#!/usr/bin/env bash
#
# run.sh — bring up the dockerify-android emulator and finish Magisk root.
#
# On google_apis_playstore (production) images `adb root` is blocked and the
# adb shell can't bootstrap Magisk over adb, so first-boot leaves Magisk patched
# with magiskd running but `su` disabled. This script completes Magisk's one-time
# "Additional Setup" automatically by driving the Magisk app UI, then verifies su.
#
# On userdebug images (default / google_apis) root is already fully set up during
# first boot; this script just confirms it.
#
# Usage: ./run.sh
set -euo pipefail

SERVICE="dockerify-android"
CONTAINER="dockerify-android"
EMU="emulator-5554"
ADB="docker exec $CONTAINER adb -s $EMU"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[!] %s\033[0m\n' "$*"; }

# ---------------------------------------------------------------------------
# 1. Start the container (builds the image on first run).
# ---------------------------------------------------------------------------
log "Starting $SERVICE ..."
docker compose up -d "$SERVICE"

# ---------------------------------------------------------------------------
# 2. Wait for first boot to finish (the marker the healthcheck also uses).
# ---------------------------------------------------------------------------
log "Waiting for first boot to complete (this can take 10-15 min on first run) ..."
until docker exec "$CONTAINER" test -f /data/.first-boot-done 2>/dev/null; do
  sleep 10
done
$ADB wait-for-device

# Wait for the Android boot to be fully completed.
until [ "$($ADB shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
  sleep 3
done

# ---------------------------------------------------------------------------
# 3. If su already works (userdebug image), we're done.
# ---------------------------------------------------------------------------
if $ADB shell su -c id 2>/dev/null | grep -q 'uid=0'; then
  log "Root already active (adb su works). Nothing else to do."
  $ADB shell magisk -c 2>/dev/null || true
  exit 0
fi

# ---------------------------------------------------------------------------
# 4. Production image: drive Magisk's "Additional Setup" via the app UI.
# ---------------------------------------------------------------------------
if ! $ADB shell 'ps -A' 2>/dev/null | grep -q magiskd; then
  warn "magiskd is not running — the ramdisk may not be patched. Aborting UI setup."
  exit 1
fi

log "Production image detected. Completing Magisk Additional Setup via the app ..."

# Tap the center of the first clickable node whose text matches $1. Returns 1 if
# no such node is currently on screen.
tap_text() {
  local label="$1" xml node nums x1 y1 x2 y2
  $ADB shell uiautomator dump /sdcard/wd.xml >/dev/null 2>&1 || return 1
  xml=$($ADB shell cat /sdcard/wd.xml 2>/dev/null | tr '>' '\n')
  node=$(printf '%s\n' "$xml" | grep -i "text=\"$label\"" | head -1) || return 1
  [ -z "$node" ] && return 1
  nums=$(echo "$node" | grep -o 'bounds="\[[0-9]*,[0-9]*\]\[[0-9]*,[0-9]*\]"' | head -1 | grep -o '[0-9]\+')
  # shellcheck disable=SC2086
  set -- $nums
  [ "$#" -ge 4 ] || return 1
  x1=$1; y1=$2; x2=$3; y2=$4
  $ADB shell input tap $(((x1 + x2) / 2)) $(((y1 + y2) / 2))
}

# Wake the screen and dismiss the keyguard so the UI is interactable.
$ADB shell input keyevent KEYCODE_WAKEUP || true
$ADB shell wm dismiss-keyguard || true
sleep 1

# Launch the Magisk app.
$ADB shell monkey -p com.topjohnwu.magisk -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1 || true
sleep 5

# The setup flow shows a dialog ("Requires Additional Setup" / then "Install").
# Tap the affirmative buttons whenever they appear, for up to ~2 minutes, until
# the device reboots (adb connection drops) or su becomes available.
for _ in $(seq 1 24); do
  if $ADB shell su -c id 2>/dev/null | grep -q 'uid=0'; then break; fi
  for label in OK Install REBOOT Reboot YES Yes; do
    tap_text "$label" >/dev/null 2>&1 && sleep 2 && break
  done
  # If the device went away (rebooting), wait for it to come back.
  $ADB wait-for-device >/dev/null 2>&1 || true
  sleep 4
done

# ---------------------------------------------------------------------------
# 5. The setup reboots the device. Wait for it and verify su.
# ---------------------------------------------------------------------------
log "Waiting for the device to settle after Magisk setup ..."
$ADB wait-for-device
until [ "$($ADB shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
  sleep 3
done

if $ADB shell su -c id 2>/dev/null | grep -q 'uid=0'; then
  log "Success — root is active."
  $ADB shell magisk -c 2>/dev/null || true
else
  warn "Could not confirm su automatically."
  warn "Finish it manually: open the Magisk app at http://localhost:8000,"
  warn "tap 'Requires Additional Setup' -> OK, let it reboot, then re-run ./run.sh."
  exit 1
fi

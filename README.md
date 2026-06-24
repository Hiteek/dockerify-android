# Dockerify Android

<img align="right" src="/doc/dockerify-android-web-preview.png" />

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker Pulls](https://img.shields.io/docker/pulls/shmayro/dockerify-android)](https://hub.docker.com/r/shmayro/dockerify-android)
[![GitHub Release](https://img.shields.io/github/v/release/shmayro/dockerify-android)](https://github.com/shmayro/dockerify-android/releases)
[![GitHub Issues](https://img.shields.io/github/issues/shmayro/dockerify-android)](https://github.com/shmayro/dockerify-android/issues)
[![GitHub Stars](https://img.shields.io/github/stars/shmayro/dockerify-android?style=social)](https://github.com/shmayro/dockerify-android/stargazers)

**Dockerify Android** is a Dockerized Android emulator supporting multiple CPU architectures (**x86** and **ARM/ARM64 apps** via ndk_translation) with native performance and seamless ADB & Web access. It allows developers to run Android virtual devices (AVDs) efficiently within Docker containers, facilitating scalable testing and development environments.

### 🔥 **Key Feature: Web Interface Access** 🌐

Access and control the Android emulator directly in your web browser with the integrated [scrcpy-web](https://github.com/Shmayro/ws-scrcpy-docker) interface! No additional software needed - just open your browser and start using Android.

> **Benefits of Web Interface:**
> - No extra software to install
> - Access from any computer with a web browser
> - Full touchscreen and keyboard support
> - Perfect for remote work or sharing the emulator with team members

<br clear="right"/>

## 🏠 **Homepage**

[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue?logo=github)](https://github.com/shmayro/dockerify-android)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-Repo-blue?logo=docker)](https://hub.docker.com/r/shmayro/dockerify-android)

## 📜 **Table of Contents**

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Usage](#-usage)
  - [Using Web Interface](#use-the-web-interface-to-access-the-emulator)
  - [Using ADB](#connect-via-adb)
  - [Using Desktop scrcpy](#use-scrcpy-to-mirror-the-emulator-screen)
  - [Customizing Device Screen](#customizing-device-screen)
- [Changing the Magisk Version](#-changing-the-magisk-version)
- [Changing the Android System Image](#-changing-the-android-system-image)
- [First Boot Process](#-first-boot-process)
- [Container Logs](#-container-logs)
- [Versioning and Releases](#-versioning-and-releases)
- [Roadmap](#-roadmap)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

## 🔧 **Features**

- **🌐 Web Interface:** Access the emulator directly from your browser with the integrated [scrcpy-web](https://github.com/Shmayro/ws-scrcpy-docker) interface.
- **🔄 ARM Translation Support:** Run ARM/ARM64 native applications on x86_64 emulator using ndk_translation layer. This allows installation of modern Android apps that ship only with ARM native libraries (arm64-v8a, armeabi-v7a).
- **Root and Magisk Preinstalled:** Comes with root access and Magisk preinstalled for advanced modifications.
- **PICO GAPPS Preinstalled:** Includes PICO GAPPS for essential Google services.
- **Seamless ADB Access:** Connect to the emulator via ADB from the host and other networked devices.
- **scrcpy Support:** Mirror the emulator screen using scrcpy for a seamless user experience.
- **Optimized Performance:** Utilizes native CPU capabilities for efficient emulation.
- **Multi-Architecture Support:** Runs natively on both **x86** and **arm64** CPU architectures.
- **Docker Integration:** Easily deploy the Android emulator within a Docker container.
- **Easy Setup:** Simple Docker commands to build and run the emulator.
- **Supervisor Management:** Manages emulator processes with Supervisor for reliability.
- **Unified Container Logs:** All emulator and boot logs are redirected to Docker's standard log system.

## 🛠️ **Prerequisites**

Before you begin, ensure you have met the following requirements:
- **Docker:** Installed on your system. [Installation Guide](https://docs.docker.com/get-docker/)
- **Docker Compose:** For managing multi-container setups. [Installation Guide](https://docs.docker.com/compose/install/)
- **KVM Support:** Ensure your system supports KVM (Kernel-based Virtual Machine) for hardware acceleration.
  - **Check KVM Support:**

    ```bash
    egrep -c '(vmx|svm)' /proc/cpuinfo
    ```

    A non-zero output indicates KVM support.

## 🚀 **Installation**

To simplify the setup process, you can use the provided [docker-compose.yml](https://github.com/Shmayro/dockerify-android/blob/main/docker-compose.yml) file.

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/shmayro/dockerify-android.git
    cd dockerify-android
    ```

2. **Run Docker Compose:**

    ```bash
    docker compose up -d
    ```

    > **Note:** This command launches the Android emulator and web interface. First boot takes some time to initialize. Once ready, the device will appear in the web interface at http://localhost:8000.

### 🚀 Quick Start (emulator only, without web interface)

If you only need ADB/scrcpy access and don't want the web interface:

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/Hiteek/dockerify-android.git
    cd dockerify-android
    ```

2. **Start only the emulator:**

    ```bash
    docker compose up -d dockerify-android
    ```

    > **Note:** The first run builds the Docker image locally (~10-15 min). Subsequent starts use the cached image and are near-instant. Once booted, connect via ADB:
    > ```bash
    > adb connect localhost:5555
    > ```


## 📡 **Usage**

### 🌐 Use the Web Interface to Access the Emulator

The **quickest and easiest way** to interact with the Android emulator is through your web browser:

1. Open your browser and go to `http://localhost:8000`
2. You should see the device listed as "dockerify-android:5555" automatically connected
3. Select one of the available streaming options:
   - **H264 Converter** (recommended for best overall experience)
   - Tiny H264 (good for low-bandwidth connections)
   - Broadway.js (fallback option)

![scrcpy-web interface](/doc/scrcpy-web-preview.png)

> **Note:** First boot may take some time as the Android emulator needs to fully initialize. When everything is ready, the device will appear in the web interface as shown in the screenshot above.

### Connect via ADB

If you need direct ADB access to the emulator:

```bash
adb connect localhost:5555
adb devices
```

**Expected Output:**

```
connected to localhost:5555
List of devices attached
localhost:5555	device
```

### Use scrcpy to Mirror the Emulator Screen

For a native desktop experience, you can use scrcpy:

```bash
scrcpy -s localhost:5555
```

> **Note:** Ensure `scrcpy` is installed on your host machine. [Installation Guide](https://github.com/Genymobile/scrcpy#installation)

## ⚙️ **Environment Variables**

| Variable | Description | Default |
| --- | --- | --- |
| `DNS` | Private DNS server used inside the emulator | `one.one.one.one` |
| `RAM_SIZE` | RAM in megabytes allocated to the emulator | `4096` |
| `SCREEN_RESOLUTION` | Screen size in `WIDTHxHEIGHT` format (e.g. `1080x1920`) | device default |
| `SCREEN_DENSITY` | Screen pixel density in DPI | device default |
| `ROOT_SETUP` | Set to `1` to enable rooting and Magisk. Can be turned on after the first start but cannot be undone without recreating the data volume. | `0` |
| `GAPPS_SETUP` | Set to `1` to install PICO GAPPS. Can be turned on after the first start but cannot be undone without recreating the data volume. | `0` |
| `ARM_TRANSLATION` | Set to `1` to enable ARM translation (ndk_translation) for running ARM/ARM64 apps on x86_64. Can be turned on after the first start but cannot be undone without recreating the data volume. | `0` |


## 🪄 **Changing the Magisk Version**

The Magisk version is pinned via the `MAGISK_VERSION` build argument in the [Dockerfile](Dockerfile) (defaults to the version shown there). During the build, the matching Magisk release APK is downloaded from the [official Magisk releases](https://github.com/topjohnwu/Magisk/releases) and used to root the emulator, overriding the one bundled with rootAVD. Because rootAVD patches the ramdisk with that APK's own `magiskboot`/`magiskinit`, any Magisk version — newer or older — works.

To switch to a different version (e.g. a newer release or an older one for compatibility):

1. **Build with the desired version** (use any tag from the [Magisk releases page](https://github.com/topjohnwu/Magisk/releases)):

    ```bash
    docker compose build --build-arg MAGISK_VERSION=v30.7 dockerify-android
    ```

    Alternatively, edit the `ARG MAGISK_VERSION=...` line in the `Dockerfile` to make it the new default.

2. **Recreate the container with a clean data volume** so the device is re-rooted with the new version:

    ```bash
    docker compose down dockerify-android
    rm -rf data/android.avd data/.first-boot-done data/.root-done
    docker compose up -d dockerify-android
    ```

    > **Important:** Magisk is only installed during the first-boot rooting step, which is guarded by the `data/.root-done` marker. If you change `MAGISK_VERSION` but keep an already-rooted `data/` volume, the device will **keep the old Magisk version** (and the Magisk app may show the daemon as `N/A` due to an app/daemon version mismatch). Removing the markers above forces a fresh root with the new version.

3. **Verify the running version** once the emulator has booted:

    ```bash
    adb connect localhost:5555
    adb shell magisk -c    # prints e.g. 30.7:MAGISK:R (30700)
    ```


## 📱 **Changing the Android System Image**

The Android version that runs inside the emulator is selected at build time via three build arguments in the [Dockerfile](Dockerfile):

| Build arg | Description | Example values |
| --- | --- | --- |
| `ANDROID_API` | Android API level | `30` (Android 11), `33` (Android 13), `34` (Android 14) |
| `ANDROID_TAG` | System image variant | `default`, `google_apis`, `google_apis_playstore` |
| `ANDROID_ABI` | CPU ABI | `x86_64` |

These produce the SDK image id `system-images;android-${ANDROID_API};${ANDROID_TAG};${ANDROID_ABI}`, which is downloaded during the build and used to create the AVD and patch the ramdisk for root.

### Variant compatibility (important)

| Variant | Google services | Rootable? | How root works |
| --- | --- | --- | --- |
| `default` | None (AOSP) | ✅ Yes | `adb root` (userdebug build) |
| `google_apis` | GMS, no Play Store | ✅ Yes | `adb root` (userdebug build) |
| `google_apis_playstore` | GMS + Play Store | ⚠️ Partial | **Production build** (`ro.debuggable=0`): `adb root` is blocked. The ramdisk is still patched and `magiskd` runs, but enabling `su` needs a **one-time manual step** (see below). **Play Integrity will fail** — use the integrity modules in `extras/` to mitigate. |

> **Feature constraints:** `GAPPS_SETUP` (PICO GAPPS) and `ARM_TRANSLATION` (ndk_translation) only apply to **API 30 / x86_64**. For other API levels keep both at `0`. A `google_apis*` variant already provides Google services, so GAPPS is unnecessary there.

> **Root on Play Store images (one-time setup):** On a `google_apis_playstore` image, production policy blocks `adb root`, so first boot leaves Magisk patched (`magiskd` running) but `su` disabled until Magisk's **"Additional Setup"** runs once. Use the helper script, which starts the container and drives that setup for you:
>
> ```bash
> ./run.sh
> ```
>
> If you prefer to do it by hand: open the **Magisk app** in the web UI (http://localhost:8000) → tap **"Requires Additional Setup"** → **OK** → let the device reboot. After that, `adb shell su` and root-requiring apps work. If you want **fully automated** root with no extra step, use `ANDROID_TAG=google_apis` (includes Google services, `adb root` works) instead.

### How to switch

1. **Build with the desired image:**

    ```bash
    docker compose build \
      --build-arg ANDROID_API=34 \
      --build-arg ANDROID_TAG=google_apis_playstore \
      dockerify-android
    ```

    Or edit the `ARG ANDROID_API=...` / `ANDROID_TAG=...` defaults in the `Dockerfile` (and the matching `args:` block in `docker-compose.yml`).

2. **Recreate the container with a clean data volume** (the AVD and root are tied to the image, so the old `data/` must be discarded):

    ```bash
    docker compose down dockerify-android
    rm -rf data/android.avd data/.first-boot-done data/.root-done data/.arm-translation-done data/.gapps-done
    docker compose up -d dockerify-android
    ```

3. **Verify** once booted (first boot is longer because it re-roots the new image):

    ```bash
    adb connect localhost:5555
    adb shell getprop ro.build.version.sdk      # e.g. 34
    adb shell pm list packages | grep vending    # com.android.vending → Play Store present
    adb shell ps -A | grep magiskd               # magiskd running → Magisk is active
    adb shell su -c id                           # uid=0 → root (Play Store: after the one-time setup above)
    ```


## 🔄 **First Boot Process**

The first time you start the container, it will perform a comprehensive setup process that includes:

1. **AVD Creation:** Creates a new Android Virtual Device running Android 30 (Android 11)
2. **PICO GAPPS Installation** (when `GAPPS_SETUP=1`): Adds essential Google services.
3. **Rooting the Device** (when `ROOT_SETUP=1`): Performs multiple reboots to:
   - Disable AVB verification
   - Remount system as writable
   - Install Magisk for root access
   - Reboot to apply root
4. **ARM Translation Installation** (when `ARM_TRANSLATION=1`): Installs ndk_translation ARM translation layer to enable running ARM/ARM64 native apps on x86_64:
   - Installs ndk_translation for both ARM32 (armeabi-v7a) and ARM64 (arm64-v8a) support
   - Updates system properties to advertise ARM ABI support
   - Configures native bridge for transparent ARM-to-x86 translation
   - After installation, the device will report `ro.product.cpu.abilist = x86_64,x86,arm64-v8a,armeabi-v7a,armeabi`
5. **Extras Copied:** Pushes everything from the `extras` directory to `/sdcard/Download` so files like APKs or Magisk modules are ready for manual installation on the device.
6. **Configuring optimal device settings**

`ROOT_SETUP`, `GAPPS_SETUP`, and `ARM_TRANSLATION` are checked on every start. If you enable them after the first boot, the script installs the requested components once and marks them complete so they won't run again. Removing them later requires recreating the data volume.

> **Important:** The first boot can take 10-15 minutes to complete. You'll know the process is finished when you see the following log output:
> ```
> Broadcast completed: result=0
> Success !!
> 2025-04-22 13:45:18,724 INFO exited: first-boot (exit status 0; expected)
> ```

> **Note:** If the Android emulator has restarted for any reason, it's recommended to restart the Docker container to reapply optimizations:
> ```bash
> docker compose restart
> ```
> This ensures the following optimizations are applied:
> - Disabled animations for better performance
> - Screen timeout set to 15 seconds
> - Disabled rotation
> - Custom DNS settings
> - Airplane mode enabled (with WiFi still active)
> - Data connection disabled

After the first boot completes, a file marker is created to prevent running the initialization again on subsequent starts.

## 📋 **Container Logs**

All logs from the emulator and boot processes are redirected to Docker's standard log system. To view all container logs:

```bash
docker logs -f dockerify-android
```

This includes:
- Supervisor logs
- Android emulator stdout/stderr
- First-boot process logs

## 🏷️ **Versioning and Releases**

Dockerify Android uses GitHub Releases as the source of truth for stable project versions. Publishing a release such as `v1.2.3` creates matching Docker image tags: `1.2.3`, `1.2`, `1`, and `latest`.

Builds from the `main` branch are published as development images using `edge` and `sha-<short-sha>` tags.

## 🚧 **Roadmap**

- [ ] Support for additional Android versions
- [x] Integration with CI/CD pipelines
- [x] ARM Translation support (ndk_translation) for running ARM64 apps on x86_64
- [x] PICO GAPPS installation
- [x] Support Magisk
- [x] Adding web interface of [scrcpy](https://github.com/Shmayro/ws-scrcpy-docker)
- [x] Redirect all logs to container stdout/stderr

## 🐞 **Troubleshooting**

- **ADB Connection Refused:**
  - **Ensure ADB Server is Running:**
    ```bash
    adb start-server -a
    ```
  - **Verify Firewall Settings:** Ensure that port `5555` is open on your server.
  - **Check Emulator Status:** Ensure the emulator has fully booted by checking logs.

    ```bash
    docker logs dockerify-android
    ```

- **First Boot Taking Too Long:**
  - This is normal, as the first boot process needs to perform several operations including:
    - Installing GAPPS (if enabled)
    - Rooting the device (if enabled)
    - Installing ARM Translation (if enabled)
    - Configuring system settings
  - The process can take 10-15 minutes depending on your system performance
  - You can monitor progress with `docker logs -f dockerify-android`

- **ARM/ARM64 Apps Still Not Installing:**
  - Ensure `ARM_TRANSLATION=1` is set in your docker-compose.yml or environment variables
  - Check that the first boot completed successfully with `docker logs dockerify-android | grep -i "ARM translation"`
  - Verify ARM ABIs are available:
    ```bash
    adb shell getprop ro.product.cpu.abilist
    ```
    Should show: `x86_64,x86,arm64-v8a,armeabi-v7a,armeabi`
  - If you enabled `ARM_TRANSLATION` after the first boot, restart the container to run the install step

- **Emulator Not Starting:**
  - **Check Container Logs:**

    ```bash
    docker logs dockerify-android
    ```

- **KVM Not Accessible:**
  - **Verify KVM Installation:**

    ```bash
    lsmod | grep kvm
    ```
  - **Check Permissions:** Ensure your user has access to `/dev/kvm`.

## 🤝 **Contributing**

Contributions are welcome! To contribute:

1. **Fork the Repository**
2. **Create a Feature Branch:**

    ```bash
    git checkout -b feature/YourFeature
    ```

3. **Commit Your Changes:**

    ```bash
    git commit -m "Add Your Feature"
    ```

4. **Push to the Branch:**

    ```bash
    git push origin feature/YourFeature
    ```

5. **Open a Pull Request**

Please ensure your contributions adhere to the project's coding standards and include relevant tests.

## 📄 **License**

This project is licensed under the [MIT License](LICENSE).

## 📫 **Contact**

- **Haroun EL ALAMI**
- **Email:** haroun.dev@gmail.com
- **GitHub:** [shmayro](https://github.com/shmayro)
- **Twitter:** [@HarounDev](https://twitter.com/HarounDev)

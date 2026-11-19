# DEROX OS 2.0 lightweight ISO profile

## Goal

Keep the first installable x86_64 ISO as small as practical without sacrificing boot reliability, installation safety, or the promised core hardware functions. This is a build policy, not a claim that an ISO has already been produced.

## Keep in Beta 1

- Linux kernel and essential storage/filesystem drivers.
- systemd, essential libraries, shell, core utilities, device management.
- GRUB for supported BIOS and UEFI boot paths.
- XFCE desktop and a lightweight display manager.
- NetworkManager plus firmware needed for common Wi-Fi adapters.
- ALSA, PipeWire, and WirePlumber for speakers, headphones, and microphones.
- Live environment, guided installer, recovery tools, and DEROX branding/wallpaper.
- English, Arabic, and French locale support where available without disproportionate size cost.

## Exclude from the first ISO

- Development toolchains, compilers, headers, source trees, and build caches.
- Debug-symbol packages and unneeded documentation/manpages in the live image (keep build logs and symbols outside the ISO for diagnosis).
- Large optional applications, games, duplicate utilities, and multiple applications with the same purpose.
- Printer/scanner, specialist, and uncommon hardware firmware unless required by test hardware; allow later installation.
- Extra themes, icon packs, fonts, translations, and sample media not needed for the first release.

Do not remove essential shared libraries, firmware, storage drivers, installer dependencies, or recovery utilities just to hit a size number.

## Image construction and compression

1. Build a minimal target root filesystem from verified upstream source archives.
2. Install only the runtime packages selected for the Beta 1 profile; never copy the compiler/toolchain into the target.
3. Remove package caches, temporary build files, and unneeded static archives from the target rootfs.
4. Keep debug symbols and full build logs in CI artifacts, not in the release filesystem.
5. Create a read-only SquashFS live root. Prefer XZ compression for the smallest release image; benchmark Zstandard as a faster-build/boot alternative before choosing.
6. Build the ISO with GRUB BIOS/UEFI support and the installer/recovery assets.
7. Record compressed ISO size, uncompressed rootfs size, package/source inventory, and SHA-256 checksum for each release candidate.

## Size target

Aim for a first Beta 1 ISO below 2 GiB, but treat this as a target rather than a promise. The actual size depends on kernel drivers, Wi-Fi firmware coverage, XFCE dependencies, and installer/recovery requirements. Do not weaken the required feature set or publish an untested image to meet the target.

## Validation

A size-reduced image is accepted only if it still:
- boots in BIOS and UEFI virtual machines;
- reaches the XFCE live session;
- detects the virtual disk and installs safely to a blank VM disk;
- boots from the installed disk;
- supports network connectivity and audio playback/capture in the documented test environment;
- passes the recovery and checksum checks.

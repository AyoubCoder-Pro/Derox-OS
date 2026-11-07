#!/usr/bin/env bash
set -Eeuo pipefail

# DEROX OS 1.0 live image: Debian 12 + XFCE4.
lb config \
  --distribution bookworm \
  --mirror-bootstrap "http://deb.debian.org/debian/" \
  --mirror-chroot "http://deb.debian.org/debian/" \
  --mirror-chroot-security "http://security.debian.org/debian-security/" \
  --mirror-binary "http://deb.debian.org/debian/" \
  --mirror-binary-security "http://security.debian.org/debian-security/" \
  --archive-areas "main contrib non-free-firmware" \
  --binary-images iso-hybrid \
  --bootappend-live "boot=live components username=derox hostname=derox-os locales=en_US.UTF-8 keyboard-layouts=us" \
  --debian-installer none \
  --iso-application "DEROX OS 1.0" \
  --iso-volume "DEROX_OS_1.0" \
  --apt-recommends true

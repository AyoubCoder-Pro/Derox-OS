#!/usr/bin/env bash
set -Eeuo pipefail

# AYOUB OS live image: lightweight Debian 12 + XFCE.
lb config \
  --distribution bookworm \
  --archive-areas "main contrib non-free-firmware" \
  --binary-images iso-hybrid \
  --bootappend-live "boot=live components username=ayoub hostname=ayoub-os locales=en_US.UTF-8 keyboard-layouts=us" \
  --debian-installer none \
  --iso-application "AYOUB OS" \
  --iso-volume "AYOUB_OS" \
  --apt-recommends true

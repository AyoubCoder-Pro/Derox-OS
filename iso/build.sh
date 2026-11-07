#!/usr/bin/env bash
set -Eeuo pipefail

# DEROX OS live image: Debian 12 + XFCE4.
# Embed the repository release version in the installed system.
version_file="../VERSION"
if [[ -f "$version_file" ]]; then
  install -D -m 0644 "$version_file" config/includes.chroot/etc/derox-version
else
  echo "Missing ../VERSION" >&2
  exit 1
fi

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
  --debian-installer live \
  --iso-application "DEROX OS" \
  --iso-volume "DEROX_OS" \
  --apt-recommends true

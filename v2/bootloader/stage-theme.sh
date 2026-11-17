#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  echo "Usage: $0 TARGET_ROOTFS BOOTLOADER_IMAGE" >&2
}

if [[ $# -ne 2 ]]; then
  usage
  exit 2
fi

rootfs=$1
image=$2
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

[[ -d "$rootfs" ]] || { echo "ERROR: target rootfs does not exist: $rootfs" >&2; exit 1; }
[[ -f "$image" ]] || { echo "ERROR: bootloader image not found: $image" >&2; exit 1; }
command -v grub-mkstandalone >/dev/null 2>&1 || {
  echo "ERROR: grub-mkstandalone is required on the build host." >&2
  exit 1
}

theme_dir="$rootfs/boot/grub/themes/derox"
install -d "$theme_dir"
install -m 0644 "$script_dir/theme.txt" "$theme_dir/theme.txt"
install -m 0644 "$image" "$theme_dir/derox-2.0-bootloader.png"

echo "DEROX GRUB theme staged at $theme_dir"
echo "The ISO builder must set GRUB_THEME=/boot/grub/themes/derox/theme.txt"
echo "and include the matching GRUB video, PNG, font, and theme modules."

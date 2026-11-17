#!/usr/bin/env bash
# Build an x86_64 Linux kernel into a target rootfs without modifying the host.
set -Eeuo pipefail

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$(id -u)" -ne 0 ]] || fail "run as an unprivileged build user, not root"
[[ "$#" -ge 3 && "$#" -le 4 ]] || fail "usage: build-kernel.sh KERNEL_SOURCE BUILD_DIR TARGET_ROOTFS [CONFIG_FRAGMENT]"

KERNEL_SRC="$(cd -- "$1" 2>/dev/null && pwd -P)" || fail "kernel source directory does not exist"
mkdir -p -- "$2"
BUILD_DIR="$(cd -- "$2" && pwd -P)"
mkdir -p -- "$3"
ROOTFS="$(cd -- "$3" && pwd -P)"
CONFIG_FRAGMENT="${4:-}"
[[ -f "$KERNEL_SRC/Makefile" ]] || fail "kernel source Makefile is missing"
[[ "$ROOTFS" != "/" ]] || fail "target rootfs must not be /"
[[ "$BUILD_DIR" != "$KERNEL_SRC" ]] || fail "use a separate out-of-tree kernel build directory"
if [[ -n "$CONFIG_FRAGMENT" ]]; then
  [[ -f "$CONFIG_FRAGMENT" ]] || fail "config fragment does not exist"
  CONFIG_FRAGMENT="$(cd -- "$(dirname -- "$CONFIG_FRAGMENT")" && pwd -P)/$(basename -- "$CONFIG_FRAGMENT")"
fi

for tool in make gcc cp install mkdir; do
  command -v "$tool" >/dev/null 2>&1 || fail "required command not found: $tool"
done

JOBS="${DEROX_BUILD_JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)}"
[[ "$JOBS" =~ ^[1-9][0-9]*$ ]] || fail "DEROX_BUILD_JOBS must be a positive integer"
export ARCH=x86_64
MAKE=(make -C "$KERNEL_SRC" O="$BUILD_DIR" ARCH=x86_64)

if [[ ! -f "$BUILD_DIR/.config" ]]; then
  "${MAKE[@]}" x86_64_defconfig
fi
if [[ -n "$CONFIG_FRAGMENT" ]]; then
  [[ -x "$KERNEL_SRC/scripts/kconfig/merge_config.sh" ]] || fail "kernel merge_config.sh is missing"
  "$KERNEL_SRC/scripts/kconfig/merge_config.sh" -m -O "$BUILD_DIR" "$BUILD_DIR/.config" "$CONFIG_FRAGMENT"
fi
"${MAKE[@]}" olddefconfig
KERNEL_RELEASE="$("${MAKE[@]}" -s kernelrelease)"
[[ "$KERNEL_RELEASE" =~ ^[A-Za-z0-9._+-]+$ ]] || fail "kernelrelease returned an unsafe value"

"${MAKE[@]}" -j"$JOBS" bzImage modules
"${MAKE[@]}" modules_install INSTALL_MOD_PATH="$ROOTFS" DEPMOD=true
IMAGE="$BUILD_DIR/arch/x86/boot/bzImage"
[[ -s "$IMAGE" ]] || fail "kernel build did not produce arch/x86/boot/bzImage"

install -d "$ROOTFS/boot"
install -m 0644 "$IMAGE" "$ROOTFS/boot/vmlinuz-$KERNEL_RELEASE"
if [[ -f "$BUILD_DIR/System.map" ]]; then
  install -m 0644 "$BUILD_DIR/System.map" "$ROOTFS/boot/System.map-$KERNEL_RELEASE"
fi
install -m 0644 "$BUILD_DIR/.config" "$ROOTFS/boot/config-$KERNEL_RELEASE"
printf 'Kernel staged successfully: %s\n' "$KERNEL_RELEASE"
printf 'Target rootfs: %s\n' "$ROOTFS"
printf 'Note: this does not create an initramfs, bootloader config, or ISO.\n'

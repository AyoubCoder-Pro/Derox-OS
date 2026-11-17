#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/src" "$TMP/bin" "$TMP/rootfs"
: > "$TMP/src/Makefile"
cat > "$TMP/bin/make" <<'MOCK'
#!/usr/bin/env bash
set -eu
out=""
for arg in "$@"; do
  case "$arg" in O=*) out="${arg#O=}";; esac
done
last="${!#}"
case "$last" in
  x86_64_defconfig)
    mkdir -p "$out"
    printf 'CONFIG_64BIT=y\n' > "$out/.config"
    ;;
  olddefconfig) : ;;
  kernelrelease) printf '7.1.8-derox-test\n' ;;
  bzImage)
    mkdir -p "$out/arch/x86/boot"
    printf 'fake-kernel-image\n' > "$out/arch/x86/boot/bzImage"
    printf 'fake-system-map\n' > "$out/System.map"
    ;;
  modules) : ;;
  modules_install)
    mkdir -p "${INSTALL_MOD_PATH:?}/lib/modules/7.1.8-derox-test"
    printf 'fake-module\n' > "${INSTALL_MOD_PATH}/lib/modules/7.1.8-derox-test/test.ko"
    ;;
  *) echo "unexpected make target: $last" >&2; exit 9 ;;
esac
MOCK
chmod +x "$TMP/bin/make"
PATH="$TMP/bin:$PATH" DEROX_BUILD_JOBS=2 bash "$ROOT/v2/kernel/build-kernel.sh" "$TMP/src" "$TMP/build" "$TMP/rootfs"
test -s "$TMP/rootfs/boot/vmlinuz-7.1.8-derox-test"
test -s "$TMP/rootfs/boot/System.map-7.1.8-derox-test"
test -s "$TMP/rootfs/boot/config-7.1.8-derox-test"
test -s "$TMP/rootfs/lib/modules/7.1.8-derox-test/test.ko"
if PATH="$TMP/bin:$PATH" bash "$ROOT/v2/kernel/build-kernel.sh" "$TMP/src" "$TMP/build2" / >/dev/null 2>&1; then
  echo "ERROR: rootfs / was accepted" >&2
  exit 1
fi
echo "PASS: kernel build staging helper tests"

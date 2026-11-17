#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

mkdir -p "$tmp/bin" "$tmp/rootfs"
cat > "$tmp/bin/grub-mkstandalone" <<'STUB'
#!/usr/bin/env sh
exit 0
STUB
chmod +x "$tmp/bin/grub-mkstandalone"
printf 'fake-png-payload\n' > "$tmp/bootloader.png"

PATH="$tmp/bin:$PATH" bash "$repo_root/v2/bootloader/stage-theme.sh" "$tmp/rootfs" "$tmp/bootloader.png"

theme_dir="$tmp/rootfs/boot/grub/themes/derox"
[[ -f "$theme_dir/theme.txt" ]] || fail "theme.txt was not installed"
[[ -f "$theme_dir/derox-2.0-bootloader.png" ]] || fail "bootloader image was not installed"
cmp -s "$repo_root/v2/bootloader/theme.txt" "$theme_dir/theme.txt" || fail "installed theme differs from source"
cmp -s "$tmp/bootloader.png" "$theme_dir/derox-2.0-bootloader.png" || fail "installed image differs from input"

if PATH="$tmp/bin:$PATH" bash "$repo_root/v2/bootloader/stage-theme.sh" >/dev/null 2>&1; then
  fail "script accepted missing arguments"
fi
if PATH="$tmp/bin:$PATH" bash "$repo_root/v2/bootloader/stage-theme.sh" "$tmp/missing-root" "$tmp/bootloader.png" >/dev/null 2>&1; then
  fail "script accepted a missing target rootfs"
fi
if PATH="$tmp/bin:$PATH" bash "$repo_root/v2/bootloader/stage-theme.sh" "$tmp/rootfs" "$tmp/missing.png" >/dev/null 2>&1; then
  fail "script accepted a missing image"
fi

echo "PASS: GRUB theme staging copies assets and rejects invalid inputs"

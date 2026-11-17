#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
TEMP_ROOT=$(mktemp -d)
trap 'rm -rf "$TEMP_ROOT"' EXIT

mkdir -p "$TEMP_ROOT"
bash "$REPO_ROOT/v2/wallpapers/install-default.sh" "$TEMP_ROOT"

WALLPAPER="$TEMP_ROOT/usr/share/backgrounds/derox/derox-2.0-default.svg"
CONFIG="$TEMP_ROOT/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"

test -s "$WALLPAPER"
test -s "$CONFIG"
grep -Fq '/usr/share/backgrounds/derox/derox-2.0-default.svg' "$CONFIG"
grep -Fq '<property name="image-show" type="bool" value="true"/>' "$CONFIG"

if bash "$REPO_ROOT/v2/wallpapers/install-default.sh" >/dev/null 2>&1; then
  echo "Expected missing-argument invocation to fail" >&2
  exit 1
fi

echo "Wallpaper integration tests passed."

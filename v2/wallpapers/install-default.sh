#!/usr/bin/env bash
set -euo pipefail

# Install DEROX OS 2.0's default wallpaper and XFCE defaults into a target rootfs.
# Usage: bash v2/wallpapers/install-default.sh /path/to/target-rootfs

if [[ $# -ne 1 || -z "$1" ]]; then
  echo "Usage: $0 TARGET_ROOTFS" >&2
  exit 2
fi

ROOTFS=$(realpath -m "$1")
if [[ "$ROOTFS" == "/" || ! -d "$ROOTFS" ]]; then
  echo "Error: TARGET_ROOTFS must be an existing directory other than /." >&2
  exit 2
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SOURCE_WALLPAPER="$SCRIPT_DIR/derox-2.0-default.svg"
DEST_DIR="$ROOTFS/usr/share/backgrounds/derox"
CONFIG_DIR="$ROOTFS/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml"

if [[ ! -s "$SOURCE_WALLPAPER" ]]; then
  echo "Error: default wallpaper is missing or empty: $SOURCE_WALLPAPER" >&2
  exit 1
fi

install -D -m 0644 "$SOURCE_WALLPAPER" "$DEST_DIR/derox-2.0-default.svg"
install -d -m 0755 "$CONFIG_DIR"
cat > "$CONFIG_DIR/xfce4-desktop.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/derox/derox-2.0-default.svg"/>
          <property name="image-style" type="int" value="5"/>
          <property name="image-show" type="bool" value="true"/>
        </property>
      </property>
    </property>
  </property>
</channel>
XML

chmod 0644 "$CONFIG_DIR/xfce4-desktop.xml"
echo "Installed DEROX OS 2.0 wallpaper and XFCE default for new users into: $ROOTFS"

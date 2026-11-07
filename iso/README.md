# DEROX OS 1.0 ISO

DEROX OS is an independent Debian 12 (Bookworm) live-image project using XFCE4.
It is not a separate Linux kernel or an official Debian release.

## Build the ISO

The supported build path is GitHub Actions:

1. Open the repository's **Actions** tab.
2. Select **Build DEROX OS 1.0 ISO**.
3. Choose **Run workflow**.
4. Wait for the build job to finish.
5. Download the `derox-os-iso` artifact from the completed run.

The artifact contains a bootable hybrid ISO and a SHA-256 checksum file.
The workflow is also triggered when files under `iso/` change.

## Included

- Debian 12 Bookworm base
- XFCE4 desktop
- LightDM login manager
- NetworkManager
- Firefox ESR
- Common terminal tools
- DEROX OS branding and the `derox` system-information command

## Before installing

First boot the ISO in a virtual machine or use the live session without installing.
Back up important files before installing any operating system. Creating a bootable
USB erases the USB drive. The live image is amd64/x86_64 and is not intended for
32-bit-only computers.

## Hardware note

XFCE4 is selected to keep the desktop relatively light, but actual performance
depends on the computer's CPU, graphics, storage, and drivers. A 4 GB RAM system
may run it, but this has not yet been tested on every device.

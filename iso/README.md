# AYOUB OS ISO

AYOUB OS is a personal Debian 12 (Bookworm) live-image project using XFCE.
It is not a separate Linux kernel or an official Debian distribution.

## Build the ISO

The supported first build path is GitHub Actions:

1. Open the repository's **Actions** tab.
2. Select **Build AYOUB OS ISO**.
3. Choose **Run workflow**.
4. Wait for the build job to finish.
5. Download the `ayoub-os-iso` artifact from the completed run.

The artifact contains a bootable hybrid ISO and a SHA-256 checksum file.
The workflow is also triggered when files under `iso/` change.

## Included

- Debian 12 Bookworm base
- XFCE desktop
- LightDM login manager
- NetworkManager
- Firefox ESR
- Common terminal tools
- AYOUB OS logo and `ayoub` system-information command

## Before installing

First boot the ISO in a virtual machine or use the live session without installing.
Back up important files before installing any operating system. Installing to a disk
can erase existing data. The live image is amd64/x86_64 and is not intended for
32-bit-only computers.

## Hardware note

XFCE is selected to keep the desktop relatively light, but actual performance
depends on the computer's CPU, graphics, storage, and drivers. A 4 GB RAM system
may run it, but this has not yet been tested on every device.

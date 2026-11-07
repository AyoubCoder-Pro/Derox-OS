# DEROX OS 1.0

**A Linux distribution for everyone.**

DEROX OS is an independent Debian-based live Linux project, built around Debian 12 (Bookworm) and the XFCE4 desktop. Version 1.0 is the first development release of the DEROX identity and live system.

> DEROX OS is an independent community project and is not affiliated with or endorsed by the Debian project.

## Version 1.0

- Debian 12 Bookworm base
- XFCE4 desktop environment
- amd64 / x86_64 hybrid live ISO
- LightDM login manager
- NetworkManager for network connections
- Firefox ESR and useful system tools
- DEROX OS welcome branding and `derox` terminal command

## Build and download

The ISO is built with GitHub Actions:

1. Open the repository's **Actions** tab.
2. Select **Build DEROX OS 1.0 ISO**.
3. Run the workflow, or open the latest successful run.
4. Download the `derox-os-iso` artifact and extract the ZIP file.
5. Verify the ISO with the included SHA-256 checksum file.

## Try it safely

Test the live ISO in a virtual machine or boot it as a live USB before considering installation. Creating a bootable USB erases the USB drive, so back up its files first. The current image is a live system; it is not yet a full disk installer.

The ISO targets 64-bit (amd64) PCs. Hardware compatibility and performance still need testing on a range of computers.

## Project status

DEROX OS 1.0 is an initial release candidate for testing and feedback, not a claim of production-grade stability. Please report bugs and hardware compatibility results through GitHub Issues.

## License

MIT

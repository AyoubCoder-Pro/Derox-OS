# DEROX 2.0 build status

**Status: preparation plus tested rootfs staging helpers — no bootable image.**

| Gate | Status | Evidence required to close |
|---|---|---|
| Architecture and build plan | Complete | Reviewed design documents |
| Source-lock schema and validator | Complete | Passing unit tests and CI |
| Host preflight checker | Complete | Shell syntax check in CI |
| Default wallpaper rootfs integration | Implemented; CI passed | CI verifies SVG installation and XFCE defaults for new users |
| GRUB bootloader theme | Theme staging helper and automated tests passed; image asset pending | Commit PNG artwork, generate GRUB config, build ISO, and boot-test UEFI/BIOS |
| DEROX OS identity files | Implemented; CI test added | Stage and test os-release, issue, hostname, MOTD, and release metadata in target rootfs |\n| Verified source inventory | Blocked | Non-empty lock with independently checked upstream SHA-256 values |
| Temporary toolchain recipes | Not started | Reviewed recipes and reproducible logs |
| Base system | Not started | Successful clean build |
| Minimal boot | Not started | QEMU/VirtualBox boot log and test record |
| Networking and firmware | Not started | Hardware/VM connectivity tests |
| Speakers and microphones | Design documented | Built ALSA/PipeWire/WirePlumber stack; playback, capture, device-switching, and physical-hardware test logs |
| XFCE desktop | Not started | Successful graphical login test |
| DEROX package manager | Design only | Signature verification and install/remove/upgrade tests |
| Live ISO and installer | Not started | Reproducible image plus install/recovery tests |

The GRUB staging test passed in GitHub Actions run 44137357644. The identity staging test has been added to CI and is awaiting its run. Do not mark a gate complete because files exist. Mark it complete only after its evidence is committed and reviewed.

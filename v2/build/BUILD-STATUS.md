# DEROX 2.0 build status

**Status: preparation only — no bootable image.**

| Gate | Status | Evidence required to close |
|---|---|---|
| Architecture and build plan | Complete | Reviewed design documents |
| Source-lock schema and validator | Complete | Passing unit tests and CI |
| Host preflight checker | Complete | Shell syntax check in CI |
| Default wallpaper rootfs integration | Implemented; CI pending | Installer copies the SVG and configures XFCE defaults for new users |
| Verified source inventory | Blocked | Non-empty lock with independently checked upstream SHA-256 values |
| Temporary toolchain recipes | Not started | Reviewed recipes and reproducible logs |
| Base system | Not started | Successful clean build |
| Minimal boot | Not started | QEMU/VirtualBox boot log and test record |
| Networking and firmware | Not started | Hardware/VM connectivity tests |
| Speakers and microphones | Design documented | Built ALSA/PipeWire/WirePlumber stack; playback, capture, device-switching, and physical-hardware test logs |
| XFCE desktop | Not started | Successful graphical login test |
| DEROX package manager | Design only | Signature verification and install/remove/upgrade tests |
| Live ISO and installer | Not started | Reproducible image plus install/recovery tests |

Do not mark a gate complete because files exist. Mark it complete only after its evidence is committed and reviewed.

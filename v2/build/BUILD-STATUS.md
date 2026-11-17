# DEROX 2.0 build status

**Status: preparation plus tested staging/build helpers — no bootable image.**

| Gate | Status | Evidence required to close |
|---|---|---|
| Architecture and build plan | Complete | Reviewed design documents |
| Source-lock schema and validator | Complete | Passing unit tests and CI |
| Host preflight checker | Complete | Shell syntax check in CI |
| Default wallpaper rootfs integration | Implemented; CI passed | SVG and XFCE defaults staged into a test rootfs |
| GRUB bootloader theme | Staging helper and tests implemented; artwork pending | Commit PNG artwork, generate GRUB config, build ISO, and boot-test UEFI/BIOS |
| DEROX OS identity files | Implemented; CI test added | Stage os-release, issue, hostname, MOTD, and release metadata |
| Kernel build/staging helper | Implemented; mock test passed in CI | Pin and verify official kernel source, perform real compilation, stage modules, and boot-test |\n| Initramfs archive helper | Implemented; CI test added | Build archive from a real early-boot rootfs and verify it boots with the kernel |
| Verified source inventory | Blocked | Non-empty lock with independently checked upstream SHA-256 values |
| Toolchain readiness gate | Implemented; build blocked | Verified source lock, reviewed recipes, and reproducible compiler logs |
| Base system | Not started | Successful clean build |
| Minimal boot | Not started | QEMU/VirtualBox boot log and test record |
| Networking and firmware | Not started | VM and physical-hardware connectivity tests |
| Speakers and microphones | Design documented | Build ALSA/PipeWire/WirePlumber; test playback, capture, and device switching |
| XFCE desktop | Not started | Successful graphical login test |
| DEROX package manager | Design only | Signature verification and install/remove/upgrade tests |
| Live ISO and installer | Not started | Reproducible image plus install/recovery tests |

The kernel helper builds an x86_64 `bzImage` and modules from an already verified, extracted source tree, then stages them under a target rootfs. It refuses root execution and never runs `make install` against the host. Its automated test uses a mock `make`; it does not prove that a real kernel has compiled.

The source lock remains intentionally empty. No source download, toolchain build, kernel compilation, root filesystem, or ISO is claimed complete.
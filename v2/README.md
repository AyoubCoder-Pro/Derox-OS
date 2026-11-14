# DEROX OS 2.0

**An independent Linux distribution built from source.**

DEROX OS 2.0 is a new development track. It does not use Debian, Ubuntu, Arch, Fedora, or another distribution as its runtime base. The intended foundation is a Linux From Scratch (LFS) system assembled from upstream source code, with a separately maintained DEROX package ecosystem.

> Status: early architecture and planning. This directory is not yet a bootable operating system, and no 2.0 ISO is available.

## Goals

- Build the base userland from upstream source code using a reproducible toolchain.
- Use the upstream Linux kernel.
- Provide an XFCE desktop session.
- Develop the DEROX package format, signed repository metadata, and package manager. The first manifest schema and read-only validator are now in `package/` and `tools/`.
- Ship a branded default wallpaper and consistent desktop identity.
- Keep all 1.0 Debian-based build files and releases unchanged.

## Current design

- Base: Linux From Scratch, with Beyond Linux From Scratch components selected individually.
- Init/service management: systemd (subject to the first bootable prototype).
- Desktop: XFCE.
- Package manager: a new DEROX implementation; package format and security requirements are specified in [APP-MANAGER.md](APP-MANAGER.md).
- Architecture target: x86_64 (amd64).

## Development stages

See [ROADMAP.md](ROADMAP.md) and [ARCHITECTURE.md](ARCHITECTURE.md).

Nothing in this folder should be described as a completed or installable release until the build, boot, package-installation, upgrade, and recovery tests pass.

# DEROX OS 2.0 roadmap — installation-first plan

The immediate goal is a **bootable and installable x86_64 beta ISO**. Do not spend time polishing secondary features before a minimal installable system exists.

## Release target: DEROX 2.0 Beta 1

The first beta is allowed to have a smaller feature set than the final vision, but it must be real, reproducible, and honestly tested.

### Critical path (do these in order)

- [x] Keep 2.0 isolated on `derox-2.0`; preserve the Debian-based 1.0 branch.
- [x] Define an independent Linux From Scratch build architecture and pin the LFS systemd 13.1 reference.
- [x] Add source-lock validation, HTTPS source fetching, SHA-256 enforcement, and build gates.
- [x] Add rootfs directory skeleton, OS identity, wallpaper, kernel staging, and initramfs staging helpers with CI tests.
- [ ] Lock the minimal set of base-system sources with independently verified upstream SHA-256/signatures.
- [ ] Implement executable, reproducible bootstrap-toolchain recipes.
- [ ] Build the minimal x86_64 base system (systemd, shell, core utilities, device management, essential libraries).
- [ ] Produce a first minimal boot image and boot it in QEMU/VirtualBox.
- [ ] Add storage discovery, initramfs integration, GRUB BIOS/UEFI configuration, and recovery path.
- [ ] Add networking and firmware needed for the target hardware.
- [ ] Add XFCE, display manager, fonts, DEROX wallpaper, and desktop defaults.
- [ ] Add audio (ALSA + PipeWire + WirePlumber) and verify speaker, headphone, and microphone support.
- [ ] Create a live session and a safe guided installer with disk selection and clear destructive-action confirmation.
- [ ] Build the installable ISO and test install, first boot, reboot, networking, audio, and recovery in a clean VM.
- [ ] Publish Beta 1 only after the above tests pass and publish SHA-256 release checksums.

### After Beta 1

- [ ] Bluetooth and Bluetooth audio.
- [ ] Signed DEROX package repository and `derox-pkg` install/remove/upgrade.
- [ ] DEROX App Manager.
- [ ] Broader hardware support, accessibility, localization, update/rollback, and security hardening.

## Definition of “installable ISO”

A file ending in `.iso` is not enough. Beta 1 is installable only when it boots from the ISO, reaches a usable live environment, installs to a blank virtual disk without damaging the host, boots from that disk after installation, and passes the documented smoke tests.

## Honest status

The project currently has tested preparation and staging helpers. It does **not** yet have a verified source lock, built toolchain, complete root filesystem, live environment, installer, or bootable 2.0 ISO. Keep these milestones unchecked until there is real build and boot evidence.

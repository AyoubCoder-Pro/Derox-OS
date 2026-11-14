# DEROX OS 2.0 roadmap

All milestones are planned; none should be marked complete until tested and reviewed.

- [x] Create a separate `derox-2.0` development branch.
- [x] Record the independent-from-other-distributions goal and initial architecture.
- [x] Define the first package manifest schema and add a read-only validator with unit tests.
- [x] Remove the Debian 1.0 ISO workflow and legacy live-build hook from this branch.
- [ ] Select and pin the LFS/BLFS book revision and x86_64 toolchain inputs.
- [ ] Create reproducible bootstrap and base-system build recipes.
- [ ] Build a minimal system and boot it in QEMU/VirtualBox.
- [ ] Add networking, certificates, audio, and hardware support.
- [ ] Build and test the XFCE desktop session.
- [ ] Integrate the official DEROX 2.0 default wallpaper and branding.
- [ ] Implement the DEROX package manifest and repository metadata verifier.
- [ ] Implement `derox-pkg` install, remove, upgrade, and recovery.
- [ ] Implement DEROX App Manager.
- [ ] Produce a reproducible live ISO.
- [ ] Test installation, updates, rollback/recovery, and SHA-256 release verification.
- [ ] Publish a clearly labelled alpha release.

## Release rule

Do not publish a 2.0 ISO as stable until clean builds and virtual-machine tests pass. Keep the existing 1.0 release and Debian-based workflow untouched.

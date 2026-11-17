# DEROX OS identity files

`install-identity.sh` stages the distribution identity into a target root filesystem.
It does not modify the running host and does not require root privileges when the
target directory is writable.

Run from the repository root:

```bash
bash v2/system/install-identity.sh /path/to/target-rootfs
bash v2/system/test-install-identity.sh
```

The staged files are:
- `/etc/os-release`: DEROX OS 2.0 development identity.
- `/etc/issue` and `/etc/motd`: clear development-build notices.
- `/etc/hostname`: default hostname `derox`.
- `/usr/share/derox/release-info`: machine-readable project metadata.

This does not create a bootable system. It must be called by the future rootfs
assembly process after the base filesystem has been created.

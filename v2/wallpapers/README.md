# DEROX OS 2.0 wallpapers

The approved default design is the purple galaxy / mountain / lake DEROX OS 2.0 artwork generated for this project.

The official vector wallpaper is `derox-2.0-default.svg`. The integration script `install-default.sh` copies it into a target root filesystem at:

`/usr/share/backgrounds/derox/derox-2.0-default.svg`

It also writes an XFCE desktop default for new users under `/etc/skel`, so the wallpaper is selected when a new user profile is created.

## Use during image assembly

After creating the target root filesystem and installing XFCE, run:

```bash
bash v2/wallpapers/install-default.sh /path/to/target-rootfs
```

The script does not build an ISO or modify the running host. Its integration test is `bash v2/wallpapers/test-install-default.sh`.

**Status:** wallpaper integration is prepared and testable, but DEROX OS 2.0 still has no completed root filesystem or ISO. This script can be included in the future image-assembly pipeline once the base system and XFCE build stages exist.

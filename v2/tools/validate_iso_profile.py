#!/usr/bin/env python3
"""Validate the DEROX 2.0 lightweight ISO profile and its safety invariants."""
import json
import sys
from pathlib import Path

REQUIRED = {
    "linux-kernel-and-essential-storage-filesystem-drivers",
    "systemd-and-essential-runtime-libraries",
    "shell-and-core-utilities",
    "device-management",
    "grub-bios-and-uefi-boot-support",
    "xfce-desktop-and-lightweight-display-manager",
    "networkmanager-and-required-wifi-firmware",
    "alsa-pipewire-wireplumber-audio-stack",
    "live-session-and-guided-installer",
    "recovery-tools",
    "derox-branding-and-default-wallpaper",
}
FORBIDDEN = {
    "storage-drivers-required-to-boot-and-install",
    "installer-and-recovery-dependencies",
    "firmware-required-by-supported-test-hardware",
    "shared-libraries-required-by-included-runtime-components",
}

def validate(data):
    errors = []
    if data.get("schema_version") != 1:
        errors.append("schema_version must be 1")
    if data.get("architecture") != "x86_64":
        errors.append("architecture must be x86_64")
    if data.get("profile") != "beta1-lightweight-x86_64":
        errors.append("unexpected profile name")
    if data.get("size_target_bytes") != 2147483648:
        errors.append("size target must be 2 GiB")
    compression = data.get("compression", {})
    if compression.get("filesystem") != "squashfs":
        errors.append("live filesystem must be SquashFS")
    if compression.get("preferred") not in {"xz", "zstd"}:
        errors.append("preferred compression must be xz or zstd")
    include = data.get("include", [])
    exclude = data.get("exclude", [])
    deferred = data.get("deferred", [])
    safety = data.get("non_removable_safety_components", [])
    if not isinstance(include, list) or not REQUIRED.issubset(include):
        errors.append("include list is missing one or more Beta 1 essentials")
    if not isinstance(exclude, list) or not isinstance(deferred, list):
        errors.append("exclude and deferred must be lists")
    if set(include) & set(exclude):
        errors.append("a component cannot be both included and excluded")
    if set(include) & set(deferred):
        errors.append("a component cannot be both included and deferred")
    if not FORBIDDEN.issubset(set(safety)):
        errors.append("safety-critical components must be explicitly protected")
    if set(exclude) & set(safety):
        errors.append("safety-critical components must never be excluded")
    return errors

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {Path(sys.argv[0]).name} PROFILE.json", file=sys.stderr)
        return 2
    try:
        data = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    errors = validate(data)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("DEROX lightweight ISO profile: valid")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())

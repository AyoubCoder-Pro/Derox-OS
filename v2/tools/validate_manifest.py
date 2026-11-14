#!/usr/bin/env python3
"""Read-only validator for early DEROX .drp package manifests.

This tool never installs packages or executes package-provided code.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

NAME_RE = re.compile(r"^[a-z0-9][a-z0-9+.-]{1,63}$")
SHA256_RE = re.compile(r"^[a-fA-F0-9]{64}$")
SAFE_FILE_RE = re.compile(r"^[A-Za-z0-9._-]+$")


def validate(data: object) -> list[str]:
    errors: list[str] = []
    if not isinstance(data, dict):
        return ["manifest root must be a JSON object"]

    required = {"schema_version", "name", "version", "architecture", "description", "license", "payload"}
    missing = sorted(required - data.keys())
    if missing:
        errors.append("missing required fields: " + ", ".join(missing))

    if data.get("schema_version") != 1:
        errors.append("schema_version must be 1")
    if not isinstance(data.get("name"), str) or not NAME_RE.fullmatch(data["name"]):
        errors.append("name must be 2-64 lowercase letters, digits, '+', '.', or '-' and start with a letter or digit")
    if not isinstance(data.get("version"), str) or not data["version"].strip() or len(data["version"]) > 128:
        errors.append("version must be a non-empty string of at most 128 characters")
    if data.get("architecture") not in ("x86_64", "any"):
        errors.append("architecture must be 'x86_64' or 'any'")
    if not isinstance(data.get("description"), str) or len(data["description"]) > 512:
        errors.append("description must be a string of at most 512 characters")
    if not isinstance(data.get("license"), str) or not data["license"].strip() or len(data["license"]) > 128:
        errors.append("license must be a non-empty string of at most 128 characters")

    for key in ("dependencies", "conflicts"):
        value = data.get(key, [])
        if not isinstance(value, list) or any(not isinstance(x, str) or not x.strip() for x in value):
            errors.append(f"{key} must be an array of non-empty strings")
        elif len(value) != len(set(value)):
            errors.append(f"{key} must not contain duplicates")

    payload = data.get("payload")
    if not isinstance(payload, dict):
        errors.append("payload must be an object")
    else:
        if not isinstance(payload.get("file"), str) or not SAFE_FILE_RE.fullmatch(payload["file"]) or payload["file"] in (".", ".."):
            errors.append("payload.file must be a safe filename without directory components")
        if payload.get("format") != "tar.zst":
            errors.append("payload.format must be 'tar.zst'")
        if not isinstance(payload.get("sha256"), str) or not SHA256_RE.fullmatch(payload["sha256"]):
            errors.append("payload.sha256 must contain exactly 64 hexadecimal characters")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a DEROX package manifest without installing it.")
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--package", type=Path, help="optional package payload to hash-check")
    args = parser.parse_args()

    try:
        data = json.loads(args.manifest.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        print(f"ERROR: cannot read manifest: {exc}", file=sys.stderr)
        return 2

    errors = validate(data)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    if args.package:
        payload = data["payload"]
        if args.package.name != payload["file"]:
            print("ERROR: package filename does not match payload.file", file=sys.stderr)
            return 1
        digest = hashlib.sha256()
        try:
            with args.package.open("rb") as stream:
                for chunk in iter(lambda: stream.read(1024 * 1024), b""):
                    digest.update(chunk)
        except OSError as exc:
            print(f"ERROR: cannot read package payload: {exc}", file=sys.stderr)
            return 2
        if digest.hexdigest().lower() != payload["sha256"].lower():
            print("ERROR: package SHA-256 does not match manifest", file=sys.stderr)
            return 1

    print(f"OK: valid DEROX package manifest for {data['name']} {data['version']}")
    if not args.package:
        print("NOTE: payload bytes were not checked; pass --package to verify the SHA-256.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

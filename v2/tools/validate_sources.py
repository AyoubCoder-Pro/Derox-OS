#!/usr/bin/env python3
"""Validate DEROX's pinned upstream source lock; never downloads or builds sources."""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

NAME_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9+._-]{0,63}$")
ARCHIVE_RE = re.compile(r"^[A-Za-z0-9._+-]+$")
SHA256_RE = re.compile(r"^[a-fA-F0-9]{64}$")


def validate(data: object) -> list[str]:
    errors: list[str] = []
    if not isinstance(data, dict):
        return ["source lock root must be a JSON object"]

    required = {"schema_version", "distribution", "release_track", "architecture", "sources"}
    missing = sorted(required - data.keys())
    if missing:
        errors.append("missing required fields: " + ", ".join(missing))
    if data.get("schema_version") != 1:
        errors.append("schema_version must be 1")
    if data.get("distribution") != "DEROX OS":
        errors.append("distribution must be 'DEROX OS'")
    if not isinstance(data.get("release_track"), str) or not data["release_track"].strip():
        errors.append("release_track must be a non-empty string")
    if data.get("architecture") != "x86_64":
        errors.append("architecture must be 'x86_64'")
    sources = data.get("sources")
    if not isinstance(sources, list):
        errors.append("sources must be an array")
        return errors

    seen: set[str] = set()
    required_source = {"name", "version", "url", "archive", "sha256", "license", "homepage"}
    for index, source in enumerate(sources):
        prefix = f"sources[{index}]"
        if not isinstance(source, dict):
            errors.append(f"{prefix} must be an object")
            continue
        missing_source = sorted(required_source - source.keys())
        if missing_source:
            errors.append(f"{prefix} missing required fields: " + ", ".join(missing_source))
        name = source.get("name")
        if not isinstance(name, str) or not NAME_RE.fullmatch(name):
            errors.append(f"{prefix}.name is invalid")
        elif name in seen:
            errors.append(f"{prefix}.name duplicates another source")
        else:
            seen.add(name)
        for field in ("version", "license"):
            value = source.get(field)
            if not isinstance(value, str) or not value.strip() or len(value) > 128:
                errors.append(f"{prefix}.{field} must be a non-empty string of at most 128 characters")
        for field in ("url", "homepage"):
            value = source.get(field)
            if not isinstance(value, str) or not value.startswith("https://") or any(c.isspace() for c in value):
                errors.append(f"{prefix}.{field} must be an HTTPS URL")
        archive = source.get("archive")
        if not isinstance(archive, str) or not ARCHIVE_RE.fullmatch(archive) or archive in (".", ".."):
            errors.append(f"{prefix}.archive must be a safe archive filename")
        digest = source.get("sha256")
        if not isinstance(digest, str) or not SHA256_RE.fullmatch(digest):
            errors.append(f"{prefix}.sha256 must contain exactly 64 hexadecimal characters")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate DEROX's upstream source lock.")
    parser.add_argument("lockfile", type=Path)
    args = parser.parse_args()
    try:
        data = json.loads(args.lockfile.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        print(f"ERROR: cannot read source lock: {exc}", file=sys.stderr)
        return 2
    errors = validate(data)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print(f"OK: valid DEROX source lock ({len(data['sources'])} pinned sources)")
    if not data["sources"]:
        print("NOTE: no sources are pinned yet; this lock is not sufficient to build DEROX.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

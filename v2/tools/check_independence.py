#!/usr/bin/env python3
"""Reject Debian package-manager/runtime dependencies in the DEROX 2.0 build tree.

Documentation may explain that 2.0 is not Debian-based. This guard scans executable
build/configuration files only, so historical explanations do not trigger failures.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

SCANNED_SUFFIXES = {
    ".sh", ".bash", ".yml", ".yaml", ".json", ".cfg", ".conf",
    ".mk", ".toml", ".ini", ".service",
}
FORBIDDEN = [
    (re.compile(r"(?m)^\s*(?:sudo\s+)?(?:apt-get|apt|dpkg|debootstrap|live-build)\b"), "Debian package/build command"),
    (re.compile(r"(?i)/etc/debian_version\b"), "Debian release marker"),
    (re.compile(r"(?i)/etc/apt(?:/|\b)"), "APT configuration path"),
    (re.compile(r"(?i)\bdeb\s+https?://[^\s]+"), "Debian APT repository entry"),
    (re.compile(r"(?i)\bFROM\s+debian(?::|\s|$)"), "Debian container base image"),
]


def scan_tree(root: Path) -> list[str]:
    violations: list[str] = []
    for area in (root / "v2", root / "iso"):
        if not area.exists():
            continue
        for path in sorted(area.rglob("*")):
            if not path.is_file() or path.suffix.lower() not in SCANNED_SUFFIXES:
                continue
            try:
                content = path.read_text(encoding="utf-8")
            except (OSError, UnicodeError) as exc:
                violations.append(f"{path.relative_to(root)}: cannot read build file: {exc}")
                continue
            for number, line in enumerate(content.splitlines(), 1):
                # Ignore shell/YAML comments; commands embedded in executable lines remain checked.
                active = line.split("#", 1)[0]
                for pattern, label in FORBIDDEN:
                    if pattern.search(active):
                        violations.append(
                            f"{path.relative_to(root)}:{number}: {label}"
                        )
    return violations


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    violations = scan_tree(root)
    if violations:
        print("DEROX 2.0 independence check FAILED:")
        print("\n".join(f"- {item}" for item in violations))
        return 1
    print("DEROX 2.0 independence check passed: no Debian build/runtime dependencies found.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

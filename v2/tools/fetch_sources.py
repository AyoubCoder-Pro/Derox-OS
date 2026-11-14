#!/usr/bin/env python3
"""Download only explicitly pinned DEROX sources and verify SHA-256 before use."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

ARCHIVE_RE = re.compile(r"^[A-Za-z0-9._+-]+$")
SHA256_RE = re.compile(r"^[a-fA-F0-9]{64}$")
CHUNK_SIZE = 1024 * 1024


class FetchError(Exception):
    pass


def safe_source_entry(entry: object, index: int) -> tuple[str, str, str]:
    if not isinstance(entry, dict):
        raise FetchError(f"sources[{index}] must be an object")
    name, url, archive, digest = (
        entry.get("name"), entry.get("url"), entry.get("archive"), entry.get("sha256")
    )
    if not isinstance(name, str) or not name:
        raise FetchError(f"sources[{index}].name is invalid")
    if not isinstance(url, str) or not url.startswith("https://") or any(c.isspace() for c in url):
        raise FetchError(f"sources[{index}].url must be HTTPS")
    if not isinstance(archive, str) or not ARCHIVE_RE.fullmatch(archive) or archive in (".", ".."):
        raise FetchError(f"sources[{index}].archive is unsafe")
    if not isinstance(digest, str) or not SHA256_RE.fullmatch(digest):
        raise FetchError(f"sources[{index}].sha256 is invalid")
    return url, archive, digest.lower()


def download_one(url: str, destination: Path, expected_sha256: str) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists():
        actual = hashlib.sha256(destination.read_bytes()).hexdigest()
        if actual == expected_sha256:
            print(f"OK: already verified {destination.name}")
            return
        raise FetchError(f"{destination} exists but its SHA-256 does not match; move it aside")
    temporary = destination.with_name(destination.name + ".part")
    digest = hashlib.sha256()
    try:
        request = urllib.request.Request(url, headers={"User-Agent": "DEROX-source-fetcher/1.0"})
        with urllib.request.urlopen(request, timeout=60) as response:
            final_url = response.geturl()
            if not final_url.startswith("https://"):
                raise FetchError("download redirected away from HTTPS; refusing it")
            with temporary.open("wb") as output:
                while True:
                    chunk = response.read(CHUNK_SIZE)
                    if not chunk:
                        break
                    digest.update(chunk)
                    output.write(chunk)
        actual = digest.hexdigest()
        if actual != expected_sha256:
            raise FetchError(
                f"SHA-256 mismatch for {destination.name}: expected {expected_sha256}, got {actual}"
            )
        temporary.replace(destination)
        print(f"OK: downloaded and verified {destination.name}")
    except Exception:
        temporary.unlink(missing_ok=True)
        raise


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("lockfile", type=Path)
    parser.add_argument("--output", type=Path, default=Path("sources"))
    args = parser.parse_args()
    try:
        lock = json.loads(args.lockfile.read_text(encoding="utf-8"))
        if not isinstance(lock, dict) or lock.get("distribution") != "DEROX OS":
            raise FetchError("not a DEROX source lock")
        sources = lock.get("sources")
        if not isinstance(sources, list):
            raise FetchError("source lock 'sources' must be an array")
        if not sources:
            raise FetchError("source lock is empty; no downloads attempted")
        for index, entry in enumerate(sources):
            url, archive, digest = safe_source_entry(entry, index)
            download_one(url, args.output / archive, digest)
    except (OSError, UnicodeError, json.JSONDecodeError, FetchError, urllib.error.URLError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    print(f"All {len(sources)} source archive(s) verified.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

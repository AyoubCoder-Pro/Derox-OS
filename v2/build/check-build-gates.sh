#!/usr/bin/env bash
# Read-only readiness gate. It never installs packages, extracts archives, or builds.
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
LOCK="$ROOT/v2/sources/sources.json"
SOURCE_DIR="${DEROX_SOURCE_DIR:-$ROOT/sources}"

fail() { printf 'BLOCKED: %s\n' "$*" >&2; exit 1; }
[[ "$(id -u)" -ne 0 ]] || fail "run as an unprivileged build user, not root"
command -v python3 >/dev/null 2>&1 || fail "python3 is required"
command -v sha256sum >/dev/null 2>&1 || fail "sha256sum is required"
[[ -f "$LOCK" ]] || fail "source lock is missing"

python3 "$ROOT/v2/tools/validate_sources.py" "$LOCK" || fail "source lock validation failed"
count="$(python3 - "$LOCK" <<'PY'
import json,sys
with open(sys.argv[1], encoding="utf-8") as f:
    print(len(json.load(f)["sources"]))
PY
)"
[[ "$count" -gt 0 ]] || fail "source lock is empty; verified SHA-256 pins are required before building"

python3 - "$LOCK" "$SOURCE_DIR" <<'PY'
import hashlib, json, pathlib, sys
lock_path, source_dir = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
data=json.loads(lock_path.read_text(encoding="utf-8"))
errors=[]
for item in data["sources"]:
    path=source_dir/item["archive"]
    if not path.is_file():
        errors.append(f"missing archive: {item['archive']}")
        continue
    digest=hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024*1024), b""):
            digest.update(chunk)
    if digest.hexdigest().lower() != item["sha256"].lower():
        errors.append(f"SHA-256 mismatch: {item['archive']}")
if errors:
    print("\n".join("BLOCKED: "+e for e in errors), file=sys.stderr)
    raise SystemExit(1)
print(f"OK: {len(data['sources'])} source archives match the lock")
PY
printf 'OK: source and privilege gates passed. This is not a toolchain build.\n'

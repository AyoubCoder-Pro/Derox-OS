# DEROX source lock

This directory will contain the exact upstream source inputs used to build DEROX OS 2.0.

## Rules

- Every source entry must have an upstream HTTPS URL, a pinned version, an archive filename, and a SHA-256 digest.
- Never use a moving URL such as `latest`, `current`, or an unpinned Git branch as a release input.
- Verify checksums against the upstream project's published checksum/signature before adding an entry.
- Record the upstream license and project homepage.
- Do not invent checksums. The initial lock file is intentionally empty until each source is verified.

Validate a lock file with:

```sh
python v2/tools/validate_sources.py v2/sources/sources.json
```

A valid empty lock file is only a structurally valid starting point; it is not a buildable system.

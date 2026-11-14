# DEROX upstream source lock

The source lock records the exact upstream archive URL, filename, version, license, homepage, and SHA-256 digest for every build input.

## Validate and download

From the repository root:

```bash
python3 v2/tools/validate_sources.py v2/sources/sources.json
python3 v2/tools/fetch_sources.py v2/sources/sources.json --output sources
```

The downloader accepts HTTPS URLs only, rejects unsafe archive names, checks the final redirect remains HTTPS, streams each archive to a temporary `.part` file, and only renames it into place after its SHA-256 matches the lock. A pre-existing archive is accepted only if its digest matches exactly.

Do not add a source until its version, official download URL, archive name, license, and SHA-256 have been checked against the upstream project's release information. Never invent or copy an unverified digest.

The starter lock is intentionally empty. The downloader therefore refuses to run until the source inventory is populated. This is expected and prevents an incomplete or fabricated source list from being treated as build-ready.

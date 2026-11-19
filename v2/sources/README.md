# DEROX upstream source lock

The source lock records the exact upstream archive URL, filename, version, license, homepage, SHA-256 digest, and a link plus provenance label for the upstream checksum/signature evidence.

## Validate and download

From the repository root:

```bash
python3 v2/tools/validate_sources.py v2/sources/sources.json
python3 v2/tools/fetch_sources.py v2/sources/sources.json --output sources
```

The downloader accepts HTTPS URLs only, rejects unsafe archive names, checks the final redirect remains HTTPS, streams each archive to a temporary `.part` file, and only renames it into place after its SHA-256 matches the lock. A pre-existing archive is accepted only if its digest matches exactly.

## Checksum evidence policy

Every source entry must include `sha256_reference` (an HTTPS link to upstream checksum or signature evidence) and `sha256_provenance`:

- `upstream-published`: upstream explicitly publishes the SHA-256 value.
- `upstream-signature-verified`: the archive or checksum file was authenticated using the upstream project's published signing key.

A SHA-256 calculated locally after downloading is useful for later integrity checks, but by itself it does **not** authenticate the archive. Do not label a locally calculated value as upstream-verified. Some LFS source-index files publish MD5 rather than SHA-256; MD5-only evidence is not sufficient for this DEROX lock policy.

The starter lock remains intentionally empty until suitable SHA-256 evidence is available for each exact pinned archive. Never invent a digest or claim that an empty lock is build-ready.

## Signature verification plan

See [SIGNATURE-VERIFICATION.md](SIGNATURE-VERIFICATION.md) for the reviewed upstream signature formats, maintainer fingerprints, trust requirements, and current candidate decisions. This document does not approve any source; the lock remains empty until verification is actually performed.

# DEROX 2.0 source-lock audit

Audit date: 2026-11-19

## Result

The production source lock at `v2/sources/sources.json` remains intentionally empty. No archive is marked build-ready until its exact archive bytes are authenticated and its SHA-256 is recorded.

## Candidate sources reviewed

| Component | Candidate | Official upstream evidence | Lock decision |
|---|---|---|---|
| Linux kernel | 7.3.5 | Kernel.org lists the 7.3.5 release and its tarball plus detached PGP signature. | Not locked: signature verification and SHA-256 recording have not yet been performed. |
| BusyBox | 1.38.0 | BusyBox official download index lists the 1.38.0 source archive and adjacent small metadata/signature files. | Not locked: the exact SHA-256 evidence file contents and provenance have not been independently confirmed. |

## Why no guessed hashes are included

A SHA-256 calculated locally after downloading an archive detects later changes but does not prove that the downloaded archive was authentic. DEROX requires either an upstream-published SHA-256 or a successful verification of the upstream signature, followed by recording the archive's SHA-256 and the exact evidence URL.

## Next steps before locking

1. Select the exact source archive and version for each component.
2. Verify upstream detached signatures against independently obtained upstream maintainer keys, or locate a published upstream SHA-256.
3. Record the verified digest, evidence URL, provenance, license, homepage, and exact download URL in `sources.json`.
4. Run the source-lock validator and a real download-and-hash verification in CI.
5. Only then allow the build gates to proceed.

References:
- Linux kernel release archive: https://cdn.kernel.org/pub/linux/kernel/v7.x/
- BusyBox official downloads: https://www.busybox.net/downloads/

# DEROX 2.0 upstream signature verification plan

Audit date: 2026-11-19

## Goal

Authenticate upstream source content before recording a SHA-256 digest in
`v2/sources/sources.json`. A locally calculated digest is recorded only after
a successful upstream signature verification; it is not treated as independent
authentication by itself.

## Linux kernel candidate

- Candidate release: Linux 7.3.5 (stable release dated 2026-11-17).
- Archive directory: https://cdn.kernel.org/pub/linux/kernel/v7.x/
- Expected detached signature: `linux-7.3.5.tar.sign`.
- Official signature instructions: https://www.kernel.org/signature.html
- Official maintainer fingerprints published by kernel.org:
  - Linus Torvalds: `ABAF11C65A2970B130ABE3C479BE3E4300411886`
  - Greg Kroah-Hartman: `647F28654894E3BD457199BE38DBBDC86092693E`
- Important format detail: the detached signature is made over the uncompressed
  `.tar` stream, not directly over the `.tar.xz` file. Verification must use
  the uncompressed tar representation as documented by kernel.org.
- Do not assume which maintainer signed a particular release. Inspect the
  signature's actual signing-key fingerprint and require it to match an
  independently trusted, explicitly pinned fingerprint.

Status: candidate only; the 7.3.5 signature has not yet been verified by DEROX.

## BusyBox candidate

- Candidate version: BusyBox 1.38.0, announced on the official BusyBox site as
  unstable on 2026-05-13.
- Archive: https://busybox.net/downloads/busybox-1.38.0.tar.bz2
- Detached signature: https://busybox.net/downloads/busybox-1.38.0.tar.bz2.sig
- Public key published under the maintainer's BusyBox website directory:
  https://busybox.net/~vda/vda_pubkey.gpg
- Full fingerprint reported for Denis Vlasenko's key:
  `C9E9416F76E610DBD09D040F47B70C55ACC9965B`.
- The public key must be checked against an independent trusted source before
  use. Downloading a key from the same site as the archive alone is not enough
  to establish trust (TOFU limitation).

Status: candidate only; do not lock the archive until key trust and signature
verification are independently established. Also decide whether an unstable
BusyBox release is appropriate for the first DEROX bootstrap.

## Required verification procedure

1. Obtain the source archive and detached signature over HTTPS.
2. Obtain the signing public key through an independently authenticated route.
3. Verify the full key fingerprint against a pinned trust record.
4. Verify the detached signature and reject missing, expired, revoked, or
   mismatched signing keys.
5. Only after signature success, calculate SHA-256 for the exact archive bytes
   that will be downloaded by the build.
6. Record the digest, archive URL, evidence URL, and
   `upstream-signature-verified` provenance in the source lock.
7. Run the source-lock validator and a clean download-and-hash test.

## Current decision

No source entry is approved by this document. The production source lock remains
empty. This is deliberate: a documented candidate or a published signature is
not the same as a completed cryptographic verification.

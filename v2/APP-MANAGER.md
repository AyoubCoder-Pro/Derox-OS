# DEROX App Manager and package format

## User experience

The planned graphical application is **DEROX App Manager**. It will provide:

- Search and browse by category.
- Application details, version, publisher, size, and permissions.
- Install, remove, and update actions.
- Update-all view and update history.
- Clear errors and an operation log.
- Repository status and signature verification.

## Package manager

The command-line backend is tentatively named `derox-pkg`. The graphical app must call this backend through a narrow, documented interface rather than modifying the package database itself.

Proposed commands:

```text
derox-pkg search <query>
derox-pkg info <package>
derox-pkg install <package>
derox-pkg remove <package>
derox-pkg upgrade
derox-pkg list
derox-pkg verify
```

These commands are a proposed interface, not implemented commands yet.

## Repository and package design

The proposed package extension is `.drp`. A package will contain a manifest, payload archive, and integrity metadata. The manifest must identify package name, version, architecture, license, dependencies, conflicts, installed files, and upstream source.

Repository metadata must be signed. The client must verify signatures and hashes before accepting metadata or package payloads. Trust keys must be shipped through a controlled release process, with a documented key-rotation and revocation procedure.

## Safety and reliability requirements

- No unsigned repository is trusted by default.
- No package may silently overwrite files owned by another package.
- Install and upgrade operations must be transactional or recoverable.
- Dependency resolution must detect conflicts before changing the system.
- Removal must preserve user data and clearly identify configuration files.
- GUI operations must request authorization through the system's standard privilege mechanism.
- Package scripts, if ever supported, need a reviewed sandbox and must not be treated as trusted merely because they are in a package.

## Implementation order

1. Define a versioned manifest schema.
2. Implement read-only package inspection and repository metadata verification.
3. Implement dependency resolution against a local test repository.
4. Implement install/remove with a recoverable file database.
5. Add signed remote repositories and updates.
6. Build the graphical XFCE application on top of the stable CLI.

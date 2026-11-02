# Issue #0003: Update Install Logic & Verification

**Status**: Closed
**Labels**: ready-for-agent, feature, architecture

## Parent

- Issue #0001: Antigravity Stow Cleanup and Path Consolidation

## What to build

Update the conflicts backup and restore logic in `install.sh` to align with the purged files and decoupled folders. Execute `bash install.sh --only dot-agent` and verify that the environment setup completes cleanly without Stow conflicts, correctly creating all symlinks. Ensure the configuration stowing process is completely idempotent.

## Acceptance criteria

- [x] get_conflicts() inside `install.sh` updated to remove obsolete check paths and include config plugins/sidecars.
- [x] Executing `bash install.sh --only dot-agent` finishes with exit code 0.
- [x] Verification shows dereferenced symlinks (`ls -laL`) resolve successfully to `.agents/` targets in the home directory.
- [x] Re-stowing a second time completes with zero errors (idempotency verified).

## Blocked by

- Issue #0002: Purge Redundant Stow Configs

## Comments

- **Comment by Antigravity**: Script successfully updated, stowing verified, and idempotency proven.

# 0002. Decouple Install Script with Declarative Manifest

## Status
Accepted

## Context
The root installer script `install.sh` operated as a monolithic "ghost controller". It hardcoded package lists, categories, dependency mapping, file conflicts, and package-specific setup hooks inside multiple scattered bash `case` statements. Adding or modifying packages required editing multiple parts of `install.sh`, violating the Single Responsibility Principle and limiting scalability.

## Decision
We decided to decouple `install.sh` into a modular architecture:
1. **Declarative Package Manifest** (`packages.json`): A single JSON file at the repository root defining package metadata (`category`, `deps`, `conflicts`, `hook`).
2. **Modular Helper Scripts** (`scripts/lib/`):
   - `scripts/lib/manifest.py`: Python helper to query `packages.json` without external binary dependencies.
   - `scripts/lib/backup.sh`: Handles conflict detection and file backup logic.
   - `scripts/lib/stow.sh`: Executes GNU Stow package linking.
3. **Isolated Setup Hooks** (`scripts/hooks/`): Package-specific post-stow logic (e.g., `gnupg.sh`, `zellij.sh`) isolated into standalone executable scripts.
4. **Thin Runner** (`install.sh`): Refactored to act as a lightweight CLI dispatcher.

## Consequences
- **High Extensibility**: Adding a new Stow package requires adding an entry in `packages.json` (and an optional hook in `scripts/hooks/`) without altering core installer logic.
- **Improved Maintainability**: Clear separation between package configuration, cleanup/backup logic, and symlink execution.
- **Zero External Overhead**: Uses built-in Python 3 for JSON parsing, maintaining 100% macOS and Linux portability.

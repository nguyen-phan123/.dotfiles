# 🛠️ Scripts & Automation Context (scripts/CONTEXT.md)

Domain vocabulary for installer scripts, dependency bootstrappers, and sync scripts.

## Vocabulary & Core Concepts

### 🚀 Stow Installer (`install.sh`)
*   **Definition**: The primary root installer script that resolves dependencies, backs up conflicting files, and stows packages dynamically into `$HOME`.
*   **Target terms**: Use **Stow Installer**.

### 📦 Dependency Bootstrapper (`scripts/install-deps.sh`)
*   **Definition**: Helper script invoked by `--deps` or missing dependencies check to install missing CLI binaries (starship, zoxide, ripgrep, stow) via Homebrew.
*   **Target terms**: Use **Dependency Bootstrapper**.

### 🤖 Claude Installer (`install-claude.sh`)
*   **Definition**: Dedicated setup script for installing and bootstrapping Claude Code agent frameworks and settings.
*   **Target terms**: Use **Claude Installer**.

### 📄 Package Manifest (`packages.json`)
*   **Definition**: Centralized declarative JSON manifest defining all Stow packages, categories, binary dependencies, file conflicts, and setup hooks.
*   **Target terms**: Use **Package Manifest**.

### 🐍 Manifest Parser (`scripts/lib/manifest.py`)
*   **Definition**: Built-in Python helper script used by `install.sh` to query package metadata from `packages.json` without external CLI dependencies.
*   **Target terms**: Use **Manifest Parser**.

### 🪝 Package Setup Hook (`scripts/hooks/*.sh`)
*   **Definition**: Isolated executable scripts that encapsulate package-specific post-stow logic (e.g. `gnupg.sh`, `zellij.sh`).
*   **Target terms**: Use **Package Setup Hook**.

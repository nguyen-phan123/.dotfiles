# 0001. Workspace-Local vs Global Agent Scope

## Status
Accepted

## Context
When configuring AI coding agents (Gemini IDE, Antigravity, and Claude Code) in a dotfiles repository, there is a risk of mixing system-wide agent parameters with workspace-local development tools. If system settings are stored globally, workspace-specific automations (like OpenSpec workflows and repository-specific coding skills) clutter the home directory or leak across unrelated projects.

## Decision
We decided to strictly separate the configurations into two scopes:
1. **Workspace-Local Scope** (`.gemini/`, `.agents/`, `.claude/` at the root of `dotfiles`): These directories are used to configure and power the agents operating *specifically* on the `dotfiles` project itself. They are tracked directly in Git but are **not** symlinked or stowed globally.
2. **Global Scope** (`dotfiles/agent/` Stow package): This directory holds system-wide configurations stowed to the user's home folder (`~/.gemini/`, `~/.agent/`, `~/.understand-anything/`) to configure global agents across all projects.

To bridge these scopes, we use a **Double Symlink** pattern: the stowed global agent settings `~/.gemini/agent` resolve to the package symlink `agent/.gemini/agent`, which in turn points relatively (`../../.agents`) to the project-local `.agents/` folder.

## Consequences
- **Maximum Locality**: Workspace-specific automations are safely isolated within the project scope, preventing leakage or data loss when resetting global settings.
- **Flawless Portability**: Clone-and-run compatibility is maintained since all project-specific tools stay inside the repository.
- **Zero Duplication**: System-wide agents can cleanly execute and access local skills through resolving nested symlinks.

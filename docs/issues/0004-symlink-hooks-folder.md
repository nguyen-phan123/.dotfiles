# Issue #0004: Establish and Symlink Workspace Hooks Folder

**Status**: Open
**Labels**: ready-for-agent, feature, architecture

## Problem Statement

Currently, the Google Antigravity IDE configuration package contains a `hooks` folder (`agent/dot-agent/.gemini/hooks`) that is empty, local, and untracked. There is no centralized workspace-level hooks directory inside `.agents/` to track and share client-side/command-line hooks (like pre-command, post-command, or runtime rewrite scripts). This prevents collaborative tracking and sharing of custom hooks, exposing the configuration to regression or manual copy-pasting bugs.

## Solution

1. Create a centralized, Git-tracked `.agents/hooks/` directory in the repository root.
2. Replace the empty `agent/dot-agent/.gemini/hooks/` directory with a relative symlink pointing directly to `../../../.agents/hooks` (level-correct path resolution).
3. Update `install.sh` to ensure `~/.gemini/hooks` is safely handled, backed up, and cleaned during stowing conflicts under the `dot-agent` package config block.
4. Ensure the entire stowing process remains idempotent and robust.

## User Stories

1. As a developer, I want all my client and CLI hooks to be managed under a single source of truth in `.agents/hooks/`, so that they are fully version-controlled in Git.
2. As a developer, I want `~/.gemini/hooks/` in my home directory to be stowed dynamically, so that my Antigravity IDE loads my active workspace hooks seamlessly.
3. As a developer, I want the symlink in `agent/dot-agent/.gemini/hooks` to resolve perfectly using relative paths, so that the repository remains portable across different host environments.
4. As an installer script, I want to safely detect and backup any legacy or pre-existing `~/.gemini/hooks` directory before symlinking, preventing data loss during configuration overrides.
5. As a developer, I want the stowing process to be fully idempotent, so that running `install.sh` repeatedly does not break or double-nest my hooks folder links.

## Implementation Decisions

### 1. Centralized Workspace Hooks Directory
- Create the physical folder `.agents/hooks/` at the repository root.
- Place a `.gitkeep` file inside `.agents/hooks/` to ensure Git tracks the folder even if it is currently empty.

### 2. Relative Symlink Mapping in dot-agent package
- Delete the existing physical directory `agent/dot-agent/.gemini/hooks/`.
- Create a relative symlink inside `agent/dot-agent/.gemini/` pointing `hooks` to `../../../.agents/hooks`.
- Ensure it dereferences correctly (level-correct relative pathing 3 levels deep).

### 3. Cleanup & Stowing Refactoring in install.sh
- Modify `get_conflicts()` in `install.sh` for the `dot-agent` package block to include `.gemini/hooks`.
- This ensures that if the developer has an active `~/.gemini/hooks` physical folder or symlink, the installer will safely back it up and clear it before running `stow`.

## Testing Decisions

### 1. Link Resolution Verification
- Running `ls -laL ~/.gemini/hooks` must successfully dereference and resolve to the target `.agents/hooks/` directory in the active dotfiles repository.
- Verify that `file ~/.gemini/hooks` shows it is a valid symbolic link and not broken.

### 2. Stow Clean Run
- Run `bash install.sh --only dot-agent` and verify that the installation completes with exit code 0.
- Verify that no warnings/errors are thrown by `stow`.

### 3. Idempotency Test
- Run `bash install.sh --only dot-agent` multiple times in succession to verify that it does not double-nest directories or throw symlink conflicts.

## Out of Scope

- Implementing specific custom scripts or hooks inside `.agents/hooks/` (this PRD only sets up the architecture and symlink structure).
- Configuring hooks for non-Antigravity clients like Claude Desktop or Claude CLI/Codex in this ticket (out-of-scope).

## Comments

- **Comment by Antigravity**: Scaffolding complete PRD and scheduling for implementation.

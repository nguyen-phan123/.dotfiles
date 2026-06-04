# Issue #0001: Antigravity Stow Cleanup and Path Consolidation

**Status**: Open
**Labels**: ready-for-agent, feature, architecture

## Description

This PRD defines the requirements and design decisions for Option 1: cleaning up redundant, non-standard, and cluttered symlink paths for the Antigravity agent configuration within the central `dotfiles` stowing package. By purging obsolete directories and streamlining the stowing logic, we prevent Stow conflicts and secure clear, decoupled agent configuration boundaries.

## Problem Statement

As a developer maintaining system-wide agent environments, the current Stow package `dot-agent` creates several cluttered and non-standard directories in the Home folder under `~/.gemini/` (specifically `~/.gemini/rules/`, `~/.gemini/workflows/`, `~/.gemini/antigravity/rules/`, and `~/.gemini/antigravity/workflows/`). 
These paths do not conform to the official Google Antigravity configuration specification. During environments updates or setup execution, this excess symlink structures cause frequent GNU Stow conflicts, clutter the global system configurations, and risk leakage between different workspace scopes.

## Solution

Consolidate and streamline the Antigravity Stow package so that it targets ONLY the official, specification-compliant configuration paths for global rules, skills, and workflows. 

Specifically:
- Remove obsolete rules and workflows directories from `agent/dot-agent/.gemini/` and `agent/dot-agent/.gemini/antigravity/`.
- Ensure the remaining paths (`GEMINI.md` for global rules, `antigravity/skills/` for global skills, and `antigravity/global_workflows/` for global workflows) are pristine and correctly stowed.
- Clean up obsolete files and paths from the `install.sh` conflict backup and cleanup routine to avoid managing legacy backup directories.

## User Stories

1. As a developer running setup scripts, I want the `install.sh` routine to execute without encountering symlink conflicts on redundant folders, so that I can quickly update my system-wide settings.
2. As a developer inspecting global configurations, I want my `~/.gemini` directory to contain only standard directories recognized by Google Antigravity, so that I don't get confused by phantom or duplicate folders.
3. As a developer editing global rules, I want my settings to rely purely on `~/.gemini/GEMINI.md`, so that I have a single source of truth for agent system instructions.
4. As a developer managing global agent workflows, I want them located exclusively in `~/.gemini/antigravity/global_workflows/`, so that I have a clean, modular area for reusable slash commands.
5. As a developer syncing MCP configurations across agents, I want the sync utility to compile and deploy files cleanly without being blocked by stowing structure issues.

## Implementation Decisions

- **Global Config Symlink Elimination**: The following directories and their symlink setups will be completely purged from `agent/dot-agent/.gemini/`:
  - `rules/`
  - `workflows/`
  - `antigravity/rules/`
  - `antigravity/workflows/`
- **Official Specification Mapping**: The system will strictly maintain and stow the following:
  - `~/.gemini/GEMINI.md` (Global Rules - File)
  - `~/.gemini/antigravity/skills/` (Global Skills - Directory)
  - `~/.gemini/antigravity/global_workflows/` (Global Workflows - Directory)
- **Install Script Updates**: Update the `get_conflicts` method in `install.sh` for the `dot-agent` package to reflect only the valid paths, eliminating the redundant cleanup steps.

## Testing Decisions

- **Symlink Integrity Test**: After running `install.sh`, verify that the Home directory contains only the intended stowed symlinks under `~/.gemini/` and that no redundant directories are created.
- **Path Resolution Test**: Verify that global skills are correctly resolved under `~/.gemini/antigravity/skills/` and global workflows are resolved under `~/.gemini/antigravity/global_workflows/`.
- **Conflict Regression Test**: Run the installation script twice consecutively (`install.sh --only dot-agent`) to ensure that Stow handles restowing cleanly without throwing `conflict` errors.

## Out of Scope

- Modifying the sync adapter script `sync.js` or its integration with Claude CLI (`.codex`) or Claude Desktop (`.claude`), as these components reside in separate layers and are not affected by stowing path cleanup.
- Removing `~/.codex/` rules, skills, or workflows symlinks, as Claude CLI/Codex natively expects these paths.

## Further Notes

None.

## Comments

- **Comment by Antigravity**: PRD successfully generated and published via the `/to-prd` process. Ready for implementation planning and approval.

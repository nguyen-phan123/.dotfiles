# Product Requirement Document (PRD): Centralized MCP Configuration Sharing & Synchronizer

## Problem Statement

As a developer using multiple artificial intelligence (AI) agents and IDE tools (such as Claude Code CLI, Claude Desktop, Cursor/Codex, and Antigravity/Gemini), I am forced to manually configure Model Context Protocol (MCP) servers repeatedly across different formats, paths, and tools. This results in:
- Significant configuration duplication (violating the DRY principle).
- Hard-to-maintain files, as server locations and arguments must be updated in multiple files.
- Environmental inconsistency, where some AI tools have access to updated tools/servers while others do not.
- Potential leakage or data loss when setup scripts overwrite entire active configuration folders (e.g. `~/.gemini`).

## Solution

A centralized, automated MCP synchronization and merging engine managed within the user's `dotfiles` repository. Users define all global/shared MCP servers in a single standard format. A companion compilation utility automatically deep-merges global configurations with provider-specific overrides, interpolates dynamic environment variables, formats them into provider-native specifications, and deploys them to their respective locations in the user home directory.

## User Stories

1. As a developer, I want to define my MCP configurations in a single centralized JSON file in my dotfiles repository, so that I do not have to copy-paste configurations across multiple AI tools.
2. As a developer, I want specific AI tools to override or add new MCP servers, so that I can keep tool-specific configurations isolated without polluting the global shared config.
3. As a developer, I want dynamic variables like `$HOME` or `$DOTFILES_DIR` to be interpolated at deploy time, so that I can share my dotfiles across different machines without breaking absolute path references.
4. As an Antigravity IDE user, I want the system to preserve my active IDE database, cache, and settings when stowing the MCP configurations, so that I do not lose history or session data.
5. As a Cursor user, I want the sync utility to deep-merge my MCP servers directly into my existing `cursor.json` workspace settings without overwriting my other editor settings.
6. As a CLI developer, I want the compilation script to automatically detect my active AI providers, so that configurations are only compiled and generated for the providers I currently have installed.
7. As a dotfiles maintainer, I want the MCP synchronization to run automatically during the repository's installation (`install.sh`), so that my environment is always fully up-to-date and in sync.

## Implementation Decisions

### 1. Centralized Dotfiles Directory Structure
- All MCP config assets will live inside the `agent/mcp/` directory of the dotfiles repository.
- Shared configurations will reside in `mcp_config.json`.
- Provider-specific overrides will reside in `overrides/<provider>.json` (e.g. `claude.json`, `cursor.json`, `gemini.json`).

### 2. Deep-Merging Logic (Deep Module)
- A dedicated, pure merge engine will be created to combine the global configurations and provider-specific overrides.
- Overrides will recursively replace existing server fields (such as `args` or `env`) and append new server definitions.
- Missing or empty provider overrides will fall back gracefully to the global configuration.

### 3. Native Format Translators
- **Claude / Gemini / Claude Desktop**: Format configuration matching the standard `{"mcpServers": { ... }}` schema.
- **Cursor**: Read the existing `cursor.json` (if present), merge/replace the `mcpServers` object, and write it back, leaving all other settings completely untouched.

### 4. Dynamic Path Interpolation
- The utility will parse commands, arguments, and environment blocks, replacing variables like `$HOME`, `${HOME}`, and `$DOTFILES_DIR` with actual absolute runtime values.

### 5. Hook Integration
- The compilation and deploy logic will be integrated into the main `install.sh` sequence using the Stow package target.
- Conflicts will be explicitly restricted to sub-paths (e.g., `.gemini/GEMINI.md`) instead of backing up whole directories.

## Testing Decisions

### Test-First Philosophy (TDD)
- The core merge, translator, and interpolation modules must be built strictly using Test-Driven Development (TDD) and the native Node.js test runner (`node:test`).
- Tests must verify behavior through public APIs (e.g., passing in mock configurations and environment objects and asserting outputs).
- Unit tests must not interact with the actual filesystem or live system environments to ensure speed, test isolation, and test repeatability.

### Tested Modules
- **Merge Engine**: Verified for deep-merging behavior, key overrides, and property additions.
- **Interpolation Utility**: Tested for multiple variables (`$HOME`, `$DOTFILES_DIR`), nested paths, and brace syntax.
- **Format Adapters**: Verified for generating valid Cursor-compatible nested schemas vs. standard Claude-style schemas.

## Out of Scope

- Remote synchronization of configurations (e.g., syncing configurations to a remote database or cloud storage).
- Real-time file system watching (automatically re-compiling configs as soon as `mcp_config.json` is modified) - compilation only runs during setup or explicit command invocations.
- Native installation of the actual MCP server binaries (this tool only configures the AI clients to use the servers, it does not download or build them).

## Further Notes

- The project prioritizes zero external dependencies for its CLI and merge module to optimize execution speed, file size, and eliminate security/dependency vulnerabilities.

# Product Requirement Document (PRD): Remove Cursor Configurations from MCP Sync

## Problem Statement

As a developer who does not currently use or support Cursor, having Cursor-specific Model Context Protocol (MCP) configuration handlers, JSON merging logic, path definitions, and unit tests inside my dotfiles repository creates unnecessary codebase bloat, complexity, and maintenance overhead. 

To keep the system highly optimized, clean, and focused strictly on the supported AI clients (Claude CLI, Claude Desktop, and Gemini/Antigravity), all Cursor-related logic and setups must be completely removed.

## Solution

Refactor the MCP Config Sync engine to fully excise all Cursor-related configurations, files, libraries, and tests:
- Remove Cursor from the active targets in the CLI synchronizer.
- Delete the `mergeIntoCursorSettings` adapter.
- Remove all related unit tests.
- Ensure zero impact or regression on the active providers (Claude, Gemini, and Claude Desktop).

## User Stories

1. As a developer, I want the sync utility to only target AI clients I actually use (Claude CLI, Claude Desktop, Gemini), so that my settings are clean and focused.
2. As a maintainer, I want all obsolete Cursor adapters, settings, and functions to be fully deleted, so that the code is easier to read and maintain (clean code).
3. As a developer, I want the unit tests to only cover active, supported behaviors, so that I don't waste time running or maintaining tests for features that are no longer used.

## Implementation Decisions

### 1. Excising Cursor from the CLI (`sync.js`)
- Completely remove the `cursor` key and its configuration options (target path, override file, and `isCursor` flag) from the `PROVIDERS` list.
- Remove all conditional checks for `config.isCursor` inside `main()` for both `--dry-run` and live synchronization modes.

### 2. Deleting the Settings Adapter (`lib/merge.js`)
- Fully delete the `mergeIntoCursorSettings` function.
- Remove `mergeIntoCursorSettings` from the exported module exports block.

### 3. Cleaning Up Unit Tests (`test/merge.test.js`)
- Remove the `mergeIntoCursorSettings` import.
- Completely excise the `Behavior 3: Merge into existing Cursor settings` test block.

### 4. Codebase Sanitization
- Delete `agent/mcp/overrides/cursor.json` if it exists.

## Testing Decisions

### Regression Testing
- Verify that the test suite in `agent/mcp/test/merge.test.js` continues to run and pass 100% of the active, remaining tests (Behavior 1: Deep Merge, Behavior 2: Interpolation, Behavior 4: Fallbacks, Behavior 5: TOML Splicing).
- Run `node agent/mcp/sync.js --dry-run` to verify that no errors are thrown and only the active providers (claude, gemini, claude-desktop, claude-cli) are compiled.

## Out of Scope

- Removing standard JSON-to-JSON or JSON-to-TOML merging and formatting capabilities (these remain active and essential for Claude and Gemini).
- Restructuring the directory layout (`agent/mcp/` remains flat and unified).

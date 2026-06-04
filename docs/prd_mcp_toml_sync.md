# Product Requirement Document (PRD): TOML Integration for Claude CLI (Codex) MCP Sync

## Problem Statement

As a developer using the Claude CLI (codenamed Codex) alongside other AI assistants, I am forced to maintain my MCP configurations in two completely different file formats:
- **JSON format** for standard tools (Claude Desktop, Gemini IDE, Cursor).
- **TOML format** for the Claude CLI (`~/.codex/config.toml`).

This breaks my single source of truth (DRY) principle, forcing me to manually translate JSON server declarations into TOML blocks, increasing errors and slowing down configuration management.

## Solution

Extend the centralized MCP Config Sync utility with a specialized **JSON-to-TOML Compiler/Adapter**. This adapter will parse the existing `~/.codex/config.toml` file, replace its `[mcp_servers]` block with the compiled global configurations (including overrides and path interpolation), and serialize it back to disk safely—without affecting any other critical TOML settings (such as appearance, model defaults, or trusted projects list).

## User Stories

1. As a developer, I want my Claude CLI (Codex) MCP servers to be automatically compiled from my unified `agent/mcp/mcp_config.json` file, so that I don't have to write TOML configurations manually.
2. As a developer, I want the sync utility to preserve all other sections in `~/.codex/config.toml` (such as `model`, `plugins`, `projects`, and `desktop` appearance settings), so that syncing MCP servers never destroys my custom CLI settings.
3. As a developer, I want to use dynamic placeholders like `$HOME` and `$DOTFILES_DIR` in my global config and have them parsed and written into the TOML file as absolute paths, so that the CLI always loads them correctly.
4. As a developer, I want to define specific overrides for my CLI agent via `agent/mcp/overrides/claude-cli.json`, so that I can add or disable CLI-specific tools without polluting the global shared config.

## Implementation Decisions

### 1. Unified Directory Layout Extension
- We will add an override configuration file for the CLI at `agent/mcp/overrides/claude-cli.json` if tool-specific overrides are needed.
- We will configure a new target provider `claude-cli` in `agent/mcp/sync.js` pointing to `/Users/diqit/.codex/config.toml`.

### 2. High-Fidelity TOML Parser and Injector (Deep Module)
- A specialized pure parser will be built in `agent/mcp/lib/merge.js` to locate the `[mcp_servers]` section in TOML.
- Instead of using a complex, heavy external TOML parser npm library (preserving our zero-dependency design), we will implement a robust regex-based line-splicer:
  - It will split the file by lines.
  - It will strip out all lines starting from `[mcp_servers.<name>]` sections up to the next non-mcp section.
  - It will serialize the newly compiled JSON servers block into standard TOML notation and inject it back.

### 3. JSON-to-TOML Serializer Format
- Standard servers will be serialized as:
  ```toml
  [mcp_servers.server-name]
  type = "stdio"
  command = "node"
  args = ["arg1", "arg2"]
  env = { KEY = "VALUE", KEY2 = "VALUE2" }
  ```
- Key-value pairs will be correctly escaped and nested using standard TOML specifications.

## Testing Decisions

### Unit Tests
We will extend the test suite in `agent/mcp/test/merge.test.js` to cover the TOML compilation logic:
- **Behavior 1: JSON to TOML Serialization**: Verify that an MCP server JSON object is converted into the exact expected TOML notation (handling command, array arguments, and env mapping).
- **Behavior 2: Safe TOML Injection**: Verify that injecting compiled servers into a mockup TOML file successfully replaces the old `mcp_servers` block while leaving other properties (like `model`, `appearance`, `projects`) completely untouched.

## Out of Scope

- Support for editing or configuring non-mcp sections of `config.toml` (e.g. we will not parse or modify model names, theme selections, or trusted projects—these are treated as read-only and preserved as-is).
- General-purpose TOML parsing (our parser is strictly optimized for splicing the `[mcp_servers]` blocks).

## Further Notes

- The utility maintains zero dependencies, leveraging lightweight, built-in JavaScript patterns to achieve outstanding execution performance.

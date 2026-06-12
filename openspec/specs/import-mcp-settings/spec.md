# import-mcp-settings Specification

## Purpose
TBD - created by archiving change import-mcp-settings. Update Purpose after archive.
## Requirements
### Requirement: Merge MCP Settings
The system SHALL read MCP settings from `~/.gemini/settings.json` and merge them into:
- `~/.gemini/antigravity-ide/mcp_config.json` (Antigravity IDE)
- `~/.gemini/antigravity/mcp_config.json` (Antigravity)
- `~/.gemini/config/mcp_config.json` (Antigravity CLI / Gemini Config)

without destroying existing custom settings.

#### Scenario: Syncing configurations when files exist
- **WHEN** the sync tool is executed
- **THEN** the settings from `~/.gemini/settings.json`'s `mcpServers` object are merged into the respective target `mcpServers` objects, overriding existing keys on collision and preserving non-colliding keys.

### Requirement: Create Target Configuration If Missing
The system SHALL create any target directories and `mcp_config.json` files if they do not exist.

#### Scenario: Syncing when a target file or directory is missing
- **WHEN** the sync tool is executed and any of the target files do not exist
- **THEN** the system creates the missing parent directory and writes a valid JSON file containing the imported `mcpServers`.



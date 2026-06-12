## ADDED Requirements

### Requirement: Merge MCP Settings
The system SHALL read MCP settings from `~/.gemini/settings.json` and merge them into `~/.gemini/antigravity-ide/mcp_config.json` without destroying existing custom settings.

#### Scenario: Syncing configurations when both files exist
- **WHEN** the sync tool is executed
- **THEN** the settings from `~/.gemini/settings.json`'s `mcpServers` object are merged into `~/.gemini/antigravity-ide/mcp_config.json`'s `mcpServers` object, overriding existing keys on collision and preserving non-colliding keys.

### Requirement: Create Target Configuration If Missing
The system SHALL create the target directory and the `mcp_config.json` file if they do not exist.

#### Scenario: Syncing when target file or directory is missing
- **WHEN** the sync tool is executed and `~/.gemini/antigravity-ide/mcp_config.json` does not exist
- **THEN** the system creates the parent directory and writes a valid JSON file containing the imported `mcpServers`.

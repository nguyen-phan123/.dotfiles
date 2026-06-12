## 1. Implementation

- [x] 1.1 Create the Node.js sync script at `shell/zsh/.sync-mcp.js` to parse, merge, and write MCP settings.
- [x] 1.2 Update the `mcpsync()` function in `shell/zsh/.zsh_profile` to reference `$HOME/.sync-mcp.js`.

## 2. Verification

- [x] 2.1 Run `./install.sh --only zsh` to stow the new script and updated Zsh configuration.
- [x] 2.2 Execute `mcpsync` to verify that MCP settings are merged from `~/.gemini/settings.json` into `~/.gemini/antigravity-ide/mcp_config.json`.

## Why

Powerlevel10k is a legacy Zsh theme configuration. The repository is migrating towards Starship as the primary, cross-shell prompt in the **Global Scope**. We need to deprecate and clean up any remaining Powerlevel10k configurations to prevent conflicts and ensure a modern, unified terminal experience.

## What Changes

- Disable and remove active references to Powerlevel10k from shell configurations in the **Stow Package** `zsh`.
- Confirm that Starship prompt initialization is active and optimized in `shell/zsh/.zsh_profile`.
- Remove the legacy `~/.p10k.zsh` configuration file to prevent prompt confusion.

## Non-goals

- Customizing Starship configuration settings or theme colors.
- Uninstalling Oh-My-Zsh or other shell plugins.

## Capabilities

### New Capabilities
- `zsh-starship-theme`: Implement a unified zsh environment configured to load the Starship prompt natively, fully replacing Powerlevel10k.

### Modified Capabilities

## Impact

- Affected files in the **Stow Package** `zsh`: `shell/zsh/.zshrc` and `shell/zsh/.zsh_profile`.
- User home directory file: `~/.p10k.zsh` (deleted).

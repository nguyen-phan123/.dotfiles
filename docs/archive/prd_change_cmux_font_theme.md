# Product Requirement Document (PRD): Change cmux Font and Theme

## Problem Statement

The current terminal emulator configurations for `cmux` (which shares the rendering engine of Ghostty) use "MesloLGS Nerd Font" and "Catppuccin Mocha" theme. The developer wants to switch the primary coding font to "JetBrains Mono" and the color theme to "Gruvbox Dark" for better readability and eye comfort during long coding sessions.

Since `cmux` uses `libghostty` internally, these styling settings are configured in the Ghostty configuration file and managed via GNU Stow inside this dotfiles repository.

## Solution

Modify the primary Ghostty configuration file inside the dotfiles repository to update the font family and theme properties, and then reinstall the configuration using GNU Stow:
- Update `font-family` to `"JetBrains Mono"`.
- Update `theme` to `"gruvbox-dark"`.
- Reinstall symlinks using the `./install.sh` script.

## User Stories

1. As a developer, I want my cmux terminal panes to render using JetBrains Mono font so that source code text is clean and highly readable.
2. As a developer, I want the theme of my terminal to be Gruvbox Dark to reduce eye strain.
3. As a developer, I want these settings persisted in my dotfiles git repository so they are safe and shareable.

## Implementation Decisions

### 1. Modifying Ghostty Configuration file
- File: [terminal/ghostty/.config/ghostty/config](file:///Users/diqit/Documents/GitHub/config/dotfiles/terminal/ghostty/.config/ghostty/config)
- Change line 6:
  ```ini
  font-family = "MesloLGS Nerd Font"
  ```
  to:
  ```ini
  font-family = "JetBrains Mono"
  ```
- Change line 8:
  ```ini
  theme = "Catppuccin Mocha"
  ```
  to:
  ```ini
  theme = "gruvbox-dark"
  ```

### 2. Deploying Configurations
- Run `./install.sh` from the dotfiles repository root to ensure the changes are stowed and symlinked to `~/.config/ghostty/config`.

## Verification Plan

### Manual Verification
- Launch `cmux` or press `Cmd + Shift + ,` (Comma) to reload the configuration.
- Verify that the font has changed to JetBrains Mono.
- Verify that the terminal theme colors match Gruvbox Dark.

# Issue #0006: Adaptive Terminal Theme Configuration

**Status**: Closed
**Labels**: ready-for-agent, enhancement

## Description

### Problem Statement

The user's terminal theme (primarily Ghostty and cmux) does not automatically adapt to macOS system light/dark mode changes. Currently, theme switching requires manual execution of the `theme-switch.sh` script or using shell aliases (`theme-light` / `theme-dark`). This causes visual friction and manual overhead when moving between bright office environments and low-light settings.

### Solution

Configure terminal applications (Ghostty and cmux) to natively track and adapt to the macOS system appearance:
1. Update Ghostty configuration to use native light/dark theme mapping (`theme = light:GitHub Light High Contrast,dark:Solarized Dark Patched`).
2. Update cmux configuration to use system appearance detection (`"appearance": "system"`).
3. Align `theme-switch.sh` to prevent conflict or adapt it as a manual override fallback.

### User Stories

1. As a developer, I want my terminal emulator (Ghostty) to automatically switch its color scheme when macOS toggles between light and dark mode, so that I don't have to run manual command scripts.
2. As a developer with nearsightedness, I want to use high-contrast GitHub Light High Contrast during the day and Solarized Dark Patched at night, so that I maintain optimal eye comfort.
3. As a terminal multiplexer user, I want cmux to automatically match the system appearance, so that window frames and UI boundaries match the OS style.
4. As a developer, I want the theme transition to be seamless and apply instantly without requiring a full restart of active shell sessions or terminal windows.

### Implementation Decisions

- **Ghostty Config**: Update `terminal/ghostty/.config/ghostty/config` to use native adaptive settings:
  ```
  theme = light:GitHub Light High Contrast,dark:Solarized Dark Patched
  ```
- **Unified Opacity**: Since background opacity cannot be dynamically conditional inside a single Ghostty config natively, we will standardize on `background-opacity = 0.95` or `background-opacity = 1.0` across modes, or keep it consistent at `0.98` to reduce glare while keeping text legible. We will choose `background-opacity = 0.95` as the baseline.
- **Cmux Config**: Update `terminal/cmux/.config/cmux/cmux.json` to:
  ```json
  "app": {
    "appearance": "system"
  }
  ```
- **Symlinks & Stow**: Clean up the static file symlinking mechanism in `install.sh` for Ghostty/cmux configs if they are now merged into a single adaptive configuration.

### Testing Decisions

- Verify OS-level theme adaptation:
  1. Set macOS to Light Mode -> Verify Ghostty matches GitHub Light High Contrast and cmux matches Light theme.
  2. Set macOS to Dark Mode -> Verify Ghostty matches Solarized Dark Patched and cmux matches Dark theme.
- Ensure active terminal multiplexer panes do not freeze or crash during theme transition.

### Out of Scope

- Synchronous automatic hot-reloading of LunarVim (`lvim`) color schemes based on OS theme changes, as text editors running inside terminal shells don't natively receive macOS system appearance change events unless complex background shell hooks are set up.

## Comments

- **Comment by Antigravity**: Initial PRD generated based on codebase analysis and user request to make the terminal theme adaptive to the system.

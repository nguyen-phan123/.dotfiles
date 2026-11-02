# Issue #0007: Ghostty Native Adaptive Theme Configuration

**Status**: Closed
**Labels**: ready-for-agent, enhancement

## Description

## Parent

- [Issue #0006](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/issues/0006-adaptive-terminal-theme.md)

## What to build

Consolidate Ghostty configurations so that Ghostty natively adapts its theme to macOS system light/dark mode transitions. Instead of having separate `config.light` and `config.dark` files swapped by a script, we should use a single config file that maps the system appearance state to their corresponding themes. Keep font size, family, layouts, and other custom settings unchanged, and find a balanced background opacity.

## Acceptance criteria

- [ ] Ghostty config uses the `theme = light:GitHub Light High Contrast,dark:Solarized Dark Patched` native syntax.
- [ ] Changing macOS system appearance automatically toggles the Ghostty theme without restarting the application or any terminal sessions.
- [ ] Background opacity is set to a stable default (e.g. `0.95`).
- [ ] Config files are stowed correctly in user directory.

## Blocked by

None - can start immediately.

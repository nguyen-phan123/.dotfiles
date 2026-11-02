# Issue #0009: Theme Switching Script and Shell Cleanup

**Status**: Closed
**Labels**: ready-for-agent, enhancement

## Description

## Parent

- [Issue #0006](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/issues/0006-adaptive-terminal-theme.md)

## What to build

Clean up and adapt the shell commands and scripts associated with manual theme switching. Since Ghostty and cmux now adapt automatically, the `theme-switch.sh` script does not need to recreate symlinks for them. Update the script to only manage LunarVim configuration (if desired) or simplify it, and clean up or adapt the shell aliases in `zsh_profile`.

## Acceptance criteria

- [ ] Script `theme-switch.sh` no longer fails or attempts to overwrite Ghostty or cmux configurations dynamically with symlinks.
- [ ] LunarVim theme switching behaves correctly and is not broken by the updates.
- [ ] Clean up redundant shell aliases or document the new adaptive configuration in `README.md` and `theme-switch.sh` help output.

## Blocked by

- [Issue #0007](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/issues/0007-ghostty-adaptive-theme.md)
- [Issue #0008](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/issues/0008-cmux-system-appearance.md)

# Issue #0008: Cmux System Appearance Configuration

**Status**: Closed
**Labels**: ready-for-agent, enhancement

## Description

## Parent

- [Issue #0006](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/issues/0006-adaptive-terminal-theme.md)

## What to build

Update the cmux multiplexer config to use system appearance sync. Instead of holding hardcoded `light` or `dark` appearances in separate configurations, default the layout configuration to track OS settings natively.

## Acceptance criteria

- [ ] Cmux configuration `cmux.json` uses `"appearance": "system"`.
- [ ] Transitioning macOS appearance updates the cmux visual boundaries, tabs, and panels immediately.

## Blocked by

None - can start immediately.

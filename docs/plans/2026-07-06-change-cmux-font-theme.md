# Change cmux Font and Theme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Change primary font to JetBrains Mono and theme to Gruvbox Dark for Ghostty and cmux.

**Architecture:** Modify the stowed Ghostty configuration file inside the dotfiles repository and run Stow installation script to update the system symlink.

**Tech Stack:** GNU Stow, Ghostty config syntax.

## Global Constraints

- Modify only configuration files, no source code changes.
- Ensure GNU Stow runs cleanly to symlink config directories.

---

### Task 1: Update Ghostty configuration file

**Files:**
- Modify: [terminal/ghostty/.config/ghostty/config](file:///Users/diqit/Documents/GitHub/config/dotfiles/terminal/ghostty/.config/ghostty/config#L6-L8)

**Interfaces:**
- Consumes: None
- Produces: Updated configuration values in `terminal/ghostty/.config/ghostty/config`

- [ ] **Step 1: Modify font-family and theme**

Update [config](file:///Users/diqit/Documents/GitHub/config/dotfiles/terminal/ghostty/.config/ghostty/config) (specifically lines 6-8):
```ini
font-family = "JetBrains Mono"
theme = "gruvbox-dark"
```

- [ ] **Step 2: Commit local configuration changes**

```bash
git add terminal/ghostty/.config/ghostty/config
git commit -m "feat(ghostty): change font to JetBrains Mono and theme to Gruvbox Dark"
```

---

### Task 2: Apply Stow symlinks and Verify

**Files:**
- Modify: None
- Test: Run terminal verification

**Interfaces:**
- Consumes: Updated configuration from Task 1.
- Produces: System-wide updated Ghostty/cmux styling.

- [ ] **Step 1: Execute dotfiles install script**

Run: `./install.sh` from the workspace root directory.
Expected output: GNU Stow links the directories correctly, linking `terminal/ghostty/.config/ghostty` to `~/.config/ghostty`.

- [ ] **Step 2: Verify in cmux**

Open or reload config in `cmux` (`Cmd + Shift + ,`). Check visually if font has changed to JetBrains Mono and theme has changed to Gruvbox Dark.

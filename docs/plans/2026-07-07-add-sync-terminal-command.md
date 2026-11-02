# Add sync:terminal Script and Alias Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a `package.json` script and a Zsh alias `termsync` to allow fast, non-blocking synchronization of Ghostty and cmux configurations.

**Architecture:** Add a new script inside the dotfiles `package.json` and a corresponding alias in `.zsh_profile`.

**Tech Stack:** Node.js, Zsh, GNU Stow.

## Global Constraints

- Modify only configuration files and shell profiles, no core source changes.
- Ensure Zsh alias resolves correctly with `$HOME` without hardcoding paths.

---

### Task 1: Update package.json scripts

**Files:**
- Modify: [package.json](file:///Users/diqit/Documents/GitHub/config/dotfiles/package.json#L24-L26)

**Interfaces:**
- Consumes: None
- Produces: `sync:terminal` npm script.

- [ ] **Step 1: Add sync:terminal script**

Add the script inside the "scripts" block of `package.json`:
```json
"sync:terminal": "./install.sh --only ghostty cmux && echo '\\n✨ Cấu hình đã được sync! Nhấn Cmd+Shift+, trong cmux/Ghostty để reload.'"
```

- [ ] **Step 2: Commit package.json changes**

```bash
git add package.json
git commit -m "feat(package): add sync:terminal script"
```

---

### Task 2: Add shell alias to Zsh profile

**Files:**
- Modify: [shell/zsh/.zsh_profile](file:///Users/diqit/Documents/GitHub/config/dotfiles/shell/zsh/.zsh_profile#L240-L243)

**Interfaces:**
- Consumes: `sync:terminal` npm script.
- Produces: `termsync` Zsh alias.

- [ ] **Step 1: Append alias to .zsh_profile**

Append this line to `shell/zsh/.zsh_profile`:
```bash
alias termsync="pnpm --prefix \$HOME/Documents/GitHub/config/dotfiles sync:terminal"
```

- [ ] **Step 2: Stow and Commit changes**

Run Stow command or install command:
```bash
./install.sh --only zsh
```
Commit Zsh profile changes:
```bash
git add shell/zsh/.zsh_profile
git commit -m "feat(zsh): add termsync alias for cmux/ghostty sync"
```

---

### Task 3: Verification

**Files:**
- Modify: None
- Test: Verify Zsh alias and execution

- [ ] **Step 1: Verify command execution**

Source the Zsh profile or open a new terminal:
```bash
source ~/.zsh_profile
```
Run the new alias:
```bash
termsync
```
Verify that the output displays the reload message and syncs successfully.

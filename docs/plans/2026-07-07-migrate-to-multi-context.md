# Migrate to Multi-Context Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the dotfiles domain documentation from a single-context to a multi-context layout (Core, Shell, Terminal).

**Architecture:** Create CONTEXT-MAP.md, sub-context files, update domain.md configuration, and update CLAUDE.md.

**Tech Stack:** Markdown, Git.

## Global Constraints

- Keep domain term definitions accurate and consistent with the existing CONTEXT.md.
- Ensure all links are absolute file:// links inside the workspace.

---

### Task 1: Create CONTEXT-MAP.md

**Files:**
- Create: [CONTEXT-MAP.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/CONTEXT-MAP.md)

**Interfaces:**
- Consumes: None
- Produces: `CONTEXT-MAP.md` mapping file.

- [ ] **Step 1: Write CONTEXT-MAP.md**

Write the following content to `CONTEXT-MAP.md`:
```markdown
# 🗺️ Dotfiles Context Map (CONTEXT-MAP.md)

This map defines the domains and contexts within the dotfiles repository.

- **Core Ecosystem**: [CONTEXT.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/CONTEXT.md)
  - Core dotfiles architecture, scopes, Stow packages, and Precedence Order.
- **Shell Environment**: [shell/CONTEXT.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/shell/CONTEXT.md)
  - Shell preferences, aliases, profile logic, and path configurations.
- **Terminal Configurations**: [terminal/CONTEXT.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/terminal/CONTEXT.md)
  - Ghostty, tmux, zellij, and cmux configurations.
```

- [ ] **Step 2: Commit CONTEXT-MAP.md**

```bash
git add CONTEXT-MAP.md
git commit -m "feat(domain): add CONTEXT-MAP.md"
```

---

### Task 2: Create Sub-Context Files

**Files:**
- Create: [shell/CONTEXT.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/shell/CONTEXT.md)
- Create: [terminal/CONTEXT.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/terminal/CONTEXT.md)

**Interfaces:**
- Consumes: `CONTEXT-MAP.md`
- Produces: `shell/CONTEXT.md` and `terminal/CONTEXT.md` files.

- [ ] **Step 1: Write shell/CONTEXT.md**

Write the following content:
```markdown
# 🐚 Shell Environment Context (shell/CONTEXT.md)

Domain vocabulary for shell-specific configs (Zsh, Oh My Zsh, aliases).

## Vocabulary & Core Concepts

### 🐚 Zsh Profile
*   **Definition**: The primary user profile configuration file (`.zsh_profile`) mapped via Stow to `$HOME/.zsh_profile` storing aliases, paths, functions.
*   **Target terms**: Use **Zsh Profile**.

### 🔗 Stow link (shell)
*   **Definition**: Configuration files under `shell/zsh/` stowed as symlinks in the home directory.
*   **Target terms**: Use **Stow link (shell)**.
```

- [ ] **Step 2: Write terminal/CONTEXT.md**

Write the following content:
```markdown
# 🖥️ Terminal Configurations Context (terminal/CONTEXT.md)

Domain vocabulary for terminal multiplexers and emulators (Ghostty, cmux, tmux).

## Vocabulary & Core Concepts

### 👻 Ghostty Config
*   **Definition**: The styling, theme, and font properties configured for Ghostty and cmux under `terminal/ghostty/.config/ghostty/config`.
*   **Target terms**: Use **Ghostty Config**.

### 🖥️ Multiplexer pane
*   **Definition**: Terminal split panes managed by cmux, tmux, or zellij.
*   **Target terms**: Use **Multiplexer pane**.
```

- [ ] **Step 3: Commit sub-context files**

```bash
git add shell/CONTEXT.md terminal/CONTEXT.md
git commit -m "feat(domain): add shell and terminal sub-contexts"
```

---

### Task 3: Update configuration and CLAUDE.md

**Files:**
- Modify: [docs/agents/domain.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/agents/domain.md)
- Modify: [CLAUDE.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/CLAUDE.md#L156-L159)

**Interfaces:**
- Consumes: Sub-context files and `CONTEXT-MAP.md`.
- Produces: Updated configurations indicating multi-context layout.

- [ ] **Step 1: Update docs/agents/domain.md**

Modify [domain.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/agents/domain.md) to set multi-context layout as active and update documentation rules.

- [ ] **Step 2: Update CLAUDE.md**

Modify `CLAUDE.md` to reference `multi-context` layout.

- [ ] **Step 3: Commit updates and verify**

```bash
git add docs/agents/domain.md CLAUDE.md
git commit -m "feat(domain): configure multi-context domain rules"
```

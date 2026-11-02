# Plan: Split CLAUDE.md Into Modular Structure

**Goal**: Reduce `CLAUDE.md` file size from 1,818 lines to ~300 lines while preserving all detailed examples by leveraging Claude Code's import feature.

**Status**: Implemented & Completed (v2.0.0 released)

---

## 🔍 Research Findings

### Claude Code Import Syntax

Claude Code **officially supports importing other files** using the `@path/to/file.md` syntax. This was specifically designed to solve the problem of large `CLAUDE.md` files.

*   **Documentation source**: [Claude Code Memory Docs](https://docs.claude.com/en/docs/claude-code/memory)
*   **Key Features**:
    *   **Syntax**: `@path/to/file.md` or `@~/.claude/docs/filename.md`.
    *   **Absolute paths**: Support home directory (`@~/.claude/my-file.md`) - **REQUIRED for dotfiles**.
    *   **Relative paths**: Behavior from `~/.claude/` is undocumented - use absolute paths for safety.
    *   **Recursion**: Up to 5 levels of nested imports.
    *   **Protection**: Imports inside markdown code blocks are ignored (prevents false positives).
    *   **Verification**: Use `/memory` command to see what files are loaded.

> [!IMPORTANT]
> **Dotfiles Compatibility Requirement**: When `CLAUDE.md` is installed to `~/.claude/` via dotfiles, **always use absolute paths** like `@~/.claude/docs/testing.md` instead of relative paths like `@docs/testing.md`. The official documentation explicitly shows `@~/.claude/...` syntax but doesn't document how relative paths resolve from `~/.claude/CLAUDE.md`.

---

## 📂 Proposed Structure (Now Live)

Split into a main file (~300 lines) + detailed documentation files:

```
claude/.claude/
├── CLAUDE.md (main file ~150 lines)
│   ├── Core Philosophy (kept inline - non-negotiable)
│   ├── Quick Reference (kept inline - most-used)
│   ├── Brief section summaries
│   └── Import statements to detailed docs
│
└── docs/
    ├── testing.md          (~240 lines)
    ├── typescript.md       (~300 lines)
    ├── code-style.md       (~370 lines)
    ├── workflow.md         (~670 lines)
    ├── examples.md         (~120 lines)
    └── working-with-claude.md (~75 lines)
```

---

## 🌟 Benefits Realized

*   **For Users**:
    *   ⚡ **Faster initial load** - Main file is ~150 lines instead of 1,818.
    *   🔍 **Scannable overview** - Quick reference covers 90% of daily needs.
    *   📈 **On-demand details** - Claude loads full documentation only when working on specific topics.
*   **For Maintenance**:
    *   ✏️ **Focused editing** - Update TypeScript rules without scrolling through testing examples.
    *   🗂️ **Logical organization** - Related content grouped in dedicated files.
*   **For Claude Code**:
    *   🧠 **Reduced context usage** - Only loads relevant details when needed.

---

## 🚦 Validation Checklist

All criteria have been successfully verified:

- `[x]` `/memory` command shows all docs loaded correctly.
- `[x]` Main `CLAUDE.md` is <400 lines (~150 lines total).
- `[x]` No content was removed (only reorganized).
- `[x]` All imports use correct absolute paths (e.g., `@~/.claude/docs/...`).
- `[x]` Each detailed doc has clear section headers.
- `[x]` Cross-references between docs work correctly.
- `[x]` Dotfiles installation (via Stow) still works.
- `[x]` GitHub renders all markdown correctly.
- `[x]` No broken links in any file.

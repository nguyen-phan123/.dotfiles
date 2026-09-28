# 🖥️ Terminal Configurations Context (terminal/CONTEXT.md)

Domain vocabulary for terminal multiplexers and emulators (Ghostty, cmux, tmux).

## Vocabulary & Core Concepts

### 👻 Ghostty Config
*   **Definition**: The styling, theme, and font properties configured for Ghostty and cmux under `terminal/ghostty/.config/ghostty/config`.
*   **Target terms**: Use **Ghostty Config**.

### 🖥️ Multiplexer pane
*   **Definition**: Terminal split panes managed by cmux, tmux, or zellij.
*   **Target terms**: Use **Multiplexer pane**.

### 🖥️ cmux Terminal
*   **Definition**: Terminal multiplexer workspace integrating Ghostty font, palette, and keybindings into macOS native tabbed windows.
*   **Target terms**: Use **cmux Terminal** or **cmux**.

### 🔄 Terminal Sync Script (`pnpm sync:terminal`)
*   **Definition**: Task script that synchronizes Ghostty & cmux configurations without requiring manual terminal restarts.
*   **Target terms**: Use **Terminal Sync Script**.

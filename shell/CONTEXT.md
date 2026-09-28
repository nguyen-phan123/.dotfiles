# 🐚 Shell Environment Context (shell/CONTEXT.md)

Domain vocabulary for shell-specific configs (Zsh, Oh My Zsh, aliases).

## Vocabulary & Core Concepts

### 🐚 Zsh Profile
*   **Definition**: The primary user profile configuration file (`.zsh_profile`) mapped via Stow to `$HOME/.zsh_profile` storing aliases, paths, functions.
*   **Target terms**: Use **Zsh Profile**.

### 🔗 Stow link (shell)
*   **Definition**: Configuration files under `shell/zsh/` stowed as symlinks in the home directory.
*   **Target terms**: Use **Stow link (shell)**.

### 🔐 Zsh Local Profile (`.zshrc.local`)
*   **Definition**: Machine-local, unversioned Zsh profile template for storing machine-specific environment variables, secrets, and API tokens.
*   **Target terms**: Use **Zsh Local Profile**.
*   **Avoid**: *Local zshrc*, *machine config*.

### ⚡ RTK Zsh Hook
*   **Definition**: Automatic shell integration that rewrites interactive terminal commands (e.g. `git status` -> `rtk git status`) for token savings.
*   **Target terms**: Use **RTK Zsh Hook**.

### 🎨 Starship Preset
*   **Definition**: Custom Starship prompt configuration files stored in `shell/zsh/.config/starship/presets/`.
*   **Target terms**: Use **Starship Preset**.

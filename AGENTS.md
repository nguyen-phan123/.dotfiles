# 🧠 Agent Workspace Memory (AGENTS.md)

Welcome to the **Dotfiles & Agent Ecosystem** repository. This memory file defines the code style, commands, workflows, and standards enforced across this workspace.

---

## 1. 🛠️ Commands & Tooling

Standard scripts and task runner commands:

| Command | Action | Description |
| :--- | :--- | :--- |
| `pnpm install` | Install deps | Installs development tools and changesets dependencies. |
| `pnpm test` | Run tests | Runs unit tests for configuration scripts and helper functions. |
| `pnpm lint` | Code linting | Checks formatting of scripts, JSON, and yaml configurations. |
| `./install.sh` | Symlink stow | Installs all packages using GNU Stow dynamically to `$HOME`. |

---

## 2. 📝 Code Style & Guidelines

Ensure maximum compatibility and clean code when writing configuration files and scripts:

### Zsh & Shell Scripting
*   **Safety Headers**: Always use `set -euo pipefail` at the start of all helper shell scripts.
*   **Variable Scope**: Use `local` variables inside shell functions to avoid polluting environment namespaces.
*   **Cross-Platform Paths**: Avoid hardcoded home directory paths (`/Users/username`); always use the `$HOME` or `~` environment variables.

### Configuration Formatting
*   **Strict JSON/YAML**: Ensure no trailing commas in JSON files (e.g., `.vscode/settings.json`), and adhere to 2-space indentation for YAML configurations.
*   **Clean Aliases**: Group aliases logically by application/tool inside [shell/zsh/.zsh_profile](file:///Users/diqit/Documents/GitHub/config/dotfiles/shell/zsh/.zsh_profile).

---

## 3. ⚙️ Tooling Configuration

*   **GNU Stow Structure**: Standard configuration folders are categorized under parent directories like [coding/](file:///Users/diqit/Documents/GitHub/config/dotfiles/coding/), [shell/](file:///Users/diqit/Documents/GitHub/config/dotfiles/shell/), [system/](file:///Users/diqit/Documents/GitHub/config/dotfiles/system/), and [terminal/](file:///Users/diqit/Documents/GitHub/config/dotfiles/terminal/). Stow maps these directly to `$HOME`.
*   **Changesets**: Package versioning is automated using Changesets. Do not bump versions manually in `package.json`.

---

## 🐙 4. Git Workflows & Commit Format

*   **Format**: Use standard angular-style prefix formatting: `<type>(<scope>): <subject>` (e.g., `feat(install): add support for machine-local configurations`).
*   **Token Protection**: Never check in secrets (e.g., API keys, client secrets). All local configs must be gitignored or managed through template files like `.zshrc.local.example`.

---

## 🤖 5. Agent Workflows & Skills

### Available Slash Commands
*   `/goal`: Use when launching long-running automated optimization cycles.
*   `/schedule`: Set timers or recurring background tasks.
*   `/grill-me`: Engage in an interactive query loop to stress-test your design decisions before writing code.

### Domain Documentation & Contexts
*   **Issue Tracker**: Log tickets and progress inside GitHub Issues using the `gh` CLI. See [issue-tracker.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/agents/issue-tracker.md).
*   **Domain docs**: Check [domain.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/agents/domain.md) and [CONTEXT.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/CONTEXT.md) for terminology mappings and architectural constraints.

# 🌐 Dotfiles & Agent Ecosystem Context (CONTEXT.md)

Personal dotfiles repository designed to configure shell utilities, development environments, and integrate system-wide AI coding agents.

---

## 📖 Vocabulary & Core Concepts

### 📂 Workspace-Local Scope
*   **Definition**: Configurations, commands, and skills that are strictly specific to a single repository workspace. These tools are tailored for developing that specific project and are untracked by global environment configuration.
*   **Target terms**: Use **Workspace-Local Scope**.
*   **Avoid**: *Local config*, *project setup*.

### 🌍 Global Scope
*   **Definition**: System-wide configurations and tools stowed into the user's home directory (`$HOME`) to be shared across all development projects on the machine.
*   **Target terms**: Use **Global Scope**.
*   **Avoid**: *Machine settings*, *global env*.

### 📦 Stow Package
*   **Definition**: A logical directory grouped under a category folder in the `dotfiles/` root (e.g., `coding/lvim/`) that is stowed dynamically into `$HOME` via GNU Stow.
*   **Target terms**: Use **Stow Package**.
*   **Avoid**: *Symlink bundle*, *flat stow*.

### ⚖️ Precedence Order
*   **Definition**: The resolution hierarchy where workspace-local agent skills and configurations absolutely overshadow stowed global configurations, ensuring that repository-specific automations do not leak or contaminate unrelated development directories (Skills Isolation).
*   **Target terms**: Use **Precedence Order**.
*   **Avoid**: *Configuration leakage*, *global overshadowing*.

---

## 💬 Example Dialogue

> [!NOTE]
> Below is an example workflow showing how to discuss scoped configurations within the dotfiles ecosystem.

> **Developer**: *"I want to add a new command to my dotfiles workspace so that I can automate PR reviews for this repo."*
>
> **Domain Expert**: *"Since that automation is unique to this repository, you should put it under **Workspace-Local Scope** in `.gemini/` at the root. Do not put it under the **Global Scope** inside `agent/` so it doesn't clutter other workspaces."*
>
> **Developer**: *"Ah, got it! And if I want all my global agents to use this skill, I can leverage the **Double Symlink** pattern."*

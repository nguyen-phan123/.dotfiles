## Context

The system has a legacy prompt configuration (Powerlevel10k) which needs to be completely removed. We have a working Starship setup in `.zsh_profile` that must act as the sole prompt configuration. Any references to Powerlevel10k must be cleaned up to ensure idempotency and reliability during installation and daily usage.

## Goals / Non-Goals

**Goals:**
- Clean up legacy `.p10k.zsh` config file.
- Verify and enforce Starship initialization in the active zsh environment.
- Confirm there are no leftovers of p10k in the dotfiles code.

**Non-Goals:**
- Customizing Starship look-and-feel or prompt layout.

## Decisions

### Decision 1: Safe deletion of legacy `.p10k.zsh`
- **Rationale**: Keeping `.p10k.zsh` in `$HOME` is confusing and can cause conflict if Oh-My-Zsh is modified to point to it.
- **Action**: Modify `install.sh` to remove `~/.p10k.zsh` if it exists, or just delete it as a one-off action during installation/migration.

## Risks / Trade-offs

- **Risk**: User loses customized p10k configurations.
- **Mitigation**: Backup the `~/.p10k.zsh` to the backup directory established in `install.sh` before deletion.

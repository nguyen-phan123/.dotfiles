## ADDED Requirements

### Requirement: Synchronize Central Skills to Targets
The system SHALL read the skills (symlinks or directories) configured in `~/.gemini/skills/` and synchronize them into the respective target folders:
- `~/.gemini/antigravity-ide/skills/`
- `~/.gemini/antigravity/skills/`
- `~/.gemini/config/skills/`

#### Scenario: Syncing central skills to all targets
- **WHEN** the sync tool is executed
- **THEN** it reads the contents of `~/.gemini/skills/` and ensures every active skill has a corresponding symlink in all three destination folders pointing to the actual skill's original source path.

### Requirement: Prune Outdated or Broken Symlinks from Targets
The system SHALL delete broken symlinks or any symlinks in the target folders that do not match the active skills in the central `~/.gemini/skills/` directory.

#### Scenario: Syncing when target folders have obsolete symlinks
- **WHEN** the sync tool is executed
- **THEN** it identifies symlinks in the target folders that do not exist in `~/.gemini/skills/` or are broken, and removes them.

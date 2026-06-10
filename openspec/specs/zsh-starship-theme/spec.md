# zsh-starship-theme Specification

## Purpose
TBD - created by archiving change migrate-starship. Update Purpose after archive.
## Requirements
### Requirement: Initialize Starship Prompt
The shell configuration MUST initialize Starship prompt correctly in the interactive Zsh shell.

#### Scenario: Load Zsh shell session
- **WHEN** user starts a new interactive zsh shell
- **THEN** the Starship prompt is rendered and no Powerlevel10k prompts or files are loaded

### Requirement: Purge Powerlevel10k configuration
The shell configuration and the installer SHALL NOT load or reference Powerlevel10k theme or its helper files, and legacy configurations MUST be cleaned up.

#### Scenario: Stow package configuration deployment
- **WHEN** the user runs `install.sh` to link or restow the zsh config
- **THEN** legacy `.p10k.zsh` configuration file is removed from `$HOME`


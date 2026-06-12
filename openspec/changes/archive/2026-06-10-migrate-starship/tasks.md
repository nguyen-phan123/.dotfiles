## 1. Clean up Legacy Powerlevel10k Configurations

- [x] 1.1 Remove or modify configuration references to Powerlevel10k in `shell/zsh/.zshrc`.
- [x] 1.2 Update `install.sh` to safely clean up and back up legacy `~/.p10k.zsh` if it exists.
- [x] 1.3 Physically remove the `~/.p10k.zsh` file from the host machine (ensuring it is backed up).

## 2. Enforce and Verify Starship Integration

- [x] 2.1 Verify `eval "$(starship init zsh)"` is loaded in `shell/zsh/.zsh_profile`.
- [x] 2.2 Run `./install.sh` to deploy the updated stow configuration.
- [x] 2.3 Verify zsh startup and test that the Starship prompt is active and functional.

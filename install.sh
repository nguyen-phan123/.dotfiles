#!/bin/bash
set -e

# Setup paths
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Configuration
GPG_AGENT_CONF=system/gnupg/.gnupg/gpg-agent.conf
ALL_PACKAGES=(zsh tmux gnupg zellij .oh-my-zsh karabiner ghostty nvim lvim cmux pip)

# Parse arguments
ONLY_PACKAGES=()
RUN_DEPS=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--deps)
      RUN_DEPS=true
      shift
      ;;
    --only)
      shift
      while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
        ONLY_PACKAGES+=("$1")
        shift
      done
      ;;
    --list)
      echo "Available packages:"
      for pkg in "${ALL_PACKAGES[@]}"; do
        echo "  - $pkg"
      done
      exit 0
      ;;
    --help|-h)
      cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d, --deps       Automatically install binary dependencies and plugins first
  --only <pkg...>  Only restow specific packages (e.g., --only zsh lvim)
  --list           List all available packages
  --help, -h       Show this help

Examples:
  $0                    # Full install (all packages)
  $0 --deps             # Install dependencies first, then stow all configs
  $0 --only zsh         # Only re-link zsh config
EOF
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1 (use --help)"
      exit 1
      ;;
  esac
done


# Determine which packages to install
if [[ ${#ONLY_PACKAGES[@]} -gt 0 ]]; then
  # Validate packages
  for pkg in "${ONLY_PACKAGES[@]}"; do
    if [[ ! " ${ALL_PACKAGES[*]} " =~ " ${pkg} " ]]; then
      echo "❌ Unknown package: $pkg (use --list to see available)"
      exit 1
    fi
  done
  PACKAGES=("${ONLY_PACKAGES[@]}")
  echo "🎯 Partial install: ${PACKAGES[*]}"
else
  PACKAGES=("${ALL_PACKAGES[@]}")
  echo "🚀 Full install: all packages"
fi

# Run dependency installation if requested or missing critical requirements
check_cmd() {
  command -v "$1" &>/dev/null
}

get_dependencies() {
  case "$1" in
    zsh|.oh-my-zsh) echo "starship zoxide bat eza fzf" ;;
    nvim)           echo "ripgrep fd" ;;
    lvim)           echo "lvim" ;;
  esac
}

REQUIRED_DEPS=()
# Always require stow for stowing packages
REQUIRED_DEPS+=("stow")

for pkg in "${PACKAGES[@]}"; do
  for dep in $(get_dependencies "$pkg"); do
    if [[ ! " ${REQUIRED_DEPS[*]} " =~ " ${dep} " ]]; then
      REQUIRED_DEPS+=("$dep")
    fi
  done
done

MISSING_DEPS=()
for dep in "${REQUIRED_DEPS[@]}"; do
  if ! check_cmd "$dep"; then
    MISSING_DEPS+=("$dep")
  fi
done

if [[ "$RUN_DEPS" == true ]]; then
  echo "📦 Triggering automated dependency installation..."
  bash "$DOTFILES_DIR/scripts/install-deps.sh" "${REQUIRED_DEPS[@]}"
elif [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
  echo -e "\033[1;33m⚠️ WARNING: Some critical system dependencies are missing: ${MISSING_DEPS[*]}\033[0m"
  read -p "Would you like to install them automatically now? [y/N] " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    bash "$DOTFILES_DIR/scripts/install-deps.sh" "${MISSING_DEPS[@]}"
  else
    echo "⚠️ Proceeding without installing missing dependencies. Linking might fail if stow is missing."
  fi
fi


# 1. Setup specific configurations (only when relevant package is included)
should_setup() {
  local pkg="$1"
  [[ ${#ONLY_PACKAGES[@]} -eq 0 ]] || [[ " ${ONLY_PACKAGES[*]} " =~ " ${pkg} " ]]
}

if should_setup "gnupg"; then
  mkdir -p system/gnupg/.gnupg
  if ! grep -q "pinentry-program" "$GPG_AGENT_CONF" 2>/dev/null; then
      echo "# See: https://samuelsson.dev/sign-git-commits-on-github-with-gpg-in-macos/" >>$GPG_AGENT_CONF
      echo "pinentry-program $(which pinentry-mac)" >>$GPG_AGENT_CONF
  fi
fi

if should_setup "zellij"; then
  mkdir -p ~/.zsh_autocomplete
  if [ ! -f ~/.zsh_autocomplete/_zellij-completion ]; then
      zellij setup --generate-completion zsh >>~/.zsh_autocomplete/_zellij-completion
  fi
fi

# 2. Get category for a package (Bash 3.2 compatible)
get_category() {
  case "$1" in
    zsh|.oh-my-zsh) echo "shell" ;;
    tmux|zellij|ghostty|cmux) echo "terminal" ;;
    nvim|lvim) echo "coding" ;;
    gnupg|karabiner|pip) echo "system" ;;
  esac
}

# 3. Backup function
backup_and_remove() {
    local rel_path="$1"
    local pkg="$2"
    local target="$HOME/$rel_path"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "📦 Backing up existing file: $rel_path"
        mkdir -p "$(dirname "$BACKUP_DIR/$rel_path")"
        mv "$target" "$BACKUP_DIR/$rel_path"
    elif [ -L "$target" ]; then
        # Resolve target to absolute path using python
        local resolved_target=$(python3 -c "import os; print(os.path.realpath('$target'))" 2>/dev/null || true)
        
        if [ -z "$resolved_target" ]; then
            local link_target=$(readlink "$target")
            if [[ "$link_target" != *"/dotfiles/"* ]]; then
                echo "🔗 Removing alien symlink (fallback): $rel_path"
                rm "$target"
            fi
        else
            # If resolved path does NOT match the expected new package path, it is outdated
            local expected_path="$DOTFILES_DIR/$(get_category "$pkg")/$pkg"
            if [[ "$resolved_target" != "$expected_path"* ]]; then
                echo "🔗 Removing alien/outdated symlink: $rel_path (points to: $resolved_target)"
                rm "$target"
            fi
        fi
    fi
}

# 3. Handle specific conflicts (only for relevant packages)
get_conflicts() {
  case "$1" in
    zsh)        echo ".zshrc .zsh_profile .nvm_setup .pyenv_setup.sh .zshenv .zshrc.local.example .flutter_setup .p10k.zsh .config/starship.toml" ;;
    .oh-my-zsh) echo ".oh-my-zsh/custom/plugins/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-you-should-use" ;;
    tmux)       echo ".tmux.conf .tmux.conf.local" ;;
    gnupg)      echo ".gnupg" ;;
    zellij)     echo ".config/zellij" ;;
    karabiner)  echo ".config/karabiner" ;;
    ghostty)    echo ".config/ghostty" ;;
    cmux)       echo ".config/cmux" ;;
    pip)        echo ".config/pip" ;;
    nvim)       echo "init.lua lazy-lock.json lua .config/nvim" ;;
    lvim)       echo ".config/lvim .local/bin/lvim" ;;
  esac
}

echo "🧹 Preparing cleanup..."
mkdir -p "$BACKUP_DIR"

for pkg in "${PACKAGES[@]}"; do
  for conflict in $(get_conflicts "$pkg"); do
    backup_and_remove "$conflict" "$pkg"
  done
done

# 4. Stow
echo "🔗 Linking dotfiles: ${PACKAGES[*]}"
for pkg in "${PACKAGES[@]}"; do
  category=$(get_category "$pkg")
  stow --verbose -d "$DOTFILES_DIR/$category" --target="$HOME" --restow "$pkg"
done

echo "✨ Done! Backup created at $BACKUP_DIR"

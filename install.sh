#!/bin/bash
set -e

# Setup paths
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
MANIFEST_PY="$DOTFILES_DIR/scripts/lib/manifest.py"

# Get list of available packages dynamically from packages.json
ALL_PACKAGES=($(python3 "$MANIFEST_PY" list-packages))

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

REQUIRED_DEPS=("stow")
RAW_DEPS=$(python3 "$MANIFEST_PY" get-deps "${PACKAGES[@]}")
for dep in $RAW_DEPS; do
  if [[ ! " ${REQUIRED_DEPS[*]} " =~ " ${dep} " ]]; then
    REQUIRED_DEPS+=("$dep")
  fi
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

# 1. Run package setup hooks if defined
for pkg in "${PACKAGES[@]}"; do
  hook_rel=$(python3 "$MANIFEST_PY" get-hook "$pkg")
  if [[ -n "$hook_rel" && -f "$DOTFILES_DIR/$hook_rel" ]]; then
    bash "$DOTFILES_DIR/$hook_rel"
  fi
done

BACKUP_COUNT=0
REMOVE_COUNT=0

# 2. Backup function
backup_and_remove() {
    local rel_path="$1"
    local pkg="$2"
    local target="$HOME/$rel_path"
    local pkg_cat=$(python3 "$MANIFEST_PY" get-category "$pkg")
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$(dirname "$BACKUP_DIR/$rel_path")"
        mv "$target" "$BACKUP_DIR/$rel_path"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
    elif [ -L "$target" ]; then
        # Resolve target to absolute path using python
        local resolved_target=$(python3 -c "import os; print(os.path.realpath('$target'))" 2>/dev/null || true)
        
        if [ -z "$resolved_target" ]; then
            local link_target=$(readlink "$target")
            if [[ "$link_target" != *"/dotfiles/"* ]]; then
                rm "$target"
                REMOVE_COUNT=$((REMOVE_COUNT + 1))
            fi
        else
            # If resolved path does NOT match the expected new package path, it is outdated
            local expected_path="$DOTFILES_DIR/$pkg_cat/$pkg"
            if [[ "$resolved_target" != "$expected_path"* ]]; then
                rm "$target"
                REMOVE_COUNT=$((REMOVE_COUNT + 1))
            fi
        fi
    fi
}

echo "🧹 [1/3] Cleaning up conflicts..."
mkdir -p "$BACKUP_DIR"

for pkg in "${PACKAGES[@]}"; do
  conflicts=$(python3 "$MANIFEST_PY" get-conflicts "$pkg")
  for conflict in $conflicts; do
    backup_and_remove "$conflict" "$pkg"
  done
done
echo "🧹 [1/3] Cleanup complete (backed up $BACKUP_COUNT files, removed $REMOVE_COUNT outdated links)."

# 3. Backup summary
if [ "$BACKUP_COUNT" -gt 0 ]; then
  echo "📦 [2/3] Backed up conflicting files to: $BACKUP_DIR"
else
  # Clean up empty backup directory if nothing was backed up
  rmdir "$BACKUP_DIR" 2>/dev/null || true
  echo "📦 [2/3] No conflicting files to backup."
fi

# 4. Stow execution
echo "🔗 [3/3] Linking packages: ${PACKAGES[*]}... [RUNNING]"
STOW_ERR_FILE=$(mktemp)
STOW_FAILED=0
for pkg in "${PACKAGES[@]}"; do
  category=$(python3 "$MANIFEST_PY" get-category "$pkg")
  if ! stow -d "$DOTFILES_DIR/$category" --target="$HOME" --restow "$pkg" >"$STOW_ERR_FILE" 2>&1; then
    STOW_FAILED=1
    break
  fi
done

if [ "$STOW_FAILED" -eq 0 ]; then
  echo "🔗 [3/3] Linking packages: ${PACKAGES[*]}... [DONE]"
  echo "✨ Done! Dotfiles installation complete."
else
  echo "❌ Error linking packages:"
  cat "$STOW_ERR_FILE"
  rm -f "$STOW_ERR_FILE"
  exit 1
fi
rm -f "$STOW_ERR_FILE"

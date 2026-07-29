#!/usr/bin/env bash
# Starship Prompt Theme Switcher
# Allows changing Starship themes/presets dynamically via CLI or fzf menu

set -euo pipefail

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/Documents/GitHub/config/dotfiles}"
STARSHIP_CONFIG_DIR="$HOME/.config"
STARSHIP_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"
CUSTOM_PRESETS_DIR="$DOTFILES_ROOT/shell/zsh/.config/starship/presets"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

list_presets() {
    echo -e "${CYAN}--- Starship Official Presets ---${NC}"
    if command -v starship &>/dev/null; then
        starship preset --list | sed 's/^/  • /'
    else
        echo "  (starship CLI not found)"
    fi

    echo ""
    echo -e "${CYAN}--- Custom Dotfiles Presets ---${NC}"
    if [[ -d "$CUSTOM_PRESETS_DIR" ]]; then
        for f in "$CUSTOM_PRESETS_DIR"/*.toml; do
            if [[ -f "$f" ]]; then
                local name
                name=$(basename "$f" .toml)
                echo "  ★ custom:$name"
            fi
        done
    else
        echo "  (no custom presets folder found)"
    fi
}

apply_preset() {
    local preset_name="$1"
    
    # Ensure config dir exists
    mkdir -p "$STARSHIP_CONFIG_DIR"

    # Create backup if starship.toml exists
    if [[ -f "$STARSHIP_CONFIG_FILE" ]]; then
        cp "$STARSHIP_CONFIG_FILE" "${STARSHIP_CONFIG_FILE}.bak"
    fi

    if [[ "$preset_name" == custom:* ]]; then
        local custom_name="${preset_name#custom:}"
        local target_file="$CUSTOM_PRESETS_DIR/${custom_name}.toml"
        if [[ ! -f "$target_file" ]]; then
            echo -e "${RED}Error: Custom preset file not found: $target_file${NC}"
            exit 1
        fi
        cp "$target_file" "$STARSHIP_CONFIG_FILE"
        echo -e "${GREEN}✓ Successfully applied custom preset: ${YELLOW}$custom_name${NC}"
    elif [[ -f "$CUSTOM_PRESETS_DIR/${preset_name}.toml" ]]; then
        cp "$CUSTOM_PRESETS_DIR/${preset_name}.toml" "$STARSHIP_CONFIG_FILE"
        echo -e "${GREEN}✓ Successfully applied custom preset: ${YELLOW}$preset_name${NC}"
    else
        if command -v starship &>/dev/null; then
            if starship preset "$preset_name" -o "$STARSHIP_CONFIG_FILE" &>/dev/null; then
                echo -e "${GREEN}✓ Successfully applied official Starship preset: ${YELLOW}$preset_name${NC}"
            else
                echo -e "${RED}Error: Unknown preset '$preset_name'. Run 'starship-theme --list' to view options.${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Error: starship CLI not found.${NC}"
            exit 1
        fi
    fi
}

interactive_select() {
    local options=()

    # Add custom presets
    if [[ -d "$CUSTOM_PRESETS_DIR" ]]; then
        for f in "$CUSTOM_PRESETS_DIR"/*.toml; do
            if [[ -f "$f" ]]; then
                options+=("custom:$(basename "$f" .toml)")
            fi
        done
    fi

    # Add official presets
    if command -v starship &>/dev/null; then
        while IFS= read -r line; do
            [[ -n "$line" ]] && options+=("$line")
        done < <(starship preset --list)
    fi

    if [[ ${#options[@]} -eq 0 ]]; then
        echo -e "${RED}No presets found!${NC}"
        exit 1
    fi

    local selected=""

    if command -v fzf &>/dev/null; then
        echo -e "${CYAN}Select a Starship prompt preset (Use arrows + Enter):${NC}"
        selected=$(printf '%s\n' "${options[@]}" | fzf --prompt="Select Theme > " --height=40% --border)
    else
        echo -e "${CYAN}Available Starship Presets:${NC}"
        select opt in "${options[@]}"; do
            if [[ -n "$opt" ]]; then
                selected="$opt"
                break
            fi
        done
    fi

    if [[ -n "$selected" ]]; then
        apply_preset "$selected"
    else
        echo "No preset selected."
    fi
}

show_help() {
    cat <<EOF
Starship Prompt Theme Switcher

Usage:
  starship-theme [PRESET_NAME]    Apply a specific preset (e.g. tokyo-night, catppuccin-powerline)
  starship-theme --list | -l       List all available official and custom presets
  starship-theme --help | -h       Show this help message

Run 'starship-theme' with no arguments for an interactive fzf selector menu.
EOF
}

case "${1:-}" in
    --list|-l)
        list_presets
        ;;
    --help|-h)
        show_help
        ;;
    "")
        interactive_select
        ;;
    *)
        apply_preset "$1"
        ;;
esac

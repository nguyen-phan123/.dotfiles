#!/usr/bin/env bash
# Theme switcher for Ghostty, cmux, and LunarVim configurations
# Optimized for nearsighted users working in varying lighting conditions

set -e

DOTFILES_ROOT="/Users/diqit/Documents/GitHub/config/dotfiles"
GHOSTTY_DIR="$DOTFILES_ROOT/terminal/ghostty/.config/ghostty"
CMUX_DIR="$DOTFILES_ROOT/terminal/cmux/.config/cmux"
LVIM_DIR="$DOTFILES_ROOT/coding/lvim/.config/lvim"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

switch_to_light() {
    echo -e "${YELLOW}Switching to light mode...${NC}"

    if [[ ! -f "$LVIM_DIR/config.light.lua" ]]; then
        echo -e "${RED}Error: $LVIM_DIR/config.light.lua not found${NC}"
        return 1
    fi

    # Update symlinks
    ln -sf config.light.lua "$LVIM_DIR/config.lua"

    echo -e "${GREEN}✓ Switched to light mode${NC}"
    echo "  - Ghostty: Natively adaptive (GitHub Light High Contrast)"
    echo "  - Cmux: Natively adaptive (Light appearance)"
    echo "  - LunarVim: Solarized Light"
    echo ""
    echo "Restart/Reload LunarVim to apply changes."
}

switch_to_dark() {
    echo -e "${YELLOW}Switching to dark mode...${NC}"

    if [[ ! -f "$LVIM_DIR/config.dark.lua" ]]; then
        echo -e "${RED}Error: $LVIM_DIR/config.dark.lua not found${NC}"
        return 1
    fi

    # Update symlinks
    ln -sf config.dark.lua "$LVIM_DIR/config.lua"

    echo -e "${GREEN}✓ Switched to dark mode${NC}"
    echo "  - Ghostty: Natively adaptive (Solarized Dark Patched)"
    echo "  - Cmux: Natively adaptive (Dark appearance)"
    echo "  - LunarVim: Solarized Dark"
    echo ""
    echo "Restart/Reload LunarVim to apply changes."
}

show_status() {
    echo "Current theme configuration:"
    echo ""

    if [[ -f "$GHOSTTY_DIR/config" && ! -L "$GHOSTTY_DIR/config" ]]; then
        if grep -q "theme = light:" "$GHOSTTY_DIR/config"; then
            echo -e "  Ghostty: ${GREEN}Natively Adaptive${NC}"
        else
            echo "  Ghostty: Static file configuration"
        fi
    elif [[ -L "$GHOSTTY_DIR/config" ]]; then
        local ghostty_target=$(readlink "$GHOSTTY_DIR/config")
        echo "  Ghostty: Symlinked to $ghostty_target (Deprecated)"
    else
        echo -e "  Ghostty: ${RED}Missing config file${NC}"
    fi

    if [[ -f "$CMUX_DIR/cmux.json" && ! -L "$CMUX_DIR/cmux.json" ]]; then
        if grep -q '"appearance"[[:space:]]*:[[:space:]]*"system"' "$CMUX_DIR/cmux.json" || grep -q '"appearance" : "system"' "$CMUX_DIR/cmux.json" || grep -q '"appearance": "system"' "$CMUX_DIR/cmux.json"; then
            echo -e "  Cmux: ${GREEN}Natively Adaptive${NC}"
        else
            echo "  Cmux: Static file configuration"
        fi
    elif [[ -L "$CMUX_DIR/cmux.json" ]]; then
        local cmux_target=$(readlink "$CMUX_DIR/cmux.json")
        echo "  Cmux: Symlinked to $cmux_target (Deprecated)"
    else
        echo -e "  Cmux: ${RED}Missing config file${NC}"
    fi

    if [[ -L "$LVIM_DIR/config.lua" ]]; then
        local lvim_target=$(readlink "$LVIM_DIR/config.lua")
        echo "  LunarVim: $lvim_target"
    else
        echo -e "  LunarVim: ${RED}Not a symlink${NC}"
    fi
}

show_help() {
    cat <<EOF
Theme Switcher for Terminal & Editor Configurations
Optimized for nearsighted users in varying lighting conditions

Usage:
    theme-switch.sh light    Switch to light mode (LunarVim)
    theme-switch.sh dark     Switch to dark mode (LunarVim)
    theme-switch.sh status   Show current theme configuration
    theme-switch.sh help     Show this help message

Note: Ghostty and Cmux are natively adaptive and follow the macOS system theme automatically.

Components:
  - Ghostty terminal emulator (Natively Adaptive)
  - Cmux terminal multiplexer (Natively Adaptive)
  - LunarVim text editor (Switches via script)

Light Mode Features:
  - Ghostty: GitHub Light High Contrast theme (Adaptive)
  - LunarVim: Solarized Light theme
  - Font size 16px
  - Background opacity 0.95 (reduces glare on glossy screens)
  - Block cursor with blink

Dark Mode Features:
  - Ghostty: Solarized Dark Patched theme (Adaptive)
  - LunarVim: Solarized Dark theme
  - Font size 16px
  - Background opacity 0.95
  - Block cursor with blink

Shell Aliases (add to ~/.zshrc):
    alias theme-light='$DOTFILES_ROOT/terminal/scripts/theme-switch.sh light'
    alias theme-dark='$DOTFILES_ROOT/terminal/scripts/theme-switch.sh dark'

EOF
}

# Main command router
case "${1:-}" in
    light)
        switch_to_light
        ;;
    dark)
        switch_to_dark
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Error: Invalid command${NC}"
        echo "Run 'theme-switch.sh help' for usage information"
        exit 1
        ;;
esac

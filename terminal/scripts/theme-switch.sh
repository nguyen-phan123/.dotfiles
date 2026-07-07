#!/usr/bin/env bash
# Theme switcher for Ghostty and cmux terminal configurations
# Optimized for nearsighted users working in varying lighting conditions

set -e

DOTFILES_ROOT="/Users/diqit/Documents/GitHub/config/dotfiles"
GHOSTTY_DIR="$DOTFILES_ROOT/terminal/ghostty/.config/ghostty"
CMUX_DIR="$DOTFILES_ROOT/terminal/cmux/.config/cmux"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

switch_to_light() {
    echo -e "${YELLOW}Switching to light mode...${NC}"

    # Validate config files exist
    if [[ ! -f "$GHOSTTY_DIR/config.light" ]]; then
        echo -e "${RED}Error: $GHOSTTY_DIR/config.light not found${NC}"
        return 1
    fi

    if [[ ! -f "$CMUX_DIR/cmux.light.json" ]]; then
        echo -e "${RED}Error: $CMUX_DIR/cmux.light.json not found${NC}"
        return 1
    fi

    # Update symlinks
    ln -sf config.light "$GHOSTTY_DIR/config"
    ln -sf cmux.light.json "$CMUX_DIR/cmux.json"

    echo -e "${GREEN}✓ Switched to light mode${NC}"
    echo "  - Ghostty: GitHub Light High Contrast"
    echo "  - Cmux: Light appearance"
    echo ""
    echo "Restart Ghostty/cmux to apply changes."
}

switch_to_dark() {
    echo -e "${YELLOW}Switching to dark mode...${NC}"

    # Validate config files exist
    if [[ ! -f "$GHOSTTY_DIR/config.dark" ]]; then
        echo -e "${RED}Error: $GHOSTTY_DIR/config.dark not found${NC}"
        return 1
    fi

    if [[ ! -f "$CMUX_DIR/cmux.dark.json" ]]; then
        echo -e "${RED}Error: $CMUX_DIR/cmux.dark.json not found${NC}"
        return 1
    fi

    # Update symlinks
    ln -sf config.dark "$GHOSTTY_DIR/config"
    ln -sf cmux.dark.json "$CMUX_DIR/cmux.json"

    echo -e "${GREEN}✓ Switched to dark mode${NC}"
    echo "  - Ghostty: Solarized Dark Patched"
    echo "  - Cmux: Dark appearance"
    echo ""
    echo "Restart Ghostty/cmux to apply changes."
}

show_status() {
    echo "Current theme configuration:"
    echo ""

    if [[ -L "$GHOSTTY_DIR/config" ]]; then
        local ghostty_target=$(readlink "$GHOSTTY_DIR/config")
        echo "  Ghostty: $ghostty_target"
    else
        echo -e "  Ghostty: ${RED}Not a symlink${NC}"
    fi

    if [[ -L "$CMUX_DIR/cmux.json" ]]; then
        local cmux_target=$(readlink "$CMUX_DIR/cmux.json")
        echo "  Cmux: $cmux_target"
    else
        echo -e "  Cmux: ${RED}Not a symlink${NC}"
    fi
}

show_help() {
    cat <<EOF
Theme Switcher for Terminal Configurations
Optimized for nearsighted users in varying lighting conditions

Usage:
    theme-switch.sh light    Switch to light mode (office/bright lighting)
    theme-switch.sh dark     Switch to dark mode (night/low lighting)
    theme-switch.sh status   Show current theme configuration
    theme-switch.sh help     Show this help message

Light Mode Features:
  - GitHub Light High Contrast theme (maximum contrast)
  - Font size 16px
  - Background opacity 0.95 (reduces glare on glossy screens)
  - Block cursor with blink

Dark Mode Features:
  - Solarized Dark Patched theme
  - Font size 16px
  - Opaque background (opacity 1.0)
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

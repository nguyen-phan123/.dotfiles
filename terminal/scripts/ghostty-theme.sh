#!/usr/bin/env bash
# Ghostty Terminal Theme Switcher & Manager
# Fast installer, switcher, and previewer for dark themes from terminalcolors.com
# Conforms to repo guidelines: set -euo pipefail, local variables, relative paths.

set -euo pipefail

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/Documents/GitHub/config/dotfiles}"
GHOSTTY_CONFIG_FILE="$DOTFILES_ROOT/terminal/ghostty/.config/ghostty/config"
THEMES_DIR="$DOTFILES_ROOT/terminal/ghostty/.config/ghostty/themes"
DOWNLOAD_SCRIPT="$DOTFILES_ROOT/terminal/scripts/download-ghostty-themes.js"
GHOSTTY_BIN="/Applications/Ghostty.app/Contents/MacOS/ghostty"

# ANSI color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

hex_to_swatch() {
    local hex="$1"
    local text="${2:-  }"
    hex="${hex###}"
    if [[ ${#hex} -ne 6 ]]; then
        printf "%s" "$text"
        return
    fi
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    # Contrast calculation for text readability on block
    local lum=$(( (r * 299 + g * 587 + b * 114) / 1000 ))
    local text_color="30"
    if (( lum < 128 )); then
        text_color="37"
    fi
    printf "\033[48;2;%d;%d;%dm\033[%sm%s\033[0m" "$r" "$g" "$b" "$text_color" "$text"
}

get_current_theme() {
    if [[ ! -f "$GHOSTTY_CONFIG_FILE" ]]; then
        echo "(no config file)"
        return
    fi
    local raw_theme
    raw_theme=$(grep -E '^[[:space:]]*theme[[:space:]]*=' "$GHOSTTY_CONFIG_FILE" | head -n 1 | sed -E 's/^[[:space:]]*theme[[:space:]]*=[[:space:]]*//' | tr -d '"' | tr -d "'")
    echo "${raw_theme:-default}"
}

show_current() {
    local current
    current=$(get_current_theme)
    echo -e "${BOLD}Current Ghostty Theme:${NC} ${GREEN}${current}${NC}"
}

list_themes() {
    local current
    current=$(get_current_theme)

    echo -e "${BOLD}=== Installed Ghostty Dark Themes (${THEMES_DIR}) ===${NC}\n"

    if [[ ! -d "$THEMES_DIR" ]]; then
        echo -e "${RED}Thư mục themes chưa tồn tại! Hãy chạy: ghostty-theme install${NC}"
        return 1
    fi

    local themes=()
    while IFS= read -r f; do
        [[ -n "$f" ]] && themes+=("$f")
    done < <(find "$THEMES_DIR" -maxdepth 1 -type f ! -name "themes.json" ! -name ".*" -exec basename {} \; | sort)

    if [[ ${#themes[@]} -eq 0 ]]; then
        echo -e "${YELLOW}Chưa có theme nào được cài đặt. Hãy chạy: ghostty-theme install${NC}"
        return 0
    fi

    local theme
    for theme in "${themes[@]}"; do
        if [[ "$theme" == "$current" || "dark:$theme" == *"$current"* || "$current" == *"$theme"* ]]; then
            printf "  ${GREEN}● %-30s ${BOLD}(active)${NC}\n" "$theme"
        else
            printf "    %-30s\n" "$theme"
        fi
    done

    echo -e "\n${CYAN}Tổng cộng: ${#themes[@]} themes.${NC}"
}

preview_theme() {
    local theme_name="${1:-}"
    if [[ -z "$theme_name" ]]; then
        echo -e "${RED}Lỗi: Vui lòng chỉ định tên theme cần preview!${NC}"
        echo "Ví dụ: ghostty-theme preview catppuccin-mocha"
        return 1
    fi

    local target_file="$THEMES_DIR/$theme_name"
    if [[ ! -f "$target_file" ]]; then
        echo -e "${RED}Theme '$theme_name' không tồn tại trong $THEMES_DIR${NC}"
        return 1
    fi

    local title
    title=$(grep -E '^#[[:space:]]*Ghostty Theme:' "$target_file" | head -n 1 | sed 's/^#[[:space:]]*Ghostty Theme:[[:space:]]*//' || true)
    if [[ -z "$title" ]]; then
        title="$theme_name"
    fi

    local bg
    bg=$(grep -E '^[[:space:]]*background[[:space:]]*=' "$target_file" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ' || true)
    local fg
    fg=$(grep -E '^[[:space:]]*foreground[[:space:]]*=' "$target_file" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ' || true)

    echo -e "${BOLD}${CYAN}Theme:${NC} ${BOLD}$title${NC} ($theme_name)"
    if [[ -n "$bg" ]]; then
        printf "Background: %-9s " "$bg"
        hex_to_swatch "$bg" "      "
        printf "\n"
    fi
    if [[ -n "$fg" ]]; then
        printf "Foreground: %-9s " "$fg"
        hex_to_swatch "$fg" "      "
        printf "\n"
    fi

    echo -e "\n${BOLD}Palette 0-7 (Normal):${NC}"
    local i
    for ((i=0; i<8; i++)); do
        local hex
        hex=$(grep -E "^[[:space:]]*palette[[:space:]]*=[[:space:]]*$i=" "$target_file" | head -n 1 | awk -F '=' '{print $3}' | tr -d ' ' || true)
        if [[ -n "$hex" ]]; then
            hex_to_swatch "$hex" " $i "
            printf " "
        else
            printf "[%d] " "$i"
        fi
    done
    printf "\n"

    echo -e "\n${BOLD}Palette 8-15 (Bright):${NC}"
    for ((i=8; i<16; i++)); do
        local hex
        hex=$(grep -E "^[[:space:]]*palette[[:space:]]*=[[:space:]]*$i=" "$target_file" | head -n 1 | awk -F '=' '{print $3}' | tr -d ' ' || true)
        if [[ -n "$hex" ]]; then
            hex_to_swatch "$hex" " $i "
            printf " "
        else
            printf "[%d] " "$i"
        fi
    done
    printf "\n"
}

apply_theme() {
    local theme_name="${1:-}"
    if [[ -z "$theme_name" ]]; then
        echo -e "${RED}Lỗi: Vui lòng chỉ định tên theme cần apply!${NC}"
        echo "Ví dụ: ghostty-theme apply catppuccin-mocha"
        return 1
    fi

    local target_file="$THEMES_DIR/$theme_name"
    if [[ ! -f "$target_file" ]]; then
        # Check if it is a built-in theme
        if [[ -x "$GHOSTTY_BIN" ]] && "$GHOSTTY_BIN" +list-themes 2>/dev/null | grep -q "^$theme_name"; then
            echo -e "${CYAN}Áp dụng built-in theme: $theme_name${NC}"
        else
            echo -e "${RED}Theme '$theme_name' không tồn tại! Chạy 'ghostty-theme list' để xem danh sách.${NC}"
            return 1
        fi
    fi

    if [[ ! -f "$GHOSTTY_CONFIG_FILE" ]]; then
        mkdir -p "$(dirname "$GHOSTTY_CONFIG_FILE")"
        echo "theme = $theme_name" > "$GHOSTTY_CONFIG_FILE"
    else
        # Update config file while preserving rest of configuration
        if grep -q -E '^[[:space:]]*theme[[:space:]]*=' "$GHOSTTY_CONFIG_FILE"; then
            local current_line
            current_line=$(grep -E '^[[:space:]]*theme[[:space:]]*=' "$GHOSTTY_CONFIG_FILE" | head -n 1)
            # If currently using adaptive theme (light:...,dark:...), preserve light theme and update dark theme
            if [[ "$current_line" == *"light:"* && "$current_line" == *"dark:"* ]]; then
                local light_part
                light_part=$(echo "$current_line" | sed -E 's/.*light:([^,]+).*/\1/')
                sed -i '' -E "s/^[[:space:]]*theme[[:space:]]*=.*/theme = light:${light_part},dark:${theme_name}/" "$GHOSTTY_CONFIG_FILE"
                echo -e "${GREEN}✓ Đã cập nhật dark theme thành:${NC} ${BOLD}${theme_name}${NC} (Adaptive mode)"
            else
                sed -i '' -E "s/^[[:space:]]*theme[[:space:]]*=.*/theme = ${theme_name}/" "$GHOSTTY_CONFIG_FILE"
                echo -e "${GREEN}✓ Đã cập nhật theme thành:${NC} ${BOLD}${theme_name}${NC}"
            fi
        else
            echo "theme = $theme_name" >> "$GHOSTTY_CONFIG_FILE"
            echo -e "${GREEN}✓ Đã thêm theme:${NC} ${BOLD}${theme_name}${NC}"
        fi
    fi

    # If running inside a terminal, immediately update current terminal colors via OSC escape sequences
    if [[ -f "$target_file" ]]; then
        local tty_dev=""
        if [[ -w /dev/tty ]]; then
            tty_dev="/dev/tty"
        elif [[ -t 1 ]]; then
            tty_dev="/dev/stdout"
        fi

        if [[ -n "$tty_dev" ]]; then
            local live_bg live_fg live_cur
            live_bg=$(grep -E '^[[:space:]]*background[[:space:]]*=' "$target_file" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ' || true)
            live_fg=$(grep -E '^[[:space:]]*foreground[[:space:]]*=' "$target_file" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ' || true)
            live_cur=$(grep -E '^[[:space:]]*cursor-color[[:space:]]*=' "$target_file" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ' || true)
            [[ -n "$live_bg" ]] && printf "\033]11;%s\007" "$live_bg" > "$tty_dev" 2>/dev/null || true
            [[ -n "$live_fg" ]] && printf "\033]10;%s\007" "$live_fg" > "$tty_dev" 2>/dev/null || true
            [[ -n "$live_cur" ]] && printf "\033]12;%s\007" "$live_cur" > "$tty_dev" 2>/dev/null || true
            local p_idx p_hex
            for ((p_idx=0; p_idx<16; p_idx++)); do
                p_hex=$(grep -E "^[[:space:]]*palette[[:space:]]*=[[:space:]]*$p_idx=" "$target_file" | head -n 1 | awk -F '=' '{print $3}' | tr -d ' ' || true)
                [[ -n "$p_hex" ]] && printf "\033]4;%d;%s\007" "$p_idx" "$p_hex" > "$tty_dev" 2>/dev/null || true
            done
        fi
    fi

    # Validate config if Ghostty binary exists
    if [[ -x "$GHOSTTY_BIN" ]]; then
        if "$GHOSTTY_BIN" +validate-config --config-file="$GHOSTTY_CONFIG_FILE" 2>/dev/null; then
            echo -e "${CYAN}💡 Nhấn ${BOLD}Cmd+Shift+,${NC}${CYAN} trong Ghostty để reload các tab hiện tại (hoặc mở Tab mới ${BOLD}Cmd+T${NC}${CYAN}).${NC}"
        else
            echo -e "${YELLOW}⚠️ Ghostty config đã được cập nhật nhưng có thể cần kiểm tra.${NC}"
        fi
    else
        echo -e "${CYAN}💡 Nhấn ${BOLD}Cmd+Shift+,${NC}${CYAN} trong Ghostty để reload.${NC}"
    fi
}

apply_random_theme() {
    if [[ ! -d "$THEMES_DIR" ]]; then
        echo -e "${RED}Chưa có theme nào được cài đặt. Hãy chạy: ghostty-theme install${NC}"
        return 1
    fi

    local themes=()
    while IFS= read -r f; do
        [[ -n "$f" ]] && themes+=("$f")
    done < <(find "$THEMES_DIR" -maxdepth 1 -type f ! -name "themes.json" ! -name ".*" -exec basename {} \; | sort)

    if [[ ${#themes[@]} -eq 0 ]]; then
        echo -e "${RED}Không tìm thấy theme nào.${NC}"
        return 1
    fi

    local rand_idx=$((RANDOM % ${#themes[@]}))
    local chosen="${themes[$rand_idx]}"
    echo -e "${CYAN}🎲 Chọn ngẫu nhiên theme: ${BOLD}${chosen}${NC}"
    apply_theme "$chosen"
}

install_themes() {
    local live_flag="${1:-}"
    if [[ ! -f "$DOWNLOAD_SCRIPT" ]]; then
        echo -e "${RED}Lỗi: Không tìm thấy script download tại $DOWNLOAD_SCRIPT${NC}"
        return 1
    fi

    echo -e "${CYAN}Bắt đầu cài đặt/cập nhật tất cả các dark theme từ terminalcolors.com...${NC}"
    if [[ "$live_flag" == "--live" || "$live_flag" == "--fetch-latest" ]]; then
        node "$DOWNLOAD_SCRIPT" --live
    else
        node "$DOWNLOAD_SCRIPT"
    fi
}

interactive_menu() {
    if [[ ! -d "$THEMES_DIR" ]]; then
        echo -e "${YELLOW}Thư mục themes chưa có, đang tải về lần đầu...${NC}"
        install_themes ""
    fi

    local themes=()
    while IFS= read -r f; do
        [[ -n "$f" ]] && themes+=("$f")
    done < <(find "$THEMES_DIR" -maxdepth 1 -type f ! -name "themes.json" ! -name ".*" -exec basename {} \; | sort)

    if [[ ${#themes[@]} -eq 0 ]]; then
        echo -e "${YELLOW}Chưa có theme nào được tải về. Đang tải tự động...${NC}"
        install_themes ""
        while IFS= read -r f; do
            [[ -n "$f" ]] && themes+=("$f")
        done < <(find "$THEMES_DIR" -maxdepth 1 -type f ! -name "themes.json" ! -name ".*" -exec basename {} \; | sort)
    fi

    local selected=""

    if command -v fzf &>/dev/null; then
        local self_script="$DOTFILES_ROOT/terminal/scripts/ghostty-theme.sh"
        echo -e "${CYAN}Chọn Ghostty Dark Theme (Dùng phím mũi tên để xem Preview, Enter để chọn):${NC}"
        selected=$(printf '%s\n' "${themes[@]}" | fzf \
            --prompt="Theme > " \
            --height=70% \
            --layout=reverse \
            --border \
            --preview "bash \"$self_script\" preview {}" \
            --preview-window=right:55%:wrap)
    else
        echo -e "${CYAN}Danh sách themes có sẵn:${NC}"
        select opt in "${themes[@]}" "Hủy bỏ"; do
            if [[ "$opt" == "Hủy bỏ" ]]; then
                echo "Đã hủy."
                return 0
            elif [[ -n "$opt" ]]; then
                selected="$opt"
                break
            fi
        done
    fi

    if [[ -n "$selected" ]]; then
        apply_theme "$selected"
    else
        echo "Không có theme nào được chọn."
    fi
}

show_help() {
    cat <<EOF
${BOLD}Ghostty Theme Switcher & Manager${NC}
Cài đặt và quản lý nhanh các dark theme cho Ghostty từ https://terminalcolors.com/tags/dark/

${BOLD}Cách dùng:${NC}
  ghostty-theme                    Mở menu chọn theme trực quan với live preview (fzf)
  ghostty-theme apply <tên-theme>   Áp dụng theme ngay lập tức (ví dụ: catppuccin-mocha)
  ghostty-theme list               Liệt kê tất cả các dark theme đã cài đặt
  ghostty-theme current            Hiển thị theme hiện tại đang được cấu hình
  ghostty-theme preview <tên-theme> Xem trước bảng màu ANSI của theme
  ghostty-theme random             Chọn ngẫu nhiên một theme và áp dụng
  ghostty-theme install [--live]   Tải và cài đặt tất cả các dark theme từ terminalcolors.com
  ghostty-theme help               Xem hướng dẫn này

${BOLD}Các theme Dark nổi bật:${NC}
  catppuccin-mocha, catppuccin-macchiato, dracula, tokyo-night, tokyo-night-storm,
  gruvbox-dark, kanagawa-wave, rose-pine, ayu-dark, nord, solarized-dark,
  github-dark, github-dark-high-contrast, one-dark, night-owl, sonokai...

${BOLD}Ghi chú:${NC}
  Ghostty sẽ tự động reload giao diện ngay lập tức khi theme được thay đổi!
EOF
}

# Main CLI router
case "${1:-}" in
    install|update|--install|--update|-i)
        install_themes "${2:-}"
        ;;
    list|--list|-l)
        list_themes
        ;;
    current|--current|-c)
        show_current
        ;;
    apply|set)
        apply_theme "${2:-}"
        ;;
    preview|--preview|-p)
        preview_theme "${2:-}"
        ;;
    random|--random|-r)
        apply_random_theme
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        interactive_menu
        ;;
    *)
        # If user passed a theme name directly, apply it
        apply_theme "$1"
        ;;
esac

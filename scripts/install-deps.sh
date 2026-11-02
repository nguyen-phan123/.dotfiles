#!/bin/bash

echo "🚀 Đang nạp đạn dược (Dependencies)..."

# Determine if we install all or selectively
INSTALL_ALL=true
if [ $# -gt 0 ]; then
  INSTALL_ALL=false
  echo "🎯 Chế độ cài đặt chọn lọc (Selective Install): $@"
else
  echo "🚀 Chế độ cài đặt toàn bộ (Full Install)"
fi

# 1. Compile Homebrew packages to install
BREW_PACKAGES=""
for pkg in starship zoxide bat eza fzf ripgrep fd neovim stow tlrc; do
  if [ "$INSTALL_ALL" = true ]; then
    BREW_PACKAGES="$BREW_PACKAGES $pkg"
  else
    # Check if $pkg is in the arguments (or nvim alias for neovim)
    for arg in "$@"; do
      if [[ "$arg" == "$pkg" ]] || [[ "$pkg" == "neovim" && "$arg" == "nvim" ]]; then
        BREW_PACKAGES="$BREW_PACKAGES $pkg"
        break
      fi
    done
  fi
done

# Include zsh-syntax-highlighting if any shell binary is being installed
if [ "$INSTALL_ALL" = true ] || [[ "$BREW_PACKAGES" == *"starship"* || "$BREW_PACKAGES" == *"zoxide"* ]]; then
  BREW_PACKAGES="$BREW_PACKAGES zsh-syntax-highlighting"
fi

if [ -n "$BREW_PACKAGES" ]; then
  echo "📦 Đang cài: $BREW_PACKAGES"
  brew install $BREW_PACKAGES
fi

# 2. Cài Plugins cho Oh-My-Zsh (nếu cần thiết)
if [ "$INSTALL_ALL" = true ] || [[ "$BREW_PACKAGES" == *"starship"* ]]; then
  ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
  mkdir -p $ZSH_CUSTOM/plugins

  echo "🔌 Đang cài Plugins cho Zsh..."

  # zsh-autosuggestions
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  else
    echo "✅ zsh-autosuggestions đã có."
  fi

  # zsh-you-should-use
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-you-should-use" ]; then
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/zsh-you-should-use
  else
    echo "✅ zsh-you-should-use đã có."
  fi
fi

# 3. Cài LunarVim (lvim) (chỉ khi được yêu cầu)
SHOULD_INSTALL_LVIM=false
if [ "$INSTALL_ALL" = true ]; then
  SHOULD_INSTALL_LVIM=true
else
  for arg in "$@"; do
    if [[ "$arg" == "lvim" ]]; then
      SHOULD_INSTALL_LVIM=true
      break
    fi
  done
fi

if [ "$SHOULD_INSTALL_LVIM" = true ]; then
  echo "🌙 Đang cài LunarVim..."
  if ! command -v lvim &> /dev/null; then
      # Install with default options
      (
          unset VIRTUAL_ENV
          unset PYTHONHOME
          # Remove pyenv bin directory from PATH
          export PATH=$(echo "$PATH" | sed -E 's|:/Users/diqit/pyenv/bin||g;s|/Users/diqit/pyenv/bin:||g')
          
          # Allow pip to install to user site-packages despite PEP 668
          export PIP_BREAK_SYSTEM_PACKAGES=1
          
          LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --yes
      )
  else
      echo "✅ LunarVim đã có."
  fi
fi

echo "✨ Xong rồi đại ca! Khởi động lại Terminal đi."

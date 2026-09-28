# Ensure valid TERM is set
export TERM="${TERM:-xterm-256color}"

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"


# Performance optimizations
DISABLE_AUTO_UPDATE=true
DISABLE_MAGIC_FUNCTIONS=true
ZSH_DISABLE_COMPFIX=true

# Plugins (loaded by oh-my-zsh)
plugins=(
  git
  zsh-you-should-use
)

source $ZSH/oh-my-zsh.sh

# GPG configuration for terminal-based signing
export GPG_TTY=$(tty)

# Source configurations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh_profile

# Machine-specific configuration (not version controlled)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local


export PATH="$HOME/.local/bin:$PATH"

# Added by Antigravity IDE
if [[ -d "$HOME/.antigravity-ide/antigravity-ide/bin" ]]; then
  export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"
fi


#!/bin/bash
set -euo pipefail

mkdir -p "$HOME/.zsh_autocomplete"
if [ ! -f "$HOME/.zsh_autocomplete/_zellij-completion" ]; then
    zellij setup --generate-completion zsh >> "$HOME/.zsh_autocomplete/_zellij-completion" 2>/dev/null || true
fi

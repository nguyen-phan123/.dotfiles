#!/usr/bin/env bash
set -euo pipefail

# Helper to open files in editor
open_in_editor() {
  local files=("$@")
  for f in "${files[@]}"; do
    if [[ ! -f "$f" ]]; then
      mkdir -p "$(dirname "$f")"
      echo "{}" > "$f"
    fi
  done

  if command -v cursor &>/dev/null; then
    cursor "${files[@]}"
  elif [[ -d "/Applications/Cursor.app" ]]; then
    open -a "Cursor" "${files[@]}"
  elif command -v code &>/dev/null; then
    code "${files[@]}"
  elif [[ -d "/Applications/Visual Studio Code.app" ]]; then
    open -a "Visual Studio Code" "${files[@]}"
  elif [[ -n "${EDITOR:-}" ]]; then
    "$EDITOR" "${files[@]}"
  elif command -v nvim &>/dev/null; then
    nvim "${files[@]}"
  else
    open "${files[@]}"
  fi
}

GEMINI_SETTINGS="$HOME/.gemini/settings.json"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
CLAUDE_LOCAL_SETTINGS="$HOME/.claude/settings.local.json"
CLAUDE_JSON="$HOME/.claude.json"

TARGET="${1:-}"

case "$TARGET" in
  gemini|gem|-g|--gemini)
    open_in_editor "$GEMINI_SETTINGS"
    ;;
  claude|cl|-c|--claude)
    open_in_editor "$CLAUDE_SETTINGS"
    ;;
  local|claude-local|-l|--local)
    open_in_editor "$CLAUDE_LOCAL_SETTINGS"
    ;;
  all|-a|--all)
    open_in_editor "$GEMINI_SETTINGS" "$CLAUDE_SETTINGS"
    ;;
  *)
    if command -v fzf &>/dev/null; then
      SELECTION=$(printf "%s\n" \
        "Gemini Settings (~/.gemini/settings.json)" \
        "Claude Settings (~/.claude/settings.json)" \
        "Claude Local Settings (~/.claude/settings.local.json)" \
        "Claude Global State (~/.claude.json)" \
        "Open All Settings (Gemini & Claude)" \
        | fzf --prompt="Select AI config to open > " --height=40% --layout=reverse --border)
      
      case "$SELECTION" in
        *"Gemini Settings"*) open_in_editor "$GEMINI_SETTINGS" ;;
        *"Claude Settings"*) open_in_editor "$CLAUDE_SETTINGS" ;;
        *"Claude Local Settings"*) open_in_editor "$CLAUDE_LOCAL_SETTINGS" ;;
        *"Claude Global State"*) open_in_editor "$CLAUDE_JSON" ;;
        *"Open All Settings"*) open_in_editor "$GEMINI_SETTINGS" "$CLAUDE_SETTINGS" ;;
      esac
    else
      open_in_editor "$GEMINI_SETTINGS" "$CLAUDE_SETTINGS"
    fi
    ;;
esac

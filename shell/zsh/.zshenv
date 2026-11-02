# Dynamically detect Homebrew prefix (Apple Silicon vs Intel)
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    export HOMEBREW_PREFIX="/usr/local"
  fi
fi
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# Load Homebrew environment variables into PATH globally
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

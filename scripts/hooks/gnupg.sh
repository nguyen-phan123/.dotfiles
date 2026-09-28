#!/bin/bash
set -euo pipefail

GPG_AGENT_CONF="system/gnupg/.gnupg/gpg-agent.conf"
mkdir -p system/gnupg/.gnupg
if ! grep -q "pinentry-program" "$GPG_AGENT_CONF" 2>/dev/null; then
    echo "# See: https://samuelsson.dev/sign-git-commits-on-github-with-gpg-in-macos/" >> "$GPG_AGENT_CONF"
    echo "pinentry-program $(which pinentry-mac)" >> "$GPG_AGENT_CONF"
fi

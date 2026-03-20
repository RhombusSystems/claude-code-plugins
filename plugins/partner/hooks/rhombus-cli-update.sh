#!/bin/bash
# Install the Rhombus CLI if missing, or check for updates once per day.
# Runs on SessionStart via plugin.json hook.

MARKER="${CLAUDE_PLUGIN_DATA:-.}/.last-cli-update-check"
INTERVAL=86400  # 24 hours in seconds

# If CLI not installed, attempt to install
if ! command -v rhombus &>/dev/null; then
  if command -v brew &>/dev/null; then
    echo "Rhombus CLI not found. Installing via Homebrew..."
    brew install RhombusSystems/tap/rhombus 2>&1
    if command -v rhombus &>/dev/null; then
      echo "Rhombus CLI installed. Run 'rhombus login' to authenticate."
    else
      echo "Homebrew install failed. Try manually: brew install RhombusSystems/tap/rhombus"
    fi
  else
    echo "Rhombus CLI is not installed. Install with one of:"
    echo "  brew install RhombusSystems/tap/rhombus"
    echo "  curl -fsSL https://raw.githubusercontent.com/RhombusSystems/rhombus-cli/main/install.sh | sh"
  fi
  mkdir -p "$(dirname "$MARKER")"
  date +%s > "$MARKER"
  exit 0
fi

# Skip update check if checked recently
if [ -f "$MARKER" ]; then
  last_check=$(cat "$MARKER" 2>/dev/null || echo 0)
  now=$(date +%s)
  elapsed=$((now - last_check))
  if [ "$elapsed" -lt "$INTERVAL" ]; then
    exit 0
  fi
fi

# Check for update via brew
if command -v brew &>/dev/null; then
  outdated=$(brew outdated --quiet RhombusSystems/tap/rhombus 2>/dev/null)
  if [ -n "$outdated" ]; then
    echo "A new version of the Rhombus CLI is available. Update with: brew upgrade rhombus"
  fi
fi

# Record check time
mkdir -p "$(dirname "$MARKER")"
date +%s > "$MARKER"

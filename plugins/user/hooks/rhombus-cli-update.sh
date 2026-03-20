#!/bin/bash
# Check for Rhombus CLI updates once per day.
# Runs on SessionStart — skips if checked recently or CLI not installed.

MARKER="${CLAUDE_PLUGIN_DATA:-.}/.last-cli-update-check"
INTERVAL=86400  # 24 hours in seconds

# Skip if CLI not installed
if ! command -v rhombus &>/dev/null; then
  echo "Rhombus CLI is not installed. Install with: brew install RhombusSystems/tap/rhombus"
  exit 0
fi

# Skip if checked recently
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

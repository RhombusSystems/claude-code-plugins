#!/usr/bin/env bash
# SessionStart hook — check age of bundled OpenAPI spec and notify if stale.
#
# The local spec at skills/rhombus-api/references/rhombus-api.json is used as a
# fallback when the MCP is unavailable. If it's >90 days old, the cached spec
# may drift from the live API. This hook prints a single-line reminder.

set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
SPEC_FILE="${PLUGIN_DIR}/skills/rhombus-api/references/rhombus-api.json"

if [[ ! -f "$SPEC_FILE" ]]; then
  exit 0
fi

# mtime in seconds since epoch, cross-platform (macOS + Linux)
if stat -f %m "$SPEC_FILE" >/dev/null 2>&1; then
  mtime=$(stat -f %m "$SPEC_FILE")
else
  mtime=$(stat -c %Y "$SPEC_FILE")
fi

now=$(date +%s)
age_days=$(( (now - mtime) / 86400 ))

if (( age_days > 90 )); then
  echo "[rhombus-developer] Local OpenAPI spec is ${age_days} days old. The 'rhombus-docs' MCP always has current docs; if you need the local spec refreshed, re-download from https://api2.rhombussystems.com/api/openapi/public.json"
fi

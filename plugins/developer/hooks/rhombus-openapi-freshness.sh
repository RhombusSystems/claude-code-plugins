#!/usr/bin/env bash
# SessionStart hook — check age of bundled OpenAPI spec and notify if stale.
#
# The local spec at skills/rhombus-api/references/rhombus-api.json is used as a
# fallback when the MCP is unavailable. Its age comes from the "syncedAt" field
# of rhombus-api.sync.json (written by scripts/refresh-openapi-spec.sh). File
# mtime is NOT used: it resets on every plugin install/update, so it never shows
# the spec's real age. If the spec is >90 days old, print a single-line reminder.

set -euo pipefail

PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
SYNC_FILE="${PLUGIN_DIR}/skills/rhombus-api/references/rhombus-api.sync.json"

[[ -f "$SYNC_FILE" ]] || exit 0

synced_at=$(sed -n 's/.*"syncedAt" *: *"\([0-9T:Z-]*\)".*/\1/p' "$SYNC_FILE" | head -1)
[[ -n "$synced_at" ]] || exit 0

# ISO-8601 UTC → epoch seconds, cross-platform (macOS + Linux)
if synced_epoch=$(date -u -j -f "%Y-%m-%dT%H:%M:%SZ" "$synced_at" +%s 2>/dev/null); then
  :
elif synced_epoch=$(date -u -d "$synced_at" +%s 2>/dev/null); then
  :
else
  exit 0
fi

age_days=$(( ($(date +%s) - synced_epoch) / 86400 ))

if (( age_days > 90 )); then
  echo "[rhombus-developer] Local OpenAPI spec was synced ${age_days} days ago (${synced_at}) and may be missing newer endpoints. The 'rhombus-docs' MCP always has current docs; the live spec is https://api2.rhombussystems.com/api/openapi/public.json"
fi

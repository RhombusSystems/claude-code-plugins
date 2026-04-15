---
description: Fetch and summarize recent Rhombus alerts, optionally filtered by camera and time window.
argument-hint: "[camera] [time window]"
---

Summarize recent Rhombus alerts for the user.

Parse `$ARGUMENTS`:
- First token (optional): camera name (fuzzy-matched, case-insensitive substring) or UUID
- Remainder (optional): time window like `1h`, `30m`, `24h`, `"yesterday"`, `"last night"`

Shell out to the CLI (from the `rhombus-user` plugin's `rhombus-cli` skill):

```bash
rhombus alert recent \
  ${CAMERA:+--camera "$CAMERA"} \
  ${WINDOW:+--after "$WINDOW"} \
  --max 20
```

Then summarize the result as a compact table:

| Time | Camera | Severity | Title | Alert UUID |
|---|---|---|---|---|

Also surface:
- Count of alerts in the window
- The most-alerting camera
- A 1–2 sentence pattern note if any (e.g., "5 of 8 alerts are motion alerts from the parking lot between 11pm and 2am — consider after-hours rule tuning.")

For any alert the user wants to investigate further, point them at:
- `/rhombus-analyze <alert-uuid>` for AI-driven frame analysis
- `rhombus alert play <alert-uuid>` to open the clip in a browser

If the CLI is not installed or the user is unauthenticated, surface the specific error and point at `rhombus login` or the SessionStart auto-installer.

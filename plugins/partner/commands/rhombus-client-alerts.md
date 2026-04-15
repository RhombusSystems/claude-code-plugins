---
description: Fetch and summarize recent Rhombus alerts scoped to a specific client organization, with an optional time window.
argument-hint: "[client-name] [time window]"
---

Summarize alerts for a specific client.

Parse `$ARGUMENTS`:

- First token: client name. If missing, ask (or use active client from `.claude/rhombus-partner.local.md`).
- Remainder: time window like `1h`, `30m`, `24h`, `"last night"`. Default: `1h`.

Resolve the client via the `rhombus-client-selector` agent if the name is ambiguous.

Run:

```bash
rhombus alert recent --partner-org "$CLIENT" \
  ${WINDOW:+--after "$WINDOW"} \
  --max 50 \
  --output json
```

Render as:

## Alerts for <Client> (window: <window>)

| Time | Camera | Severity | Title | Alert UUID |
|---|---|---|---|---|

Plus summary:

- **Total:** <N> alerts
- **Most-alerting camera:** <name> (<N> alerts)
- **Pattern note:** 1–2 sentences if anything stands out (time clustering, single-rule spike, etc.)
- **Recommended action:** e.g., "4 of 8 alerts are motion-after-hours at the parking lot — consider tuning the rule."

For any alert the user wants to dig into, point at:

- `rhombus alert play <uuid>` to open the clip
- `rhombus analyze alert <uuid> --partner-org "$CLIENT"` to analyze frames

If the client has zero alerts in the window, say so explicitly — silence is useful signal.

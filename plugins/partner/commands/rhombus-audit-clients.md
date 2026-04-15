---
description: Run a metric-per-client audit across every managed Rhombus client organization and produce a sorted report. Supported metrics — offline-cameras, alert-volume, storage, license, door-issues.
argument-hint: "[metric]"
---

Run a fleet-wide audit.

Parse `$ARGUMENTS` as the metric. If empty or unknown, list the supported metrics and ask.

## Supported metrics

| Metric | What it measures | Per-client command |
|---|---|---|
| `offline-cameras` | Count of cameras where `connectionState != "connected"` | `rhombus camera get-minimal-camera-state-list` |
| `alert-volume` | Alerts in the last 7 days (adjustable) | `rhombus alert recent --max 500 --after "7d ago"` |
| `storage` | Storage utilization % | `rhombus license get-license-state` (exact op may vary) |
| `license` | License slot utilization % | `rhombus license get-license-state` |
| `door-issues` | Doors with non-healthy status | `rhombus door get-minimal-door-state-list` |

Default time window for time-scoped metrics: 7 days. If the user says "this month" or "last 24 hours", adjust.

## Execution

Delegate to the `rhombus-fleet-ops` agent — it has the optimized loop pattern and handles per-client failures. Or inline:

```bash
rhombus partner get-partner-clients-v2 | jq -r '.partnerClients[].orgName' \
  | xargs -I{} -P 4 bash -c '<per-client logic with jq>'
```

## Output

```
# Fleet audit — <metric>

**Date:** <ISO>
**Clients scanned:** <N>
**Window:** <time window if applicable>

## Headline
<one sentence: "12 of 47 clients have offline cameras, worst: Acme (8)">

## Top 10

| Client | Value | Notes |
|---|---|---|

## Callouts
<anything >2σ from mean, or clients with zero issues worth celebrating>

## Recommended actions
1. …
2. …
```

For very large fleets (>100 clients), add a progress indicator inline.

Suggest follow-ups:

- `/rhombus-client-alerts <top-client> 7d` for a deeper drill-in
- `/rhombus-fleet-report weekly` for a scheduled version of this audit

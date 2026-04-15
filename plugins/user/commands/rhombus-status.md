---
description: One-shot Rhombus deployment health report — cameras online/offline, door states, sensor battery levels, and recent device issues.
---

Produce a compact health report for the user's Rhombus deployment.

Run these in parallel:

```bash
rhombus camera get-minimal-camera-state-list --output json
rhombus door get-minimal-door-state-list --output json
rhombus component get-component-list --output json   # if available
```

Aggregate the output into a single-pass report with these sections:

## Cameras
- Total cameras, online count, offline count (with names)
- Any cameras with firmware > 30 days behind latest
- Cameras reporting degraded video (if exposed)

## Doors
- Total doors, locked count, unlocked count
- Any doors in an error state

## Sensors + IoT (if present)
- Low-battery sensors (<20%)
- Sensors with stale readings (>1h since last report)

## Summary
- 1-sentence health verdict ("all good" / "3 cameras offline" / "door-controller-7 reporting errors")
- Next action (if any) — e.g., "Consider checking the Main Office network switch — 4 cameras offline at once usually means an upstream network issue."

Output format: plain markdown — no JSON dump. Cap the report at ~30 lines unless there are many issues.

If the CLI is missing, surface the error and point at `rhombus login` or the SessionStart auto-installer.

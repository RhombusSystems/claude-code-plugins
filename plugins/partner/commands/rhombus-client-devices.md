---
description: Produce a device inventory for one Rhombus client organization — cameras (online/offline, firmware), doors, sensors (battery/status).
argument-hint: "[client-name]"
---

Device inventory for a specific client.

Parse `$ARGUMENTS` as the client name. If empty, use the active client from `.claude/rhombus-partner.local.md`. If neither, ask.

Run these in parallel:

```bash
rhombus camera get-minimal-camera-state-list --partner-org "$CLIENT" --output json &
rhombus door get-minimal-door-state-list --partner-org "$CLIENT" --output json &
rhombus component get-component-list --partner-org "$CLIENT" --output json &
wait
```

Render as:

## Device inventory — <Client>

### Cameras (<N_online>/<N_total> online)

| Name | Status | Firmware | Last seen |
|---|---|---|---|

Flag any camera offline >24h or with firmware >3 minor versions behind.

### Doors (<N_locked>/<N_total> locked)

| Name | State | Controller | Issues |
|---|---|---|---|

### Sensors & other devices

| Name | Type | Battery | Last reading | Status |
|---|---|---|---|---|

Flag any sensor with battery <20% or stale >24h.

### Summary

- Total devices: <N>
- Healthy: <N>
- Degraded: <N> (list)
- Offline: <N> (list)

### Recommended actions

Prioritized list, e.g.:

1. Investigate <camera> — offline for 3 days.
2. Replace battery on <sensor> — 8% remaining.
3. Firmware update pending on <N> cameras.

Keep the report under ~50 lines unless the client has many issues.

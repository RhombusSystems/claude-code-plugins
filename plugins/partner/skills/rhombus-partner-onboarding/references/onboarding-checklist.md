# Partner Client Onboarding Checklist

Copy and adapt for each client. Every MSP has slightly different policies; keep a local fork of this file for your baseline.

## 0. Pre-flight

- [ ] Client organization exists in Rhombus and is visible via `rhombus partner get-partner-clients-v2`.
- [ ] Client admin email and role level decided (Admin / Manager / Viewer).
- [ ] Monitoring integration (PagerDuty / Slack / custom webhook) URL ready.
- [ ] Retention baseline JSON prepared (see below).

## 1. Activate the client

```bash
/rhombus-client-switch "<client-name>"
```

Verify `.claude/rhombus-partner.local.md` has `active_client: <client-name>`.

## 2. Sanity check access

```bash
rhombus camera get-minimal-camera-state-list
rhombus door get-minimal-door-state-list
rhombus user get-users-in-org
```

All three should return non-empty results (unless the client is brand-new).

## 3. Invite partner admin

Via CLI (if the user webservice exposes the partner invite operation) or via the Rhombus Console (`Admin → Users → Invite`).

```bash
rhombus user create-user \
  --user-email "partner-admin@example.com" \
  --role "Admin"
# exact flags may vary — run `rhombus user --help` for the current schema
```

## 4. Retention baseline

Partner-standard retention policy — adapt to your MSP's SLA:

```json
{
  "videoRetentionDays": 30,
  "eventRetentionDays": 90,
  "auditLogRetentionDays": 365,
  "aiInsightsRetentionDays": 180
}
```

Apply via the Policy Webservice — check `rhombus policy --help` for the current operation name (the spec evolves; don't hard-code it here).

## 5. Alert routing

- [ ] Create a webhook pointing at your monitoring system.
  ```bash
  rhombus developer create-webhook \
    --url "https://your-monitoring.example.com/rhombus" \
    --event-types "alert,doorAccess,vehicleDetection"
  ```
- [ ] Configure an escalation chain (primary → secondary → on-call).
- [ ] Set quiet hours for non-critical alerts if the client wants them.

## 6. Smoke test

```bash
# Pull recent alerts
rhombus alert recent --max 5

# Simulate a test alert (if an alert rule supports manual trigger; otherwise generate one by walking past a camera)
# Confirm it lands in your monitoring platform.
```

## 7. Document

- [ ] Client-ops log entry with: client name, onboarding date, partner admin email, retention settings, webhook URL, any deviations from the baseline.
- [ ] Slack/Teams announcement to your support team: "Client X is now live under partner management."

## 8. Hand off to day-2 ops

- [ ] Add to weekly health report scope (`/rhombus-fleet-report weekly` should pick them up automatically once active).
- [ ] Schedule a 30-day review check-in.

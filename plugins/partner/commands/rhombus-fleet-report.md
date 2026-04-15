---
description: Generate a shareable cross-client fleet report — weekly health, monthly executive, or incident rollup. Uses the rhombus-cross-client-reporting skill.
argument-hint: "[weekly|monthly|incident]"
---

Generate a cross-client fleet report.

Parse `$ARGUMENTS`:

- `weekly` (default) — 7-day health report, one-page, for the support team.
- `monthly` — 30-day executive report with trend lines, for customer success / leadership.
- `incident` — single-client rollup for a specific time window; ask the user for client + window if not provided.

Invoke the `rhombus-cross-client-reporting` skill with the chosen template.

The skill will:

1. Pull the client list via `rhombus partner get-partner-clients-v2`.
2. For each client, collect health + alert + license data in parallel.
3. Render using the template at `plugins/partner/skills/rhombus-cross-client-reporting/references/report-templates.md`.
4. Print the markdown report.

After the report prints, ask the user:

- "Save to `fleet-report-<weekly|monthly>-<YYYY-MM-DD>.md`?"
- "Share via email / Slack / ticket?" (don't actually send — just format for paste-in)
- "Drill into any client with `/rhombus-client-alerts <name>` or `/rhombus-client-devices <name>`?"

Large-fleet note (>50 clients): the report can take several minutes. Offer a progress indicator (e.g., "Processed 20/47 clients…") so the user knows it's working.

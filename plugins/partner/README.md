# Partner Plugin

Multi-org tooling for MSP and reseller partners managing many Rhombus client organizations. Version **2.0.0**.

## What's in the box

- **Three partner-specific skills** — CLI usage for partners, cross-client reporting, and new-client onboarding.
- **Three agents** — client-selector, fleet-ops, client-onboarding.
- **Six slash commands** for multi-org workflows.
- **Active-client state** stored in `.claude/rhombus-partner.local.md` so you don't type `--partner-org` on every call.
- **Partner-aware hooks** — session-init announces the active client; validate hook nudges you if you forget to scope.

## Skills

| Skill | Triggers on |
|---|---|
| `rhombus-partner-cli` | Partner auth, `--partner-org`, `rhombus partner get-partner-clients-v2`, multi-org recipes |
| `rhombus-cross-client-reporting` | Fleet reports, MSP rollups, weekly/monthly health summaries |
| `rhombus-partner-onboarding` | New-client onboarding flow (API access, invites, retention, alert routing) |

The partner plugin does **not** duplicate the user plugin's core CLI skill. If you also want `rhombus-cli`, `rhombus-deployment-context`, and `rhombus-mind` skills, enable the `rhombus-user` plugin alongside this one.

## Agents

| Agent | Triggers on |
|---|---|
| `rhombus-client-selector` | Any ambiguous client reference — fuzzy-matches, reads active-client, falls back to asking |
| `rhombus-fleet-ops` | Multi-org audits, health sweeps, alert volume rollups, license utilization |
| `rhombus-client-onboarding` | New-client onboarding walkthrough with validation at each step |

## Slash commands

| Command | Arg hint | Purpose |
|---|---|---|
| `/rhombus-clients` | — | List managed client orgs |
| `/rhombus-client-switch` | `[client-name]` | Set active client (slash-only; writes to `.claude/rhombus-partner.local.md`) |
| `/rhombus-audit-clients` | `[metric]` | Fleet-wide audit: offline-cameras, alert-volume, storage, license, door-issues |
| `/rhombus-client-alerts` | `[client-name] [time]` | Alerts for one client |
| `/rhombus-client-devices` | `[client-name]` | Device inventory for one client |
| `/rhombus-fleet-report` | `[weekly\|monthly\|incident]` | Cross-client rollup using report templates |

## Hooks

| Hook | Event | Purpose |
|---|---|---|
| `rhombus-cli-update.sh` | SessionStart | Install CLI if missing; daily update check |
| `rhombus-partner-session-init` | SessionStart | Announce the active client (or warn if unset) |
| `rhombus-cli-validate` | PreToolUse (Bash) | Flag client-scoped commands missing `--partner-org` when no active client is set; catch common mistakes |

## Quick start

```bash
# Enable the plugin
/plugin enable rhombus-partner

# Authenticate as a partner
rhombus login

# See your managed clients
/rhombus-clients

# Set an active client for this workspace
/rhombus-client-switch "acme corp"

# Fleet-wide audit
/rhombus-audit-clients offline-cameras

# Weekly fleet report
/rhombus-fleet-report weekly
```

## Pairing

Most partners will also enable `rhombus-user` for the core CLI skills, and `rhombus-developer` if they're building custom integrations per client. All three plugins coexist cleanly — no overlap, no duplicate commands.

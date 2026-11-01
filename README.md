# Rhombus Claude Code Plugin Marketplace

A plugin marketplace for Claude Code, organized by persona. Install only the plugin relevant to you.

Docs: https://developer.rhombus.com/claude-code-plugins · Support: support@rhombus.com

## Quick Start

### 1. Add the marketplace

```
/plugin marketplace add RhombusSystems/claude-code-plugins
```

### 2. Enable your plugin

```
/plugin enable rhombus-developer
/plugin enable rhombus-user
/plugin enable rhombus-partner
```

Enable only the plugin for your role. You can enable multiple if needed.

See [docs/usage.md](docs/usage.md) for full installation details.

## Plugins

| Plugin | For | Key capabilities |
|---|---|---|
| [developer](plugins/developer/) | Engineers building on Rhombus | MCP-first: auto-wires `rhombus-node-mcp` + docs MCP. Six `/rhombus-*` commands (endpoint search, schema, curl, SDK codegen, MCP status, new project). API-architect + webhook-debugger agents. Skills for full API reference (1,040+ endpoints incl. Robot, Relay/NVR + third-party RTSP), SDK codegen, webhook receivers, and edge streaming (RTSP/ONVIF). |
| [user](plugins/user/) | Day-to-day Rhombus customers | Rhombus CLI, deployment context (analyze/stitch), Rhombus MIND AI, curated support-article index. Five workflow commands (alerts, status, watch, analyze, context-refresh). CLI, alerts, devices, footage-investigator agents. CLI auto-installer + command validator. |
| [partner](plugins/partner/) | MSPs and resellers | Active-client session state, fleet-ops audits, cross-client reporting, client onboarding. Six multi-org commands (clients, client-switch, audit-clients, client-alerts, client-devices, fleet-report). Client-selector + fleet-ops + onboarding agents. Partner-aware command validation. |

## What's new in developer 2.0.2

- Local OpenAPI spec re-synced to the live API (1,041 endpoints, up from 986; adds Robot, device labels/health, API-token and webhook-secret rotation, Pane endpoints; drops 7 retired Alert Monitoring/Noonlight endpoints).
- The `rhombus-docs` MCP now points at `https://developer.rhombus.com/mcp` (the old `api-docs.rhombus.community/mcp` URL redirects to the docs home page, so the server never attached); tool references updated to `search_rhombus_developer` and `query_docs_filesystem_rhombus_developer`.
- The freshness hook now reads the spec's real sync date from `rhombus-api.sync.json` instead of file mtime (which reset on every install, so it never warned).
- Maintainers: refresh with `scripts/refresh-openapi-spec.sh`, update the counts in `SKILL.md`/READMEs, and bump the developer plugin version.

## What's new in 2.0

- Every plugin now ships user-invoked `/rhombus-*` slash commands in addition to model-invoked skills.
- Developer plugin auto-configures two MCP servers (official API MCP + docs MCP) — no manual setup.
- User plugin split the monolithic CLI skill into focused skills (CLI, deployment-context, MIND, support-links) so the right one triggers.
- Partner plugin is no longer a user-plugin copy — genuine multi-org workflows with active-client state and fleet-ops agents.
- Local OpenAPI spec refreshed to CLI v0.16.0 (892 endpoints; adds Relay/NVR and third-party RTSP services).

## Creating New Skills

See [docs/contributing.md](docs/contributing.md) for the full guide. Use `template/SKILL.md` as your starting point.

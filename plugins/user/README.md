# User Plugin

Day-to-day tools for Rhombus platform users. Version **2.0.0**.

## Skills

| Skill | Triggers on |
|---|---|
| `rhombus-cli` | Installation, auth, global flags, auto-generated API commands (`rhombus camera …`, etc.), and the hand-written `login`, `configure`, `alert`, `footage` commands |
| `rhombus-deployment-context` | `rhombus context`, `analyze`, `stitch` — anything about camera snapshots, footage analysis, multi-camera stitch review |
| `rhombus-mind` | `rhombus chat` and `rhombus voice` — natural-language and voice interaction with Rhombus MIND |
| `rhombus-support-links` (background) | NAS, RTSP, provisioning, alert rules, user/role management — surfaces support.rhombussystems.com article pointers |

## Slash commands

| Command | Arg hint | Purpose |
|---|---|---|
| `/rhombus-alerts` | `[camera] [time window]` | Fetch + summarize recent alerts |
| `/rhombus-status` | — | One-shot deployment health report |
| `/rhombus-watch` | `[camera]` | Open live footage in the browser (slash-only) |
| `/rhombus-analyze` | `[alert-uuid \| camera time-range]` | AI-driven footage analysis |
| `/rhombus-context-refresh` | — | Regenerate `~/.rhombus/context/<profile>/` (slash-only) |

## Agents

| Agent | Triggers on |
|---|---|
| `rhombus-cli` | Building and executing rhombus commands from natural-language descriptions |
| `rhombus-alerts` | Alert monitoring, security-event investigation, footage download |
| `rhombus-devices` | Device inventory, online/offline audits, sensor data |
| `rhombus-footage-investigator` | "What happened at X time on camera Y" incident reconstruction |

## Hooks

| Hook | Event | Purpose |
|---|---|---|
| `rhombus-cli-update.sh` | SessionStart | Installs the CLI if missing; checks for updates (daily throttle) |
| `rhombus-cli-validate` | PreToolUse (Bash) | Validates `rhombus` commands for common mistakes and suggests jq/filter improvements |

## Quick Start

```bash
# Enable the plugin — SessionStart hook will install the CLI automatically
/plugin enable rhombus-user

# Authenticate
rhombus login

# Get a deployment health snapshot
/rhombus-status

# Investigate something
/rhombus-analyze "front lobby" "last night between 11pm and midnight"
```

## Tip

The user plugin is intentionally CLI-driven. If you also need direct API integration (HTTP calls, SDK generation, OpenAPI spec, webhooks, MCP tools), enable `rhombus-developer` alongside.

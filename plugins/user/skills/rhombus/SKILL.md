---
name: rhombus
description: >
  Rhombus CLI reference and usage guide for the `rhombus` command-line tool.
  Use this skill when the user asks about the Rhombus CLI, wants to run rhombus
  commands, needs help with rhombus login/configure/alert/chat/live/voice,
  wants to interact with Rhombus cameras/sensors/doors/devices from the terminal,
  asks about rhombus CLI installation, authentication, profiles, or configuration,
  or mentions: rhombus cli, rhombus command, rhombus terminal, camera alerts,
  live stream, rhombus mind, voice assistant, rhombus api from command line,
  device management cli, access control cli, brew install rhombus.
argument-hint: "[command or topic]"
allowed-tools: Read, Grep, Glob, Bash
---

# Rhombus CLI

The `rhombus` CLI wraps the entire Rhombus REST API into a single binary. It includes 6 hand-written commands and ~60 auto-generated service groups covering 846+ API endpoints.

## Installation

```bash
# Homebrew (macOS)
brew install RhombusSystems/tap/rhombus

# Shell script (macOS/Linux)
curl -fsSL https://raw.githubusercontent.com/RhombusSystems/rhombus-cli/main/install.sh | sh

# PowerShell (Windows)
irm https://raw.githubusercontent.com/RhombusSystems/rhombus-cli/main/install.ps1 | iex
```

Source: https://github.com/RhombusSystems/rhombus-cli

## Authentication

Two methods — browser-based (recommended) or manual:

```bash
# Browser-based OAuth2 login (creates permanent API key automatically)
rhombus login

# Manual configuration
rhombus configure
# Prompts for: API Key, Output format, Endpoint URL
```

### Profiles

Multiple named profiles are supported (like AWS CLI):

```bash
rhombus configure --profile staging
rhombus alert recent --profile staging
```

### Environment Variables

Override any config setting:

| Variable | Purpose |
|----------|---------|
| `RHOMBUS_API_KEY` | API key |
| `RHOMBUS_PROFILE` | Active profile name |
| `RHOMBUS_OUTPUT` | Output format (json/table/text) |
| `RHOMBUS_ENDPOINT_URL` | API base URL |

### Config Files

Stored in `~/.rhombus/` as INI format:
- `~/.rhombus/config` — settings (output format, endpoint)
- `~/.rhombus/credentials` — API keys (file mode 0600)
- `~/.rhombus/certs/<profile>/` — client certs for mTLS auth

## Global Flags

Every command accepts these:

| Flag | Description |
|------|-------------|
| `--profile` | Config profile (default: "default") |
| `--output` | Output format: json, table, text |
| `--api-key` | Override API key for this call |
| `--endpoint-url` | Override API base URL |
| `--version` | Show CLI version |

## Hand-Written Commands

### `rhombus login`
Browser-based OAuth2 PKCE authentication. Opens browser, receives callback on `localhost:11434`, creates a permanent API key. Supports partner accounts. 5-minute timeout.

### `rhombus configure`
Interactive setup: API key, output format, endpoint URL. Use `--profile` for multi-profile configs.

### `rhombus alert`

| Subcommand | Description | Key Flags |
|------------|-------------|-----------|
| `alert recent` | List policy alerts from last hour | `--camera` (name/UUID), `--after` ("1h ago", "5m ago", epoch ms), `--max` (default 20) |
| `alert thumb [uuid]` | Download alert thumbnail JPEG | `--output` (file path) |
| `alert download [uuid]` | Download alert video clip | `--output` (file path) |
| `alert play [uuid]` | Play alert clip in browser | — |

Camera names are fuzzy-matched (case-insensitive substring).

### `rhombus footage [camera]`
Opens a Rhombus camera player in the browser. Defaults to live view. Use `--start` to jump to a specific time in the past.

```bash
rhombus footage "front lobby"
rhombus footage "front lobby" --start "5m ago"
rhombus footage "front lobby" --token-duration 7200   # 2-hour session
```

### `rhombus chat`
Interactive AI chat with Rhombus MIND (backed by Claude). MIND can execute CLI commands locally via tool use — it has full access to the `rhombus` CLI.

```bash
rhombus chat
# Then type natural language queries about your system
```

### `rhombus voice`
Voice-powered chat with Rhombus MIND. Records audio via `sox`, transcribes with `whisper-cpp`.

```bash
rhombus voice
rhombus voice --model medium   # Options: tiny, base, small (default), medium, large
```

**Dependencies:** `sox` (recording), `whisper-cpp` (transcription). Models auto-download to `~/.rhombus/models/`.

## Auto-Generated API Commands

~60 service groups, each with multiple subcommands mapping to Rhombus API endpoints. Every generated command follows the same pattern:

```bash
rhombus <service-group> <operation> [flags]

# Examples
rhombus camera get-minimal-camera-state-list
rhombus door get-minimal-door-state-list
rhombus user get-users-in-org
rhombus event get-policy-alerts-v2 --after-timestamp-ms 1700000000000
```

### Key Patterns

**Discover available operations:**
```bash
rhombus camera --help
rhombus access-control --help
```

**Generate a JSON skeleton with all parameters:**
```bash
rhombus camera get-camera-config --generate-cli-skeleton
# Prints JSON template with all available fields and example values
```

**Pass parameters as JSON:**
```bash
# Inline JSON
rhombus camera get-camera-config --cli-input-json '{"cameraUuid":"cam_123"}'

# From file
rhombus camera get-camera-config --cli-input-json file://params.json
```

**Flags override JSON input:** If both `--cli-input-json` and individual flags are set, flags take precedence.

**Flag naming:** All flags use kebab-case (e.g., `--camera-uuid`, `--after-timestamp-ms`). These map to camelCase API parameters automatically.

**All API calls are POST.** The entire Rhombus API uses POST, even for reads.

### Service Groups

See `references/commands.md` for the complete list of all 60+ service groups with descriptions. The major categories:

- **Devices:** camera, sensor, door, door-controller, doorbell-camera, audiogateway, audioplayback, elevator, climate, badge-reader, button, ble, media-device, device-config
- **Access Control:** access-control, access-control-integrations, guest-management-kiosk
- **AI & Analytics:** face-recognition-person, face-recognition-event, face-recognition-matchmaker, vehicle, occupancy, logistics, proximity, scene-query, search
- **Events & Monitoring:** event, event-search, alert-monitoring, alarm-monitoring-keypad, lockdown-plan, policy, rules, rules-records, schedule, rapidsos
- **Organization:** org, user, user-metadata, customer, location, permission, license, feature, partner
- **Integrations:** integrations, webhook-integrations, org-integrations, iot-integrations, storage-integrations, incident-management-integrations, service-management-integrations, oauth, developer
- **Media & Reports:** video, upload, export, report, tvos-config, help-service

## Common Workflows

See `references/workflows.md` for detailed recipes. Quick examples:

```bash
# Check recent alerts for a specific camera
rhombus alert recent --camera "parking lot" --max 5

# List all cameras
rhombus camera get-minimal-camera-state-list

# Get door states
rhombus door get-minimal-door-state-list

# Watch a live stream
rhombus footage "main entrance"

# Ask MIND about your system
rhombus chat
> "Show me all motion alerts from the last 30 minutes"

# Generate API call skeleton
rhombus report get-count-report --generate-cli-skeleton

```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `command not found: rhombus` | Run install again or check PATH includes `/usr/local/bin` |
| Auth errors | Run `rhombus login` or check `~/.rhombus/credentials` |
| Wrong org data | Check `--profile` flag or `RHOMBUS_PROFILE` env var |
| Voice deps missing | Install `sox` (`brew install sox`) and `whisper-cpp` |
| Login timeout | Ensure browser can reach `console.rhombussystems.com` and callback port 11434 is free |

## API Base URL

Default: `https://api2.rhombussystems.com`

Override per-command with `--endpoint-url` or globally via `rhombus configure`.

## Relationship to Rhombus API

This skill covers the CLI tool. For direct API integration (HTTP calls, SDK generation, OpenAPI spec, webhooks), install the `rhombus-developer` plugin. The CLI wraps the same API — every auto-generated CLI command maps 1:1 to an API endpoint.

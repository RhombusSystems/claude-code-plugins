# User Plugin

Day-to-day tools for Rhombus platform users.

## Skills

| Skill | Command | Description |
|---|---|---|
| `rhombus` | `/rhombus` | Rhombus CLI tool reference — all commands, auth, workflows, and troubleshooting |

## Agents

| Agent | Description |
|---|---|
| `rhombus-cli` | General-purpose CLI assistant — builds and executes `rhombus` commands |
| `rhombus-alerts` | Alert monitoring specialist — investigates security events, downloads footage |
| `rhombus-devices` | Device management — inventories cameras, sensors, doors, audits deployments |

## Hooks

| Hook | Event | Description |
|---|---|---|
| `rhombus-cli-validate` | PreToolUse (Bash) | Validates rhombus commands and suggests improvements (jq piping, flag format) |
| `rhombus-cli-update` | SessionStart | Checks for CLI updates daily, notifies if a new version is available |

## Quick Start

```bash
# Install the Rhombus CLI
brew install RhombusSystems/tap/rhombus

# Authenticate
rhombus login

# Enable the plugin
/plugin enable rhombus-user

# List your cameras
rhombus camera get-minimal-camera-state-list
```

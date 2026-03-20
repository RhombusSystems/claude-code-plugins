# Partner Plugin

Tools for MSP and reseller partners managing multiple client organizations on the Rhombus platform.

> **Note:** This plugin starts with the same content as the user plugin and will be customized with partner-specific workflows for multi-org management.

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
/plugin enable rhombus-partner

# List cameras for a client org
rhombus camera get-minimal-camera-state-list --partner-org "acme corp"
```

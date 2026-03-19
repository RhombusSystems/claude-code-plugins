# Developer & Technical Teams Plugin

Skills, agents, and hooks for software engineers, DevOps, QA, and other technical contributors building on the Rhombus platform.

## Skills

| Skill | Command | Description |
|---|---|---|
| `code-review` | `/code-review` | Structured code review for quality, security, and performance |
| `api-doc` | `/api-doc` | Generate API documentation from source code |
| `rhombus-api` | `/rhombus-api` | Full Rhombus API reference (846+ endpoints, OpenAPI spec, SDK generation) |
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
| `rhombus-api-intercept` | PreToolUse (Bash) | Suggests `rhombus` CLI when detecting raw curl/wget calls to Rhombus APIs |
| `rhombus-cli-validate` | PreToolUse (Bash) | Validates rhombus commands and suggests improvements (jq piping, flag format) |

## Rhombus CLI Quick Start

```bash
brew install RhombusSystems/tap/rhombus
rhombus login
rhombus camera get-minimal-camera-state-list
```

See the `/rhombus` skill for full CLI documentation, or ask the `rhombus-cli` agent to help build commands.

## Adding a skill

Place new skills under `plugins/developers/skills/<skill-name>/SKILL.md`. See [docs/contributing.md](../../docs/contributing.md) for the full guide.

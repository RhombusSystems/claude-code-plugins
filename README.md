# Rhombus Claude Code Plugin Marketplace

A plugin marketplace for Claude Code, organized by persona. Install only the plugin relevant to you.

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

| Plugin | For | Contents |
|---|---|---|
| [developer](plugins/developer/) | Engineers building on the Rhombus platform | API reference (892+ endpoints), API doc generation, code review, API intercept hook |
| [user](plugins/user/) | Day-to-day Rhombus platform users | CLI reference, CLI/alerts/devices agents, CLI validate hook |
| [partner](plugins/partner/) | MSP/reseller managing client orgs | CLI reference, CLI/alerts/devices agents, CLI validate hook (to be customized) |

## Creating New Skills

See [docs/contributing.md](docs/contributing.md) for the full guide. Use `template/SKILL.md` as your starting point.

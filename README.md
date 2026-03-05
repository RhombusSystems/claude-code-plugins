# Rhombus Claude Code Plugin Marketplace

A centralized plugin marketplace for Claude Code, organized by Rhombus team. Each team installs only the plugin relevant to them.

## What is this?

This repository is a plugin marketplace for Claude Code. Plugins are collections of skills — reusable prompt modules that give Claude specialized capabilities triggered by slash commands. Each team's plugin is independent: a marketing person never needs to install developer plugins, and vice versa.

## Quick Start

> **Internal repo** — you must be a RhombusSystems org member with GitHub authentication configured in your terminal. If `git clone https://github.com/RhombusSystems/claude-code-plugins` works, the command below will too.

### 1. Add the marketplace

```
/plugin marketplace add RhombusSystems/claude-code-plugins
```

### 2. Enable your team's plugin

```
/plugin enable developers
/plugin enable business-ops
/plugin enable marketing
/plugin enable finance
/plugin enable plugin-creator
```

Enable only the plugin for your team. You can enable multiple if needed.

See [docs/usage.md](docs/usage.md) for full installation details.

## Plugins

| Plugin | For | Skills |
|---|---|---|
| [developers](plugins/developers/) | Engineering, DevOps, QA | Code review, debugging, architecture, tests, CI/CD |
| [business-ops](plugins/business-ops/) | Operations, Project Management | SOPs, meeting summaries, OKRs, status reports |
| [marketing](plugins/marketing/) | Marketing, Growth, Content | Ad copy, campaigns, blog posts, social posts |
| [finance](plugins/finance/) | Finance, Accounting | Budget analysis, reports, expense categorization |
| [plugin-creator](plugins/plugin-creator/) | Anyone creating new skills | Generate, eval, and publish skills |

## Creating New Skills

Any team member can create and publish a new skill using the `plugin-creator` plugin. See [docs/contributing.md](docs/contributing.md) for the full guide.

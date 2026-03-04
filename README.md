# Rhombus Claude Code Skills

A centralized, organized library of Claude Code skills for use across Rhombus teams.

## What is this?

This repository is a shared skills library that any Rhombus team can plug into their Claude Code setup. Skills are reusable prompt modules that give Claude specialized capabilities — like running code reviews, drafting finance reports, or generating marketing copy — triggered by a simple slash command.

## Quick Start: Register as a Plugin

Add all Rhombus skills to your Claude Code project with one command:

```
/plugin marketplace add rhombus/claude-code-skills
```

Then enable the skill group you need:

```
/plugin enable skill-creator
/plugin enable developers
/plugin enable business-ops
/plugin enable marketing
/plugin enable finance
```

See [docs/usage.md](docs/usage.md) for full installation and activation details.

## Skill Categories

| Category | Description | Skills |
|---|---|---|
| [skill-creator](skills/skill-creator/) | Meta-skill for creating, testing, and publishing new Rhombus skills | Generate, eval, and publish skills |
| [developers](skills/developers/) | Skills for Developer & Technical Teams | Code review, debugging, architecture |
| [business-ops](skills/business-ops/) | Skills for Business Operations | Workflows, reporting, process docs |
| [marketing](skills/marketing/) | Skills for Marketing | Copy, campaigns, content strategy |
| [finance](skills/finance/) | Skills for Finance | Reports, analysis, budgeting |

## Creating New Skills

Any team member can create and publish a new skill using the `skill-creator` meta-skill. See [docs/contributing.md](docs/contributing.md) for the full guide.

## Using Skills

See [docs/usage.md](docs/usage.md) for how to install and activate skills in your project.

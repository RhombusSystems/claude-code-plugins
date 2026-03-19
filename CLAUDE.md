# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the Rhombus Claude Code plugin marketplace — a centralized repo where team-specific plugins (collections of skills) are published and installed via Claude Code's `/plugin` system. Each plugin targets a specific team (developers, business-ops, marketing, finance) so users only install what's relevant to them.

## Architecture

**Marketplace layer:** `.claude-plugin/marketplace.json` is the registry that maps plugin names to their source directories under `plugins/`. Claude Code reads this file when a user runs `/plugin marketplace add` against the repo.

**Plugin layer:** Each `plugins/<name>/` directory is a self-contained plugin with its own `.claude-plugin/plugin.json` manifest (name, description, version, author). Plugins are the installable unit.

**Skill layer:** Inside each plugin, `skills/<skill-name>/SKILL.md` defines an individual capability. The SKILL.md frontmatter (`name`, `description`, `disable-model-invocation`, `argument-hint`, `context`, `allowed-tools`, `user-invocable`) controls how and when Claude triggers the skill. The markdown body contains the instructions Claude follows.

**Template:** `template/SKILL.md` is the canonical starting point for new skills — it documents all available frontmatter fields with comments.

## Key Conventions

- **Skill descriptions are the trigger mechanism.** A vague description means a skill that never fires. Be explicit about what requests, phrasings, and contexts should activate it. See `docs/contributing.md` for strong vs weak description examples.
- **`disable-model-invocation: true`** is required on any skill with side effects (deploy, commit, send messages, post externally).
- **Kebab-case** for all skill folder names (e.g., `code-review`, not `codeReview`).
- **Keep SKILL.md under 500 lines.** Move large reference material to `references/` subdirectories.
- **Branch naming** for new skills: `plugin/<category>/<skill-name>` (e.g., `plugin/developers/code-review`).

## Creating New Skills

Use the `plugin-creator` meta-plugin at `plugins/plugin-creator/`. It runs an interview → draft → test → eval loop with built-in eval scripts at `plugins/plugin-creator/skills/plugin-creator/scripts/`. Full workflow documented in `docs/contributing.md`.

## Skill Folder Structure

Minimum:
```
plugins/<plugin>/skills/<skill-name>/SKILL.md
```

Optional additions: `references/` (docs loaded on demand), `scripts/` (executable scripts), `assets/` (templates, icons).

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the Rhombus Claude Code plugin marketplace — a centralized repo where plugins are published and installed via Claude Code's `/plugin` system. Three plugins, one per persona:

| Plugin | Slug | Audience |
|---|---|---|
| `plugins/developer/` | `rhombus-developer` | Engineers building on the Rhombus platform |
| `plugins/user/` | `rhombus-user` | Day-to-day Rhombus platform users |
| `plugins/partner/` | `rhombus-partner` | MSP/reseller managing client orgs |

## Architecture

Three layers, outer to inner:

**Marketplace** — `.claude-plugin/marketplace.json` is the registry that maps plugin slugs to source directories under `plugins/`. Claude Code reads this when a user runs `/plugin marketplace add` against the repo.

**Plugin** — Each `plugins/<name>/` directory is self-contained with its own `.claude-plugin/plugin.json` manifest (name, description, version, author). A plugin can contain skills, hooks, and agents.

**Components** inside a plugin:

- **Skills** (`skills/<skill-name>/SKILL.md`) — Individual capabilities. Frontmatter fields (`name`, `description`, `disable-model-invocation`, `argument-hint`, `context`, `allowed-tools`, `user-invocable`) control triggering. The markdown body is the instruction set.
- **Hooks** (`hooks/*.md` or `hooks/*.sh`) — Event-driven interceptors. Prompt-based hooks (`.md`) use frontmatter (`event`, `matcher`, `type: prompt`) to intercept tool calls (e.g., `PreToolUse` on `Bash`). Shell hooks (`.sh`) run as scripts.
- **Agents** (`agents/*.md`) — Subagent definitions for specialized autonomous tasks (e.g., CLI assistance, alert monitoring, device management).

**Template:** `template/SKILL.md` is the canonical starting point for new skills — it documents all available frontmatter fields with comments.

## Key Conventions

- **Skill descriptions are the trigger mechanism.** A vague description means a skill that never fires. Be explicit about what requests, phrasings, and contexts should activate it. See `docs/contributing.md` for strong vs weak description examples.
- **`disable-model-invocation: true`** is required on any skill with side effects (deploy, commit, send messages, post externally).
- **Kebab-case** for all folder names (e.g., `code-review`, not `codeReview`).
- **Keep SKILL.md under 500 lines.** Move large reference material to `references/` subdirectories.
- **Branch naming** for new skills: `plugin/<persona>/<skill-name>` (e.g., `plugin/developer/code-review`).
- **Version bumps** — when updating plugin capabilities, bump the `version` field in each affected plugin's `.claude-plugin/plugin.json` and in `.claude-plugin/marketplace.json`.

## Creating New Skills

1. Copy `template/SKILL.md` as your starting point
2. Place the skill in the appropriate plugin under `plugins/<persona>/skills/<skill-name>/SKILL.md`
3. See `docs/contributing.md` for the full guide

## Skill Folder Structure

Minimum:
```
plugins/<plugin>/skills/<skill-name>/SKILL.md
```

Optional additions: `references/` (docs loaded on demand), `scripts/` (executable scripts), `assets/` (templates, icons).

## CI/CD

Two GitHub Actions workflows in `.github/workflows/`:

- **`claude.yml`** — Responds to `@claude` mentions in issues, PR comments, and review comments using `anthropics/claude-code-action@v1`.
- **`claude-code-review.yml`** — Auto-reviews PRs on open/sync/reopen using the `code-review` plugin skill. Both require the `CLAUDE_CODE_OAUTH_TOKEN` secret.

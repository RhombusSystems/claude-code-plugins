# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the Rhombus Claude Code plugin marketplace — a centralized repo where plugins are published and installed via Claude Code's `/plugin` system. **Content-only repo**: no build/lint/test tooling, no `package.json`. Changes are Markdown + JSON; validation happens when Claude Code loads the plugin. Three plugins, one per persona:

| Plugin | Slug | Audience |
|---|---|---|
| `plugins/developer/` | `rhombus-developer` | Engineers building on the Rhombus platform |
| `plugins/user/` | `rhombus-user` | Day-to-day Rhombus platform users |
| `plugins/partner/` | `rhombus-partner` | MSP/reseller managing client orgs |

## Architecture

Three layers, outer to inner:

**Marketplace** — `.claude-plugin/marketplace.json` is the registry that maps plugin slugs to source directories under `plugins/`. Claude Code reads this when a user runs `/plugin marketplace add` against the repo.

**Plugin** — Each `plugins/<name>/` directory is self-contained with its own `.claude-plugin/plugin.json` manifest (name, description, version, author). A plugin can contain skills, commands, agents, hooks, and an MCP-server config.

**Components** inside a plugin:

- **Skills** (`skills/<skill-name>/SKILL.md`) — Model-invoked capabilities. Frontmatter fields (`name`, `description`, `disable-model-invocation`, `argument-hint`, `context`, `allowed-tools`, `user-invocable`) control triggering. The markdown body is the instruction set.
- **Commands** (`commands/*.md`) — User-invoked slash commands (e.g., `/rhombus-alerts`). Frontmatter: `description`, `argument-hint`, `disable-model-invocation` (to keep them slash-only). Use commands for side-effectful or high-friction workflows that benefit from explicit invocation.
- **Hooks** (`hooks/*.md` or `hooks/*.sh`) — Event-driven interceptors. Prompt-based hooks (`.md`) use frontmatter (`event`, `matcher`, `type: prompt`) to intercept tool calls (e.g., `PreToolUse` on `Bash`). Shell hooks (`.sh`) run as scripts and are wired via the plugin's `plugin.json` `hooks` field.
- **Agents** (`agents/*.md`) — Subagent definitions for specialized autonomous tasks. Frontmatter: `name`, `description` (with `<example>` blocks), `tools`, `color`.
- **MCP servers** (`.mcp.json` at plugin root) — External tool integrations. The developer plugin wires `rhombus-node-mcp` (stdio/npx) and the Rhombus docs MCP (HTTP); tools appear as `mcp__<server>__<tool>` in Claude.

**Template:** `template/SKILL.md` is the canonical starting point for new skills — it documents all available frontmatter fields with comments.

## Key Conventions

- **Skill descriptions are the trigger mechanism.** A vague description means a skill that never fires. Be explicit about what requests, phrasings, and contexts should activate it. See `docs/contributing.md` for strong vs weak description examples.
- **`disable-model-invocation: true`** is required on any skill with side effects (deploy, commit, send messages, post externally).
- **Kebab-case** for all folder names (e.g., `code-review`, not `codeReview`).
- **Keep SKILL.md under 500 lines.** Move large reference material to `references/` subdirectories.
- **Branch naming** for new skills: `plugin/<persona>/<skill-name>` (e.g., `plugin/developer/code-review`). For multi-component reworks that touch several components in one plugin, use `plugin/<persona>/<version>` (e.g., `plugin/partner/2.0`).
- **Version bumps** — each plugin's version lives in its own `plugins/<name>/.claude-plugin/plugin.json`. The root `.claude-plugin/marketplace.json` has a separate `metadata.version` for the marketplace as a whole; bump it when the marketplace registry itself changes (e.g., a new plugin is added), not on every plugin capability change.

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
- **`claude-code-review.yml`** — Auto-reviews PRs on open/sync/reopen using Anthropic's upstream `code-review` plugin (from `github.com/anthropics/claude-code`), not this repo's `rhombus-developer/skills/code-review`. Both workflows require the `CLAUDE_CODE_OAUTH_TOKEN` secret.

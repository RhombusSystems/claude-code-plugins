# Contributing to the Rhombus Plugin Marketplace

This guide walks you through adding new components to the Rhombus plugin marketplace. The bulk of the doc covers **skills** (model-invoked capabilities), with dedicated sections at the bottom for **slash commands** and **MCP servers**.

**Terminology:** A **plugin** is the persona-level installable unit (e.g., `developer`, `user`, `partner`). Inside a plugin you can add:
- **Skills** (`skills/<name>/SKILL.md`) — model-invoked
- **Slash commands** (`commands/<name>.md`) — user-invoked
- **Agents** (`agents/<name>.md`) — specialized subagents
- **Hooks** (`hooks/<name>.md` or `.sh`) — event-driven
- **MCP servers** (`.mcp.json` at plugin root) — external tool integrations

This is the Claude Code spec terminology — keep it consistent.

## Prerequisites

- Claude Code installed and configured
- Access to the [RhombusSystems/claude-code-plugins](https://github.com/RhombusSystems/claude-code-plugins) repo

## Steps

### 1. Start from the template

Copy `template/SKILL.md` into the appropriate plugin:

```bash
mkdir -p plugins/<persona>/skills/<skill-name>
cp template/SKILL.md plugins/<persona>/skills/<skill-name>/SKILL.md
```

Edit the SKILL.md to define your skill's name, description, and instructions.

### 2. Write a strong description

The `description` field in your `SKILL.md` frontmatter is the **primary mechanism** that determines whether Claude uses your skill. A weak description means a skill that never triggers.

**Guidelines:**
- Include both what the skill does *and* the specific contexts, phrasings, or requests that should trigger it
- Be explicit rather than vague — Claude tends to undertrigger skills with short or generic descriptions
- Err on the side of "pushy": spell out edge cases and adjacent use cases where the skill applies, even when the user doesn't use the exact skill name

**Weak:**
```yaml
description: Summarize documents.
```

**Strong:**
```yaml
description: >
  Summarize documents, reports, meeting notes, or long-form content into
  key points and action items. Use this skill whenever the user asks to
  summarize, recap, condense, or extract the main points from any document,
  even if they don't explicitly say "summarize".
```

### 3. Choose the right frontmatter flags

**`disable-model-invocation: true`** — Add this to any skill that has side effects or that you want to control manually:

```yaml
---
name: send-report
description: Send the weekly report to the finance Slack channel
disable-model-invocation: true
---
```

Without this flag, Claude may decide to run the skill on its own. Use it for anything that deploys, commits, sends a message, posts externally, or modifies shared systems.

**`argument-hint`** — Add this if your skill takes input, so users see a hint in autocomplete:

```yaml
---
name: code-review
description: Review a file or PR for issues and improvements
argument-hint: "[filename or PR number]"
---
```

**`context: fork`** — Add this to run the skill in an isolated subagent with no access to your conversation history. Good for research tasks or long-running work you want to run independently.

See `template/SKILL.md` for the full list of available frontmatter fields.

### 4. Place the skill in the correct plugin folder

Put your skill in the appropriate plugin under `plugins/`:

| Persona | Folder |
|---|---|
| Developer | `plugins/developer/skills/<skill-name>/` |
| User | `plugins/user/skills/<skill-name>/` |
| Partner | `plugins/partner/skills/<skill-name>/` |

Use **kebab-case** for the folder name (e.g., `plugins/developer/skills/code-review/`).

### 5. Skill folder structure

At minimum, your skill folder needs:

```
plugins/<plugin>/skills/<skill-name>/
└── SKILL.md
```

Use `template/SKILL.md` as your starting point. For more complex skills, you can add:

```
plugins/<plugin>/skills/<skill-name>/
├── SKILL.md
├── references/        # Detailed docs loaded into context only when needed
├── scripts/           # Scripts Claude can execute
└── assets/            # Templates, icons, or other output files
```

Keep `SKILL.md` under 500 lines. Move large reference material to separate files and link to them from `SKILL.md`.

### 6. Open a PR

- Branch name: `plugin/<persona>/<skill-name>` (e.g., `plugin/developer/code-review`)
- For multi-component reworks touching several components at once, use `plugin/<persona>/<version>` (e.g., `plugin/partner/2.0`)
- PR description: what the skill does, example inputs/outputs, and how you tested it
- Link to the plugin's README for reviewer context

## Adding a Slash Command

Slash commands live in `plugins/<persona>/commands/<name>.md`. They are **user-invoked** (typed as `/name`) rather than model-invoked. Use commands when the workflow benefits from explicit triggering — side effects, multi-step procedures, or anything the user should choose to run.

Minimum frontmatter:

```yaml
---
description: One-line summary shown in the / menu.
argument-hint: "[input]"
---
```

Optional `disable-model-invocation: true` keeps the command slash-only (Claude won't invoke it autonomously — important for side-effectful commands like `/rhombus-client-switch`).

The markdown body is the prompt Claude executes. Use `$ARGUMENTS` to reference user-supplied args. See `plugins/user/commands/rhombus-alerts.md` for a minimal example.

## Adding an MCP Server

Place a `.mcp.json` at the plugin root. Example (from `plugins/developer/.mcp.json`):

```json
{
  "mcpServers": {
    "rhombus": {
      "command": "npx",
      "args": ["--yes", "--package", "rhombus-node-mcp", "mcp-server-rhombus"],
      "env": { "RHOMBUS_API_KEY": "${RHOMBUS_API_KEY}" }
    },
    "rhombus-docs": {
      "type": "http",
      "url": "https://api-docs.rhombus.community/mcp"
    }
  }
}
```

Tools surface in Claude as `mcp__<server-name>__<tool-name>`. Skills that want Claude to reach for MCP tools first should name them explicitly in the skill description.

## Need help?

See [usage.md](usage.md) for how to install and test skills locally before submitting.

# Contributing a New Skill

This guide walks you through creating and publishing a new skill to the Rhombus plugin marketplace.

**Terminology:** A **plugin** is the persona-level installable unit (e.g., `developer`, `user`, `partner`). A **skill** is an individual capability inside a plugin, defined by a `SKILL.md` file. This is the Claude Code spec terminology — keep it consistent.

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
- PR description: what the skill does, example inputs/outputs, and how you tested it
- Link to the plugin's README for reviewer context

## Need help?

See [usage.md](usage.md) for how to install and test skills locally before submitting.

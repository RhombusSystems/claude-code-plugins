# Contributing a New Skill

This guide walks you through creating and publishing a new skill to the Rhombus Claude Code Skills library.

## Prerequisites

- Claude Code installed and configured
- Access to the [RhombusSystems/claude-code-skills](https://github.com/RhombusSystems/claude-code-skills) repo

## Steps

### 1. Activate the skill-creator

The `skill-creator` skill is a meta-skill that guides you through the entire skill creation process.

**If you haven't installed the plugin yet**, add it first:

```
/plugin marketplace add RhombusSystems/claude-code-skills
```

Then enable the skill-creator group:

```
/plugin enable skill-creator
```

**If you're working from a local clone**, you can add the plugin directly from the path:

```
/plugin marketplace add ./path/to/claude-code-skills
/plugin enable skill-creator
```

Then trigger it:

```
/skill-creator
```

Claude will interview you about the skill you want to create — what it does, who uses it, and what a good output looks like.

### 2. Follow the interview → draft → test → eval loop

The skill-creator guides you through:

1. **Interview** — Claude asks about the skill's purpose, inputs, and expected outputs
2. **Draft** — Claude generates a `SKILL.md` based on your answers
3. **Test** — Run the skill against a few real examples
4. **Eval** — Use the eval scripts in `skills/skill-creator/scripts/` to score outputs and iterate
5. **Description optimization** — Run the description optimizer to improve triggering accuracy

### 3. Write a strong description

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

After creating your skill, use the skill-creator's built-in description optimizer to test and improve triggering accuracy before submitting.

### 4. Choose the right frontmatter flags

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

### 5. Place the skill in the correct category folder

Put your skill in the appropriate category under `skills/`:

| Team | Folder |
|---|---|
| Developers | `skills/developers/<skill-name>/` |
| Business Ops | `skills/business-ops/<skill-name>/` |
| Marketing | `skills/marketing/<skill-name>/` |
| Finance | `skills/finance/<skill-name>/` |

Use **kebab-case** for the folder name (e.g., `skills/developers/code-review/`).

### 6. Skill folder structure

At minimum, your skill folder needs:

```
skills/<category>/<skill-name>/
└── SKILL.md
```

Use `template/SKILL.md` as your starting point. For more complex skills, you can add:

```
skills/<category>/<skill-name>/
├── SKILL.md
├── references/        # Detailed docs loaded into context only when needed
├── scripts/           # Scripts Claude can execute
└── assets/            # Templates, icons, or other output files
```

Keep `SKILL.md` under 500 lines. Move large reference material to separate files and link to them from `SKILL.md`.

### 7. Register in marketplace.json

Add your skill path to `.claude-plugin/marketplace.json` under the correct plugin group's `skills` array:

```json
{
  "name": "developers",
  "skills": [
    "./skills/developers/code-review",
    "./skills/developers/your-new-skill"
  ]
}
```

### 8. Open a PR

- Branch name: `skill/<category>/<skill-name>` (e.g., `skill/developers/code-review`)
- PR description: what the skill does, example inputs/outputs, and how you tested it
- Link to the category README for reviewer context

## Need help?

See [usage.md](usage.md) for how to install and test skills locally before submitting.

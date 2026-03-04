# Contributing a New Skill

This guide walks you through creating and publishing a new skill to the Rhombus Claude Code Skills library.

## Prerequisites

- Claude Code installed and configured
- This repo cloned locally or available via plugin

## Steps

### 1. Activate the skill-creator

The `skill-creator` skill is a meta-skill that guides you through the entire skill creation process. Enable it in your Claude Code project:

```
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
3. **Test** — Run the skill manually against a few real examples
4. **Eval** — Use the eval scripts in `skills/skill-creator/scripts/` to score outputs and iterate

### 3. Place the skill in the correct category folder

Put your skill in the appropriate category under `skills/`:

| Team | Folder |
|---|---|
| Developers | `skills/developers/<skill-name>/` |
| Business Ops | `skills/business-ops/<skill-name>/` |
| Marketing | `skills/marketing/<skill-name>/` |
| Finance | `skills/finance/<skill-name>/` |

Use **kebab-case** for the folder name (e.g., `skills/developers/code-review/`).

### 4. Skill folder structure

At minimum, your skill folder needs:

```
skills/<category>/<skill-name>/
└── SKILL.md
```

Use `template/SKILL.md` as your starting point. Additional files (agents, assets, scripts) can be added as needed.

### 5. Register in marketplace.json

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

### 6. Open a PR

- Branch name: `skill/<category>/<skill-name>` (e.g., `skill/developers/code-review`)
- PR description: what the skill does, example inputs/outputs, and how you tested it
- Link to the category README for reviewer context

## Need help?

See [usage.md](usage.md) for how to install and test skills locally before submitting.

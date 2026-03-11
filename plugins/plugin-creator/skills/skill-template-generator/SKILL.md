---
name: skill-template-generator
description: >
  Generate a new skill from the template with proper folder structure, frontmatter,
  and reference files for any team plugin. Use this skill when the user asks to
  create a new skill, scaffold a skill, bootstrap a skill, add a skill to a plugin,
  or generate a skill template. Also trigger on: new skill, create skill, add skill,
  scaffold skill, skill boilerplate, start a skill, quick skill, skill skeleton.
  This is a lightweight scaffolding tool — for full skill development with evals
  and optimization, use the plugin-creator skill instead.
disable-model-invocation: true
argument-hint: "[plugin-name] [skill-name]"
---

# Skill Template Generator

Quickly scaffold a new skill folder with the correct structure for any Rhombus team plugin.

## Arguments

- `$1` — Plugin name (e.g., `developers`, `marketing`, `finance`, `business-ops`)
- `$2` — Skill name in kebab-case (e.g., `code-review`, `budget-analysis`)

If arguments are missing, ask the user for them.

## Validation

Before generating:

1. Verify the plugin exists under `plugins/$1/`
2. Verify `plugins/$1/.claude-plugin/plugin.json` exists
3. Verify `plugins/$1/skills/$2/` does NOT already exist (don't overwrite)
4. Verify the skill name is kebab-case (lowercase letters, numbers, and hyphens only)

If validation fails, explain the issue and stop.

## What to Generate

Create the following structure:

```
plugins/$1/skills/$2/
├── SKILL.md
└── references/          (empty directory, for future reference files)
```

### SKILL.md Content

Generate a SKILL.md using the template at `template/SKILL.md` as the base. Customize it:

1. Set `name:` to `$2`
2. Write a detailed `description:` based on the skill name and the plugin's purpose (read the plugin's `plugin.json` for context)
3. Add a `# <Skill Name>` heading (title-cased from the kebab-case name)
4. Add a `## Purpose` section with a placeholder explaining what the skill does
5. Add a `## When This Skill Activates` section with placeholder trigger scenarios
6. Add a `## Behavior Instructions` section with placeholder steps
7. Add comments indicating where the user should fill in details

### Description Writing Guidelines

The description is critical for triggering. Follow these rules:

- Minimum 50 characters
- Include what the skill does AND when it should trigger
- List specific phrases, keywords, and contexts that should activate it
- Err on the side of being explicit — Claude undertriggers with vague descriptions
- Reference the plugin's domain (e.g., for `developers` plugin, mention code/engineering contexts)

## After Generation

Tell the user:

1. The skill has been scaffolded at `plugins/$1/skills/$2/`
2. They should edit `SKILL.md` to fill in the actual instructions
3. They can add reference files to `references/` for large content
4. For full skill development with testing and optimization, use `/plugin-creator`
5. When ready, open a PR with branch name `plugin/$1/$2`

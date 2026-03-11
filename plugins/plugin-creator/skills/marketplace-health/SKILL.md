---
name: marketplace-health
description: >
  Validate the Rhombus plugin marketplace registry, plugin manifests, and skill
  folder structure. Use this skill when the user asks to check marketplace health,
  validate plugins, audit the plugin registry, verify skill structure, or check
  for broken/missing plugins. Also trigger when the user mentions: marketplace
  check, plugin validation, registry audit, skill inventory, plugin status,
  broken plugins, missing skills, marketplace integrity, plugin health check.
allowed-tools: Read, Grep, Glob, Bash
---

# Marketplace Health Check

Audit the Rhombus Claude Code plugin marketplace for structural integrity and completeness.

## What to Check

### 1. Registry Integrity

Read `.claude-plugin/marketplace.json` and verify:

- Every plugin entry has a `name` and `source` field
- Every `source` path points to an existing directory
- Every referenced directory contains `.claude-plugin/plugin.json`
- No orphan plugin directories exist under `plugins/` that aren't registered

### 2. Plugin Manifest Validation

For each plugin's `.claude-plugin/plugin.json`, verify:

- Required fields present: `name`, `description`, `version`, `author`
- `name` matches the directory name
- `version` follows semver format

### 3. Skill Structure Validation

For each `skills/<name>/` directory found under any plugin:

- `SKILL.md` exists and is non-empty
- YAML frontmatter contains required `name` and `description` fields
- `name` in frontmatter matches the folder name
- `description` is at least 50 characters (short descriptions lead to poor triggering)
- SKILL.md is under 500 lines (per project convention)
- If `references/`, `scripts/`, or `assets/` directories exist, they contain at least one file

### 4. Empty Plugin Detection

Flag plugins that have a `skills/` directory but no skills inside it — these are scaffolded but need content.

## Output Format

Produce a structured report:

```
## Marketplace Health Report

### Registry: [PASS/FAIL]
- [list findings]

### Plugin Manifests
#### <plugin-name>: [PASS/FAIL]
- [list findings]

### Skills
#### <plugin>/<skill>: [PASS/WARN/FAIL]
- [list findings]

### Empty Plugins (need skills)
- [list empty plugins with their descriptions from plugin.json]

### Summary
- Total plugins: X
- Total skills: X
- Passing: X | Warnings: X | Failures: X
```

## Execution Steps

1. Read `.claude-plugin/marketplace.json` to get the plugin list
2. For each plugin, read `.claude-plugin/plugin.json`
3. Glob for `plugins/*/skills/*/SKILL.md` to find all skills
4. Run each validation check above
5. Glob for `plugins/*/` directories and compare against registry to find orphans
6. Output the report

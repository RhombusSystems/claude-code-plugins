# Using Rhombus Plugins

This guide explains how to install and activate plugins from this marketplace in your Claude Code project.

## Option A: Plugin Marketplace (Recommended)

Install the marketplace once, then enable your plugin.

### 1. Add the marketplace

```
/plugin marketplace add RhombusSystems/claude-code-plugins
```

### 2. Enable your plugin

| Persona | Command |
|---|---|
| Developers building on Rhombus | `/plugin enable rhombus-developer` |
| Day-to-day Rhombus users | `/plugin enable rhombus-user` |
| MSP/reseller partners | `/plugin enable rhombus-partner` |

You can enable multiple plugins if needed.

### 3. Activate a skill

Once a plugin is enabled, trigger a skill using its slash command:

```
/rhombus-api
/code-review
/rhombus
```

Check each plugin's `README.md` for the available skill commands.

## Option B: Manual Copy

If you prefer to embed skills directly in your project rather than using the plugin:

### 1. Clone this repo

```bash
git clone https://github.com/RhombusSystems/claude-code-plugins
```

### 2. Copy the skill folder

Copy any skill folder into your project's `skills/` directory:

```bash
cp -r claude-code-plugins/plugins/developer/skills/code-review ./skills/
```

### 3. Register in your project's CLAUDE.md or settings

Add the skill path to your project's Claude Code configuration so Claude knows it's available.

### 4. Activate the skill

Trigger it in Claude Code just as you would a plugin-installed skill.

## How skills work

Skills are Markdown files (`SKILL.md`) that contain instructions Claude follows when the skill is active. When you trigger a skill, Claude reads those instructions and applies them to your request.

Some skills include supporting files:
- `agents/` — Sub-agent prompts used during the skill workflow
- `scripts/` — Python scripts for eval, reporting, and packaging
- `assets/` — Supporting files like HTML templates

## Troubleshooting

- **Skill not found**: Make sure the plugin is enabled and the skill's `SKILL.md` exists in the correct location under `plugins/<name>/skills/<skill-name>/`
- **Unexpected behavior**: Check the `SKILL.md` for the skill — the instructions are readable and can be reviewed directly
- **Questions about creating skills**: See [contributing.md](contributing.md)

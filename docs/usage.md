# Using Rhombus Skills

This guide explains how to install and activate skills from this library in your Claude Code project.

## Option A: Plugin (Recommended)

The fastest way to get started. This registers the full library and lets you enable skill groups by name.

**Prerequisite:** This is an internal GitHub repo. You need to be a RhombusSystems org member with GitHub authentication configured in your terminal. Claude Code uses your existing git credentials — if `git clone https://github.com/RhombusSystems/claude-code-skills` works, the command below works too.

For background auto-updates at Claude Code startup, also set:

```bash
export GITHUB_TOKEN=your_github_pat
```

### 1. Add the plugin

```
/plugin marketplace add RhombusSystems/claude-code-skills
```

### 2. Enable the skill groups you need

```
/plugin enable skill-creator
/plugin enable developers
/plugin enable business-ops
/plugin enable marketing
/plugin enable finance
```

You can enable multiple groups. Only enabled groups are active in your session.

### 3. Activate a skill

Once a group is enabled, trigger a skill using its slash command:

```
/skill-creator
/code-review
```

Check each category's `README.md` for the available skill commands.

## Option B: Manual Copy

If you prefer to embed skills directly in your project rather than using the plugin:

### 1. Clone this repo

```bash
git clone https://github.com/RhombusSystems/claude-code-skills
```

### 2. Copy the skill folder

Copy any skill folder into your project's `skills/` directory:

```bash
cp -r claude-code-skills/skills/developers/code-review ./skills/
```

### 3. Register in your project's CLAUDE.md or settings

Add the skill path to your project's Claude Code configuration so Claude knows it's available.

### 3. Activate the skill

Trigger it in Claude Code just as you would a plugin-installed skill.

## How skills work

Skills are Markdown files (`SKILL.md`) that contain instructions Claude follows when the skill is active. When you trigger a skill, Claude reads those instructions and applies them to your request.

Some skills include supporting files:
- `agents/` — Sub-agent prompts used during the skill workflow
- `scripts/` — Python scripts for eval, reporting, and packaging
- `assets/` — Supporting files like HTML templates

## Troubleshooting

- **Skill not found**: Make sure the plugin group is enabled and the skill path is correctly listed in `marketplace.json`
- **Unexpected behavior**: Check the `SKILL.md` for the skill — the instructions are readable and can be reviewed directly
- **Questions about creating skills**: See [contributing.md](contributing.md)

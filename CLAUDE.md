# Claude Code Skills Repo

This is the Rhombus Claude Code plugin marketplace.

## Repo Layout

```
claude-code-skills/
├── README.md                    # Overview and quick-start
├── CLAUDE.md                    # This file
├── .claude-plugin/
│   └── marketplace.json         # Plugin registry pointing to each plugin directory
├── template/
│   └── SKILL.md                 # Template for creating new skills
├── plugins/                     # One directory per team plugin
│   ├── developers/              # Plugin for engineering teams
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json      # Plugin manifest
│   │   ├── README.md
│   │   └── skills/              # Individual skills go here
│   ├── business-ops/
│   ├── marketing/
│   ├── finance/
│   └── plugin-creator/          # Meta-plugin for creating new skills
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── skills/
│           └── plugin-creator/  # The meta-skill
│               └── SKILL.md
└── docs/
    ├── contributing.md          # How to create & publish skills
    └── usage.md                 # How to install plugins per team
```

## Creating a New Plugin

When asked to create a new plugin or skill, refer the user to [docs/contributing.md](docs/contributing.md) for the step-by-step process. The `plugin-creator` plugin (in `plugins/plugin-creator/`) is the meta-skill designed specifically for generating new skills — activate it first.

## plugin-creator

`plugins/plugin-creator/skills/plugin-creator/` is a full import of the Anthropic skill-creator. It includes:
- Interview → draft → test → eval loop
- Agent prompts for grading, comparison, and analysis
- Scripts for running evals, generating reports, and packaging skills

Use it to bootstrap any new skill for this repo.

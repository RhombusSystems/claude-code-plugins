# Claude Code Skills Repo

This is the Rhombus shared Claude Code skills library.

## Repo Layout

```
claude-code-skills/
├── README.md                    # Overview and quick-start
├── CLAUDE.md                    # This file
├── .claude-plugin/
│   └── marketplace.json         # Plugin registry for all skill groups
├── template/
│   └── SKILL.md                 # Template for creating new skills
├── skills/
│   ├── skill-creator/           # Meta-skill: generate, test, publish skills
│   ├── developers/              # Skills for Developer & Technical Teams
│   ├── business-ops/            # Skills for Business Operations
│   ├── marketing/               # Skills for Marketing
│   └── finance/                 # Skills for Finance
└── docs/
    ├── contributing.md          # How to create & publish skills
    └── usage.md                 # How to install skills in a project
```

## Creating a New Skill

When asked to create a new skill, refer the user to [docs/contributing.md](docs/contributing.md) for the step-by-step process. The `skill-creator` skill (in `skills/skill-creator/`) is the meta-skill designed specifically for generating new skills — activate it first.

## skill-creator

`skills/skill-creator/` is a full import of the Anthropics skill-creator. It includes:
- Interview → draft → test → eval loop
- Agent prompts for grading, comparison, and analysis
- Scripts for running evals, generating reports, and packaging skills

Use it to bootstrap any new skill for this repo.

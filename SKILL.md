---
name: claude-code-plugins-patterns
description: Coding patterns extracted from RhombusSystems/claude-code-plugins
version: 1.0.0
source: local-git-analysis
analyzed_commits: 8
---

# Claude Code Plugins — Repo Patterns

## Commit Conventions

This project uses **imperative, descriptive commit messages** — no conventional commit prefixes (`feat:`, `fix:`, etc.). Each message starts with a verb describing the action.

Examples from history:
- `Add brand-guide skill to marketing plugin`
- `Fix plugin install instructions for internal repo`
- `Improve template and contributing guide based on docs review`
- `Renamed from Skills to new naming - Plugins`
- `Initial scaffolding for Rhombus Claude Code Skills library`

### Branch naming

- Feature branches: `plugin/<category>/<skill-name>` (e.g. `plugin/developers/code-review`)
- Claude-generated branches: `claude/<descriptive-name>`
- PRs target `main`

## Code Architecture

```
claude-code-plugins/
├── .claude-plugin/
│   └── marketplace.json         # Plugin registry — lists all plugins with source paths
├── CLAUDE.md                    # Repo-level instructions for Claude Code
├── README.md                    # Overview and install instructions
├── template/
│   └── SKILL.md                 # Canonical template for new skills
├── plugins/                     # One directory per team plugin
│   ├── <team>/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json      # Plugin manifest (name, description, version, author)
│   │   ├── README.md            # Team plugin overview
│   │   └── skills/
│   │       └── <skill-name>/    # kebab-case folder name
│   │           ├── SKILL.md     # Skill definition (YAML frontmatter + Markdown body)
│   │           ├── references/  # Large reference docs loaded on demand
│   │           ├── scripts/     # Python or shell scripts Claude can execute
│   │           ├── agents/      # Subagent prompt definitions (.md files)
│   │           └── assets/      # Templates, HTML viewers, icons
│   ├── developers/
│   ├── business-ops/
│   ├── marketing/
│   ├── finance/
│   └── plugin-creator/          # Meta-plugin for generating new skills
└── docs/
    ├── contributing.md           # Step-by-step skill creation guide
    └── usage.md                  # Plugin install/enable instructions
```

### Key files that co-change

| Change type | Files typically modified together |
|---|---|
| New plugin added | `marketplace.json` + `plugins/<team>/plugin.json` + `plugins/<team>/README.md` |
| Structural rename | `CLAUDE.md` + `README.md` + `marketplace.json` + all `plugin.json` files |
| New skill added | `plugins/<team>/skills/<name>/SKILL.md` + optional `references/` files |
| Docs update | `docs/contributing.md` + `template/SKILL.md` + `docs/usage.md` |

## Plugin Registry

`marketplace.json` is the single source of truth for available plugins:

```json
{
  "plugins": [
    { "name": "developers",     "source": "./plugins/developers" },
    { "name": "business-ops",   "source": "./plugins/business-ops" },
    { "name": "marketing",      "source": "./plugins/marketing" },
    { "name": "finance",        "source": "./plugins/finance" },
    { "name": "plugin-creator", "source": "./plugins/plugin-creator" }
  ]
}
```

When adding a new plugin, you must register it here.

## Plugin Manifest (`plugin.json`)

Each plugin has a `.claude-plugin/plugin.json`:

```json
{
  "name": "plugin-name",
  "description": "What this plugin provides and who it's for.",
  "version": "1.0.0",
  "author": { "name": "Rhombus" }
}
```

## Skill Definition (`SKILL.md`)

Skills use YAML frontmatter for metadata and Markdown for instructions:

### Required frontmatter
- `name` — kebab-case identifier
- `description` — detailed, trigger-oriented description (be explicit about when to activate)

### Optional frontmatter
- `argument-hint` — autocomplete hint for arguments
- `disable-model-invocation: true` — prevent auto-triggering (for side-effect skills)
- `allowed-tools` — restrict available tools
- `context: fork` — run in isolated subagent
- `user-invocable: false` — hide from slash menu

### Description writing convention

Descriptions must be **explicit and pushy** — list specific phrasings, contexts, and edge cases that should trigger the skill. Claude undertriggers on vague descriptions.

### Size guideline

Keep `SKILL.md` under 500 lines. Move large reference material to `references/` subdirectory.

## Workflows

### Adding a New Skill

1. Create `plugins/<team>/skills/<skill-name>/SKILL.md` using `template/SKILL.md` as base
2. Add optional `references/`, `scripts/`, `agents/`, `assets/` subdirectories as needed
3. Test locally with `/plugin marketplace add ./path/to/repo`
4. Branch: `plugin/<team>/<skill-name>`
5. Open PR with example inputs/outputs

### Adding a New Plugin (Team)

1. Create `plugins/<team-name>/.claude-plugin/plugin.json`
2. Create `plugins/<team-name>/README.md`
3. Create `plugins/<team-name>/skills/` directory
4. Register in `.claude-plugin/marketplace.json`
5. Update root `README.md` plugins table

### Using the Meta Plugin-Creator

1. Enable: `/plugin enable plugin-creator`
2. Run: `/plugin-creator`
3. Follow interview -> draft -> test -> eval loop
4. The plugin-creator has its own agents (`analyzer`, `comparator`, `grader`) and Python eval scripts

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Plugin directory | kebab-case | `business-ops` |
| Skill directory | kebab-case | `brand-guide` |
| Plugin manifest | `.claude-plugin/plugin.json` | — |
| Skill file | `SKILL.md` (uppercase) | — |
| Reference files | kebab-case `.md` | `brand-system.md` |
| Agent prompts | kebab-case `.md` in `agents/` | `analyzer.md` |
| Python scripts | snake_case `.py` in `scripts/` | `run_eval.py` |

## Existing Skill Example

The `brand-guide` skill in `plugins/marketing/` is the most complete example:
- Strong, trigger-oriented description with keyword list
- `allowed-tools: Read, Grep, Glob` restriction
- Quick reference table for common values
- Behavior instructions for different scenarios
- CSS template for code generation
- Delegates to `references/brand-system.md` for detailed content

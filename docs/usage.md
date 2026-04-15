# Using Rhombus Plugins

This guide explains how to install and use plugins from this marketplace in Claude Code.

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

### 3. Use the plugin

Each plugin ships three kinds of capabilities. All three are live the moment you enable the plugin — no further activation needed.

**Skills** — model-invoked. Claude detects relevant user requests and applies the skill automatically. You don't type anything; just ask your question naturally ("how do I build a face recognition workflow on Rhombus?" fires the `rhombus-api` skill).

**Slash commands** — user-invoked. Type them directly in the prompt. Each plugin's README lists its commands, e.g.:

```
/rhombus-find-endpoint camera        # developer
/rhombus-alerts "front lobby" 1h     # user
/rhombus-fleet-report weekly         # partner
```

**Agents** — model-invoked specialized subagents. Claude delegates to them when the request matches the agent's description (e.g., complex multi-step investigations, webhook debugging, client-selection).

Check each plugin's `README.md` for the complete list of skills, commands, and agents.

### 4. Developer plugin: MCP servers

The `rhombus-developer` plugin auto-wires two MCP servers via its `.mcp.json`:

- **`rhombus`** (official API MCP via `rhombus-node-mcp`) — requires `RHOMBUS_API_KEY` exported in your shell.
- **`rhombus-docs`** (HTTP MCP at `api-docs.rhombus.community/mcp`) — live doc search.

Verify with `/rhombus-mcp-status`.

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

### 4. Use the skill

Trigger it in Claude Code the same way as a plugin-installed skill — ask Claude a matching question and it auto-applies.

## How it works

- **Skills** (`SKILL.md`) — Markdown files containing instructions Claude follows when the skill is active. Triggered by matching the `description` field against the user's request.
- **Commands** (`commands/*.md`) — Slash-command entry points with frontmatter and a prompt body. Typed explicitly as `/<command-name>`.
- **Agents** (`agents/*.md`) — Subagent definitions with their own system prompt, tool set, and invocation triggers.
- **Hooks** (`hooks/*.md` or `.sh`) — Event-driven automation (PreToolUse, SessionStart, etc.) that runs around tool calls and session events.
- **MCP servers** (`.mcp.json` at plugin root) — External tool integrations auto-attached when the plugin is enabled. Tools appear as `mcp__<server>__<tool>`.

## Troubleshooting

- **Skill/command not found**: Run `/reload-plugins`. Confirm the plugin is enabled with `/plugin list`.
- **MCP not attached**: Run `/rhombus-mcp-status` (developer plugin). Check that `RHOMBUS_API_KEY` is exported in the shell that launched Claude Code.
- **Unexpected behavior**: Open the relevant `SKILL.md`, command, or agent — the instructions are plain Markdown and readable directly.
- **Questions about creating skills or commands**: See [contributing.md](contributing.md).

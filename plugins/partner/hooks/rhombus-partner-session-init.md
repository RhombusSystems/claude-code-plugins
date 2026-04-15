---
name: rhombus-partner-session-init
event: SessionStart
type: prompt
---

On session start for the `rhombus-partner` plugin:

1. Read `.claude/rhombus-partner.local.md` at the repo root if it exists.
2. If it has an `active_client:` key in the YAML frontmatter, announce to the user:

   > **Rhombus partner:** active client is **`<active_client>`**. Partner commands default to this client unless you pass `--partner-org`. Change with `/rhombus-client-switch <name>`, clear with `/rhombus-client-switch none`.

3. If the file doesn't exist or has no `active_client`:

   > **Rhombus partner:** no active client set. Partner commands will run against your partner management org by default. Set one with `/rhombus-client-switch <name>`, or pass `--partner-org "<name>"` on each command.

Keep the announcement to a single line — do not produce a wall of text on every session start. Do not run any CLI commands in this hook (it's a prompt hook, not a shell hook).

If the user seems confused about partner mode, point them at the `rhombus-partner-cli` skill or run `/rhombus-clients` to list their managed orgs.

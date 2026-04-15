---
description: >-
  Set the active Rhombus client organization for this workspace. Writes
  `.claude/rhombus-partner.local.md` with an `active_client` entry. Side-effect —
  modifies a file in the repo. Slash-only.
argument-hint: "[client-name]"
disable-model-invocation: true
---

Set the active Rhombus client for this workspace.

Parse `$ARGUMENTS` as the client name. If empty, list options via `rhombus partner get-partner-clients-v2` and ask the user to pick.

Resolution (reuse the `rhombus-client-selector` agent if the name is ambiguous):

1. Exact match in `rhombus partner get-partner-clients-v2 | jq -r '.partnerClients[].orgName'`? Use it.
2. Single fuzzy match (case-insensitive substring)? Confirm, then use.
3. Zero or multiple matches? Show the list, ask the user.

Once resolved to a canonical name, write `.claude/rhombus-partner.local.md`:

```markdown
---
active_client: <canonical name>
active_client_uuid: <uuid>
switched_at: <ISO timestamp>
---

# Partner workspace notes

(Keep your own per-workspace notes here. This file is read by the partner plugin's
session-init hook, client-selector agent, and the rhombus-cli-validate hook.)
```

If the file already exists:

- **Preserve the body** below the frontmatter (user's notes).
- **Replace only the frontmatter** with the new active_client.

Report back:

```
✅ Active client set to <canonical name> (<uuid>).

Subsequent partner commands will default to this client when --partner-org is omitted.
Clear with `/rhombus-client-switch none` or delete `.claude/rhombus-partner.local.md`.
```

Special case: if `$ARGUMENTS` is `none` or `clear`, remove the `active_client` key from frontmatter (leaving the body intact) and report "Active client cleared."

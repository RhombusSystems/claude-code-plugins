---
description: List all Rhombus client organizations managed by the current partner account, with active/inactive state and a count of cameras per client.
---

List the managed Rhombus client orgs.

```bash
rhombus partner get-partner-clients-v2 --output json
```

Render as a table:

| # | Client | UUID | Active? | Cameras | Last onboarded |
|---|---|---|---|---|---|

For each client, optionally enrich with a camera count (parallelized, 4 at a time):

```bash
rhombus camera get-minimal-camera-state-list --partner-org "$CLIENT" 2>/dev/null | jq '.cameraStates | length'
```

Skip enrichment if there are >30 clients (too slow). Mention the skipping inline.

Highlight the currently active client (from `.claude/rhombus-partner.local.md` if present) with a ★.

End with:

- Total clients count
- Active client (if any)
- Suggestion: "Run `/rhombus-client-switch <name>` to change active client, or `/rhombus-audit-clients <metric>` for a fleet-wide audit."

If the user is not a partner, surface the auth error and suggest `rhombus login` with partner credentials.

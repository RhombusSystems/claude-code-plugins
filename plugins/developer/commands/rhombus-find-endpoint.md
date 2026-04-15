---
description: Search the Rhombus OpenAPI spec for endpoints by keyword, tag, or operationId. Returns matching operationId, path, method, and summary.
argument-hint: "[keyword or operationId]"
---

Search the Rhombus API for endpoints matching `$ARGUMENTS`.

**Preferred path:** If `mcp__rhombus-docs__search-documentation` is attached, call it with the user's query — it returns ranked doc results including endpoint references. If `mcp__rhombus-docs__get-endpoint-details` is attached and `$ARGUMENTS` looks like an operationId, call that instead for structured details.

**Fallback path:** Grep the local spec at `plugins/developer/skills/rhombus-api/references/rhombus-api.json`:

```bash
grep -i "$ARGUMENTS" plugins/developer/skills/rhombus-api/references/rhombus-api.json | grep '"operationId"'
```

For each match, report:
- `operationId`
- HTTP path + method
- One-line summary (from the spec's `summary` field)
- Tag (API service category)

If there are more than 20 matches, show the first 20 and note the total count. If there are zero matches, suggest related keywords (e.g., if the user searched "lpr", suggest "vehicle" since LPR is under Vehicle Webservice).

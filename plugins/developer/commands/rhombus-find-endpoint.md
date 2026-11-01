---
description: Search the Rhombus OpenAPI spec for endpoints by keyword, tag, or operationId. Returns matching operationId, path, method, and summary.
argument-hint: "[keyword or operationId]"
---

Search the Rhombus API for endpoints matching `$ARGUMENTS`.

**Preferred path:** If `mcp__rhombus-docs__search_rhombus_developer` is attached, call it with the user's query — it returns ranked doc sections including API operations. If `$ARGUMENTS` looks like an operationId and `mcp__rhombus-docs__query_docs_filesystem_rhombus_developer` is attached, run `rg -l "$ARGUMENTS" /api-reference` with it and `cat` the matching file for structured details.

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

---
description: Dump the request and response schema for a specific Rhombus API endpoint as markdown. Use when you need to know exactly what fields an endpoint accepts or returns.
argument-hint: "[operationId]"
---

Return the request and response schema for the Rhombus API endpoint with operationId `$ARGUMENTS`.

**Preferred path:** If `mcp__rhombus-docs__get-endpoint-details` is attached, call it with `$ARGUMENTS` — it returns full endpoint details including typed schemas.

**Fallback path:** Grep the local OpenAPI spec at `plugins/developer/skills/rhombus-api/references/rhombus-api.json`:

```bash
grep -A 80 '"operationId" : "'"$ARGUMENTS"'"' plugins/developer/skills/rhombus-api/references/rhombus-api.json
```

Then resolve any `$ref` pointers to `components.schemas` for full field details.

Format the output as:

### `$ARGUMENTS`

**Path:** `POST /api/<path>`

**Request body**
| Field | Type | Required | Description |
|---|---|---|---|

**Response (200)**
| Field | Type | Description |
|---|---|---|

If the operationId is not found, suggest running `/rhombus-find-endpoint <keyword>` to discover it.

---
description: Generate a ready-to-run cURL command for a Rhombus API endpoint, including auth headers and a skeleton request body. Only use this when the user needs a shell example rather than actual execution.
argument-hint: "[operationId]"
---

Emit a runnable cURL command for the Rhombus API endpoint with operationId `$ARGUMENTS`.

1. Resolve the endpoint path and request schema using `/rhombus-schema $ARGUMENTS` (or the docs MCP if attached).
2. Produce the cURL in this exact shape:

```bash
curl -X POST "https://api2.rhombussystems.com/api/<path>" \
  -H "x-auth-scheme: api-token" \
  -H "x-auth-apikey: $RHOMBUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "<requiredField>": "<realistic example value>"
  }'
```

3. Checklist before emitting:
   - Both auth headers present
   - `POST` method (all Rhombus endpoints are POST)
   - `Content-Type: application/json`
   - Required fields populated with realistic example values (base64 url-safe UUIDs like `AAAAAAAAAAAAAAAAAAAAAA`, millisecond epoch timestamps like `1234567890000`)
   - Optional fields included in a trailing comment for discoverability

4. If the user probably wanted to *run* the call rather than copy a shell example, remind them: *"If you want to execute this, `mcp__rhombus__<operationId>` handles auth and typing for you."*

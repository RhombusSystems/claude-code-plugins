---
name: rhombus-api-intercept
event: PreToolUse
matcher: Bash
type: prompt
---

Inspect the bash command about to be executed. If it contains a `curl`, `wget`, or `fetch` call targeting any of these Rhombus API domains:

- `api2.rhombussystems.com`
- `api.rhombussystems.com`
- `media.rhombussystems.com`
- `auth.rhombussystems.com`

Then surface a suggestion in this priority order (do NOT block — only suggest):

## 1. Prefer an MCP tool call

The developer plugin auto-attaches the `rhombus` MCP server (`mcp__rhombus__*` tools) which wraps these same endpoints with typed arguments and handled auth. If a matching MCP tool exists, recommend it first:

> `mcp__rhombus__<tool-name>` handles auth, typed arguments, and retries automatically — prefer it over raw cURL.

If you cannot identify the exact MCP tool name, suggest the user run `/rhombus-mcp-status` to list attached tools.

## 2. Fall back to the `rhombus` CLI

If the MCP is unavailable or the operation is CLI-native (deployment context generation, footage streaming, etc.), suggest the CLI:

```
rhombus camera get-minimal-camera-state-list
```

instead of:

```
curl -X POST https://api2.rhombussystems.com/api/camera/getMinimalCameraStateList \
  -H "x-auth-apikey: KEY" -H "x-auth-scheme: api-token"
```

If the rhombus CLI equivalent is not obvious, suggest `rhombus --help` or `rhombus <service-group> --help`.

## 3. Allow raw cURL only when explicit

If the user explicitly asked for a cURL example (e.g., for documentation, for non-Rhombus tooling, or to integrate with a system that needs cURL syntax), let the command proceed without suggesting alternatives.

Do NOT block the command. Only add a helpful suggestion before allowing it to proceed.

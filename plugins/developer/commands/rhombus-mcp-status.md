---
description: Report the status of the Rhombus MCP servers (rhombus-node-mcp and rhombus-docs). Diagnose connection issues and missing environment variables.
---

Report the status of the two MCP servers this plugin wires.

1. Check whether any `mcp__rhombus__*` tools are attached in the current session. If yes, report:
   > ✅ **rhombus** (API MCP) — attached. Example tools: `<list up to 5 tool names>`.

   If no tools are attached, report:
   > ❌ **rhombus** (API MCP) — not attached.
   >
   > Likely causes:
   > - `RHOMBUS_API_KEY` is not exported in the shell that launched Claude Code (check with `echo $RHOMBUS_API_KEY`).
   > - `npx` is not available on PATH (Node.js not installed).
   > - First-run package download still in progress — try again in ~30 seconds.

2. Check whether any `mcp__rhombus-docs__*` tools are attached. If yes:
   > ✅ **rhombus-docs** — attached. Tools: `search-documentation`, `get-endpoint-details`, `search-code-examples` (as available).

   If no:
   > ❌ **rhombus-docs** — not attached.
   >
   > Likely causes:
   > - Network access to `api-docs.rhombus.community` is blocked.
   > - The docs MCP endpoint changed — check `plugins/developer/.mcp.json`.

3. If both are attached, summarize: *"Both MCP servers are connected. Claude will prefer MCP tools over raw cURL and local grep. See the `rhombus-api` skill for the decision tree."*

Do NOT attempt to restart or reconfigure the servers — Claude Code manages the MCP lifecycle. Report only.

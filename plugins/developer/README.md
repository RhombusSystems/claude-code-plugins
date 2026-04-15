# Developer Plugin

Tools for engineers building on the Rhombus platform. Version **2.0.0**.

## What's in the box

- **Two MCP servers** auto-attached: `rhombus` (official API MCP via `rhombus-node-mcp`) and `rhombus-docs` (live HTTP MCP at `api-docs.rhombus.community/mcp`).
- **Six slash commands** for common workflows.
- **Two specialized agents** (API architect, webhook debugger).
- **Five skills** covering API reference, SDK codegen, webhook scaffolding, edge streaming, and code review.

## Setup

The plugin wires MCP servers automatically via `.mcp.json`. You only need:

1. **`RHOMBUS_API_KEY`** exported in the shell that launches Claude Code (generate from Rhombus Console → API Key Settings).
2. **Node 18+** on PATH so `npx` can fetch `rhombus-node-mcp` on first run.

Verify with `/rhombus-mcp-status`.

## Slash commands

| Command | Arg hint | Purpose |
|---|---|---|
| `/rhombus-find-endpoint` | `[keyword \| operationId]` | Search the OpenAPI spec for endpoints |
| `/rhombus-schema` | `[operationId]` | Dump request/response schema as markdown |
| `/rhombus-curl` | `[operationId]` | Emit a ready-to-run cURL with auth headers |
| `/rhombus-sdk` | `[python\|ts\|java\|go] [out-dir]` | Generate a typed SDK client (slash-only) |
| `/rhombus-mcp-status` | — | Report state of both MCP servers |
| `/rhombus-newproject` | `[language] [feature]` | Scaffold a starter repo |

## Agents

| Agent | Triggers on |
|---|---|
| `rhombus-api-architect` | Integration design, endpoint chaining, PR review for new API usage |
| `rhombus-webhook-debugger` | Webhook delivery failures, signature verification errors, duplicate events |

## Skills

| Skill | Triggers when user asks about |
|---|---|
| `rhombus-api` | Rhombus API, endpoints, cURL, any "how do I build X on Rhombus" question (covers 892+ endpoints inc. Relay/NVR + third-party RTSP) |
| `rhombus-sdk-codegen` | Scaffolding typed SDK clients (Python, TS, Java, Go, C#) |
| `rhombus-webhook-receiver` | Building webhook listeners (Express, FastAPI, Lambda) |
| `rhombus-edge-streaming` | RTSP, ONVIF, Secure Raw Streams, custom seekpoints, embedded player |
| `code-review` | Generic code review |
| `api-doc` | Generic API doc generation |

## Hooks

| Hook | Event | Purpose |
|---|---|---|
| `rhombus-api-intercept` | PreToolUse (Bash) | Suggests MCP tool → CLI → cURL order when raw Rhombus HTTP calls are detected |
| `rhombus-openapi-freshness.sh` | SessionStart | Warns if bundled OpenAPI spec is >90 days old |

## Typical workflow

```
# Ask a "how" question — docs MCP answers
"How do I build a face recognition workflow on Rhombus?"

# Ask to actually do something — API MCP executes
"List my cameras"
"Download a clip of alert <uuid>"

# Scaffold a new integration
/rhombus-newproject python lpr-to-slack
```

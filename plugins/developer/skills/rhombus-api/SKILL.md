---
name: rhombus-api
description: Comprehensive guide for working with the Rhombus API and building applications on the Rhombus platform. Use when the user asks questions about the Rhombus API, requests cURL examples, needs endpoint documentation, wants to build apps integrating Rhombus cameras/access control/sensors, asks "How do I [X] using the Rhombus API", or asks about streaming video, LPR, face recognition, webhooks, door controllers, IoT sensors, alarm monitoring, relay/NVR management, third-party RTSP cameras, or any Rhombus development task. Also trigger when the user mentions Rhombus platform capabilities, wants to generate SDK clients, or references the Rhombus OpenAPI spec. Covers all 65+ API service categories across 980+ endpoints including camera management, access control, IoT sensors, face recognition, vehicle/LPR, alarm monitoring, lockdown plans, occupancy, elevators, relay/NVR, webhooks, user management, and more.
---

# Rhombus API Skill

This skill provides comprehensive support for working with the Rhombus API and building applications on the Rhombus platform. Rhombus was built on API-driven micro-services from day one — every feature in the web console, mobile apps, and firmware is backed by the same API endpoints available to developers.

## MCP-First — tool selection order

This plugin auto-attaches two MCP servers. **Always try them before falling back to grep/cURL.**

1. **`mcp__rhombus__*` — Rhombus API MCP (live)**. Call this for anything the user wants to *do*: list cameras, fetch an alert, create a credential, download a clip. It wraps the same API endpoints covered below, with typed arguments and handled auth. Requires `RHOMBUS_API_KEY` in the environment; check `/rhombus-mcp-status` if tools are missing.
2. **`mcp__rhombus-docs__*` — Rhombus docs MCP (live doc search)**. Call this for "*how do I…*" narrative questions, implementation guides, best practices, and code examples. Tools: `search-documentation`, `get-endpoint-details`, `search-code-examples`.
3. **Local OpenAPI grep on `references/rhombus-api.json`** — fallback when (a) the MCP is unreachable, (b) you need exact schema drill-down for an endpoint, or (c) you're enumerating every endpoint in a tag.
4. **Raw cURL** — only when the user explicitly asks for a shell example, or when integrating with a system that needs cURL syntax. See `references/mcp-tool-reference.md` for a task → MCP-tool map.

Decision tree:

```
User asks to DO something on Rhombus   → mcp__rhombus__* tool call
User asks HOW something works           → mcp__rhombus-docs__search-documentation
User asks for a schema/field list       → grep references/rhombus-api.json
User asks for a cURL example            → emit cURL (last resort)
```

## Quick Reference

Always start by reading `references/quickstart.md` for authentication patterns, base URL, and common endpoint examples.

## Key Resources

- **Base URL**: US `https://api2.rhombussystems.com`, EU `https://api2.eu.rhombussystems.com`. An organization lives in one region and its API keys only work against that region's base URL; paths, headers and payloads are identical. See `https://developer.rhombus.com/api-regions`.
- **OpenAPI Spec (live)**: `https://api2.rhombussystems.com/api/openapi/public.json` (EU: `https://api2.eu.rhombussystems.com/api/openapi/public.json`)
- **OpenAPI Spec (local)**: `references/rhombus-api.json` (167,856 lines, 986 endpoints)
- **Developer Docs**: `https://developer.rhombus.com/`
- **Documentation MCP**: `https://api-docs.rhombus.community/mcp` (live doc search for AI tools)
- **Docs Index (for AI)**: `https://developer.rhombus.com/llms.txt`
- **Support**: `support@rhombus.com`

## Authentication

All requests require two headers. All endpoints use POST, even for reads.

```
x-auth-scheme: api-token
x-auth-apikey: YOUR_API_KEY
```

Customers create API keys in the Rhombus Console under **Settings → Integrations & Developer Resources → API Tokens → Add API Key** (choose Auth Type **Api Token** for header-based keys; the modal defaults to Certificate). Partner organizations use **Settings → API Management → Add API Key**.

### Federated tokens (browsers, video players, LAN devices)

Use a federated token anywhere you can't safely put your API key.

1. **Mint it on your server** with your API key: `POST /api/org/generateFederatedSessionToken` with body `{"durationSec": 3600}`. Optional fields: `deviceUUid` (limits the token to one device; use this for LAN streaming) and `domain`. The response is `{"federatedSessionToken": "..."}`.
2. **Send it** as `x-auth-scheme: federated-token` plus `x-auth-ft: <token>`, either as headers or, on media URLs and LAN device URLs, as query parameters: `?x-auth-scheme=federated-token&x-auth-ft=<token>`.

Rules:
- The scheme value is exactly `federated-token` (no other spelling works).
- A federated token never goes in `x-auth-apikey`.
- Devices on the customer's LAN never accept API keys. They accept only federated tokens, ideally device-scoped with `deviceUUid`. A device-scoped token can't call the cloud API.

Details: `https://developer.rhombus.com/implementations/lan-streaming`.

## Complete API Category Reference

The Rhombus API is organized into **65+ service categories**. When searching the spec, match against these exact tag strings.

### Core Device Management
- `"Camera Webservice"` — Camera CRUD, settings, snapshots, VOD URIs, media URIs, shared streams
- `"Component Webservice"` — Device lifecycle, firmware, health monitoring across all device types
- `"Door Controller Webservice"` — Door controller hardware configuration and monitoring
- `"Door Webservice"` — Door **sensors** (open/close state and events). To lock or unlock an access-controlled door, use `POST /api/accesscontrol/unlockAccessControlledDoor` (Access Control Webservice); list access-controlled doors with `POST /api/component/findAccessControlledDoors` (Component Webservice)
- `"Doorbell Camera Webservice"` — Doorbell-specific camera operations
- `"Sensor Webservice"` — IoT sensor data retrieval (environmental, motion)
- `"Climate Webservice"` — Temperature, humidity, air quality sensor data
- `"AudioGateway Webservice"` — Audio gateway device management
- `"AudioPlayback Webservice"` — Audio playback and announcements
- `"BLE Webservice"` — Bluetooth Low Energy device management
- `"Badge Reader Webservice"` — Badge reader hardware management
- `"Button Webservice"` — Physical button/panic button devices
- `"Relay Webservice"` — NVR/relay management, third-party RTSP camera discovery and assignment, firmware updates, PTZ control
- `"Media Device Webservice"` — Media device management
- `"Elevator Webservice"` — Elevator access control and floor management
- `"Device Config Webservice"` — Low-level device configuration

### Access Control
- `"Access Control Webservice"` — Credentials, groups, grants, revocations, assignments
- `"Access Control Integrations Webservice"` — Third-party access control integrations
- `"Guest Management Kiosk Webservice"` — Visitor/guest management kiosk operations

### AI & Analytics
- `"Face Recognition Person Webservice"` — Manage known persons for face recognition
- `"Face Recognition Event Webservice"` — Face recognition event data
- `"Face Recognition Matchmaker Webservice"` — Face matching configuration and thresholds
- `"Vehicle Webservice"` — Vehicle/LPR detection, license plate lookups
- `"Occupancy Webservice"` — People counting and occupancy data
- `"Logistics Webservice"` — Logistics and shipping/receiving analytics
- `"Proximity Webservice"` — Proximity detection events
- `"Search Webservice"` — AI-powered search across events

### Events & Monitoring
- `"Event Search Webservice"` — Search events across all device types (access, motion, analytics)
- `"Event Webservice"` — Event management and custom seekpoints
- `"Alert Monitoring Webservice"` — Alert rule configuration and monitoring
- `"Alarm Monitoring Keypad Webservice"` — Alarm panel keypad operations
- `"Lockdown Plan Webservice"` — Emergency lockdown plan configuration and execution
- `"RapidSOS Webservice"` — RapidSOS emergency integration
- `"Rules Webservice"` — Automation rules engine
- `"Rules Records Webservice"` — Rules execution history and records
- `"Schedule Webservice"` — Scheduling for access, rules, and operations

### Organization & Users
- `"User Webservice"` — User CRUD, roles, permissions
- `"User Metadata Webservice"` — Extended user metadata
- `"Org Webservice"` — Organization-level settings and configuration
- `"Customer Webservice"` — Customer/tenant management
- `"Location Webservice"` — Location hierarchy (buildings, floors, zones)
- `"Permission Webservice"` — Role-based access control configuration
- `"License Webservice"` — License management
- `"Feature Webservice"` — Feature flag management
- `"Policy Webservice"` — Security and retention policies
- `"Partner Webservice"` — Partner/reseller operations

### Integrations & Developer
- `"Developer Webservice"` — Event listeners (`/api/developer/createEventListener`, `getAllEventListeners`, `deleteEventListener`)
- `"Webhook Integrations Webservice"` — Organization webhooks (`/api/integrations/webhooks/getWebhookIntegration`, `updateWebhookIntegrationV2`)
- `"Integrations Webservice"` — General integration configuration
- `"Org Integrations Webservice"` — Organization-level integrations
- `"Incident Management Integrations Webservice"` — Incident management (e.g., PagerDuty)
- `"Service Management Integrations Webservice"` — Service management (e.g., ServiceNow)
- `"IoT Integrations Webservice"` — IoT platform integrations
- `"Storage Integrations Webservice"` — External storage integrations
- `"OAuth Webservice"` — OAuth flow management

### Media & Exports
- `"Video Webservice"` — Video frame retrieval, exact frame URIs, media operations
- `"Upload Webservice"` — File upload operations
- `"Export Webservice"` — Data and footage export
- `"Report Webservice"` — Report generation
- `"TvOs Config Webservice"` — Apple TV / display configuration
- `"Help Webservice"` — Help and support operations

## Working with the API Spec

The complete OpenAPI spec is at `references/rhombus-api.json` (167,856 lines). Never try to read it in full. Use targeted grep or `jq` searches. Note that an operationId does not always match the last path segment (for example, `POST /api/camera/getMediaUris` has operationId `getCameraMediaUris`).

### Search Patterns

**Find endpoints by keyword (most common):**
```bash
grep -i "keyword" references/rhombus-api.json | grep '"operationId"'
```

**List ALL endpoints in a category:**
```bash
jq -r '.paths | to_entries[] | .key as $p | .value[] | select(.tags[0] == "Camera Webservice") | "\(.operationId)  \($p)"' references/rhombus-api.json
```

**Count endpoints per category:**
```bash
grep '"tags" : \[' references/rhombus-api.json | sort | uniq -c | sort -rn
```

**Get full endpoint detail (path + operationId + tags) in one pass:**
```bash
grep -E '"(operationId|tags|summary)" :' references/rhombus-api.json | head -60
```

**Find a specific endpoint's request schema:**
```bash
grep -A 50 '"operationId" : "getMinimalCameraStateList"' references/rhombus-api.json | head -60
```

**Find schema definitions by name:**
```bash
grep '"SchemaName" :' references/rhombus-api.json -A 30
```

**Find all endpoints matching a pattern (e.g., all "create" operations):**
```bash
grep '"operationId" : "create' references/rhombus-api.json
```

**Find deprecated endpoints:**
```bash
grep -A3 '"deprecated" : true' references/rhombus-api.json | grep '"operationId"'
```

**Extract request body schema for an endpoint:**
```bash
grep -A 100 '"operationId" : "targetEndpoint"' references/rhombus-api.json | grep -A 20 '"requestBody"'
```

**Find endpoints that reference a specific schema:**
```bash
grep -i 'SchemaName' references/rhombus-api.json | head -20
```

### Search Strategy

1. Start with a keyword grep filtered to operationId to find candidate endpoints
2. Once you identify the operationId, grep with `-A 80` to get the full endpoint definition including parameters, request body, and response schema references
3. If the endpoint references a schema (e.g., `$ref`), follow the schema name to `components/schemas` in the spec
4. For complex workflows, identify the chain of endpoints needed and document the data flow between them (UUIDs from one response feed into the next request)

## GitHub Example Repositories

Rhombus maintains official example repos at `https://github.com/RhombusSystems/`. Evaluate recency before recommending — some may use older patterns.

### player-example (CURRENT — recommended reference)
- **Repo**: `https://github.com/RhombusSystems/player-example`
- **What it does**: Lightweight HTML/JS camera stream player using DashJS
- **Key patterns**: Server mints a federated token and calls getMediaUris → browser plays the MPEG-DASH URI in DashJS with `x-auth-scheme=federated-token&x-auth-ft=<token>` on each media request
- **Architecture**: Requires server-side proxy to protect API keys (never expose keys in frontend code)
- **When to reference**: Any video streaming, camera player, or embedded video implementation

### rhombus-api-examples-python
- **Repo**: `https://github.com/RhombusSystems/rhombus-api-examples-python`
- **Examples include**: User list export to CSV, temperature rate of change, LAN footage download, door open/close reports, live camera re-streaming, BLE tag movement tracking, timelapse creation, clip download with reports, webhook-triggered alert clip download
- **Auth pattern**: Uses `requests.session()` with persistent headers
- **When to reference**: Python-based integrations, batch operations, data export scripts

### rhombus-api-examples-javascript
- **Repo**: `https://github.com/RhombusSystems/rhombus-api-examples-javascript`
- **Examples include**: CopyFootageToLocalStorage, EmbedShareStreamInIFrame, ExtendedAIModule
- **Uses**: Rhombus Codegen for typed client stubs
- **When to reference**: Node.js integrations, iframe embedding, extended AI module usage

### rhombus-node-mcp
- **Repo**: `https://github.com/RhombusSystems/rhombus-node-mcp`
- **What it does**: MCP server for Claude integration with Rhombus API
- **Setup**: Docker or npx with `RHOMBUS_API_KEY` env var
- **When to reference**: Claude Code / MCP server setup, chatbot-driven security operations

### low-code-no-code
- **Repo**: `https://github.com/RhombusSystems/low-code-no-code`
- **What it does**: Workflow examples for Zapier, Make.com, n8n
- **When to reference**: No-code/low-code automation, webhook-based workflows

### Other repos (evaluate recency before recommending)
- `rhombus-api-examples-java` — Java API examples
- `rhombus-streamdeck` — Elgato Stream Deck integration
- `rhombus-jetson-roboflow` — NVIDIA Jetson + Roboflow edge AI
- `rhombus-libonvif` — ONVIF library with YOLOX
- `system-surveyor` — System Surveyor specs and profiles

## MCP servers (auto-attached by this plugin)

This plugin's `.mcp.json` wires two MCP servers automatically — you do not need to run `claude mcp add`.

| Server | Purpose | Key tools |
|---|---|---|
| `rhombus` (from `rhombus-node-mcp`) | Live API access — actually performs operations | `mcp__rhombus__*` (see `references/mcp-tool-reference.md` after first connection for the enumerated tool list) |
| `rhombus-docs` (HTTP MCP at api-docs.rhombus.community) | Live doc search | `mcp__rhombus-docs__search-documentation`, `mcp__rhombus-docs__get-endpoint-details`, `mcp__rhombus-docs__search-code-examples` |

Prerequisite for `rhombus`: `RHOMBUS_API_KEY` must be exported in the shell that launched Claude Code. If it isn't, the server fails silently at startup; run `/rhombus-mcp-status` to verify.

Users on Cursor / VS Code with a different plugin host can still use the docs MCP by adding to their own config — config snippet is in `docs/contributing.md`.

## Generating cURL Examples

Only emit cURL when the user explicitly asks for a shell example, or when the MCP is unavailable. Otherwise, prefer the equivalent `mcp__rhombus__*` tool — it handles auth, typed arguments, and retries automatically.

Every cURL command follows this pattern:

```bash
curl -X POST "https://api2.rhombussystems.com/api/ENDPOINT_PATH" \
  -H "x-auth-scheme: api-token" \
  -H "x-auth-apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "requiredField": "value"
  }'
```

For EU organizations, replace the host with `https://api2.eu.rhombussystems.com`.

Checklist: both auth headers present, POST method, Content-Type set, JSON body formatted, required vs optional fields annotated, realistic example values (base64 url-safe UUIDs like `"AAAAAAAAAAAAAAAAAAAAAA"`, millisecond epoch timestamps like `1234567890000`).

## SDK Client Generation

Rhombus publishes an OpenAPI 3.0 spec. Generate typed clients in any language:

```bash
# Python
openapi-generator-cli generate \
  -i https://api2.rhombussystems.com/api/openapi/public.json \
  -g python -o ./rhombus-python-client

# TypeScript/Node
openapi-generator-cli generate \
  -i https://api2.rhombussystems.com/api/openapi/public.json \
  -g typescript-fetch -o ./rhombus-ts-client

# Java, C#, Go, PHP, etc. — same pattern, swap the -g flag
```

The spec's `servers` entry lists only the US host. For EU organizations, set the generated client's base URL to `https://api2.eu.rhombussystems.com`.

The JavaScript examples repo uses Rhombus Codegen for typed stubs — this is an alternative to openapi-generator.

## Common Workflows

### Video Streaming (Browser)
1. Server mints a federated token: `POST /api/org/generateFederatedSessionToken` with `{"durationSec": 3600}` → `federatedSessionToken`
2. Server fetches media URIs with its API key: `POST /api/camera/getMediaUris` with `{"cameraUuid": "..."}` → `wanLiveMpdUri` (also `wanLiveM3u8Uri`, `wanLiveH264Uri`)
3. Browser initializes DashJS with the MPEG-DASH URI and appends `x-auth-scheme=federated-token&x-auth-ft=<token>` to every media request
4. See `player-example` repo for full implementation

### Video Retrieval (VOD / Clips)
1. Get camera list: `POST /api/camera/getMinimalCameraStateList`
2. Get the VOD URI template: `POST /api/camera/getMediaUris` with `{"cameraUuid": "..."}` → `wanVodMpdUriTemplate` (or `wanVodM3u8UriTemplate`)
3. Replace `{START_TIME}` with a Unix timestamp in **seconds** and `{DURATION}` with a length in seconds
4. Fetch the manifest and every segment with auth: a federated token (`x-auth-scheme: federated-token` + `x-auth-ft`, as headers or query parameters), or API-key headers from a server-side client
5. For exact frames: `POST /api/video/getExactFrameUri` with `{"cameraUuid": "...", "timestampMs": 1712345678000}` → `frameUri` (optional crop: `permyriadCropX`, `permyriadCropY`, `permyriadCropWidth`, `permyriadCropHeight`)

### Shared Stream Embedding (iFrame)
1. Create shared stream: `POST /api/camera/createSharedLiveVideoStream` with `{"cameraUuid": "..."}` → `sharedLiveVideoStreamUrl`
2. Embed returned URL in iframe: `<iframe src="SHARED_STREAM_URL"></iframe>`
3. URL params: `disableautoplay`, `hideevents`, `realtime`, `showheader` (true/false)

### Access Control Setup
1. Create user: `POST /api/user/createUser` (`email`, `name`)
2. Create credential: `POST /api/accesscontrol/createStandardCsnCredential` (`credentialValue`, `userUuid`)
3. Assign credential: `POST /api/accesscontrol/assignAccessControlCredential` (`credentialHexValue`, `userUuid`)
4. Create access grant: `POST /api/accesscontrol/createAccessGrant` (`accessGrant`)
5. Unlock a door: `POST /api/accesscontrol/unlockAccessControlledDoor` with `{"accessControlledDoorUuid": "..."}` (list doors with `POST /api/component/findAccessControlledDoors`)

### Face Recognition Pipeline
1. Create known person: Use Face Recognition Person endpoints
2. Configure matching: Use Face Recognition Matchmaker endpoints
3. Query events: Use Face Recognition Event Webservice search endpoints
4. Match results include confidence scores and matched person UUIDs

### Vehicle / LPR Workflow
1. Search vehicle events: Use Vehicle Webservice endpoints
2. Events include license plate text, vehicle images, timestamps
3. Combine with camera data for location context
4. Use `getExactFrameUri` with crop parameters for vehicle image extraction

### Webhook Setup
Rhombus sends two kinds of webhooks:
1. **Organization webhooks** (Activity or Diagnostic). Add one in the Console under **Settings → Integrations & Developer Resources → Webhooks**, or with the API: call `POST /api/integrations/webhooks/getWebhookIntegration`, then `POST /api/integrations/webhooks/updateWebhookIntegrationV2` with the current settings as `updatedWebhookSettings` plus `webhookUrl` (and `isDiagnostic: true` for a Diagnostic webhook). The response returns that URL's `webhookSecret`. Deliveries carry `x-rhombus-signature-sha1`.
2. **Rule webhook actions**. Add a webhook action to a rule with `POST /api/rules/createRule` or `POST /api/rules/updateRule`; the response's `webhookSecrets` maps each webhook URL to its secret. Deliveries carry `x-rhombus-signature-sha256` (actions without a secret are sent unsigned).
3. Implement a listener that verifies the signature over the raw body before parsing. Use the `rhombus-webhook-receiver` skill to scaffold one.
4. Details: `https://developer.rhombus.com/webhooks`

### Alarm Monitoring
1. Configure alarm rules via Alert Monitoring Webservice
2. Set up keypad operations via Alarm Monitoring Keypad Webservice
3. Integrate with RapidSOS for emergency dispatch

### Lockdown Execution
1. Create or find a plan: `POST /api/accesscontrol/lockdownPlan/createLocationLockdownPlan`, `POST /api/accesscontrol/lockdownPlan/findLockdownPlansByLocation`
2. Activate: `POST /api/accesscontrol/lockdownPlan/activateLockdownForLocation` with `locationUuid` and `lockdownPlanUuids`
3. Release when clear: `POST /api/accesscontrol/lockdownPlan/deactivateLockdownForLocation` with `locationUuid`

### IoT / Environmental Monitoring
1. Query sensor data: Use Sensor Webservice or Climate Webservice
2. Data includes temperature, humidity, air quality, vape detection
3. Set up alerts via Alert Monitoring Webservice for threshold violations

## Best Practices

**Performance**: Use `getMinimal*` endpoints when full details aren't needed. Cache location and device lists (they change infrequently). Implement pagination for large result sets. Use appropriate time ranges to limit results.

**Rate Limits**: Limits are enforced per organization: every API key and OAuth token in the org shares one token bucket, so extra keys don't add throughput. The bucket refills at a per-second rate and allows bursts of roughly 10x that rate. A throttled request gets `429` with a `Retry-After` header (seconds); wait that long, then retry with exponential backoff and jitter. See `https://developer.rhombus.com/rate-limits`.

**Security**: Never hardcode API keys — use environment variables or secret managers. For browser apps, keep the key on a server and hand the browser a short-lived federated token (`x-auth-scheme: federated-token` + `x-auth-ft`). Rotate API keys periodically. Use HTTPS for all requests.

**Error Handling**: 401 = auth failure (check API key + headers), 400 = bad request body, 404 = resource not found, 429 = rate limited (wait `Retry-After` seconds), 500 = server error (retry with exponential backoff). A `403` with "Invalid api key" often means the key belongs to the other region (US vs EU).

**Architecture**: Rhombus uses POST for all operations, including reads. UUIDs are base64 url-safe encoded strings. Timestamps are Unix epoch milliseconds. The API is the same API that Rhombus's own web console and mobile apps use — if you can do it in the UI, you can do it via API.

## Handling Questions

**"How do I [X]?"** → Identify the category, search for endpoints, provide a complete cURL example, explain the workflow if multi-step.

**"Build me [an app that does X]"** → Identify the relevant API workflows, reference the GitHub example repos for architectural patterns (especially `player-example` for video), and scaffold the implementation with proper auth, error handling, and the right endpoints.

**"What endpoints exist for [X]?"** → Search the spec by tag or keyword, list the relevant operationIds with brief descriptions.

**"Show me the schema for [X]"** → Find the endpoint in the spec, extract the request/response schema, and format it clearly.

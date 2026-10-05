# Rhombus MCP Tool Reference

Quick map: common API tasks → MCP tool to call first.

`rhombus-node-mcp` exposes a small set of task-level tools (for example `camera-tool`, `access-control-tool`), not one tool per endpoint. Most tools take a `requestType` (or `eventType` / `queryType`) argument that selects the operation. Tool names surface as `mcp__rhombus__<tool>` in Claude. The exact set depends on the version of `rhombus-node-mcp` you have connected; run `/rhombus-mcp-status` to confirm.

Every fallback endpoint below exists in the bundled spec (`rhombus-api.json`). All are `POST`.

## Cameras

| Task | MCP tool | Fallback endpoint |
|---|---|---|
| List cameras | `mcp__rhombus__get-entity-tool` | `POST /api/camera/getMinimalCameraStateList` |
| Camera settings | `mcp__rhombus__camera-tool` (`get-settings`) | `POST /api/deviceconfig/getFacetedConfig` |
| Get media URIs (live and VOD templates) | `mcp__rhombus__camera-tool` (`get-media-uris`) | `POST /api/camera/getMediaUris` |
| VOD clip URL | `mcp__rhombus__camera-tool` (`get-media-uris`) | `POST /api/camera/getMediaUris`, then fill `{START_TIME}` / `{DURATION}` (seconds) in `wanVodMpdUriTemplate` |
| Exact frame | `mcp__rhombus__camera-tool` (`image`) | `POST /api/video/getExactFrameUri` |
| Create shared stream | none | `POST /api/camera/createSharedLiveVideoStream` |

## Alerts and events

| Task | MCP tool | Fallback endpoint |
|---|---|---|
| Recent alerts | `mcp__rhombus__policy-alerts-tool` | `POST /api/event/getPolicyAlerts` |
| Device and access events | `mcp__rhombus__events-tool` | `POST /api/component/findPaginatedComponentEventsByAccessControlledDoor` (door events); per-device `get...Events...` endpoints for sensors |
| Saved clips | `mcp__rhombus__clips-tool` | `POST /api/event/getSavedClipsV2` |
| Create custom seekpoints | none | `POST /api/camera/createCustomFootageSeekpoints` |

## Access control

| Task | MCP tool | Fallback endpoint |
|---|---|---|
| List access-controlled doors | `mcp__rhombus__get-entity-tool` | `POST /api/component/findAccessControlledDoors` |
| Create credential | none | `POST /api/accesscontrol/createStandardCsnCredential` |
| Assign credential | `mcp__rhombus__access-control-tool` | `POST /api/accesscontrol/assignAccessControlCredential` |
| Create access grant | `mcp__rhombus__access-control-tool` | `POST /api/accesscontrol/createAccessGrant` |
| Door unlock | `mcp__rhombus__access-control-tool` | `POST /api/accesscontrol/unlockAccessControlledDoor` |

## Vehicle / LPR

| Task | MCP tool | Fallback endpoint |
|---|---|---|
| Search vehicle events | `mcp__rhombus__lpr-tool` | `POST /api/vehicle/getVehicleEvents` |
| Save a known plate | `mcp__rhombus__lpr-tool` | `POST /api/vehicle/saveVehicle` |

## Face recognition

| Task | MCP tool | Fallback endpoint |
|---|---|---|
| Add known person | none | `POST /api/faceRecognition/person/createPerson` |
| Search face events | `mcp__rhombus__faces-tool` | `POST /api/faceRecognition/faceEvent/findFaceEventsByOrg` |

## Webhooks

| Task | MCP tool | Fallback endpoint |
|---|---|---|
| List organization webhooks and secrets | none | `POST /api/integrations/webhooks/getWebhookIntegration` |
| Add or change an organization webhook | none | `POST /api/integrations/webhooks/updateWebhookIntegrationV2` (pass the current settings as `updatedWebhookSettings`; add `webhookUrl` to create one, which returns its `webhookSecret`) |
| Rule with a webhook action | `mcp__rhombus__rules-tool` | `POST /api/rules/createRule`, `POST /api/rules/updateRule` (response `webhookSecrets`) |

## Lockdown and emergency

| Task | MCP tool | Fallback endpoint |
|---|---|---|
| Activate lockdown | `mcp__rhombus__access-control-tool` | `POST /api/accesscontrol/lockdownPlan/activateLockdownForLocation` |
| Release lockdown | `mcp__rhombus__access-control-tool` | `POST /api/accesscontrol/lockdownPlan/deactivateLockdownForLocation` |

## Discovering tools not in this table

If the task is not in this sheet:

1. `mcp__rhombus-docs__search-documentation "<task keyword>"` — returns doc references with likely endpoints.
2. Check the full category list in `../SKILL.md` → "Complete API Category Reference".
3. If an MCP tool exists for your target endpoint, Claude will offer it in autocomplete as `mcp__rhombus__*`.
4. If no MCP tool exists, fall back to cURL via `/rhombus-curl <operationId>`.

Populate missing entries in this file as you discover them in your org.

# Rhombus MCP Tool Reference

Quick map: common API tasks → MCP tool to call first.

The exact tool names depend on the version of `rhombus-node-mcp` you have connected. Run `/rhombus-mcp-status` to confirm. Tool names surface as `mcp__rhombus__<tool>` in Claude.

## Cameras

| Task | MCP tool (typical) | Fallback endpoint |
|---|---|---|
| List cameras | `mcp__rhombus__getMinimalCameraStateList` | `POST /api/camera/getMinimalCameraStateList` |
| Fetch camera detail | `mcp__rhombus__getCameraState` | `POST /api/camera/getCameraState` |
| Get media URIs | `mcp__rhombus__getMediaUris` | `POST /api/camera/getMediaUris` |
| VOD clip URL | `mcp__rhombus__getVodUri` | `POST /api/camera/getVodUri` |
| Exact frame | `mcp__rhombus__getExactFrameUri` | `POST /api/video/getExactFrameUri` |
| Create shared stream | `mcp__rhombus__createSharedLiveVideoStream` | `POST /api/camera/createSharedLiveVideoStream` |

## Alerts and events

| Task | MCP tool (typical) | Fallback endpoint |
|---|---|---|
| Recent alerts | `mcp__rhombus__getRecentAlerts` | `POST /api/alert/getRecentAlerts` |
| Search events | `mcp__rhombus__searchEvents` | `POST /api/eventsearch/search` |
| Create custom event | `mcp__rhombus__createEvent` | `POST /api/event/createEvent` |
| Create seekpoint | `mcp__rhombus__createSeekpoint` | `POST /api/event/createSeekpoint` |

## Access control

| Task | MCP tool (typical) | Fallback endpoint |
|---|---|---|
| Create credential | `mcp__rhombus__createStandardCsnCredential` | `POST /api/accesscontrol/createStandardCsnCredential` |
| Assign credential | `mcp__rhombus__assignAccessControlCredential` | `POST /api/accesscontrol/assignAccessControlCredential` |
| Create access grant | `mcp__rhombus__createAccessGrant` | `POST /api/accesscontrol/createAccessGrant` |
| Door unlock | `mcp__rhombus__unlockDoor` | `POST /api/door/unlockDoor` |

## Vehicle / LPR

| Task | MCP tool (typical) | Fallback endpoint |
|---|---|---|
| Search vehicle events | `mcp__rhombus__searchVehicleEvents` | `POST /api/vehicle/searchVehicleEvents` |
| Add known plate | `mcp__rhombus__createKnownVehicle` | `POST /api/vehicle/createKnownVehicle` |

## Face recognition

| Task | MCP tool (typical) | Fallback endpoint |
|---|---|---|
| Add known person | `mcp__rhombus__createKnownPerson` | `POST /api/facerecognition/createKnownPerson` |
| Search FR events | `mcp__rhombus__searchFaceRecognitionEvents` | `POST /api/facerecognition/searchEvents` |

## Webhooks

| Task | MCP tool (typical) | Fallback endpoint |
|---|---|---|
| List webhooks | `mcp__rhombus__getWebhooks` | `POST /api/developer/getWebhooks` |
| Create webhook | `mcp__rhombus__createWebhook` | `POST /api/developer/createWebhook` |
| Delete webhook | `mcp__rhombus__deleteWebhook` | `POST /api/developer/deleteWebhook` |

## Lockdown and emergency

| Task | MCP tool (typical) | Fallback endpoint |
|---|---|---|
| Execute lockdown plan | `mcp__rhombus__executeLockdownPlan` | `POST /api/lockdown/executePlan` |
| Release lockdown | `mcp__rhombus__releaseLockdown` | `POST /api/lockdown/releasePlan` |

## Discovering tools not in this table

If the task is not in this sheet:

1. `mcp__rhombus-docs__search-documentation "<task keyword>"` — returns doc references with likely endpoints.
2. Check the full category list in `../SKILL.md` → "Complete API Category Reference".
3. If an MCP tool exists for your target endpoint, Claude will offer it in autocomplete as `mcp__rhombus__*`.
4. If no MCP tool exists, fall back to cURL via `/rhombus-curl <operationId>`.

Populate missing entries in this file as you discover them in your org.

# Rhombus API Quickstart

## Base URL
```
https://api2.rhombussystems.com      # US organizations
https://api2.eu.rhombussystems.com   # EU organizations
```

An organization lives in one region, and its API keys only work against that region's base URL. Paths, headers and payloads are the same in both regions. See https://developer.rhombus.com/api-regions.

## Authentication

All Rhombus API requests require two headers:

```bash
x-auth-scheme: api-token
x-auth-apikey: YOUR_API_KEY_HERE
```

Create the key in the Rhombus Console under **Settings → Integrations & Developer Resources → API Tokens → Add API Key**: enter a **Name**, set **Auth Type** to **Api Token** (the modal defaults to Certificate, which is for mTLS), pick a **Role**, and copy the key (it's shown only once). Partner organizations use **Settings → API Management → Add API Key**.

For browsers, video players and devices on the LAN, use a federated token instead of exposing your API key:
```bash
# Step 1: Server-side — mint a short-lived federated token with your API key
curl -X POST "https://api2.rhombussystems.com/api/org/generateFederatedSessionToken" \
  -H "x-auth-scheme: api-token" \
  -H "x-auth-apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"durationSec": 3600}'
# Response: {"federatedSessionToken": "..."}
# Optional: "deviceUUid" limits the token to one device. Use device-scoped tokens for LAN streaming.

# Step 2: Client-side — send the federated token as headers...
x-auth-scheme: federated-token
x-auth-ft: FEDERATED_TOKEN_FROM_STEP_1

# ...or, on media URLs and LAN device URLs, as query parameters
?x-auth-scheme=federated-token&x-auth-ft=FEDERATED_TOKEN_FROM_STEP_1
```

The scheme value is exactly `federated-token`, and a federated token never goes in `x-auth-apikey`. Devices on the LAN never accept API keys; they accept only federated tokens.

## Standard cURL Pattern

```bash
curl -X POST "https://api2.rhombussystems.com/api/ENDPOINT_PATH" \
  -H "x-auth-scheme: api-token" \
  -H "x-auth-apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "key": "value"
  }'
```

## Standard Python Pattern

```python
import requests

api_url = "https://api2.rhombussystems.com"  # EU: "https://api2.eu.rhombussystems.com"
session = requests.session()
session.headers = {
    "Accept": "application/json",
    "x-auth-scheme": "api-token",
    "Content-Type": "application/json",
    "x-auth-apikey": "YOUR_API_KEY"
}

# Example: list cameras
resp = session.post(f"{api_url}/api/camera/getMinimalCameraStateList", json={})
cameras = resp.json()
```

## Standard JavaScript/Node Pattern

```javascript
const response = await fetch('https://api2.rhombussystems.com/api/endpoint', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'x-auth-scheme': 'api-token',
    'x-auth-apikey': 'YOUR_API_KEY'
  },
  body: JSON.stringify({ /* request data */ })
});
const data = await response.json();
```

## API Categories

The Rhombus API is organized into 65+ categories. The most commonly used:

### Cameras & Video
- **Camera** — Camera management, video retrieval, snapshots, shared streams
- **Video** — Frame retrieval, exact frame URIs (with cropping support)
- **Doorbell Camera** — Doorbell-specific operations

### Access Control
- **Access Control** — Credentials, groups, grants, revocations, door unlock
- **Door** — Door sensors (open/close state and events)
- **Door Controller** — Door controller hardware
- **Elevator** — Elevator floor access control
- **Guest Management Kiosk** — Visitor management

### AI & Analytics
- **Face Recognition Person/Event/Matchmaker** — Face recognition pipeline
- **Vehicle** — LPR, license plate lookups, vehicle detection
- **Occupancy** — People counting
- **Logistics** — Shipping/receiving analytics

### IoT & Sensors
- **Sensor** — General IoT sensor data
- **Climate** — Temperature, humidity, air quality
- **BLE** — Bluetooth Low Energy tracking
- **Button** — Panic/emergency buttons
- **AudioGateway / AudioPlayback** — Audio devices

### Events & Monitoring
- **Event Search** — Cross-device event queries
- **Alert Monitoring** — Alert rules and notifications
- **Alarm Monitoring Keypad** — Alarm panel operations
- **Lockdown Plan** — Emergency lockdown management
- **RapidSOS** — Emergency dispatch integration
- **Rules / Schedule** — Automation engine

### Organization
- **User** — User management
- **Location** — Building/floor/zone hierarchy
- **Org** — Organization settings
- **Permission** — RBAC configuration

### Integrations
- **Developer** — Event listeners
- **Webhook Integrations** — Organization webhooks and their secrets
- **OAuth** — OAuth flows
- **Incident/Service Management Integrations** — PagerDuty, ServiceNow, etc.

## Common Endpoint Patterns

All paths start with `/api/<service>/` and every endpoint is `POST` with a JSON body (send `{}` when there are no fields).

### Listing Resources
- Path: `/api/<service>/getMinimal...` (for example `/api/camera/getMinimalCameraStateList`), `/api/<service>/get...` or `/api/<service>/find...`
- Body: Typically minimal or empty (`{}`)

### Creating Resources
- Path: `/api/<service>/create...`
- Body: Resource properties

### Updating Resources
- Path: `/api/<service>/update...`
- Body: Resource UUID + updated properties

### Deleting Resources
- Path: `/api/<service>/delete...`
- Body: Resource UUID

## Frequently Used Endpoints

### Camera Operations
```bash
# List all cameras
POST /api/camera/getMinimalCameraStateList
Body: {}

# Get media URIs: live streams (wanLiveMpdUri, wanLiveM3u8Uri, wanLiveH264Uri),
# VOD templates (wanVodMpdUriTemplate, wanVodM3u8UriTemplate) and LAN URIs
POST /api/camera/getMediaUris
Body: {"cameraUuid": "..."}
# Recorded footage: in a VOD template, replace {START_TIME} with a Unix timestamp
# in seconds and {DURATION} with a length in seconds.

# Get exact frame (supports cropping for vehicle/face extraction)
POST /api/video/getExactFrameUri
Body: {"cameraUuid": "...", "timestampMs": 1234567890000}

# Create shared live stream (for iframe embedding)
POST /api/camera/createSharedLiveVideoStream
Body: {"cameraUuid": "..."}
```

### Access Control
```bash
# List access-controlled doors
POST /api/component/findAccessControlledDoors
Body: {}

# Unlock an access-controlled door
POST /api/accesscontrol/unlockAccessControlledDoor
Body: {"accessControlledDoorUuid": "..."}

# Create access credential
POST /api/accesscontrol/createStandardCsnCredential
Body: {"credentialValue": "...", "userUuid": "..."}

# Get access events for a door
POST /api/component/findPaginatedComponentEventsByAccessControlledDoor
Body: {"accessControlledDoorUuid": "...", "createdAfterMs": 1234567890000, "createdBeforeMs": 1234567990000}

# Door sensors (open/close), not access-controlled doors
POST /api/door/getMinimalDoorStateList
```

### User Management
```bash
# List users
POST /api/user/getUsersInOrg
Body: {}

# Create user
POST /api/user/createUser
Body: {"email": "...", "name": "..."}
```

### Location Management
```bash
# List locations
POST /api/location/getLocations
Body: {}

# Get one location
POST /api/location/getLocation
Body: {"locationUuid": "..."}
```

### IoT / Sensors
```bash
# List environmental (climate) sensors and their current readings
POST /api/climate/getMinimalClimateStateList
Body: {}

# Get climate events for one sensor
POST /api/climate/getClimateEventsForSensor
Body: {"sensorUuid": "...", "createdAfterMs": 1234567890000, "createdBeforeMs": 1234567990000}
```

## Response Format

All successful responses return JSON with status 200. The response structure varies by endpoint but typically includes resource data or lists, UUIDs for created resources, and success indicators.

## Common Field Formats

### UUID Format
UUIDs in Rhombus are base64 (url-safe) encoded strings:
```
"AAAAAAAAAAAAAAAAAAAAAA"
```

### Timestamps
Timestamps are Unix epoch time in milliseconds:
```
1234567890000
```

### Pagination
Pagination fields vary by endpoint, so check each request schema. The most common pattern is `maxPageSize` plus `lastEvaluatedKey`: send the `lastEvaluatedKey` from the previous response to get the next page, and stop when the response has none.
```json
{
  "maxPageSize": 100,
  "lastEvaluatedKey": "value_from_previous_response"
}
```
Other endpoints use `limit`, `maxResults` with `lastTimestampMs`/`lastUuid`, or a nested `pageRequest` object.

## SDK Client Generation

Generate typed clients from the OpenAPI spec:
```bash
openapi-generator-cli generate \
  -i https://api2.rhombussystems.com/api/openapi/public.json \
  -g python -o ./rhombus-python-client
```

Supported generators: python, typescript-fetch, java, csharp, go, php, and many more.

## Error Handling

Common error responses:
- `401` — Authentication failed (check API key and headers)
- `400` — Bad request (check request body format)
- `403` with "Invalid api key" — often a key from the other region (US vs EU)
- `404` — Resource not found
- `429` — Rate limited: wait the `Retry-After` header's seconds, then retry with exponential backoff and jitter
- `500` — Server error (retry with exponential backoff)

## Rate Limits

Limits are enforced per organization. Every API key and OAuth token in the organization shares one token bucket, so adding keys doesn't add throughput. The bucket refills at a per-second rate and allows bursts of roughly 10x that rate. See https://developer.rhombus.com/rate-limits.

## Best Practices

1. **Always include both authentication headers** — Missing either will result in authentication failure
2. **Use POST for all endpoints** — Even for read operations
3. **Include Content-Type header** — Always use `application/json`
4. **Handle pagination** — Large result sets require pagination
5. **Use minimal endpoints when possible** — `getMinimal*` endpoints return less data and are faster
6. **Cache location and device lists** — These change infrequently
7. **Use federated tokens for browser apps** — Never expose API keys in frontend code; send `x-auth-scheme: federated-token` + `x-auth-ft`
8. **Use server-side proxies for streaming** — Protects API tokens and resolves CORS issues
9. **Check for deprecated endpoints** — Some older endpoints are marked as deprecated

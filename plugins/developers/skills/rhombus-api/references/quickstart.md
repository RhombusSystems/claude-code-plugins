# Rhombus API Quickstart

## Base URL
```
https://api2.rhombussystems.com
```

## Authentication

All Rhombus API requests require two headers:

```bash
x-auth-scheme: api-token
x-auth-apikey: YOUR_API_KEY_HERE
```

For browser-based apps, use federated session tokens instead of exposing your API key:
```bash
# Step 1: Server-side — generate a short-lived federated token
curl -X POST "https://api2.rhombussystems.com/api/org/generateFederatedSessionToken" \
  -H "x-auth-scheme: api-token" \
  -H "x-auth-apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"durationSec": 3600}'

# Step 2: Client-side — use the federated token
x-auth-scheme: federated-session-token
x-auth-apikey: FEDERATED_TOKEN_FROM_STEP_1
```

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

api_url = "https://api2.rhombussystems.com"
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

The Rhombus API is organized into 60+ categories. The most commonly used:

### Cameras & Video
- **Camera** — Camera management, video retrieval, snapshots, shared streams
- **Video** — Frame retrieval, exact frame URIs (with cropping support)
- **Doorbell Camera** — Doorbell-specific operations

### Access Control
- **Access Control** — Credentials, groups, grants, revocations, doors
- **Door** — Door state, lock/unlock operations
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
- **Developer** — API keys, webhooks
- **Webhook Integrations** — Webhook management
- **OAuth** — OAuth flows
- **Incident/Service Management Integrations** — PagerDuty, ServiceNow, etc.

## Common Endpoint Patterns

### Listing Resources
Most list endpoints follow this pattern:
- Path: `/api/category/list*` or `/api/category/getMinimal*`
- Method: POST
- Body: Typically minimal or empty (`{}`)

### Creating Resources
- Path: `/api/category/create*`
- Method: POST
- Body: Resource properties

### Updating Resources
- Path: `/api/category/update*`
- Method: POST
- Body: Resource UUID + updated properties

### Deleting Resources
- Path: `/api/category/delete*`
- Method: POST
- Body: Resource UUID

## Frequently Used Endpoints

### Camera Operations
```bash
# List all cameras
POST /api/camera/getMinimalCameraStateList

# Get camera details
POST /api/camera/getCamera
Body: {"cameraUuid": "..."}

# Get VOD URI for footage
POST /api/camera/getVodUri
Body: {"cameraUuid": "...", "startTime": 1234567890, "duration": 3600}

# Get media URIs for streaming (used with DashJS player)
POST /camera/getMediaUris
Body: {"cameraUuid": "..."}

# Get exact frame (supports cropping for vehicle/face extraction)
POST /video/getExactFrameUri
Body: {"cameraUuid": "...", "timestamp": 1234567890000}

# Create shared live stream (for iframe embedding)
POST /api/camera/createSharedLiveVideoStream
Body: {"cameraUuid": "..."}
```

### Access Control
```bash
# List access control doors
POST /api/door/getMinimalDoorStateList

# Lock/unlock a door
POST /api/door/updateDoorLockState
Body: {"doorUuid": "...", "lockState": "UNLOCKED"}

# Create access credential
POST /api/accesscontrol/createStandardCsnCredential
Body: {"csn": "...", "userId": "..."}

# Get access events
POST /api/event/searchAccessControlActivityEvent
Body: {"startTime": 1234567890, "endTime": 1234567890}
```

### User Management
```bash
# List users
POST /api/user/getOrgUserList

# Create user
POST /api/user/createUser
Body: {"email": "...", "firstName": "...", "lastName": "..."}
```

### Location Management
```bash
# List locations
POST /api/location/getLocations

# Get location hierarchy
POST /api/location/getLocationHierarchy
```

### IoT / Sensors
```bash
# Get sensor data
POST /api/sensor/getSensorData
Body: {"sensorUuid": "...", "startTime": 1234567890, "endTime": 1234567890}

# Get climate data
POST /api/climate/getClimateData
Body: {"sensorUuid": "...", "startTime": 1234567890, "endTime": 1234567890}
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
Many list endpoints support pagination:
```json
{
  "pageSize": 100,
  "pageToken": "optional_token_for_next_page"
}
```

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
- `404` — Resource not found
- `500` — Server error (retry with exponential backoff)

## Best Practices

1. **Always include both authentication headers** — Missing either will result in authentication failure
2. **Use POST for all endpoints** — Even for read operations
3. **Include Content-Type header** — Always use `application/json`
4. **Handle pagination** — Large result sets require pagination
5. **Use minimal endpoints when possible** — `getMinimal*` endpoints return less data and are faster
6. **Cache location and device lists** — These change infrequently
7. **Use federated tokens for browser apps** — Never expose API keys in frontend code
8. **Use server-side proxies for streaming** — Protects API tokens and resolves CORS issues
9. **Check for deprecated endpoints** — Some older endpoints are marked as deprecated

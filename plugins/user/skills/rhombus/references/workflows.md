# Rhombus CLI Workflow Recipes

Practical recipes for common tasks using the Rhombus CLI.

## Getting Started

```bash
# Install
brew install RhombusSystems/tap/rhombus

# Authenticate (opens browser)
rhombus login

# Verify it works
rhombus camera get-minimal-camera-state-list
```

## Camera Operations

### List all cameras
```bash
rhombus camera get-minimal-camera-state-list
```

### Get detailed camera settings
```bash
# First, find the camera UUID from the list above
rhombus camera get-camera-config --camera-uuid "cam_abc123"
```

### Watch camera footage
```bash
# Live view by name (fuzzy matched)
rhombus footage "front lobby"
rhombus footage "parking"

# By UUID
rhombus footage "cam_abc123"

# Jump to a specific time in the past
rhombus footage "front lobby" --start "5m ago"

# Extended session (2 hours)
rhombus footage "front lobby" --token-duration 7200
```

### Get camera media URIs
```bash
rhombus camera get-camera-media-uris --camera-uuid "cam_abc123"
```

## Alert Management

### Recent alerts (last hour)
```bash
rhombus alert recent
```

### Alerts for a specific camera
```bash
rhombus alert recent --camera "parking lot" --max 10
```

### Alerts from a custom time range
```bash
# Relative time
rhombus alert recent --after "30m ago"
rhombus alert recent --after "2h ago"

# Epoch milliseconds
rhombus alert recent --after 1700000000000
```

### Download alert media
```bash
# Get alert UUID from alert recent output
ALERT_UUID="alert_abc123"

# Download thumbnail
rhombus alert thumb "$ALERT_UUID" --output "alert-thumb.jpg"

# Download video clip
rhombus alert download "$ALERT_UUID" --output "alert-clip.mp4"

# Play in browser
rhombus alert play "$ALERT_UUID"
```

## Access Control

### Find access control group by name
```bash
# Use rhombus access-control --help to discover all available operations
rhombus access-control find-access-control-group-by-exact-name --name "Group Name"
```

### List doors
```bash
rhombus door get-minimal-door-state-list
```

### Get door controller status
```bash
# Use rhombus door-controller --help to discover available operations
rhombus door-controller register-discovered-rhombus-reader  # example; see --help for all commands
```

## AI & Analytics

### Face recognition
```bash
# Get a known person
rhombus face-recognition-person get-person --person-uuid "PERSON_UUID"

# Get a face recognition event
rhombus face-recognition-event get-face-event --event-uuid "EVENT_UUID"
```

### Vehicle / LPR
```bash
# Get vehicle detection events
rhombus vehicle get-vehicle-events

# List all vehicles
rhombus vehicle get-vehicles
```

### Occupancy
```bash
rhombus occupancy get-minimal-occupancy-sensor-state-list
```

## Organization Management

### List users
```bash
rhombus user get-users-in-org
```

### Organization settings
```bash
rhombus org get-org
```

### Locations
```bash
rhombus location get-locations
```

## Policy & Rules

### List alert policies
```bash
# Policies are per-type: camera, door, climate, etc.
rhombus policy get-camera-policies
# Also: get-door-policies, get-climate-policies, get-occupancy-policies, etc.
```

### Get policy alert details
```bash
rhombus event get-policy-alert-details --cli-input-json '{"alertUuid":"alert_abc123"}'
```

## Reports

### Generate a report
```bash
# Discover parameters
rhombus report get-count-report --generate-cli-skeleton

# Generate with parameters
rhombus report get-count-report --cli-input-json file://report-params.json
```

## Integrations

### Manage API tokens
```bash
rhombus integrations get-api-token-applications-dep
# Note: this command is deprecated. Consider using the developer group instead.
```

### Webhooks
```bash
# Get webhook integration details
rhombus webhook-integrations get-webhook-integration --cli-input-json '{"webhookUuid":"WEBHOOK_UUID"}'

# Use rhombus webhook-integrations --help to discover all available operations
```

## Rhombus MIND (AI Assistant)

### Interactive chat
```bash
rhombus chat
```

Then type natural language queries:
- "Show me all motion alerts from the last 30 minutes"
- "Which cameras are offline?"
- "Open the front door"
- "What's the occupancy of the main office?"

MIND has access to the full CLI and can execute commands on your behalf.

### Voice chat
```bash
# Default (small whisper model)
rhombus voice

# Better accuracy (slower)
rhombus voice --model medium
```

Press Enter to record, speak, press Enter to stop. On macOS, responses are spoken aloud.

## Multi-Profile Setup

```bash
# Configure production profile
rhombus configure --profile production

# Configure staging profile
rhombus configure --profile staging

# Use a specific profile
rhombus camera get-minimal-camera-state-list --profile staging

# Set default via environment
export RHOMBUS_PROFILE=staging
```

## JSON Skeleton Workflow

For any command you're unfamiliar with:

```bash
# 1. Generate the skeleton to see all parameters
rhombus event get-policy-alerts-v2 --generate-cli-skeleton > params.json

# 2. Edit the JSON file — fill in values, remove unused fields
# (editor of your choice)

# 3. Execute with the file
rhombus event get-policy-alerts-v2 --cli-input-json file://params.json
```

## Scripting with jq

```bash
# Get all camera UUIDs
rhombus camera get-minimal-camera-state-list | jq -r '.cameraStates[].uuid'

# Get names and UUIDs as TSV
rhombus camera get-minimal-camera-state-list | jq -r '.cameraStates[] | [.name, .uuid] | @tsv'

# Count cameras by location
rhombus camera get-minimal-camera-state-list | jq '.cameraStates | group_by(.locationUuid) | map({location: .[0].locationUuid, count: length})'

# Get all offline cameras
rhombus camera get-minimal-camera-state-list | jq '[.cameraStates[] | select(.connectionState != "connected")]'
```

## Troubleshooting

### Authentication Issues
```bash
# Re-authenticate
rhombus login

# Check stored credentials exist
cat ~/.rhombus/credentials

# Override with env var for testing
RHOMBUS_API_KEY="your-key" rhombus camera get-minimal-camera-state-list
```

### Endpoint Discovery
```bash
# List all service groups
rhombus --help

# List operations in a group
rhombus camera --help

# Get full parameter details
rhombus camera get-camera-config --generate-cli-skeleton
```

### Debug API Calls
```bash
# Use a different endpoint
rhombus camera get-minimal-camera-state-list --endpoint-url "https://staging-api.rhombussystems.com"
```

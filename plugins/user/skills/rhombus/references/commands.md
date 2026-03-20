# Rhombus CLI Command Reference

Complete reference for all CLI commands, organized by category.

## Hand-Written Commands

### rhombus login

Browser-based OAuth2 PKCE authentication flow.

1. Opens browser to `https://console.rhombussystems.com/login`
2. Local callback server on `localhost:11434/callback`
3. Exchanges authorization code for OAuth token
4. Creates permanent API key via `/api/integrations/org/submitApiTokenApplication`
5. Attempts cert-based auth first (ECDSA P-256), falls back to token-based
6. Detects partner accounts and saves `is_partner` flag
7. Saves credentials to active profile in `~/.rhombus/credentials`

**Flags:** Inherits global flags only. 5-minute timeout.

### rhombus configure

Interactive prompts:
- API Key
- Default output format (json/table/text)
- Default endpoint URL

Respects `--profile` for multi-profile setups.

### rhombus alert recent

List policy alerts from the organization.

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--camera` | string | — | Filter by camera name or UUID (fuzzy matched) |
| `--after` | string | 1 hour ago | Time filter: relative ("1h ago", "5m ago", "30m ago") or epoch ms |
| `--max` | int | 20 | Maximum alerts to return |

Camera name resolution: fetches full camera list, does case-insensitive substring match. Prompts if multiple matches.

### rhombus alert thumb [alert-uuid]

Download alert thumbnail as JPEG.

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--output` | string | `alert-<uuid>.jpg` | Output file path |

Uses media API at `https://media.rhombussystems.com`.

### rhombus alert download [alert-uuid]

Download alert video clip as DASH .mpd manifest.

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--output` | string | `alert-<uuid>.mpd` | Output file path |

### rhombus alert play [alert-uuid]

Play alert video clip in browser. Generates a temporary HTML file with a dash.js video player and opens it.

### rhombus live [camera-name-or-uuid]

Open live DASH video stream in browser.

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--duration` | int | 3600 | Federated session token lifetime in seconds |

Flow:
1. Resolves camera name to UUID (fuzzy match)
2. Generates federated session token via `/api/org/generateFederatedSessionToken`
3. Gets media URIs via `/api/camera/getMediaUris`
4. Creates temporary HTML file with dash.js player
5. Opens in default browser

### rhombus chat

Interactive AI chat with Rhombus MIND (backed by Claude).

- Sends tool definitions so MIND can execute CLI commands locally
- Handles tool-use loops: submit query → poll for response → execute tool calls → return results
- Color-coded terminal output: blue (user), green (MIND)
- APIs used: `/api/chatbot/submitChat`, `/api/chatbot/getChatRecord`

### rhombus voice

Voice-powered chat with Rhombus MIND.

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--model` | string | small | Whisper model: tiny, base, small, medium, large |

Dependencies:
- `sox` — audio recording (`rec` command)
- `whisper-cpp` (or `whisper-cli`) — local speech-to-text
- Whisper models auto-download to `~/.rhombus/models/` from HuggingFace
- macOS: speaks responses via `say` command
- Falls back to text input if user types instead of pressing Enter

---

## Auto-Generated Service Groups

All auto-generated from the Rhombus OpenAPI spec. Each group contains multiple operation subcommands.

### Device Management

| Command | Description |
|---------|-------------|
| `camera` | Camera management — largest group with ~50+ operations (get state, settings, streams, thumbnails, analytics) |
| `sensor` | Environmental sensor management |
| `door` | Door state and management |
| `door-controller` | Door controller hardware operations |
| `doorbell-camera` | Doorbell camera operations |
| `audio-gateway` | Audio gateway device management |
| `audio-playback` | Audio playback control |
| `climate` | Climate/temperature sensor operations |
| `badge-reader` | Badge reader operations |
| `button` | Panic button / device button management |
| `ble` | Bluetooth Low Energy device operations |
| `media-device` | Generic media device operations |
| `elevator` | Elevator control and monitoring |
| `device-config` | Cross-device configuration management |
| `component` | Component management (hardware components across device types) |

### Access Control

| Command | Description |
|---------|-------------|
| `access-control` | Access control groups, users, doors, schedules |
| `access-control-integrations` | Third-party access control integration management |
| `guest-management-kiosk` | Guest check-in kiosk operations |

### AI & Analytics

| Command | Description |
|---------|-------------|
| `face-recognition-person` | Manage known persons for face recognition |
| `face-recognition-event` | Face recognition event history |
| `face-recognition-matchmaker` | Face matching configuration and results |
| `vehicle` | Vehicle detection and license plate recognition (LPR) |
| `occupancy` | Room/zone occupancy monitoring |
| `logistics` | Package and delivery tracking |
| `proximity` | Proximity detection events |
| `scene-query` | Visual search across camera footage |
| `search` | Cross-system search operations |

### Events & Monitoring

| Command | Description |
|---------|-------------|
| `event` | Core event management (motion, alerts, system events) |
| `event-search` | Advanced event search with filters |
| `alert-monitoring` | Alert monitoring station configuration |
| `alarm-monitoring-keypad` | Alarm keypad operations (arm/disarm) |
| `lockdown-plan` | Lockdown plan management and activation |
| `policy` | Alert policy/rule management (motion zones, schedules, thresholds) |
| `rules` | Rules engine configuration |
| `rules-records` | Rules execution history |
| `schedule` | Schedule management for policies and access |
| `rapidsos` | RapidSOS emergency integration |

### Organization & Users

| Command | Description |
|---------|-------------|
| `org` | Organization settings, branding, features |
| `user` | User account management (CRUD, roles, permissions) |
| `user-metadata` | User metadata and custom fields |
| `customer` | Customer management |
| `location` | Location/site management |
| `permission` | Permission and role management |
| `license` | License management and allocation |
| `feature` | Feature flag management |
| `partner` | Partner/MSP operations (requires rhombus-partner plugin) |

### Integrations

| Command | Description |
|---------|-------------|
| `integrations` | General integrations (API tokens, connected services) |
| `webhook-integrations` | Webhook endpoint management |
| `org-integrations` | Org-level integration configuration |
| `iot-integrations` | IoT platform integrations |
| `storage-integrations` | Cloud storage (AWS S3, Azure, GCP) integrations |
| `incident-management-integrations` | Incident management platform integrations |
| `service-management-integrations` | ITSM/service management integrations |
| `oauth` | OAuth token and application management |
| `developer` | Developer tools and API key management |

### Media, Exports & Support

| Command | Description |
|---------|-------------|
| `video` | Video operations (clips, streams, VOD) |
| `upload` | File upload operations |
| `export` | Data export operations |
| `report` | Report generation (activity, compliance, analytics) |
| `tvos-config` | Apple TV display configuration |
| `help-service` | Support tickets, feedback, RMA requests, device triage |

---

## Generated Command Pattern

Every auto-generated subcommand follows the same interface:

### Discovery
```bash
# List all operations in a service group
rhombus camera --help

# Get help for a specific operation
rhombus camera get-minimal-camera-state-list --help
```

### Skeleton Generation
```bash
# Print JSON template with all parameters and example values
rhombus camera get-camera-settings-admin --generate-cli-skeleton
```

Output is a JSON object showing every available parameter with type-appropriate example values. Use this to discover what fields an endpoint accepts.

### Input Methods

**Individual flags (kebab-case):**
```bash
rhombus camera get-camera-settings-admin --camera-uuid "cam_abc123"
```

**Inline JSON:**
```bash
rhombus camera get-camera-settings-admin --cli-input-json '{"cameraUuid":"cam_abc123"}'
```

**JSON from file:**
```bash
rhombus camera get-camera-settings-admin --cli-input-json file://params.json
```

**Flag + JSON (flags override):**
```bash
rhombus camera get-camera-settings-admin \
  --cli-input-json file://base-params.json \
  --camera-uuid "cam_override"
```

### Value Coercion

Flag values are automatically coerced:
- JSON-parseable strings (arrays, objects, numbers, booleans) are parsed as their native types
- Everything else is passed as a string
- kebab-case flags map to camelCase API parameters (e.g., `--camera-uuid` → `cameraUuid`)

### Output

All commands output JSON by default. The `--output` global flag can switch to `table` or `text` format (table and text are partial implementations).

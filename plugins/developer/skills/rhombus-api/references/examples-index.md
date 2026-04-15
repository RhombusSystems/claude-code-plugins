# RhombusSystems GitHub — Example Repos Index

Annotated index of the public `RhombusSystems/*` repos, with "when to use" guidance. Use this as a first stop before writing new integration code.

## Reference implementations

### `rhombus-node-mcp`
- **Language:** TypeScript (Node)
- **Purpose:** Official MCP server wrapping the Rhombus API.
- **When to use:** You want LLM-driven agents (Claude Code, Cursor, custom) to call Rhombus operations with typed auth. This plugin auto-configures it.

### `rhombus-cli`
- **Language:** Go
- **Purpose:** First-class CLI for the Rhombus platform — 62+ auto-generated API commands plus hand-written features (alert retrieval, live streaming, footage download, video stitching, AI Chat, WebSocket alert tail).
- **When to use:** Terminal-driven workflows, bulk ops, analytics scripts. This plugin's `rhombus-user` and `rhombus-partner` plugins lean on it heavily.

## SDK + client examples

### `rhombus-api-examples-python`
- **Language:** Python
- **Examples:** User list CSV export, temperature rate-of-change, LAN footage download, door open/close reports, live re-streaming, BLE tag tracking, timelapse, clip download with reports, webhook-triggered alert clips.
- **When to use:** Python services, batch jobs, data export pipelines.

### `rhombus-api-examples-javascript`
- **Language:** JavaScript / TypeScript
- **Examples:** Copy footage to local storage, embed share-stream in iframe, extended AI module usage.
- **Uses:** Rhombus Codegen for typed stubs (alternative to openapi-generator).
- **When to use:** Node services, iframe embedding, TypeScript client work.

### `rhombus-api-examples-java`
- **Language:** Java
- **When to use:** JVM integrations. Evaluate recency before adopting patterns.

### `rhombus-react-sdk`
- **Language:** TypeScript (React)
- **Purpose:** React component library for common Rhombus UI patterns.
- **When to use:** Building in-browser dashboards on top of Rhombus video/alerts.

## Edge + streaming

### `Player-example`
- **Language:** HTML + JavaScript (DashJS)
- **Purpose:** Lightweight embedded video player using federated session tokens.
- **When to use:** Custom web player, multi-camera grid, embedding in a dashboard where iframe share-stream isn't enough.

### `edgecaster-stream-converter`
- **Language:** Python
- **Purpose:** Bridge RTSP ↔ Rhombus Secure Raw Streams.
- **When to use:** Ingest non-Rhombus RTSP cameras, or expose Rhombus cameras as RTSP to third-party NVRs. See `rhombus-edge-streaming` skill.

### `rhombus-libonvif`
- **Language:** C++ (LGPL 2.1)
- **Purpose:** ONVIF discovery + streaming with YOLOX object detection.
- **When to use:** Edge-AI analytics on ONVIF cameras locally.

### `rhombus-jetson-roboflow`
- **Language:** Python
- **Purpose:** NVIDIA Jetson + Roboflow + Rhombus integration reference.
- **When to use:** Jetson-based edge AI pipelines posting custom events to Rhombus.

### `rhombus-seekpoint-generator-example`
- **Language:** Python
- **Purpose:** Post custom AI detections as seekpoints on the Rhombus timeline.
- **When to use:** You have your own ML model and want events surfaced in Rhombus.

## Integrations

### `low-code-no-code`
- **Language:** YAML / JSON
- **Purpose:** Zapier, Make.com, n8n workflow templates.
- **When to use:** Non-engineers wiring Rhombus events to other SaaS tools.

### `rhombus-streamdeck`
- **Language:** Mixed
- **Purpose:** Elgato Stream Deck plugin for Rhombus operations.
- **When to use:** Physical button-mapped ops (open a specific camera, trigger a door, start lockdown).

### `system-surveyor`
- **Language:** N/A (specs)
- **Purpose:** System Surveyor device profiles for Rhombus hardware.
- **When to use:** Pre-sales / installer workflows in System Surveyor.

## Recency note

Recency of repos varies. Before copying patterns, check the repo's last commit date — anything untouched for >18 months may use older auth patterns (e.g., pre-federated-session-token). When in doubt, prefer `player-example`, `rhombus-api-examples-python`, and `rhombus-cli` — these are the actively maintained references.

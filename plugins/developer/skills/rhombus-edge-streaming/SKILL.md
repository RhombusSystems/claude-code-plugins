---
name: rhombus-edge-streaming
description: Implement edge streaming and third-party camera integration with Rhombus — re-streaming Rhombus cameras as RTSP via EdgeCaster, adding third-party RTSP/ONVIF cameras through a Rhombus Relay, local ONVIF tooling via rhombus-libonvif, custom analytics seekpoint generation, LAN streaming with federated tokens, and embedded player usage. Use whenever the user mentions RTSP, ONVIF, "edge ingest", "secure raw streams", "seekpoint", "third-party camera", "non-Rhombus camera", "NVR integration", "edgecaster", "Jetson", "roboflow", or asks to stream video out of or into the Rhombus platform via a non-standard path. Also trigger for questions about the Player-example repo and lightweight web camera embeds.
argument-hint: "[rtsp|onvif|seekpoint|player] [question]"
---

# Rhombus Edge Streaming

Rhombus supports several edge-streaming scenarios beyond the standard in-platform camera experience. This skill covers the right tool and repo for each.

## 1. Rhombus cameras out as RTSP — EdgeCaster

**Scenario:** You want Rhombus camera feeds available as standard RTSP streams for a third-party VMS, NVR, or AI system.

**Tool:** EdgeCaster (`edgecaster-stream-converter`) — a small box (Raspberry Pi 5, mini-PC, or Linux VM) that pulls each Rhombus camera's Secure Raw Stream (H.264 over HTTPS) with FFmpeg and re-broadcasts it as RTSP on the local network. One direction only: Rhombus → RTSP.

**Repo:** `https://github.com/RhombusSystems/edgecaster-stream-converter`

**Architecture:**

```
[Rhombus cameras] --Secure Raw Stream--> [EdgeCaster] --RTSP (rtsp://<device-ip>:8554/<name>)--> [VMS / NVR / AI system]
```

**When to recommend:** The user needs Rhombus video inside an existing VMS/NVR or an AI pipeline that only speaks RTSP.

## 2. Third-party cameras into Rhombus — Rhombus Relay

**Scenario:** You have non-Rhombus RTSP or ONVIF cameras and want their video in the Rhombus platform.

**Tool:** A Rhombus Relay (NVR) on the camera network. Discover and add the cameras in the Console, or with the Relay Webservice: `POST /api/relay/executeThirdPartyCameraDiscovery`, `POST /api/relay/addThirdPartyCameraViaOnvif`, `POST /api/relay/assignThirdPartyCameraToNVR`, `POST /api/relay/getMinimalThirdPartyCameraStateList`.

**When to recommend:** The user has cameras that can't be replaced and wants them managed and recorded in Rhombus.

## 2b. Local ONVIF tooling — rhombus-libonvif

**Scenario:** You want to discover and view ONVIF cameras locally, with on-device object detection, outside the Rhombus platform.

**Tool:** `rhombus-libonvif` — a client-side ONVIF implementation (command-line `onvif-util` and a GUI) with built-in YOLOX object detection. LGPL 2.1.

**Repo:** `https://github.com/RhombusSystems/rhombus-libonvif`

**When to recommend:** Edge-AI use cases where the user is doing analytics locally (on a NUC, Jetson, or similar) rather than in the cloud.

**Companion repo:** `rhombus-jetson-roboflow` for NVIDIA Jetson + Roboflow integration — preferred starting point if the user is specifically on Jetson hardware.

## 3. Custom analytics — seekpoint generator

**Scenario:** You have a third-party AI model (object detection, LPR, pose estimation) producing events, and want those events to appear as seekpoints/markers on the Rhombus video timeline.

**Tool:** `rhombus-seekpoint-generator-example` — Python reference for posting custom seekpoints to a camera's timeline.

**Repo:** `https://github.com/RhombusSystems/rhombus-seekpoint-generator-example`

**Architecture:**

```
[Your model] --detections--> [seekpoint generator] --POST /api/camera/createCustomFootageSeekpoints--> [Rhombus timeline]
```

**When to recommend:** The user has their own AI model (e.g., PPE detection, forklift safety, queue counting) and wants its output first-class in the Rhombus UI.

**Key endpoints:** `POST /api/camera/createCustomFootageSeekpoints` (create, many per call), `POST /api/camera/getCustomFootageSeekpointsV2` (read back), `POST /api/camera/deleteCustomFootageSeekpoints`.

## 4. Lightweight embedded player

**Scenario:** You want to embed a Rhombus camera feed in a third-party web app without using the iframe share-stream approach.

**Tool:** `Player-example` — minimal HTML + DashJS player.

**Repo:** `https://github.com/RhombusSystems/player-example`

**Architecture:**

```
[Browser] --asks for token + URIs--> [Your server] --API key--> [Rhombus POST /api/org/generateFederatedSessionToken, POST /api/camera/getMediaUris]
[Browser] --MPEG-DASH via DashJS, ?x-auth-scheme=federated-token&x-auth-ft=<token>--> [Rhombus media URLs]
```

**Why not iframe:** Iframe share-stream (`createSharedLiveVideoStream`) is simpler but has less control over UX. Use `Player-example` when you need custom overlays, multi-camera grids, or integration with third-party identity.

**Never:** embed API keys in browser code. Mint a federated token on your server and send it as `x-auth-scheme: federated-token` + `x-auth-ft` (headers, or query parameters on media URLs). The scheme value is exactly `federated-token`, and the token never goes in `x-auth-apikey`.

## 5. LAN streaming

**Scenario:** You want live or recorded video, or two-way audio, straight from cameras on the customer's network instead of through the cloud.

- `POST /api/camera/getMediaUris` returns LAN URIs (`lanLiveH264Uris`, `lanLiveMpdUris`, `lanLiveM3u8Uris`, `lanVodMpdUrisTemplates`, `lanVodM3u8UrisTemplates`, `lanCheckUrls`).
- Devices on the LAN **never accept API keys**. Mint a device-scoped federated token (`deviceUUid`) and send it on every request, including each segment and the WebSocket upgrade, as headers or query parameters.
- In VOD templates, replace `{START_TIME}` (Unix seconds) and `{DURATION}` (seconds).
- Guide: `https://developer.rhombus.com/implementations/lan-streaming`

## Decision tree

```
Non-Rhombus camera needs to be IN Rhombus?
  → RTSP or ONVIF → Rhombus Relay (Relay Webservice third-party camera endpoints)

Local ONVIF discovery or edge AI outside Rhombus?
  → rhombus-libonvif (or rhombus-jetson-roboflow on Jetson)

Rhombus camera needs to be OUT of Rhombus?
  → Need RTSP?    → EdgeCaster (edgecaster-stream-converter)
  → Need MPEG-DASH in a browser?  → player-example + federated tokens
  → Need it straight from the LAN? → LAN URIs from getMediaUris + device-scoped federated tokens

Custom AI events on Rhombus timeline?
  → rhombus-seekpoint-generator-example + POST /api/camera/createCustomFootageSeekpoints
```

## Reference sheet

See `references/rtsp-onvif.md` for:
- EdgeCaster install and setup
- ONVIF discovery gotchas (multicast, firewall, auth)
- Seekpoint payload shape
- Player-example server-side token proxy snippet

# RTSP / ONVIF / Edge Streaming Reference

Implementation notes for the edge-streaming scenarios in the `rhombus-edge-streaming` skill.

## EdgeCaster (edgecaster-stream-converter)

EdgeCaster re-streams Rhombus cameras as RTSP. It does not bring third-party cameras into Rhombus (use a Rhombus Relay for that).

**Install** (Ubuntu or Debian on a Raspberry Pi 5, mini-PC, or VM), or flash the EdgeCaster Raspberry Pi image:

```bash
curl -fsSL https://raw.githubusercontent.com/RhombusSystems/edgecaster-stream-converter/main/scripts/bootstrap.sh | sudo bash
```

**Set up:** open `http://edgecaster.local` (or `http://<device-ip>`), paste a Rhombus API key, switch on the cameras to stream, and copy each camera's RTSP link (`rtsp://<device-ip>:8554/<name>`) into the VMS, NVR, or AI system.

**Deployment:** Wired Gigabit network recommended. There is no fixed stream limit; capacity depends on the host's network and CPU. See the repo README for details.

## ONVIF discovery gotchas

- ONVIF discovery uses WS-Discovery over multicast (`239.255.255.250:3702`). Many corporate networks block multicast; fall back to static config with the camera's IP.
- Default ONVIF ports: 80 (control), 554 (RTSP). If the camera is on a non-standard port, add `:PORT` in the profile URL.
- Auth: ONVIF uses WS-Security `UsernameToken`. `rhombus-libonvif` handles this; if you roll your own, watch for clock skew (must be within 5 min of camera).
- Profile selection: cameras advertise multiple profiles ("Main", "Sub"). Use the sub-profile for analytics (lower bitrate) unless you need full resolution.

## Seekpoint payload shape

```json
POST /api/camera/createCustomFootageSeekpoints
{
  "cameraUuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "footageSeekPoints": [
    {
      "name": "Forklift aisle 3",
      "timestampMs": 1712345678000,
      "description": "custom-forklift-v1, confidence 0.94",
      "color": "BLUE",
      "displayOverlay": true
    }
  ]
}
```

- `name` (max 32 characters) and `timestampMs` are required; `description` (max 100 characters), `color` and `displayOverlay` are optional.
- Send many seekpoints in one call rather than one request per detection.
- The response carries only `error` / `errorMsg` / `warningMsg`, not seekpoint IDs. Read seekpoints back with `POST /api/camera/getCustomFootageSeekpointsV2`.

## Player-example server-side token proxy

```typescript
// server/proxy.ts  (Node + Express)
import express from 'express';
import fetch from 'node-fetch';

const app = express();

app.post('/api/rhombus-session', async (req, res) => {
  const r = await fetch('https://api2.rhombussystems.com/api/org/generateFederatedSessionToken', {
    method: 'POST',
    headers: {
      'x-auth-scheme': 'api-token',
      'x-auth-apikey': process.env.RHOMBUS_API_KEY!,
      'content-type': 'application/json',
    },
    body: JSON.stringify({ durationSec: 3600 }),
  });
  const { federatedSessionToken } = await r.json();
  res.json({ token: federatedSessionToken });
});
```

`/api/rhombus-session` is a route on your own server. Your server also calls `POST /api/camera/getMediaUris` with its API key and returns the URIs. The browser then sends the token on every media request as `x-auth-scheme: federated-token` + `x-auth-ft: <token>`, or as `?x-auth-scheme=federated-token&x-auth-ft=<token>` when the player can't set headers. The scheme value is exactly `federated-token`, and the token never goes in `x-auth-apikey`. For LAN device URLs, mint a device-scoped token by adding `deviceUUid` to the request body.

## Rate-limit considerations for seekpoint posting

- Limits are per organization: every API key and OAuth token in the org shares one token bucket that refills at a per-second rate and allows bursts of roughly 10x that rate. Extra API keys don't add throughput. See `https://developer.rhombus.com/rate-limits`.
- Batch detections into one `createCustomFootageSeekpoints` call per camera instead of one request per detection.
- On `429`, wait the `Retry-After` seconds, then retry with exponential backoff and jitter.
- To request a higher limit, contact `support@rhombus.com`.

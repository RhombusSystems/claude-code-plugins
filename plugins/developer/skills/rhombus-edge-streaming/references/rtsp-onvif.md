# RTSP / ONVIF / Edge Streaming Reference

Implementation notes for the four edge-streaming scenarios in the `rhombus-edge-streaming` skill.

## edgecaster-stream-converter

**Install:**

```bash
git clone https://github.com/RhombusSystems/edgecaster-stream-converter
cd edgecaster-stream-converter
pip install -r requirements.txt
```

**Minimal config (RTSP → Rhombus):**

```yaml
# config.yaml
source:
  type: rtsp
  url: rtsp://user:pass@192.168.1.100:554/stream1

destination:
  type: rhombus-secure-raw-stream
  api_key: ${RHOMBUS_API_KEY}
  target_camera_uuid: AAAAAAAAAAAAAAAAAAAAAA
```

**Deployment:** Run as a systemd service on a small edge host (RPi 5, mini PC, NUC). One gateway can multiplex several streams; check repo README for resource guidance.

## ONVIF discovery gotchas

- ONVIF discovery uses WS-Discovery over multicast (`239.255.255.250:3702`). Many corporate networks block multicast; fall back to static config with the camera's IP.
- Default ONVIF ports: 80 (control), 554 (RTSP). If the camera is on a non-standard port, add `:PORT` in the profile URL.
- Auth: ONVIF uses WS-Security `UsernameToken`. `rhombus-libonvif` handles this; if you roll your own, watch for clock skew (must be within 5 min of camera).
- Profile selection: cameras advertise multiple profiles ("Main", "Sub"). Use the sub-profile for analytics (lower bitrate) unless you need full resolution.

## Seekpoint payload shape

```json
POST /api/event/createSeekpoint
{
  "cameraUuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "timestamp": 1712345678000,
  "durationMs": 3000,
  "title": "Forklift in aisle 3",
  "tags": ["forklift", "aisle-3"],
  "metadata": {
    "confidence": 0.94,
    "model": "custom-forklift-v1"
  }
}
```

Response includes a `seekpointUuid` you can reference when linking back to the event from your system.

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
    body: JSON.stringify({ ttlSec: 3600 }),
  });
  const { federatedSessionToken } = await r.json();
  res.json({ token: federatedSessionToken });
});
```

Browser calls `/api/rhombus-session`, receives the short-lived token, then uses it with `x-auth-scheme: federated-session-token` to fetch media URIs.

## Rate-limit considerations for seekpoint posting

- Hard cap: 1,000 req/hr per API key.
- If your model emits >1,000 events/hour, batch before posting or request a higher rate limit via `api@rhombus.com`.
- For bursty workloads (e.g., LPR at rush hour), implement exponential backoff on 429 responses.

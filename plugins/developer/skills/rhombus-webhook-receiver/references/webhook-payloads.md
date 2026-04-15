# Rhombus Webhook Payload Reference

Example payloads for each event category. These are illustrative — the exact fields on your webhook depend on which event types you subscribed to and which feature flags your org has enabled. Use `mcp__rhombus-docs__search-documentation webhook payloads` for authoritative, version-current shapes.

## Envelope (common to all events)

Every Rhombus webhook request has:

- HTTP method: `POST`
- Headers: `Content-Type: application/json`, `X-Rhombus-Signature: <hex-hmac>`, `X-Rhombus-Delivery-Id: <uuid>`
- Body: a JSON object with at minimum `type`, `uuid` (event uuid), `timestamp` (ms epoch), and event-specific fields.

## Camera motion event

```json
{
  "type": "cameraMotion",
  "uuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "timestamp": 1712345678000,
  "cameraUuid": "BBBBBBBBBBBBBBBBBBBBBB",
  "locationUuid": "CCCCCCCCCCCCCCCCCCCCCC",
  "motionZones": ["front-door"],
  "durationMs": 4200,
  "confidence": 0.92,
  "mediaUri": "https://media.rhombussystems.com/..."
}
```

## Alert event

```json
{
  "type": "alert",
  "uuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "alertUuid": "DDDDDDDDDDDDDDDDDDDDDD",
  "timestamp": 1712345678000,
  "cameraUuid": "BBBBBBBBBBBBBBBBBBBBBB",
  "ruleUuid": "EEEEEEEEEEEEEEEEEEEEEE",
  "severity": "high",
  "title": "Parking lot — after hours motion",
  "mediaUris": {
    "still": "https://media.rhombussystems.com/.../still.jpg",
    "clip": "https://media.rhombussystems.com/.../clip.mp4"
  }
}
```

## Door event

```json
{
  "type": "doorAccess",
  "uuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "timestamp": 1712345678000,
  "doorUuid": "FFFFFFFFFFFFFFFFFFFFFF",
  "doorControllerUuid": "GGGGGGGGGGGGGGGGGGGGGG",
  "action": "unlocked",
  "credentialUuid": "HHHHHHHHHHHHHHHHHHHHHH",
  "userUuid": "IIIIIIIIIIIIIIIIIIIIII",
  "granted": true
}
```

Note: `cameraUuid` is **not** on door events. Identifier is `doorUuid`.

## LPR / vehicle event

```json
{
  "type": "vehicleDetection",
  "uuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "timestamp": 1712345678000,
  "cameraUuid": "BBBBBBBBBBBBBBBBBBBBBB",
  "plateText": "ABC1234",
  "plateConfidence": 0.98,
  "matchedKnownPlate": true,
  "knownPlateUuid": "JJJJJJJJJJJJJJJJJJJJJJ",
  "vehicleImage": "https://media.rhombussystems.com/..."
}
```

## Access credential event

```json
{
  "type": "credentialIssued",
  "uuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "timestamp": 1712345678000,
  "credentialUuid": "HHHHHHHHHHHHHHHHHHHHHH",
  "userUuid": "IIIIIIIIIIIIIIIIIIIIII",
  "credentialType": "standardCsn",
  "issuedBy": "KKKKKKKKKKKKKKKKKKKKKK"
}
```

## IoT sensor threshold event

```json
{
  "type": "sensorThreshold",
  "uuid": "AAAAAAAAAAAAAAAAAAAAAA",
  "timestamp": 1712345678000,
  "sensorUuid": "LLLLLLLLLLLLLLLLLLLLLL",
  "sensorType": "climate",
  "metric": "temperature",
  "value": 32.4,
  "thresholdType": "above",
  "thresholdValue": 30.0,
  "units": "celsius"
}
```

## Signature verification snippet (Node)

```typescript
import crypto from 'crypto';

export function verifySignature(rawBody: Buffer, signature: string, secret: string): boolean {
  const expected = crypto.createHmac('sha256', secret).update(rawBody).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(expected, 'hex'), Buffer.from(signature, 'hex'));
}
```

## Signature verification snippet (Python)

```python
import hmac, hashlib

def verify_signature(raw_body: bytes, signature: str, secret: str) -> bool:
    expected = hmac.new(secret.encode(), raw_body, hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, signature)
```

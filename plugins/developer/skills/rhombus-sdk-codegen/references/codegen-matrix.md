# Rhombus SDK Codegen — Language Matrix

Reference tables for generating and using Rhombus API clients in each supported language.

## Generator flags

| Language | Generator | Notes |
|---|---|---|
| Python | `python` | Produces `urllib3`-based client. Package `openapi_client` by default — override with `--package-name rhombus`. |
| TypeScript (fetch) | `typescript-fetch` | Native `fetch`; no runtime deps. Good default for Node 18+ and browsers. |
| TypeScript (axios) | `typescript-axios` | Adds axios dep. Prefer if the rest of the project already uses axios. |
| TypeScript (node) | `typescript-node` | Uses `request` library (deprecated); avoid in new work. |
| Java | `java` | Maven by default. Override with `--library jersey2` or `okhttp-gson` to change HTTP stack. |
| Go | `go` | Produces idiomatic Go packages; pointer types for all nullable fields. |
| C# | `csharp` | Uses `RestSharp`. For .NET 6+ generic hosts, consider `csharp-netcore`. |

## Auth helper snippets

### Python

```python
from openapi_client import Configuration, ApiClient
import os

config = Configuration(host="https://api2.rhombussystems.com")
config.api_key['x-auth-apikey'] = os.environ['RHOMBUS_API_KEY']
config.api_key['x-auth-scheme'] = 'api-token'
client = ApiClient(config)
```

### TypeScript (fetch)

```typescript
import { Configuration, CameraWebserviceApi } from './generated';

const config = new Configuration({
  basePath: 'https://api2.rhombussystems.com',
  headers: {
    'x-auth-apikey': process.env.RHOMBUS_API_KEY!,
    'x-auth-scheme': 'api-token',
  },
});
const cameras = new CameraWebserviceApi(config);
```

### Java

```java
ApiClient client = new ApiClient();
client.setBasePath("https://api2.rhombussystems.com");
client.addDefaultHeader("x-auth-apikey", System.getenv("RHOMBUS_API_KEY"));
client.addDefaultHeader("x-auth-scheme", "api-token");
```

### Go

```go
cfg := rhombus.NewConfiguration()
cfg.Servers = rhombus.ServerConfigurations{
    { URL: "https://api2.rhombussystems.com" },
}
cfg.DefaultHeader["x-auth-apikey"] = os.Getenv("RHOMBUS_API_KEY")
cfg.DefaultHeader["x-auth-scheme"] = "api-token"
client := rhombus.NewAPIClient(cfg)
```

## Known gotchas

- **All endpoints are POST.** The generated client will reflect this. If you see a `GET` in generated code, the spec changed or the generator is stale — regenerate.
- **UUIDs are base64 url-safe strings**, not RFC 4122 hyphenated UUIDs. Generated clients type them as `string`.
- **Timestamps are milliseconds since epoch**, as `int64` / `number`. Always convert to your local time class at boundaries.
- **Nullable fields in Go**: generator produces pointer types (`*string`). Always nil-check before deref.
- **TypeScript optional fields**: the fetch generator emits `field?: T`. Node 18's `fetch` serializes `undefined` fields as absent — don't `JSON.stringify` manually.
- **Python package name collision**: by default the generated package is `openapi_client`, which collides across multiple generated SDKs. Always use `--package-name rhombus` for disambiguation.

## Federated session token pattern (browser apps)

For browser-based apps, never embed the API key. Instead, run a small server that:

1. Holds `RHOMBUS_API_KEY` securely.
2. Exposes an endpoint like `POST /api/rhombus-session` that calls `generateFederatedSessionToken` via the SDK.
3. Returns the short-lived token to the browser.

Browser uses `x-auth-scheme: federated-session-token` with the token in `x-auth-apikey`. See `player-example` repo for a full implementation.

## Regeneration

The Rhombus OpenAPI spec updates periodically. Regenerate your client at least quarterly — the `rhombus-openapi-freshness` hook in this plugin will remind you if the local spec is >90 days old.

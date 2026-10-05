---
name: rhombus-webhook-receiver
description: Scaffold a webhook listener for Rhombus events in Express (Node.js), FastAPI (Python), or AWS Lambda. Use whenever the user asks to build a webhook endpoint, event listener, or receiver for Rhombus alerts, door events, LPR matches, or any Rhombus-triggered automation. Also trigger on phrases like "wire up a webhook", "receive Rhombus events", "PagerDuty integration", "Slack notifier for Rhombus", "alert webhook", or anything about handling Rhombus event payloads. Covers signature verification, idempotency, and known payload shapes.
argument-hint: "[express|fastapi|lambda] [feature]"
---

# Rhombus Webhook Receiver

Scaffold a production-ready webhook listener for Rhombus events. The scaffold includes signature verification, idempotency, and structured logging — the three things every Rhombus webhook listener needs.

## Supported targets

| Flag | Stack | Output |
|---|---|---|
| `express` | Node.js + Express + TypeScript | `index.ts`, `verify.ts`, `dedupe.ts`, `handlers/*.ts`, `package.json`, `.env.example` |
| `fastapi` | Python 3.11+ + FastAPI + uvicorn | `app.py`, `verify.py`, `dedupe.py`, `handlers/`, `pyproject.toml`, `.env.example` |
| `lambda` | AWS Lambda + API Gateway | `handler.py` or `handler.ts`, `template.yaml` (SAM), `.env.example` |

## Scaffolded components

Every scaffold includes these files:

1. **HTTP entry point** — receives `POST /webhook` with a raw body reader (critical for signature verification).
2. **Signature verifier** — lowercase-hex HMAC of the raw body keyed with the webhook secret from env (the secret string as-is, UTF-8), compared in constant time. Check `x-rhombus-signature-sha256` (HMAC-SHA256, rule webhook actions) first, then `x-rhombus-signature-sha1` (HMAC-SHA1, organization webhooks). Reject with `401` when the header is missing or doesn't match.
3. **Idempotency layer** — dedupes by `alertUuid` (organization webhooks) or `uuid` (rule webhook actions) using an in-memory LRU for dev; swap to Redis/DynamoDB for prod.
4. **Event router** — for organization webhooks, switches on `activityTrigger` / `diagnosticTrigger`; for rule webhook actions, on `ruleUuid` and each `deviceEvents[].activities`. Default handlers are stubs that log the payload.
5. **Structured logger** — logs every attempt with the dedupe key, trigger, signature-ok flag, duplicate flag, outcome.

## Two kinds of Rhombus webhooks

| | Organization webhooks | Rule webhook actions |
|---|---|---|
| Set up in | Console **Settings → Integrations & Developer Resources → Webhooks** (Trigger Type **Activity** or **Diagnostic**), or `POST /api/integrations/webhooks/updateWebhookIntegrationV2` | A rule's webhook action (`POST /api/rules/createRule`, `POST /api/rules/updateRule`) |
| Secret | **Webhook Secret** column in the Console; `webhookSecret` in the API response when you add a URL | `webhookSecrets` (URL → secret) in the createRule / updateRule response |
| Signature header | `x-rhombus-signature-sha1` | `x-rhombus-signature-sha256` |
| Body | `version`, `activityTrigger` or `diagnosticTrigger`, `summary`, `deviceUuid`, `location` (location UUID), `deviceType`, `timestampMs`, `alertUuid`, ... | `uuid`, `orgUuid`, `ruleUuid`, `triggeredTimestampMs`, `deviceEvents`, `ruleTriggers`, ... |

Each webhook URL has its own secret. There is no delivery-ID header and no signed timestamp.

## Known payload shapes

See `references/webhook-payloads.md` for the full field list of both bodies, sample JSON, a test vector, and verified Node and Python verification code.

**Important:** don't assume every event comes from a camera. Check `deviceType`, and treat absent fields as normal: Rhombus omits fields that don't apply.

## Signature verification — the pitfall

Rhombus computes the signature over the **raw request body bytes**, not a re-serialized JSON. If your framework auto-parses JSON before you can access the raw body, signature verification will fail.

Framework-specific fixes:

- **Express:** use `express.raw({ type: 'application/json' })` on the webhook route; parse JSON *after* verification.
- **FastAPI:** use `await request.body()` (returns bytes) before parsing.
- **Lambda:** use the raw `event.body` (base64-decode if `isBase64Encoded`). API Gateway may change header-name casing, so look headers up case-insensitively.

Compare with `crypto.timingSafeEqual` (Node, after checking equal lengths) or `hmac.compare_digest` (Python), never `==`.

## Delivery and idempotency

- Organization webhooks count any `2xx` as delivered; rule webhook actions count only `200` or `202`. Return `200`.
- Respond within a second or two and enqueue heavy work to a background worker. Rhombus gives up quickly if it can't connect to your URL.
- A failed delivery is recorded as a webhook-failure diagnostic in the organization and is not retried, so log every request you receive.
- Dedupe anyway, by `alertUuid` (organization webhooks) or `uuid` (rule webhook actions).

## Next steps after scaffolding

1. Get the webhook secret: copy it from **Settings → Integrations & Developer Resources → Webhooks** (organization webhooks) or from the `webhookSecrets` map returned by `createRule` / `updateRule` (rule webhook actions). Set it as `RHOMBUS_WEBHOOK_SECRET` in your `.env`; if you register several URLs, store one secret per URL.
2. Expose your listener publicly (ngrok/cloudflared for dev, a real host for prod).
3. Register the URL with Rhombus: add an organization webhook (Activity or Diagnostic) in the Console, or add a webhook action to a rule.
4. Trigger a test event and confirm you see it in the logs with `sig_ok=true, duplicate=false`.
5. Fill in handler logic for each trigger you actually care about.

Docs: https://developer.rhombus.com/webhooks and https://developer.rhombus.com/implementations/webhook-listener

If deliveries aren't arriving, invoke the `rhombus-webhook-debugger` agent.

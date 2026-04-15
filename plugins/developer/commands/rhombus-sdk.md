---
description: Generate a typed Rhombus SDK client from the official OpenAPI spec for Python, TypeScript, Java, or Go. Runs openapi-generator-cli. This is a side-effecting command that writes files to disk; keep it slash-only.
argument-hint: "[python|ts|java|go] [output-dir]"
disable-model-invocation: true
---

Generate a typed Rhombus API client for the language specified in `$ARGUMENTS`.

Parse `$ARGUMENTS` as `<language> [output-dir]`. Default output dir: `./rhombus-<language>-client`.

Language → generator flag map:

| Language | Generator |
|---|---|
| `python` | `python` |
| `ts` / `typescript` | `typescript-fetch` |
| `java` | `java` |
| `go` | `go` |

Command template:

```bash
openapi-generator-cli generate \
  -i https://api2.rhombussystems.com/api/openapi/public.json \
  -g <generator> \
  -o <output-dir>
```

Prerequisites check:
- `openapi-generator-cli` available on PATH (`which openapi-generator-cli`)
- Network access to `api2.rhombussystems.com`

If the generator CLI is missing, point the user at `npm install -g @openapitools/openapi-generator-cli` or the Homebrew install.

After generation, read `../skills/rhombus-sdk-codegen/references/codegen-matrix.md` for language-specific follow-up (auth helper patterns, known gotchas, package structure).

# Developer Plugin

Tools for engineers building on the Rhombus platform.

## Skills

| Skill | Command | Description |
|---|---|---|
| `rhombus-api` | `/rhombus-api` | Full Rhombus API reference (846+ endpoints, OpenAPI spec, SDK generation) |
| `api-doc` | `/api-doc` | Generate API documentation from source code |
| `code-review` | `/code-review` | Structured code review for quality, security, and performance |

## Hooks

| Hook | Event | Description |
|---|---|---|
| `rhombus-api-intercept` | PreToolUse (Bash) | Suggests `rhombus` CLI when detecting raw curl/wget calls to Rhombus APIs |

## Quick Start

```bash
# Enable the plugin
/plugin enable rhombus-developer

# Look up an API endpoint
/rhombus-api How do I list cameras?

# Generate docs for your code
/api-doc src/routes/

# Review code for issues
/code-review src/auth.ts
```

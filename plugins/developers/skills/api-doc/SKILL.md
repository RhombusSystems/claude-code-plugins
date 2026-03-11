---
name: api-doc
description: >
  Generate API documentation from source code, including endpoint descriptions,
  request/response schemas, and usage examples. Use this skill when the user asks
  to document an API, generate API docs, create endpoint documentation, or write
  OpenAPI/Swagger specs. Also trigger on: API documentation, document endpoints,
  REST docs, API reference, endpoint docs, swagger, openapi spec, API schema,
  route documentation, document this API, generate docs for routes.
argument-hint: "[file or directory path]"
allowed-tools: Read, Grep, Glob
---

# API Documentation Generator

Generate clear, complete API documentation from source code.

## Process

### 1. Discover Endpoints

- Glob for route/controller files based on the framework detected:
  - Express: `**/routes/**`, `**/controllers/**`, `app.get/post/put/delete`
  - FastAPI: `**/*router*`, `@app.get/post/put/delete`
  - Django: `**/urls.py`, `**/views.py`
  - Spring: `**/*Controller*`, `@GetMapping/@PostMapping`
  - Generic: Search for HTTP method patterns
- Read each file to extract route definitions, middleware, and handlers

### 2. Extract Information Per Endpoint

For each endpoint, document:

- **Method & Path**: `GET /api/v1/users/:id`
- **Description**: What this endpoint does (infer from handler logic and naming)
- **Authentication**: Required auth (check for auth middleware/decorators)
- **Parameters**: Path params, query params, headers
- **Request Body**: Schema with types and required/optional fields
- **Response**: Success and error response shapes with status codes
- **Example**: A curl command or fetch example

### 3. Output Format

Generate documentation in Markdown:

```markdown
# API Reference

## Authentication
<describe auth mechanism>

## Endpoints

### <Resource Name>

#### <METHOD> <path>
<description>

**Authentication:** Required / Optional / None

**Parameters:**
| Name | In | Type | Required | Description |
|------|-----|------|----------|-------------|

**Request Body:**
```json
{
  "field": "type — description"
}
```

**Response (200):**
```json
{
  "field": "type — description"
}
```

**Errors:**
| Status | Description |
|--------|-------------|

**Example:**
```bash
curl -X METHOD https://api.example.com/path \
  -H "Authorization: Bearer <token>" \
  -d '{"field": "value"}'
```
```

### 4. Additional Output Options

If the user asks for OpenAPI/Swagger format, output a valid OpenAPI 3.0 YAML spec instead of Markdown.

## Guidelines

- Infer descriptions from function names, comments, and logic — don't leave fields as "TODO"
- Include all status codes the endpoint can return (check error handling)
- Group endpoints by resource/domain
- Note any rate limiting, pagination, or versioning patterns
- If types are available (TypeScript, Python type hints), use them for schemas

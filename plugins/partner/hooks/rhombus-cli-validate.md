---
name: rhombus-cli-validate
event: PreToolUse
matcher: Bash
type: prompt
---

Inspect the bash command about to be executed. If it starts with `rhombus ` (the Rhombus CLI):

1. **Check for common mistakes:**
   - Using GET-style flags (like `--method GET`) — all Rhombus API calls are POST
   - Missing required authentication (no `--api-key` flag and no `rhombus login` in conversation history)
   - Using camelCase flags instead of kebab-case (e.g., `--cameraUuid` should be `--camera-uuid`)
   - Passing JSON directly as a positional argument instead of via `--cli-input-json`

2. **Enhance if helpful:**
   - If the command output is raw JSON and might benefit from `jq` formatting, suggest piping through `jq`
   - If the user is running a list command with no filters, mention available filter flags

Do NOT block the command. Only add helpful suggestions or warnings before allowing it to proceed.

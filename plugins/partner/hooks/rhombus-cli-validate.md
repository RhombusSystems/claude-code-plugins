---
name: rhombus-cli-validate
event: PreToolUse
matcher: Bash
type: prompt
---

Inspect the bash command about to be executed. If it starts with `rhombus ` (the Rhombus CLI):

## 1. Partner scoping check (partner-specific)

If the command operates on client-scoped resources (service groups: `camera`, `door`, `door-controller`, `user`, `alert`, `access-control`, `event`, `event-search`, `face-recognition-*`, `vehicle`, `sensor`, `climate`, `occupancy`, `lockdown-plan`, `policy`, etc.), check whether it targets a specific client:

- ✅ The command has `--partner-org "<name>"` — OK, it targets a specific client.
- ⚠️ No `--partner-org`, but `.claude/rhombus-partner.local.md` has `active_client:` — note in a 1-line reminder: *"Running against active client `<name>`. Use `--partner-org` to target a different org, or `/rhombus-client-switch` to change the active client."*
- ❌ No `--partner-org` AND no active client in `.claude/rhombus-partner.local.md` — the command will run against the partner's own management org (which usually has no cameras/devices). Suggest: *"This will run against your partner management org. To target a client, either append `--partner-org "<name>"` or run `/rhombus-client-switch <name>` first."*

Meta and partner-scoped commands (e.g., `rhombus partner get-partner-clients-v2`, `rhombus login`, `rhombus configure`, `rhombus context generate`) are exempt from this check — they're expected to run without a client scope.

## 2. Common mistakes

- Using GET-style flags (like `--method GET`) — all Rhombus API calls are POST.
- Using camelCase flags instead of kebab-case (e.g., `--cameraUuid` should be `--camera-uuid`).
- Passing JSON directly as a positional argument instead of via `--cli-input-json`.
- Missing `rhombus login` first — if the session has never seen a successful CLI call, hint that the user might need to authenticate.

## 3. Quality-of-life enhancements

- If the output will be raw JSON and might benefit from `jq` formatting, suggest piping through `jq`.
- If the user is running a list command with no filters, mention available filter flags (e.g., `alert recent` supports `--camera`, `--after`, `--max`).

Do NOT block the command. Only add helpful suggestions or warnings before allowing it to proceed.

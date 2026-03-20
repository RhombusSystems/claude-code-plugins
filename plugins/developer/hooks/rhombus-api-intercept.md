---
name: rhombus-api-intercept
event: PreToolUse
matcher: Bash
type: prompt
---

Inspect the bash command about to be executed. If it contains a `curl`, `wget`, or `fetch` call targeting any of these Rhombus API domains:

- `api2.rhombussystems.com`
- `api.rhombussystems.com`
- `media.rhombussystems.com`
- `auth.rhombussystems.com`

Then suggest using the `rhombus` CLI instead, which handles authentication, parameter formatting, and output parsing automatically.

For example, instead of:
```
curl -X POST https://api2.rhombussystems.com/api/camera/getMinimalCameraStateList \
  -H "x-auth-apikey: KEY" -H "x-auth-scheme: api-token"
```

Suggest:
```
rhombus camera get-minimal-camera-state-list
```

If the rhombus CLI equivalent is not obvious, suggest the user run `rhombus --help` or `rhombus <service-group> --help` to find the right command.

Do NOT block the command. Only add a helpful suggestion before allowing it to proceed.

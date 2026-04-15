---
description: Scaffold a new Rhombus integration project with a typed SDK, webhook receiver, and README. Composes the rhombus-sdk-codegen and rhombus-webhook-receiver skills.
argument-hint: "[language] [feature]"
---

Scaffold a starter repo for a Rhombus integration.

Parse `$ARGUMENTS` as `<language> [feature]`. Language is required; feature is free-form (e.g., "alert-to-slack", "lpr-dashboard", "clip-archiver").

Sequence:

1. Ask the user to confirm the project directory path (default: `./rhombus-<feature>`).
2. Invoke the `rhombus-sdk-codegen` skill with the language to generate a typed client in `<project>/sdk/`.
3. If the feature involves real-time events (keywords: webhook, alert, event, notify, slack, teams, pagerduty, trigger), invoke the `rhombus-webhook-receiver` skill to scaffold a listener in `<project>/webhook/`.
4. Write `<project>/README.md` with:
   - One-paragraph project summary
   - Prerequisites (`RHOMBUS_API_KEY`, any language-specific tooling)
   - Dev commands (install, run, test)
   - Link to the Rhombus docs MCP and this plugin's `rhombus-api` skill
5. Write `<project>/.env.example` with `RHOMBUS_API_KEY=` and any webhook secrets.
6. Initialize a git repo (`git init`) and do an initial commit with message `chore: scaffold <feature> integration`.

At the end, print a summary listing what was created and the next steps (e.g., "export RHOMBUS_API_KEY", "run the webhook in one terminal", "send a test event").

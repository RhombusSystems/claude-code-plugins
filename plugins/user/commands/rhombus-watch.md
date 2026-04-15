---
description: >-
  Open a Rhombus camera player in the browser. Side-effect — launches a browser
  window. Keep this slash-only so Claude doesn't trigger it autonomously.
argument-hint: "[camera]"
disable-model-invocation: true
---

Open the Rhombus live camera player in the user's browser.

Parse `$ARGUMENTS` as a camera name (fuzzy-matched) or UUID. If empty, ask the user which camera.

Run:

```bash
rhombus footage "$ARGUMENTS"
```

The CLI will open a browser tab to `console.rhombussystems.com` authenticated via a short-lived token (default 1-hour duration).

Optional modifiers the user might want:

- `--start "5m ago"` to jump to a specific time
- `--token-duration 7200` for a 2-hour session

If the user provides a time window in the arg (e.g., "front lobby 5m ago"), parse it and pass `--start`.

Do NOT attempt to render the stream inline — this is an explicit browser launch.

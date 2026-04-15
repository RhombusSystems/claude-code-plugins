---
description: Run `rhombus analyze` on an alert or a camera+time window and summarize the activity observed.
argument-hint: "[alert-uuid | camera time-range]"
---

Analyze Rhombus footage and summarize what happened.

Parse `$ARGUMENTS`:

- If it looks like a base64-style UUID, treat it as an alert UUID: `rhombus analyze alert "$UUID"`.
- Otherwise, parse as `<camera-name-or-location> <time-range>` and run:
  - `rhombus analyze footage "<camera>" --period "<time-range>"`
  - If the first token is a location rather than a camera, use `--location` instead.

Default to **activity frames only** (the CLI default). Add `--include-motion` if the user says "all motion" or "everything". Add `--fill` if they say "every few seconds" or "evenly spaced".

After the analyze call, produce a structured summary:

## Alert / Window
- Camera(s), location, time range

## Activity observed
- Chronological bullet list of what the frames show
- Note any people, vehicles, or objects of interest
- Flag anything that looks like an incident rather than routine activity

## Suggested next step
- `rhombus alert play <uuid>` to see the clip, or
- `/rhombus-watch <camera> <time>` for live / historical footage, or
- `rhombus stitch ...` if the user wants a multi-camera artifact

If LAN mode would be faster (user on-site), suggest appending `--lan`.

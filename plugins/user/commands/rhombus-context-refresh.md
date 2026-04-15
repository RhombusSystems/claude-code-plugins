---
description: >-
  Regenerate the local Rhombus deployment context (index.md + manifest.json +
  per-camera stills) in `~/.rhombus/context/<profile>/`. Side-effects —
  downloads media and writes to disk. Slash-only.
disable-model-invocation: true
---

Regenerate the cached Rhombus deployment context.

Run:

```bash
rhombus context generate --lan --concurrency 8
```

Drop `--lan` if the user indicates they're not on-site. Drop `--concurrency` if they don't want parallel downloads.

Before running, confirm with the user if:

- There's an existing context less than 6 hours old (`~/.rhombus/context/<profile>/index.md` mtime) — regenerating will replace it.
- They have more than 50 cameras — this will take a while and hit disk/network hard.

After the command finishes, report:

- Where the index was written (`~/.rhombus/context/<profile>/`)
- The number of locations and cameras captured
- Any cameras that failed to produce a still (with reasons)

Suggest follow-ups:

- `rhombus context location "<name>"` for a location summary
- `rhombus context camera "<name>"` for a fresh single-camera still

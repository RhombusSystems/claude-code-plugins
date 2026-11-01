#!/usr/bin/env bash
# Refresh the developer plugin's bundled OpenAPI spec from the live public API.
#
# Writes:
#   plugins/developer/skills/rhombus-api/references/rhombus-api.json       (spec, verbatim)
#   plugins/developer/skills/rhombus-api/references/rhombus-api.sync.json  (sync record read by the freshness hook)
#
# Usage: scripts/refresh-openapi-spec.sh [spec-url]
# After running: update the endpoint/line counts in SKILL.md and the READMEs, and bump
# plugins/developer/.claude-plugin/plugin.json "version" so installed copies update.

set -euo pipefail

SPEC_URL="${1:-https://api2.rhombussystems.com/api/openapi/public.json}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REF_DIR="${ROOT}/plugins/developer/skills/rhombus-api/references"
SPEC="${REF_DIR}/rhombus-api.json"
SYNC="${REF_DIR}/rhombus-api.sync.json"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

curl -fsS --retry 3 -o "$tmp" "$SPEC_URL"

python3 - "$tmp" "$SPEC" "$SYNC" "$SPEC_URL" <<'PY'
import datetime, hashlib, json, os, shutil, sys

new_path, spec_path, sync_path, url = sys.argv[1:5]
methods = {"get", "post", "put", "delete", "patch", "head", "options"}

def stats(path):
    with open(path) as f:
        doc = json.load(f)
    paths = doc.get("paths") or {}
    ops = sum(1 for v in paths.values() for m in v if m in methods)
    return doc, len(paths), ops, len((doc.get("components") or {}).get("schemas") or {})

doc, n_paths, n_ops, n_schemas = stats(new_path)
if not doc.get("openapi") or n_paths == 0:
    sys.exit("downloaded document is not an OpenAPI spec with paths; refusing to overwrite")

if os.path.exists(spec_path):
    old, old_paths, _, _ = stats(spec_path)
    added = sorted(set(doc["paths"]) - set(old["paths"]))
    removed = sorted(set(old["paths"]) - set(doc["paths"]))
    print(f"paths: {old_paths} -> {n_paths} (+{len(added)} / -{len(removed)})")
    for p in removed:
        print(f"  removed {p}")

shutil.copyfile(new_path, spec_path)
with open(spec_path, "rb") as f:
    sha = hashlib.sha256(f.read()).hexdigest()
with open(spec_path) as f:
    lines = sum(1 for _ in f)

record = {
    "syncedAt": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "source": url,
    "paths": n_paths,
    "operations": n_ops,
    "schemas": n_schemas,
    "lines": lines,
    "sha256": sha,
}
with open(sync_path, "w") as f:
    json.dump(record, f, indent=2)
    f.write("\n")
print(json.dumps(record, indent=2))
PY

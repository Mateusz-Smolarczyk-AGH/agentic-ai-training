#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="$ROOT/.opencode/opencode.json"

if [[ ! -f "$CFG" ]]; then
  echo "Missing $CFG — the workshop configuration is not in the repository." >&2
  exit 1
fi

python3 - "$CFG" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    cfg = json.load(handle)

agents = cfg.setdefault("agent", {})
agents["rewiever"] = {
    "description": "Investigates how something works in the repository. Read-only.",
    "mode": "subagent",
    "prompt": "Trace real code paths. Cite file:line. Distinguish what you verified from what you inferred. Answer the question you were asked; do not summarise the whole repository.",
    "permission": {
        "edit": "deny",
        "bash": {"*": "deny", "grep *": "allow", "ls *": "allow"},
    },
}

with open(path, "w", encoding="utf-8") as handle:
    json.dump(cfg, handle, indent=2, ensure_ascii=False)
    handle.write("\n")

print("Added subagent 'rewiever' to", path)
PY

echo "Config works immediately (no restart). Paste: 'Investigate the structure of this repository. Use the rewiever subagent.'"

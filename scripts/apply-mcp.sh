#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="$ROOT/.opencode/opencode.json"

if [[ ! -f "$CFG" ]]; then
  echo "Missing $CFG — the repo has no workshop configuration." >&2
  exit 1
fi

python3 - "$CFG" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    cfg = json.load(handle)

servers = cfg.setdefault("mcp", {})
servers["context7"] = {
    "type": "local",
    "enabled": True,
    "command": ["npx", "-y", "@upstash/context7-mcp"],
}

with open(path, "w", encoding="utf-8") as handle:
    json.dump(cfg, handle, indent=2, ensure_ascii=False)
    handle.write("\n")

print("Added MCP server 'context7' to", path)
PY

echo "The config works immediately (no restart). Ask the agent: 'Use context7 to check the FastAPI documentation.'"

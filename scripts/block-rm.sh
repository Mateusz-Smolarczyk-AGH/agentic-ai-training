#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="$ROOT/.opencode/opencode.json"

python3 - "$CFG" <<'PY'
import json
import os
import sys

path = sys.argv[1]
if not os.path.exists(path):
    print("Missing", path, "— no .opencode/opencode.json in the repository." )
    sys.exit(1)

with open(path, encoding="utf-8") as handle:
    cfg = json.load(handle)

bash = cfg.setdefault("permission", {}).setdefault("bash", {})
bash["rm -rf *"] = "deny"
bash["rm -fr *"] = "deny"

with open(path, "w", encoding="utf-8") as handle:
    json.dump(cfg, handle, indent=2, ensure_ascii=False)
    handle.write("\n")

print("Blocked rm -rf / rm -fr in", path)
PY

echo "The config works immediately (no restart). Repeat the injection demo — the agent should refuse."

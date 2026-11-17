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
    print("Missing", path, "— nothing to remove.")
    sys.exit(0)

with open(path, encoding="utf-8") as handle:
    cfg = json.load(handle)

bash = cfg.get("permission", {}).get("bash", {})
for key in ("rm -rf *", "rm -fr *"):
    bash.pop(key, None)

with open(path, "w", encoding="utf-8") as handle:
    json.dump(cfg, handle, indent=2, ensure_ascii=False)
    handle.write("\n")

print("Removed the rm block from", path)
PY

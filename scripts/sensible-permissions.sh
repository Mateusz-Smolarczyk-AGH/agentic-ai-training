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
    print("Missing", path, "— no .opencode/opencode.json in the repository.")
    sys.exit(1)

with open(path, encoding="utf-8") as handle:
    cfg = json.load(handle)

cfg["permission"] = {
    "read": "allow",
    "edit": "allow",
    "bash": {
        "*": "ask",
        "ls *": "allow",
        "cat *": "allow",
        "grep *": "allow",
        "find *": "allow",
        "git status *": "allow",
        "git diff *": "allow",
        "git log *": "allow",
        "python3 *": "allow",
    },
}

with open(path, "w", encoding="utf-8") as handle:
    json.dump(cfg, handle, indent=2, ensure_ascii=False)
    handle.write("\n")

print("Set a sensible set: bash '*': ask + allow-list (ls, cat, grep, find, git, python3).")
PY

echo "The config works immediately (no restart). The agent asks about everything outside the allow-list."

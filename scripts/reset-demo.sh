#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$ROOT/examples/demo_bypass"
if [[ ! -e "$ROOT/examples/demo_bypass/temp.txt" ]]; then
  : > "$ROOT/examples/demo_bypass/temp.txt"
  echo "Restored the examples/demo_bypass/ directory (permission-bypass demo)."
fi

if git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$ROOT" restore examples/ 2>/dev/null || git -C "$ROOT" checkout -- examples/ 2>/dev/null || true
  echo "Restored the examples/ directory from the repository state (git)."
else
  echo "This is not a git repository — I cannot restore examples/." >&2
  echo "Ask the instructor for a fresh copy of the repo." >&2
  exit 1
fi

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RAW="$ROOT/wiki/llm-wiki/raw"

usage() {
  echo "Usage: $0 [--reset]" >&2
  echo "  (no arguments)    prepare wiki/llm-wiki/raw/ and print the topic and prompt" >&2
  echo "  --reset           delete the contents of wiki/llm-wiki/raw/ except .gitkeep" >&2
}

case "${1:-}" in
  "")
    mkdir -p "$RAW"
    if [[ ! -e "$RAW/.gitkeep" ]]; then
      : > "$RAW/.gitkeep"
    fi
    cat <<'TXT'
Example topic: "LLM Wiki / agent-native wikis and knowledge bases for LLMs — SOTA 2026: capabilities, advantages and limitations, comparison with RAG (GraphRAG, agentic retrieval, long context, agent memory)".

The research prompt is in docs/16-agent-research.md — paste it into opencode (the `build` agent).

Expected result in wiki/llm-wiki/raw/ (4–8 files):
- research papers: original *.pdf (> 50 KB)
- blogs/documentation: cleaned *.md
TXT
    ;;
  --reset)
    mkdir -p "$RAW"
    find "$RAW" -mindepth 1 ! -path "$RAW/.gitkeep" -delete
    echo "Cleared wiki/llm-wiki/raw/ (kept .gitkeep)."
    ;;
  *)
    usage
    exit 2
    ;;
esac

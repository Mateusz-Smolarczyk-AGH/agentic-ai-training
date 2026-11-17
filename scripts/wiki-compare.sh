#!/usr/bin/env bash
# wiki-compare.sh "<question>" [model]
# Same question in two modes: without wiki (raw/) and with wiki (wiki/).
# Output: a summary table (time, calls, tokens, citation) plus the tool-call trace. Transcripts in .tmp-wiki/.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

usage() {
  cat <<'TXT'
Usage: bash scripts/wiki-compare.sh "<question>" [model]

  <question>      the question asked in both modes
  [model]         default: plgrid/Qwen/Qwen3.6-27B

Prints a summary table (time/calls/tokens/citation) and the tool-call trace for both modes.

Environment:
  TIMEOUT_RAW=N   seconds limit for the without-wiki mode (default 300)
  TIMEOUT_WIKI=N  seconds limit for the with-wiki mode (default 300)
TXT
}

if [[ $# -lt 1 ]]; then
  usage >&2
  exit 2
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

Q="$1"
MODEL="${2:-plgrid/Qwen/Qwen3.6-27B}"

OUT=".tmp-wiki"
mkdir -p "$OUT"
STAMP=$(date +%s)

FORCE=" Answer right away: do not ask for permission and do not describe a plan."
WIKI_Q="Using ONLY the pages under wiki/llm-wiki/wiki/, answer briefly (one sentence) and finish with the cited page.$FORCE Question: $Q"
RAW_Q="Answer using the files under wiki/llm-wiki/raw/ (you may also use the network). Do NOT use wiki/llm-wiki/wiki/. Finish by naming what you used as the source — a file or a URL — or write exactly: not found. Answer briefly (one sentence).$FORCE Question: $Q"

run() {
  local tag="$1" prompt="$2" limit="${3:-300}" t0 t1
  t0=$(date +%s)
  timeout "$limit" opencode run --auto --session "ses-wikicmp-${STAMP}-${tag}" \
    --model "$MODEL" --agent plan --format json "$prompt" > "$OUT/$tag.json" 2> "$OUT/$tag.err"
  t1=$(date +%s)
  echo $((t1 - t0)) > "$OUT/$tag.sec"
  if [[ ! -s "$OUT/$tag.json" ]]; then
    echo "WARNING: mode '$tag' returned nothing — check $OUT/$tag.err" >&2
  fi
}

run raw "$RAW_Q" "${TIMEOUT_RAW:-300}"
run wiki "$WIKI_Q" "${TIMEOUT_WIKI:-300}"

python3 - "$OUT" "$MODEL" "$Q" <<'PY'
import json
import os
import re
import sys

out, model, question = sys.argv[1], sys.argv[2], sys.argv[3]

ARG_KEYS = ("pattern", "path", "filePath", "file", "command", "url", "query")


def read_arm(tag):
    calls, texts, tokens = [], [], 0
    with open(os.path.join(out, f"{tag}.json"), encoding="utf-8", errors="replace") as handle:
        for line in handle:
            line = line.strip()
            if not line.startswith("{"):
                continue
            try:
                event = json.loads(line)
            except ValueError:
                continue
            kind = event.get("type")
            part = event.get("part") or {}
            if kind == "tool_use":
                state = part.get("state") or {}
                args = state.get("input") or {}
                where = next((args[key] for key in ARG_KEYS if args.get(key)), "")
                where = re.sub(r"\s+", " ", str(where)).strip()
                result = state.get("output")
                if state.get("status") != "completed":
                    summary = "ERROR"
                elif isinstance(result, str) and result.strip():
                    found = re.match(r"Found (\d+) matches", result)
                    rows = [row for row in result.splitlines() if row.strip()]
                    summary = f"{found.group(1)} matches" if found else f"{len(rows)} rows"
                else:
                    summary = "no output"
                calls.append((part.get("tool", "?"), where, summary))
            elif kind == "text":
                texts.append(part.get("text", ""))
            elif kind in ("step-finish", "step_finish"):
                usage = part.get("tokens") or {}
                tokens += int(usage.get("input", 0)) + int(usage.get("output", 0))
    seconds = open(os.path.join(out, f"{tag}.sec")).read().strip()
    final = re.sub(r"\s+", " ", "".join(texts)).strip()
    cited = sorted(set(re.findall(r"(?:raw|wiki)/[\w./-]+\.(?:md|pdf|html|txt)", final)))
    return seconds, calls, tokens, final, cited


arms = {tag: read_arm(tag) for tag in ("raw", "wiki")}

print(f"Model:    {model}")
print(f"Question: {question}")
print()
print(f"{'':<12}{'time':>7}{'calls':>7}{'tokens':>9}  citation")
for tag, label in (("raw", "no wiki"), ("wiki", "with wiki")):
    seconds, calls, tokens, _, cited = arms[tag]
    print(f"{label:<12}{seconds + ' s':>7}{len(calls):>7}{tokens:>9}  {', '.join(cited) or '-'}")
print()
for tag, label in (("raw", "NO WIKI"), ("wiki", "WITH WIKI")):
    seconds, calls, tokens, final, cited = arms[tag]
    print(f"[{label}] path to the answer — {len(calls)} tool calls:")
    for number, (tool, where, summary) in enumerate(calls, 1):
        step = re.sub(r"\s+", " ", f"{tool}  {where}").strip()[:88]
        print(f"  {number:>2}. {step:<90} {summary}")
    print(f"  -> answer: {final[:300]}")
    print()
PY

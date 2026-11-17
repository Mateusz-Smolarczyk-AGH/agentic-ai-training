#!/usr/bin/env bash
set -euo pipefail

BASE=$((40000 + $(id -u) % 20000))

probe() {
  python3 - "$BASE" <<'PY'
import random
import socket
import sys


def free(port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    with sock:
        try:
            sock.bind(("127.0.0.1", port))
        except OSError:
            return False
    return True


base = int(sys.argv[1])
if free(base):
    print(base)
    sys.exit(0)

sys.stderr.write(f"Port {base} is busy — looking for a free one in the 8000-9999 range.\n")
seen = {base}
for _ in range(50):
    port = random.randint(8000, 9999)
    if port in seen:
        continue
    seen.add(port)
    if free(port):
        print(port)
        sys.exit(0)
    sys.stderr.write(f"Port {port} is busy.\n")

sys.stderr.write("Found no free port in the 8000-9999 range after 50 attempts.\n")
sys.exit(1)
PY
}

if command -v python3 >/dev/null 2>&1; then
  if ! PORT="$(probe)"; then
    exit 1
  fi
else
  echo "No python3 — using the base port $BASE without checking." >&2
  PORT="$BASE"
fi

case "${1:-}" in
  ""|export)
    echo "export OPENCODE_PORT=$PORT"
    ;;
  print)
    echo "$PORT"
    ;;
  *)
    echo "Usage: $0 [export|print]" >&2
    exit 2
    ;;
esac

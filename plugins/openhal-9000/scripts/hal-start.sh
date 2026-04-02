#!/usr/bin/env bash
# OpenHAL 9000 — Start the TTS Docker server
set -euo pipefail

CONTAINER_NAME="openhal-9000-server"
MODEL_DIR="$HOME/.openhal-9000/models"
PORT="${OPENHAL_PORT:-9090}"
IMAGE="openhal-9000-piper"

# Already running?
if docker ps --filter name="$CONTAINER_NAME" --format '{{.Names}}' 2>/dev/null | grep -q "$CONTAINER_NAME"; then
  exit 0
fi

# Remove stopped container
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

# Check port availability
if lsof -i :"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "ERROR: Port $PORT is already in use." >&2
  echo "Set OPENHAL_PORT to use a different port." >&2
  exit 1
fi

docker run -d --name "$CONTAINER_NAME" \
  --platform linux/arm64 \
  -p "127.0.0.1:${PORT}:9090" \
  -v "$MODEL_DIR:/models" \
  "$IMAGE" >/dev/null 2>&1

# Wait for server ready (up to 5 seconds)
for i in $(seq 1 10); do
  if python3 -c "import socket; s=socket.socket(); s.settimeout(0.5); s.connect(('localhost',${PORT})); s.close()" 2>/dev/null; then
    exit 0
  fi
  sleep 0.5
done

echo "WARNING: Server started but may not be ready." >&2
exit 0

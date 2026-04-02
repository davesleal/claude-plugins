#!/usr/bin/env bash
# OpenHAL 9000 — Health check
PORT="${OPENHAL_PORT:-9090}"
DATA_DIR="$HOME/.openhal-9000"

echo "=== OpenHAL 9000 Status ==="

# Docker
if command -v docker >/dev/null 2>&1; then
  echo "Docker: installed"
  if docker ps --filter name=openhal-9000-server --format '{{.Names}}' | grep -q openhal-9000-server; then
    echo "Server: running"
  else
    echo "Server: stopped"
  fi
else
  echo "Docker: NOT INSTALLED"
fi

# Model
if [ -f "$DATA_DIR/models/hal.onnx" ] || [ -L "$DATA_DIR/models/hal.onnx" ]; then
  TARGET="$DATA_DIR/models/hal.onnx"
  [ -L "$TARGET" ] && TARGET="$(readlink "$TARGET")"
  SIZE=$(du -h "$TARGET" 2>/dev/null | cut -f1)
  echo "Model: present ($SIZE)"
else
  echo "Model: NOT FOUND"
fi

# Port
if lsof -i :"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Port $PORT: listening"
else
  echo "Port $PORT: not listening"
fi

# Voice toggle
if [ -f "$DATA_DIR/voice-enabled" ]; then
  echo "Voice: enabled"
else
  echo "Voice: disabled"
fi

# HAL mode
if [ -f "$DATA_DIR/hal-mode" ]; then
  echo "HAL Mode: active"
else
  echo "HAL Mode: inactive"
fi

# ffmpeg
if command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg: installed"
else
  echo "ffmpeg: NOT INSTALLED"
fi

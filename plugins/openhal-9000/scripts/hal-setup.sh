#!/usr/bin/env bash
# OpenHAL 9000 — First-run bootstrap
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$HOME/.openhal-9000"
MODEL_DIR="$DATA_DIR/models"
MODEL_FILE="$MODEL_DIR/hal.onnx"
MODEL_JSON="$MODEL_DIR/hal.onnx.json"
IMAGE="openhal-9000-piper"

# Known-good checksums
MODEL_SHA256="0e08c82dc027bc72b8b839324801709e205e8c201ccae171b92e37a664d94361"

# HuggingFace URLs
HF_BASE="https://huggingface.co/campwill/HAL-9000-Piper-TTS/resolve/main"
MODEL_URL="${HF_BASE}/hal.onnx"
CONFIG_URL="${HF_BASE}/hal.onnx.json"

# --- Check prerequisites ---
if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker is required. Install OrbStack (https://orbstack.dev) or Docker Desktop." >&2
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ERROR: ffmpeg is required. Install with: brew install ffmpeg" >&2
  exit 1
fi

# --- Create data directory ---
mkdir -p "$MODEL_DIR"
chmod 700 "$DATA_DIR"

# --- Download or link model ---
if [ ! -f "$MODEL_FILE" ] && [ ! -L "$MODEL_FILE" ]; then
  # Check if user already has the model from a previous manual install
  if [ -f "$HOME/.piper/models/hal.onnx" ]; then
    echo "Found existing HAL model in ~/.piper/models/. Linking it."
    ln -sf "$HOME/.piper/models/hal.onnx" "$MODEL_FILE"
    ln -sf "$HOME/.piper/models/hal.onnx.json" "$MODEL_JSON"
  else
    echo "Downloading HAL 9000 voice model (~63MB)..."
    curl -fL --progress-bar -o "$MODEL_FILE" "$MODEL_URL"
    curl -fL --progress-bar -o "$MODEL_JSON" "$CONFIG_URL"
  fi
fi

# --- Verify checksum ---
if command -v shasum >/dev/null 2>&1; then
  TARGET="$MODEL_FILE"
  if [ -L "$MODEL_FILE" ]; then
    TARGET="$(readlink "$MODEL_FILE")"
  fi
  ACTUAL_SHA=$(shasum -a 256 "$TARGET" | awk '{print $1}')
  if [ "$ACTUAL_SHA" != "$MODEL_SHA256" ]; then
    echo "WARNING: Model checksum mismatch. File may be corrupted or updated." >&2
    echo "Expected: $MODEL_SHA256" >&2
    echo "Got:      $ACTUAL_SHA" >&2
  fi
fi

# --- Build Docker image ---
echo "Building OpenHAL 9000 Docker image..."
docker build -t "$IMAGE" "$PLUGIN_ROOT" 2>&1 | tail -3

# --- Create sentinel files ---
touch "$DATA_DIR/voice-enabled"
touch "$DATA_DIR/initialized"

echo "OpenHAL 9000 setup complete."

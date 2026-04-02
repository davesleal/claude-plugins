#!/usr/bin/env bash
# OpenHAL 9000 — Status line indicator
if [ -f "$HOME/.openhal-9000/hal-mode" ]; then
  printf '\033[31m●\033[0m OpenHAL 9000'
fi

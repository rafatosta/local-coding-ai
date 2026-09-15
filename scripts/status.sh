#!/usr/bin/env bash
set -euo pipefail
CONTAINER="${OLLAMA_CONTAINER:-local-coding-ai}"
PORT="${OLLAMA_PORT:-11434}"

echo "== local-coding-ai =="
printf "Podman: "
command -v podman >/dev/null 2>&1 && podman --version || echo "não encontrado"

if podman container exists "$CONTAINER" 2>/dev/null; then
  RUNNING="$(podman inspect -f '{{.State.Running}}' "$CONTAINER")"
  echo "Container: $CONTAINER (running=$RUNNING)"
  if [ "$RUNNING" = "true" ]; then
    echo "API: http://127.0.0.1:${PORT}"
    echo
    echo "Modelos:"
    podman exec "$CONTAINER" ollama list || true
    echo
    echo "Processos Ollama:"
    podman exec "$CONTAINER" ollama ps || true
  fi
else
  echo "Container: não criado"
fi

if command -v nvidia-smi >/dev/null 2>&1; then
  echo
  echo "GPU host:"
  nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader 2>/dev/null || echo "nvidia-smi instalado, mas a GPU não respondeu."
fi

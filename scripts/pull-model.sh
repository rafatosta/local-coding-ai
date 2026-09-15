#!/usr/bin/env bash
set -euo pipefail
CONTAINER="${OLLAMA_CONTAINER:-local-coding-ai}"
MODEL="${OLLAMA_MODEL:-qwen2.5-coder:7b}"

if ! podman container exists "$CONTAINER" || [ "$(podman inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null)" != "true" ]; then
  echo "Ollama não está em execução. Execute ./scripts/start.sh primeiro." >&2
  exit 1
fi

echo "Baixando modelo: $MODEL"
podman exec -it "$CONTAINER" ollama pull "$MODEL"

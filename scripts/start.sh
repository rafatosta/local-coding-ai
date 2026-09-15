#!/usr/bin/env bash
set -euo pipefail

CONTAINER="${OLLAMA_CONTAINER:-local-coding-ai}"
PORT="${OLLAMA_PORT:-11434}"
GPU_MODE="${OLLAMA_GPU:-auto}"
IMAGE="localhost/local-coding-ai:latest"
VOLUME="local-coding-ai-models"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

command -v podman >/dev/null 2>&1 || { echo "Erro: Podman não encontrado." >&2; exit 1; }

if podman container exists "$CONTAINER"; then
  if [ "$(podman inspect -f '{{.State.Running}}' "$CONTAINER")" = "true" ]; then
    echo "Ollama já está em execução: http://127.0.0.1:${PORT}"
    exit 0
  fi
  podman rm "$CONTAINER" >/dev/null
fi

podman volume exists "$VOLUME" || podman volume create "$VOLUME" >/dev/null

podman build -t "$IMAGE" -f "$ROOT_DIR/Containerfile" "$ROOT_DIR"

GPU_ARGS=()
if [ "$GPU_MODE" != "cpu" ]; then
  if podman run --rm --device nvidia.com/gpu=all docker.io/library/alpine:latest true >/dev/null 2>&1; then
    GPU_ARGS=(--device nvidia.com/gpu=all)
    echo "GPU NVIDIA CDI detectada. Aceleração habilitada."
  elif [ "$GPU_MODE" = "nvidia" ]; then
    echo "Erro: OLLAMA_GPU=nvidia solicitado, mas o dispositivo CDI nvidia.com/gpu=all não está disponível." >&2
    echo "Execute ./scripts/check-env.sh para diagnóstico." >&2
    exit 1
  else
    echo "GPU NVIDIA CDI não disponível. Iniciando em modo CPU."
  fi
fi

podman run -d \
  --name "$CONTAINER" \
  --replace \
  --restart unless-stopped \
  -p "127.0.0.1:${PORT}:11434" \
  -e OLLAMA_HOST=0.0.0.0:11434 \
  -v "${VOLUME}:/root/.ollama" \
  "${GPU_ARGS[@]}" \
  "$IMAGE" >/dev/null

echo "Ollama iniciado: http://127.0.0.1:${PORT}"

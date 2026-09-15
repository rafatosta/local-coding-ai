#!/usr/bin/env bash
set -euo pipefail
CONTAINER="${OLLAMA_CONTAINER:-local-coding-ai}"
if podman container exists "$CONTAINER"; then
  podman stop "$CONTAINER"
else
  echo "Container $CONTAINER não existe."
fi

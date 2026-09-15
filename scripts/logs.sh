#!/usr/bin/env bash
set -euo pipefail
CONTAINER="${OLLAMA_CONTAINER:-local-coding-ai}"
podman logs -f "$CONTAINER"

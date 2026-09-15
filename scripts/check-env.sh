#!/usr/bin/env bash
set -u

ok() { printf "%-24s OK (%s)\n" "$1" "$2"; }
warn() { printf "%-24s AVISO (%s)\n" "$1" "$2"; }
fail() { printf "%-24s AUSENTE (%s)\n" "$1" "$2"; }

echo "== Diagnóstico local-coding-ai =="

if command -v podman >/dev/null 2>&1; then
  ok "Podman" "$(podman --version)"
else
  fail "Podman" "instale o Podman antes de continuar"
  exit 1
fi

if command -v nvidia-smi >/dev/null 2>&1; then
  GPU="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -n1)"
  if [ -n "$GPU" ]; then ok "NVIDIA host" "$GPU"; else warn "NVIDIA host" "nvidia-smi não conseguiu consultar a GPU"; fi
else
  warn "NVIDIA host" "nvidia-smi não encontrado; CPU continua suportada"
fi

if podman run --rm --device nvidia.com/gpu=all docker.io/library/alpine:latest true >/dev/null 2>&1; then
  ok "NVIDIA CDI" "nvidia.com/gpu=all disponível"
else
  warn "NVIDIA CDI" "indisponível; use CPU ou configure NVIDIA Container Toolkit/CDI"
fi

if podman volume exists local-coding-ai-models >/dev/null 2>&1; then
  ok "Volume de modelos" "local-coding-ai-models"
else
  warn "Volume de modelos" "será criado no primeiro start"
fi

echo
echo "Diagnóstico concluído. Execute ./scripts/start.sh para iniciar."

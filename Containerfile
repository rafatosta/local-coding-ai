ARG OLLAMA_IMAGE=ollama/ollama:latest
FROM ${OLLAMA_IMAGE}

EXPOSE 11434
VOLUME ["/root/.ollama"]

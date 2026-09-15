# Instalação

## Requisitos do host

Obrigatório:

- Linux
- Podman
- Git

Opcional para aceleração NVIDIA:

- driver NVIDIA funcional no host;
- NVIDIA Container Toolkit com CDI configurado para Podman.

O projeto não instala nem altera driver de vídeo, kernel ou bootloader.

## Preparação

```bash
git clone https://github.com/rafatosta/local-coding-ai.git
cd local-coding-ai
chmod +x scripts/*.sh
./scripts/check-env.sh
```

## Inicialização

```bash
./scripts/start.sh
./scripts/pull-model.sh
./scripts/status.sh
```

O serviço fica disponível em `http://127.0.0.1:11434`.

## Configuração

Use variáveis de ambiente para sobrescrever os padrões:

```bash
OLLAMA_PORT=11435 OLLAMA_GPU=cpu ./scripts/start.sh
OLLAMA_MODEL=qwen2.5-coder:7b ./scripts/pull-model.sh
```

Não é necessário copiar `env.example`; ele documenta as opções disponíveis.

## Atualização

Pare o container e execute novamente o start. O `Containerfile` usa a imagem configurada em `OLLAMA_IMAGE` durante o build e os modelos permanecem no volume persistente.

```bash
./scripts/stop.sh
./scripts/start.sh
```

## Remoção

Remover o container não remove os modelos. Para apagar deliberadamente todos os pesos baixados:

```bash
podman volume rm local-coding-ai-models
```

Esse comando é destrutivo e exige novo download dos modelos.
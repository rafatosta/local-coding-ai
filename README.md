# local-coding-ai

Ambiente local, reutilizável e independente de projeto para executar modelos de IA para programação com **Ollama + Podman**.

O objetivo é manter o runtime de IA separado dos repositórios de aplicação. VS Code, terminal ou qualquer cliente compatível com a API do Ollama pode usar o serviço em `http://localhost:11434`.

## Princípios

- Ollama executado em container Podman.
- Modelos armazenados em volume persistente, nunca no Git.
- GPU NVIDIA opcional; CPU continua disponível como fallback.
- Nenhum acoplamento com RSCFlow, ZapZap ou outro projeto.
- Configuração reproduzível em distribuições Linux com Podman.

## Início rápido

```bash
./scripts/check-env.sh
./scripts/start.sh
./scripts/pull-model.sh
./scripts/status.sh
```

O modelo padrão pode ser alterado pela variável `OLLAMA_MODEL`:

```bash
OLLAMA_MODEL=qwen2.5-coder:7b ./scripts/pull-model.sh
```

## Comandos

```bash
./scripts/start.sh          # inicia Ollama
./scripts/stop.sh           # encerra o container
./scripts/status.sh         # verifica container, API, GPU e modelos
./scripts/logs.sh           # acompanha logs
./scripts/pull-model.sh     # baixa o modelo configurado
./scripts/check-env.sh      # diagnostica host e suporte à GPU
```

Para solicitar explicitamente GPU NVIDIA:

```bash
OLLAMA_GPU=nvidia ./scripts/start.sh
```

O modo padrão (`OLLAMA_GPU=auto`) usa NVIDIA quando o dispositivo CDI `nvidia.com/gpu=all` estiver disponível; caso contrário inicia em CPU.

## VS Code

O Ollama expõe sua API apenas no host local por padrão. Extensões/agentes compatíveis podem apontar para:

```text
http://localhost:11434
```

Consulte [`docs/VSCODE.md`](docs/VSCODE.md).

## Hardware

Os pesos permanecem no volume `local-coding-ai-models`. Para máquinas com aproximadamente 16 GB de RAM e GPU NVIDIA de 6 GB, comece com um modelo coder 7B/8B quantizado e contexto moderado. Modelos maiores podem funcionar com offload para RAM/CPU, mas reduzem significativamente a folga para IDE, navegador e servidores de desenvolvimento.

Consulte [`docs/GPU.md`](docs/GPU.md) e [`docs/MODELS.md`](docs/MODELS.md).

## Estrutura

```text
.
├── Containerfile
├── compose.yaml
├── config/
│   └── env.example
├── docs/
│   ├── GPU.md
│   ├── INSTALL.md
│   ├── MODELS.md
│   └── VSCODE.md
└── scripts/
    ├── check-env.sh
    ├── logs.sh
    ├── pull-model.sh
    ├── start.sh
    ├── status.sh
    └── stop.sh
```

## Segurança

A porta `11434` é publicada em `127.0.0.1`, não em todas as interfaces de rede. Não exponha a API do Ollama diretamente à Internet.
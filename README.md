# local-coding-ai

Infraestrutura local e reutilizável para executar modelos de inteligência artificial com **Ollama + Podman**.

O projeto fornece um ambiente containerizado para disponibilizar modelos locais por meio da API do Ollama. Clientes compatíveis — como IDEs, extensões, agentes, aplicações ou o próprio terminal — podem consumir o serviço em `http://localhost:11434`.

O `local-coding-ai` cuida da infraestrutura de execução. A capacidade, o desempenho e a adequação a uma determinada tarefa dependem do modelo selecionado, dos recursos de hardware disponíveis e do cliente utilizado.

## Características

- Ollama executado em container Podman.
- Modelos armazenados em volume persistente, fora do Git.
- GPU NVIDIA opcional com suporte a CDI.
- Execução em CPU disponível como fallback.
- Diagnóstico do ambiente e da disponibilidade de GPU.
- API acessível apenas pelo host local por padrão.
- Configuração reutilizável e reproduzível em distribuições Linux com Podman.
- Independência em relação às aplicações e aos clientes que consomem a API.

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

## Clientes

O Ollama expõe sua API apenas no host local por padrão:

```text
http://localhost:11434
```

Qualquer cliente compatível com a API do Ollama pode utilizar essa infraestrutura. Para integração com VS Code, consulte [`docs/VSCODE.md`](docs/VSCODE.md).

## Hardware e modelos

Os modelos permanecem no volume persistente `local-coding-ai-models`. O tamanho e a quantização do modelo, o contexto utilizado e a disponibilidade de CPU, RAM e GPU determinam o desempenho e os recursos que podem ser executados localmente.

A escolha do modelo deve considerar o hardware disponível e o tipo de tarefa pretendida. O projeto não impõe um modelo específico.

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
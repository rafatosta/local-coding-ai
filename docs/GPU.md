# GPU

## Responsabilidades

O container contém o runtime Ollama. O host continua responsável pelo driver da GPU e pela integração do dispositivo com containers.

Isso mantém a imagem reutilizável sem tentar encapsular componentes ligados ao kernel.

## NVIDIA + Podman

O projeto usa CDI (`nvidia.com/gpu=all`) quando disponível. O script `check-env.sh` testa essa capacidade e `start.sh` possui três modos:

- `OLLAMA_GPU=auto`: tenta NVIDIA e usa CPU como fallback;
- `OLLAMA_GPU=nvidia`: exige NVIDIA CDI e falha explicitamente se indisponível;
- `OLLAMA_GPU=cpu`: não tenta expor GPU ao container.

Exemplo:

```bash
OLLAMA_GPU=nvidia ./scripts/start.sh
```

### SELinux

Em hosts com SELinux, como Fedora, o dispositivo NVIDIA CDI pode estar corretamente configurado e ainda assim o NVML falhar dentro do container com `Failed to initialize NVML: Insufficient Permissions`.

Quando a NVIDIA CDI é selecionada, `start.sh` aplica ao container Ollama:

```text
--device nvidia.com/gpu=all
--security-opt=label=disable
```

A opção `label=disable` desabilita a rotulagem SELinux somente para esse container. Ela não desabilita o SELinux no host. O modo CPU não recebe essa exceção.

## Verificação

```bash
./scripts/check-env.sh
./scripts/status.sh
```

No host, `nvidia-smi` deve conseguir consultar a GPU para que a aceleração NVIDIA seja considerada saudável.

Para confirmar o acesso pelo container NVIDIA:

```bash
podman exec -it local-coding-ai nvidia-smi
```

Após uma inferência, `./scripts/status.sh` permite verificar a coluna `PROCESSOR` do Ollama e confirmar se o modelo está usando GPU ou uma combinação de CPU/GPU.

## Portabilidade

O mesmo repositório pode ser usado em outra distribuição. O que pode mudar entre hosts é a instalação/configuração do driver NVIDIA e do suporte CDI. Essa parte não deve ser automatizada pelo repositório porque depende da distribuição, versão do driver e kernel.
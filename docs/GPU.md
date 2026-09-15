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

## Dependências NVIDIA no Fedora

O driver NVIDIA precisa estar instalado e funcionando no host antes da configuração do acesso pelo Podman. O projeto não instala o driver automaticamente, pois essa etapa depende da distribuição, kernel e forma de instalação adotada pelo usuário.

Em Fedora com os pacotes NVIDIA provenientes do RPM Fusion, além do driver gráfico, o utilitário `nvidia-smi` é fornecido pelo pacote:

```bash
sudo dnf install xorg-x11-drv-nvidia-cuda
```

A instalação típica observada no ambiente de validação inclui os seguintes componentes do driver NVIDIA:

```text
akmod-nvidia
xorg-x11-drv-nvidia
xorg-x11-drv-nvidia-libs
xorg-x11-drv-nvidia-cuda-libs
xorg-x11-drv-nvidia-cuda
xorg-x11-drv-nvidia-power
```

Nem todos precisam ser instalados manualmente: parte deles pode ser resolvida como dependência pelo gerenciador de pacotes. O ponto importante para o diagnóstico deste projeto é que `nvidia-smi` esteja disponível e consiga consultar a GPU no host.

Teste:

```bash
nvidia-smi
```

### NVIDIA Container Toolkit

O acesso da GPU NVIDIA a containers Podman usa o NVIDIA Container Toolkit e CDI. O pacote necessário no host é:

```text
nvidia-container-toolkit
```

Se ele ainda não estiver disponível nos repositórios configurados no Fedora, adicione primeiro o repositório oficial do NVIDIA Container Toolkit conforme a documentação da NVIDIA e então instale:

```bash
sudo dnf install nvidia-container-toolkit
```

Confirme a instalação:

```bash
nvidia-ctk --version
```

Depois gere a especificação CDI:

```bash
sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
```

E confirme os dispositivos disponíveis:

```bash
nvidia-ctk cdi list
```

Uma configuração funcional deve disponibilizar pelo menos um dispositivo NVIDIA e, para os scripts deste projeto, a entrada:

```text
nvidia.com/gpu=all
```

Depois disso, execute:

```bash
./scripts/check-env.sh
```

O diagnóstico esperado é semelhante a:

```text
NVIDIA host              OK
NVIDIA CDI               OK (nvidia.com/gpu=all disponível)
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
# VS Code

O ambiente não depende de uma extensão específica para consumir o Ollama. Qualquer cliente compatível pode usar a API local:

```text
http://localhost:11434
```

## Gerenciar o container pelo VS Code

Para o uso cotidiano, o repositório recomenda a extensão oficial **Container Tools** da Microsoft (`ms-azuretools.vscode-containers`). Ela suporta Podman e permite administrar containers diretamente pelo VS Code.

Ao abrir este repositório, o VS Code pode sugerir automaticamente a instalação da extensão por meio de `.vscode/extensions.json`. O workspace também configura o Container Tools para usar Podman.

Fluxo esperado:

```text
VS Code
  -> Containers
     -> local-coding-ai
        -> Start / Stop / Restart / Logs / Inspect
```

Depois que o container tiver sido criado pelo menos uma vez, não é necessário abrir este repositório sempre que quiser iniciar ou parar o Ollama. A visualização de containers do VS Code trabalha com o runtime Podman da máquina e pode ser usada enquanto outro projeto, como RSCFlow ou ZapZap, estiver aberto.

Os scripts do repositório continuam sendo a interface de referência para instalação, diagnóstico e automação. A extensão é apenas uma interface gráfica conveniente sobre o runtime.

## Primeira criação

Na primeira utilização, valide o ambiente e crie/inicie o serviço:

```bash
./scripts/check-env.sh
./scripts/start.sh
./scripts/pull-model.sh
./scripts/status.sh
```

A partir daí, o container `local-coding-ai` pode ser iniciado e parado diretamente pela visualização **Containers** do VS Code.

## Continue

O Continue é uma opção de cliente para VS Code com suporte a modelos locais/Ollama. Instale a extensão pelo marketplace oficial e configure o provider Ollama apontando para a API local.

A responsabilidade fica separada:

```text
workspace atual -> extensão/agente -> Ollama :11434 -> modelo local
```

Assim, o repositório `local-coding-ai` não precisa conhecer o RSCFlow, ZapZap ou qualquer outro projeto. O cliente/editor fornece ao modelo o contexto do workspace aberto.

## Diagnóstico

Se o Ollama não aparecer ou não responder, confirme primeiro o runtime:

```bash
./scripts/status.sh
```

Teste a API diretamente:

```bash
curl http://127.0.0.1:11434/api/tags
```

Isso separa problemas do runtime de problemas do cliente ou da extensão do VS Code.

## Segurança

Por padrão o projeto publica a API somente em `127.0.0.1`. Não altere para `0.0.0.0` no host sem avaliar autenticação, firewall e exposição da rede.

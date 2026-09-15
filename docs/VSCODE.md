# VS Code

O ambiente não depende de uma extensão específica. Qualquer cliente que suporte Ollama pode usar a API local:

```text
http://localhost:11434
```

## Continue

O Continue é uma opção de cliente para VS Code com suporte a modelos locais/Ollama. Instale a extensão pelo marketplace oficial e configure o provider Ollama apontando para a API local.

A responsabilidade fica separada:

```text
workspace atual -> extensão/agente -> Ollama :11434 -> modelo local
```

Assim, o repositório `local-coding-ai` não precisa conhecer o RSCFlow, ZapZap ou qualquer outro projeto. O cliente/editor fornece ao modelo o contexto do workspace aberto.

## Antes de configurar o editor

Confirme primeiro o runtime:

```bash
./scripts/start.sh
./scripts/pull-model.sh
./scripts/status.sh
```

Teste a API diretamente:

```bash
curl http://127.0.0.1:11434/api/tags
```

Somente depois configure a extensão. Isso separa problemas do runtime de problemas do cliente VS Code.

## Segurança

Por padrão o projeto publica a API somente em `127.0.0.1`. Não altere para `0.0.0.0` no host sem avaliar autenticação, firewall e exposição da rede.
# Modelos

O repositório não versiona pesos. Modelos são obtidos pelo Ollama e persistidos no volume `local-coding-ai-models`.

## Modelo inicial

O padrão atual é:

```text
qwen2.5-coder:7b
```

Ele foi escolhido como ponto de partida conservador para desenvolvimento local em hardware com recursos limitados. A escolha deve ser revisada por benchmark real, não apenas pelo número de parâmetros.

## Alterar modelo

```bash
OLLAMA_MODEL=<modelo:tag> ./scripts/pull-model.sh
```

Depois, configure o mesmo identificador no cliente VS Code/agente utilizado.

## Critérios para avaliar um coder

Para este ambiente, compare pelo menos:

1. aderência às instruções do repositório;
2. capacidade de modificar múltiplos arquivos sem alterações desnecessárias;
3. qualidade de React/TypeScript, Python e demais stacks realmente usadas;
4. geração e correção de testes;
5. tempo até a resposta;
6. RAM e VRAM utilizadas;
7. tamanho de contexto necessário para tarefas reais.

## Quantização e contexto

Modelos Q4 normalmente oferecem um bom compromisso para hardware limitado. O consumo durante inferência é maior que o arquivo de pesos porque também há cache KV e overhead do runtime. Aumentar o contexto aumenta o consumo de memória.

Comece com 7B/8B e contexto moderado. Suba para modelos maiores apenas quando tarefas reais demonstrarem ganho suficiente para justificar o custo.
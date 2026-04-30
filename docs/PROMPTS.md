# Prompts de Manutenção

Cada seção abaixo contém um **prompt completo, auto-contido e colável** numa nova sessão Claude (ou outro agente). Não dependem do contexto desta conversa — paths são absolutos, requisitos explícitos, critério de pronto incluído.

Achados de origem documentados em [`REVIEW.md`](REVIEW.md).

---

## 1. Consertar timer Claude

```
O script ~/.dotfiles/scripts/claude_timer.sh tem dois bugs:

1. Após >5h sem reset, o display congela em "00h00m" porque
   /tmp/claude_start fica stale e REMAINING é fixado em 0
   (linha 27).
2. A porcentagem usada (%) só aparece quando /tmp/claude_usage
   é populado manualmente via `claude-set`, então na prática
   nunca aparece.

Quero que você:

(a) Adicione auto-detecção de stale: se ELAPSED > TOTAL,
    invalide /tmp/claude_start e recomece a contagem do zero
    automaticamente, em vez de mostrar 00h00m.
(b) Verifique se o binário `ccusage` está disponível
    (https://github.com/ryoppippi/ccusage) e, se sim, use ele
    para obter % real do dashboard. Caso contrário, mantenha
    o fallback manual via /tmp/claude_usage.
(c) Mova /tmp/claude_start e /tmp/claude_usage para
    "${XDG_RUNTIME_DIR:-/tmp}/claude_start" (mesmo para usage),
    com fallback para /tmp.
(d) Atualize ~/.dotfiles/scripts/claude_set.sh para usar o
    mesmo path resolvido.
(e) Remova a seção "⚠️ Limitações conhecidas" do
    ~/.dotfiles/README.md (a partir da linha que começa com
    "### ⚠️ Limitações conhecidas" até o "---" seguinte).

Critério de pronto:
- Rodar `~/.dotfiles/scripts/claude_timer.sh` numa sessão
  recém-aberta mostra tempo crescente, não 00h00m.
- Se ccusage existir, % aparece sem `claude-set` manual.
- Sem ccusage, comportamento atual é preservado.
- Status do tmux atualiza dentro de 60s (status-interval).

Não mexa em link/.tmux.conf.
```

---

## 2. Shellcheck no pre-push

```
Quero adicionar lint automatizado de shell scripts no
~/.dotfiles antes de cada `git push`. Restrições importantes:

- Lint SÓ os arquivos shell modificados no push (não o repo
  todo — são ~1.277 arquivos).
- Hook deve ser opt-in via comando explícito, não habilitado
  automaticamente em todo clone.
- Se shellcheck não estiver instalado, exibir aviso e seguir
  (não bloquear o push).
- Se houver erros de shellcheck, abortar o push com saída
  clara mostrando arquivo e linha.

Implemente:

1. Adicione `shellcheck` ao
   ~/.dotfiles/init/30_osx_homebrew_recipes.sh.
2. Crie ~/.dotfiles/.githooks/pre-push:
   - Lê `git diff --name-only @{u}..HEAD` (com fallback se
     não houver upstream).
   - Filtra arquivos com extensão .sh ou cujo shebang seja
     shell (bash/sh/zsh).
   - Roda `shellcheck -x` em cada um.
   - Output formatado: `✓ pass` ou `✗ N errors`.
3. Crie ~/.dotfiles/bin/dotfiles-install-hooks que executa
   `git config core.hooksPath .githooks` no repo dotfiles
   (apenas local — nunca --global).
4. Documente no README a invocação:
     ./bin/dotfiles-install-hooks
5. Adicione 1 commit por mudança lógica (recipes, hook,
   installer, docs). Mensagens em pt-BR.

Critério de pronto:
- `git push` num branch com erro shellcheck conhecido falha.
- `git push` num branch limpo passa.
- Sem hooks instalados (estado inicial), push funciona normal.
```

---

## 3. Substituir `/Users/sierra` hardcoded por `$HOME`

```
Em ~/.dotfiles/init/20_osx_homebrew.sh, linhas 10-11, há
caminhos hardcoded para /Users/sierra/.bash_profile que
quebram o repo em qualquer máquina onde o usuário não seja
"sierra".

Substitua por "$HOME/.bash_profile". Verifique também se
existem outras ocorrências de /Users/sierra no repo (excluindo
docs/, .git/ e submódulos) com:

  grep -rn "/Users/sierra" ~/.dotfiles \
    --exclude-dir=.git --exclude-dir=docs \
    --exclude-dir=.oh-my-zsh --exclude-dir=tpm

Conserte cada uma. Faça 1 commit:

  fix: usar \$HOME em vez de path hardcoded /Users/sierra

Critério de pronto: o grep acima retorna 0 linhas (excluindo
binários e o próprio CHANGELOG/REVIEW se mencionarem o path
como exemplo).
```

---

## 4. Auditar `eval` em `bin/dotfiles`

```
~/.dotfiles/bin/dotfiles tem 9 chamadas a `eval` (linhas
232, 233, 259, 260, 268, 284, 285, 378) usadas para
referência indireta a arrays bash. Quero uma auditoria
caso-a-caso:

Para cada ocorrência:
1. Mostre o contexto (3 linhas antes/depois).
2. Identifique se a entrada do `eval` pode em algum caminho
   de execução vir de variável controlada pelo usuário
   (argumentos de CLI, conteúdo de arquivos lidos, env vars,
   etc.).
3. Para casos onde só o nome de array vem de código interno
   confiável: marque como "OK, hardened" e proponha um
   comentário curto inline para sinalizar.
4. Para casos onde há qualquer caminho de injeção: proponha
   substituição por `${!arr@}` / `${!arr[@]}` (referência
   indireta nativa do bash 4.3+) e mostre o diff.

Não aplique nenhum patch automaticamente — quero ler a
análise primeiro. Saída em formato markdown, uma seção por
ocorrência.

Não confunda com bin/rename:244,302 (esse é Perl, `eval` em
Perl é exception handling, não shell eval — pular).
```

---

## 5. Triagem de TODO/FIXME

```
Em ~/.dotfiles existem 8 marcadores TODO/FIXME/XXX em código
ativo:

  bin/    : 6 ocorrências
  source/ : 2 ocorrências

(Ignore link/ — a maioria está dentro de submódulos como
oh-my-zsh.)

Quero uma triagem em formato de tabela markdown com colunas:

| Arquivo:linha | Texto do marker | Categoria | Ação proposta |

Categorias:
- "obsoleto": já foi resolvido, marcador esquecido — propor
  remoção.
- "atual": ainda é uma melhoria desejável — manter, talvez
  refinar.
- "virou bug": condição que era TODO virou problema real —
  promover para issue.
- "fora de escopo": dependência externa, esperando upstream
  — manter com nota de causa.

Não conserte nada — só categorize. Use:

  grep -rn "TODO\|FIXME\|XXX" ~/.dotfiles/bin ~/.dotfiles/source \
    --include="*.sh" -B1 -A2

para ter contexto de cada um.
```

---

## 6. Resolver submódulo `tpm` dirty

```
~/.dotfiles/link/.tmux/plugins/tpm aparece em `git status`
como dirty submódulo (`m` minúsculo).

Investigue:

1. `cd ~/.dotfiles/link/.tmux/plugins/tpm && git status`
   — o que mudou dentro do submódulo?
2. `git diff` dentro do submódulo — o conteúdo é runtime
   (cache, lock, log) ou fonte modificada?
3. Cheque se o tpm tem .gitignore e se algum arquivo
   regenerado a cada execução escapa do ignore.

Decisão a propor (escolha UMA com justificativa):

(a) **runtime esperado**: adicionar `assume-unchanged` no
    .git/info/excludes do dotfiles ou ignorar o submódulo
    em `git status` via `[submodule "..."] ignore = dirty`.
(b) **modificação intencional**: precisamos forkar o tpm,
    apontar o submódulo para o fork e commitar.
(c) **corrupção**: `git submodule update --init --force` e
    documentar o motivo no commit.

Não execute (b) ou (c) sem confirmação — apenas (a) é
autônomo.

Saída esperada: relatório markdown com diagnóstico + comando
exato para aplicar a opção escolhida.
```

---

## Como adicionar novos prompts aqui

Padrão:

1. Numere a seção e adicione ao índice em `REVIEW.md`.
2. Comece com 1-2 linhas de contexto fora do bloco de código.
3. Coloque o **prompt em si dentro de um bloco \`\`\`** (sem fences aninhadas).
4. Inclua: paths absolutos, restrições, comandos exatos para verificação, e um **critério de pronto** explícito.
5. Sempre proibir destruição autônoma — se a ação for irreversível, exija confirmação.

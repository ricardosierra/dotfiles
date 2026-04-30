# Revisão Global do Dotfiles

> Snapshot em 2026-04-30. Este documento **lista achados sem aplicar fix nenhum**. Para cada item há um prompt pronto-para-rodar em `docs/PROMPTS.md`.
>
> **Continuação em [`REVIEW2.md`](REVIEW2.md)** — segunda rodada de auditoria deep cobrindo `source/`, `init/` e `bin/dotfiles` (30 achados novos, sem duplicar IDs daqui).

## Bugs confirmados

### B1 — Timer Claude congela em `00h00m` e nunca exibe %

**Arquivo:** `scripts/claude_timer.sh:19-27`, `:34-42`
**Sintoma:** status bar do tmux mostra `Claude 00h00m` mesmo quando ainda há tempo de sessão real (usuário reportou ~46m restantes); a porcentagem nunca aparece automaticamente.
**Causa:**
1. `/tmp/claude_start` é gravado com `date +%s` na primeira invocação e nunca invalidado. Após >5h `REMAINING` é fixado em 0 (`scripts/claude_timer.sh:27`).
2. A `%` vem só de `/tmp/claude_usage`, populado manualmente via `claude-set 3h29m 86%`. Sem isso, o `%` é omitido.
3. Não há integração com API/dashboard do Claude — nem com `ccusage` (não instalado).

**Workaround:** `claude-reset` ou `claude-set <tempo> <%>`.
**Severidade:** Média (feature anunciada não cumpre o que promete).
**Prompt para fix:** [`PROMPTS.md` § 1](PROMPTS.md#1-consertar-timer-claude).

### B2 — Caminho hardcoded `/Users/sierra` em `init/20_osx_homebrew.sh`

**Arquivo:** `init/20_osx_homebrew.sh:10-11`
**Sintoma:** o instalador de Homebrew grava em `/Users/sierra/.bash_profile`, quebrando o dotfiles em qualquer máquina cujo usuário não seja `sierra`.
**Severidade:** Alta (anula a portabilidade do repo).
**Prompt para fix:** [`PROMPTS.md` § 3](PROMPTS.md#3-substituir-userssierra-hardcoded-por-home).

---

## Riscos de segurança / robustez

### R1 — Uso pesado de `eval` no `bin/dotfiles` (script principal)

`bin/dotfiles` tem **9 chamadas a `eval`** (linhas 232, 233, 259, 260, 268, 284, 285, 378) usadas para iterar sobre nomes de arrays bash via referência indireta. Não há entrada de usuário direta nessas linhas — os arrays são populados internamente — mas qualquer regressão futura que injete dados externos nesses arrays vira RCE imediata.
**Severidade:** Baixa hoje, mas precisa estar marcado para auditoria a cada PR que mexer em `bin/dotfiles`.
**Prompt para auditoria:** [`PROMPTS.md` § 4](PROMPTS.md#4-auditar-eval-em-bindotfiles).

### R2 — `eval $(thefuck --alias)` sem aspas

**Arquivo:** `source/50_misc.sh:35`
Padrão arriscado em geral; aqui `thefuck` é trusted, mas a forma é a mesma de RCE clássico. Trocar por `eval "$(thefuck --alias)"` é trivial e remove o smell.

### R3 — Submódulo `link/.tmux/plugins/tpm` dirty

`git status` mostra `m` (mudanças locais dentro do submódulo). Pode ser:
- artefato de runtime (cache que o tpm grava sozinho — comum)
- modificação intencional não rastreada
- corrupção

Se for runtime: adicionar ao `.gitignore` interno do submódulo ou a um `assume-unchanged`. Se for intencional: precisa virar fork. Se for corrupção: `git submodule update --force`.
**Prompt:** [`PROMPTS.md` § 6](PROMPTS.md#6-resolver-submodulo-tpm-dirty).

### R4 — `bin/rename` é Perl, não shell

`bin/rename:244,302` usam `eval` em Perl (que é exception-handling, **não** shell eval). Falso positivo se rodar grep cego. Documentado aqui para evitar confusão em auditorias futuras.

---

## Higiene

### H1 — Shebangs heterogêneos

Distribuição encontrada em `bin/` + `scripts/` + `init/` + `source/`:

| Shebang                    | Arquivos |
| -------------------------- | -------: |
| `#!/bin/bash`              |       50 |
| `#!/usr/bin/env bash`      |       16 |
| `#!/bin/sh`                |        7 |
| `#! /bin/sh` (com espaço)  |        1 |
| `#!/usr/bin/zsh`           |        1 |

Inconsistência cosmética, mas afeta portabilidade (env-bash funciona em macOS com bash 5 do brew; `/bin/bash` direto pega bash 3 antigo do macOS). Padronizar em `#!/usr/bin/env bash` para arquivos que usam features modernas.

### H2 — TODO/FIXME

- `bin/`: 6 ocorrências
- `source/`: 2 ocorrências
- `scripts/`: 0
- `init/`: 0
- `link/`: 544 (a maioria provavelmente dentro de submódulos como oh-my-zsh — ignorar)

Os 8 do `bin/` + `source/` valem triagem. Prompt: [`PROMPTS.md` § 5](PROMPTS.md#5-triagem-de-todofixme).

### H3 — Sem testes automatizados nem hooks

Verificado:
- nenhum `.githooks/`, `.husky/`, `core.hooksPath`
- nenhum `.github/workflows/`
- `shellcheck`, `shfmt`, `bats` não instalados na máquina

Recomendação na próxima seção.

---

## Sugestões de melhoria

### S1 — Adicionar `shellcheck` no pre-push (opt-in)

Lint só nos arquivos do diff, não no repo todo (~1.277 shells). Pre-push é o ponto certo: barato, batchável, evita atrapalhar commits interativos. Detalhes e prompt em [`PROMPTS.md` § 2](PROMPTS.md#2-shellcheck-no-pre-push).

### S2 — Mover state do timer para `${XDG_RUNTIME_DIR:-/tmp}`

`/tmp` é mundialmente legível e algumas distros limpam agressivamente. `XDG_RUNTIME_DIR` (presente no macOS via launchd, em Linux moderno via systemd) é per-user e mais semântico. Mudança de uma linha em `scripts/claude_timer.sh` e `scripts/claude_set.sh`.

### S3 — `claude_set.sh` valida formatos com regex frágil

`scripts/claude_set.sh:19-29` aceita `3h29m`, `3h`, `45m` mas rejeita silenciosamente `3h0m` invalido por nao casar exatamente. A regex tambem nao valida limites (`99h99m` passa). Validar em sub-shell com `awk` ou `bash` arithmetic.

### S4 — Documentar a ordem de carregamento de `source/`

Os arquivos em `source/` rodam em ordem alfabética por convenção; novos colaboradores tendem a errar isso. Uma linha no `README.md` resolve.

---

## Como usar este documento

1. Achados acima descrevem **o quê** e **onde**.
2. `docs/PROMPTS.md` tem **como** consertar — cada prompt é colável numa nova sessão Claude/Cursor/Codex e inclui paths absolutos, contexto e critério de pronto.
3. Reabrir este review periodicamente (sugerido: a cada minor bump do dotfiles ou trimestralmente).

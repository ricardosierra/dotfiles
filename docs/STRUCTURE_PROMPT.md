# Prompt-base de Estrutura

Bloco abaixo descreve o repo `~/.dotfiles` inteiro de forma auto-contida. Use como **header** de qualquer prompt de revisão — basta colar o bloco e adicionar suas instruções de foco no final (há um placeholder marcado).

Atualizado em **2026-04-30**. Reabra e ajuste após mudanças estruturais grandes (novos top-level dirs, troca de gerenciador, etc.).

---

````
Você vai revisar o repositório de dotfiles em ~/.dotfiles do usuário
Ricardo R. Sierra. Antes do foco específico da revisão (no final deste
prompt), absorva o contexto estrutural abaixo. Não duplique trabalho
já documentado — referências em "Docs existentes" listam o que já foi
analisado.

═══════════════════════════════════════════════════════════════════
IDENTIDADE & PROPÓSITO
═══════════════════════════════════════════════════════════════════

Fork pessoal e fortemente customizado do dotfiles do "cowboy"
(Ben Alman). Gerenciador próprio em Bash (não usa dotbot/rcm/chezmoi).
Suporta macOS, Ubuntu, Fedora, Kali e Debian via detecção em runtime.

Comando central: `dotfiles` (em ~/.dotfiles/bin/dotfiles, ~837 linhas).
É o orquestrador que copia, linka e roda init scripts em sequência.

═══════════════════════════════════════════════════════════════════
LAYOUT TOP-LEVEL
═══════════════════════════════════════════════════════════════════

~/.dotfiles/
├── bin/         36 executáveis (dotfiles + utilities pessoais)
├── scripts/     scripts auxiliares (atualmente só timer Claude)
├── init/        16 scripts de install ordenados por prefixo numérico
├── source/      40 arquivos sourceados em todo shell login
├── link/        symlink farm — vai pra ~/.<nome>
├── copy/        arquivos copiados pra ~/ (não linkados — editáveis
│                localmente sem afetar o repo: .gitconfig.local etc.)
├── conf/        configs por OS (linux, osx, manh, tic)
├── config/      conteúdo de ~/.config/ (htop, fontconfig, powerline)
├── caches/      arquivos cacheados pelo dotfiles (autogerados)
├── backups/     backups feitos antes de sobrescrever durante install
├── docs/        documentação (en/, pt/, 2.0/, helper/, REVIEW.md,
│                PROMPTS.md, STRUCTURE_PROMPT.md)
├── ansible/     roles ansible (provisioning paralelo ao install bash)
├── vendor/      submódulos vendorizados: git-extras, rbenv, rename, z
├── dependency/  shims de compatibilidade (shopt fallback)
├── test/        4 arquivos de teste para utilitários internos
│                (test_array.sh, test_path_remove.sh, test_setdiff.sh,
│                teste.sh) — não há runner automatizado
├── default/     skeleton/template defaults
├── Dockerfile + docker-compose.yml  (testar dotfiles em container)
├── README.md    instruções principais
├── CHANGELOG.md histórico (NOTA: hoje em formato Keep-a-Changelog,
│                deveria ser "Release Notes" com emojis conforme
│                regra global do usuário — bug conhecido)
└── LICENSE-MIT

═══════════════════════════════════════════════════════════════════
CONVENÇÕES POR DIRETÓRIO
═══════════════════════════════════════════════════════════════════

▸ bin/  — executáveis com shebang. NÃO sourceados; ficam no $PATH.
  Exemplos relevantes: `dotfiles` (orquestrador), `eachdir`,
  `manh`, `multi_firefox`, `update-rust-nightly`, `pentest`.

▸ init/ — rodam UMA vez no `dotfiles install`. Prefixo numérico
  define ordem (10_xcode → 20_homebrew → 30_recipes → ...).
  Sufixo de OS isola plataformas (`*_osx_*`, `*_linux_*`).

▸ source/ — sourceados em TODO shell interativo, ordem alfabética.
  Prefixos: 00_ (core), 01_ (path/exports/prompt), 10_ (editor/tmux),
  20_ (system), 30_ (rede/docker), 50_ (utilitários — maioria),
  60_ (windows), 80_ (work_station), 90_ (dump), 100_ (workflow),
  1000_ (sierra_only — segredos pessoais).
  → Ordem importa: 01_path.sh precisa rodar antes de qualquer
    binário customizado. 1000_sierra_only.sh fica por último.

▸ link/ — `ln -s ~/.dotfiles/link/.foo ~/.foo`. Edição em qualquer
  lado afeta o outro. Inclui `.oh-my-zsh` (submódulo) e `.tmux/`.

▸ copy/ — `cp ~/.dotfiles/copy/.foo ~/.foo`. Cópia única. Usado
  para arquivos com segredos locais (`.gitconfig.local`).

▸ scripts/ — chamados a partir de configs (ex: tmux statusline) ou
  por aliases. Hoje apenas `claude_set.sh` e `claude_timer.sh`.

═══════════════════════════════════════════════════════════════════
FLUXO DE INSTALL (resumo do bin/dotfiles)
═══════════════════════════════════════════════════════════════════

1. Detecta OS via uname e arquivos /etc/*-release.
2. Backups: arquivos em ~ que conflitam vão pra ~/.dotfiles/backups/<timestamp>/.
3. Copy step: copia `copy/*` pra ~ (só se ainda não existir).
4. Link step: symlink `link/*` pra ~ (sobrescreve, com backup).
5. Init step: roda `init/*.sh` em ordem alfabética, filtrando por OS.
6. Source step (a partir de então, todo shell): carrega `source/*.sh`.

Helpers internos (`bin/dotfiles`): `e_header`, `e_success`, `e_error`,
`e_arrow`, `info`, `user`, `success`, `fail`. Usam ANSI escapes
diretos.

═══════════════════════════════════════════════════════════════════
SUBSISTEMAS NOTÁVEIS
═══════════════════════════════════════════════════════════════════

▸ Timer Claude — `scripts/claude_timer.sh` integrado ao tmux
  (`link/.tmux.conf` chama via `#(...)` no status-right). Aliases
  `claude-reset` e `claude-set` em `source/50_misc.sh`. Bug
  conhecido (ver Docs existentes).

▸ Oh-My-Zsh — submódulo em `link/.oh-my-zsh`. ~544 marcadores
  TODO/FIXME dentro são do upstream, ignorar.

▸ TPM (Tmux Plugin Manager) — submódulo em `link/.tmux/plugins/tpm`,
  atualmente dirty (status `m`). Causa não-investigada.

▸ Powerline — `config/powerline/`, sourced em `source/10_powerline*.sh`.

▸ Ansible — `ansible/roles/` paralelo ao install bash; uso opcional.

▸ Vendor submodules — `vendor/{git-extras,rbenv,rename,z}` adicionados
  manualmente; cada um tem licença e ciclo próprio.

═══════════════════════════════════════════════════════════════════
TAMANHO E DISTRIBUIÇÃO DE CÓDIGO SHELL
═══════════════════════════════════════════════════════════════════

Linhas por diretório (apenas .sh + rcs visíveis):

  source/  ≈ 4.441 linhas  (maior superfície — foco preferido)
  init/    ≈ 1.731 linhas  (rodam com privilégios elevados)
  scripts/ ≈    99 linhas
  link/    ≈ 6.481 linhas  (inclui submódulos — descontar antes)
  bin/     muitos arquivos sem extensão (dotfiles tem ~837 linhas
                                          sozinho; outros são curtos)

Shebangs heterogêneos: 50× #!/bin/bash, 16× #!/usr/bin/env bash,
7× #!/bin/sh, 1× #!/usr/bin/zsh, 1× "#! /bin/sh" (com espaço).

═══════════════════════════════════════════════════════════════════
RESTRIÇÕES DO USUÁRIO (regras globais — não violar)
═══════════════════════════════════════════════════════════════════

▸ Commits: SEM `Co-Authored-By:` (nem Claude nem outro modelo).
  Mensagens em pt-BR, estilo conciso, sujeito + opcional corpo.

▸ CHANGELOG: formato "Release Notes" obrigatório
  (### ✨ Novidades / ### 🎨 Melhorias / ### 🐛 Correções /
   ### 🔧 Técnico, itens em `- [x]` ou `- [ ]`).
  Referência canônica: ~/Dev/Banlek/banlek-uploader/CHANGELOG.md.
  → O CHANGELOG.md atual NÃO segue isso e é bug conhecido.

▸ Português brasileiro em mensagens, comentários, docs.

▸ Nada de emojis em código a menos que o usuário peça
  (exceção: o emoji ⚠️ já está no README na seção de limitações
  conhecidas e no formato Release Notes).

═══════════════════════════════════════════════════════════════════
DOCS EXISTENTES (já analisado — não duplicar)
═══════════════════════════════════════════════════════════════════

▸ docs/REVIEW.md — inventário atual de bugs, riscos e sugestões.
  Bugs já mapeados: timer Claude congelado, /Users/sierra hardcoded
  em init/20_osx_homebrew.sh:10-11. Riscos: 9 evals em bin/dotfiles,
  eval sem aspas em source/50_misc.sh:35, submódulo tpm dirty.

▸ docs/PROMPTS.md — 6 prompts prontos para corrigir cada item.

▸ README.md (seção "Claude Usage Timer") — feature + limitações.

▸ CHANGELOG.md — histórico em formato errado (Keep-a-Changelog em
  vez de Release Notes).

Se sua revisão duplicar achados que já estão em REVIEW.md, mencione
o ID do achado (B1, B2, R1, etc.) em vez de re-descrever.

═══════════════════════════════════════════════════════════════════
FORMATO DE SAÍDA ESPERADO
═══════════════════════════════════════════════════════════════════

Markdown com seções claras. Para cada achado novo:

  ### <ID> — <título curto>
  **Arquivo:** path:linha
  **Tipo:** bug | risco | higiene | sugestão
  **Severidade:** alta | média | baixa
  **Descrição:** o que está errado e por quê.
  **Correção proposta:** uma frase ou diff curto.

NÃO aplique nenhum patch — só análise.
NÃO dê uma "nota" geral subjetiva. Liste fatos, não opiniões.
NÃO recomende reescrever o repo do zero.
NÃO sugira migrar para outro gerenciador (dotbot etc.) sem que
isso seja pedido explicitamente.

═══════════════════════════════════════════════════════════════════
FOCO DESTA REVISÃO  ← preencha antes de enviar
═══════════════════════════════════════════════════════════════════

[ADICIONE AQUI O FOCO DA REVISÃO. Exemplos:

  • "Revisar tudo em source/ procurando comportamento incorreto
     em macOS Sequoia ou variáveis depreciadas."

  • "Auditoria de segurança em init/ — qualquer comando que rode
     com sudo, baixe binário externo, ou modifique configs do
     sistema sem confirmar."

  • "Performance do shell startup — medir tempo de cada arquivo
     em source/ e propor lazy-loading onde fizer sentido."

  • "Portabilidade Linux — encontrar tudo que assume macOS sem
     guard explícito de OS."

Seja específico no escopo. Quanto mais estreito o foco, mais
profundo o achado.]
````

---

## Como usar

1. `cat docs/STRUCTURE_PROMPT.md` (ou abra no editor).
2. Copie **só o conteúdo dentro do bloco \`\`\`\`** (do `Você vai revisar...` até o `]` final).
3. Substitua a seção `FOCO DESTA REVISÃO` pelo seu objetivo concreto.
4. Cole numa nova sessão Claude/Cursor/Codex.
5. Quando o resultado vier, considere consolidar em `docs/REVIEW.md` (atualizando IDs B1/R1/etc. para não repetir).

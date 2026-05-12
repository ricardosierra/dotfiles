# Política de Depreciação

Como decidimos o que sai do repo, o que vai pra `archive/` e o que continua suportado.

## Regras

1. **Sem documentação ⇒ candidato a archive.**
   Todo script em `bin/` ou source-file precisa ter, no mínimo, um comentário-cabeçalho
   explicando o que faz e quando usar. Sem isso, vai pra revisão na próxima rodada.

2. **Sem uso há 2 anos ⇒ archive.**
   Heurística: `git log --since='2 years ago' -- <arquivo>` retorna vazio (ou só commits
   de formatação/cleanup). Rodar `bash scripts/audit/audit_dead_files.sh` pra lista
   atualizada.

3. **Depende de ferramenta morta ⇒ remover.**
   Sublime Text 2, Pebble SDK, nave (Node), powerline-python, docker-machine,
   apt-key (deprecated em apt 2.0+) — saem.

4. **Ferramentas ofensivas ⇒ opt-in via `archive/legacy-security/`.**
   BeEF, pentest scripts, tor+iptables. Sem bit de execução por padrão.
   Quem precisar, copia pra fora do repo conscientemente.

5. **Pessoal demais ⇒ `archive/personal/` ou `~/.dotfiles.private/` (gitignored).**
   Templates de VM, configs de Bus Pirate / FTDI, scripts com nome próprio
   (`1000_sierra_only.sh`). Acoplamento explícito a você sai do shared.

6. **Quebra shell não-interativo ⇒ não pode carregar automaticamente.**
   Use guards `[[ $- == *i* ]] || return 0` no início de qualquer source-file
   que produza output, prompts, ou dependa de TTY.

7. **Mexe em sistema ⇒ precisa de `--dry-run` e confirmação.**
   Aplicável a tudo em `init/` e a scripts em `bin/system/`. Sem prompt + sudo
   automático = perigo.

8. **Submodule sem upstream ativo (último commit > 2 anos) ⇒ remover.**
   Verificar com `git submodule foreach 'git log -1 --format=%cr'`.

9. **Vendor que pode vir de package manager ⇒ remover do vendor.**
   `git-extras`, `rename`, `z` — todos disponíveis via brew/apt. Manter
   vendor apenas pro que realmente não tem outro caminho (`.tmux/gpakosz`).

## Processo

1. **Achado** → entra na tabela em `docs/audit.md` § 2 (Inventário classificado).
2. **Arquivamento** → mover pra `archive/<categoria>/` num único commit
   (`chore: archive <arquivo>`). Não mexer em comportamento no mesmo commit.
3. **Carência** → 1 release (≈ próxima `vX.Y.0`) sem reclamação.
4. **Remoção definitiva** → `git rm archive/<categoria>/<arquivo>` em commit
   separado, com referência ao commit de arquivamento.
5. **Documentar** → sempre na seção `### 🔧 Técnico` do `CHANGELOG.md`,
   no formato Release Notes.

## Categorias do `archive/`

| Diretório | Para que serve |
|---|---|
| `archive/legacy/` | Tooling obsoleto não-perigoso (CDRW, Firefox-fixer, Sublime helpers) |
| `archive/legacy-security/` | Ferramentas ofensivas ou destrutivas (BeEF, tor-iptables, pentest) |
| `archive/personal/` | Específico do dono (VMs, Bus Pirate, scripts com nome próprio) |
| `archive/docs-2.0/` | Documentação abandonada mas com histórico |
| `archive/<outro>/` | Qualquer nova categoria precisa de uma linha aqui |

## Como saber se algo precisa ir pra `archive/`

Sequência de checagens (manuais):

```sh
# 1. Quando foi a última vez que alguém tocou?
git log -1 --format='%cr  %s' -- bin/multi_firefox

# 2. Existe referência fora do próprio arquivo?
grep -RIl multi_firefox . --exclude-dir=.git --exclude-dir=vendor --exclude-dir=link

# 3. A ferramenta principal (curl, dep externa) ainda existe?
command -v cdrecord || echo "cdrecord não existe mais"
```

Se as três respostas forem "muito tempo / só ele mesmo / não" — vai pra archive.

# Funcionamento do Dotfiles

## Como o comando `dotfiles` funciona

Quando [`dotfiles`](../../bin/dotfiles) é executado pela primeira vez, acontece o seguinte:

1. No Ubuntu, o Git é instalado via APT se necessário (já presente no macOS).
2. O repositório é clonado em `~/.dotfiles`.
3. Arquivos de `/copy` são copiados para `~/`.
4. Subdiretórios de `/copy` são copiados para `/`.
5. Arquivos de `/link` são criados como links simbólicos em `~/`.
6. Você escolhe quais scripts de `/init` executar — pré-filtrados para o seu SO.
7. Os scripts selecionados são executados em ordem alfanumérica.

Nas execuções seguintes: o passo 1 é ignorado, o passo 2 atualiza o repositório, e o passo 6 lembra das seleções anteriores.

---

## Referência de diretórios

### `/backups`

Criado automaticamente antes dos passos copy e link. Qualquer arquivo de `~/` que seria sobrescrito é movido para cá primeiro. Pode ser inspecionado ou deletado com segurança.

### `/bin`

Scripts executáveis e links simbólicos. Este diretório é adicionado ao `$PATH` automaticamente.

Scripts principais:

| Script | Descrição |
|--------|----------|
| `dotfiles` | Orquestrador principal — executa o ciclo completo de instalação/atualização |
| `src` | Recarrega todos os arquivos de `/source` sem reiniciar o shell |
| `browser-exec` | Abre URLs no browser ou cai para uma imagem Docker de browser |
| `eachdir` | Executa um comando em cada subdiretório imediato |

### `/caches`

Dados em cache usados por scripts (ex: brew bundle cache). Pode ser deletado — é regenerado na próxima execução.

### `/conf`

Arquivos de configuração que referenciam mas não vivem em `~/`. Por exemplo, configs específicas de SO e arquivos de fontes.

### `/copy`

Arquivos copiados literalmente para `~/` durante a instalação. Use para arquivos com dados pessoais (email, chaves privadas) que não devem ser commitados no repo público. Editar `~/arquivo` **não** atualiza `~/.dotfiles/copy/arquivo`.

Exemplo: `copy/.gitconfig` contém email + chave de assinatura.

### `/link`

Arquivos linkados para `~/` com `ln -s`. Editar `~/.dotfiles/link/arquivo` ou `~/arquivo` muda os dois — são o mesmo arquivo. Nunca linke arquivos com conteúdo sensível; adicione-os ao `.gitignore`.

### `/source`

Arquivos shell carregados automaticamente em todo novo shell, em ordem alfanumérica. Por isso os arquivos têm prefixos numéricos (`00_`, `10_`, `50_`, etc.).

Arquivos principais:

| Arquivo | Descrição |
|---------|----------|
| `00_dotfiles.sh` | Variáveis core e helpers do dotfiles |
| `01_exports.sh` | Exports de variáveis de ambiente |
| `01_path.sh` | Configuração do PATH |
| `01_prompt.sh` | Variáveis do prompt |
| `10_tmux.sh` | Helpers de sessão tmux |
| `20_system.sh` | Aliases de sistema (ls, cd, cp, mv) |
| `30_docker.sh` | Aliases Docker e Docker Machine |
| `50_dev.sh` | Aliases e funções de desenvolvimento |
| `50_file.sh` | Atalhos de manipulação de arquivos |
| `50_net.sh` | Utilitários de rede |
| `50_osx.sh` | Helpers específicos do macOS |
| `100_workflow.sh` | Comandos de workflow Git (gf/jf) |

### `/init`

Scripts de instalação executados uma vez por máquina (idempotentes — ignoram o que já está instalado). Numerados para controle de ordem.

#### macOS
- `init/10_osx_xcode.sh` — Xcode Command Line Tools
- `init/20_osx_homebrew.sh` — Homebrew
- `init/30_osx_homebrew_recipes.sh` — Ferramentas CLI via Homebrew
- `init/30_osx_homebrew_casks.sh` — Apps GUI via Homebrew Cask
- `init/50_osx_fonts.sh` — Fontes de programação

#### Linux
- `init/20_linux_apt.sh` — Pacotes APT + git-extras

#### Ambos
- `init/50_node.sh` — Node.js, npm
- `init/50_ruby.sh` — Ruby, gems, rbenv
- `init/50_vim.sh` — Plugins do Vim

### `/test`

Testes unitários para funções bash complexas.

### `/vendor`

Bibliotecas de terceiros incluídas como submódulos git (ex: git-extras, oh-my-zsh, rbenv).

---

## Aliases e funções

`~/.bashrc` e `~/.bash_profile` são intencionalmente mínimos — eles apenas carregam `/source`. Adicione seus próprios aliases, funções e exports nos arquivos de `/source/` ou em arquivos de override pessoais:

| Arquivo | Descrição |
|---------|----------|
| `~/.aliases` | Aliases pessoais (carregados automaticamente) |
| `~/.exports` | Variáveis de ambiente customizadas |
| `~/.path` | Entradas extras de PATH |

---

## O prompt

[`source/50_prompt.sh`](../../source/50_prompt.sh) constrói um prompt mostrando:

- Diretório atual
- Timestamp
- Último código de saída (vermelho em falha)
- Status do repo Git/SVN

**Flags Git:**

| Flag | Significado |
|------|------------|
| `?` | Arquivos não rastreados |
| `!` | Modificados mas não staged |
| `+` | Staged, prontos para commit |

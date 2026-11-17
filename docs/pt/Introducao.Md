# Introdução ao Dotfiles

## Seja cuidadoso

Este dotfiles altera drasticamente o seu bash, funções e programas executados a partir do terminal. Certifique-se de que é isso que você deseja antes de instalar.

Ele substituirá arquivos existentes como `.bashrc`. Todos os arquivos substituídos ou deletados são copiados para `~/.dotfiles/backups/` antes de serem removidos.

**Antes de instalar, faça um fork do repositório e remova tudo que você não for usar.**

---

## Sobre o projeto

O objetivo do dotfiles é ser instalado sempre que você começar a usar um novo computador, recuperando todo o seu ambiente de desenvolvimento e trabalho com um único comando.

---

## O que está incluído

- **Configuração do shell** — prompt, aliases, funções, exports, configuração de PATH
- **Scripts de instalação** — Homebrew (macOS), APT (Linux), Node.js, Ruby, plugins do Vim, fontes
- **Helpers Docker** — aliases para gerenciar containers, imagens, redes e shells Docker sob demanda
- **Workflow Git** — comandos `gf`/`jf` para criar branch, commitar e enviar com um único comando
- **Integração tmux** — timer de sessão Claude e configuração da barra de status
- **Gitignore global** — ignora artefatos comuns de build, editores e ferramentas de IA
- **Personalização do Vim** — plugins e configurações via script de init

---

## O que acontece durante a instalação

Quando o comando `dotfiles` é executado pela primeira vez:

1. No Ubuntu, o Git é instalado via APT se necessário (já presente no macOS).
2. O repositório é clonado em `~/.dotfiles`.
3. Arquivos de `/copy` são copiados para `~/`.
4. Arquivos de `/link` são criados como links simbólicos em `~/`.
5. Você escolhe quais scripts de `/init` executar — pré-filtrados para o seu SO.
6. Os scripts selecionados são executados em ordem alfanumérica.

Nas execuções seguintes, o passo 1 é ignorado, o passo 2 atualiza o repositório, e o passo 5 lembra das seleções anteriores.

---

## Plataformas suportadas

| Plataforma | Status |
|-----------|--------|
| macOS 10.15+ | Principal |
| Ubuntu 14.04 – 22.04 LTS | Testado |
| Debian | Compatível |
| KaliLinux | Compatível |
| Fedora | Parcial |

---

## Próximos passos

- [Funcionamento](Funcionamento.md) — detalhes de cada diretório e passo
- [Personalizando](Personalizando.md) — como adicionar seus próprios aliases e configurações
- [Atalhos](usando/Atalhos.md) — referência de aliases disponíveis

---

## Auditoria de manutenção (2026-Q2)

Um ciclo completo de auditoria rodou neste repo pra remover tooling legado,
modernizar o bootstrap e adicionar CI. Saídas principais:

- [`docs/audit.md`](../audit.md) — relatório completo (8 fases, 60+ commits)
- [`docs/scripts-review.md`](../scripts-review.md) — revisão de 27 scripts em
  `bin/{pentest,network,system,files,security,life,text}/` + 7 ferramentas novas
- [`docs/deprecations.md`](../deprecations.md) — política de archive
- [`scripts/audit/`](../../scripts/audit/) — 11 scripts de auditoria reusáveis
- [`archive/`](../../archive/) — código legado em quarentena (instalador BeEF,
  gravador CDRW, funções docker mortas atom/phonegap/dcos/tormessenger, etc.)

Novas ferramentas CLI adicionadas neste ciclo (todas em `bin/`):

| Ferramenta | O que faz |
|---|---|
| `port-killer <porta>` | Mata processo escutando numa porta (com confirmação) |
| `du-by-extension [dir]` | Top 20 de uso de disco por extensão |
| `wifi-strength` | SSID atual + força do sinal (macOS/Linux) |
| `dedupe [dir]` | Lista duplicatas por hash MD5 |
| `ssl-check <dominio>` | Audita cert TLS: issuer, validade, dias restantes |
| `git-cleanup [--apply]` | Remove branches já mergeadas em main/master/develop |
| `wc-by-language [dir]` | LoC por linguagem (alternativa leve a tokei/cloc) |

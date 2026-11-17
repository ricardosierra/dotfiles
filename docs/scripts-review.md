# Revisão de scripts em `bin/`

Snapshot **2026-05-12**. Cobre `bin/pentest/`, `bin/network/`, `bin/system/`,
`bin/files/`, `bin/security/`, `bin/life/`, `bin/text/` — 27 scripts ativos
(`bin/pentest/ddos` removido na Fase 2 por ser placebo).

> Produzido seguindo Prompt #43 do [`PROMPTS2.md`](PROMPTS2.md).
> Não modifica nenhum script — apenas relata.

---

## Sumário

| Pasta | Total | KEEP | KEEP_WITH_CHANGES | ARCHIVE | REMOVE |
|---|---:|---:|---:|---:|---:|
| `bin/pentest/` | 5 | 1 | 3 | 1 | 0 |
| `bin/network/` | 4 | 1 | 2 | 1 | 0 |
| `bin/system/` | 3 | 0 | 3 | 0 | 0 |
| `bin/files/` | 12 | 2 | 7 | 3 | 0 |
| `bin/security/` | 1 | 0 | 1 | 0 | 0 |
| `bin/life/` | 1 | 0 | 1 | 0 | 0 |
| `bin/text/` | 1 | 1 | 0 | 0 | 0 |
| **Total** | **27** | **5** | **17** | **5** | **0** |

### Tabela-resumo por script

| Script | Estado | Veredicto |
|---|---|---|
| `bin/pentest/checkip` | WORKS_NEEDS_DEP | KEEP_WITH_CHANGES |
| `bin/pentest/email_list` | BROKEN_URL + PT_BR_ONLY | ARCHIVE |
| `bin/pentest/pentest` | WORKS_NEEDS_DEP + ROOT_REQUIRED | KEEP_WITH_CHANGES |
| `bin/pentest/scan` | WORKS_NEEDS_DEP | KEEP |
| `bin/pentest/zscan` | WORKS_NEEDS_DEP + DESKTOP_ONLY + PT_BR_ONLY | KEEP_WITH_CHANGES |
| `bin/network/email` | WORKS_NEEDS_DEP + PT_BR_ONLY | KEEP_WITH_CHANGES |
| `bin/network/email-auth` | WORKS | KEEP |
| `bin/network/roteador` | BROKEN_DEP + ROOT_REQUIRED + PT_BR_ONLY | ARCHIVE |
| `bin/network/transfer` | WORKS (sem shebang) | KEEP_WITH_CHANGES |
| `bin/system/memory` | BROKEN (pipe sem sentido) | KEEP_WITH_CHANGES |
| `bin/system/clear-snap` | WORKS_NEEDS_DEP (Linux) | KEEP_WITH_CHANGES |
| `bin/system/system_cleaner` | WORKS_NEEDS_DEP + ROOT_REQUIRED + PT_BR_ONLY | KEEP_WITH_CHANGES |
| `bin/files/cmp-porcent-equals` | WORKS + PT_BR_ONLY | KEEP_WITH_CHANGES |
| `bin/files/convert-csv-to-ldif` | WORKS (loop fixo em 90 linhas) | KEEP_WITH_CHANGES |
| `bin/files/convert-multi` | WORKS_NEEDS_DEP | KEEP_WITH_CHANGES |
| `bin/files/convert-odt-or-ppt-to-pdf` | WORKS_NEEDS_DEP | KEEP |
| `bin/files/convert-ogg-to-pdf` | WORKS (nome enganoso — converte pra MP3) | KEEP_WITH_CHANGES |
| `bin/files/convert-swfslide-to-pdf` | BROKEN_DEP (Flash EOL 2020) | ARCHIVE |
| `bin/files/convert-txt-to-ttsbook` | BROKEN_URL (Google TTS endpoint) | ARCHIVE |
| `bin/files/get-wallpapers-hubble` | BROKEN_URL (Hubble migrou domínio) | ARCHIVE |
| `bin/files/minify-img` | WORKS_NEEDS_DEP (já tem guard) | KEEP |
| `bin/files/minify-jpg` | WORKS_NEEDS_DEP | KEEP_WITH_CHANGES |
| `bin/files/search-in-pdf` | WORKS_NEEDS_DEP (encoding corrompido) | KEEP_WITH_CHANGES |
| `bin/files/txt-in-img` | WORKS_NEEDS_DEP | KEEP_WITH_CHANGES |
| `bin/security/crypt_l4sencfs` | WORKS_NEEDS_DEP + ROOT_REQUIRED + PT_BR_ONLY | KEEP_WITH_CHANGES |
| `bin/life/tempo` | BROKEN_URL | KEEP_WITH_CHANGES |
| `bin/text/sincleg` | WORKS | KEEP |

---

## bin/pentest/

### checkip
1. **O que faz:** consulta `ipinfo.io/<ip>` e enriquece com geocoding via Google Maps.
2. **Deps:** `curl` [✓], `dig` (bind9-dnsutils/bind9-host) [✓], `awk`/`sed` [✓].
3. **Estado:** WORKS_NEEDS_DEP. Bug: `yum -y install` no fallback (macOS não tem yum).
4. **Modernização:** trocar `if [[ ! -f "/usr/bin/curl" ]]` por `command -v curl >/dev/null 2>&1`. Remover `yum -y install` (que quebra em macOS/Debian). Trocar endpoint de geocoding (depende de `body.json` que não existe — provavelmente nunca funcionou).
5. **Veredicto:** KEEP_WITH_CHANGES.

### email_list
1. **O que faz:** raspa Bing por "contato email" + objeto/região; produz lista de emails.
2. **Deps:** `lynx` ou `wget`, `bc`. PT-BR via Bing.com.br.
3. **Estado:** BROKEN_URL + PT_BR_ONLY. O HTML do Bing mudou drasticamente desde 2014; o regex `resultados` não casa mais; URL `www.bing.com/search?q=...html` tampouco. Uso cinza (OSINT/recon ou spam).
4. **Modernização:** reescrever via API search comercial (Google Custom Search, Brave Search API) — fora do escopo de utilitários simples.
5. **Veredicto:** ARCHIVE em `archive/legacy-security/` (uso cinza + funcionalmente quebrado).

### pentest
1. **O que faz:** menu interativo PenScan — DNS pulls (dig), nmap ping sweep, MSSQL enum, hostname resolver. Salva resultados em `<output>/<company>/{dns,nmap,sql,hosts}/`.
2. **Deps:** `toilet` (banner ASCII art), `nmap`, `host`, `dig`. ROOT_REQUIRED.
3. **Estado:** WORKS_NEEDS_DEP + ROOT_REQUIRED. Bug: `sudo apt-get install -y toilet` no fallback (macOS sem apt).
4. **Modernização:** validar todas as deps no topo com loop genérico (`for d in toilet nmap host dig; do command -v "$d" >/dev/null || missing+=("$d"); done`). Trocar `rootcheck` por `if [[ $EUID -ne 0 ]]; then` (POSIX). Output dir hardcodado `/root` em alguns echos — usar variável.
5. **Veredicto:** KEEP_WITH_CHANGES.

### scan
1. **O que faz:** port-scan Ruby de subnet ou hosts específicos via `nmap -sP`/`-sT`. Marca IPs locais com `*`.
2. **Deps:** `ruby` [✓], `nmap` [✓], `ifconfig` (legacy mas ainda disponível em macOS e linux com `net-tools`).
3. **Estado:** WORKS_NEEDS_DEP.
4. **Modernização:** parser de `ifconfig` poderia migrar pra `ip -j addr` (JSON output, mais robusto) em Linux. Em macOS continua via `ifconfig`. Detectar com `command -v ip` e fallback.
5. **Veredicto:** KEEP (utilitário sólido, código limpo).

### zscan
1. **O que faz:** menu Zenity (GTK) — ping, ifconfig, netstat, whois, nmap ping sweep, nmap service detect. Output em janelas Zenity.
2. **Deps:** `zenity` [✓ linux desktop], `netstat` (deprecated), `whois`, `nmap`, `ifconfig`.
3. **Estado:** WORKS_NEEDS_DEP + DESKTOP_ONLY + PT_BR_ONLY.
4. **Modernização:** `netstat` → `ss` (substituto canônico). `ifconfig -a` → `ip -c addr show`. `/tmp/netmp.tmp` deveria ser `mktemp` pra evitar race condition.
5. **Veredicto:** KEEP_WITH_CHANGES.

---

## bin/network/

### email
1. **O que faz:** wrapper de `mail` com IP externo no assunto.
2. **Deps:** `mail` (mailutils/bsd-mailx), `links` (browser texto). PT-BR.
3. **Estado:** WORKS_NEEDS_DEP + PT_BR_ONLY. Bug: `EMAIL_TO="email de destino..."` literal — script só funciona depois de editar.
4. **Modernização:** trocar `links -dump ip.dnsexit.com` por `curl -s ifconfig.me`. Mover `EMAIL_TO` pra `~/.dotfilesconfig.local` (variável `MUTT_TO` ou similar). Trocar `links` por `curl` (links nem é instalado por padrão em distros novas).
5. **Veredicto:** KEEP_WITH_CHANGES.

### email-auth
1. **O que faz:** envia email autenticado via SMTP raw em `/dev/tcp`. 7 parâmetros: smtp, port, user, pass, rcpt, html-file, subject.
2. **Deps:** bash com `/dev/tcp` [✓ bash 3+]. Nenhuma dep externa.
3. **Estado:** WORKS.
4. **Modernização:** documentar que TLS não é suportado (só auth login plain). Para SMTP moderno (Gmail App Passwords) precisaria STARTTLS — fora do escopo de bash puro. Adicionar `--help` e validação.
5. **Veredicto:** KEEP.

### roteador
1. **O que faz:** compartilha internet via NAT (ad-hoc Wi-Fi) usando `iwconfig`/`ifconfig`/`iptables`.
2. **Deps:** `iwconfig` (deprecated, agora `iw`), `ifconfig` (deprecated, agora `ip`), `iptables` (legacy, agora `nft`).
3. **Estado:** BROKEN_DEP + ROOT_REQUIRED + PT_BR_ONLY. Ad-hoc mode foi removido de muitos drivers Wi-Fi modernos. NetworkManager + `nmcli connection add type ad-hoc` é a abordagem 2026.
4. **Modernização:** reescrever via `nmcli` + `nft` — virtualmente do zero. Esforço alto, retorno baixo (poucos usam ad-hoc hoje).
5. **Veredicto:** ARCHIVE em `archive/legacy/`.

### transfer
1. **O que faz:** upload de arquivo/pipe pra transfer.sh e printa URL.
2. **Deps:** `curl` [✓], `zip` (se dir). transfer.sh está ATIVO (verificado).
3. **Estado:** WORKS. **Sem shebang** — bug.
4. **Modernização:** adicionar `#!/usr/bin/env bash`. Trocar `return 1` por `exit 1` (script standalone, não sourced).
5. **Veredicto:** KEEP_WITH_CHANGES.

---

## bin/system/

### memory
1. **O que faz:** **tenta** mostrar uso de memória RAM.
2. **Deps:** `top` [✓], `free` [✓ linux only].
3. **Estado:** BROKEN. `top | free -m` é um pipe sem sentido — `free` ignora stdin. Funciona por acidente porque `free` roda igual independente da entrada. Quebrado em macOS (sem `free`).
4. **Modernização:** rewrite completo. Linux: `free -h --giga | awk '/Mem:/ {print $3"/"$2}'`. macOS: `vm_stat` + cálculo. Detectar OS e branch.
5. **Veredicto:** KEEP_WITH_CHANGES.

### clear-snap
1. **O que faz:** apt clean + journalctl vacuum + remoção de snaps obsoletos + thumbnails.
2. **Deps:** `apt` [✓ linux], `journalctl` [✓ systemd], `snap` [✓ ubuntu]. ROOT_REQUIRED.
3. **Estado:** WORKS_NEEDS_DEP. Ubuntu-only. `set -eu` no meio do script (bizarro). Comando `sudo apt-get install gtkorphan` no final é instalação, não cleanup — confuso.
4. **Modernização:** adicionar guard `is_ubuntu || (echo "Ubuntu-only" && exit 1)`. Mover `set -eu` pro topo. Remover instalação de gtkorphan ou separar em script próprio.
5. **Veredicto:** KEEP_WITH_CHANGES.

### system_cleaner
1. **O que faz:** dialog + apt-get update/upgrade/autoremove + drop_caches + swap reset.
2. **Deps:** `dialog` [✓], `apt-get` [✓ debian-family], `free` [✓ linux]. ROOT_REQUIRED + PT_BR_ONLY.
3. **Estado:** WORKS_NEEDS_DEP + ROOT_REQUIRED. `echo 3 > /proc/sys/vm/drop_caches` precisa de root direto (sem sudo) — vai falhar em zsh/bash interativo.
4. **Modernização:** `tee /proc/sys/vm/drop_caches <<< 3` via sudo. Guard `is_ubuntu || is_debian`. Adicionar `--yes` flag pra rodar não-interativo.
5. **Veredicto:** KEEP_WITH_CHANGES.

---

## bin/files/

### cmp-porcent-equals
1. **O que faz:** compara percentual de linhas iguais entre arquivos de uma pasta.
2. **Deps:** `sed`, `awk`, `sort` (POSIX). PT-BR.
3. **Estado:** WORKS + PT_BR_ONLY. Bug menor: `clear` dentro de `if test -s` sem `then` antes (linha 19).
4. **Modernização:** validar input ao começar. Trocar `[ $val -gt $perc ]` por `(( val > perc ))` (bash). Output em CSV pra processamento.
5. **Veredicto:** KEEP_WITH_CHANGES.

### convert-csv-to-ldif
1. **O que faz:** converte CSV pra LDIF (formato LDAP).
2. **Deps:** `sed`, `cut`, `head`, `tail` (POSIX).
3. **Estado:** WORKS — mas loop fixo em 90 linhas (`while [ $cont -le 90 ]`). Bug grosseiro: se CSV tem >90 linhas, perde dados; se <90, vai além do arquivo.
4. **Modernização:** loop dinâmico (`total=$(wc -l < "$arquivo1"); while [ $cont -le $total ]`). Adicionar mapping configurável (atualmente cn/dn/sn/pw fixos).
5. **Veredicto:** KEEP_WITH_CHANGES.

### convert-multi
1. **O que faz:** converte todos arquivos da pasta entre formatos (imagem ou áudio).
2. **Deps:** `ebb` (texlive-binaries), `ffmpeg`, `convert` (imagemagick), `lame` (mp3). Tem guard via `pinpoint`.
3. **Estado:** WORKS_NEEDS_DEP. `find $DIR -type f` mas `DIR` nunca é setado — usa pasta atual por sorte.
4. **Modernização:** setar `DIR="${1:-.}"` (mas hoje `$1` é extensão). Reformular argumentos: `convert-multi <de> <pra> [dir]`. Adicionar `--dry-run`.
5. **Veredicto:** KEEP_WITH_CHANGES.

### convert-odt-or-ppt-to-pdf
1. **O que faz:** `unoconv -f pdf $1`. Wrapper minimal.
2. **Deps:** `unoconv` (Python, ainda mantido).
3. **Estado:** WORKS_NEEDS_DEP.
4. **Modernização:** quote: `unoconv -f pdf "$1"`. Validar `$1` existe.
5. **Veredicto:** KEEP.

### convert-ogg-to-pdf
1. **O que faz:** **nome enganoso** — converte OGG pra MP3, não pra PDF.
2. **Deps:** `rename` (perl), `oggdec` (vorbis-tools), `lame`.
3. **Estado:** WORKS_NEEDS_DEP — mas nome induz a erro.
4. **Modernização:** renomear pra `convert-ogg-to-mp3`. Adicionar bitrate como flag (`-b`).
5. **Veredicto:** KEEP_WITH_CHANGES (rename + validação).

### convert-swfslide-to-pdf
1. **O que faz:** converte slides Flash SWF (do SlideShare antigo) pra PDF.
2. **Deps:** `swfrender` (swftools — pacote ainda existe), `imagemagick convert`. Refer-se a Greasemonkey/DownThemAll do Firefox antigo no help.
3. **Estado:** BROKEN_DEP. Flash Player EOL em **2020-12-31**. SlideShare migrou pra HTML5. Não há mais SWF pra converter.
4. **Modernização:** caso de uso morto — ARCHIVE.
5. **Veredicto:** ARCHIVE em `archive/legacy/`.

### convert-txt-to-ttsbook
1. **O que faz:** TTS (text-to-speech) de um .txt usando Google Translate TTS API + mp3splt.
2. **Deps:** `wget`, `iconv`, `mp3splt`. Endpoint Google `translate.google.com/translate_tts`.
3. **Estado:** BROKEN_URL. Google removeu o endpoint público `translate_tts` (retorna 403 desde ~2015). Hoje TTS exige Google Cloud TTS API com auth + cost.
4. **Modernização:** alternativas modernas:
   - `edge-tts` (Python, gratuito, vozes neurais Microsoft)
   - `piper` (TTS offline)
   - `say` (macOS built-in)
   Reescrita completa.
5. **Veredicto:** ARCHIVE em `archive/legacy/`.

### get-wallpapers-hubble
1. **O que faz:** baixa wallpapers da Hubble entre 1995-2012 em todas resoluções.
2. **Deps:** `wget`.
3. **Estado:** BROKEN_URL. Hubble migrou pra `hubblesite.org/contents/media/images/` com estrutura totalmente diferente; URLs antigas retornam 404.
4. **Modernização:** scraping novo via JSON API (https://hubblesite.org/api/v3/). Esforço de rewrite.
5. **Veredicto:** ARCHIVE em `archive/legacy/`.

### minify-img
1. **O que faz:** otimiza JPEG/PNG na pasta atual via `jpegoptim`/`optipng`.
2. **Deps:** `jpegoptim`, `optipng`. **Tem guard via pinpoint** ✅.
3. **Estado:** WORKS_NEEDS_DEP.
4. **Modernização:** adicionar suporte a WEBP/AVIF (formatos modernos). Flag `--hard` referenciada na variável mas não chega a usuário.
5. **Veredicto:** KEEP.

### minify-jpg
1. **O que faz:** redimensiona JPGs >1024px pra 50% via imagemagick.
2. **Deps:** `convert` (imagemagick), `find`.
3. **Estado:** WORKS_NEEDS_DEP. Sobreposto com `minify-img`. Lógica usa truque estranho (converte JPEG→PNG→volta) — desnecessário.
4. **Modernização:** mergear funcionalidade em `minify-img` com flag `--resize WIDTH`.
5. **Veredicto:** KEEP_WITH_CHANGES (ou consolidar com minify-img).

### search-in-pdf
1. **O que faz:** busca recursiva por string em PDFs (converte via pdftotext + grep).
2. **Deps:** `pdftotext` (poppler-utils).
3. **Estado:** WORKS_NEEDS_DEP. **Bug grave:** arquivo tem caracteres `?` no lugar de aspas (encoding corrompido) — provavelmente CP1252 salvo como UTF-8.
4. **Modernização:** corrigir encoding. Usar `pdfgrep` (canônico, mais rápido). Quote variáveis.
5. **Veredicto:** KEEP_WITH_CHANGES (encoding fix prioridade alta).

### txt-in-img
1. **O que faz:** sobrepõe texto sobre imagens da pasta atual.
2. **Deps:** `convert` (imagemagick), font `Titillium-Web-Regular`.
3. **Estado:** WORKS_NEEDS_DEP. Depende de font específica que pode não estar instalada.
4. **Modernização:** fallback de fonte (`-font` opcional). Sair se nenhuma imagem encontrada (atualmente roda mas falha silenciosamente).
5. **Veredicto:** KEEP_WITH_CHANGES.

---

## bin/security/

### crypt_l4sencfs
1. **O que faz:** wrapper de cryptsetup LUKS (criar/montar/desmontar volumes criptografados em arquivo).
2. **Deps:** `cryptsetup`, `losetup`, `dd`, `mke2fs`. Linux only. ROOT_REQUIRED. PT-BR.
3. **Estado:** WORKS_NEEDS_DEP + ROOT_REQUIRED + PT_BR_ONLY. Hardcode `/mnt/l4senc` — colide se rodar duas vezes em paralelo.
4. **Modernização:** `is_linux || exit 1`. Mountpoint configurável. `set -e`. Não suprimir todos os erros (`2>&1&>/dev/null` em todo lugar mata diagnóstico).
5. **Veredicto:** KEEP_WITH_CHANGES.

---

## bin/life/

### tempo
1. **O que faz:** mostra temperatura/vento/umidade pra Piracicaba, raspando `folha.uol.com.br/folha/tempo/`.
2. **Deps:** `lynx`.
3. **Estado:** BROKEN_URL. A URL `www1.folha.uol.com.br/folha/tempo/br-piracicaba.shtml` retorna 404 (Folha desativou o sub-domínio `www1` há anos). Mesmo se voltasse, o layout HTML mudou.
4. **Modernização:** trocar por `curl wttr.in/Piracicaba?format=3` (1 linha, sem deps além de curl). Tornar cidade configurável: `tempo [cidade]`.
5. **Veredicto:** KEEP_WITH_CHANGES (modernização trivial).

---

## bin/text/

### sincleg
1. **O que faz:** sincronizador de legenda `.srt` — ajusta timestamps em milissegundos.
2. **Deps:** `bc`, `sed` (POSIX).
3. **Estado:** WORKS.
4. **Modernização:** nenhuma crítica. Adicionar `--help` saudável. Aceitar argumento `--input file.srt --output new.srt` além do stdin.
5. **Veredicto:** KEEP (utilitário sólido, sem mudança urgente).

---

## Novos scripts sugeridos

Domínios cobertos hoje têm gaps óbvios. Estes 7 scripts agregam valor real
ao perfil do dono (full-stack PHP/Node/Ruby/Python/Go, Linux + macOS):

### 1. `bin/system/port-killer`

**O que faria:** dado um port number, encontra e mata o processo que escuta nele.

```sh
$ port-killer 3000
[port-killer] PID 84321 (node) listening on :3000 — kill? [y/N]
```

**Por quê:** uso constante quando webserver dev fica órfão. Hoje o fluxo manual
é `lsof -i :3000` → ver PID → `kill 84321` → 3-5 comandos. Vira `port-killer 3000`.

**Esqueleto (10 linhas):**
```sh
#!/usr/bin/env bash
port="${1:?Usage: port-killer <port>}"
pid=$(lsof -ti :"$port" 2>/dev/null) || { echo "Nenhum processo em :$port"; exit 0; }
ps -p "$pid" -o pid,comm,args
read -rp "Matar? [y/N] " ans
[[ "$ans" =~ ^[Yy] ]] && kill "$pid" && echo "Killed."
```

---

### 2. `bin/system/du-by-extension`

**O que faria:** ranking de extensão por uso de disco na pasta atual (ou path dado).

```sh
$ du-by-extension ~/Projects
12.4G  .git
 8.1G  .node_modules
 3.2G  .mp4
 1.8G  .pdf
```

**Por quê:** quando o disco enche, o "qual extensão está ocupando" não vem do `du` normal.
Hoje requer pipeline `find ... -name '*.X' | xargs du` repetido por extensão.

---

### 3. `bin/network/wifi-strength`

**O que faria:** mostra SSID atual + força do sinal (%) + canal. Cross-platform
(macOS usa `airport`, Linux usa `iwconfig`/`nmcli`).

```sh
$ wifi-strength
SSID: HomeNet5G  |  Signal: 87%  |  Channel: 36 (5GHz)
```

**Por quê:** diagnóstico Wi-Fi rápido. Substitui clicar no ícone do sistema +
abrir Network Utility. Útil quando trabalhando remoto.

---

### 4. `bin/files/dedupe`

**O que faria:** encontra arquivos duplicados por hash MD5/SHA256 em uma pasta
(recursivo). Modo `--dry-run` (default) só lista; `--delete` remove duplicatas
mantendo o primeiro.

```sh
$ dedupe ~/Downloads
3 duplicates found (4.2 MB recoverable):
  ~/Downloads/foto.jpg
    ~/Downloads/copia/foto.jpg
    ~/Downloads/backup/foto.jpg
```

**Por quê:** `fdupes` resolve mas não vem por padrão em macOS. Versão em bash
puro com `find -exec md5sum` cobre 90% dos casos. Útil pra limpar Downloads/Desktop.

---

### 5. `bin/pentest/ssl-check`

**O que faria:** audita certificado SSL de um domínio — expiração, chain,
ciphers suportados, redirects HTTP→HTTPS.

```sh
$ ssl-check google.com
Issuer:    Google Trust Services
Valid:     2026-04-20 → 2026-07-13 (62 dias restantes)
Chain:     google.com → GTS CA 1C3 → GTS Root R1 ✓
Ciphers:   TLS_AES_256_GCM_SHA384, ECDHE-RSA-AES128-GCM-SHA256
HSTS:      max-age=31536000; includeSubDomains
```

**Por quê:** complementa o `bin/pentest/checkip` (que cobre IP info). Útil
pra audit antes de deploy, ou pra debugar problema de TLS. Wrapper sobre
`openssl s_client` e `curl -vI` — 50 linhas.

---

### 6. `bin/dev/git-cleanup`

**O que faria:** remove branches locais que já foram mergeados em `main`/`master`/`develop`.
Modo `--dry-run` default.

```sh
$ git-cleanup
Branches já mergeadas em main (removerá em --apply):
  feature/login
  fix/typo-readme
  chore/deps-update
3 branches. Run with --apply pra remover.
```

**Por quê:** todo mundo acumula branches mortas. Hoje é manual: `git branch
--merged | xargs git branch -d` com pegadinhas (não deleta atual, não vê
remoto, etc).

---

### 7. `bin/text/wc-by-language`

**O que faria:** conta linhas de código por linguagem em um repo.

```sh
$ wc-by-language ~/Projects/my-app
PHP        12,432 (45.1%)
JS          8,231 (29.9%)
SQL         3,109 (11.3%)
HTML        2,541  (9.2%)
CSS         1,234  (4.5%)
```

**Por quê:** útil pra entender repo novo. Substitui `tokei` ou `cloc` (que
precisam ser instalados); versão minimal em shell + awk dá 80% do valor.
Bom complemento ao `bin/dev/count-commits` existente.

---

## Considerações finais

**Recomendação de execução (Fase 4 / Prompt #44):**

1. **Primeiro round (fixes triviais, sem mudança funcional):** adicionar
   shebang em `transfer`, corrigir encoding em `search-in-pdf`, renomear
   `convert-ogg-to-pdf` pra `convert-ogg-to-mp3`.
2. **Segundo round (modernizações de URL/API):** `tempo` via wttr.in,
   `checkip` sem yum hardcoded, `clear-snap`/`system_cleaner` com guards
   `is_linux`/`is_ubuntu`.
3. **Terceiro round (archive):** `email_list`, `roteador`,
   `convert-swfslide-to-pdf`, `convert-txt-to-ttsbook`, `get-wallpapers-hubble`
   → `archive/legacy/` (ou `archive/legacy-security/` pra `email_list`).
4. **Quarto round (novos scripts):** implementar os 7 propostos, um por
   commit. Começar por `port-killer` e `git-cleanup` (mais alta utilidade
   diária).

**Total estimado:** ~25 commits pequenos. Tempo: ~3-5 horas de revisão
manual + testes (cada modernização precisa de teste smoke).

Cada modernização deve seguir as regras do Prompt #44 em
[`PROMPTS2.md`](PROMPTS2.md): 1 commit por script, guard de deps no topo,
preservar função original.

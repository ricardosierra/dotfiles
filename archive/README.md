# Archive

Diretório de quarentena para código legado, ainda preservado por histórico mas
fora do path ativo do dotfiles. Nada aqui é sourced, copiado para `~/` ou
adicionado ao `$PATH` pelo `bin/dotfiles`.

Política completa de depreciação em [`../docs/deprecations.md`](../docs/deprecations.md).

## Categorias

### `legacy/`

Tooling obsoleto **não-perigoso** — ferramentas com use case morto ou
substituível por alternativa moderna. Exemplos: `cdrecord` (CDRW), patch
manual de binários do Firefox, manipulação direta do brew cellar para
toolchain do Rust.

### `legacy-security/`

Ferramentas **ofensivas ou destrutivas** — bootstrap automático removido.
Exemplos: instalador do BeEF, scripts que mexem em iptables sem reverse.
Quem precisar copia para fora do repo conscientemente.

### `docs-2.0/`

Documentação que foi escrita para uma reescrita "2.0" do dotfiles que
nunca aconteceu. Stubs preservados pelo histórico.

### `docs-helper/`

Snippets de `cat <<-HELP` listando aliases — tentativa antiga de gerar
`--help` por área (docker, vcs). Conteúdo pode ser integrado às funções
ativas no futuro.

## Como reativar algo

```sh
git mv archive/<categoria>/<arquivo> <local-original>
```

Os arquivos preservam o histórico no `git log --follow`.

## Como remover definitivamente

Após **1 release** (≈ próxima `vX.Y.0`) sem reclamação, remover:

```sh
git rm archive/<categoria>/<arquivo>
```

E documentar em `CHANGELOG.md` na seção `### 🔧 Técnico`.

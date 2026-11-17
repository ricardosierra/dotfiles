#!/usr/bin/env bash
# Heurística: arquivos cujo basename aparece em poucos lugares (candidato a remover).
# Mostra os 30 com menos referências. NÃO é prova de morte — só sinal.
cd "$(git rev-parse --show-toplevel)" || exit 1
{
  while IFS= read -r f; do
    base="$(basename "$f")"
    refs="$(grep -RIl "$base" . \
      --exclude-dir=.git \
      --exclude-dir=vendor \
      --exclude-dir=link \
      --exclude-dir=backups \
      --exclude-dir=archive 2>/dev/null | wc -l | tr -d ' ')"
    printf "%5s %s\n" "$refs" "$f"
  done < <(find bin source init scripts -type f -not -path '*/.*' 2>/dev/null)
} | sort -n | head -30
exit 0

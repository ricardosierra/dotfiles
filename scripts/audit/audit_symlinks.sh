#!/usr/bin/env bash
# Lista symlinks quebrados no repo.
# Usa `find -L . -type l`: -L segue symlinks; um link só aparece como type l
# quando não pode ser seguido (i.e., destino não existe).
# Portátil entre GNU e BSD find (macOS).
cd "$(git rev-parse --show-toplevel)" || exit 1
find -L . -type l \
  -not -path './.git/*' \
  -not -path './backups/*' \
  2>/dev/null
exit 0

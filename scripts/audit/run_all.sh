#!/usr/bin/env bash
# Roda todas as auditorias e salva resultados em .audit/ (gitignored).
# Uso: bash scripts/audit/run_all.sh
# Não usa `set -e` porque algumas auditorias (shellcheck/shfmt) retornam !=0
# quando acham findings, e isso é o resultado esperado, não falha.
cd "$(git rev-parse --show-toplevel)" || exit 1

OUT_DIR=".audit"
mkdir -p "$OUT_DIR"

scripts=(
  audit_symlinks
  audit_no_shebang
  audit_personal_paths
  audit_shadowing
  audit_eval
  audit_dead_files
  audit_path_health
  audit_executables
  audit_large_files
)
command -v shellcheck >/dev/null 2>&1 && scripts+=(audit_shellcheck)
command -v shfmt      >/dev/null 2>&1 && scripts+=(audit_shfmt)

echo "Rodando ${#scripts[@]} auditorias → $OUT_DIR/"
for s in "${scripts[@]}"; do
  out="$OUT_DIR/${s}.txt"
  printf '  %-26s ' "$s"
  bash "scripts/audit/${s}.sh" > "$out" 2>&1
  rc=$?
  lines=$(wc -l < "$out" | tr -d ' ')
  if [[ $rc -eq 0 ]]; then
    echo "→ $out ($lines linhas)"
  else
    # Exit !=0 esperado quando shfmt/shellcheck acham findings — não é falha
    echo "→ $out ($lines linhas, exit=$rc — findings esperados)"
  fi
done

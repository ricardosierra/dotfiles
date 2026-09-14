#!/usr/bin/env bats

setup() {
  DOTFILES="$BATS_TEST_DIRNAME/.."
  export DOTFILES
}

@test "git-hooks: clean_commit_msg.py remove trailers do Cursor, Claude, Grok, Codex e Gemini" {
  MSG_FILE="$(mktemp)"
  printf '%s\n' \
    "feat: commit teste com multiplos trailers de IA" \
    "" \
    "Corpo da mensagem do commit." \
    "" \
    "Co-authored-by: Cursor <cursoragent@cursor.com>" \
    "Co-authored-by: Claude <noreply@anthropic.com>" \
    "Co-authored-by: Grok <grok@x.ai>" \
    "Co-authored-by: Codex <codex@openai.com>" \
    "Co-authored-by: Gemini <gemini@google.com>" \
    "Made with [Cursor](https://cursor.com)" > "$MSG_FILE"

  python3 "$DOTFILES/link/.git_hooks/clean_commit_msg.py" "$MSG_FILE"

  run grep -Ei "(cursor|claude|grok|codex|gemini)" "$MSG_FILE"
  [ "$status" -ne 0 ]

  run cat "$MSG_FILE"
  [[ "$output" =~ "feat: commit teste" ]]
  [[ "$output" =~ "Corpo da mensagem do commit." ]]

  rm -f "$MSG_FILE"
}

@test "git-hooks: commit-msg executa com sucesso e limpa arquivo" {
  MSG_FILE="$(mktemp)"
  printf '%s\n' \
    "fix(landing): corrigir layout" \
    "" \
    "Co-authored-by: Cursor <cursoragent@cursor.com>" > "$MSG_FILE"

  bash "$DOTFILES/link/.git_hooks/commit-msg" "$MSG_FILE"
  run grep -i "cursor" "$MSG_FILE"
  [ "$status" -ne 0 ]

  rm -f "$MSG_FILE"
}

@test "git-hooks: pre-commit bloqueia autoria de modelo de IA" {
  export GIT_AUTHOR_NAME="Claude"
  export GIT_AUTHOR_EMAIL="claude@anthropic.com"

  run bash "$DOTFILES/link/.git_hooks/pre-commit"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "PRE-COMMIT BLOQUEADO" ]]

  unset GIT_AUTHOR_NAME
  unset GIT_AUTHOR_EMAIL
}

@test "git-hooks: pre-commit permite desenvolvedor humano" {
  export GIT_AUTHOR_NAME="Ricardo Sierra"
  export GIT_AUTHOR_EMAIL="contato@ricardosierra.com.br"

  run bash "$DOTFILES/link/.git_hooks/pre-commit"
  [ "$status" -eq 0 ]

  unset GIT_AUTHOR_NAME
  unset GIT_AUTHOR_EMAIL
}

@test "git-hooks: init/15_git.sh roda sem erros de sintaxe" {
  run bash -n "$DOTFILES/init/15_git.sh"
  [ "$status" -eq 0 ]
}

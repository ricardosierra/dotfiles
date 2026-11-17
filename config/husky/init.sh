#!/usr/bin/env sh
# Global Husky init hook
# Automatically sanitizes commits, enforces human identity, and blocks pushes containing forced AI trailers
# Portável para Linux, macOS e Windows.

# 1. Checagem de identidade no pre-commit
if [ "$n" = "pre-commit" ]; then
  AUTHOR_NAME="${GIT_AUTHOR_NAME:-$(git config --get user.name 2>/dev/null || true)}"
  AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-$(git config --get user.email 2>/dev/null || true)}"
  COMMITTER_NAME="${GIT_COMMITTER_NAME:-$(git config --get user.name 2>/dev/null || true)}"
  COMMITTER_EMAIL="${GIT_COMMITTER_EMAIL:-$(git config --get user.email 2>/dev/null || true)}"

  AI_REGEX="(cursor|cursoragent|claude|anthropic|grok|xai|x\.ai|codex|openai|chatgpt|gemini|deepmind|antigravity|copilot|devin|windsurf)"

  for id in "$AUTHOR_NAME" "$AUTHOR_EMAIL" "$COMMITTER_NAME" "$COMMITTER_EMAIL"; do
    if echo "$id" | grep -E -i -q "$AI_REGEX"; then
      echo ""
      echo "❌ [HUSKY PRE-COMMIT BLOQUEADO]"
      echo "Identidade de IA detectada no autor ou committer: '$id'"
      echo "Autor permitido: programador real."
      exit 1
    fi
  done
fi

# 2. Limpeza da mensagem no commit-msg ou prepare-commit-msg
if [ "$n" = "commit-msg" ] || [ "$n" = "prepare-commit-msg" ]; then
  if [ -n "$1" ] && [ -f "$1" ]; then
    HOOK_DIR="$HOME/.git_hooks"
    cleaned=0
    PYTHON_CMD=""
    if command -v python3 >/dev/null 2>&1; then
      PYTHON_CMD="python3"
    elif command -v python >/dev/null 2>&1; then
      PYTHON_CMD="python"
    elif command -v py >/dev/null 2>&1; then
      PYTHON_CMD="py"
    elif [ -x "/usr/bin/python3" ]; then
      PYTHON_CMD="/usr/bin/python3"
    fi

    if [ -n "$PYTHON_CMD" ] && [ -f "$HOOK_DIR/clean_commit_msg.py" ]; then
      if "$PYTHON_CMD" "$HOOK_DIR/clean_commit_msg.py" "$1" 2>/dev/null; then
        cleaned=1
      fi
    fi

    if [ "$cleaned" -eq 0 ]; then
      TMP_FILE="${1}.tmp.$$"
      grep -E -i -v '(co-authored-by|made-with|generated-by|assisted-by|authored-by|prompted-by):.*(cursor|cursoragent|anysphere|claude|anthropic|grok|xai|x\.ai|codex|openai|chatgpt|gemini|deepmind|antigravity|copilot|aider|windsurf|codeium|tabnine|supermaven|devin)' "$1" | \
      grep -E -i -v '(made with \[.*(cursor|claude|gemini|codex)|cursoragent@cursor\.com|noreply@anthropic\.com)' > "$TMP_FILE" 2>/dev/null && mv -f "$TMP_FILE" "$1"
      rm -f "$TMP_FILE"
    fi
  fi
fi

# 3. Bloqueio de push com trailers ou menções de IA
if [ "$n" = "pre-push" ]; then
  remote="$1"
  url="$2"
  zero_sha="0000000000000000000000000000000000000000"

  while read -r local_ref local_sha remote_ref remote_sha; do
    if [ "$local_sha" = "$zero_sha" ]; then
      continue
    fi

    if [ "$remote_sha" = "$zero_sha" ]; then
      range="$(git rev-list "$local_sha" --not --remotes="$remote" 2>/dev/null || echo "$local_sha")"
    else
      range="$(git rev-list "${remote_sha}..${local_sha}" 2>/dev/null)"
    fi

    for commit in $range; do
      msg="$(git log -1 --format="%B" "$commit")"
      if echo "$msg" | grep -E -i -q "(co-authored-by:\s*.*(cursor|claude|anthropic|grok|xai|x\.ai|codex|openai|chatgpt|gemini|deepmind|copilot|antigravity|windsurf|aider)|made-with:\s*.*(cursor|claude|anthropic|grok|xai|codex|openai|chatgpt|gemini|deepmind|copilot)|cursoragent@cursor\.com|noreply@anthropic\.com|made with \[.*cursor)"; then
        echo ""
        echo "❌ [HUSKY PRE-PUSH BLOQUEADO]"
        echo "O commit $commit possui co-autoria ou menção indevida de IA:"
        echo "----------------------------------------"
        echo "$msg"
        echo "----------------------------------------"
        echo "Push cancelado para evitar enviar créditos/autoria forçada de IA ao repositório remoto."
        exit 1
      fi
    done
  done
fi

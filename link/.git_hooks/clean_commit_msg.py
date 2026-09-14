#!/usr/bin/env python3
"""
Sanitizador de mensagens de commit contra autoria e trailers forçados de IA.
Suporta Python 3 em Linux, macOS e Windows.
"""
import sys
import re

AI_KEYWORDS = [
    r'cursor', r'cursoragent', r'anysphere',
    r'claude', r'anthropic',
    r'grok', r'xai', r'x\.ai',
    r'codex', r'openai', r'chatgpt',
    r'gemini', r'deepmind', r'antigravity',
    r'copilot', r'github-copilot',
    r'aider', r'windsurf', r'codeium', r'tabnine', r'supermaven', r'devin'
]
AI_JOINED = '|'.join(AI_KEYWORDS)

AI_TRAILER_PATTERN = re.compile(
    r'^\s*(?:'
    rf'(?:Co-authored-by|Made-with|Generated-by|Assisted-by|Authored-by|Prompted-by|Created-by|Committed-by):\s*.*(?:{AI_JOINED}).*'
    rf'|.*(?:Made|Generated|Assisted|Created|Written)\s+with\s+.*(?:{AI_JOINED}).*'
    rf'|.*(?:🤖|✨|⚡|🪄)?\s*(?:Generated|Created|Built|Assisted)\s+by\s+.*(?:{AI_JOINED}).*'
    rf'|.*(?:cursoragent@cursor\.com|noreply@anthropic\.com).*'
    r')\s*$',
    re.IGNORECASE
)

def clean_file(path):
    try:
        with open(path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception:
        return

    lines = content.splitlines()
    cleaned_lines = [line for line in lines if not AI_TRAILER_PATTERN.match(line)]

    # Remove linhas em branco extras no final
    while cleaned_lines and not cleaned_lines[-1].strip():
        cleaned_lines.pop()

    cleaned = '\n'.join(cleaned_lines) + ('\n' if cleaned_lines else '')

    if cleaned != content:
        try:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(cleaned)
        except Exception:
            pass

if __name__ == '__main__':
    if len(sys.argv) > 1:
        clean_file(sys.argv[1])

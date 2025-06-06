#!/usr/bin/env bash
set -euo pipefail

KEY=${OPENAI_API_KEY:-}
[[ -z $KEY ]] && { echo "⚠️  OPENAI_API_KEY is not set" >&2; exit 1; }

URL=${OPENAI_URL:-https://api.openai.com/v1/chat/completions}
MODEL=${OPENAI_MODEL:-gpt-4o-mini}

[[ $# -eq 0 ]] && { echo "usage: $(basename "$0") <prompt>"; exit 2; }
PROMPT=$*

curl -sS -N "$URL" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d @- <<EOF |
{ "model": "$MODEL",
  "stream": true,
  "messages": [ { "role": "user", "content": "$PROMPT" } ] }
EOF
jq -r --unbuffered 'select(.choices?) | .choices[0].delta.content // empty'


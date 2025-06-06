#!/usr/bin/env bash
set -euo pipefail

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq is required but not installed" >&2
    echo "Install with: brew install jq (macOS) or apt-get install jq (Ubuntu)" >&2
    exit 1
fi

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


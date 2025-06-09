#!/usr/bin/env bash
set -euo pipefail

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "⚠️  curl is required but not installed" >&2
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq is required but not installed" >&2
    echo "Install with: brew install jq (macOS) or apt-get install jq (Ubuntu)" >&2
    exit 1
fi

KEY=${LLM_SH_API_KEY:-}
[[ -z $KEY ]] && { echo "⚠️  LLM_SH_API_KEY is not set" >&2; exit 1; }

URL=${LLM_SH_URL:-https://api.openai.com/v1/chat/completions}
MODEL=${LLM_SH_MODEL:-gpt-4o-mini}


[[ $# -eq 0 ]] && { echo "usage: $(basename "$0") <prompt>"; exit 2; }
PROMPT=$*

curl -sS -N "$URL" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d @- <<EOF 2>/dev/null |
{ "model": "$MODEL",
  "stream": true,
  "messages": [ { "role": "user", "content": "$PROMPT" } ] }
EOF
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -n "$line" && "$line" == data:* ]]; then
        json_part="${line#data: }"
        if [[ "$json_part" != "[DONE]" && -n "$json_part" ]]; then
            content=$(echo "$json_part" | jq -r 'select(type == "object" and .choices?) | .choices[0].delta.content // empty' 2>/dev/null || true)
            [[ -n "$content" && "$content" != "null" ]] && printf "%s" "$content"
        fi
    fi
done
echo


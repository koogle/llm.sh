#!/usr/bin/env bash
set -euo pipefail

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "⚠️  curl is required but not installed" >&2
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
            # Extract content directly with string manipulation
            if [[ "$json_part" == *'"content":"'* ]]; then
                # Extract everything between "content":" and the next "
                content="${json_part#*\"content\":\"}"
                content="${content%%\"*}"
                # Decode \n sequences to actual newlines
                content="${content//\\n/$'\n'}"
                printf "%s" "$content"
            fi
        fi
    fi
done
echo


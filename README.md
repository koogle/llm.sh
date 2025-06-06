# bash_llm
A simple bash script to interact with LLMs from the command line.

## Setup

1. Make the script executable:
   ```bash
   chmod +x llm.sh
   ```

2. Set your API key:
   ```bash
   export LLM_SH_API_KEY="your-api-key-here"
   ```

3. (Optional) Configure the model and URL:
   ```bash
   export LLM_SH_MODEL="gpt-4o-mini"  # default
   export LLM_SH_URL="https://api.openai.com/v1/chat/completions"  # default
   ```

## Usage

```bash
./llm.sh "What is the capital of France?"
./llm.sh "Explain quantum computing in simple terms"
./llm.sh write a haiku about coding
```

## Requirements

- `jq` - Install with `brew install jq` (macOS) or `apt-get install jq` (Ubuntu)
- An OpenAI API key or compatible API endpoint

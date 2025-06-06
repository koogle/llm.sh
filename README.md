# llm.sh

A simple bash script to interact with LLMs from the command line. This is a KISS (Keep It Simple, Stupid) version with minimal dependencies, inspired by [Simon Willison's llm tool](https://github.com/simonw/llm).

## Quick Install

```bash
./install.sh
```

This will:
- Install the script as `llm` command in `~/.local/bin`
- Prompt for your OpenAI API key and save it to your shell config
- Add `~/.local/bin` to your PATH

## Manual Setup

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

After installation:
```bash
llm "What is the capital of France?"
llm "Explain quantum computing in simple terms"
llm write a haiku about coding
```

Or manually:
```bash
./llm.sh "What is the capital of France?"
```

## Requirements

- `jq` - Install with `brew install jq` (macOS) or `apt-get install jq` (Ubuntu)
- An OpenAI API key or compatible API endpoint

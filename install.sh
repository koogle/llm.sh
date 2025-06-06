#!/usr/bin/env bash
set -euo pipefail

echo "🤖 Installing bash_llm..."

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "❌ jq is required but not installed"
    echo "Install with: brew install jq (macOS) or apt-get install jq (Ubuntu)"
    exit 1
fi

# Get API key from user
echo
read -p "🔑 Enter your OpenAI API key: " -s api_key
echo

if [[ -z "$api_key" ]]; then
    echo "❌ API key cannot be empty"
    exit 1
fi

# Create ~/.local/bin if it doesn't exist
mkdir -p "$HOME/.local/bin"

# Copy script to ~/.local/bin
cp llm.sh "$HOME/.local/bin/llm"
chmod +x "$HOME/.local/bin/llm"

# Add to PATH and set API key in shell config
shell_config=""
if [[ "$SHELL" == */zsh ]]; then
    shell_config="$HOME/.zshrc"
elif [[ "$SHELL" == */bash ]]; then
    shell_config="$HOME/.bashrc"
else
    echo "⚠️  Unsupported shell: $SHELL"
    echo "Please manually add ~/.local/bin to your PATH and set LLM_SH_API_KEY"
    exit 1
fi

# Add to shell config if not already there
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$shell_config" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_config"
fi

if ! grep -q 'export LLM_SH_API_KEY=' "$shell_config" 2>/dev/null; then
    echo "export LLM_SH_API_KEY=\"$api_key\"" >> "$shell_config"
else
    # Update existing API key
    sed -i.bak "s/export LLM_SH_API_KEY=.*/export LLM_SH_API_KEY=\"$api_key\"/" "$shell_config"
fi

echo "✅ Installation complete!"
echo
echo "To use immediately, run:"
echo "  source $shell_config"
echo
echo "Or restart your terminal and then use:"
echo "  llm 'What is the weather like?'"
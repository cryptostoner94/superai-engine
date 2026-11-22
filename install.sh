#!/bin/bash
echo "--- SuperAI: Universal Deployment v3.0 ---"

# 1. Environment Detection
[[ $SHELL == *"zsh"* ]] && CONF="$HOME/.zshrc" || CONF="$HOME/.bashrc"
touch "$CONF"

# 2. Dependency Installation
python3 -m pip install google-genai --quiet --user

# 3. Require API Key
if [[ -z "${GOOGLE_API_KEY:-}" ]]; then
    echo "ERROR: GOOGLE_API_KEY is not set." >&2
    echo "Create a key in Google AI Studio, export it, then run this installer again:" >&2
    echo "  export GOOGLE_API_KEY='<your-google-ai-studio-key>'" >&2
    exit 1
fi

# 4. Refresh the alias only. A GOOGLE_API_KEY line in $CONF belongs to the user.
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' '/alias sai=/d' "$CONF"
else
    sed -i '/alias sai=/d' "$CONF"
fi
echo "alias sai='python3 ~/auto_exec.py'" >> "$CONF"

if grep -q '^export GOOGLE_API_KEY=' "$CONF"; then
    echo "WARNING: $CONF already exports GOOGLE_API_KEY."
    echo "If that line holds an older shared key, remove it and export your own key instead."
fi

# 5. Download Engine
curl -sSL https://raw.githubusercontent.com/cryptostoner94/superai-engine/main/auto_exec.py -o ~/auto_exec.py

echo "Installation Successful."
echo "Add this line to $CONF so the key is available in new shells:"
echo "  export GOOGLE_API_KEY='<your-google-ai-studio-key>'"
echo "Then run: source $CONF"

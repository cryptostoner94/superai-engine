#!/bin/bash
echo "--- SuperAI: Universal Deployment (Mac/Linux Fix) ---"

# Use python3 -m pip to avoid 'pip not found' on macOS
python3 -m pip install google-genai rich --quiet --user

# Secret Management via Doppler or Prompt
if command -v doppler &> /dev/null; then
    USER_SECRET=$(doppler secrets get GOOGLE_API_KEY --plain 2>/dev/null)
fi
if [ -z "$USER_SECRET" ]; then
    read -sp "Enter Google API Key: " USER_SECRET
    echo ""
fi

# Download Engine
curl -sSL https://raw.githubusercontent.com/cryptostoner94/superai-engine/main/auto_exec.py -o ~/auto_exec.py

# Universal Alias Injection with macOS sed compatibility
[[ $SHELL == *"zsh"* ]] && CONF="$HOME/.zshrc" || CONF="$HOME/.bashrc"
touch "$CONF"
sed -i '' '/GOOGLE_API_KEY/d' "$CONF" 2>/dev/null || sed -i '/GOOGLE_API_KEY/d' "$CONF"
sed -i '' '/alias sai=/d' "$CONF" 2>/dev/null || sed -i '/alias sai=/d' "$CONF"

echo "export GOOGLE_API_KEY=$USER_SECRET" >> "$CONF"
echo "alias sai='python3 ~/auto_exec.py'" >> "$CONF"

echo "Installation Successful. Restart terminal and type 'sai'."

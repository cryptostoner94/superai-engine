#!/bin/bash
echo "--- SuperAI: Universal Deployment (Mac/Linux Fix) ---"

# 1. Use pip3 for Mac compatibility
python3 -m pip install google-genai rich --quiet --user

# 2. Secret Management
if command -v doppler &> /dev/null; then
    USER_SECRET=$(doppler secrets get GOOGLE_API_KEY --plain 2>/dev/null)
fi
if [ -z "$USER_SECRET" ]; then
    read -sp "Enter Google API Key: " USER_SECRET
    echo ""
fi

# 3. Download Engine
curl -sSL https://raw.githubusercontent.com/cryptostoner94/superai-engine/main/auto_exec.py -o ~/auto_exec.py

# 4. Universal Alias Registration (Renaming to 'sai' to avoid 'go' conflict)
[[ $SHELL == *"zsh"* ]] && CONF="$HOME/.zshrc" || CONF="$HOME/.bashrc"

# Fix for Mac sed syntax
touch "$CONF"
sed -i.bak '/GOOGLE_API_KEY/d' "$CONF"
sed -i.bak '/alias sai=/d' "$CONF"

echo "export GOOGLE_API_KEY=$USER_SECRET" >> "$CONF"
echo "alias sai='python3 ~/auto_exec.py'" >> "$CONF"

echo "Installation Successful. RESTART TERMINAL and type 'sai'."

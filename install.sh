#!/bin/bash
# Master Installer for Harjeev Singh Kohli
echo "--- SuperAI: Universal Deployment Starting ---"

# Install Python requirements
pip install google-genai rich --quiet --user

# Secret Management (Doppler or Manual)
if command -v doppler &> /dev/null; then
    USER_SECRET=$(doppler secrets get GOOGLE_API_KEY --plain 2>/dev/null)
fi

if [ -z "$USER_SECRET" ]; then
    read -sp "Enter Google API Key: " USER_SECRET
    echo ""
fi

# Download Engine
curl -sSL https://raw.githubusercontent.com/cryptostoner94/superai-engine/main/auto_exec.py -o ~/auto_exec.py

# Permanent Alias for 'go'
[[ $SHELL == *"zsh"* ]] && CONF="$HOME/.zshrc" || CONF="$HOME/.bashrc"
sed -i '/GOOGLE_API_KEY/d' "$CONF"
sed -i '/alias go=/d' "$CONF"
echo "export GOOGLE_API_KEY=$USER_SECRET" >> "$CONF"
echo "alias go='python3 ~/auto_exec.py'" >> "$CONF"

echo "Installation Successful. Restart terminal or type 'source $CONF' then 'go'."

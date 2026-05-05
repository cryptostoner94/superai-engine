#!/bin/bash
echo "--- SuperAI: Universal Deployment (Mac/Linux Fix) ---"

# 1. Mac-Compatible Package Install
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

# 4. Universal Alias (Using 'sai' to avoid 'go' conflict)
[[ $SHELL == *"zsh"* ]] && CONF="$HOME/.zshrc" || CONF="$HOME/.bashrc"
touch "$CONF"

# Mac-specific sed cleanup
sed -i '' '/GOOGLE_API_KEY/d' "$CONF" 2>/dev/null || sed -i '/GOOGLE_API_KEY/d' "$CONF"
sed -i '' '/alias sai=/d' "$CONF" 2>/dev/null || sed -i '/alias sai=/d' "$CONF"

# Save New Config
echo "export GOOGLE_API_KEY=$USER_SECRET" >> "$CONF"
echo "alias sai='python3 ~/auto_exec.py'" >> "$CONF"

echo "Installation Successful. Type 'source $CONF' then 'sai'."

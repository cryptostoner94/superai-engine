#!/bin/bash
echo "--- SuperAI: Universal Deployment v3.0 ---"

# 1. Environment Detection
[[ $SHELL == *"zsh"* ]] && CONF="$HOME/.zshrc" || CONF="$HOME/.bashrc"
touch "$CONF"

# 2. Dependency Installation
python3 -m pip install google-genai --quiet --user

# 3. Clean and Set API Key
# Using the key you provided: AIzaSyAK71roUt79u12w-4QWoGo735l-OzgdJFU
K="AIzaSyAK71roUt79u12w-4QWoGo735l-OzgdJFU"
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' '/export GOOGLE_API_KEY=/d' "$CONF"
    sed -i '' '/alias sai=/d' "$CONF"
else
    sed -i '/export GOOGLE_API_KEY=/d' "$CONF"
    sed -i '/alias sai=/d' "$CONF"
fi

echo "export GOOGLE_API_KEY='$K'" >> "$CONF"
echo "alias sai='python3 ~/auto_exec.py'" >> "$CONF"

# 4. Download Engine
curl -sSL https://raw.githubusercontent.com/cryptostoner94/superai-engine/main/auto_exec.py -o ~/auto_exec.py

echo "Installation Successful. Run: source $CONF"

#!/bin/bash
# High-Precision Autonomous Engine Installer
# Target: Harjeev Singh Kohli | CLI: superai

echo "--- Initializing SuperAI Engine Deployment ---"

# 1. Install required Python packages
pip install google-genai rich --quiet

# 2. Doppler Secret Sync Logic
if command -v doppler &> /dev/null; then
    echo "Checking Doppler for GOOGLE_API_KEY..."
    # Attempt to pull key; fallback if Doppler isn't logged in or key is missing
    DOPPLER_KEY=$(doppler secrets get GOOGLE_API_KEY --plain 2>/dev/null)
    if [ -n "$DOPPLER_KEY" ]; then
        USER_SECRET=$DOPPLER_KEY
        echo "Successfully synced key from Doppler."
    else
        read -sp "Key not found in Doppler. Paste valid Google API Key: " USER_SECRET
        echo ""
    fi
else
    echo "Doppler CLI not detected."
    read -sp "Paste valid Google API Key: " USER_SECRET
    echo ""
fi

# 3. Download the core execution logic from your repo
echo "Downloading engine logic..."
curl -sSL https://raw.githubusercontent.com/cryptostoner94/superai-engine/main/auto_exec.py -o ~/auto_exec.py

# 4. Persistence Configuration (Clean existing to avoid duplicates)
sed -i '/export GOOGLE_API_KEY=/d' ~/.bashrc
sed -i '/alias go=/d' ~/.bashrc

echo "export GOOGLE_API_KEY=$USER_SECRET" >> ~/.bashrc
echo "alias go='python3 ~/auto_exec.py'" >> ~/.bashrc

# 5. Activation for current shell
export GOOGLE_API_KEY=$USER_SECRET
alias go='python3 ~/auto_exec.py'

echo "--- Deployment Complete ---"
echo "Type 'go' to enter the autonomous space or run a single command."

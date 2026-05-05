#!/bin/bash
# High-Precision Autonomous Engine Installer
# Target: Harjeev Singh Kohli

echo "Initializing SuperAI Deployment..."
pip install google-genai rich --quiet

# Securely capture API Key without terminal echo
read -sp "Paste your Google API Key: " USER_SECRET
echo -e "\nConfiguring environment..."

# Download the main execution logic
curl -sSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/superai-engine/main/auto_exec.py -o ~/auto_exec.py

# Set Persistence
echo "export GOOGLE_API_KEY=$USER_SECRET" >> ~/.bashrc
echo "alias go='python3 ~/auto_exec.py'" >> ~/.bashrc

# Activate for current session
export GOOGLE_API_KEY=$USER_SECRET
alias go='python3 ~/auto_exec.py'

echo "Deployment successful. Type 'go' to enter the SuperAI space."

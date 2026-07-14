#!/bin/bash

echo "🔐 Starting TCP tunnel for VNC (port 5900)..."

if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok is not installed!"
    echo ""
    echo "📦 Installing ngrok..."

    if [ -f /etc/debian_version ]; then
        curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
        echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
        sudo apt-get update && sudo apt-get install -y ngrok
    elif [ -f /etc/redhat-release ]; then
        curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/pki/rpm-gpg/NGROK_GPG_KEY >/dev/null
        echo -e "[ngrok]\nname=ngrok\nbaseurl=https://ngrok-agent.s3.amazonaws.com\nenabled=1\ngpgcheck=1\ngpgkey=/etc/pki/rpm-gpg/NGROK_GPG_KEY" | sudo tee /etc/yum.repos.d/ngrok.repo
        sudo yum install -y ngrok
    else
        echo "⚠️  Could not detect OS. Please install ngrok manually from https://ngrok.com/download"
        exit 1
    fi
fi

export NGROK_CONFIG_DIR="/tmp/.ngrok"
mkdir -p "$NGROK_CONFIG_DIR"

echo ""
echo "🚀 Starting ngrok TCP tunnel..."
echo "💡 Your VNC connection details will appear below!"
echo ""

ngrok tcp 5900

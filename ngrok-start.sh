#!/bin/bash

# ngrok-start.sh - Start ngrok tunnel for VNC port 5900

echo "🔐 Starting ngrok tunnel for VNC (port 5900)..."

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok is not installed!"
    echo ""
    echo "📦 Installing ngrok..."
    
    # Install ngrok on Linux (Debian/Ubuntu)
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

# Check if ngrok auth token is configured
if [ -z "$NGROK_AUTHTOKEN" ] && [ ! -f ~/.ngrok2/ngrok.yml ] && [ ! -f ~/.config/ngrok/ngrok.yml ]; then
    echo ""
    echo "⚠️  ngrok auth token not found!"
    echo "📝 Please get your auth token from https://dashboard.ngrok.com/get-started/your-authtoken"
    echo ""
    echo "Then set it as environment variable:"
    echo "  export NGROK_AUTHTOKEN=YOUR_TOKEN"
    echo "  ./ngrok-start.sh"
    echo ""
    exit 1
fi

# Set ngrok config directory to /tmp to avoid permission issues in Cloud Shell
export NGROK_CONFIG_DIR="/tmp/.ngrok"
mkdir -p "$NGROK_CONFIG_DIR"

# Start ngrok tunnel for port 5900
echo ""
echo "🚀 Starting ngrok tunnel..."
echo "💡 Your VNC connection details will appear below!"
echo ""

if [ -n "$NGROK_AUTHTOKEN" ]; then
    ngrok tcp 5900 --authtoken "$NGROK_AUTHTOKEN"
else
    ngrok tcp 5900
fi

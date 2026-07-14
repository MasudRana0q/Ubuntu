#!/bin/bash

# tunnel-start.sh - Start a TCP tunnel using localhost.run (FREE, no card required!)

echo "🔐 Starting tunnel for VNC (port 5900)..."

# Check if ssh is installed
if ! command -v ssh &> /dev/null; then
    echo "❌ ssh is not installed!"
    exit 1
fi

# Create .ssh directory in /tmp to avoid permission issues (for Cloud Shell)
export SSH_DIR="/tmp/.ssh"
mkdir -p "$SSH_DIR"
export KNOWN_HOSTS="$SSH_DIR/known_hosts"
touch "$KNOWN_HOSTS"

echo ""
echo "🚀 Starting localhost.run tunnel (FREE, no card required)..."
echo "💡 Your VNC connection details will appear below!"
echo ""

# Start localhost.run tunnel
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile="$KNOWN_HOSTS" -R 0:localhost:5900 localhost.run

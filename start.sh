#!/bin/bash

# Load common helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/docker-common.sh"
source "$SCRIPT_DIR/scripts/ngrok-common.sh"

MODE="${1:-default}"

# Create data directories
mkdir -p data/home data/shared

# Decide whether to reuse, rebuild, or pull the image
echo "🔍 Checking Docker image mode..."

# Stop existing container if running
stop_ngrok_tunnel
stop_container

if [ "$MODE" = "rebuild" ] || [ "$MODE" = "mobile-rebuild" ]; then
    echo "📦 Rebuilding Docker image..."
    build_image && run_container
elif [ "$MODE" = "pull" ] || [ "$MODE" = "mobile-pull" ]; then
    echo "📥 Pulling Docker image instead of building..."
    pull_image && run_container
else
    echo "📦 Checking local Docker image..."
    ensure_image && run_container
fi

if [ $? -eq 0 ]; then
    echo -e "\n✅ Container started successfully!"
    echo -e "📝 How to connect:"
    echo -e "   1. With a VNC client (local): Host = localhost, Port = 5900, Password = ubuntu"
    echo -e "   2. With a browser (mobile/desktop): http://localhost:6900/vnc.html"
    echo -e "   3. On Google Cloud Shell: Use Web Preview on port 6900"
    echo -e "   4. For mobile access from anywhere (FREE): Run ./web-tunnel.sh, then open the URL + /vnc.html!"
    echo -e "   💡 Tip: On mobile, just open the ngrok URL in your browser!"

    if [ "$MODE" = "mobile" ] || [ "$MODE" = "mobile-rebuild" ] || [ "$MODE" = "mobile-pull" ]; then
        echo -e "\n⏳ Waiting for the container to become ready..."
        sleep 20
        "$SCRIPT_DIR/healthcheck.sh"
        echo -e "\n📱 Opening RVNC mobile tunnel..."
        "$SCRIPT_DIR/tcp-tunnel.sh"
    fi
else
    echo -e "\n❌ Failed to start container!"
    exit 1
fi

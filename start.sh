#!/bin/bash

# Load common helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/docker-common.sh"

# Create data directories
mkdir -p data/home data/shared

# Check if we need to rebuild the image
echo "🔍 Checking if we need to rebuild the image..."
# We'll rebuild if Dockerfile, supervisord.conf, or start-vnc.sh changed
# For simplicity, we'll rebuild every time for now, but we can optimize later
# But for now, let's just proceed

# Stop existing container if running
stop_container

# Build and run
echo "📦 Building Docker image (using cache if possible)..."
build_image && run_container

if [ $? -eq 0 ]; then
    echo -e "\n✅ Container started successfully!"
    echo -e "📝 How to connect:"
    echo -e "   1. With a VNC client (local): Host = localhost, Port = 5900, Password = ubuntu"
    echo -e "   2. With a browser (mobile/desktop): http://localhost:6900/vnc.html"
    echo -e "   3. On Google Cloud Shell: Use Web Preview on port 6900"
    echo -e "   4. For mobile access from anywhere (FREE): Run ./web-tunnel.sh, then open the URL + /vnc.html!"
    echo -e "   💡 Tip: On mobile, just open the ngrok URL in your browser!"
else
    echo -e "\n❌ Failed to start container!"
    exit 1
fi

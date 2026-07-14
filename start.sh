#!/bin/bash

# Load common helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/docker-common.sh"

# Create data directories
mkdir -p data/home data/shared

# Stop existing container if running
stop_container

# Build and run
build_image && run_container

if [ $? -eq 0 ]; then
    echo -e "\n✅ Container started successfully!"
    echo -e "📝 How to connect:"
    echo -e "   1. With a VNC client (mobile/desktop): Host = localhost, Port = 5900, Password = ubuntu"
    echo -e "   2. With a browser (mobile/desktop): http://localhost:6900/vnc.html"
    echo -e "   3. On Google Cloud Shell: Use Web Preview on port 6900"
    echo -e "   💡 Tip: On mobile, use AVNC or RealVNC Viewer for best experience!"
else
    echo -e "\n❌ Failed to start container!"
    exit 1
fi

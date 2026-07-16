#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/docker-common.sh"
source "$SCRIPT_DIR/scripts/ngrok-common.sh"

stop_ngrok_tunnel
stop_container

if [ $? -eq 0 ]; then
    echo "✅ Container stopped successfully!"
else
    echo "❌ Failed to stop container!"
    exit 1
fi

#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/docker-common.sh"

restart_container

if [ $? -eq 0 ]; then
    echo "✅ Container restarted successfully!"
else
    echo "❌ Failed to restart container!"
    exit 1
fi

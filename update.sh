#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/docker-common.sh"

echo "🔄 Updating project..."
git fetch origin
git reset --hard origin/main

stop_container
build_image && run_container

if [ $? -eq 0 ]; then
    echo "✅ Container updated and restarted successfully!"
else
    echo "❌ Failed to update container!"
    exit 1
fi

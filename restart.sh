#!/bin/bash

echo "🔄 Restarting Ubuntu Desktop..."

docker compose restart

if [ $? -eq 0 ]; then
    echo "✅ Container restarted successfully!"
else
    echo "❌ Failed to restart container!"
    exit 1
fi

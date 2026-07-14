#!/bin/bash

echo "🛑 Stopping Ubuntu Desktop..."

docker compose down

if [ $? -eq 0 ]; then
    echo "✅ Container stopped successfully!"
else
    echo "❌ Failed to stop container!"
    exit 1
fi

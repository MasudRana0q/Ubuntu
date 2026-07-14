#!/bin/bash

echo "🛑 Stopping Ubuntu Desktop..."

if command -v docker-compose &> /dev/null; then
    docker-compose down
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
    docker compose down
else
    echo "❌ Docker Compose not found!"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✅ Container stopped successfully!"
else
    echo "❌ Failed to stop container!"
    exit 1
fi

#!/bin/bash

echo "🔄 Restarting Ubuntu Desktop..."

if command -v docker-compose &> /dev/null; then
    docker-compose restart
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
    docker compose restart
else
    echo "❌ Docker Compose not found!"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✅ Container restarted successfully!"
else
    echo "❌ Failed to restart container!"
    exit 1
fi

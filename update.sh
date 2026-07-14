#!/bin/bash

echo "🔄 Updating Ubuntu Desktop..."

git pull origin main

if command -v docker-compose &> /dev/null; then
    docker-compose down
    docker-compose up -d --build
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
    docker compose down
    docker compose up -d --build
else
    echo "❌ Docker Compose not found!"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✅ Container updated and restarted successfully!"
else
    echo "❌ Failed to update container!"
    exit 1
fi

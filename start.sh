#!/bin/bash

echo "🚀 Starting Ubuntu Desktop with KasmVNC..."

if command -v docker-compose &> /dev/null; then
    docker-compose up -d --build
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
    docker compose up -d --build
else
    echo "❌ Docker Compose not found!"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully!"
    echo "📱 Access at: http://localhost:6901"
else
    echo "❌ Failed to start container!"
    exit 1
fi

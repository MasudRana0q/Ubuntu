#!/bin/bash

echo "🚀 Starting Ubuntu Desktop with KasmVNC..."

docker compose up -d --build

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully!"
    echo "📱 Access at: http://localhost:6901"
else
    echo "❌ Failed to start container!"
    exit 1
fi

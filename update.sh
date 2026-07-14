#!/bin/bash

echo "🔄 Updating Ubuntu Desktop..."

git pull origin main

docker compose down

docker compose up -d --build

if [ $? -eq 0 ]; then
    echo "✅ Container updated and restarted successfully!"
else
    echo "❌ Failed to update container!"
    exit 1
fi

#!/bin/bash

echo "🔍 Checking container health..."

docker compose ps

docker compose logs --tail=20

docker compose exec ubuntu-desktop curl -f http://localhost:6901/ 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Container is healthy!"
else
    echo "❌ Container is unhealthy!"
    exit 1
fi

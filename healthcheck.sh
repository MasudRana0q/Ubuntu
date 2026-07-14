#!/bin/bash

echo "🔍 Checking container health..."

if command -v docker-compose &> /dev/null; then
    docker-compose ps
    docker-compose logs --tail=20
    docker-compose exec ubuntu-desktop curl -f http://localhost:6901/ 2>/dev/null
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
    docker compose ps
    docker compose logs --tail=20
    docker compose exec ubuntu-desktop curl -f http://localhost:6901/ 2>/dev/null
else
    echo "❌ Docker Compose not found!"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✅ Container is healthy!"
else
    echo "❌ Container is unhealthy!"
    exit 1
fi

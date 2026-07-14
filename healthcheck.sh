#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/scripts/docker-common.sh"

echo "🔍 Checking container health..."

setup_docker_env
require_docker

if ! container_exists; then
    echo "❌ Container ${CONTAINER_NAME} does not exist."
    exit 1
fi

docker ps -a --filter "name=^/${CONTAINER_NAME}$"
docker logs --tail 20 "${CONTAINER_NAME}"

if container_running && docker exec "${CONTAINER_NAME}" curl -fsS "http://localhost:6901/" >/dev/null 2>&1; then
    echo "✅ Container is healthy!"
else
    echo "❌ Container is unhealthy!"
    exit 1
fi

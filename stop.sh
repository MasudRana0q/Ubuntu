#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/scripts/docker-common.sh"

echo "🛑 Stopping Ubuntu Desktop..."

setup_docker_env
require_docker

if container_exists; then
    docker rm -f "${CONTAINER_NAME}"
    echo "✅ Container stopped successfully!"
else
    echo "ℹ️ Container ${CONTAINER_NAME} is not running."
fi

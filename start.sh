#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/scripts/docker-common.sh"

echo "🚀 Starting Ubuntu Desktop with KasmVNC..."

setup_docker_env
require_docker

echo "📦 Building image ${IMAGE_NAME}:latest ..."
build_image

echo "▶️ Starting container ${CONTAINER_NAME} ..."
run_container

echo "✅ Container started successfully!"
echo "🌐 Browser URL: http://localhost:${VNC_PORT}"
echo "🔐 Password: ${VNC_PASSWORD}"
echo "📁 Shared folder: ${DATA_SHARED}"

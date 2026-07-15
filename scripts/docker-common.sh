#!/bin/bash

# Common Docker helper functions for Ubuntu Desktop project

IMAGE_NAME="${IMAGE_NAME:-ubuntu-desktop-vnc}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
CONTAINER_NAME="${CONTAINER_NAME:-ubuntu-desktop-vnc}"

# Set Docker config directory to avoid permission issues in Cloud Shell
export DOCKER_CONFIG="${TMPDIR:-/tmp}/.docker"
mkdir -p "$DOCKER_CONFIG"

build_image() {
    echo "📦 Building Docker image: $FULL_IMAGE_NAME"
    docker build -t "$FULL_IMAGE_NAME" .
}

pull_image() {
    echo "📥 Pulling Docker image: $FULL_IMAGE_NAME"
    docker pull "$FULL_IMAGE_NAME"
}

ensure_image() {
    if docker image inspect "$FULL_IMAGE_NAME" >/dev/null 2>&1; then
        echo "✅ Existing Docker image found: $FULL_IMAGE_NAME"
        return 0
    fi

    echo "📦 No local image found. Building it now..."
    build_image
}

run_container() {
    echo "🚀 Starting container: $CONTAINER_NAME"
    docker run -d \
        --name "$CONTAINER_NAME" \
        --restart unless-stopped \
        -p 5900:5900 \
        -p 6900:6900 \
        -v "$(pwd)/data/home:/home/ubuntu" \
        -v "$(pwd)/data/shared:/shared" \
        "$FULL_IMAGE_NAME"
}

stop_container() {
    echo "🛑 Stopping container: $CONTAINER_NAME"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
}

restart_container() {
    echo "🔄 Restarting container: $CONTAINER_NAME"
    docker restart "$CONTAINER_NAME"
}

check_health() {
    echo "🔍 Checking container: $CONTAINER_NAME"
    docker ps -a --filter "name=^/$CONTAINER_NAME$"
    echo -e "\n📜 Logs (last 20 lines):"
    docker logs --tail 20 "$CONTAINER_NAME" 2>/dev/null || true
}

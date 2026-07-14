#!/bin/bash

# Common Docker helper functions for Ubuntu Desktop project

IMAGE_NAME="ubuntu-desktop-vnc"
CONTAINER_NAME="ubuntu-desktop-vnc"

# Set Docker config directory to avoid permission issues in Cloud Shell
export DOCKER_CONFIG="${TMPDIR:-/tmp}/.docker"
mkdir -p "$DOCKER_CONFIG"

build_image() {
    echo "📦 Building Docker image: $IMAGE_NAME:latest"
    docker build -t "$IMAGE_NAME:latest" .
}

run_container() {
    echo "🚀 Starting container: $CONTAINER_NAME"
    docker run -d \
        --name "$CONTAINER_NAME" \
        --restart unless-stopped \
        -p 5900:5900 \
        -v "$(pwd)/data/home:/home/ubuntu" \
        -v "$(pwd)/data/shared:/shared" \
        "$IMAGE_NAME:latest"
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
    docker logs --tail 20 "$CONTAINER_NAME" 2>/dev/null || true
}

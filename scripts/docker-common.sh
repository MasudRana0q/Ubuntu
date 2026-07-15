#!/bin/bash

# Common Docker helper functions for Ubuntu Desktop project

IMAGE_NAME="${IMAGE_NAME:-ubuntu-desktop-vnc}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
CONTAINER_NAME="${CONTAINER_NAME:-ubuntu-desktop-vnc}"
IMAGE_FINGERPRINT_LABEL="ubuntu.build_fingerprint"

# Set Docker config directory to avoid permission issues in Cloud Shell
export DOCKER_CONFIG="${TMPDIR:-/tmp}/.docker"
mkdir -p "$DOCKER_CONFIG"

build_image() {
    local fingerprint
    fingerprint="$(get_image_fingerprint)"

    echo "📦 Building Docker image: $FULL_IMAGE_NAME"
    docker build --label "${IMAGE_FINGERPRINT_LABEL}=${fingerprint}" -t "$FULL_IMAGE_NAME" .
}

pull_image() {
    echo "📥 Pulling Docker image: $FULL_IMAGE_NAME"
    docker pull "$FULL_IMAGE_NAME"
}

ensure_image() {
    local current_fingerprint existing_fingerprint
    current_fingerprint="$(get_image_fingerprint)"

    if docker image inspect "$FULL_IMAGE_NAME" >/dev/null 2>&1; then
        existing_fingerprint="$(docker image inspect -f "{{ index .Config.Labels \"$IMAGE_FINGERPRINT_LABEL\" }}" "$FULL_IMAGE_NAME" 2>/dev/null || true)"
    else
        existing_fingerprint=""
    fi

    if [ -n "$existing_fingerprint" ] && [ "$existing_fingerprint" = "$current_fingerprint" ]; then
        echo "✅ Existing Docker image matches current code: $FULL_IMAGE_NAME"
        return 0
    fi

    if [ -n "$existing_fingerprint" ]; then
        echo "🔄 Docker image is outdated. Rebuilding..."
    else
        echo "📦 No matching local image found. Building it now..."
    fi

    build_image
}

get_image_fingerprint() {
    sha256sum Dockerfile config/supervisord.conf scripts/start-vnc.sh | sha256sum | awk '{print $1}'
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

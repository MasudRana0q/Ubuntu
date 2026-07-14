#!/bin/bash

set -u

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="${PROJECT_ROOT}/.runtime"
DOCKER_CONFIG_DIR="${DOCKER_CONFIG_DIR:-${RUNTIME_DIR}/docker-config}"
IMAGE_NAME="${IMAGE_NAME:-ubuntu-desktop-kasm}"
CONTAINER_NAME="${CONTAINER_NAME:-ubuntu-desktop}"
VNC_PORT="${VNC_PORT:-6901}"
VNC_PASSWORD="${VNC_PASSWORD:-ubuntu}"
VNC_RESOLUTION="${VNC_RESOLUTION:-1280x720}"
DATA_HOME="${DATA_HOME:-${PROJECT_ROOT}/data/home}"
DATA_SHARED="${DATA_SHARED:-${PROJECT_ROOT}/data/shared}"

ensure_runtime_dirs() {
    mkdir -p "${RUNTIME_DIR}" "${DOCKER_CONFIG_DIR}" "${DATA_HOME}" "${DATA_SHARED}"
}

setup_docker_env() {
    ensure_runtime_dirs
    export DOCKER_CONFIG="${DOCKER_CONFIG_DIR}"
}

require_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "❌ Docker CLI পাওয়া যায়নি। আগে Docker ইনস্টল করুন।"
        exit 1
    fi

    if ! docker info >/dev/null 2>&1; then
        echo "❌ Docker daemon অ্যাক্সেস করা যাচ্ছে না। Cloud Shell-এ আগে Docker environment চালু আছে কি না দেখুন।"
        exit 1
    fi
}

container_exists() {
    docker ps -a --format '{{.Names}}' | grep -Fx "${CONTAINER_NAME}" >/dev/null 2>&1
}

container_running() {
    docker ps --format '{{.Names}}' | grep -Fx "${CONTAINER_NAME}" >/dev/null 2>&1
}

build_image() {
    docker build --tag "${IMAGE_NAME}:latest" "${PROJECT_ROOT}"
}

run_container() {
    if container_exists; then
        docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || return 1
    fi

    docker run -d \
        --name "${CONTAINER_NAME}" \
        --restart unless-stopped \
        -p "${VNC_PORT}:6901" \
        -e VNC_PORT=6901 \
        -e VNC_PASSWORD="${VNC_PASSWORD}" \
        -e VNC_RESOLUTION="${VNC_RESOLUTION}" \
        -v "${DATA_HOME}:/home/ubuntu" \
        -v "${DATA_SHARED}:/shared" \
        "${IMAGE_NAME}:latest"
}

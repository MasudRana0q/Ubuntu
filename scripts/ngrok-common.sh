#!/bin/bash

NGROK_CONFIG_DIR="${NGROK_CONFIG_DIR:-/tmp/.ngrok}"
NGROK_CONFIG_FILE="${NGROK_CONFIG_FILE:-$NGROK_CONFIG_DIR/ngrok.yml}"
NGROK_TOKEN_FILE="${NGROK_TOKEN_FILE:-$NGROK_CONFIG_DIR/authtoken}"

ensure_ngrok_installed() {
    if command -v ngrok >/dev/null 2>&1; then
        return 0
    fi

    echo "📦 Installing ngrok..."

    if [ -f /etc/debian_version ]; then
        curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
        echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list >/dev/null
        sudo apt-get update && sudo apt-get install -y ngrok
    elif [ -f /etc/redhat-release ]; then
        curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/pki/rpm-gpg/NGROK_GPG_KEY >/dev/null
        echo -e "[ngrok]\nname=ngrok\nbaseurl=https://ngrok-agent.s3.amazonaws.com\nenabled=1\ngpgcheck=1\ngpgkey=/etc/pki/rpm-gpg/NGROK_GPG_KEY" | sudo tee /etc/yum.repos.d/ngrok.repo >/dev/null
        sudo yum install -y ngrok
    else
        echo "❌ Could not detect OS for ngrok installation."
        exit 1
    fi
}

save_ngrok_token() {
    local token="$1"

    if [ -z "$token" ]; then
        echo "❌ ngrok token পাওয়া যায়নি।"
        exit 1
    fi

    mkdir -p "$NGROK_CONFIG_DIR"
    printf '%s\n' "$token" > "$NGROK_TOKEN_FILE"
    chmod 600 "$NGROK_TOKEN_FILE"

    ngrok config add-authtoken "$token" --config "$NGROK_CONFIG_FILE" >/dev/null

    echo "✅ ngrok token save হয়েছে।"
}

ensure_ngrok_auth() {
    mkdir -p "$NGROK_CONFIG_DIR"

    if [ -n "${NGROK_AUTHTOKEN:-}" ]; then
        ngrok config add-authtoken "$NGROK_AUTHTOKEN" --config "$NGROK_CONFIG_FILE" >/dev/null
        return 0
    fi

    if [ -f "$NGROK_TOKEN_FILE" ]; then
        ngrok config add-authtoken "$(cat "$NGROK_TOKEN_FILE")" --config "$NGROK_CONFIG_FILE" >/dev/null
        return 0
    fi

    if [ -f "$NGROK_CONFIG_FILE" ] && grep -q "authtoken:" "$NGROK_CONFIG_FILE"; then
        return 0
    fi

    echo "❌ ngrok token set করা নেই।"
    echo "👉 আগে এই কমান্ড একবার চালান:"
    echo "   ./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN"
    exit 1
}

start_ngrok_tcp() {
    echo ""
    echo "🚀 Starting ngrok TCP tunnel..."
    echo "💡 RVNC Viewer-এর জন্য host এবং port নিচে দেখাবে।"
    echo ""
    ngrok tcp 5900 --config "$NGROK_CONFIG_FILE"
}

start_ngrok_http() {
    echo ""
    echo "🚀 Starting ngrok HTTP tunnel..."
    echo "💡 URL নিচে দেখাবে। শেষে /vnc.html যোগ করবেন।"
    echo ""
    ngrok http 6900 --config "$NGROK_CONFIG_FILE"
}

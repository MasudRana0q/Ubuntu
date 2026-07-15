#!/bin/bash

# web-tunnel.sh - Start ngrok HTTP tunnel for noVNC web interface (port 6900)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/ngrok-common.sh"

echo "🔐 Starting web tunnel for noVNC (port 6900)..."

ensure_ngrok_installed
ensure_ngrok_auth
start_ngrok_http

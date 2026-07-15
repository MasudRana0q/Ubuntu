#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/ngrok-common.sh"

echo "🔐 Starting TCP tunnel for VNC (port 5900)..."

ensure_ngrok_installed
ensure_ngrok_auth
start_ngrok_tcp

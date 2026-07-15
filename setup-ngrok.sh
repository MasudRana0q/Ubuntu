#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/ngrok-common.sh"

TOKEN="${1:-}"

if [ -z "$TOKEN" ]; then
    echo "❌ ব্যবহার: ./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN"
    exit 1
fi

ensure_ngrok_installed
save_ngrok_token "$TOKEN"

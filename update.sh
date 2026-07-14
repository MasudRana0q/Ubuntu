#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Updating Ubuntu Desktop..."

git fetch origin
git pull --ff-only origin main

"${SCRIPT_DIR}/stop.sh"
"${SCRIPT_DIR}/start.sh"

echo "✅ Container updated and restarted successfully!"

#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Restarting Ubuntu Desktop..."

"${SCRIPT_DIR}/stop.sh"
"${SCRIPT_DIR}/start.sh"

echo "✅ Container restarted successfully!"

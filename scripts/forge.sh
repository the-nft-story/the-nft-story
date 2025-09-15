#!/usr/bin/env bash
# Proxy for the 'forge' command using Docker Compose
# Usage: ./scripts/forge.sh [forge arguments]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIRECTORY="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIRECTORY"

# Ensure foundry service is up
docker-compose up -d foundry

# Forward all arguments to forge inside the foundry container
docker-compose exec foundry forge "$@"
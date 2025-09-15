#!/usr/bin/env bash
# Start development shell inside Foundry Docker container

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIRECTORY="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIRECTORY"

echo ""
echo "Entering Foundry container shell. Type 'exit' to leave."
echo ""

docker compose run --rm -it foundry bash

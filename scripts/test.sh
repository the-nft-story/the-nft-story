#!/usr/bin/env bash
# Test runner script
# Usage: ./scripts/test.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIRECTORY="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIRECTORY"

CMD="forge test $*"
docker-compose run --rm foundry "$CMD"

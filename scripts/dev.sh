#!/usr/bin/env bash
# Start development shell inside Foundry Docker container

set -euo pipefail

echo ""
echo "Starting Foundry development container..."
echo ""

docker-compose up -d foundry

docker-compose exec foundry forge --version

echo ""
echo "Entering Foundry container shell. Type 'exit' to leave."
echo ""

docker-compose exec foundry bash

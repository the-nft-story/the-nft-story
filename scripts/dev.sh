#!/bin/bash
# Start development environment
# Minimal script following "Do The Simplest Thing That Could Possibly Work"

set -e

echo "Starting NFT Story development environment..."
docker-compose up -d foundry

echo "Development container is running. Use:"
echo "  docker-compose exec foundry bash"
echo "to enter the development shell."
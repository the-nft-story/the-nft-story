#!/bin/bash
# Build contracts in Docker container
# Minimal script following "Do The Simplest Thing That Could Possibly Work"

set -e

echo "Building contracts in Docker container..."
docker-compose run --rm foundry forge build
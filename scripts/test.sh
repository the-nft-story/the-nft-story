#!/bin/bash
# Run tests in Docker container
# Minimal script following "Do The Simplest Thing That Could Possibly Work"

set -e

echo "Running tests in Docker container..."
docker-compose run --rm foundry forge test
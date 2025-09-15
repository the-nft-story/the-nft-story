#!/bin/bash

# Clean script for The NFT Story development environment
# Forces complete rebuild of Docker containers and restarts services

set -e

# Function to run command and indent output
run_indented() {
    "$@" 2>&1 | sed 's/^/    * /'
}

echo "🧹 Cleaning The NFT Story development environment..."

# Stop and remove all containers, networks, volumes
echo "📦 Stopping and removing containers..."
run_indented docker-compose down --volumes --remove-orphans

# Remove all images related to this project
echo "🗑️  Removing project images..."
run_indented docker-compose down --rmi all 2>/dev/null || true

# Prune Docker system (remove unused containers, networks, images, cache)
echo "🔄 Pruning Docker system..."
run_indented docker system prune -f

# Rebuild all containers from scratch
echo "🔨 Rebuilding containers from scratch..."
run_indented docker-compose build --no-cache --pull

echo "✅ Clean complete! Development environment rebuilt"

# Minimal Foundry development environment using official image
# Reference: https://getfoundry.sh/guides/foundry-in-docker
FROM ghcr.io/foundry-rs/foundry:latest

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Build contracts by default
RUN forge build

# Default command for development
CMD ["bash"]
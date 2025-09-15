#!/usr/bin/env bash
# Environment initialization script
# Usage: source ./scripts/env.sh

# Exit if not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ This script must be sourced, not executed directly"
    echo "Usage: source ./scripts/env.sh"
    exit 1
fi

# Get the project directory (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 Initializing development environment..."

# Source .env file if it exists
if [[ -f "$PROJECT_DIR/.env" ]]; then
    echo "📄 Loading environment variables from .env"
    set -a  # automatically export all variables
    source "$PROJECT_DIR/.env"
    set +a  # disable automatic export
fi

# Add ./bin to PATH if not already present
BIN_PATH="$PROJECT_DIR/bin"
if [[ ":$PATH:" != *":$BIN_PATH:"* ]]; then
    export PATH="$BIN_PATH:$PATH"
    echo "🔧 Added ./bin to PATH"
else
    echo "✅ ./bin already in PATH"
fi

# Create deactivate function
deactivate() {
    # Restore original PATH by removing our bin directory
    if [[ ":$PATH:" == *":$BIN_PATH:"* ]]; then
        export PATH="${PATH//$BIN_PATH:/}"
        export PATH="${PATH//:$BIN_PATH/}"
        export PATH="${PATH//$BIN_PATH/}"
    fi

    # Clean up environment variables
    unset NFT_STORY_ENV
    unset BIN_PATH
    unset PROJECT_DIR
    unset SCRIPT_DIR

    # Remove deactivate function
    unset -f deactivate

    echo "👋 Deactivated nft-story environment"
}

echo "✅ Environment initialized! Use 'deactivate' to exit."
echo ""
echo "📋 Available commands:"
echo "  🔨 forge build              - Build smart contracts"
echo "  🧪 forge test               - Run contract tests"
echo "  📊 forge test --gas-report  - Run tests with gas analysis"
echo "  🔍 forge coverage           - Generate test coverage report"
echo "  🧹 clean                    - Clean and rebuild Docker environment"
echo "  🐚 dev                      - Enter interactive development shell"
echo ""
# The NFT Story

A fully on-chain, community-driven storytelling platform where participants mint NFTs representing words/phrases that collectively build an evolving narrative.

## 🎯 Project Vision

Create permanent, decentralized literary works that exist entirely on the blockchain with no external dependencies. Community members mint word NFTs that form a collaborative story, embracing radical decentralization where "chaos is a feature, not a bug."

## 🏗️ Architecture

- **Storage**: Append-only array for gas efficiency
- **Pricing**: Fixed 0.002 ETH per word
- **Blockchain**: Ethereum mainnet (starting with Sepolia testnet)
- **Philosophy**: No content moderation, pure decentralized expression

## 📚 Educational Focus

This project is designed as a comprehensive Web3 learning experience covering:
- Smart contract development with Foundry
- Gas optimization techniques
- Test-driven development
- Frontend Web3 integration
- Deployment strategies

## 🚀 Getting Started

### Prerequisites

1. **Install Docker and Docker Compose**
   - Follow the [official Docker installation guide](https://docs.docker.com/engine/install/) for your operating system

2. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd the-nft-story
   ```

### Development Environment

This project uses Docker for a reproducible development environment with automatic environment setup. Choose one of the two options below:

**Option 1: Automatic Environment (Recommended)**
```bash
# Install direnv (one-time setup)
# https://direnv.net/docs/installation.html

# Enable for this project (one-time)
direnv allow
```

**Option 2: Manual Environment**
```bash
# Source environment manually each session
source scripts/init-env.sh

# Exit environment when done
deactivate
```

**Advanced Development (Direct Docker):**
```bash
# Alternative: Direct Docker commands (not needed with environment setup above)
docker-compose up -d foundry
docker-compose exec foundry bash

# Or use scripts directly:
./scripts/dev.sh     # Start development environment
./scripts/build.sh   # Build contracts in Docker
./scripts/test.sh    # Run tests in Docker
```

## 📖 Documentation

- [`docs/product-requirements-document.md`](docs/product-requirements-document.md) - Complete technical specifications
- [`docs/implementation-tasks.md`](docs/implementation-tasks.md) - Development roadmap
- [`docs/project-milestones.md`](docs/project-milestones.md) - Detailed timeline
- [`CLAUDE.md`](CLAUDE.md) - AI development guidance

## 🎓 Learning Approach

This project follows a strict test-driven development approach with educational quizzing and detailed explanations of all design decisions. Understanding the "why" behind each choice is prioritized over implementation speed.

## 🌐 Deployment Strategy

1. **Phase 1**: Sepolia testnet for development and testing
2. **Phase 2**: Ethereum mainnet for the Prologue chapter
3. **Future**: Multi-chain expansion to L2s for broader accessibility

---

*Built with educational intent - every decision explained, every pattern taught.*
# Implementation Tasks

This document outlines the immediate next steps and features to be implemented for The NFT Story project.

## Phase 0: Foundation & CI Setup (IMMEDIATE PRIORITY)

### Reproducible Development Environment (Docker)
- [ ] **Docker Development Environment** - Containerized Foundry setup
  - Create minimal Dockerfile with Foundry installation
  - Configure docker-compose.yml for development workflow
  - Add .dockerignore for optimized build context
  - Enable hot-reload for contract development

- [ ] **Hello World Contract** - Minimal viable implementation
  ```solidity
  contract HelloStory {
      string[] public words;

      function addWord(string memory word) external {
          words.push(word);
      }

      function getWord(uint256 index) external view returns (string memory) {
          return words[index];
      }

      function getWordCount() external view returns (uint256) {
          return words.length;
      }
  }
  ```

- [ ] **Single Test Validation**
  ```solidity
  function testAddAndRetrieveWord() public {
      string memory testWord = "hello";
      helloStory.addWord(testWord);

      assertEq(helloStory.getWordCount(), 1);
      assertEq(helloStory.getWord(0), testWord);
  }
  ```

### CI/CD Pipeline Setup
- [ ] **GitHub Actions Workflow** - Docker-based automated testing
  - Use Docker container for consistent CI environment
  - Run Foundry tests with gas reporting
  - Add basic linting and formatting checks
  - Generate test coverage report

### Project Structure (Minimal)
```
the-nft-story/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── contracts/
│   ├── src/
│   │   └── HelloStory.sol
│   ├── test/
│   │   └── HelloStory.t.sol
│   ├── script/
│   │   └── Deploy.s.sol
│   └── foundry.toml
└── scripts/
    ├── dev.sh       # Start development environment
    ├── test.sh      # Run tests in Docker
    └── build.sh     # Build contracts in Docker
```

### Success Criteria
- [ ] Docker development environment works on any machine with Docker installed
- [ ] Hello world contract compiles without warnings in Docker container
- [ ] Single test passes and validates basic functionality
- [ ] CI pipeline runs successfully using Docker container
- [ ] Gas reporting shows reasonable costs (<50k gas per addWord)
- [ ] Development workflow documented for team onboarding

## Phase 1: Core Smart Contract Implementation

### Smart Contract Development
- [ ] **StoryPrologue.sol** - Core contract with append-only array storage
  - Implement `WordNFT` struct and `words[]` array
  - Add `mintWord()` function with 0.002 ETH fixed pricing
  - Implement word validation (1-100 chars, alphanumeric + punctuation)
  - Add `getStorySegment()` for batched reading
  - Add `getWordCount()` and metadata functions
  - Implement ERC-721 compliance with on-chain tokenURI generation

- [ ] **Gas Optimization**
  - Implement packed storage for words ≤32 bytes using `bytes32`
  - Optimize string concatenation in story reconstruction
  - Test gas costs and ensure <100k gas per mint (target <80k optimized)

- [ ] **Event System**
  - Emit `WordAdded` events for frontend indexing
  - Include all necessary data in events (tokenId, word, author, timestamp)

### Testing Infrastructure
- [ ] **Unit Tests** (Foundry/Hardhat)
  - Test word minting with various inputs
  - Test story reconstruction accuracy
  - Test gas costs under different scenarios
  - Test edge cases (empty strings, max length, unicode)

- [ ] **Integration Tests**
  - Test full 1000-word chapter completion
  - Test concurrent minting scenarios
  - Test story segment retrieval with large datasets

## Phase 2: Frontend Development

### Core Components
- [ ] **StoryViewer** - Display paginated story with word ownership
- [ ] **WordMinter** - Interface for adding new words to story
- [ ] **OwnershipVisualizer** - Click words to see owner details
- [ ] **WalletConnection** - Web3 wallet integration

### Web3 Integration
- [ ] **Contract Hooks** - wagmi/viem setup for contract interactions
- [ ] **Event Listening** - Real-time story updates via events
- [ ] **Hybrid Data Loading** - Events for speed, contract storage for reliability
- [ ] **Transaction Handling** - Optimistic UI with proper error handling

### Performance Features
- [ ] **Pagination** - Load story in 50-100 word chunks
- [ ] **Local Caching** - Cache story segments in localStorage
- [ ] **Real-time Updates** - WebSocket/polling for new additions

## Phase 3: Testing & Deployment

### Smart Contract Deployment
- [ ] **Sepolia Testnet Deployment** (Ethereum testnet)
  - Deploy and verify contracts on Sepolia
  - Test with small community (10-20 users) using testnet ETH
  - Gather real gas cost data and optimize for mainnet deployment
  - Validate gas targets: <50k for HelloStory, <100k for StoryPrologue

- [ ] **Security Audit**
  - Reentrancy testing
  - Input validation testing
  - Access control verification

### Frontend Deployment
- [ ] **Production Build** - Optimize and deploy Next.js app
- [ ] **Mobile Testing** - Ensure responsive design works
- [ ] **Cross-browser Testing** - Test wallet integrations

## Key Features to Implement

### Smart Contract Features
1. **Word Validation Function**
   ```solidity
   function validateWord(string memory word) internal pure returns (bool)
   ```

2. **Story Reconstruction**
   ```solidity
   function getStorySegment(uint256 startIndex, uint256 count)
       external view returns (string[] memory)
   ```

3. **On-chain Metadata**
   ```solidity
   function tokenURI(uint256 tokenId) external view returns (string memory)
   ```

4. **Chapter Completion Check**
   ```solidity
   function isChapterComplete() external view returns (bool)
   ```

### Frontend Features
1. **Real-time Story Display** - Show words as they're minted
2. **Word Ownership Visualization** - Hover/click to see word details
3. **Story Timeline** - Visual representation of story creation over time
4. **Mint Interface** - Simple form to add words with wallet connection
5. **Story Export** - Copy/share complete story text

## Technical Priorities

### Must Have
- Gas-efficient word storage and retrieval
- Reliable Web3 wallet integration
- Real-time story updates without page refresh
- Mobile-responsive design

### Nice to Have
- Story search functionality
- Author profile pages
- Word rarity/statistics
- Social sharing features

### Future Considerations (Chapter 2+)
- Word insertion capabilities (vs append-only)
- Community voting on word quality
- Dynamic pricing models
- Cross-chapter references
- Governance mechanisms

## Success Criteria

### Technical
- [ ] Gas cost <100k per word mint (StoryPrologue), <50k per word (HelloStory)
- [ ] Story loads in <2 seconds for 100 words
- [ ] Zero data loss (all words recoverable from blockchain)
- [ ] Mobile usability on iOS/Android

### Community
- [ ] First 100 words minted within 1 week of launch
- [ ] 10+ unique contributors in first month
- [ ] Story remains readable and engaging (subjective)

## Development Environment Setup

### Docker-First Approach (Phase 0)
The minimal development setup uses Docker to ensure reproducibility:

```bash
# Start development environment
docker-compose up -d

# Run tests
./scripts/test.sh

# Build contracts
./scripts/build.sh

# Interactive development shell
docker-compose exec foundry bash
```

### Future Phases
Once Docker foundation is established:
- Smart contracts: Foundry (containerized)
- Frontend: Next.js 14 with TypeScript
- Web3: wagmi + viem
- Styling: Tailwind CSS
- Testing: Foundry tests + Jest/React Testing Library
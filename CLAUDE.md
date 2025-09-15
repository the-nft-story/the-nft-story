# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **The NFT Story** - a fully on-chain, community-driven storytelling platform where participants mint NFTs representing words/phrases that collectively build an evolving narrative. All story data is stored directly in smart contracts with no external dependencies.

## Educational Context

**IMPORTANT**: This project is primarily an educational experience for learning Web3 and blockchain development. When working on this project:

### Teaching Approach Required
- **Explain ALL design decisions** in detail before implementing
- **Present multiple approaches** to each problem with pros/cons analysis
- **Discuss trade-offs** thoroughly (gas costs, security, UX, complexity)
- **Ask for input** on technical decisions rather than assuming preferences
- **Provide learning context** - explain WHY certain patterns exist in Web3
- **Reference best practices** and industry standards with explanations

### Educational Priorities
1. **Understanding over speed** - prefer thorough explanation to quick implementation
2. **Pattern recognition** - highlight common Web3 development patterns and anti-patterns
3. **Security awareness** - explain potential vulnerabilities and mitigation strategies
4. **Gas optimization** - teach the "why" behind gas-efficient coding patterns
5. **Ecosystem knowledge** - explain tooling choices (Foundry vs Hardhat, wagmi vs web3.js, etc.)

### Discussion Format
Before implementing any significant feature:
1. **Present the problem** and multiple solution approaches
2. **Analyze pros/cons** of each approach with concrete examples
3. **Recommend** an approach with clear reasoning
4. **Ask for feedback** and adjust based on learning goals
5. **Implement** with educational commentary throughout

Example: "For word storage, we have 3 main approaches: (1) mapping with counters, (2) array storage, (3) linked list. Let me explain each approach and why array storage is optimal for our use case..."

### Knowledge Assessment Protocol
**IMPORTANT**: Periodically quiz the user's understanding to ensure deep learning:

#### Quiz Triggers
- **Before major milestones**: Test understanding of prerequisites
- **After completing tasks**: Validate comprehension of what was built
- **Before design decisions**: Ensure foundational concepts are solid
- **After explanations**: Check if complex topics were understood

#### Quiz Types
1. **Conceptual**: "Why did we choose append-only arrays over linked lists?"
2. **Technical**: "What happens to gas costs if we store a 100-character string?"
3. **Trade-off Analysis**: "Compare the pros/cons of events vs direct storage queries"
4. **Practical Application**: "How would you modify the contract to allow word editing?"
5. **Security**: "What attack vectors exist in our current design?"

#### Quiz Format
- Ask 2-3 focused questions after completing each major task
- Wait for responses before proceeding
- Provide clarification if answers reveal knowledge gaps
- Adapt future explanations based on understanding level

Example: "Before we implement the HelloStory contract, let me check your understanding: (1) Why do we use `string[]` instead of `mapping(uint256 => string)`? (2) What's the gas implication of our choice? (3) How will this affect our frontend data loading?"

## Key Architecture Decisions

### Smart Contract Design
- **Append-only array storage**: Words stored in `WordNFT[]` array for gas efficiency and simplicity
- **Fixed pricing**: 0.002 ETH per word regardless of length or position
- **No linked lists**: Rejected doubly-linked approach to avoid gas costs of updating existing NFTs
- **Chapter-based**: Each chapter is a separate contract (StoryPrologue, StoryChapter2, etc.) allowing iterative evolution

### Radical Decentralization Philosophy
- **No content moderation**: Community creates whatever emerges - chaos is a feature, not a bug
- **Minimal validation**: Only technical constraints (character whitelist, length limits)
- **Pure on-chain**: All story data must be readable from contract storage without external dependencies
- **Chapter evolution**: Future chapters can experiment with governance/moderation based on lessons learned

### Core Data Structure
```solidity
struct WordNFT {
    string word;           // The actual word/phrase
    address author;        // Who contributed it
    uint256 timestamp;     // When it was added
}

WordNFT[] public words;    // Sequential story storage
```

### Frontend Strategy
- **Next.js 14** with App Router
- **wagmi + viem** for type-safe blockchain interactions
- **Ethereum mainnet first**: Start with Sepolia testnet, deploy to mainnet
- **Hybrid event/storage approach**: Use events for fast UI updates, contract storage as fallback
- **Real-time updates**: WebSocket/polling for new word additions
- **Batch reading**: Load story in 50-100 word chunks for performance
- **Gas estimation**: Show users expected costs before transactions

## Project Structure

This repository currently contains only the Product Requirements Document (`docs/product-requirements-document.md`). The full implementation will include:

- `/contracts` - Solidity smart contracts
- `/frontend` - Next.js web application
- `/scripts` - Deployment and utility scripts
- `/test` - Smart contract tests

## Implementation Requirements

### Smart Contracts
- Use append-only array storage (NOT linked lists)
- Implement gas-efficient word validation
- Fixed 0.002 ETH pricing per word
- 1000 word limit per chapter
- Emit events for frontend indexing while maintaining on-chain data

### Frontend
- Must work entirely from blockchain data (events + contract storage)
- No external databases or indexing services as dependencies
- Real-time story visualization with word-by-word ownership display
- Mobile-responsive design

### Testing
- Gas cost analysis for optimization
- Stress test with full 1000-word chapters
- Security testing for input validation and reentrancy
- Frontend testing with large story datasets

## Development Commands

### Automatic Environment Setup (RECOMMENDED)
**STATUS**: ✅ Auto-environment integration completed

**Option 1: direnv (Universal)**
```bash
# Install direnv (one-time setup)
# macOS: brew install direnv
# Ubuntu: sudo apt install direnv
# Add hook to shell profile: eval "$(direnv hook bash)" or eval "$(direnv hook zsh)"

# Enable for this project (one-time)
direnv allow

# Environment auto-loads when entering directory!
# Use 'direnv block' to temporarily disable
```

**Option 2: Manual sourcing (Fallback)**
```bash
# Source environment manually
source scripts/init-env.sh

# Exit environment
deactivate
```

**VSCode Integration**:
- Terminals automatically use nft-story environment
- Use Command Palette → "Tasks: Run Task" for common operations
- Recommended extensions auto-suggested on project open

### Docker Development Environment (CURRENT)
**STATUS**: ✅ Docker environment completed (commit 0fc764b)

```bash
# Quick Start (with auto-environment via direnv or source scripts/init-env.sh)
forge build         # Build contracts (auto-Docker)
forge test          # Run tests (auto-Docker)
clean               # Clean and rebuild environment
dev                 # Interactive development shell

# manual commands (still work)
./scripts/dev.sh     # Start development environment
./scripts/build.sh   # Build contracts in Docker
./scripts/test.sh    # Run tests in Docker

# Interactive Development
docker-compose up -d foundry            # Start container
docker-compose exec foundry bash        # Enter development shell

# Inside container - standard Foundry commands:
forge build
forge test --gas-report
forge test --match-test testAddAndRetrieveWord
forge coverage
```

### Smart Contract Development (Foundry in Docker)
```bash
# Initialize project (NEXT STEP after Docker installation)
docker-compose run --rm foundry forge init contracts

# Build contracts
docker-compose run --rm foundry forge build

# Run tests with gas reporting
docker-compose run --rm foundry forge test --gas-report

# Deploy to local anvil (optional)
docker-compose --profile anvil up -d anvil  # Start local blockchain
docker-compose run --rm foundry forge script script/Deploy.s.sol --rpc-url http://anvil:8545
```

### CI/CD Commands (TODO)
```bash
# Local CI simulation (future)
act push  # If using act to test GitHub Actions locally

# Manual test run (matches future CI)
./scripts/test.sh && docker-compose run --rm foundry forge coverage
```

### Expected Full Project Workflow (Future)
- **Frontend**: `npm run dev`, `npm run build`, `npm run test`
- **Full Project**: `npm run dev:all` (contracts + frontend)

## Key Files

- `docs/product-requirements-document.md` - Complete technical and functional specifications
- `docs/implementation-tasks.md` - Immediate next steps and features to implement
- `docs/project-milestones.md` - Detailed roadmap with timelines and implementation notes
- `docs/prompt.xml` - Original project prompt

## Implementation Priorities

### COMPLETED ✅ (Phase 0 Foundation - Session 1)
1. **Docker Development Environment**: Containerized Foundry setup with official images
   - ✅ Minimal Dockerfile using `ghcr.io/foundry-rs/foundry:latest`
   - ✅ docker-compose.yml with foundry service and optional anvil blockchain
   - ✅ Development scripts: dev.sh, test.sh, build.sh
   - ✅ .dockerignore optimized for existing files only
   - ✅ Updated README.md with comprehensive developer instructions
   - ✅ Committed changes (commit 0fc764b)

### IMMEDIATE NEXT (After Docker Installation)
**CRITICAL**: User must install Docker first, then initialize Foundry project
1. **Docker Installation**: User needs to install Docker using provided commands
2. **Hello World Contract**: Minimal `HelloStory.sol` with string array storage
3. **Single Test Suite**: Comprehensive test validating add/retrieve functionality
4. **Foundry Project Init**: Initialize contracts/ directory structure

### Next (Milestone 1 - Weeks 1-2)
1. **StoryPrologue Contract**: Full implementation with NFT functionality
2. **Gas Optimization**: Target <100k gas per word mint using packed storage
3. **Comprehensive Testing**: Edge cases, security, and stress tests
4. **Word Validation**: Alphanumeric + punctuation whitelist, 1-100 char length

### Future (Milestone 2+)
1. **Frontend MVP**: Story viewer + word minter components
2. **Web3 Integration**: wagmi/viem setup with event-driven updates
3. **Real-time UI**: New words appear within 5 seconds of minting
4. **Mobile Design**: Responsive interface for iOS/Android

### Critical Implementation Notes
- **EDUCATIONAL FIRST**: Explain all decisions before implementing
- **CI FIRST**: No code changes without passing CI pipeline
- **TEST-DRIVEN DEVELOPMENT**: Write tests before implementation (see TDD section below)
- **NO external dependencies** - all story data must be readable from contract storage
- **Events are supplementary** - use for UI speed, not as primary data source
- **Gas efficiency is paramount** - each optimization directly impacts user adoption (explain why)
- **Embrace chaos** - no content moderation, community creates what it creates

## Test-Driven Development (TDD) Protocol

**MANDATORY**: This project follows strict TDD methodology for educational value and code quality.

### TDD Cycle (Red-Green-Refactor)
1. **🔴 RED**: Write a failing test that describes desired behavior
2. **🟢 GREEN**: Write minimal code to make the test pass
3. **🔵 REFACTOR**: Improve code while keeping tests green
4. **📚 EDUCATE**: Explain what was learned in each cycle

### TDD Implementation Rules
- **No production code** without a failing test first
- **Write minimal tests** - one concept per test
- **Explain test strategy** before writing tests
- **Document test rationale** - why this test matters

### Testing Strategy by Phase

#### Phase 0: HelloStory Contract
```solidity
// Example TDD approach:
// 1. RED: Write test for adding first word
function testAddFirstWord() public {
    helloStory.addWord("hello");
    assertEq(helloStory.getWordCount(), 1);
    assertEq(helloStory.getWord(0), "hello");
}

// 2. GREEN: Implement minimal addWord() function
// 3. REFACTOR: Optimize gas usage
// 4. EDUCATE: Explain array growth patterns
```

#### Educational Benefits of TDD
- **Design clarity**: Tests force clear interface design
- **Regression protection**: Prevents breaking existing functionality
- **Documentation**: Tests serve as executable specifications
- **Confidence**: Refactoring becomes safe with comprehensive tests
- **Gas optimization**: Benchmark gas costs through testing

### Test Categories to Implement

#### 1. **Happy Path Tests**
- Basic functionality working as expected
- Standard user workflows

#### 2. **Edge Case Tests**
- Empty strings, maximum length strings
- Boundary conditions (array bounds, gas limits)
- Unicode characters, special punctuation

#### 3. **Security Tests**
- Input validation bypass attempts
- Reentrancy scenarios (even if not applicable)
- Access control verification

#### 4. **Gas Optimization Tests**
- Measure gas usage for different input sizes
- Compare optimization strategies
- Ensure gas targets are met

#### 5. **Integration Tests**
- Contract interactions with external systems
- Event emission verification
- State consistency across operations

### TDD Educational Milestones

After each TDD cycle, quiz understanding:
- "Why did we write this specific test first?"
- "What edge cases might we be missing?"
- "How does this test help with gas optimization?"
- "What would happen if we removed this assertion?"

### Gas-Focused Testing Pattern
```solidity
// Educational gas testing approach
function testGasCosts() public {
    uint256 gasBefore = gasleft();
    helloStory.addWord("test");
    uint256 gasUsed = gasBefore - gasleft();

    // Educational assertion with explanation
    assertLt(gasUsed, 50000, "Gas usage exceeds educational target");
    console.log("Gas used for 'test':", gasUsed);
}
```

### Learning Topics to Cover
- **Solidity fundamentals**: Storage vs memory, gas costs, security patterns
- **ERC standards**: Why ERC-721, alternatives like ERC-1155
- **Testing strategies**: Unit vs integration tests, fuzzing, invariant testing
- **Frontend Web3**: Wallet connections, transaction handling, event listening
- **Development tools**: Foundry ecosystem, debugging techniques
- **Deployment**: Testnet vs mainnet, verification, monitoring

## Hello World Contract Specification

The immediate task is implementing this minimal contract to validate the entire development stack:

```solidity
contract HelloStory {
    string[] public words;
    event WordAdded(uint256 indexed index, string word);

    function addWord(string memory word) external {
        require(bytes(word).length > 0, "Empty word not allowed");
        require(bytes(word).length <= 50, "Word too long");
        words.push(word);
        emit WordAdded(words.length - 1, word);
    }

    function getWord(uint256 index) external view returns (string memory) {
        require(index < words.length, "Index out of bounds");
        return words[index];
    }

    function getWordCount() external view returns (uint256) {
        return words.length;
    }
}
```

**Educational Implementation Approach**:
Before implementing, explain:
- Why `string[]` vs `mapping(uint256 => string)` for word storage
- Gas implications of dynamic arrays vs mappings
- `require()` vs `revert()` vs custom errors for validation
- Event indexing decisions and their impact on frontend querying
- Testing strategy: what edge cases to cover and why

**Success Criteria**:
- CI passes with all tests green
- Gas cost <50k per addWord (measured via tests)
- 100% test coverage achieved through TDD
- Complete understanding of each design decision (validated via quizzes)
- All tests written BEFORE implementation code

## Educational Questions to Explore
When implementing this contract, discuss:
1. **Storage patterns**: Why array vs mapping? What are the trade-offs?
2. **Gas optimization**: How does string length affect gas costs?
3. **Error handling**: Modern Solidity error patterns (custom errors vs strings)
4. **Event design**: What should be indexed? Why?
5. **Testing philosophy**: Unit vs integration testing in Solidity

Refer to milestone documents for detailed implementation specifications and timelines.
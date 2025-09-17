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

Example: "Before we implement the HelloWorld contract, let me check your understanding: (1) Why do we use `string[]` instead of `mapping(uint256 => string)`? (2) What's the gas implication of our choice? (3) How will this affect our frontend data loading?"

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

### Quick Start
```bash
# Get help with all available commands
make help

# Initialize the project (first time only)
make setup

# Build and test workflow
make build && make test
```

### Smart Contract Development (Foundry in Docker)

#### Environment Setup
```bash
make setup          # Initialize foundry project and install dependencies
make install        # Alias for setup
make deps           # Install/update foundry dependencies
make clean          # Clean build artifacts and Docker environment
```

#### Development Environment
```bash
make dev            # Open interactive development shell (eth-security-toolbox)
make shell          # Alias for dev
make logs           # Show container logs
make status         # Show development environment status
```

#### Building & Compilation
```bash
make build          # Compile smart contracts
make watch          # Watch for changes and rebuild/test automatically
```

#### Testing
```bash
make test           # Run all tests
make gas-report     # Run tests with detailed gas reporting
make test-coverage  # Run tests with coverage analysis
make test-cov       # Alias for test-coverage
```

#### Code Quality & Security
```bash
make lint           # Run Solhint linter for code quality
make format         # Format Solidity code with forge fmt
make fmt            # Alias for format
make format-check   # Check if code is properly formatted
make slither        # Run Slither security analysis (full output with JSON)
make security       # Run complete security analysis (Slither + lint)
```

#### Documentation & Inspection
```bash
make docs           # Generate contract documentation
make inspect CONTRACT=HelloWorld  # Inspect specific contract (ABI, bytecode, gas estimates)
make version        # Show Foundry tool versions
```

#### Debugging
```bash
make trace TX=0x...  # Trace a specific transaction hash
```

### Docker Services Available

#### Foundry Service
- **Image**: `ghcr.io/foundry-rs/foundry:latest`
- **Purpose**: Smart contract compilation, testing, and deployment
- **Working Directory**: `/workspace/contracts`
- **Volume**: Persistent cache for dependencies

#### Security Toolbox (dev)
- **Image**: `ghcr.io/trailofbits/eth-security-toolbox:nightly`
- **Purpose**: Security analysis with Slither, interactive development
- **Access**: `make dev` for interactive shell

#### Solhint Linter
- **Image**: `protodb/protofire-solhint:latest`
- **Purpose**: Solidity code quality analysis
- **Usage**: Activated automatically with `make lint`

### Development Workflow

#### Daily Development
```bash
# 1. Start development
make build          # Ensure everything compiles

# 2. Test-driven development
make test           # Run existing tests
# Write new tests, then implement features

# 3. Code quality checks
make format         # Format code
make lint           # Check code quality
make security       # Security analysis

# 4. Gas optimization
make gas-report     # Monitor gas usage
```

#### Project Setup (First Time)
```bash
# 1. Clone and enter project
git clone <repo-url>
cd the-nft-story

# 2. Initialize environment
make setup

# 3. Verify setup
make build
make test
make version
```

### CI/CD Integration

#### Local CI Simulation
```bash
# Run full CI pipeline locally
make build && make test && make security && make format-check
```

#### Expected CI Pipeline (Future)
- ✅ Build contracts: `make build`
- ✅ Run tests: `make test`
- ✅ Security analysis: `make security`
- ✅ Code formatting: `make format-check`
- ✅ Gas reporting: `make gas-report`
- ✅ Documentation: `make docs`

### File Structure Integration
- **Makefile**: Complete development workflow automation
- **compose.yaml**: Docker services configuration
- **foundry.env**: Environment variables for Foundry
- **contracts/**: Foundry project with smart contracts
- **SECURITY.md**: Security analysis documentation
- **.github/workflows/**: CI/CD and Claude AI automation workflows

## Key Files

- `docs/product-requirements-document.md` - Complete technical and functional specifications
- `docs/implementation-tasks.md` - Immediate next steps and features to implement
- `docs/project-milestones.md` - Detailed roadmap with timelines and implementation notes
- `docs/prompt.xml` - Original project prompt
- `compose.yaml` - Docker compose configuration for this workspace

### GitHub Workflows
- `.github/workflows/security.yml` - Slither, dependency review, OpenSSF Scorecard security analysis
- `.github/workflows/claude-security.yml` - AI-powered security review with educational focus
- `.github/workflows/claude-assistant.yml` - Interactive Claude assistance via @claude mentions
- `.github/workflows/claude-educational-review.yml` - Comprehensive educational code reviews

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
2. **HelloWorld Contract**: Minimal `HelloWorld.sol` with string array storage
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
- **SECURITY FIRST**: Follow Trail of Bits security guidelines (see Security Development section below)
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

#### Phase 0: HelloWorld Contract
```solidity
// Example TDD approach:
// 1. RED: Write test for adding first word
function testAddFirstWord() public {
    helloWorld.addWord("hello");
    assertEq(helloWorld.getWordCount(), 1);
    assertEq(helloWorld.getWord(0), "hello");
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
    helloWorld.addWord("test");
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
- **Security practices**: Following Trail of Bits guidelines, vulnerability prevention

## Security Development Guidelines

**MANDATORY**: This project follows [Trail of Bits' Building Secure Contracts](https://github.com/crytic/building-secure-contracts/tree/master/development-guidelines) guidelines for security-first development.

### Design Phase Security Requirements

#### 1. Documentation Standards
- **Plain English Description**: Every contract must have clear, non-technical documentation
- **Architectural Diagrams**: Visual representation of system components and interactions
- **NatSpec Documentation**: Complete `@notice`, `@param`, `@return` documentation for all functions
- **Migration Procedures**: Document upgrade/migration strategies before implementation

#### 2. Architecture Principles
- **Minimize On-Chain Computation**: Keep complex logic off-chain when possible
- **Prefer Migration Over Upgradeability**: Design for contract replacement rather than proxy patterns
- **Simplicity First**: Keep contract logic comprehensible and auditable
- **Modular Design**: Divide system into focused, single-responsibility contracts

### Implementation Security Standards

#### 1. Code Structure Requirements
- **Small Functions**: Maximum 20-30 lines per function for readability
- **Careful Inheritance**: Document inheritance hierarchies and potential conflicts
- **Event Logging**: Emit events for all critical state changes
- **Battle-Tested Libraries**: Use OpenZeppelin for standard functionality

#### 2. Security-Critical Practices
- **Vulnerability Awareness**: Review [SWC Registry](https://swcregistry.io/) before coding
- **Solidity Documentation**: Follow all warnings and best practices
- **Avoid Assembly**: No inline assembly without explicit security review
- **Dependency Management**: Pin exact versions, audit all dependencies

### Security Testing Protocol

#### 1. Automated Security Scanning (MANDATORY)
- **Slither Integration**: Run `make security` on every commit
- **Clean Reports**: Zero high/medium findings before merging
- **Custom Properties**: Define contract-specific security properties

#### 2. Contract-Specific Validation
- **ERC Compliance**: Verify standard conformance with automated tests
- **Access Controls**: Test all permission boundaries and role assignments
- **State Transitions**: Validate all possible state changes are intentional
- **External Interactions**: Test integration with other contracts/tokens

#### 3. Property-Based Testing
- **Invariant Testing**: Define and test system invariants with Echidna
- **Fuzzing**: Generate random inputs to discover edge cases
- **Symbolic Execution**: Use tools like Manticore for path exploration

### Security Review Preparation

#### 1. Visual Code Inspection
- **Inheritance Graphs**: Generate and review contract inheritance trees
- **Function Visibility**: Audit all function access modifiers
- **State Variable Access**: Review storage variable visibility and mutability

#### 2. Security Property Documentation
Must document security properties for:
- **State Machine**: Valid state transitions and access controls
- **Arithmetic Operations**: Overflow/underflow protections
- **External Interactions**: Reentrancy guards and call safety
- **Standards Conformance**: ERC compliance and interface adherence

#### 3. Threat Modeling
- **Front-Running**: Identify and mitigate MEV vulnerabilities
- **Privacy**: Document what information is publicly accessible
- **DeFi Integration**: Assess risks of external protocol dependencies
- **Upgrade Risks**: Document centralization and upgrade attack vectors

### Development Workflow Security

#### 1. Pre-Commit Requirements
```bash
# Security pipeline (all must pass)
make build           # Compilation must succeed
make test            # All tests must pass
make security        # Security analysis must be clean
make format-check    # Code formatting must be consistent
```

#### 2. Code Review Standards
- **Security Focus**: Every PR must include security analysis
- **Threat Assessment**: Document new attack vectors introduced
- **Gas Analysis**: Review gas costs for DoS attack resistance
- **External Dependencies**: Audit any new library integrations
- **AI-Assisted Reviews**: Claude provides automated security and educational analysis

#### 3. Deployment Security
- **Testnet First**: Deploy and test on testnets before mainnet
- **Monitoring Setup**: Implement transaction monitoring and alerting
- **Incident Response**: Have response plan ready before deployment
- **Contact Information**: Add security contact to [security repositories](https://github.com/ethereum-lists/contracts-security-contacts)

### Educational Security Learning

#### 1. Security Quiz Integration
After implementing security features, quiz understanding:
- "What attack vectors does this guard against?"
- "How could an attacker exploit this function?"
- "What are the gas implications of this security measure?"
- "How would you test this security property?"

#### 2. Vulnerability Analysis
- **Case Studies**: Study real-world exploit examples
- **Code Reviews**: Analyze vulnerable contract patterns
- **Security Tools**: Understand how Slither detects issues
- **Best Practices**: Learn why certain patterns are dangerous

#### 3. Security Resources
- **Trail of Bits Guidelines**: https://github.com/crytic/building-secure-contracts
- **Consensys Best Practices**: https://consensys.github.io/smart-contract-best-practices/
- **Solidity Security**: https://docs.soliditylang.org/en/latest/security-considerations.html
- **DeFi Security**: https://blog.trailofbits.com/2021/02/05/how-the-defi-space-represents-breaking-smart-contract-composability/

### Security Metrics and KPIs
- **Zero Critical/High Findings**: Slither reports must be clean
- **100% Test Coverage**: All functions must have comprehensive tests
- **Gas Efficiency**: Optimize for DoS resistance, not just cost
- **Documentation Completeness**: All security properties documented
- **Review Readiness**: Codebase prepared for professional security audit

## Educational Questions to Explore
When implementing this contract, discuss:
1. **Storage patterns**: Why array vs mapping? What are the trade-offs?
2. **Gas optimization**: How does string length affect gas costs?
3. **Error handling**: Modern Solidity error patterns (custom errors vs strings)
4. **Event design**: What should be indexed? Why?
5. **Testing philosophy**: Unit vs integration testing in Solidity

Refer to milestone documents for detailed implementation specifications and timelines.

## Claude AI Integration

This project leverages Claude AI for enhanced development workflows and educational support:

### Available Claude Workflows

#### 1. Interactive Assistant (`@claude` mentions)
- **Trigger**: Mention `@claude` in any issue, PR comment, or review
- **Purpose**: Get AI assistance for coding questions, debugging, and implementation guidance
- **Educational Focus**: Provides learning-oriented explanations and teaches Web3 patterns
- **Workflow**: `.github/workflows/claude-assistant.yml`

#### 2. Automated Security Review
- **Trigger**: Every pull request automatically
- **Purpose**: AI-powered security analysis with smart contract focus
- **Educational Value**: Explains vulnerabilities and provides learning context
- **Workflow**: `.github/workflows/claude-security.yml`

#### 3. Educational Code Review
- **Trigger**: Pull requests affecting contracts, frontend, or tests
- **Purpose**: Comprehensive educational feedback on code patterns and best practices
- **Learning Focus**: Web3 patterns, gas optimization, testing strategies
- **Workflow**: `.github/workflows/claude-educational-review.yml`

### Setup Requirements

To enable Claude AI workflows, add your Anthropic API key to repository secrets:
```bash
# In GitHub repo settings > Secrets and variables > Actions
ANTHROPIC_API_KEY=your_anthropic_api_key_here
```

### Using Claude Assistant

1. **Ask Questions**: Mention `@claude` in any issue or PR comment
2. **Get Code Help**: Claude can read your codebase and provide specific guidance
3. **Debug Issues**: Share error messages for educational debugging assistance
4. **Learn Patterns**: Ask about Web3 concepts, security patterns, or best practices

### Educational Benefits

- **Learning-First Approach**: All Claude responses prioritize educational value
- **Security Awareness**: Automated detection and explanation of vulnerabilities
- **Pattern Recognition**: Helps identify and understand Web3 development patterns
- **Best Practices**: Guidance aligned with Trail of Bits security standards
- **Gas Optimization**: Educational approach to smart contract efficiency

The Claude AI integration transforms this repository into an interactive learning environment where every interaction provides educational value and development guidance.
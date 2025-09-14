# On-Chain Community Storytelling NFT - Product Requirements Document

## 1. Executive Summary

### Project Vision
Create a fully on-chain, community-driven storytelling platform where participants mint NFTs representing words or phrases that collectively build an evolving narrative. All story data is stored directly in smart contracts, creating a permanent, decentralized literary work that exists entirely on the blockchain.

### Core Value Proposition
- **Permanent Stories**: Literary works that cannot be censored, deleted, or lost
- **Collaborative Creation**: Community-driven storytelling with individual word ownership
- **True Decentralization**: No external dependencies - stories exist purely on-chain
- **Digital Collectibles**: Each word/phrase is an ownable NFT with provable contribution

### Success Metrics
- Total words minted per chapter
- Unique story contributors
- Gas efficiency (cost per word stored)
- Story readability and community engagement
- Time to complete first "Prologue" chapter

## 2. Technical Architecture

### 2.1 Smart Contract Design

#### Core Contract Structure [AI_IMPLEMENT]
```solidity
contract StoryPrologue {
    struct WordNFT {
        string word;           // The actual word/phrase
        address author;        // Who contributed it
        uint256 timestamp;     // When it was added
    }

    WordNFT[] public words;        // Append-only array storage
    uint256 public maxWords = 1000; // Chapter limit

    function getWordCount() external view returns (uint256) {
        return words.length;
    }
}
```

#### Gas Optimization Strategies [AI_IMPLEMENT]
1. **Append-Only Array**: Store story words in simple array for cheapest gas costs
2. **Packed Storage**: Use `bytes32` for short words, `string` only when necessary
3. **Event-Driven History**: Emit events for off-chain indexing
4. **Batch Operations**: Allow multiple word additions in single transaction
5. **No State Updates**: Avoid updating existing NFTs to minimize gas costs

### 2.2 Data Structures

#### Word Storage Pattern [AI_IMPLEMENT]
```solidity
// Optimized storage for gas efficiency
struct PackedWord {
    bytes32 shortWord;    // Words ≤32 bytes
    string longWord;      // Overflow for longer phrases
    bool isLong;          // Flag for storage type
    uint128 prevId;       // Previous word (packed)
    uint128 nextId;       // Next word (packed)
}
```

#### Story Traversal Mechanism
- **Sequential Access**: Words stored in chronological order (array index = story position)
- **Direct Access**: Instant lookup by array index (no pointer traversal needed)
- **Batch Reading**: Return word ranges for efficient frontend rendering
- **Full Story**: Concatenate array elements for complete narrative

### 2.3 Tokenomics

#### Minting Cost Structure
- **Fixed Price**: 0.002 ETH per word (regardless of length or position)
- **Accessibility Focus**: Low barrier to encourage broad community participation
- **No Complex Pricing**: Simple, predictable costs for all contributors
- **Spam Protection**: Price high enough to discourage meaningless contributions
- **Future Evolution**: Later chapters may implement dynamic pricing based on lessons learned

#### Word Validation Rules [AI_IMPLEMENT]
```solidity
function validateWord(string memory word) internal pure returns (bool) {
    bytes memory wordBytes = bytes(word);
    
    // Length constraints
    if (wordBytes.length == 0 || wordBytes.length > 100) return false;
    
    // Character validation (alphanumeric + basic punctuation)
    for (uint i = 0; i < wordBytes.length; i++) {
        bytes1 char = wordBytes[i];
        if (!isValidCharacter(char)) return false;
    }
    
    return true;
}
```

## 3. Functional Requirements

### 3.1 Core Features

#### F001: Word/Phrase Minting
**Description**: Users can mint NFTs representing story words that are permanently added to the narrative sequence.

**Acceptance Criteria**:
- User submits word/phrase with payment
- Contract validates word meets quality standards
- Word is added to story sequence via append-only array
- NFT is minted with on-chain metadata
- `WordAdded` event is emitted for indexing

**Implementation Notes** [AI_IMPLEMENT]:
```solidity
function mintWord(string memory word) external payable returns (uint256) {
    require(words.length < maxWords, "Chapter complete");
    require(validateWord(word), "Invalid word");
    require(msg.value >= 0.002 ether, "Insufficient payment");

    // Append to story array
    words.push(WordNFT({
        word: word,
        author: msg.sender,
        timestamp: block.timestamp
    }));

    uint256 tokenId = words.length; // Token ID matches array position
    
    _mint(msg.sender, tokenId);
    emit WordAdded(tokenId, word, msg.sender);
    
    return tokenId;
}
```

#### F002: On-Chain Story Rendering
**Description**: Complete story can be reconstructed from blockchain data without external dependencies.

**Acceptance Criteria**:
- Contract provides methods to read story segments
- Story maintains proper word ordering
- No external calls required for story access
- Efficient batched reading for long stories

**Implementation Notes** [AI_IMPLEMENT]:
```solidity
function getStorySegment(uint256 startIndex, uint256 count)
    external view returns (string[] memory) {
    require(startIndex < words.length, "Start index out of bounds");

    uint256 endIndex = startIndex + count;
    if (endIndex > words.length) {
        endIndex = words.length;
    }

    string[] memory segment = new string[](endIndex - startIndex);
    for (uint256 i = startIndex; i < endIndex; i++) {
        segment[i - startIndex] = words[i].word;
    }

    return segment;
}

function getFullStory() external view returns (string memory) {
    // WARNING: Gas-intensive for long stories
    // Use for testing/verification only
    string memory story = "";

    for (uint256 i = 0; i < words.length; i++) {
        if (i > 0) {
            story = string(abi.encodePacked(story, " "));
        }
        story = string(abi.encodePacked(story, words[i].word));
    }

    return story;
}
```

#### F003: Story Visualization Interface
**Description**: Web interface displays evolving story with word-by-word ownership visualization.

**Acceptance Criteria**:
- Real-time story updates as new words are minted
- Click on words to see owner and mint details
- Visual timeline of story creation
- Responsive design for mobile and desktop

### 3.2 Governance Features

#### G001: Content Moderation Rules [AI_IMPLEMENT]
**Description**: Minimal on-chain validation maintains decentralization while preventing technical issues.

**Implementation**:
- Character whitelist (alphanumeric + basic punctuation)
- Length constraints (1-100 characters)
- No profanity filter (community creates what it creates)
- No content moderation (pure decentralized expression)
- Emergency pause mechanism only for critical contract vulnerabilities

**Philosophy**: The Prologue embraces radical decentralization. If the community mints nonsense, that IS the story. Future chapters can experiment with governance mechanisms based on lessons learned.

#### G002: Chapter Management
**Description**: Story is organized into chapters, each as independent smart contracts allowing iterative evolution.

**Features**:
- `maxWords` limit per chapter (1000 for Prologue)
- Chapter completion when limit reached
- Each chapter = separate contract deployment (StoryPrologue, StoryChapter2, etc.)
- No automatic transitions (community decides when/how to deploy next chapters)
- Cross-chapter referencing possible via contract addresses

**Rationale**: Separate contracts allow each chapter to be a "version upgrade" with new features, pricing models, or governance mechanisms without affecting previous chapters. The Prologue serves as the experimental foundation.

## 4. Implementation Specifications

### 4.1 Smart Contracts

#### Primary Contract: StoryPrologue
**Responsibilities**:
- Store all story words using append-only array storage
- Manage NFT minting and ownership
- Provide story reconstruction functions
- Implement gas-efficient storage patterns

**Key Functions** [AI_IMPLEMENT]:
```solidity
interface IStoryPrologue {
    function mintWord(string memory word) external payable returns (uint256);
    function getStorySegment(uint256 startIndex, uint256 count) external view returns (string[] memory);
    function getWordCount() external view returns (uint256);
    function getWordMetadata(uint256 tokenId) external view returns (WordNFT memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
    function isChapterComplete() external view returns (bool);
}
```

#### Secondary Contract: StoryRenderer
**Responsibilities**:
- Generate on-chain SVG representations of words
- Create formatted story output
- Handle metadata URI generation

**Key Functions**:
```solidity
function generateWordSVG(uint256 tokenId) external view returns (string memory);
function generateStoryPage(uint256 startId, uint256 count) external view returns (string memory);
```

### 4.2 Frontend Requirements

#### Tech Stack
- **Framework**: Next.js 14 with App Router
- **Web3**: wagmi + viem for type-safe blockchain interactions
- **Styling**: Tailwind CSS for responsive design
- **State Management**: Zustand for simple global state

#### Key Components [AI_IMPLEMENT]
```typescript
// Core component structure
interface StoryViewerProps {
  contractAddress: string;
  startWordId?: number;
  wordsPerPage?: number;
}

interface WordMintingProps {
  onWordMinted: (tokenId: number) => void;
  suggestedNextWords?: string[];
}

interface OwnershipVisualizerProps {
  words: WordData[];
  highlightOwner?: string;
}
```

#### Performance Considerations
- **Pagination**: Load story in chunks of 50-100 words
- **Caching**: Cache word data and story segments locally
- **Real-time Updates**: WebSocket or polling for new words
- **Optimistic UI**: Show pending words before confirmation

## 5. Testing Requirements

### 5.1 Smart Contract Tests [AI_IMPLEMENT]

#### Gas Cost Analysis
```solidity
// Test scenarios for gas optimization
function testGasCosts() public {
    // Single word minting: ~100k gas
    // Story traversal (100 words): ~200k gas
    // Batch reading (50 words): ~150k gas
}
```

#### Stress Testing Scenarios
- Mint maximum words (1000) in single chapter
- Concurrent minting from multiple accounts
- Story reconstruction with various segment sizes
- Edge cases: empty words, maximum length phrases, unicode characters

#### Security Test Cases
- Reentrancy protection during minting
- Access control for administrative functions
- Integer overflow protection
- Input validation bypass attempts

### 5.2 Frontend Testing
- Story rendering performance with 1000+ words
- Mobile responsiveness across devices
- Web3 wallet integration (MetaMask, WalletConnect)
- Error handling for failed transactions

## 6. Deployment Strategy

### Blockchain Selection: Ethereum Mainnet First
**Rationale**:
- **Educational Priority**: Learn gas optimization under real economic pressure
- **Maximum Decentralization**: True censorship resistance and permanence
- **Industry Standard**: Experience the "gold standard" of blockchain deployment
- **Future Expansion**: Can deploy to L2s (Base, Arbitrum) as later chapters

### Phase 1: Sepolia Testnet Launch (2 weeks)
**Objectives**: Validate core functionality and optimize gas costs

**Tasks**:
- [ ] Deploy contracts to Sepolia testnet (Ethereum testnet)
- [ ] Implement basic frontend with testnet configuration
- [ ] Conduct internal testing with 10-20 beta users
- [ ] Gather gas cost data and optimize storage patterns
- [ ] Test story reconstruction performance
- [ ] Validate real-world gas costs against targets

**Success Criteria**:
- Story of 100+ words created successfully on Sepolia
- Gas costs under 100k per word mint (measured on testnet)
- No critical bugs in core functionality
- Frontend works with MetaMask/WalletConnect on testnet

### Phase 2: Ethereum Mainnet Soft Launch (4 weeks)
**Objectives**: Limited release to build initial community on mainnet

**Tasks**:
- [ ] Deploy optimized contracts to Ethereum mainnet
- [ ] Configure frontend for mainnet with gas estimation
- [ ] Launch with invite-only access (100 early users willing to pay gas costs)
- [ ] Monitor actual mainnet gas costs and usage patterns
- [ ] Gather community feedback on user experience vs gas cost trade-offs
- [ ] Document lessons learned for future L2 deployments

**Success Criteria**:
- "Prologue" chapter 25% complete (250 words) on Ethereum mainnet
- Active community of 50+ contributors willing to pay mainnet gas
- Gas costs remain economically viable for target audience
- Positive feedback on storytelling experience despite gas costs

### Phase 3: Full Public Launch (2 weeks)
**Objectives**: Open access and scale community on Ethereum mainnet

**Tasks**:
- [ ] Remove access restrictions on mainnet deployment
- [ ] Launch marketing campaign emphasizing permanence and decentralization
- [ ] Partner with NFT communities and Web3 creators comfortable with mainnet gas costs
- [ ] Host community events and writing challenges
- [ ] Plan future chapter developments (potentially on L2s for broader access)

**Success Criteria**:
- "Prologue" chapter completion (1000 words) on Ethereum mainnet
- 200+ unique contributors willing to pay mainnet gas fees
- Sustainable minting activity (5+ words/day) despite gas costs
- Established foundation for multi-chain expansion strategy

### Future Multi-Chain Expansion
**Post-Prologue Strategy**:
- **Chapter 2**: Deploy to Base (Coinbase L2) for broader accessibility
- **Chapter 3**: Deploy to Arbitrum for DeFi community engagement
- **Chapter 4**: Experiment with governance mechanisms on Polygon
- **Cross-Chain References**: Enable story connections across different chains

## 7. Success Metrics & KPIs

### Primary Metrics
- **Words Minted**: Target 1000 for Prologue completion
- **Unique Contributors**: Target 200+ different authors
- **Story Coherence**: Community rating of narrative quality
- **Gas Efficiency**: <100k gas per word mint (optimized)

### Secondary Metrics
- **Community Engagement**: Discord/Twitter activity
- **Story Readability**: External reviews and social sharing
- **Technical Performance**: Frontend load times, error rates
- **Economic Activity**: Total ETH volume, secondary sales

### Long-term Vision Metrics
- **Chapter Progression**: Number of completed chapters
- **Cross-Chapter References**: Interconnected storytelling
- **Cultural Impact**: Media coverage, academic interest
- **Technical Innovation**: Influence on other on-chain projects

## 8. Risk Assessment & Mitigation

### Technical Risks
**Risk**: Gas costs become prohibitive for users
**Mitigation**: Implement aggressive optimization, consider L2 deployment

**Risk**: Story becomes incoherent with random contributions
**Mitigation**: Community moderation tools, suggested next words feature

**Risk**: Smart contract vulnerabilities
**Mitigation**: Comprehensive testing, security audits, emergency pause mechanism

### Economic Risks
**Risk**: Insufficient demand for word minting
**Mitigation**: Engaging marketing, reasonable pricing, community incentives

**Risk**: Whale dominance (single user mints many words)
**Mitigation**: Consider rate limiting in future chapters (Prologue embraces chaos)

### Community Risks
**Risk**: Story becomes incoherent or inappropriate
**Mitigation**: Accept as feature, not bug - pure decentralized expression. Future chapters can implement governance if needed.

**Risk**: Chapter transitions and scalability
**Mitigation**: Each chapter deploys as separate contract (StoryPrologue, StoryChapter2, etc.). Allows iterative improvements and feature evolution without affecting previous chapters.

## 9. Future Considerations

### Chapter Evolution
- **Chapter 2**: Advanced features like branching narratives
- **Chapter 3**: Cross-references and story interconnections
- **Chapter 4**: Community governance and moderation tools

### Technical Improvements
- Layer 2 deployment for reduced costs
- Advanced story visualization tools
- Mobile app development
- API for third-party integrations

### Community Features
- Author reputation systems
- Collaborative writing tools
- Story quality voting mechanisms
- NFT trait evolution based on story position

---

## Implementation Checklist

- [ ] All data storage is fully on-chain ✓
- [ ] Gas costs are considered and optimized ✓
- [ ] No external dependencies introduced ✓
- [ ] Frontend operates using only blockchain data ✓
- [ ] Implementation is feasible with current technology ✓
- [ ] Security considerations are addressed ✓
- [ ] Upgrade path is defined (chapter system) ✓

**Next Steps**: Begin Phase 1 implementation with core smart contract development and basic frontend prototype.
# Transformation Layer Architecture: Perplexity → Safe Memory

**Date:** 2025-11-12
**Status:** Discovery Phase - Architectural Design
**Purpose:** Convert Perplexity AI conversations into safely consumable memory graphs for local AI agents

---

## Executive Summary

**Problem:** Local AI agents (Claude Code, Gemini CLI) need to consume external AI research (Perplexity) without context contamination, attribution confusion, or instruction leakage.

**Solution:** A transformation layer that converts Perplexity conversation logs into schema-validated, attributed, contamination-safe memory graphs.

**Key Insight:** Direct consumption of conversation logs is unsafe. Transformation to memory graph creates a safe abstraction layer.

---

## Design Principles

### 1. Safety First
- Contamination prevention is the primary design constraint
- Attribution must be explicit and unambiguous
- Instructions/prompts must never enter the knowledge base
- Speaker identity must be preserved and clear

### 2. Token Efficiency
- "In context every token is sacred"
- Selective retrieval (query only relevant knowledge)
- Compressed representation (facts, not verbatim conversations)
- No loading entire conversation history

### 3. AI-First
- Primary user is local AI agent (Claude Code, Gemini CLI)
- Human benefit is derivative
- Autonomous operation preferred
- Clear APIs for AI consumption

### 4. Foundation Imperatives Alignment
- **Configurability:** Schema, extraction rules, storage format all configurable
- **Modularity:** Independent components (capture, transform, store, query)
- **Extensibility:** Can add new extraction patterns, storage backends
- **Integration:** GitHub-native storage, MCP-compatible query layer
- **Automation:** End-to-end automated pipeline

---

## High-Level Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    PERPLEXITY AI                           │
│                  (External Research)                       │
└────────────────────────────────────────────────────────────┘
                           ↓
                   [Conversation Export]
                    (JSON preferred)
                           ↓
┌────────────────────────────────────────────────────────────┐
│               TRANSFORMATION LAYER                         │
│                                                            │
│  ┌──────────────────────────────────────────────────┐     │
│  │ Stage 1: Capture & Parse                         │     │
│  │ - Browser automation / API / Manual export       │     │
│  │ - Parse JSON/Markdown structure                  │     │
│  │ - Extract message pairs with metadata            │     │
│  └──────────────────────────────────────────────────┘     │
│                           ↓                                │
│  ┌──────────────────────────────────────────────────┐     │
│  │ Stage 2: Attribution & Validation                │     │
│  │ - Validate speaker roles (user/AI)               │     │
│  │ - Extract timestamps, session metadata           │     │
│  │ - Identify conversation context/purpose          │     │
│  └──────────────────────────────────────────────────┘     │
│                           ↓                                │
│  ┌──────────────────────────────────────────────────┐     │
│  │ Stage 3: Knowledge Extraction                    │     │
│  │ - LLM-driven entity/relationship extraction      │     │
│  │ - Separate facts from scaffolding                │     │
│  │ - Extract temporal progression                   │     │
│  │ - Capture process memory (why asked)             │     │
│  └──────────────────────────────────────────────────┘     │
│                           ↓                                │
│  ┌──────────────────────────────────────────────────┐     │
│  │ Stage 4: Simplification & Filtering              │     │
│  │ - Schema-compliant facts only                    │     │
│  │ - Strip instructions/prompts                     │     │
│  │ - Remove conversational scaffolding              │     │
│  │ - Deduplicate, normalize                         │     │
│  └──────────────────────────────────────────────────┘     │
│                           ↓                                │
│  ┌──────────────────────────────────────────────────┐     │
│  │ Stage 5: Graph Construction                      │     │
│  │ - Build nodes (entities, concepts, findings)     │     │
│  │ - Build edges (relationships, informed-by)       │     │
│  │ - Attach attribution metadata                    │     │
│  │ - Add temporal markers                           │     │
│  └──────────────────────────────────────────────────┘     │
│                           ↓                                │
│  ┌──────────────────────────────────────────────────┐     │
│  │ Stage 6: Schema Enforcement                      │     │
│  │ - Validate against schema                        │     │
│  │ - Reject non-compliant nodes/edges               │     │
│  │ - Quality checks (attribution present, etc.)     │     │
│  └──────────────────────────────────────────────────┘     │
└────────────────────────────────────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────────────┐
│                  STORAGE LAYER                             │
│  - GitHub repository (Markdown + JSON)                     │
│  - Knowledge graph files                                   │
│  - Temporal index                                          │
│  - Attribution index                                       │
└────────────────────────────────────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────────────┐
│                  QUERY LAYER                               │
│  - Semantic search                                         │
│  - Temporal queries                                        │
│  - Attribution-aware retrieval                             │
│  - Selective loading (token-efficient)                     │
└────────────────────────────────────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────────────┐
│            LOCAL AI AGENTS                                 │
│       (Claude Code, Gemini CLI)                            │
│  - Query knowledge safely                                  │
│  - No contamination risk                                   │
│  - Clear attribution                                       │
└────────────────────────────────────────────────────────────┘
```

---

## Stage-by-Stage Breakdown

### Stage 1: Capture & Parse

**Purpose:** Obtain Perplexity conversation in structured format

**Input:**
- Perplexity conversation (via API, wrapper, or manual export)

**Process:**
1. **Capture method** (multiple options, priority order):
   - Option A: Perplexity API (if cost-viable in future)
   - Option B: Python wrapper (wallaceokeke/perplexity-ai-wrapper)
   - Option C: Manual export with structured template

2. **Parse structure:**
   - Identify message pairs (user question → AI response)
   - Extract metadata (timestamps, session ID)
   - Validate format (JSON preferred, Markdown fallback)

3. **Preserve:**
   - Speaker roles (user vs AI)
   - Temporal order
   - Citation links
   - Conversation context

**Output:**
```json
{
  "session_id": "session-20251112-perplexity-research",
  "timestamp": "2025-11-12T10:30:00Z",
  "context": "Discovery phase: researching integration paths",
  "messages": [
    {
      "role": "user",
      "timestamp": "2025-11-12T10:30:00Z",
      "content": "What technical integration paths exist for Perplexity AI?"
    },
    {
      "role": "assistant",
      "timestamp": "2025-11-12T10:30:15Z",
      "content": "...",
      "citations": [...]
    }
  ]
}
```

**Contamination Prevention:**
- ✅ Speaker roles explicit
- ✅ Temporal order preserved
- ✅ Metadata separated from content

---

### Stage 2: Attribution & Validation

**Purpose:** Validate structure and enrich attribution metadata

**Input:** Parsed conversation JSON

**Process:**
1. **Validate roles:**
   - Ensure alternating user/AI structure
   - Flag anomalies (missing roles, unexpected formats)

2. **Extract conversation metadata:**
   - Purpose/intent (why was this research done?)
   - Project context (which project/decision it informs)
   - Phase context (foundation, discovery, implementation)

3. **Enrich citations:**
   - Parse citation links
   - Validate source attribution
   - Mark external sources vs AI-generated content

4. **Identify progression:**
   - Initial question → follow-up → refinement
   - Track how understanding evolved
   - Mark final vs intermediate findings

**Output:**
```json
{
  "session_id": "session-20251112-perplexity-research",
  "attribution": {
    "source": "Perplexity AI",
    "date": "2025-11-12",
    "context": "Discovery phase - Question 1",
    "informed_decisions": ["ADR-008"],
    "project": "Perplex"
  },
  "progression": {
    "initial_understanding": "...",
    "refinements": [...],
    "final_understanding": "..."
  },
  "validated_messages": [...]
}
```

**Contamination Prevention:**
- ✅ Source explicitly labeled (Perplexity AI)
- ✅ Project context separated
- ✅ Progression tracked (temporal understanding)

---

### Stage 3: Knowledge Extraction

**Purpose:** Extract entities, relationships, and findings from conversation content

**Input:** Validated, attributed conversation

**Process:**

1. **LLM-driven extraction** (using local AI or extraction service):

   **Extraction prompt pattern:**
   ```
   ROLE: Knowledge Extractor
   TASK: Extract structured knowledge from external AI conversation

   INPUT: Perplexity AI conversation about [topic]

   EXTRACT:
   - Entities (concepts, tools, technologies, patterns)
   - Relationships (A relates to B, A informs C)
   - Findings (conclusions, recommendations)
   - Citations (source attribution for claims)

   SCHEMA:
   {
     "entities": [
       {"name": "...", "type": "...", "description": "..."}
     ],
     "relationships": [
       {"subject": "...", "predicate": "...", "object": "..."}
     ],
     "findings": [
       {"claim": "...", "evidence": "...", "source": "..."}
     ]
   }

   CRITICAL:
   - Extract ONLY factual content
   - DO NOT include conversation scaffolding
   - DO NOT include prompts or meta-discussion
   - Preserve source attribution for all claims
   ```

2. **Entity extraction:**
   - Identify concepts, tools, solutions mentioned
   - Extract properties/characteristics
   - Classify entity types (tool, pattern, concept, finding)

3. **Relationship extraction:**
   - Subject-Predicate-Object triplets
   - "Tool X solves problem Y"
   - "Pattern A enables capability B"
   - "Finding C informed decision D"

4. **Temporal extraction:**
   - Track when understanding changed
   - "Initial finding → Revised finding"
   - Mark refinement points

5. **Process memory extraction:**
   - WHY this research was conducted
   - WHAT question it addressed
   - HOW it informed decisions

**Output:**
```json
{
  "entities": [
    {
      "id": "entity-basic-memory",
      "name": "Basic Memory",
      "type": "tool",
      "description": "Local-first semantic memory system",
      "properties": {
        "storage": "Markdown",
        "architecture": "MCP-based",
        "attribution": "None documented"
      }
    }
  ],
  "relationships": [
    {
      "subject": "entity-basic-memory",
      "predicate": "lacks",
      "object": "speaker-attribution-mechanism"
    },
    {
      "subject": "entity-basic-memory",
      "predicate": "suitable-for",
      "object": "note-taking-not-conversation-processing"
    }
  ],
  "findings": [
    {
      "claim": "No production tools solve external AI conversation contamination",
      "evidence": "Analysis of Basic Memory, Graphiti, Neo4j, ai-knowledge-graph",
      "confidence": "high",
      "source": "Perplexity AI analysis",
      "citations": [...]
    }
  ],
  "process_memory": {
    "why_asked": "Discovery phase: identify technical integration paths",
    "question_addressed": "What solutions exist for conversation-to-graph transformation?",
    "informed_decisions": ["ADR-008"],
    "phase": "discovery"
  }
}
```

**Contamination Prevention:**
- ✅ Extraction prompt explicitly filters scaffolding
- ✅ Schema-driven (only compliant output accepted)
- ✅ Source attribution preserved in findings

---

### Stage 4: Simplification & Filtering

**Purpose:** Apply CooperKGC-inspired simplification function to strip contamination vectors

**Input:** Extracted knowledge (entities, relationships, findings)

**Process:**

1. **Simplification function** (inspired by CooperKGC):
   ```python
   def simplify(extracted_knowledge):
       """
       Filter complex extraction to schema-compliant facts only.
       Remove conversational scaffolding, instructions, prompts.
       """

       # Filter entities
       entities = [
           e for e in extracted_knowledge['entities']
           if validate_entity_schema(e) and not is_meta_content(e)
       ]

       # Filter relationships
       relationships = [
           r for r in extracted_knowledge['relationships']
           if validate_relationship_schema(r) and not is_instruction(r)
       ]

       # Filter findings
       findings = [
           f for f in extracted_knowledge['findings']
           if has_evidence(f) and has_attribution(f)
       ]

       return {
           'entities': entities,
           'relationships': relationships,
           'findings': findings
       }
   ```

2. **Instruction filtering:**
   - Detect imperative language ("you should", "must", "create")
   - Remove content that looks like prompts or commands
   - Keep only declarative facts

3. **Scaffolding removal:**
   - Remove meta-discussion ("Let's analyze", "To understand")
   - Remove conversational fillers
   - Keep substantive content only

4. **Deduplication:**
   - Merge duplicate entities
   - Normalize entity names
   - Consolidate redundant relationships

5. **Quality validation:**
   - Every finding must have evidence
   - Every claim must have attribution
   - Every entity must have description
   - Every relationship must connect valid entities

**Output:**
```json
{
  "simplified_knowledge": {
    "entities": [...],  // Only schema-compliant, non-meta
    "relationships": [...],  // Only facts, no instructions
    "findings": [...]  // Only evidenced, attributed claims
  },
  "filtered_out": {
    "reason": "instruction_detected",
    "count": 3
  }
}
```

**Contamination Prevention:**
- ✅ Instruction detection and removal
- ✅ Scaffolding stripped
- ✅ Schema validation enforced
- ✅ Attribution required

**This is the critical firewall between conversation and knowledge.**

---

### Stage 5: Graph Construction

**Purpose:** Build memory graph with nodes, edges, and metadata

**Input:** Simplified, filtered knowledge

**Process:**

1. **Node creation:**
   ```json
   {
     "node_id": "entity-basic-memory",
     "node_type": "tool",
     "label": "Basic Memory",
     "properties": {
       "description": "...",
       "characteristics": [...]
     },
     "metadata": {
       "source": "Perplexity AI",
       "session": "session-20251112-perplexity-research",
       "timestamp": "2025-11-12T10:30:00Z",
       "context": "Discovery phase",
       "attribution": "External AI research",
       "project": "Perplex"
     }
   }
   ```

2. **Edge creation:**
   ```json
   {
     "edge_id": "rel-001",
     "edge_type": "relationship",
     "subject": "entity-basic-memory",
     "predicate": "lacks",
     "object": "speaker-attribution",
     "metadata": {
       "source": "Perplexity AI",
       "timestamp": "2025-11-12T10:30:00Z",
       "evidence": "No attribution mechanism documented",
       "confidence": "high"
     }
   }
   ```

3. **Temporal edges:**
   - Connect initial understanding → revised understanding
   - Mark progression over time
   - Enable temporal queries

4. **Process memory nodes:**
   ```json
   {
     "node_id": "research-context-001",
     "node_type": "process_memory",
     "properties": {
       "why_asked": "Identify integration paths",
       "question": "What solutions exist?",
       "informed": ["ADR-008"],
       "phase": "discovery"
     },
     "edges": [
       {"to": "entity-basic-memory", "type": "analyzed"},
       {"to": "entity-graphiti", "type": "analyzed"}
     ]
   }
   ```

5. **Citation nodes:**
   - External sources as separate nodes
   - Connected to findings they support
   - Preserve URL, date, author if available

**Output:** Complete knowledge graph in memory-safe format

**Contamination Prevention:**
- ✅ Every node has explicit source attribution
- ✅ External origin clearly marked
- ✅ Process memory separated from factual content
- ✅ Temporal progression tracked

---

### Stage 6: Schema Enforcement

**Purpose:** Final validation before storage

**Input:** Constructed graph

**Process:**

1. **Schema validation:**
   ```yaml
   schema:
     node:
       required_fields:
         - node_id
         - node_type
         - metadata.source
         - metadata.timestamp
         - metadata.attribution
       forbidden_patterns:
         - imperative_language
         - first_person_references
         - instruction_indicators

     edge:
       required_fields:
         - subject (must reference valid node)
         - predicate
         - object (must reference valid node)
         - metadata.source

     finding:
       required_fields:
         - claim
         - evidence
         - source_attribution
   ```

2. **Quality checks:**
   - All nodes have source attribution?
   - All relationships connect valid entities?
   - All findings have evidence and attribution?
   - No orphaned nodes?
   - Temporal consistency (no future timestamps)?

3. **Rejection handling:**
   - Log rejected nodes/edges
   - Flag for human review if ambiguous
   - Do not store non-compliant data

4. **Validation report:**
   ```json
   {
     "validated": 45,
     "rejected": 3,
     "reasons": {
       "missing_attribution": 2,
       "instruction_detected": 1
     }
   }
   ```

**Output:** Validated, safe-to-store knowledge graph

**Contamination Prevention:**
- ✅ Schema enforcement blocks contamination
- ✅ Rejected content never enters storage
- ✅ Validation report provides transparency

---

## Storage Layer

**Purpose:** Persist knowledge graph in token-efficient, queryable format

### Storage Format

**Option 1: JSON-based (Simple, GitHub-native)**

```
/knowledge/
  external/
    perplexity/
      sessions/
        session-20251112-perplexity-research/
          metadata.json          # Session info, attribution, context
          nodes.json            # All nodes with full metadata
          edges.json            # All relationships
          temporal-index.json   # Timestamp-based index
          attribution-index.json # Source-based index
```

**Option 2: Hybrid (Markdown + JSON)**

```
/knowledge/
  external/
    perplexity/
      sessions/
        session-20251112-perplexity-research/
          README.md             # Human-readable summary
          graph.json            # Machine-readable graph
          nodes/
            entity-basic-memory.md  # Individual node files
            entity-graphiti.md
          metadata.json         # Session metadata
```

**Option 3: Graph Database (Future)**

- Neo4j, SQLite with graph extension
- More powerful queries but higher complexity
- Defer until proven necessary

### Indexes for Token Efficiency

**Temporal Index:**
```json
{
  "2025-11-12": ["session-20251112-perplexity-research"],
  "discovery-phase": ["session-20251112-perplexity-research"]
}
```

**Topic Index:**
```json
{
  "integration-patterns": ["session-20251112-perplexity-research"],
  "knowledge-graphs": ["session-20251112-perplexity-research"],
  "semantic-memory": ["session-20251112-perplexity-research"]
}
```

**Attribution Index:**
```json
{
  "Perplexity AI": ["session-20251112-perplexity-research"],
  "GitHub Copilot": ["session-20251111-ai-research"],
  "User": ["all-sessions"]
}
```

**Purpose:** Enable selective loading without reading entire graph

---

## Query Layer

**Purpose:** Provide token-efficient, contamination-safe access for local AI

### Query Patterns

**1. Semantic Query:**
```python
query = {
  "topic": "knowledge graph transformation",
  "type": "tools",
  "source": "Perplexity AI",
  "date_range": "2025-11-01 to 2025-11-30"
}

results = knowledge_base.search(query)
# Returns: relevant nodes + edges + attribution metadata
```

**2. Temporal Query:**
```python
query = {
  "entity": "Basic Memory",
  "show_evolution": True,
  "from": "initial",
  "to": "final"
}

results = knowledge_base.get_evolution(query)
# Returns: How understanding of Basic Memory changed over time
```

**3. Process Memory Query:**
```python
query = {
  "decision": "ADR-008",
  "get_research": True
}

results = knowledge_base.get_supporting_research(query)
# Returns: All research that informed ADR-008
```

**4. Attribution Query:**
```python
query = {
  "source": "Perplexity AI",
  "session": "session-20251112-perplexity-research"
}

results = knowledge_base.get_by_source(query)
# Returns: All knowledge from specific source/session
```

### API for Local AI Agents

**Claude Code / Gemini CLI Integration:**

```python
# Query example from local AI
from perplex_knowledge import PerplexKnowledge

kb = PerplexKnowledge(repo_path="/home/user/perplex")

# Semantic search
findings = kb.search(
    topic="semantic memory systems",
    source_filter="Perplexity AI",
    format="markdown"  # AI-readable format
)

# Results include clear attribution
for finding in findings:
    print(f"Finding: {finding.claim}")
    print(f"Source: {finding.source}")  # Always "Perplexity AI" + session
    print(f"Evidence: {finding.evidence}")
    print(f"Context: {finding.context}")  # Discovery phase, etc.
```

**Contamination Prevention in Query Layer:**
- ✅ Results always include attribution header
- ✅ Source explicitly labeled
- ✅ Format designed for safe AI consumption
- ✅ No raw conversation content returned

---

## Contamination Prevention Mechanisms Summary

### Architectural Safeguards

| Layer | Mechanism | Purpose |
|-------|-----------|---------|
| **Capture** | Structured format (JSON) | Explicit speaker roles |
| **Attribution** | Metadata enrichment | Source/context/project tracking |
| **Extraction** | LLM prompt filtering | Extract facts, ignore scaffolding |
| **Simplification** | Instruction detection | Remove commands/prompts |
| **Filtering** | Schema validation | Block non-compliant content |
| **Graph** | Attribution metadata on every node | Traceable origin |
| **Schema Enforcement** | Validation layer | Final firewall |
| **Storage** | Indexed, attributed files | Selective retrieval |
| **Query** | Attribution in results | Safe consumption |

### Inspired by Research

**From CooperKGC:**
- Simplification function (complex reasoning → schema facts)
- Schema enforcement layer
- Source attribution labels
- Interaction limits (one-time extraction)

**From Perplexity Feedback:**
- JSON format preference
- Role-based filtering (user/AI distinction)
- Citation preservation
- Temporal metadata tracking

**From Our Analysis:**
- Instruction filtering (imperative language detection)
- Process memory nodes (why/what/how)
- Progressive understanding tracking
- Context isolation (project/phase segregation)

---

## Token Efficiency Strategy

### Problem: "In Context Every Token is Sacred"

**Challenge:** Loading entire conversation history = thousands of tokens

**Solution:** Multi-level retrieval

### Level 1: Index Query (Minimal Tokens)

```json
{
  "query": "semantic memory systems",
  "results": [
    {
      "session": "session-20251112",
      "topic": "Knowledge graph transformation",
      "relevance": 0.95,
      "node_count": 12
    }
  ]
}
```

**Token cost:** ~50 tokens (index only)

### Level 2: Summary Retrieval (Low Tokens)

```markdown
Session: session-20251112-perplexity-research
Source: Perplexity AI
Context: Discovery phase - integration paths

Key Findings:
- Basic Memory lacks attribution (not suitable)
- Graphiti has temporal tracking (promising)
- CooperKGC pattern solves contamination (research only)

Nodes: 45 | Relationships: 78 | Citations: 23
```

**Token cost:** ~200 tokens (summary)

### Level 3: Full Graph (High Tokens, Selective)

```json
{
  "nodes": [...],  // All 45 nodes
  "edges": [...],  // All 78 relationships
  "metadata": {...}
}
```

**Token cost:** ~2000-3000 tokens (full graph)

**Strategy:** Query index → retrieve summary → decide if full graph needed

**Contrast with "just read conversation":**
- Raw conversation: 10,000+ tokens
- Index query: 50 tokens
- Summary: 200 tokens
- Full graph (if needed): 2,000 tokens

**Savings: 5-10x token efficiency**

---

## Implementation Considerations

### Technology Stack Options

**Option 1: Python-based (Recommended for prototyping)**

```
Components:
- Capture: wallaceokeke/perplexity-ai-wrapper
- Parsing: Python json/markdown libraries
- Extraction: LLM API calls (OpenAI, Anthropic, local)
- Storage: JSON files in GitHub repo
- Query: Custom Python module
```

**Pros:**
- Fast prototyping
- Rich ecosystem
- Easy LLM integration

**Cons:**
- Python dependency for local AI agents
- Not as lightweight as native tools

---

**Option 2: TypeScript/Node.js**

```
Components:
- Capture: Playwright-based wrapper
- Parsing: TypeScript with zod schema validation
- Extraction: LLM SDK calls
- Storage: JSON + SQLite for indexing
- Query: TypeScript API
```

**Pros:**
- MCP server integration easier
- Better Claude Desktop integration
- Type safety

**Cons:**
- More complex setup
- Heavier runtime

---

**Option 3: Hybrid (Recommended for production)**

```
Components:
- Capture: Python wrapper (best option available)
- Transformation: Python scripts (LLM integration)
- Storage: JSON files (language-agnostic)
- Query: MCP server (TypeScript) for Claude Desktop
         + Python module for CLI agents
```

**Pros:**
- Best-of-breed components
- Flexible integration
- Language-agnostic storage

**Cons:**
- More moving parts
- Coordination complexity

---

### LLM for Extraction

**Options:**

1. **Local LLM (Token-efficient, private):**
   - Ollama with Llama/Mistral
   - No API costs
   - Privacy-preserving
   - May have lower extraction quality

2. **Cloud LLM (Higher quality, cost):**
   - OpenAI GPT-4o (structured output support)
   - Anthropic Claude (strong reasoning)
   - Google Gemini (Perplexity recommended)
   - API costs per extraction

3. **Hybrid:**
   - Local LLM for initial extraction
   - Cloud LLM for validation/refinement
   - Balance cost and quality

**Recommendation:** Start with cloud (validate approach), migrate to local if viable.

---

### Integration with Existing Tools

**Basic Memory:**
- Could use as storage backend (if attribution added)
- MCP integration exists
- Would need customization

**Graphiti:**
- Could use for temporal tracking
- MCP integration exists
- Would need conversation preprocessing

**Custom Solution:**
- Full control over contamination prevention
- Optimized for our use case
- More development effort

**Recommendation:** Custom transformation layer, evaluate storage/query layer separately.

---

## Open Questions & Next Steps

### Questions Requiring User Input

1. **Capture method priority:**
   - Start with manual export (template-based)?
   - Invest in wrapper integration first?
   - Wait for API cost clarity?

2. **LLM for extraction:**
   - Use cloud LLM (cost acceptable)?
   - Require local LLM (privacy/cost)?
   - Hybrid acceptable?

3. **Storage format preference:**
   - JSON-only (simple, queryable)?
   - Markdown+JSON (human-readable)?
   - Graph DB later if needed?

4. **MCP vs. direct file access:**
   - Build MCP server for query layer?
   - Let AI agents read files directly?
   - Both (phased approach)?

5. **Scope for first implementation:**
   - Full pipeline (capture → query)?
   - Transform-only (assume manual capture)?
   - Proof-of-concept with single conversation?

---

### Next Steps (Proposed)

**If architecture approved:**

1. **Prototype Phase:**
   - Take ONE Perplexity conversation (the one you provided)
   - Manually implement transformation pipeline
   - Validate contamination prevention
   - Test with Claude Code consumption

2. **Validation Phase:**
   - Does local AI understand attribution?
   - Does query layer prevent contamination?
   - Is token efficiency achieved?
   - Can AI use knowledge without confusion?

3. **Automation Phase:**
   - Script the transformation pipeline
   - Integrate capture mechanism
   - Build query API/MCP server
   - Document for future sessions

4. **Integration Phase:**
   - Test with real discovery work
   - Iterate based on usage
   - Optimize token efficiency
   - Scale to multiple conversations

---

## Alignment with Foundation Imperatives

### Holistic System Thinking ✅
- Considered entire pipeline (capture → storage → query → consumption)
- Designed for system-wide contamination prevention
- Token efficiency impacts all stages

### AI-First ✅
- Primary user is local AI agent
- Query API designed for AI consumption
- Attribution prevents AI confusion

### Configurability ✅
- Schema configurable
- Extraction prompts customizable
- Storage format flexible
- Query parameters adjustable

### Modularity ✅
- Independent stages (capture, transform, store, query)
- Replaceable components (LLM, storage backend)
- Clear interfaces between layers

### Extensibility ✅
- Can add new extraction patterns
- Can add new storage backends
- Can add new query types
- Schema can evolve

### Integration ✅
- GitHub-native storage
- MCP-compatible query layer
- Works with existing tools (Claude Code, Gemini CLI)

### Automation ✅
- End-to-end pipeline automatable
- No manual intervention required (after capture)
- Scriptable, repeatable

---

## References

- **Research:** CooperKGC multi-agent collaboration patterns
- **Feedback:** Perplexity AI's own recommendations
- **Tools Analyzed:** Basic Memory, Graphiti, Neo4j LLM KB Builder, ai-knowledge-graph
- **Inspiration:** Gemini CLI failed experiment (what NOT to do)

---

**Status:** Architectural design complete, awaiting user validation and prioritization for implementation.

**Last Updated:** 2025-11-12
**Next Review:** After user feedback on architecture and open questions

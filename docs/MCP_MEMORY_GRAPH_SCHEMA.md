# MCP Memory Graph Schema

**Purpose:** Define the JSONL format for memory graphs exported by perplex-transformer and imported to MCP memory server

**Target System:** @modelcontextprotocol/server-memory (Official Anthropic MCP memory server)

**Status:** Draft - awaiting implementation and validation

**Last Updated:** 2025-11-12

---

## Overview

The memory graph schema bridges Perplexity AI conversation logs with MCP memory server's knowledge graph storage. perplex-transformer outputs memory graphs in this format, which perplex-reader imports using MCP memory server tools.

**Format:** JSONL (JSON Lines) - newline-delimited JSON
**Storage:** One JSON object per line, each representing either an entity or relation

---

## MCP Memory Server Format

The official MCP memory server (@modelcontextprotocol/server-memory) uses the following structures:

### Entity Structure

```json
{
  "name": "unique-entity-identifier",
  "entityType": "classification-category",
  "observations": [
    "atomic fact 1 about this entity",
    "atomic fact 2 about this entity",
    "atomic fact 3 with attribution [Source: URL]"
  ]
}
```

**Field Specifications:**

- **name** (string, required):
  - Unique identifier for the entity
  - Should be human-readable and descriptive
  - Examples: "context-contamination-risk", "CooperKGC-framework", "Perplexity-API"
  - Naming convention: kebab-case for multi-word concepts

- **entityType** (string, required):
  - Classification/category of the entity
  - Common types: "concept", "technology", "person", "organization", "finding", "technique", "constraint"
  - Used for querying and filtering

- **observations** (array of strings, required):
  - Atomic, independent facts about the entity
  - Each observation should be self-contained
  - Include attribution when from external source
  - Examples:
    - "Perplexity API is prohibitively expensive for individual users"
    - "CooperKGC uses simplification function to prevent contamination [Source: Research paper]"
    - "Token efficiency is a design constraint, not just optimization"

### Relation Structure

```json
{
  "from": "source-entity-name",
  "to": "target-entity-name",
  "relationType": "relationship-descriptor-active-voice"
}
```

**Field Specifications:**

- **from** (string, required):
  - Source entity name (must match an existing entity's `name` field)
  - The subject of the relationship

- **to** (string, required):
  - Target entity name (must match an existing entity's `name` field)
  - The object of the relationship

- **relationType** (string, required):
  - Relationship descriptor in active voice
  - Describes how `from` relates to `to`
  - Common types: "uses", "requires", "enables", "conflicts-with", "implements", "depends-on", "informed-by", "validates"
  - Examples:
    - from: "perplex-transformer", to: "CooperKGC-simplification", relationType: "uses"
    - from: "contamination-prevention", to: "schema-enforcement", relationType: "requires"

---

## Memory Graph JSONL Format

A complete memory graph file contains both entities and relations:

```jsonl
{"name": "perplexity-ai", "entityType": "technology", "observations": ["Research-focused AI with strong search capabilities", "Cannot afford API access (prohibitively expensive)", "User-mediated workflow with human as bridge"]}
{"name": "context-contamination", "entityType": "risk", "observations": ["Occurs when external AI conversations are read directly", "Causes attribution confusion (who said what)", "Can leak instructions into data"]}
{"name": "mcp-memory-server", "entityType": "technology", "observations": ["Official Anthropic memory system", "Uses JSONL knowledge graph format", "Provides 9 tools: create, read, update, delete, search"]}
{"name": "CooperKGC-simplification", "entityType": "technique", "observations": ["Filters extracted knowledge to schema-compliant facts only", "Removes conversational scaffolding and instructions", "Serves as contamination firewall in transformation pipeline"]}
{"from": "perplex-transformer", "to": "CooperKGC-simplification", "relationType": "uses"}
{"from": "context-contamination", "to": "schema-enforcement", "relationType": "mitigated-by"}
{"from": "perplex-reader", "to": "mcp-memory-server", "relationType": "imports-to"}
```

**Validation Rules:**

1. Each line must be valid JSON
2. Each JSON object must have either:
   - Entity fields: name, entityType, observations
   - OR Relation fields: from, to, relationType
3. Relation `from` and `to` must reference existing entity names
4. Entity names must be unique within a graph
5. Observations must be non-empty strings
6. All fields are required (no optional fields)

---

## Perplexity Conversation to Memory Graph Mapping

### Entity Types from Perplexity Conversations

| Conversation Element | Entity Type | Examples |
|---------------------|-------------|----------|
| Technologies mentioned | "technology" | "Python", "uv package manager", "GitHub Spec Kit" |
| Concepts discussed | "concept" | "context contamination", "token efficiency", "multi-AI synergy" |
| Research findings | "finding" | "Perplexity API cost prohibitive", "Different AIs have different talents" |
| Constraints identified | "constraint" | "No Perplexity API access", "Non-technical user requirement" |
| Techniques/patterns | "technique" | "Simplification function", "Transformer project pattern" |
| People/organizations | "person" / "organization" | "Anthropic", "User" |
| Tools/frameworks | "tool" | "GitHub Spec Kit", "MCP memory server" |

### Relation Types from Perplexity Conversations

| Conversation Pattern | Relation Type | Example |
|---------------------|---------------|---------|
| "X uses Y" | "uses" | transformer uses simplification function |
| "X requires Y" | "requires" | contamination prevention requires schema enforcement |
| "X enables Y" | "enables" | proper methodology enables trust |
| "X solves Y" | "solves" | transformer pattern solves contamination risk |
| "X conflicts with Y" | "conflicts-with" | API cost conflicts with budget constraint |
| "X informs Y" | "informed-by" | decision informed by CooperKGC research |
| "X validates Y" | "validates" | end-to-end test validates architecture |
| "X depends on Y" | "depends-on" | perplex-reader depends on MCP memory server |

---

## Attribution Metadata

All observations from external sources (Perplexity research, papers, documentation) MUST include attribution:

**Format:** `[Source: description]` or `[Source: URL]` appended to observation

**Examples:**

```json
{
  "name": "CooperKGC-framework",
  "entityType": "technique",
  "observations": [
    "Multi-agent system for knowledge graph construction",
    "Uses simplification function to filter contamination [Source: CooperKGC research paper]",
    "Implements schema enforcement as validation firewall [Source: CooperKGC GitHub]"
  ]
}
```

**Attribution is CRITICAL for:**
- Traceability (where did this knowledge come from?)
- Trustworthiness (can we verify this claim?)
- Avoiding plagiarism (proper credit to sources)
- Debugging (if knowledge is wrong, trace back to source)

---

## Schema Validation Rules

### Entity Validation

1. **Name uniqueness**: No duplicate entity names within a graph
2. **Name format**: Kebab-case preferred, human-readable
3. **EntityType constraints**: Must be from allowed taxonomy (concept, technology, person, organization, finding, technique, constraint, tool)
4. **Observations non-empty**: At least one observation required
5. **Observation atomicity**: Each observation is single, independent fact
6. **Attribution present**: External sources must have [Source: ...] in observation

### Relation Validation

1. **Entity existence**: Both `from` and `to` must reference existing entities
2. **RelationType constraints**: Must be from allowed taxonomy or clearly descriptive active-voice verb
3. **No self-loops**: `from` ≠ `to` (entity cannot relate to itself)
4. **Direction matters**: Relations are directional (from → to), not bidirectional

### Graph-Level Validation

1. **JSONL format**: Each line is valid JSON
2. **Complete graph**: All referenced entities exist before relations reference them
3. **Consistency**: No conflicting observations or relations
4. **Provenance**: Clear attribution chain from Perplexity conversation to entities

---

## Example: Complete Memory Graph

Input: Perplexity conversation about context contamination in AI systems

Output: `perplexity-research-contamination.jsonl`

```jsonl
{"name": "context-contamination", "entityType": "risk", "observations": ["Occurs when AI agents read external AI conversations directly", "Causes attribution confusion between user, external AI, and local AI", "Can leak instructions or prompts into knowledge base [Source: Perplexity AI conversation 2025-11-12]"]}
{"name": "simplification-function", "entityType": "technique", "observations": ["Filters extracted knowledge to schema-compliant facts only", "Removes conversational scaffolding, instructions, and prompts", "Implemented in Stage 4 of transformation pipeline", "Inspired by CooperKGC multi-agent framework [Source: CooperKGC research]"]}
{"name": "schema-enforcement", "entityType": "technique", "observations": ["Validates all entities and relations against defined schema", "Rejects non-compliant data before storage", "Acts as final firewall in transformation pipeline"]}
{"name": "transformer-project-pattern", "entityType": "pattern", "observations": ["Dedicated project for processing external AI conversations", "Accepts ephemeral contamination, cleaned after each use", "Outputs validated, safe memory graphs for import [Source: User insight during discovery phase]"]}
{"from": "simplification-function", "to": "context-contamination", "relationType": "mitigates"}
{"from": "schema-enforcement", "to": "simplification-function", "relationType": "validates-output-of"}
{"from": "transformer-project-pattern", "to": "simplification-function", "relationType": "uses"}
{"from": "transformer-project-pattern", "to": "context-contamination", "relationType": "prevents"}
```

**Interpretation:**

- 4 entities extracted from conversation
- 4 relationships identified
- All observations include context or attribution
- Relations form coherent graph showing how techniques address risks

**Query Examples (using MCP memory server):**

- `search_nodes("contamination")` → finds context-contamination entity
- `open_nodes(["transformer-project-pattern"])` → shows pattern with all connections
- `read_graph()` → returns entire graph structure

---

## Implementation Notes

### For perplex-transformer

1. **Stage 3 (Extraction):** Generate candidate entities and relations from conversation
2. **Stage 4 (Simplification):** Filter to schema-compliant entities/relations, add attribution
3. **Stage 5 (Graph Construction):** Format as JSONL
4. **Stage 6 (Validation):** Validate against this schema before output

### For perplex-reader

1. **Read JSONL file:** Parse line by line
2. **Separate entities and relations:** Group by type
3. **Import entities first:** Call `create_entities` tool with all entities
4. **Import relations second:** Call `create_relations` tool with all relations
5. **Verify import:** Use `read_graph` or `search_nodes` to confirm

### Error Handling

**Invalid entity:**
- Missing required field → reject, log error
- Duplicate name → skip if identical, error if different
- Invalid entityType → use "concept" as fallback or reject

**Invalid relation:**
- Missing entity → skip relation, log warning
- Invalid relationType → use "relates-to" as fallback or reject
- Self-loop → skip, log warning

**JSONL parse error:**
- Invalid JSON → skip line, log error with line number
- Continue processing remaining lines

---

## Schema Evolution

As the project matures, this schema may evolve. Changes MUST be:

1. **Backward compatible** where possible
2. **Documented** with version number and migration guide
3. **Validated** with existing memory graphs
4. **Announced** to users before deployment

**Version:** 1.0-draft (initial definition)

**Changelog:**
- 2025-11-12: Initial schema definition based on MCP memory server research

---

## Next Steps

1. **Validate schema** with sample Perplexity conversations
2. **Implement in perplex-transformer** (Stage 5 & 6)
3. **Test import** using perplex-reader with MCP memory server
4. **Iterate** based on real-world usage and edge cases discovered

---

**For AI Agents:**

This schema is the contract between perplex-transformer (producer) and perplex-reader (consumer). Follow it precisely. Any deviations risk import failures or contaminated knowledge graphs.

**For Human Users:**

This document explains how your Perplexity conversations become queryable knowledge in your local AI projects. The JSONL files are human-readable JSON, one object per line, so you can inspect and understand what's being imported.

**Last Updated:** 2025-11-12
**Status:** Draft - Stage 1 deliverable for review

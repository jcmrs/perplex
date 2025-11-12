# Process Memory: Discovery Phase Progression

**Session:** 2025-11-12 Discovery Phase
**Purpose:** Track WHY decisions were made, HOW understanding evolved, WHAT NOW
**This document:** Living memory of reasoning chains and pivots

---

## Progression of Understanding

### Initial Question (Start)
**User asked:** "What technical integration paths exist for Perplexity AI?"

**Initial assumption:** We need to automate Perplexity integration
- Thought: Find API or CLI
- Thought: Automate capture and processing
- Goal: Remove manual steps

### Pivot 1: API Not Viable
**Discovery:** Perplexity API is prohibitively expensive

**WHY this matters:**
- Invalidated primary integration path
- Forced rethinking of automation approach

**WHAT changed:** From "API-first" to "what else exists?"

### Pivot 2: Browser Automation Concerns
**Discovery:** Browser automation (wrappers) is fragile

**WHY this matters:**
- Maintenance burden high
- UI changes break automation
- Violates "automation" imperative (if it breaks constantly)

**User constraint revealed:** "In context every token is sacred"
- Not just about runtime cost
- About context window management
- About what AI can even load/process
- Token efficiency is DESIGN CONSTRAINT, not optimization

**WHAT changed:** From "automate capture" to "maybe automation isn't the goal?"

### Pivot 3: Local Alternatives Explored
**Discovery:** Perplexica, PerplexityLite exist (local research AIs)

**WHY considered:**
- No API costs
- Local control
- Stable integration (APIs we control)

**WHY rejected:**
- User insight: "Different AIs have different talents"
- Perplexity is specifically good at research/ideation
- Multi-AI synergy is REAL and MEASURABLE (not just convenience)
- Unique search mechanisms not replicated elsewhere

**WHAT changed:** From "replace Perplexity" to "work WITH Perplexity despite challenges"

### Pivot 4: Understanding Actual Workflow
**Discovery:** User is ALREADY in the loop (user-mediated workflow)

**Actual workflow:**
```
User ↔ Perplexity (conversational research)
  ↓
User exports conversation
  ↓
User provides to Claude Code
  ↓
[PROBLEM: Contamination, attribution confusion]
```

**WHY this is critical:**
- The workflow is NOT "automate everything"
- The workflow IS "make manual handoff safe"
- Human is the BRIDGE between AIs (feature, not bug)
- Goal is safe consumption, not automation

**WHAT changed:** From "automate Perplexity interaction" to "transform conversation logs safely"

### Pivot 5: CORE vs Serena
**Discovery:** User already uses Serena MCP for all projects

**WHY this matters:**
- Don't introduce new dependency (CORE) when Serena exists
- Serena already handles: persistent memory, reflections, session handover, process memory
- Integration point is obvious: output to Serena format

**WHAT changed:** From "use CORE" to "integrate with Serena"

### Pivot 6: Transformer Project Pattern
**User insight:** Contamination acceptable if ephemeral and disposable

**Pattern:**
- Dedicated project processes conversations (perplex-transformer)
- Gets contaminated during processing? OK, thrown away after
- Outputs clean, validated memory graph
- Real projects import only validated output
- Transformer cleaned for next use

**WHY this is brilliant:**
- Isolates contamination risk
- Stateless service (no cross-project pollution)
- Reusable across all projects
- Output validated before import

**WHAT changed:** From "prevent all contamination" to "isolate and dispose"

### Current State: Stage 1 Methodology Focus
**Discovery:** Need methodology/framework BEFORE coding

**WHY:**
- Pattern: Claude Code instances lose sight of product/big picture during development
- Cause: Insufficient methodology/framework foundation
- Solution: Establish "Golden Path" (atomic-level specificity) FIRST

**User observation:**
- "When AI doesn't have a name for something, it hallucinates"
- Even with frameworks, AI gets confused ("am I using Agile? or X enhanced?")
- Need CLEAR, NAMED, UNAMBIGUOUS framework adapted for AI-first

**WHAT NOW:** Establish Stage 1 deliverables before any coding

### Pivot 7: Serena vs MCP Memory Server
**Discovery:** Serena is NOT a memory system - it's a code intelligence tool

**What happened:**
- Researched Serena GitHub repository expecting memory storage features
- Found: Serena is LSP-based semantic code manipulation (find_symbol, edit code, etc.)
- The `.serena/memories/` directory contains development docs, not runtime agent memory
- MemoriesManager API mentioned in DeepWiki docs doesn't exist in repository

**The actual memory system:**
- **@modelcontextprotocol/server-memory** - Official Anthropic MCP memory server
- Knowledge graph-based persistent memory
- JSONL storage format (line-delimited JSON)
- Entities (name, entityType, observations[])
- Relations (from, to, relationType)
- 9 tools: create, read, update, delete, search

**WHY this matters:**
- Integration target is MCP memory server, not Serena
- Memory graph schema must match MCP memory server format
- perplex-reader imports to MCP memory server (not Serena)
- Serena can still be used (for code intelligence), but memory is separate

**WHAT changed:** From "integrate with Serena memory API" to "integrate with MCP memory server format"

---

## Key Insights (WHY Things Matter)

### 1. Multi-AI Synergy is Real
**What:** Different AIs have genuine specializations
**Why:** Perplexity's research/ideation capabilities aren't replaceable
**Implication:** Can't just use Claude Code alone, need the collaboration

### 2. Token Efficiency is Design Constraint
**What:** "In context every token is sacred"
**Why:** Context windows limited, loading costs real, even Claude Code has limits
**Implication:** Everything must be designed for selective, token-efficient access

### 3. User-Mediated is Feature
**What:** Human passes prompts TO Perplexity, outputs TO Claude Code
**Why:** The synergy requires both AIs, user is the bridge
**Implication:** Don't try to automate the collaboration, make the handoff safe

### 4. Contamination is Solvable via Isolation
**What:** Transformer project gets contaminated, then cleaned
**Why:** Output validated before import, contamination never reaches real projects
**Implication:** Don't need to prevent contamination everywhere, just contain it

### 5. Serena is Already There
**What:** All projects already use Serena MCP
**Why:** Persistent memory, reflections, session handover already solved
**Implication:** Integrate with Serena, don't introduce competing system

### 6. Methodology Prevents Derailment
**What:** AI loses sight of product/big picture during development
**Why:** Insufficient foundation, ambiguous framework, lack of atomic specificity
**Implication:** Can't skip methodology establishment phase

---

## Decision Chain (Traceability)

### Decision: Build Transformation Layer
**Informed by:**
- Contamination risk when Claude Code reads raw Perplexity conversations
- CooperKGC research (simplification function prevents contamination)
- Perplexity's own recommendations (JSON, role-based filtering)

**Led to:**
- 6-stage transformation architecture
- Schema enforcement as firewall
- Attribution metadata requirements

### Decision: Two Sub-Projects
**Informed by:**
- Transformer pattern insight
- Isolation of contamination
- Reusability across projects

**Led to:**
- perplex-transformer (processes conversations)
- perplex-reader (imports to Serena)

### Decision: Stage 1 Before Coding
**Informed by:**
- User's experience: Claude Code instances lose sight of goals
- Need for "Golden Path" (atomic-level specificity)
- Observation: AI hallucinates when things lack names

**Led to:**
- Methodology/framework establishment as prerequisite
- Technology stack validation before commitment
- Deliverables defined before implementation

---

## Open Loops (What's Unresolved)

### ~~1. Which Development Methodology?~~ ✅ RESOLVED
~~**Question:** SDD? Lean? Shape Up? Agile adapted for AI?~~
**RESOLVED:** Spec-Driven Development (SDD) with GitHub Spec Kit
**Resolution:** 4 phases (Specify → Plan → Tasks → Implement), living specs, atomic tasks, checkpoints

### ~~2. Technology Stack~~ ✅ RESOLVED
~~**Question:** Python (proven but legacy concerns)? Deno (modern but feasibility unknown)? Other?~~
**RESOLVED:** Python 3.11 + uv package manager
**Resolution:** Environment validated, matches Serena stack, modern Python (not legacy 2.x)

### ~~3. Serena Integration Depth~~ ✅ RESOLVED (CORRECTED)
~~**Question:** Simple prompt? Serena plugin? Hybrid?~~
**RESOLVED:** Integration target is MCP memory server, not Serena
**Resolution:** Serena = code intelligence tool (LSP). Memory = @modelcontextprotocol/server-memory (JSONL knowledge graph)

### 4. Memory Graph Schema ⏳ IN PROGRESS
**Question:** Exact JSON/JSONL structure for MCP memory server compatibility
**Current understanding:**
- JSONL format (line-delimited JSON)
- Entities: {name, entityType, observations[]}
- Relations: {from, to, relationType}
- 9 tools available for create/read/update/delete/search
**Remaining work:** Define exact schema for perplex-transformer output, validate against MCP memory server expectations

---

## What NOW (Immediate Next Steps)

### ~~Step 1: Understand AI-First Methodologies~~ ✅ COMPLETE
~~**Action:** Research development frameworks suitable for AI agents~~
**COMPLETED:** GitHub Spec Kit (SDD) selected and documented in STAGE1_DELIVERABLES.md

### ~~Step 2: Validate Technology Stack~~ ✅ COMPLETE
~~**Action:** Check Deno feasibility, evaluate Python concerns, consider alternatives~~
**COMPLETED:** Python 3.11 + uv validated and documented in ADR-009

### ~~Step 3: Deep Dive Serena~~ ✅ COMPLETE (CORRECTED)
~~**Action:** Read Serena docs comprehensively (architecture, memory API, extensibility)~~
**COMPLETED:** Discovered Serena is code intelligence, not memory. MCP memory server is integration target.

### ~~Step 4: Define Stage 1 Deliverables~~ ✅ COMPLETE
~~**Action:** Specify exactly what documents/ADRs/specs are needed~~
**COMPLETED:** STAGE1_DELIVERABLES.md created with complete checklist

### Step 5: Define MCP Memory Graph Schema ⏳ CURRENT
**Action:** Create formal JSON/JSONL schema for memory graphs compatible with @modelcontextprotocol/server-memory
**Why:** perplex-transformer needs output format specification
**Output:** Memory graph schema document

### Step 6: Install GitHub Spec Kit
**Action:** Install `specify` CLI and configure for perplex projects
**Why:** Need tooling to proceed with Phase 2 (Plan)
**Output:** Working Spec Kit installation

### Step 7: Write Phase 1 Specifications
**Action:** Create 1-specify.md for perplex-transformer and perplex-reader
**Why:** High-level what/why must be documented before planning
**Output:** Two specification documents for user review

---

## Constraints Discovered

### Hard Constraints (Non-Negotiable)
1. **No Perplexity API** - Cost prohibitive
2. **Token efficiency required** - Context window is precious
3. **Non-technical user** - Must be understandable and maintainable
4. **MCP memory server integration** - All projects use MCP memory for persistent knowledge graphs
5. **Holistic + AI-First + Five Cornerstones** - Foundation imperatives

### Soft Constraints (Preferences)
1. **Avoid NPM hell** - Strong preference against complex JS dependency trees
2. **Modern tech preferred** - But not at cost of stability
3. **Simple over clever** - Maintainability over optimization
4. **Automation for repetitive** - Manual is temporary exception

---

## Patterns to Preserve

### What Works
1. **User ↔ Perplexity collaboration** - Multi-AI synergy valuable
2. **Serena for memory** - Already proven in production
3. **Transformer isolation pattern** - Elegant contamination solution
4. **Process memory tracking** - This document itself

### What Doesn't Work (Avoid)
1. **Jumping to implementation** - Leads to derailment
2. **Ambiguous frameworks** - AI gets confused about what it's using
3. **Assuming automation everywhere** - User-mediated workflow is reality
4. **Ignoring token costs** - Design constraint, not just optimization

---

## For Next Session

**If I (or another AI) resumes this project:**

1. **Read this document FIRST** - It contains the WHY
2. **Understand the pivots** - We rejected several paths for good reasons
3. **Remember:** This is NOT about automating Perplexity, it's about safe transformation
4. **Check:** Stage 1 must be complete before any coding
5. **Validate:** Does methodology prevent the "losing sight" pattern?

**Current state:** Completing Stage 1 (methodology + framework + foundation)

**Next milestone:** Stage 1 deliverables complete and validated

**Then:** Stage 2 implementation of perplex-transformer and perplex-reader

---

**Last Updated:** 2025-11-12
**Status:** Active - Stage 1 in progress
**Maintained by:** AI agents working on Perplex project

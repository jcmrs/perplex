# Stage 1: Methodology + Framework + Foundation

**Objective:** Establish stable foundation before any coding
**Methodology:** Spec-Driven Development (SDD) using GitHub Spec Kit
**Technology Stack:** Python 3.11 + uv
**Success Criteria:** Any AI agent (Claude Code, Gemini CLI) can proceed to Stage 2 implementation following this foundation

---

## Deliverable 1: Development Methodology Document ✅

**Status:** COMPLETE
**Methodology Chosen:** Spec-Driven Development (SDD) with GitHub Spec Kit

**What:** Living, version-controlled markdown specifications guide AI agents through development

**Why this prevents "losing sight" pattern:**
- Specs are continuous reference (never lose context)
- Checkpoints force course-correction before drift
- Atomic tasks prevent scope creep
- Test-driven validation gives AI self-trust

**Four Phases:**
1. **SPECIFY:** High-level what/why (user provides, AI elaborates)
2. **PLAN:** Technical how (AI generates architecture/approach)
3. **TASKS:** Decompose into atomic, testable chunks
4. **IMPLEMENT:** Execute sequentially with reviews

**Tools:**
- GitHub Spec Kit CLI: `specify` command
- Commands: `/specify`, `/plan`, `/tasks`
- Markdown specs in `/specs/` directory (version-controlled)

**Documentation:** See [GitHub Spec Kit Guide](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)

---

## Deliverable 2: Technology Stack Decision (ADR) ✅

**Status:** COMPLETE

### ADR-009: Technology Stack for Perplex Transformer & Reader

**Date:** 2025-11-12
**Status:** Decided

**Decision:** Python 3.11 + uv package manager

**Context:**
- Need technology for perplex-transformer and perplex-reader
- User prefers avoiding NPM hell
- Hesitant about Python due to "legacy" concerns
- Interested in modern tech (Deno) but feasibility unknown
- Serena (existing MCP dependency) uses Python + uv

**Environment Constraints:**
- Python 3.11.14 available ✅
- Node 22.21.1 available (not needed)
- Deno NOT available ❌
- `uv` package manager available ✅

**Options Considered:**

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **Python 3.11 + uv** | Modern (not legacy), matches Serena stack, `uv` proven reliable, no NPM hell | User hesitancy about Python | ✅ SELECTED |
| **Node/TypeScript** | Modern, strong typing | NPM dependency hell, different stack than Serena | ❌ Rejected |
| **Deno** | Modern, stable, no NPM | Not available in environment | ❌ Not viable |

**Rationale:**
1. **Python 3.11 is modern** - Not legacy (2.x was legacy)
2. **Matches Serena** - Same tech stack, proven stable
3. **`uv` is excellent** - Fast, reliable, modern package management
4. **User's own evidence** - "Serena proves proper Python usage can be stable and secure"
5. **Avoids NPM hell** - Strong user preference

**Consequences:**
- ✅ Consistency with Serena (easier integration)
- ✅ Modern Python (3.11 has great features)
- ✅ Reliable packaging (uv handles dependencies cleanly)
- ✅ No new language/runtime to learn

**Constraints:**
- Dependency management via `uv` (minimal dependencies)
- Python 3.11+ required (no backwards compatibility to 2.x)
- Type hints used (modern Python style)

---

## Deliverable 3: Project Foundation Specification

**Status:** IN PROGRESS

### 3.1 Project Structure (Defined)

```
perplex/  (main project - this repo)
├── README.md
├── FOUNDATION.md
├── docs/
│   ├── PRODUCT_VISION.md
│   ├── PROCESS_MEMORY.md
│   ├── TRANSFORMATION_LAYER_ARCHITECTURE.md
│   └── STAGE1_DELIVERABLES.md (this file)
├── decisions/
│   └── 2025-11-12-technology-stack.md (ADR-009)
└── specs/  (NEW - Spec Kit specifications)
    ├── perplex-transformer/
    │   ├── 1-specify.md
    │   ├── 2-plan.md
    │   ├── 3-tasks.md
    │   └── implementation-log.md
    └── perplex-reader/
        ├── 1-specify.md
        ├── 2-plan.md
        ├── 3-tasks.md
        └── implementation-log.md

perplex-transformer/  (NEW - sub-project 1)
├── pyproject.toml  (uv project)
├── README.md
├── input/
├── processing/
├── output/
└── src/
    └── transformer/
        ├── __init__.py
        ├── parser.py
        ├── extractor.py
        ├── simplifier.py
        ├── graph_builder.py
        └── validator.py

perplex-reader/  (NEW - sub-project 2)
├── pyproject.toml  (uv project)
├── README.md
└── src/
    └── reader/
        ├── __init__.py
        └── importer.py
```

### 3.2 Foundation Imperatives Checklist

**For ANY component built in this project:**

**Holistic System Thinking:**
- [ ] Documented: How does this affect other components?
- [ ] Documented: What breaks if this changes?
- [ ] Documented: What becomes possible with this?

**AI-First:**
- [ ] Can AI agent understand this without human explanation?
- [ ] Is documentation machine-readable AND human-readable?
- [ ] Are there automation scripts for repetitive tasks?
- [ ] Are decisions preserved with full context?

**Configurability:**
- [ ] Is behavior driven by configuration (not hardcoded)?
- [ ] Are all settings in config files (version-controlled)?
- [ ] Are defaults documented with rationale?

**Modularity:**
- [ ] Clear component boundaries?
- [ ] Dependencies explicitly documented?
- [ ] Single, clear responsibility?
- [ ] Minimal coupling, high cohesion?

**Extensibility:**
- [ ] Can new capabilities be added without modifying core?
- [ ] Are plugin/extension points identified?
- [ ] Is API designed for unknown future use cases?

**Integration:**
- [ ] Standard interfaces for component interaction?
- [ ] Data formats documented and consistent?
- [ ] Integration points explicitly designed?
- [ ] External system assumptions documented?

**Automation:**
- [ ] Common operations have scripts?
- [ ] Manual processes documented as automation candidates?
- [ ] Validation and checks run automatically?

---

## Deliverable 4: Spec Kit Integration Setup

**Status:** PENDING

**What's needed:**
1. Install GitHub Spec Kit CLI
2. Configure for perplex-transformer and perplex-reader
3. Create initial spec files
4. Validate AI agents can use `/specify`, `/plan`, `/tasks` commands

**Action items:**
- [ ] Research Spec Kit installation for local projects
- [ ] Create `.speckit` or equivalent configuration
- [ ] Initialize spec files for both sub-projects
- [ ] Test with Claude Code and Gemini CLI

---

## Deliverable 5: MCP Memory Server Integration Specification

**Status:** IN PROGRESS (research complete, schema definition remaining)

**Critical Discovery:**
- Serena is code intelligence tool (LSP-based), NOT memory storage
- Actual integration target: **@modelcontextprotocol/server-memory** (official Anthropic)
- Memory = separate MCP server from Serena

**What's needed:**
1. ✅ Understand MCP memory server architecture
2. ⏳ Define memory graph format (MCP-compatible)
3. ⏳ Specify import mechanism (create_entities, create_relations tools)
4. ⏳ Document integration contract

**Research completed:**
- ✅ MCP memory server uses JSONL format (line-delimited JSON)
- ✅ Entities structure: {name, entityType, observations[]}
- ✅ Relations structure: {from, to, relationType}
- ✅ 9 tools available: create_entities, create_relations, add_observations, delete_*, read_graph, search_nodes, open_nodes
- ✅ Storage: memory.jsonl file (configurable via MEMORY_FILE_PATH)

**Remaining work:**
- [ ] Define exact JSON schema for perplex-transformer output
- [ ] Specify mapping from Perplexity conversations to MCP entities/relations
- [ ] Document entity types and relation types taxonomy
- [ ] Define observation format for research findings

**Output:** MCP Memory Graph Schema document

---

## Deliverable 6: Sub-Project Specifications (Golden Path)

**Status:** PENDING (after Spec Kit setup)

### 6.1 perplex-transformer Specification

**Using Spec Kit 4-phase process:**

**Phase 1 - SPECIFY (High-level):**
```markdown
# perplex-transformer Specification

## What
Transform Perplexity AI conversation logs (Markdown) into safe, attributed
memory graphs (JSON) that can be consumed by local AI agents without context
contamination.

## Why
Local AI agents (Claude Code, Gemini CLI) need to access Perplexity research
without:
- Attribution confusion (who said what)
- Context contamination (instructions vs data)
- Token inefficiency (loading entire conversations)

## Success Criteria
- Input: Perplexity Markdown conversation
- Output: Serena-compatible JSON memory graph
- Validation: No contamination vectors present
- Token efficiency: Graph < 20% of conversation size
- Attribution: Every node traceable to source

## User Journey
1. User exports Perplexity conversation to Markdown
2. User places in perplex-transformer/input/
3. User runs transformation script
4. Script processes conversation through 6 stages
5. Outputs validated memory graph to output/
6. User imports to target project
7. Transformer cleans workspace for next use
```

**Phase 2 - PLAN (will be generated by AI from spec above)**

**Phase 3 - TASKS (will be decomposed by AI into atomic tasks)**

**Phase 4 - IMPLEMENT (will be executed sequentially with reviews)**

---

### 6.2 perplex-reader Specification

**Phase 1 - SPECIFY (High-level):**
```markdown
# perplex-reader Specification

## What
Import memory graphs from perplex-transformer into MCP memory server
(@modelcontextprotocol/server-memory) for target projects, preserving
attribution and provenance.

## Why
Local AI agents query MCP memory server for persistent knowledge. Research from
Perplexity must be accessible via MCP memory tools without consuming AI context
during import.

## Success Criteria
- Input: JSONL memory graph from perplex-transformer
- Process: Use MCP memory server tools (create_entities, create_relations)
- Output: Entities and relations created in MCP memory server
- Validation: Can query memories via search_nodes and read_graph tools
- Token efficiency: Import uses MCP tools, not LLM context window

## User Journey
Option A (Simple - Prompt-Based):
1. User places memory graph in ProjectA/.mcp/imports/perplexity-research.jsonl
2. User prompts Claude Code: "Import the Perplexity research"
3. Claude Code reads JSONL, uses create_entities and create_relations tools
4. MCP memory server stores entities/relations
5. User can query: "What research about X?"

Option B (Automated Script):
1. User runs: ./perplex-reader/import.py ProjectA/.mcp/imports/research.jsonl
2. Script reads JSONL, calls MCP memory server tools programmatically
3. Returns: "Imported X entities, Y relationships"
4. No AI context consumed

Option C (MCP Tool Extension):
1. Build perplex-reader as MCP server with import_perplexity_research tool
2. Claude Code calls tool directly: import_perplexity_research(file_path)
3. Tool handles import using MCP memory server API
4. Returns summary of import
```

---

## Deliverable 7: Completeness Checklist for Stage 1

**Before proceeding to Stage 2 (implementation):**

### Methodology
- [x] Development methodology chosen and documented (Spec Kit SDD)
- [x] AI agents understand the 4 phases (Specify, Plan, Tasks, Implement)
- [x] Checkpoints defined (when human reviews/approves)
- [ ] Spec Kit CLI installed and tested

### Technology
- [x] Technology stack decided (Python 3.11 + uv)
- [x] Environment validated (capabilities confirmed)
- [x] Dependencies strategy defined (uv, minimal deps)
- [x] No "NPM hell" risk

### Foundation
- [x] Process memory documented
- [x] Foundation imperatives checklist exists
- [ ] Project structure created (directories, initial files)
- [ ] Configuration templates ready

### Integration
- [x] MCP memory server API understood (@modelcontextprotocol/server-memory)
- [ ] Memory graph JSONL schema defined (entities, relations, observations)
- [ ] Integration contract specified (MCP tools: create_entities, create_relations)
- [ ] Import mechanism decided (prompt-based, script, or MCP tool extension)

### Specifications
- [ ] perplex-transformer spec (Phase 1: Specify) complete
- [ ] perplex-reader spec (Phase 1: Specify) complete
- [ ] Specs reviewed and approved by user
- [ ] Both specs clear enough for Gemini flash to understand

### Validation
- [ ] Can a different AI read these specs and know what to build?
- [ ] Can non-technical user understand what's being built?
- [ ] Are there no ambiguities that could cause drift?
- [ ] Is every component traceable to product vision?

---

## Stage 1 Completion Criteria

**Stage 1 is COMPLETE when:**

1. ✅ Methodology established (Spec Kit SDD)
2. ✅ Technology decided (Python 3.11 + uv)
3. ✅ Process memory documented
4. ⏳ Spec Kit installed and working
5. ✅ MCP memory server integration understood (CORRECTED: was "Serena")
6. ⏳ Memory graph JSONL schema defined
7. ⏳ Sub-project specs (Phase 1) written and approved
8. ⏳ All checklists above completed
9. ⏳ User validates: "This prevents the losing sight pattern"

**Then and only then:** Move to Stage 2 (implementation)

---

## What Stage 2 Will Look Like

**With Stage 1 complete:**

1. **For perplex-transformer:**
   - Run `/plan` → AI generates technical plan
   - Review/approve plan
   - Run `/tasks` → AI decomposes into atomic tasks
   - Review/approve tasks
   - Implement tasks sequentially with checkpoints

2. **For perplex-reader:**
   - Same Spec Kit process
   - Smaller scope, faster completion

3. **Integration:**
   - Test transformer → reader → MCP memory server → Claude Code query
   - Validate end-to-end with real Perplexity conversation
   - Iterate based on findings

**Trust enabled:**
- User trusts the foundation
- AI trusts the specs (clear, named, atomic)
- AI trusts its environment (MCP memory server, Spec Kit, process memory)
- AI trusts itself (can validate work via tests)

---

## Next Actions (To Complete Stage 1)

### Immediate (This Session)
1. ✅ Document methodology (done - Spec Kit SDD)
2. ✅ Decide technology (done - Python 3.11 + uv)
3. ✅ Create Stage 1 deliverables doc (this file)
4. ✅ Research MCP memory server integration (CORRECTED: was "Serena")
5. ⏳ Define memory graph JSONL schema (next)

### Next Session
5. Install Spec Kit CLI
6. Create initial project structure
7. Write Phase 1 specs for both sub-projects
8. User review and approval

### Following Session
9. Complete remaining checklist items
10. Validate completeness
11. User confirms: "Stage 1 complete, proceed to Stage 2"

---

**Status:** Stage 1 ~60% complete
**Blockers:** None (making good progress)
**Next:** Deep dive Serena documentation for integration specification

**Last Updated:** 2025-11-12
**Maintained by:** AI agents working on Perplex project

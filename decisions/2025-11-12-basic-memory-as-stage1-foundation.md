# ADR-009: Use basic-memory as Stage 1 Memory Foundation

**Date:** 2025-11-12
**Status:** Proposed (awaiting user validation)
**Context:** Stage 1 Architecture - Memory Management System Selection

---

## Context

Project Perplex Stage 1 requires a memory management system with:
1. **Complete project isolation** (zero context contamination)
2. **Local-first architecture** (all data on user's machine)
3. **MCP protocol compatibility** (Claude Desktop integration)
4. **Windows compatibility** (user's environment)
5. **Non-technical friendly** (human-readable, maintainable)
6. **Extensible** (foundation for future Perplexity integration)

Three options were evaluated:
- `@modelcontextprotocol/server-memory` (official Anthropic)
- `memory-bank-mcp` (community file-based)
- `basic-memory` (knowledge graph with bidirectional sync)

---

## Decision

**Use basic-memory as the foundation for Stage 1 memory management.**

**Repository:** https://github.com/basicmachines-co/basic-memory
**Tech Stack:** Python 3.12+, SQLite, Markdown
**Protocol:** MCP
**License:** AGPL-3.0

---

## Rationale

### Why basic-memory Over Alternatives

**vs. @modelcontextprotocol/server-memory (Original Plan):**
- ✅ basic-memory has **proven multi-project isolation** (built-in via `PROJECT` env var)
- ✅ basic-memory storage is **human-readable** (Markdown vs opaque format)
- ✅ basic-memory supports **bidirectional sync** (AI writes, human edits)
- ✅ basic-memory has **richer knowledge graph** (wiki-links, relations, semantic markup)
- ❌ @modelcontextprotocol/server-memory multi-project support unclear from docs

**vs. memory-bank-mcp (Perplexity Reference):**
- ✅ basic-memory has **knowledge graph capabilities** (relations, navigation)
- ✅ basic-memory supports **semantic markup** (categories, observations)
- ✅ basic-memory integrates with **external tools** (Obsidian, VS Code)
- ✅ basic-memory has **search and query** built-in
- ✅ basic-memory has **visualization** (canvas for graphs)
- ⚠️ memory-bank-mcp is simpler (just file storage)

### Alignment with Foundation Imperatives

**1. Holistic System Thinking:**
- Knowledge graph structure enables rich relationships
- Bidirectional sync considers AI + human workflows
- Integration with existing tools (Obsidian) respects user's ecosystem

**2. AI-First:**
- MCP protocol provides native AI agent integration
- Knowledge graph navigation enables autonomous research
- Semantic markup structures knowledge for AI consumption

**3. Configurability:**
- Per-project via `PROJECT` environment variable
- File-based configuration (Claude Desktop `claude_desktop_config.json`)
- Storage location configurable

**4. Modularity:**
- SQLite index + Markdown storage = separable concerns
- MCP server runs independently of Claude Desktop
- Can integrate with multiple AI tools (Claude, Cursor, Roo Code)

**5. Extensibility:**
- Knowledge graph foundation supports future features
- Cloud sync capability (optional)
- Visualization and canvas features for future UI
- Wiki-link syntax for graph traversal

**6. Integration:**
- MCP protocol is standard integration point
- Works with Claude Desktop, Cursor, Roo Code
- Markdown files integrate with Obsidian, VS Code
- Optional cloud sync for future multi-device workflows

**7. Automation:**
- Watch mode (`--watch`) auto-syncs files
- Bidirectional sync maintains consistency
- Search and query operations automate discovery

### Alignment with Product Vision

**Non-Technical Friendly:**
- ✅ Markdown files are human-readable
- ✅ Can edit with familiar tools (Obsidian, VS Code)
- ✅ No database query language required
- ✅ YAML frontmatter is intuitive

**AI-Autonomous:**
- ✅ AI agents can read, write, navigate knowledge graph
- ✅ MCP integration enables autonomous operation
- ✅ Search and context-building tools support research

**Context-Aware:**
- ✅ Per-project isolation via `PROJECT` env var
- ✅ Separate storage directories per project
- ✅ Separate SQLite indexes (no cross-contamination)
- ✅ Relations and wiki-links create project-specific knowledge graph

**Bridge, Not Replacement:**
- ✅ Stores research artifacts from Perplexity (future)
- ✅ Enables AI agents to access research findings
- ✅ Foundation for future integration, not competing system

### Windows Environment Validation

**Requirements:**
- Python 3.12+ (available on Windows)
- SQLite (cross-platform, included with Python)
- File system operations (cross-platform)
- `uvx` package manager (Python ecosystem, Windows-compatible)

**Assumptions to Validate:**
- ⚠️ Python 3.12+ installed on user's Windows system (TO BE VERIFIED)
- ⚠️ `uvx` works on Windows (likely, but needs testing)
- ⚠️ `~/basic-memory/` path resolution on Windows (need to check)

---

## Consequences

### Positive

1. **Multi-Project Isolation Solved**
   - Proven implementation with per-project configuration
   - Separate storage + indexes = zero contamination risk
   - Can run multiple projects simultaneously with separate MCP servers

2. **Knowledge Graph Foundation**
   - Wiki-link navigation enables complex research organization
   - Relations create explicit connections between concepts
   - Semantic markup adds structure (observations, facts, questions)
   - Foundation for future advanced querying and analysis

3. **Human-Readable Storage**
   - Markdown files editable with any text editor
   - Integrates with existing tools (Obsidian, VS Code)
   - Version control friendly (git diffs work well)
   - Non-technical users can directly edit if needed

4. **Bidirectional Sync**
   - AI writes knowledge, human can edit/refine
   - Changes sync automatically (watch mode)
   - Supports human-AI collaboration workflows
   - Respects both AI-first and human-friendly principles

5. **Extensibility for Future Stages**
   - Optional cloud sync for multi-device (future)
   - Visualization capabilities (canvas)
   - Search and query foundation
   - API for custom integrations

6. **Active Maintenance**
   - Real-world usage and community
   - Regular updates and improvements
   - Responsive to issues and feature requests

### Negative

1. **Python Dependency**
   - Requires Python 3.12+ on user's Windows machine
   - Additional installation step vs Node.js-only solutions
   - May require Python version upgrade if older version installed
   - Mitigation: Python is widely used, well-documented

2. **More Complex Than Simple File Storage**
   - SQLite database adds complexity vs plain files
   - Indexing and sync mechanisms to understand
   - More moving parts than basic read/write
   - Mitigation: Complexity hidden behind MCP interface

3. **AGPL-3.0 License**
   - Copyleft license (derivatives must be open source)
   - Fine for our use case (local tool, no distribution)
   - If we ever fork/modify, changes must be shared
   - Mitigation: Using as-is, not modifying core

4. **Windows Compatibility Unverified**
   - Documentation shows macOS examples primarily
   - Need to test on Windows before committing
   - Path handling may need adjustment
   - Mitigation: Python is cross-platform, likely works fine

### Neutral

1. **Learning Curve**
   - Understanding knowledge graph concepts (wiki-links, relations)
   - YAML frontmatter format
   - MCP configuration
   - Mitigation: Comprehensive documentation provided

2. **Storage Format Lock-In**
   - Committed to Markdown + SQLite format
   - Migration to different system requires export
   - Mitigation: Markdown is portable, SQLite is queryable

---

## Alternatives Considered

### Alternative 1: @modelcontextprotocol/server-memory
**Why Not Selected:**
- Multi-project isolation not clearly documented
- Storage format not human-readable
- No bidirectional sync
- Less feature-rich than basic-memory

**When to Reconsider:**
- If Python dependency becomes blocker
- If Anthropic adds multi-project isolation docs
- If official implementation evolves significantly

### Alternative 2: memory-bank-mcp
**Why Not Selected:**
- No knowledge graph capabilities
- No semantic markup or relations
- No search or query features
- Limited compared to basic-memory

**When to Reconsider:**
- If simplicity is valued over features
- If Python dependency is problematic
- If knowledge graph proves unnecessary

### Alternative 3: Build Custom MCP Server
**Why Not Selected:**
- Reinventing the wheel when proven solution exists
- Development time and maintenance burden
- Risk of introducing isolation bugs
- No benefit over basic-memory for our use case

**When to Reconsider:**
- If basic-memory doesn't meet requirements after testing
- If unique features are needed that basic-memory can't provide
- If licensing becomes issue

---

## Validation Plan

### Phase 1: Environment Verification
1. ✅ Research basic-memory capabilities (COMPLETE)
2. ⬜ Verify Python 3.12+ on user's Windows system
3. ⬜ Test `uvx` installation on Windows
4. ⬜ Verify path resolution (`~/basic-memory/` on Windows)

### Phase 2: Functional Testing
1. ⬜ Install basic-memory on Windows
2. ⬜ Configure Claude Desktop with basic-memory MCP
3. ⬜ Create test project and write test notes
4. ⬜ Verify knowledge graph navigation
5. ⬜ Test bidirectional sync (edit Markdown files)

### Phase 3: Isolation Validation
1. ⬜ Create two separate project configurations
2. ⬜ Write notes to both projects
3. ⬜ Verify zero cross-contamination
4. ⬜ Test concurrent access (if applicable)

### Phase 4: Integration Design
1. ⬜ Design Stage 1 architecture with basic-memory
2. ⬜ Plan workflow for research artifact capture
3. ⬜ Document usage patterns for AI agents
4. ⬜ Create setup guide for non-technical users

---

## Implementation Notes

### Configuration Example

**Claude Desktop (`claude_desktop_config.json`):**
```json
{
  "mcpServers": {
    "perplex-memory": {
      "command": "uvx",
      "args": ["basic-memory", "mcp"],
      "env": {
        "PROJECT": "perplex"
      }
    }
  }
}
```

### Storage Structure

```
~/basic-memory/
└── perplex/
    ├── .basic-memory.db (SQLite index)
    └── notes/
        ├── perplexity-integration-research.md
        ├── stage-1-architecture.md
        ├── browser-automation-findings.md
        └── mcp-server-patterns.md
```

### Markdown Note Example

```markdown
---
title: Stage 1 Architecture Decisions
created: 2025-11-12
updated: 2025-11-12
tags: [architecture, decisions, stage-1]
---

# Stage 1 Architecture Decisions

## Observations

[decision] Selected basic-memory for memory management foundation.

[fact] basic-memory provides built-in multi-project isolation via PROJECT env var.

[method] Knowledge graph navigation uses wiki-link syntax: [[Other Note]].

## Relations

- Related to: [[Perplexity Integration Research]]
- Depends on: [[MCP Server Patterns]]
- Informs: [[Stage 2 Planning]]
```

---

## Success Criteria

This decision is validated when:

1. ✅ Python 3.12+ confirmed working on user's Windows system
2. ✅ basic-memory installed and configured successfully
3. ✅ Claude Desktop connects to basic-memory MCP server
4. ✅ Test notes created and retrieved via AI agent
5. ✅ Multi-project isolation verified (zero cross-contamination)
6. ✅ Bidirectional sync tested (AI writes, human edits, stays consistent)
7. ✅ Knowledge graph navigation working (wiki-links, relations)
8. ✅ User validates approach aligns with vision

---

## Related Decisions

- ADR-008: Stage 1 Architecture - Methodology and Framework (2025-11-12)
- Perplexity AI Validation: Green light for MCP + memory isolation approach
- DISCOVERY_FINDINGS.md: Serena analysis led to MCP discovery
- MEMORY_SERVER_COMPARISON.md: Detailed comparison of options

---

## References

- basic-memory Repository: https://github.com/basicmachines-co/basic-memory
- Model Context Protocol: https://anthropic.com/model-context-protocol
- memory-bank-mcp Reference: https://github.com/alioshr/memory-bank-mcp
- Perplexity Validation: docs/PERPLEXITY_VALIDATION_ANALYSIS.md
- Memory Server Comparison: docs/MEMORY_SERVER_COMPARISON.md

---

**Decision Made By:** Claude Code (AI Agent)
**Pending Validation By:** User (Human Partner)
**Next Action:** Verify Python 3.12+ on Windows, test installation

---

**Notes:**

This decision represents a pivot from the original plan (@modelcontextprotocol/server-memory) based on:
1. Perplexity AI validation recommending proven isolation patterns
2. User's observation that basic-memory wasn't referenced
3. Research revealing basic-memory's superior feature set and alignment

The user's suggestion to examine basic-memory led directly to discovering a significantly better solution. This exemplifies the value of human-AI collaboration in architectural decision-making.

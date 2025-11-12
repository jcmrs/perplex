# Memory Server Implementation Comparison

**Date:** 2025-11-12
**Purpose:** Compare memory server options for Stage 1 architecture
**Status:** Research complete - recommendation updated

---

## Overview

Three memory server implementations evaluated:
1. `@modelcontextprotocol/server-memory` - Official Anthropic MCP memory server
2. `memory-bank-mcp` - Community file-based memory with project isolation
3. `basic-memory` - Knowledge graph system with bidirectional sync

---

## 1. @modelcontextprotocol/server-memory (Original Plan)

**Repository:** NPM package by Anthropic
**Tech Stack:** TypeScript/Node.js
**Protocol:** MCP (official reference implementation)

### Features
- Knowledge graph storage (entities and relations)
- In-memory or persistent storage options
- Standard MCP memory operations

### Strengths
- ✅ Official Anthropic implementation
- ✅ Reference standard for MCP memory
- ✅ Well-maintained and documented

### Weaknesses
- ❌ Multi-project isolation not explicitly documented
- ❌ Limited documentation on storage isolation patterns
- ❌ Unclear if multiple knowledge graphs supported
- ❌ No obvious project-scoping mechanism

### Windows Compatibility
- ✅ Node.js-based, cross-platform

### Verdict
**Original choice, but lacks clear multi-project isolation patterns.**

---

## 2. memory-bank-mcp (Perplexity Reference)

**Repository:** https://github.com/alioshr/memory-bank-mcp
**Tech Stack:** TypeScript/Node.js
**Protocol:** MCP

### Features
- File-based memory banks
- Project-specific directories within root path
- Path traversal prevention
- Project listing and file enumeration
- Read/write/update operations
- Type-safe with error handling

### Storage Mechanism
```
MEMORY_BANK_ROOT/
├── project-a/
│   ├── memory-file-1.txt
│   └── memory-file-2.txt
├── project-b/
│   ├── memory-file-1.txt
│   └── memory-file-2.txt
└── project-c/
    └── memory-file-1.txt
```

### Configuration
```json
{
  "MEMORY_BANK_ROOT": "/path/to/memory/banks",
  "disabled": false,
  "autoApprove": ["read", "write", "update", "list"]
}
```

### Strengths
- ✅ **Explicit project isolation** via directory structure
- ✅ Path traversal prevention (security)
- ✅ Simple file-based storage
- ✅ Project listing capabilities
- ✅ Type-safe operations
- ✅ Multiple tool integration (Cline, Claude, Cursor, Roo Code)

### Weaknesses
- ⚠️ Basic file storage (no knowledge graph)
- ⚠️ No semantic relationships between memories
- ⚠️ Limited query capabilities

### Windows Compatibility
- ✅ Node.js/npm-based, cross-platform
- ⚠️ Documentation shows macOS paths (but npm suggests Windows works)

### Verdict
**Good reference for isolation patterns, but limited features compared to basic-memory.**

---

## 3. basic-memory (User Suggestion) ⭐ RECOMMENDED

**Repository:** https://github.com/basicmachines-co/basic-memory
**Tech Stack:** Python 3.12+, SQLite, Markdown
**Protocol:** MCP
**License:** AGPL-3.0

### Features

**Core Capabilities:**
- **Local-first knowledge management**
- **Bidirectional synchronization** (AI ↔ local files)
- **Knowledge graph with wiki-style navigation** (`[[WikiLink]]` syntax)
- **Semantic markup** - Observations with categories (`[method]`, `[fact]`, `[question]`)
- **Relations** - Explicit connections between entities
- **Multi-project support** - Built-in project isolation
- **Human-readable storage** - Markdown with YAML frontmatter
- **Real-time sync** - `--watch` mode for live file synchronization
- **Cloud integration** - Optional bidirectional cloud sync
- **Graph navigation** - LLMs can traverse knowledge via links
- **Search and discovery** - Query across knowledge base
- **Visualization** - Canvas for knowledge graphs

### Architecture

**Storage Structure:**
```
~/basic-memory/
├── project-a/
│   ├── .basic-memory.db (SQLite index)
│   └── notes/
│       ├── topic-1.md
│       ├── topic-2.md
│       └── concept-x.md
├── project-b/
│   ├── .basic-memory.db
│   └── notes/
│       └── idea.md
└── project-c/
    ├── .basic-memory.db
    └── notes/
        └── research.md
```

**Markdown Format:**
```markdown
---
title: Browser Automation Research
created: 2025-11-12
updated: 2025-11-12
tags: [research, perplexity, integration]
---

# Browser Automation Research

## Observations

[method] Selenium can automate browser interactions with Perplexity.

[fact] Perplexity has no official API as of 2025.

[question] Can browser automation maintain session state?

## Relations

- Related to: [[Perplexity Integration]]
- Depends on: [[Stage 1 Architecture]]
- Informs: [[Stage 2 Planning]]
```

### MCP Integration

**Tools Exposed:**
- `write_note` - Create new knowledge
- `read_note` - Retrieve existing knowledge
- `edit_note` - Update knowledge
- `delete_note` - Remove knowledge
- `build_context` - Navigate via `memory://` URLs
- `recent_activity` - See recent changes
- `search` - Query knowledge base
- `canvas` - Visualize knowledge graph

**Configuration (Claude Desktop):**
```json
{
  "mcpServers": {
    "basic-memory": {
      "command": "uvx",
      "args": ["basic-memory", "mcp"],
      "env": {
        "PROJECT": "project-a"
      }
    }
  }
}
```

### Strengths

**Perfect Alignment with Our Requirements:**

1. ✅ **Multi-project isolation BUILT-IN** - Each project has separate storage + index
2. ✅ **Local-first** - All data on user's machine
3. ✅ **Knowledge graph** - Rich relationships between concepts
4. ✅ **Human-readable** - Markdown files editable with any tool (Obsidian, VS Code)
5. ✅ **Bidirectional sync** - AI writes, human edits, stays consistent
6. ✅ **MCP protocol** - Full MCP compatibility
7. ✅ **Semantic markup** - Categories and relations for structured knowledge
8. ✅ **Graph navigation** - AI can traverse knowledge via links
9. ✅ **Non-technical friendly** - Edit files directly in familiar tools
10. ✅ **Extensible** - Foundation for future Perplexity integration
11. ✅ **Real-time sync** - Watch mode keeps files synchronized
12. ✅ **Search and query** - Built-in discovery mechanisms

**Additional Benefits:**
- Can visualize knowledge graphs
- Optional cloud sync (future feature)
- Active development and maintenance
- Python ecosystem (widely used, well-documented)

### Weaknesses

- ⚠️ Python-based (requires Python 3.12+ on user's Windows machine)
- ⚠️ More complex than simple file storage
- ⚠️ AGPL-3.0 license (copyleft, but fine for our use case)
- ⚠️ Windows compatibility not explicitly documented (but likely works)

### Windows Compatibility

- ✅ Python 3.12+ runs on Windows
- ✅ SQLite is cross-platform
- ✅ File operations are cross-platform
- ⚠️ Documentation shows macOS examples (need to verify Windows paths)
- ⚠️ `uvx` package manager needs to be tested on Windows

### Integration with Our Architecture

**Perfect Fit:**

```
User's Windows Machine:
├── Python 3.12+ (installed)
├── basic-memory (installed via uvx)
├── Project Storage:
│   ├── ~/basic-memory/perplex/ (this project)
│   ├── ~/basic-memory/other-project-1/
│   └── ~/basic-memory/other-project-2/
└── Claude Desktop:
    └── Connects to basic-memory MCP server
```

**Per-Project Configuration:**
```json
{
  "mcpServers": {
    "perplex-memory": {
      "command": "uvx",
      "args": ["basic-memory", "mcp"],
      "env": {"PROJECT": "perplex"}
    },
    "other-project-memory": {
      "command": "uvx",
      "args": ["basic-memory", "mcp"],
      "env": {"PROJECT": "other-project-1"}
    }
  }
}
```

**Complete Isolation:**
- Each project has its own MCP server instance
- Separate storage directories
- Separate SQLite indexes
- No cross-contamination possible

### Verdict

**⭐ RECOMMENDED - Best fit for Project Perplex Stage 1**

**Why:**
1. Multi-project isolation is built-in and proven
2. Knowledge graph capabilities exceed our initial requirements
3. Human-readable storage aligns with non-technical user principle
4. Bidirectional sync enables human editing (AI-first + human-friendly)
5. Markdown format integrates with existing tools (Obsidian, VS Code)
6. MCP protocol ensures compatibility with Claude Desktop
7. Extensibility supports future Perplexity integration
8. Real-world usage and active maintenance

---

## Comparison Matrix

| Feature | @modelcontextprotocol/server-memory | memory-bank-mcp | basic-memory ⭐ |
|---------|-------------------------------------|-----------------|----------------|
| **Multi-Project Isolation** | ❓ Unclear | ✅ Built-in | ✅ Built-in |
| **Storage Format** | In-memory/Custom | Plain files | Markdown + SQLite |
| **Knowledge Graph** | ✅ Yes | ❌ No | ✅ Yes (advanced) |
| **Human-Readable** | ❌ No | ⚠️ Plain text | ✅ Markdown |
| **Bidirectional Sync** | ❌ No | ❌ No | ✅ Yes |
| **MCP Protocol** | ✅ Yes (official) | ✅ Yes | ✅ Yes |
| **Semantic Markup** | ⚠️ Basic | ❌ No | ✅ Advanced |
| **Graph Navigation** | ⚠️ Basic | ❌ No | ✅ Wiki-links |
| **External Tool Integration** | ❌ No | ❌ No | ✅ Obsidian, VS Code |
| **Windows Compatible** | ✅ Node.js | ✅ Node.js | ⚠️ Python (likely) |
| **Search/Query** | ⚠️ Basic | ❌ No | ✅ Built-in |
| **Visualization** | ❌ No | ❌ No | ✅ Canvas |
| **Cloud Sync (optional)** | ❌ No | ❌ No | ✅ Yes |
| **Real-time Sync** | ❌ No | ❌ No | ✅ Watch mode |
| **Maintenance** | ✅ Anthropic | ⚠️ Community | ✅ Active |
| **Documentation** | ✅ Good | ⚠️ Basic | ✅ Comprehensive |
| **Non-Technical Friendly** | ❌ No | ⚠️ Moderate | ✅ Yes (edit Markdown) |

---

## Architecture Impact

### Updated Stage 1 Components

**Memory Management System:**
- **Technology:** basic-memory (Python + SQLite + Markdown)
- **Isolation:** Per-project via environment variable (`PROJECT=perplex`)
- **Storage:** `~/basic-memory/perplex/`
- **Format:** Markdown with YAML frontmatter
- **Protocol:** MCP

**Integration Points:**
```
Claude Desktop (Windows)
    ↓ MCP
basic-memory Server (Python)
    ↓ SQLite + File I/O
~/basic-memory/perplex/
    ├── .basic-memory.db
    └── notes/*.md
```

**User Workflow:**
1. Claude Desktop connects to basic-memory MCP server
2. AI writes research findings as Markdown notes
3. Knowledge graph builds relationships automatically
4. Human can edit notes in Obsidian/VS Code if desired
5. Changes sync bidirectionally

---

## Testing Requirements

### Windows Validation

1. **Python 3.12+ Installation**
   - Verify Python works on Windows
   - Test `uvx` package manager

2. **basic-memory Installation**
   ```bash
   uvx basic-memory mcp
   ```

3. **Path Handling**
   - Verify `~/basic-memory/` resolves on Windows
   - Test with Windows-style paths if needed

4. **MCP Configuration**
   - Configure Claude Desktop on Windows
   - Test connection to basic-memory server

5. **Multi-Project Isolation**
   - Create two projects with separate configs
   - Verify no cross-contamination

---

## Recommendation

**Use basic-memory as the foundation for Stage 1.**

**Rationale:**
1. ✅ Solves multi-project isolation completely (proven implementation)
2. ✅ Exceeds requirements (knowledge graph, semantic markup, wiki-links)
3. ✅ Aligns with AI-first + non-technical friendly principles
4. ✅ Human-readable Markdown (can edit with standard tools)
5. ✅ Bidirectional sync (AI writes, human edits)
6. ✅ Extensible foundation for future Perplexity integration
7. ✅ Active maintenance and real-world usage
8. ⚠️ Requires Python 3.12+ (need to verify on Windows)

**Next Steps:**
1. Verify Python 3.12+ availability on user's Windows system
2. Test basic-memory installation and configuration on Windows
3. Validate multi-project isolation
4. Write formal Stage 1 specifications based on basic-memory architecture
5. Prototype integration with Claude Desktop

---

**Last Updated:** 2025-11-12
**Status:** Research complete - basic-memory recommended
**Credit:** User suggestion led to this discovery

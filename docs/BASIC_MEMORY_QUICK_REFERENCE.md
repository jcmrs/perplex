# basic-memory Quick Reference

**Purpose:** Quick reference for using basic-memory MCP server with Claude Code CLI.

**Project:** Project Perplex
**Date:** 2025-11-12

---

## MCP Tools Available

### write_note
**Purpose:** Create a new knowledge note

**Parameters:**
- `title` - Note title (becomes filename)
- `content` - Markdown content with YAML frontmatter
- `tags` - Array of tags (optional)

**Example:**
```markdown
---
title: Research Finding
created: 2025-11-12
tags: [research, perplexity]
---

# Research Finding

## Observations

[fact] Perplexity has no API as of 2025.
[question] How can we integrate without API?

## Relations

- Related to: [[Perplexity Integration]]
```

---

### read_note
**Purpose:** Read an existing note

**Parameters:**
- `title` - Note title
- `permalink` - Direct memory:// URL (alternative)

**Returns:** Full note content including frontmatter

---

### edit_note
**Purpose:** Update an existing note

**Parameters:**
- `title` - Note title to edit
- `content` - New content (replaces entire note)

**Note:** Preserves `created` date, updates `updated` date automatically

---

### delete_note
**Purpose:** Remove a note

**Parameters:**
- `title` - Note title to delete

**Warning:** Permanent deletion. No undo.

---

### build_context
**Purpose:** Navigate knowledge graph via wiki-links

**Parameters:**
- `url` - memory:// URL or [[WikiLink]] syntax

**Example:**
```
memory://Project%20Perplex%20Foundation
[[Stage 1 Architecture]]
```

**Returns:** Note content plus related notes (follows wiki-links)

---

### recent_activity
**Purpose:** See recently created/updated notes

**Parameters:**
- `limit` - Number of recent notes (default: 10)

**Returns:** List of recent notes with timestamps

---

### search
**Purpose:** Search across all notes

**Parameters:**
- `query` - Search terms

**Example:**
```
search("stage 1 architecture")
search("perplexity integration")
```

**Returns:** Matching notes with relevance scores

---

### canvas
**Purpose:** Visualize knowledge graph

**Parameters:**
- `start_node` - Starting note title (optional)

**Returns:** Visual representation of note relationships

---

## Note Format Best Practices

### YAML Frontmatter
```yaml
---
title: Required - Note title
created: Auto-generated - ISO date
updated: Auto-updated - ISO date
tags: [Optional, Array, Of, Tags]
---
```

### Observations Section
Use semantic markup:
```markdown
## Observations

[fact] Factual statement
[method] How something works
[question] Open question
[decision] Decision made
[goal] Objective or target
```

### Relations Section
Explicit connections:
```markdown
## Relations

- Related to: [[Other Note]]
- Depends on: [[Foundation Note]]
- Informs: [[Future Note]]
```

### Wiki-Links
```markdown
[[Exact Note Title]]
[[Multi Word Title]]
```

**Important:** Link text must match note title exactly (case-sensitive)

---

## Storage Locations

**Project Storage:**
```
~/basic-memory/perplex/
├── .basic-memory.db (SQLite index)
└── notes/
    ├── note-1.md
    ├── note-2.md
    └── note-3.md
```

**Windows Path:**
```
C:\Users\<username>\basic-memory\perplex\
```

**File Format:**
- Human-readable Markdown
- Can edit with any text editor
- Obsidian-compatible
- VS Code-compatible
- Git-friendly

---

## Project Isolation

**Configuration:**
```json
{
  "mcpServers": {
    "perplex-memory": {
      "command": "uvx",
      "args": ["basic-memory", "mcp"],
      "env": {
        "PROJECT": "perplex"  ← Isolates to this project
      }
    }
  }
}
```

**Key Points:**
- Each project has unique `PROJECT` value
- Separate storage directories per project
- Separate SQLite indexes per project
- Zero cross-contamination

**Example: Multiple projects:**
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
      "env": {"PROJECT": "other-project"}
    }
  }
}
```

Result:
- `~/basic-memory/perplex/` - Perplex notes only
- `~/basic-memory/other-project/` - Other project notes only
- Complete isolation

---

## Common Workflows

### 1. Capture Research Finding
```markdown
---
title: Browser Automation Research
created: 2025-11-12
tags: [research, automation]
---

# Browser Automation Research

## Observations

[fact] Selenium can automate browsers.
[method] Uses WebDriver protocol.
[question] Can it maintain Perplexity session state?

## Relations

- Informs: [[Stage 2 Planning]]
- Related to: [[Perplexity Integration]]
```

### 2. Document Decision
```markdown
---
title: Memory Architecture Decision
created: 2025-11-12
tags: [decision, architecture]
---

# Memory Architecture Decision

## Observations

[decision] Selected basic-memory for Stage 1.
[fact] Provides knowledge graph with wiki-links.
[method] Uses MCP protocol for AI integration.

## Relations

- Foundation: [[Project Perplex Foundation]]
- Details: See decisions/2025-11-12-basic-memory-as-stage1-foundation.md
```

### 3. Track Open Questions
```markdown
---
title: Open Questions Stage 1
created: 2025-11-12
tags: [questions, stage-1]
---

# Open Questions Stage 1

## Observations

[question] How to handle Perplexity authentication in automation?
[question] What's the best browser automation library?
[question] Can we extract conversation history programmatically?

## Relations

- Stage: [[Stage 1 Architecture]]
- Next: [[Stage 2 Planning]]
```

### 4. Build Context for AI Agent
```
1. Start with: [[Project Perplex Foundation]]
2. Follow links to related notes
3. Build comprehensive context
4. Use search to find specific topics
5. Use recent_activity to see what's new
```

---

## Troubleshooting

### Note not found
- Verify note title exactly matches (case-sensitive)
- Check storage directory for file
- Use search to find similar titles

### Wiki-link not working
- Ensure target note exists
- Check title matches exactly
- Verify no typos in link syntax: `[[Title]]`

### Cross-contamination concern
- Verify PROJECT env var set correctly
- Check storage paths: `~/basic-memory/<project>/`
- List notes from each project separately
- Confirm separate SQLite databases

### Sync issues (if editing files manually)
- Use `--watch` mode for real-time sync
- Or restart MCP server to re-index
- Check file permissions if sync fails

---

## Integration with Obsidian (Optional)

**Point Obsidian vault to:**
```
~/basic-memory/perplex/notes/
```

**Benefits:**
- Visual graph view
- Rich editing experience
- Backlinks panel
- Tags management
- Daily notes integration

**Workflow:**
1. AI writes notes via MCP
2. Human reviews/edits in Obsidian
3. Bidirectional sync maintains consistency

---

## Best Practices

### Do
- ✅ Use semantic markup ([fact], [method], [question], etc.)
- ✅ Create Relations sections with wiki-links
- ✅ Use descriptive, specific titles
- ✅ Tag appropriately for discoverability
- ✅ Link related notes explicitly
- ✅ Update notes when information changes

### Don't
- ❌ Create duplicate note titles (overwrites)
- ❌ Use special characters in titles (filesystem limitations)
- ❌ Forget to set PROJECT env var (contamination risk)
- ❌ Delete notes without checking relations first
- ❌ Mix projects in same storage directory

---

## Performance Tips

### For Large Knowledge Bases
- Use specific search queries (not overly broad)
- Navigate via wiki-links (more efficient than search)
- Archive old notes to separate directory if needed
- Use tags to organize and filter

### For Fast Access
- Build context from specific starting point
- Use recent_activity for current work
- Create index notes for major topics
- Link notes hierarchically (top-down navigation)

---

## Backup and Recovery

### Backup
All data is in plain Markdown files:
```powershell
# Backup entire project memory
cp -r ~\basic-memory\perplex\ ~\backups\perplex-memory-2025-11-12\

# Or use git (if storage in git repo)
cd ~\basic-memory\perplex
git add .
git commit -m "Backup knowledge base"
```

### Recovery
Restore files to `~/basic-memory/perplex/notes/`

MCP server will re-index automatically on next start.

---

## Advanced Features

### Canvas Visualization
Create visual knowledge graph:
```
canvas(start_node="Project Perplex Foundation")
```

Shows relationships visually.

### Cloud Sync (Optional)
basic-memory supports optional cloud sync:
```bash
uvx basic-memory sync --configure
```

Bidirectional synchronization with cloud storage.

**Note:** Local-first design means cloud is optional enhancement, not requirement.

---

## For AI Agents

**When to create notes:**
- Research findings
- Decisions made
- Open questions
- Architecture concepts
- Integration patterns
- Troubleshooting solutions

**When to read notes:**
- Building context for task
- Referencing past decisions
- Following up on open questions
- Checking what's been researched

**When to update notes:**
- New information available
- Questions answered
- Decisions revisited
- Relations discovered

**Navigation strategy:**
1. Start with foundation/index note
2. Follow wiki-links to related concepts
3. Use search for specific topics
4. Build comprehensive context before starting work

---

## Quick Command Reference

```bash
# Check basic-memory version
uvx basic-memory --version

# Start MCP server (usually automatic via Claude Code CLI)
uvx basic-memory mcp

# Watch mode (sync files in real-time)
uvx basic-memory mcp --watch

# Configure cloud sync (optional)
uvx basic-memory sync --configure

# Check storage location
dir ~\basic-memory\perplex\notes

# Check database
# SQLite at: ~\basic-memory\perplex\.basic-memory.db
```

---

**Last Updated:** 2025-11-12
**Status:** Reference guide for Stage 1 operations
**For:** Claude Code CLI and human users

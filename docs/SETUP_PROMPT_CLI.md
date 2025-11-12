# Stage 1 Setup Prompt for Claude Code CLI

**Purpose:** Guide Claude Code CLI through Stage 1 architecture setup for Project Perplex.

**Date:** 2025-11-12

**Target:** Claude Code CLI (local Windows environment)

---

## Context Loading

Before beginning, read these files to understand the project:

### Critical Context (Read First)
1. **`FOUNDATION.md`** - Core imperatives and principles
2. **`docs/PRODUCT_VISION.md`** - What we're building and why
3. **`decisions/2025-11-12-basic-memory-as-stage1-foundation.md`** (ADR-009) - Memory architecture decision
4. **`docs/PERPLEXITY_VALIDATION_ANALYSIS.md`** - Validation that led to this architecture
5. **`docs/MEMORY_SERVER_COMPARISON.md`** - Why basic-memory was selected
6. **`sessions/CURRENT_STATUS.md`** - Current project state

### Supporting Context (Skim if needed)
- `docs/DISCOVERY_FINDINGS.md` - Research that led to Stage 1 design
- `decisions/2025-11-12-perplexity-integration-architecture.md` (ADR-008) - Overall Stage 1 architecture
- `checkpoints/README.md` - How project continuity works

---

## Your Mission

**Set up Stage 1 architecture for Project Perplex:**

1. ✅ Verify/upgrade Python to 3.12+
2. ✅ Install basic-memory MCP server
3. ✅ Configure MCP at **project level** (not global)
4. ✅ Test basic-memory connection and functionality
5. ✅ Validate multi-project isolation
6. ✅ Create example knowledge graph entry
7. ✅ Document the setup for future reference

**Core Requirement:** Complete project isolation. Zero context contamination between projects.

---

## Step-by-Step Instructions

### Step 1: Environment Verification

**Check Python version:**
```powershell
python --version
```

**Expected:** Python 3.12.x or higher

**If Python < 3.12:**
- User has Python 3.11.9 currently
- Guide user through upgrading to Python 3.12+:
  1. Download from https://www.python.org/downloads/
  2. Install Python 3.12.x (can coexist with 3.11.9)
  3. Verify installation: `python --version`
  4. Confirm 3.12+ is now default

**Check Node.js (for reference):**
```powershell
node --version
```
Expected: User has Node.js v24.7.0 (already confirmed, just for completeness)

**Check uvx availability:**
```powershell
uvx --version
```

**If uvx not available:**
```powershell
pip install uv
```

---

### Step 2: Install basic-memory MCP Server

**Installation:**
```powershell
uvx basic-memory mcp --version
```

This should install basic-memory if not already present.

**Verify installation:**
```powershell
uvx basic-memory --help
```

You should see basic-memory commands listed.

**Installation Details:**
- Package: `basic-memory` (from PyPI)
- Version: Latest (should be 0.x.x)
- Dependencies: Python 3.12+, SQLite (included with Python)

---

### Step 3: Configure MCP at Project Level

**Important:** All configuration must be **project-level**, not global or user-level.

**Create Project-Level MCP Configuration:**

Based on your existing project configuration structure, create MCP config:

**File:** `C:\Development\perplex\.claude\mcp-config.json` (or wherever your project-level config lives)

**Configuration:**
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

**Key Points:**
- `PROJECT=perplex` - This isolates memory to this project only
- Storage will be at: `~/basic-memory/perplex/` (Windows: `C:\Users\<username>\basic-memory\perplex\`)
- No global or user-level configuration (project isolation)

**Verify Configuration:**
- Check that config file exists
- Validate JSON syntax
- Confirm environment variable `PROJECT` is set to `perplex`

---

### Step 4: Test MCP Connection

**Launch Test:**

Check if MCP server connects:
```powershell
# This depends on your Claude Code CLI's MCP test command
# Adjust based on actual CLI commands
```

**What to verify:**
1. MCP server starts successfully
2. basic-memory responds to MCP calls
3. Storage directory created: `~/basic-memory/perplex/`
4. SQLite database initialized: `~/basic-memory/perplex/.basic-memory.db`

**If connection fails:**
- Check Python 3.12+ is active
- Verify uvx can run basic-memory
- Check MCP config path is correct
- Look for error messages and troubleshoot

---

### Step 5: Create Test Knowledge Entry

**Using MCP tools, create a test note:**

**Test Note Content:**
```markdown
---
title: Stage 1 Setup Complete
created: 2025-11-12
tags: [setup, test, stage-1]
---

# Stage 1 Setup Complete

## Observations

[fact] Project Perplex Stage 1 architecture is now operational.

[method] basic-memory MCP server provides knowledge graph storage.

[decision] All memory is isolated to PROJECT=perplex environment variable.

## Relations

- Foundation: [[Project Perplex Foundation]]
- Architecture: [[Stage 1 Architecture]]
```

**Commands (adapt to MCP API):**
```
# Use basic-memory MCP tools to write this note
# Tool: write_note
# Parameters: title, content, tags
```

**Verify:**
1. Note created successfully
2. File exists at: `~/basic-memory/perplex/notes/stage-1-setup-complete.md`
3. SQLite index updated
4. Can read note back via MCP

---

### Step 6: Validate Multi-Project Isolation

**Critical Test:** Ensure project isolation works.

**Test Procedure:**

1. **Create second test project config:**
   ```json
   {
     "mcpServers": {
       "test-project-memory": {
         "command": "uvx",
         "args": ["basic-memory", "mcp"],
         "env": {
           "PROJECT": "test-project"
         }
       }
     }
   }
   ```

2. **Write note to test-project:**
   - Use `test-project-memory` MCP server
   - Create note with title: "Test Project Note"

3. **Verify isolation:**
   - Check `~/basic-memory/perplex/` contains only perplex notes
   - Check `~/basic-memory/test-project/` contains only test-project notes
   - No cross-contamination
   - Separate SQLite databases

4. **Query from perplex context:**
   - Search for "Test Project Note" from perplex MCP
   - Should return zero results (not visible)
   - Confirms isolation working

5. **Clean up test project:**
   - Remove test project MCP config
   - Optionally delete `~/basic-memory/test-project/`

**Expected Result:** ✅ Complete isolation between projects. Zero cross-contamination.

---

### Step 7: Test Knowledge Graph Navigation

**Create related notes to test wiki-links:**

**Note 1: Project Perplex Foundation**
```markdown
---
title: Project Perplex Foundation
created: 2025-11-12
tags: [foundation, overview]
---

# Project Perplex Foundation

## Observations

[fact] Project Perplex bridges local AI tools with Perplexity AI.

[goal] Enable seamless research collaboration without manual context-switching.

## Relations

- Architecture: [[Stage 1 Architecture]]
- Memory: [[Stage 1 Setup Complete]]
```

**Note 2: Stage 1 Architecture**
```markdown
---
title: Stage 1 Architecture
created: 2025-11-12
tags: [architecture, stage-1]
---

# Stage 1 Architecture

## Observations

[decision] Use basic-memory for knowledge graph storage.

[method] MCP protocol provides AI agent integration.

[fact] Python 3.12+ required for basic-memory.

## Relations

- Foundation: [[Project Perplex Foundation]]
- Setup: [[Stage 1 Setup Complete]]
- Decision: See decisions/2025-11-12-basic-memory-as-stage1-foundation.md
```

**Test Navigation:**
1. Read "Stage 1 Setup Complete" note
2. Follow wiki-link to [[Project Perplex Foundation]]
3. Follow wiki-link to [[Stage 1 Architecture]]
4. Verify relationships are bidirectional
5. Test search: "stage 1" should return all three notes

**Expected Result:** ✅ Knowledge graph navigation works. Wiki-links connect notes.

---

### Step 8: Document Setup for Future Reference

**Create setup documentation:**

**File:** `docs/STAGE1_SETUP_LOG.md`

**Content:**
```markdown
# Stage 1 Setup Log

**Date:** 2025-11-12
**Performed by:** Claude Code CLI
**Status:** ✅ Complete

## Environment

- **OS:** Windows
- **Python Version:** [VERSION]
- **Node.js Version:** v24.7.0
- **basic-memory Version:** [VERSION]
- **Project Directory:** C:\Development\perplex

## Installed Components

1. ✅ Python 3.12+ (upgraded from 3.11.9)
2. ✅ uvx package manager
3. ✅ basic-memory MCP server
4. ✅ Project-level MCP configuration

## Configuration

**MCP Config Location:** .claude/mcp-config.json

**Storage Location:** ~/basic-memory/perplex/

**Project Isolation:** Enabled via PROJECT=perplex environment variable

## Tests Performed

1. ✅ MCP connection test (successful)
2. ✅ Note creation test (successful)
3. ✅ Multi-project isolation test (zero cross-contamination)
4. ✅ Knowledge graph navigation test (wiki-links working)
5. ✅ Search test (successful)

## Sample Notes Created

- Stage 1 Setup Complete
- Project Perplex Foundation
- Stage 1 Architecture

## Verification Commands

**Check Python version:**
```powershell
python --version
```

**Check basic-memory:**
```powershell
uvx basic-memory --version
```

**Check storage:**
```powershell
dir ~\basic-memory\perplex\notes
```

**Check database:**
```powershell
# SQLite DB at: ~\basic-memory\perplex\.basic-memory.db
```

## Troubleshooting

[Document any issues encountered and solutions]

## Next Steps

- ✅ Stage 1 setup complete
- ⬜ Write formal Phase 1 specifications
- ⬜ Begin Stage 2 planning (Perplexity integration)

## Notes

[Any additional observations or recommendations]
```

---

### Step 9: Final Verification Checklist

**Confirm all items before marking complete:**

- [ ] Python 3.12+ installed and verified
- [ ] basic-memory MCP server installed
- [ ] Project-level MCP configuration created (not global)
- [ ] MCP connection successful
- [ ] Test notes created and readable
- [ ] Multi-project isolation validated (zero cross-contamination)
- [ ] Knowledge graph navigation working (wiki-links functional)
- [ ] Search functionality tested
- [ ] Storage directories confirmed correct
- [ ] Setup documentation created
- [ ] User validated everything works

**If all items checked:** ✅ Stage 1 setup complete!

---

## Important Reminders

### Project-Level Only
- ⚠️ **Never configure MCP globally or at user level**
- ✅ **All configuration must be project-specific**
- ✅ **Each project gets its own MCP server instance with PROJECT env var**

### Isolation is Critical
- ⚠️ **Zero cross-contamination between projects**
- ✅ **Test isolation thoroughly before marking complete**
- ✅ **Separate storage directories per project**
- ✅ **Separate SQLite databases per project**

### Windows Paths
- Use Windows-style paths where appropriate
- `~\basic-memory\perplex\` = `C:\Users\<username>\basic-memory\perplex\`
- PowerShell commands, not bash

### Error Handling
- If something fails, document it
- Troubleshoot systematically
- Ask user for guidance if needed
- Don't skip validation steps

---

## Foundation Alignment Check

**Before completing, verify alignment with Foundation imperatives:**

1. **Holistic System Thinking:**
   - ✅ Considered isolation across all projects
   - ✅ Documented setup for future sessions

2. **AI-First:**
   - ✅ MCP integration enables AI autonomy
   - ✅ Knowledge graph structured for AI consumption

3. **Configurability:**
   - ✅ Project-level configuration
   - ✅ Environment-specific via PROJECT variable

4. **Modularity:**
   - ✅ MCP server separate from Claude Code CLI
   - ✅ Storage independent of configuration

5. **Extensibility:**
   - ✅ Knowledge graph foundation for future features
   - ✅ Can add more MCP servers as needed

6. **Integration:**
   - ✅ MCP protocol standard
   - ✅ Works with Claude Code CLI

7. **Automation:**
   - ✅ MCP automates memory operations
   - ✅ Setup process is reproducible

**If all aligned:** ✅ Proceed confidently.

---

## Success Criteria

**Stage 1 setup is successful when:**

1. ✅ Python 3.12+ confirmed working
2. ✅ basic-memory installed and functional
3. ✅ MCP server connects successfully
4. ✅ Project-level configuration operational
5. ✅ Test notes created and retrieved
6. ✅ Multi-project isolation validated (zero contamination)
7. ✅ Knowledge graph navigation works (wiki-links)
8. ✅ Search functionality operational
9. ✅ User validates everything works as expected
10. ✅ Documentation created for future reference

---

## After Setup Complete

**Next actions:**

1. **Report to user:**
   - Summary of what was done
   - Confirmation all tests passed
   - Location of storage and configuration
   - Any issues encountered and resolved

2. **Ready for next phase:**
   - Stage 1 architecture operational
   - Can begin formal Phase 1 specifications
   - Foundation for Stage 2 (Perplexity integration)

3. **Create session log:**
   - Document the setup session
   - Commit changes to git
   - Update CURRENT_STATUS.md

---

## For User Reference

**How to use basic-memory going forward:**

**Create a note:**
```
[Via Claude Code CLI, use MCP tools]
Tool: write_note
Parameters: {title, content, tags}
```

**Read a note:**
```
Tool: read_note
Parameters: {title or permalink}
```

**Search notes:**
```
Tool: search
Parameters: {query}
```

**Navigate via wiki-links:**
```
Tool: build_context
Parameters: {memory:// URL or [[WikiLink]]}
```

**List recent activity:**
```
Tool: recent_activity
```

All operations automatically isolated to PROJECT=perplex.

---

## Troubleshooting Guide

### Issue: Python 3.12+ not found
**Solution:** Install Python 3.12+ from python.org, verify with `python --version`

### Issue: uvx not found
**Solution:** `pip install uv`, then verify with `uvx --version`

### Issue: basic-memory installation fails
**Solution:** Check Python version, check internet connection, check pip/uv working

### Issue: MCP connection fails
**Solution:** Verify config file path, check JSON syntax, verify PROJECT env var set

### Issue: Notes not creating
**Solution:** Check storage directory exists, check write permissions, check MCP connection

### Issue: Cross-contamination detected
**Solution:** Verify PROJECT env var different per project, check storage paths, recreate config

### Issue: Wiki-links not working
**Solution:** Verify note titles match link text exactly, check notes exist, test search first

---

**Ready to begin? Follow the steps above systematically. Good luck!**

---

**Prepared by:** Claude Code Web (AI Agent)
**For Execution by:** Claude Code CLI (Local AI Agent)
**Date:** 2025-11-12
**Status:** Ready for use

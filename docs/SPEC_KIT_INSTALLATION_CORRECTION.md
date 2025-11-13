# SPEC KIT INSTALLATION CORRECTION - URGENT

**Date:** 2025-11-13
**Issue:** Original integration prompt had incorrect installation method
**Status:** CORRECTED - Read this immediately

---

## Critical Correction

**WRONG (from original prompt):**
```bash
npx spec-kit --version  # ❌ Package doesn't exist in npm
```

**CORRECT:**
Spec Kit is a **Python tool** using `uv`, not Node.js/npm!

---

## Correct Installation Method

### Prerequisites Check (Should All Pass)

From Stage 1, you already have:
- ✅ Python 3.11+ installed
- ✅ `uv` installed and working
- ✅ Git installed
- ✅ Claude Code CLI (AI agent)

**Verify:**
```bash
uv --version     # Should show uv version
python --version # Should show Python 3.11+
git --version    # Should show git version
```

### Installation Options

**Option 1: Persistent Installation (RECOMMENDED)**
```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

**What this does:**
- Installs `specify` CLI tool globally via uv
- Tool persists across sessions
- Use commands directly: `specify init <project>`

**Option 2: One-Time Usage**
```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

**What this does:**
- Runs `specify` command without permanent installation
- Downloads and executes on-demand
- Good for testing, but use Option 1 for persistent use

---

## Correct Commands

**WRONG (from original prompt):**
```bash
npx spec-kit --help          # ❌
npx spec-kit specify         # ❌
npx spec-kit plan            # ❌
npx spec-kit tasks           # ❌
```

**CORRECT:**

### After Installation (Option 1)
```bash
specify --help                    # Show help
specify init <PROJECT_NAME>       # Initialize project
```

### One-Time Usage (Option 2)
```bash
uvx --from git+https://github.com/github/spec-kit.git specify --help
uvx --from git+https://github.com/github/spec-kit.git specify init perplex
```

---

## Correct Spec Kit Commands

**Available Commands:**

### Essential Workflow (Slash Commands for AI Agents)
- `/speckit.constitution` — Establish project governing principles
- `/speckit.specify` — Define requirements and user stories
- `/speckit.plan` — Create technical implementation strategy
- `/speckit.tasks` — Generate actionable task lists
- `/speckit.implement` — Execute all tasks to build features

### Optional Quality Commands
- `/speckit.clarify` — Resolve underspecified areas
- `/speckit.analyze` — Check cross-artifact consistency
- `/speckit.checklist` — Validate requirements completeness

**Note:** Commands are `/speckit.*`, not just `/specify`, `/plan`, etc.

---

## Installation Steps (Corrected)

### Step 1: Install Spec Kit
```bash
# Recommended: Persistent installation
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

**Expected output:**
- uv downloads Spec Kit from GitHub
- Installs `specify-cli` tool
- Tool available globally

**Verify installation:**
```bash
specify --version
# OR
specify --help
```

### Step 2: Initialize for Project Perplex

**Option A: Initialize in current directory**
```bash
cd /path/to/perplex
specify init --here --ai claude
```

**Option B: Initialize with project name**
```bash
specify init perplex --ai claude
```

**Flags to use:**
- `--ai claude` — Specify Claude Code as AI agent
- `--here` — Initialize in current directory (recommended)
- `--force` — Skip confirmation if directory non-empty (use if needed)
- `--no-git` — Skip git initialization (we already have git)

**Expected behavior:**
- Creates `.speckit/` directory
- Sets up project configuration
- May create initial constitution file
- Configures for Claude Code agent

### Step 3: Verify Setup
```bash
# Check what was created
ls -la .speckit/
cat .speckit/config.yml  # or similar config file

# Try a spec kit command
# (commands are used within AI agent interaction, not directly)
```

---

## Key Differences from Original Prompt

### Installation Tool
- **WRONG:** npm/npx (Node.js ecosystem)
- **CORRECT:** uv/uvx (Python ecosystem)

### Package Name
- **WRONG:** `spec-kit` (doesn't exist)
- **CORRECT:** `specify-cli` from GitHub repository

### Command Names
- **WRONG:** `/specify`, `/plan`, `/tasks`
- **CORRECT:** `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`

### Prerequisites
- **ASSUMED (wrong):** Node.js and npm
- **ACTUAL:** Python 3.11+ and uv (which we already have from Stage 1!)

---

## Why This Error Happened

**Root Cause:** I didn't verify the actual installation method before writing the integration prompt.

**Should Have:**
1. WebFetch to GitHub repository first
2. Checked actual installation command
3. Verified package ecosystem (Python vs Node.js)
4. Tested command syntax

**Lesson:** Always verify installation methods from official sources before providing integration guidance.

---

## Perfect Alignment with Stage 1

**This is actually GREAT news:**

✅ **Python 3.11+** — We installed this in Stage 1
✅ **uv** — We installed this in Stage 1
✅ **Git** — Already available
✅ **Claude Code CLI** — You are the AI agent
✅ **Project isolation** — We validated this with basic-memory

**Stage 1 prepared us perfectly for Spec Kit!** The technology stack choice (Python + uv) was the right decision.

---

## Corrected Installation Workflow

### Complete Installation Process

```bash
# 1. Verify prerequisites (should all pass from Stage 1)
uv --version
python --version
git --version

# 2. Install Spec Kit persistently
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# 3. Verify installation
specify --version
specify --help

# 4. Initialize for Project Perplex
cd /path/to/perplex
specify init --here --ai claude --no-git

# 5. Verify setup
ls -la .speckit/
cat .speckit/*  # Check what was created

# 6. Test Spec Kit integration
# (commands are used within AI agent workflow, test with /speckit.constitution)
```

---

## Updated Success Criteria

### Installation Validation
- [ ] `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` succeeds
- [ ] `specify --version` works
- [ ] `specify --help` shows commands
- [ ] Commands available: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`

### Configuration Validation
- [ ] `.speckit/` directory exists
- [ ] Configuration files created
- [ ] Git integration configured (or skipped with `--no-git`)
- [ ] Claude Code agent specified

### Understanding Validation
- [ ] I understand Spec Kit is Python-based (not Node.js)
- [ ] I know the correct command prefix: `/speckit.*`
- [ ] I understand initialization creates `.speckit/` directory
- [ ] I know this aligns perfectly with our Stage 1 architecture

---

## Constitution Command (New Discovery)

**IMPORTANT:** Spec Kit has a `/speckit.constitution` command!

This aligns **PERFECTLY** with our foundation:
- We have `FOUNDATION.md` (governing principles)
- Spec Kit wants constitution (governing principles)
- We can use `/speckit.constitution` to formalize our foundation for Spec Kit

**This is beautiful alignment!**

---

## Next Steps After Correct Installation

### Immediate (This Session)
1. Install with corrected command: `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`
2. Initialize: `specify init --here --ai claude --no-git`
3. Test: `specify --help` and verify commands
4. Report: `[From: CLI] Spec Kit installed successfully with corrected method`

### Near-Term (Next Session)
1. Use `/speckit.constitution` to formalize FOUNDATION.md
2. Use `/speckit.specify` for perplex-transformer specification
3. Use `/speckit.plan` to generate technical plan
4. Use `/speckit.tasks` to decompose into atomic work

---

## Apology and Correction

**My Error:** I provided incorrect installation instructions without verifying the actual method.

**Impact:** CLI encountered 404 error trying to install non-existent npm package.

**Correction:** This document provides verified, correct installation method from official GitHub repository and blog post.

**Validation:** Installation method verified via WebFetch to:
- https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
- https://github.com/github/spec-kit

---

## Official Documentation References

**GitHub Repository:**
https://github.com/github/spec-kit

**Blog Post:**
https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/

**DeepWiki:**
https://deepwiki.com/github/spec-kit

**Recommendation:** Clone repository locally for offline reference:
```bash
git clone https://github.com/github/spec-kit.git docs/external/spec-kit-repo
```

---

**Status:** CORRECTED
**Priority:** CRITICAL - CLI should use this immediately
**Prepared by:** Claude Code Web (Web)
**Date:** 2025-11-13
**Verified:** Installation method validated via official sources

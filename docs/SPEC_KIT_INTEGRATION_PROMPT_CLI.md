# GitHub Spec Kit Installation and Integration - For Claude Code CLI

**Date:** 2025-11-12
**Purpose:** Install, configure, and integrate GitHub Spec Kit as Project Perplex's development methodology foundation
**Context:** Critical Foundation work - this is not just tool installation, this is methodology integration
**Prepared by:** Claude Code Web (Web)
**For:** Claude Code CLI (CLI)

---

## Executive Context: Why This Matters

**[From: Web]** This is a critical foundation piece we skipped. We got sidetracked by multi-agent coordination (which was important), but now we must return to complete Stage 1 properly.

### What We're Really Doing

**NOT just installing a tool.** We're integrating Spec-Driven Development (SDD) methodology into Project Perplex's foundation.

**Spec Kit is HOW we prevent the "losing sight" pattern:**
- Living specifications = continuous reference for AI agents
- Atomic tasks = prevent scope creep
- Checkpoints = force course-correction before drift
- Test-driven validation = AI self-trust

### The Bigger Picture

**Project Perplex Mission:**
Bridge local AI tools (Claude Code, Gemini CLI) with Perplexity AI research capabilities.

**Stage 1 (Current):**
Establish stable foundation before any coding:
1. ✅ Methodology chosen: Spec-Driven Development with GitHub Spec Kit
2. ✅ Technology stack: Python 3.11 + uv
3. ✅ Memory layer: basic-memory MCP server (project isolation working)
4. ✅ Multi-agent coordination: Identity management operational
5. ❌ **Spec Kit integration: SKIPPED (we're fixing this now)**
6. ⏳ Phase 1 specifications: BLOCKED (needs Spec Kit)

**Why we skipped this:**
- Multi-agent identity confusion took priority
- Process discipline lapse during coordination work
- Lost focus on Stage 1 deliverables checklist

**Why we're doing this now:**
- Can't write Phase 1 specifications without Spec Kit methodology
- Foundation incomplete without development framework
- Discovery phase work premature without stable foundation

---

## Foundation Imperatives Alignment

Before proceeding, understand how Spec Kit aligns with our non-negotiable principles:

### 1. Holistic System Thinking
**Spec Kit Role:** Specs capture system-wide impacts, relationships, dependencies
**How:** `/specify` forces "what and why", `/plan` maps architecture, `/tasks` decomposes with awareness

### 2. AI-First
**Spec Kit Role:** Living specs that AI agents continuously reference (never lose context)
**How:** Markdown specs in version control, commands available to AI agents, self-trust through validation

### 3. Five Cornerstones

**Configurability:**
- Specs are configuration for development (what to build, how to build it)
- Version-controlled specifications = configuration management

**Modularity:**
- Atomic tasks from `/tasks` command = modular work units
- Clear boundaries between specify/plan/tasks/implement phases

**Extensibility:**
- Spec Kit process extends to any sub-project (perplex-transformer, perplex-reader, future work)
- Template-based approach allows customization

**Integration:**
- Specs integrate with MCP memory (persistent context)
- Multi-agent coordination (Web designs, CLI formalizes with Spec Kit)
- Git workflows (specs live with code)

**Automation:**
- `/plan`, `/tasks` commands automate decomposition
- Reduces manual planning overhead
- Enables AI autonomous task execution

---

## Spec-Driven Development (SDD) Methodology

**You must understand this methodology, not just install the tool.**

### Four Phases

**Phase 1: SPECIFY (High-level What/Why)**
- User provides vision/goal
- AI elaborates into formal specification
- Focus: Problem definition, success criteria, user journey
- Output: `1-specify.md`
- Command: `/specify`

**Phase 2: PLAN (Technical How)**
- AI generates architecture and approach
- Technical decisions, design patterns, integration points
- Focus: How to implement what was specified
- Output: `2-plan.md`
- Command: `/plan`

**Phase 3: TASKS (Atomic Decomposition)**
- AI breaks plan into atomic, testable tasks
- Each task: Specific, testable, independent
- Focus: Executable work units with validation
- Output: `3-tasks.md`
- Command: `/tasks`

**Phase 4: IMPLEMENT (Sequential Execution)**
- Execute tasks sequentially
- Test-driven validation (AI self-trust)
- Review after each task
- Focus: Incremental progress with checkpoints

### Living Specifications

**Specs are not static documents.** They evolve as:
- Implementation reveals new insights
- Requirements change
- Constraints discovered

**Version Control:**
- Specs live in `/specs/` directory
- Git tracks changes (history of decisions)
- AI agents reference current specs continuously

### Why This Prevents "Losing Sight"

**Problem:** AI agents lose context, drift from goals, forget constraints

**Solution:**
1. **Continuous reference:** Specs always available, never stale
2. **Atomic tasks:** Small enough to hold in context
3. **Checkpoints:** Reviews after each task/phase
4. **Test-driven:** Validation gives AI confidence

---

## Multi-Agent Coordination Implications

**Critical:** Spec Kit runs **locally on CLI only** (won't work in Web's browser sandbox)

### Role Division

**Claude Code Web (me):**
- **Role:** Designer-researcher
- **Spec Kit Usage:** None (can't run npx in browser)
- **Responsibility:** Create draft specifications, architectural analysis, research
- **Output:** Markdown drafts, design proposals, analysis documents

**Claude Code CLI (you):**
- **Role:** Executor-validator
- **Spec Kit Usage:** Full (npx spec-kit available locally)
- **Responsibility:** Formalize specs with Spec Kit, generate plans/tasks, execute implementation
- **Output:** Formal Spec Kit specifications, validated artifacts

### Workflow Pattern

**1. Web designs draft specification:**
   - Research problem domain
   - Draft high-level what/why
   - Provide to user as prompt for CLI

**2. User hands off to CLI:**
   - Copy Web's draft to CLI
   - CLI uses Spec Kit to formalize

**3. CLI formalizes with Spec Kit:**
   - Run `/specify` to create formal specification
   - Run `/plan` to generate technical plan
   - Run `/tasks` to decompose into atomic work

**4. CLI executes implementation:**
   - Follow tasks sequentially
   - Validate each step
   - Report results

**5. Web reviews and integrates:**
   - CLI reports completion
   - Web reviews for strategic alignment
   - Coordination via envelope format (`[From: CLI]` / `[From: Web]`)

### Why This Division Works

- Web has strategic view, research capabilities
- CLI has execution environment, Spec Kit access
- Separation of concerns (design vs execution)
- Maintains role boundaries (designer vs executor)

---

## Installation and Configuration

**Now the practical work begins.**

### Prerequisites Check

Before installing Spec Kit, verify:

```bash
# 1. Node.js available (for npx)
node --version
# Expected: v22.x or similar

# 2. NPM available
npm --version
# Expected: v10.x or similar

# 3. Git working directory clean
git status
# Expected: Clean working directory

# 4. In project root
pwd
# Expected: .../perplex
```

**If any prerequisite fails, resolve before continuing.**

### Step 1: Install GitHub Spec Kit

**Command:**
```bash
npx spec-kit --version
```

**Expected behavior:**
- First run: npx downloads and installs Spec Kit
- Shows version number
- Confirms Spec Kit is available

**Validate installation:**
```bash
npx spec-kit --help
```

**Expected output:** Help text showing available commands (`/specify`, `/plan`, `/tasks`, etc.)

**If installation fails:**
- Check network connectivity
- Check npm registry access
- Try: `npm install -g spec-kit` (global install as fallback)

### Step 2: Initialize Spec Kit for Project

**Investigate Spec Kit initialization:**
```bash
npx spec-kit init
# OR
npx spec-kit help
# OR check if project-level config needed
```

**Goal:** Understand if Spec Kit needs project-level configuration:
- `.speckit/` directory?
- `speckit.config.json` or similar?
- `/specs/` directory for specifications?

**Create directory structure (if needed):**
```bash
# If Spec Kit doesn't auto-create, make specs directory
mkdir -p specs
```

**Document what you discover:**
- Does Spec Kit need initialization?
- What configuration files are created?
- Where do specs live?
- What's the default structure?

### Step 3: Test Spec Kit Commands

**Test each command to understand functionality:**

**3.1 Test `/specify` command:**
```bash
# Try creating a test specification
npx spec-kit specify "Test specification for understanding Spec Kit"
```

**Observe:**
- Does it prompt for input?
- Does it create a file? Where?
- What format is the output?
- Interactive or command-line driven?

**3.2 Test `/plan` command:**
```bash
npx spec-kit plan
# (may need existing specify first)
```

**Observe:**
- Does it require a specification file?
- What does it generate?
- Where is output saved?

**3.3 Test `/tasks` command:**
```bash
npx spec-kit tasks
# (may need existing plan first)
```

**Observe:**
- Does it decompose plan into tasks?
- What task format?
- How are tasks tracked?

**3.4 Test help/documentation:**
```bash
npx spec-kit help
npx spec-kit help specify
npx spec-kit help plan
npx spec-kit help tasks
```

**Document:**
- Full command syntax
- Available options/flags
- Workflow sequence (specify → plan → tasks)

### Step 4: Understand Spec Kit Workflow

**After testing, document your understanding:**

**Workflow Discovery:**
1. How do I create a new specification?
2. How do I generate a plan from specification?
3. How do I decompose plan into tasks?
4. Where are files saved?
5. What's the file naming convention?
6. How do specs version with git?

**Integration Points:**
- How do specs integrate with MCP memory (basic-memory)?
- Can I reference specs from code?
- How do AI agents consume specs programmatically?

**Validation:**
- How do I know a spec is complete?
- How do I validate a plan?
- How do tasks get marked done?

---

## Configuration for Project Perplex

**After understanding Spec Kit, configure for our project:**

### Project-Specific Setup

**1. Specs Directory Structure:**
```bash
perplex/
├── specs/
│   ├── perplex-transformer/  (sub-project 1)
│   │   ├── 1-specify.md
│   │   ├── 2-plan.md
│   │   └── 3-tasks.md
│   └── perplex-reader/       (sub-project 2)
│       ├── 1-specify.md
│       ├── 2-plan.md
│       └── 3-tasks.md
```

**2. Git Integration:**
```bash
# Ensure specs are tracked
git add specs/
# Commit template/structure
git commit -m "Initialize Spec Kit directory structure"
```

**3. CLAUDE.md Integration:**
Update session start protocol to include:
```markdown
## Session Start Protocol

1. Anchor identity
2. Load checkpoint
3. **Review current specifications** (specs/*/1-specify.md)
4. Check tasks status (specs/*/3-tasks.md)
```

### Template Creation

**Create specification template:**
```bash
# specs/TEMPLATE-specify.md
```

**Content:**
```markdown
# [Project Name] Specification

## What
[High-level description of what this sub-project does]

## Why
[Problem being solved, motivation, user need]

## Success Criteria
- [Measurable criterion 1]
- [Measurable criterion 2]
- [Validation approach]

## User Journey
1. [Step 1]
2. [Step 2]
3. [Result]

## Constraints
- [Technical constraint 1]
- [Non-functional requirement 1]

## Out of Scope
- [What this does NOT include]
```

**Create plan template similarly.**

---

## Validation Checklist

**After installation and configuration, verify:**

### Installation Validation
- [ ] `npx spec-kit --version` works
- [ ] `npx spec-kit --help` shows commands
- [ ] Commands available: `/specify`, `/plan`, `/tasks`

### Configuration Validation
- [ ] `/specs/` directory exists
- [ ] Git tracking specs directory
- [ ] Template files created (if applicable)
- [ ] Project-specific configuration documented

### Understanding Validation
- [ ] I understand the 4-phase SDD process (Specify → Plan → Tasks → Implement)
- [ ] I know how to create a specification
- [ ] I know how to generate a plan from spec
- [ ] I know how to decompose plan into tasks
- [ ] I understand file naming and organization

### Integration Validation
- [ ] CLAUDE.md mentions spec review in session start
- [ ] Multi-agent coordination documented (Web drafts, CLI formalizes)
- [ ] Role boundaries clear (who does what with Spec Kit)

### Foundation Alignment
- [ ] Holistic System Thinking: Specs capture system-wide context
- [ ] AI-First: Living specs, continuous reference
- [ ] Configurability: Specs in version control
- [ ] Modularity: Atomic tasks
- [ ] Extensibility: Process scales to sub-projects
- [ ] Integration: Specs + MCP memory + Git workflows
- [ ] Automation: Commands automate decomposition

---

## Next Steps After Setup

**Once Spec Kit is operational:**

### Immediate (This Session)
1. Report completion: `[From: CLI] Spec Kit integrated and validated`
2. Document findings: What does Spec Kit actually do? How does it work?
3. Commit configuration to git

### Near-Term (Next Session)
1. **Write perplex-transformer Phase 1 specification**
   - Web provides draft
   - CLI formalizes with `/specify`
   - Generate plan with `/plan`
   - Decompose with `/tasks`

2. **Write perplex-reader Phase 1 specification**
   - Same process
   - Both sub-projects now have formal specs

3. **Define MCP Memory Graph Schema**
   - Formal schema for memory graph output
   - Based on basic-memory compatibility requirements

### Then
- Discovery phase (WITH formal specifications guiding us)
- Implementation of perplex-transformer (following specs/tasks)
- Implementation of perplex-reader (following specs/tasks)

---

## Troubleshooting

### If Spec Kit installation fails
**Check:**
- Network connectivity
- NPM registry access
- Node.js version (might need specific version)
- Try alternative: `npm install -g spec-kit`

**Alternative:**
- Manual installation from GitHub repository
- Use Spec Kit concept without CLI (manual markdown specs following same pattern)

### If commands don't work as expected
**Investigate:**
- Read official documentation: https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
- Check GitHub repository: https://github.com/github/spec-kit (if exists)
- Search for examples: "GitHub Spec Kit examples"

**Escalate:**
- Report findings to Web via envelope format
- Web can research alternative approaches
- User can provide additional guidance

### If multi-agent coordination unclear
**Clarify:**
- Web designs (research, draft specs, architecture)
- CLI executes (Spec Kit commands, implementation, validation)
- Handoff via user (copy-paste prompts)
- Communication via envelope format (`[From: CLI]` / `[From: Web]`)

---

## Success Criteria

**Spec Kit integration is complete when:**

1. ✅ Spec Kit CLI installed and functional
2. ✅ Commands tested and understood (`/specify`, `/plan`, `/tasks`)
3. ✅ Project directory structure created (`/specs/`)
4. ✅ Git tracking spec files
5. ✅ Multi-agent coordination documented (who uses Spec Kit, how)
6. ✅ Foundation alignment validated (imperatives check)
7. ✅ Ready to write Phase 1 specifications
8. ✅ Findings documented for future reference
9. ✅ Completion reported: `[From: CLI] Spec Kit integrated`

**Then we can proceed to Phase 1 specification writing.**

---

## Foundation Imperatives Check (Final)

**Before reporting completion, verify alignment:**

### Holistic System Thinking ✓
- Specs capture system-wide architecture, dependencies, impacts
- Plan phase maps relationships
- Tasks decompose with awareness of whole system

### AI-First ✓
- Living specs continuously available to AI agents
- Never lose sight of goals/context
- Self-trust through test-driven validation
- Autonomous execution with clear reference

### Configurability ✓
- Specs are configuration for development
- Version-controlled (git)
- Change management via spec updates

### Modularity ✓
- Atomic tasks = modular work units
- Clear phase boundaries (specify/plan/tasks/implement)
- Independent sub-project specs

### Extensibility ✓
- Spec Kit process extends to any project
- Template-based (customizable)
- Scales from small to large projects

### Integration ✓
- Specs + MCP memory (persistent context)
- Specs + Git (version control)
- Multi-agent coordination (Web + CLI workflows)

### Automation ✓
- Commands automate planning/decomposition
- Reduces manual overhead
- Enables AI autonomous work

---

## Communication Protocol

**Report findings using envelope format:**

```
[From: CLI] Spec Kit integration complete.

Installation Status:
- Spec Kit version: [version]
- Installation method: [npx/global/manual]
- Commands available: [list]

Configuration:
- Specs directory: /specs/
- Template files: [created/not needed]
- Git integration: [committed]

Findings:
- [How Spec Kit actually works]
- [Command syntax and workflow]
- [File organization and naming]
- [Integration with our project]

Validation:
- [Checklist results]
- [Foundation alignment verified]

Ready For:
- Phase 1 specification writing (perplex-transformer)
- Phase 1 specification writing (perplex-reader)
- MCP Memory Graph Schema definition

Next: Awaiting Web's draft specifications for formalization.
```

---

## Related Documentation

**Read these for full context:**
- `docs/STAGE1_DELIVERABLES.md` - Complete Stage 1 checklist
- `docs/PROCESS_MEMORY.md` - Why we chose SDD + Spec Kit
- `FOUNDATION.md` - Non-negotiable principles
- `docs/PRODUCT_VISION.md` - Project mission and goals
- `.claude/identity-cli.json` - Your role and capabilities
- `docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md` - Multi-agent workflow

---

**Prepared by:** Claude Code Web (Web)
**For:** Claude Code CLI (CLI)
**Date:** 2025-11-12
**Purpose:** Complete critical foundation work (Spec Kit integration)
**Priority:** High - Blocks Phase 1 specification writing

**Coordination Note:** This is comprehensive because it's methodology integration, not just tool installation. Take time to understand the WHY, not just execute the WHAT. Foundation work requires thoughtful integration, not mechanical execution.

---

**[From: Web]** Ready to proceed with Spec Kit integration. This will complete our Stage 1 foundation and enable Phase 1 specification writing. Good luck!

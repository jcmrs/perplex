# Three-Environment Coordination System

**Created:** 2025-11-12
**Purpose:** Document how Claude Code Web, Claude Code CLI, and GitHub coordinate as a unified system

---

## Architecture Overview

Project Perplex operates as a **three-node distributed system** where each environment has specific roles and responsibilities.

```
┌─────────────────────┐       ┌─────────────────────┐       ┌─────────────────────┐
│  Claude Code Web    │──────▶│      GitHub         │◀──────│  Claude Code CLI    │
│   (Collaborator)    │       │  (Coordination Hub) │       │      (Local)        │
└─────────────────────┘       └─────────────────────┘       └─────────────────────┘
        │                              │                              │
        │                              │                              │
        ▼                              ▼                              ▼
  Git workflows                 Auto-create PR              MCP integration
  Checkpoints                   Auto-merge                  Local development
  Session protocols             Validation                  Testing
  Documentation                 Branch cleanup              CLI tools
```

## Environment Roles

### 1. Claude Code Web (Strategic Collaborator)

**Established Systems:**
- Git workflows and conventions
- Checkpoint system for session continuity
- Session protocols (start/end)
- GitHub automation configuration
- Foundation documentation
- Architecture decisions (ADRs)

**Responsibilities:**
- Strategic planning and architecture
- Complex system design
- Cross-session coordination
- Documentation creation
- Workflow establishment

**Branch Convention:** `claude/*` branches for all work

**Example branches:**
- `claude/feature-description-sessionid`
- `claude/fix-bug-description-sessionid`
- `claude/docs-update-sessionid`

### 2. GitHub (Coordination Hub)

**Automated Workflows:**

#### Auto-Create PR (`.github/workflows/auto-create-pr-claude-branches.yml`)
- **Trigger:** Push to `claude/*` branches
- **Action:** Automatically creates PR from branch to `main`
- **PR Title:** First line of commit message
- **PR Body:** Remaining commit message lines
- **Idempotent:** Won't create duplicate PRs

#### Auto-Merge (`.github/workflows/auto-merge-claude-branches.yml`)
- **Trigger:** PR opened/updated from `claude/*` branch
- **Validation:** Runs `tools/validate-foundation.sh`
- **Action:** Auto-merges if validation passes
- **Cleanup:** Deletes branch after merge
- **Comments:** Posts validation results on PR

#### Foundation Validation (`.github/workflows/foundation-validation.yml`)
- **Trigger:** All pushes and PRs
- **Checks:** Foundation structure, documents exist, git clean
- **Blocking:** Prevents merge if validation fails

#### Tests (`.github/workflows/tests.yml`)
- **Trigger:** All pushes and PRs
- **Checks:** Shell scripts (shellcheck), YAML (yamllint), Bats tests
- **Blocking:** Prevents merge if tests fail

#### Completeness Review (`.github/workflows/completeness-review.yml`)
- **Trigger:** Pull requests
- **Action:** Posts completeness checklist as PR comment
- **Non-blocking:** Advisory only, doesn't prevent merge

#### Checkpoint Automation (`.github/workflows/checkpoint-automation.yml`)
- **Trigger:** PR merge to main
- **Action:** Creates checkpoint preserving project state
- **Creates:** checkpoint PR with markdown + memory graph JSON
- **Human approval:** Checkpoint PR must be manually merged

#### Checkpoint Info on PR (`.github/workflows/checkpoint-info-on-pr.yml`)
- **Trigger:** PR opened/reopened
- **Action:** Posts latest checkpoint context as comment
- **Helps:** Contributors understand current project state

#### Cleanup Checkpoint Branches (`.github/workflows/cleanup-checkpoint-branches.yml`)
- **Trigger:** Checkpoint PR merge
- **Action:** Deletes merged checkpoint branches
- **Keeps:** Repository clean

**Responsibilities:**
- Automated PR creation
- Validation enforcement
- Auto-merging validated PRs
- Branch lifecycle management
- Checkpoint creation
- Context provision on PRs

### 3. Claude Code CLI Local (This Environment)

**Current Capabilities:**
- Local file system access
- MCP server integration (perplex-memory)
- Git operations
- Shell command execution
- Direct basic-memory CLI tools

**Configured Systems:**
- ✅ basic-memory MCP server (installed, registered)
- ✅ Git hooks path (`.githooks/` configured)
- ✅ Session-state.json (continuity mechanism)
- ⚠️ Branch conventions (NOW understood)
- ⚠️ PR automation (NOW understood)

**Responsibilities:**
- Local development and testing
- Knowledge graph management via MCP
- CLI tool operations
- Quick iterations
- Following established workflows

**Critical Gap Previously Missed:**
- Worked directly on `main` branch (violated convention)
- Didn't understand `claude/*` → GitHub → Auto-PR → Auto-merge flow
- Didn't configure git hooks initially
- Didn't consider system-wide coordination

---

## Coordination Workflows

### Workflow 1: Claude Code Web → GitHub → Main

```
1. Claude Code Web creates branch: claude/feature-xyz-sessionid
2. Web commits and pushes to branch
3. GitHub auto-creates PR
4. GitHub runs validation
5. GitHub auto-merges if passing
6. GitHub deletes branch
7. GitHub creates checkpoint PR
8. Human reviews and merges checkpoint PR
```

### Workflow 2: Claude Code CLI → GitHub → Main (CORRECT)

```
1. CLI creates branch: claude/cli-work-$(date +%s)
2. CLI commits work locally
3. CLI pushes to origin claude/cli-work-*
4. GitHub auto-creates PR
5. GitHub runs validation
6. GitHub auto-merges if passing
7. GitHub deletes branch
8. CLI pulls merged changes: git pull origin main
```

### Workflow 3: Session Continuity (Cross-Environment)

```
1. Environment A creates checkpoint (manual or auto)
2. Checkpoint committed to checkpoint PR
3. Human merges checkpoint PR to main
4. Environment B runs: ./tools/resume-from-checkpoint.sh
5. Environment B reads LATEST.md symlink
6. Environment B loads checkpoint + memory graph
7. Environment B continues work seamlessly
```

---

## Git Hooks (Local Enforcement)

**Location:** `.githooks/` (version controlled)

**Configuration Required:**
```bash
git config core.hooksPath .githooks
```

**Hooks Installed:**

### pre-commit
- **Runs:** Before commit creation
- **Validates:** Foundation structure (via `tools/validate-foundation.sh`)
- **Blocks:** Commit if validation fails
- **Skip:** `git commit --no-verify` (not recommended)

### commit-msg
- **Runs:** After commit message written
- **Validates:** Message quality (non-empty, min 10 chars, imperative mood tips)
- **Blocks:** Commit if message invalid
- **Skip:** `git commit --no-verify` (not recommended)

### pre-push
- **Runs:** Before push to remote
- **Validates:** Completeness review (non-interactive)
- **Advisory:** Shows warnings but doesn't block push
- **Purpose:** Catch potential gaps before GitHub sees them

**Why Hooks Matter:**
- Local validation prevents GitHub CI failures
- Faster feedback loop (catch issues before push)
- Consistent enforcement across environments
- Matches GitHub validation exactly

---

## Branch Conventions

### Naming Pattern

```
claude/<type>-<description>-<sessionid>
```

**Examples:**
- `claude/feature-perplexity-integration-011CUzxDPZiWB31A6DM5T2Mc`
- `claude/fix-mcp-connection-011CV35RoubgSRMHNVuYa7Si`
- `claude/docs-update-system-coordination-20251112`

**Type prefixes:**
- `feature-` - New functionality
- `fix-` - Bug fixes
- `docs-` - Documentation updates
- `refactor-` - Code refactoring
- `test-` - Test additions/updates
- `chore-` - Maintenance tasks

**Session ID:**
- Web sessions: Use Claude-provided session ID
- CLI sessions: Use timestamp or descriptive identifier

### Base Branch

**Always:** `main`

All `claude/*` branches branch from and merge back to `main`.

---

## Commit Message Format

### Structure

```
<brief summary> (<72 chars max)

<detailed explanation if needed>

Addresses: [What user request or gap this addresses]
Foundation alignment: [Which imperatives this serves]
Phase: [foundation/discovery/implementation]
Session: [session-YYYYMMDD-description]
```

### Examples

**Good:**
```
Add three-environment coordination documentation

Documents how Claude Code Web, CLI, and GitHub coordinate as
a unified system. Fills gap identified by Claude Code Web.

Addresses: Holistic System Thinking imperative violation
Foundation alignment: AI-First (system understanding)
Phase: Foundation → Discovery transition
Session: 2025-11-12-system-integration
```

**Bad:**
```
Updated docs
```

**Why it matters:**
- First line becomes PR title (auto-create PR workflow)
- Body becomes PR description
- Helps future sessions understand context

---

## Coordination Protocols

### Protocol 1: Starting Work

**Claude Code CLI:**
```bash
# 1. Ensure on main with latest
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b claude/cli-work-$(date +%s)

# 3. Verify hooks configured
git config core.hooksPath  # Should output: .githooks

# 4. Start work
```

**Claude Code Web:**
```
# 1. Uses built-in branch creation
# 2. Already follows claude/* convention
# 3. Hooks pre-configured
# 4. Start work
```

### Protocol 2: Committing Work

**Both environments:**
```bash
# 1. Review changes
git status
git diff

# 2. Stage files
git add <files>

# 3. Commit (hooks run automatically)
git commit -m "Clear, descriptive message

Detailed explanation.

Addresses: User request or gap
Foundation alignment: Imperatives served
Phase: Current phase
Session: session-id
"

# 4. If hooks fail, fix issues and retry
# 5. Do NOT use --no-verify unless hooks malfunction
```

### Protocol 3: Pushing and PR Creation

**Claude Code CLI:**
```bash
# 1. Push to origin
git push -u origin claude/cli-work-*

# 2. GitHub auto-creates PR (no manual PR needed!)
# 3. GitHub validates (foundation, tests)
# 4. GitHub auto-merges if passing
# 5. Pull merged changes
git checkout main
git pull origin main
```

**Claude Code Web:**
```
# Same as CLI
# Web environment may have streamlined push commands
```

### Protocol 4: Session End

**Both environments:**
```bash
# 1. Run session end script
./tools/session-end.sh

# This automatically:
# - Checks for uncommitted changes
# - Runs foundation validation
# - Runs completeness review (mandatory)
# - Prompts for checkpoint creation
# - Shows session summary

# 2. Commit any remaining changes
git add <files>
git commit -m "Session end: finalize work"

# 3. Push
git push -u origin $(git branch --show-current)

# 4. GitHub handles rest (PR, merge, cleanup)
```

### Protocol 5: Cross-Environment Handoff

**When Environment A completes milestone:**
```bash
# 1. Create checkpoint
./tools/create-checkpoint.sh "Milestone description"

# 2. Checkpoint PR created on GitHub
# 3. Human reviews and merges checkpoint PR
```

**When Environment B starts session:**
```bash
# 1. Load checkpoint
./tools/resume-from-checkpoint.sh

# 2. Reads LATEST.md → actual checkpoint file
# 3. Loads memory graph for relationships
# 4. Understands project state
# 5. Continues work seamlessly
```

---

## Automation Tools

### Session Management

**tools/session-start.sh:**
- Shows current branch
- Displays CURRENT_STATUS.md
- Lists recent decisions
- Quick validation checks
- Session checklist

**tools/session-end.sh:**
- Checks uncommitted changes
- Runs foundation validation
- Runs completeness review (mandatory)
- Prompts checkpoint creation
- Shows session summary

**Usage:**
```bash
./tools/session-start.sh   # At session start
./tools/session-end.sh     # At session end
```

### Validation

**tools/validate-foundation.sh:**
- Verifies foundation structure
- Checks required documents exist
- Validates directory structure
- Ensures git repository clean

**tools/review-completeness.sh:**
- Systematic gap detection
- Checks: git state, documentation, artifacts, quality, session completeness
- Interactive prompts for subjective checks
- Can run in non-interactive mode (CI)

**Usage:**
```bash
./tools/validate-foundation.sh      # Quick structure check
./tools/review-completeness.sh      # Thorough gap detection
```

### Checkpoints

**tools/create-checkpoint.sh:**
- Creates checkpoint markdown file
- Generates memory graph JSON
- Updates LATEST.md symlink
- Idempotency: won't create duplicate within 2 hours

**tools/resume-from-checkpoint.sh:**
- Reads latest checkpoint
- Shows critical files to read
- Displays key relationships
- Provides next actions

**Usage:**
```bash
./tools/create-checkpoint.sh "Description"  # Create checkpoint
./tools/resume-from-checkpoint.sh           # Resume from checkpoint
```

### Status

**tools/generate-status.sh:**
- Regenerates sessions/CURRENT_STATUS.md
- Shows: phase, branch, git status, recent commits, decisions
- Auto-updates with current state

**Usage:**
```bash
./tools/generate-status.sh  # Regenerate status file
```

---

## Integration Checklist for Claude Code CLI

### Initial Setup (One-Time)

- [x] Install basic-memory via uvx
- [x] Register perplex-memory MCP server
- [x] Create .claude/mcp-config.json
- [x] Configure git hooks: `git config core.hooksPath .githooks`
- [x] Create session-state.json for continuity
- [x] Understand three-environment architecture

### Every Session Start

- [ ] Run `./tools/session-start.sh` or manually:
  - [ ] Check current branch (`git branch --show-current`)
  - [ ] Read sessions/CURRENT_STATUS.md
  - [ ] Review recent decisions (ls -t decisions/*.md | head -3)
  - [ ] Load latest checkpoint if needed
- [ ] Ensure on `main` branch before creating feature branch
- [ ] Create `claude/*` branch for new work

### During Work

- [ ] Follow commit message format
- [ ] Let hooks validate commits (don't skip)
- [ ] Use automation tools (validate-foundation, review-completeness)
- [ ] Create ADRs for significant decisions
- [ ] Update documentation as work progresses

### Every Session End

- [ ] Run `./tools/session-end.sh` which:
  - [ ] Validates uncommitted changes
  - [ ] Runs foundation validation
  - [ ] Runs completeness review (mandatory)
  - [ ] Prompts checkpoint creation
  - [ ] Shows session summary
- [ ] Commit all changes
- [ ] Push to `claude/*` branch
- [ ] Let GitHub handle PR creation and merging

### After GitHub Merges

- [ ] Pull merged changes: `git checkout main && git pull origin main`
- [ ] Delete local branch: `git branch -d claude/branch-name`
- [ ] Ready for next work

---

## What I Missed (And Now Understand)

### Gap 1: Branch Convention

**Missed:** Worked directly on `main` branch for Stage 1 setup

**Correct:** Should have created `claude/stage1-setup-20251112` branch

**Why it matters:** Auto-create PR workflow only triggers on `claude/*` branches. Working on `main` bypasses the entire automation system.

**Fix:** Future work must be on `claude/*` branches

### Gap 2: Git Hooks

**Missed:** Didn't configure `git config core.hooksPath .githooks`

**Correct:** Hooks must be activated with config command

**Why it matters:** Without hooks, local validation doesn't run. Errors caught only on GitHub, slower feedback loop.

**Fix:** Hooks now configured (✅)

### Gap 3: System Coordination

**Missed:** Treated task as isolated Stage 1 setup, didn't consider:
- How Claude Code Web established workflows
- How GitHub automation orchestrates PR lifecycle
- How my commits integrate with the larger system

**Correct:** Every action must consider ripple effects across three environments

**Why it matters:** Holistic System Thinking imperative - changes affect entire system, not just local environment

**Fix:** This document created to establish coordination understanding

### Gap 4: PR Automation

**Missed:** Didn't know GitHub auto-creates PRs from `claude/*` branches

**Correct:** Push to `claude/*` → GitHub creates PR → Validates → Auto-merges → Cleanup

**Why it matters:** Manual PR creation unnecessary and breaks automation flow. AI-First means automation handles mechanics.

**Fix:** Now understand full automation workflow

---

## Foundation Imperative Alignment

### Holistic System Thinking

This document addresses the **critical gap** identified by Claude Code Web:

"You solved the immediate task but didn't consider ripple effects across the three-node system."

**How this fixes it:**
- Maps all three environments and their responsibilities
- Documents coordination workflows between environments
- Establishes protocols for cross-environment handoff
- Explains automation dependencies

### AI-First

The automation system enables AI agent autonomy:
- Auto-create PR (no human needed)
- Auto-merge after validation (no human needed)
- Auto-cleanup branches (no human needed)
- Checkpoints preserve state (AI can resume seamlessly)

**Human role:** Strategic (approve checkpoint PRs, provide direction), not mechanical (create PRs, merge, cleanup)

### Configurability, Modularity, Extensibility

- Git hooks configurable via `core.hooksPath`
- GitHub workflows modifiable without code changes
- MCP servers add/remove via `claude mcp add/remove`
- Automation tools scriptable and version controlled

### Integration

- MCP protocol for tool integration
- Git hooks for validation integration
- GitHub Actions for automation integration
- Standard interfaces (bash scripts, JSON config)

### Automation

- PR creation automated
- Validation automated
- Merging automated
- Branch cleanup automated
- Checkpoint creation automated (on merge)
- Status generation automated

---

## For Future Sessions

**When you (Claude Code CLI) start a new session:**

1. **Load context first:**
   ```bash
   ./tools/resume-from-checkpoint.sh
   # OR
   ./tools/session-start.sh
   ```

2. **Verify integration:**
   ```bash
   git config core.hooksPath  # Should be .githooks
   git branch --show-current  # Should be main before branching
   claude mcp list           # Should show perplex-memory connected
   ```

3. **Create branch for work:**
   ```bash
   git checkout -b claude/cli-work-$(date +%Y%m%d-%H%M%S)
   ```

4. **Work, commit, push:**
   ```bash
   # Work...
   git add <files>
   git commit -m "Descriptive message"  # Hooks validate
   git push -u origin $(git branch --show-current)
   # GitHub handles rest!
   ```

5. **End session properly:**
   ```bash
   ./tools/session-end.sh
   ```

**When Claude Code Web hands off to you:**
- Checkpoint will exist
- Load it with `./tools/resume-from-checkpoint.sh`
- Understand current phase/focus
- Continue work on new `claude/*` branch

**When you hand off to Claude Code Web:**
- Create checkpoint with `./tools/create-checkpoint.sh`
- Push changes to `claude/*` branch
- Let GitHub create PR
- Human reviews checkpoint PR
- Claude Code Web resumes from checkpoint

---

## Key Insights

### 1. Three Environments, One System

Each environment is a specialized node in a distributed system. Coordination protocols prevent conflicts and enable seamless collaboration.

### 2. GitHub is the Orchestrator

Not just a code host - it's the automation hub that coordinates between environments, enforces validation, and manages lifecycle.

### 3. Automation Enables AI-First

Full automation (auto-create PR, auto-merge, auto-cleanup) removes human from mechanical loop. Human role becomes strategic approval and direction.

### 4. Hooks + GitHub Workflows = Defense in Depth

- Hooks catch issues locally (fast feedback)
- GitHub workflows enforce globally (consistent validation)
- Two layers prevent drift

### 5. Checkpoints Enable Continuity

Not just documentation - they're the handoff mechanism that allows different AI environments (and humans) to resume work seamlessly.

### 6. Branch Convention is Critical

`claude/*` branches trigger all automation. Working on `main` bypasses the entire system.

---

## Conclusion

Project Perplex isn't just code in a repository - it's a **coordinated three-environment system** where Claude Code Web, Claude Code CLI, and GitHub work together as a unified whole.

**My role (Claude Code CLI):**
- Follow established conventions (`claude/*` branches)
- Use automation tools (session-start, session-end, validation)
- Let GitHub handle PR mechanics
- Coordinate via checkpoints
- Think holistically about system impacts

**What changed after this understanding:**
- Git hooks configured (✅)
- Branch conventions understood (✅)
- PR automation understood (✅)
- System coordination documented (✅)

**Next time I start:**
- Load checkpoint first
- Verify hooks configured
- Create `claude/*` branch
- Work with system awareness

---

**Last Updated:** 2025-11-12
**Status:** Active System Documentation
**Addresses:** Holistic System Thinking gap identified by Claude Code Web
**Foundation Alignment:** All imperatives validated through system understanding

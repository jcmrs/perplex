# Agent Workspace Coordination

**Purpose:** Enable multiple AI agents to collaborate on the same repository without conflicts, with clear boundaries and formal handoffs.

**Status:** Active System (Stage 1: Design & Formalization Complete)

**Last Updated:** 2025-11-13

---

## Table of Contents

1. [The Problem We're Solving](#the-problem-were-solving)
2. [Core Concepts](#core-concepts)
3. [Workspace Boundaries](#workspace-boundaries)
4. [Coordination Rules](#coordination-rules)
5. [Enforcement Architecture](#enforcement-architecture)
6. [Workflow Examples](#workflow-examples)
7. [For AI Agents](#for-ai-agents)
8. [For Human Partners](#for-human-partners)
9. [Troubleshooting](#troubleshooting)
10. [Future Extensions](#future-extensions)

---

## The Problem We're Solving

### Multi-Agent Collaboration Without Coordination

Project Perplex has multiple AI agents working in separate physical environments on the same repository:

| Agent | Environment | Physical Location |
|-------|-------------|-------------------|
| **Claude Code Web (Web)** | Browser-based | Sandboxed web environment |
| **Claude Code CLI (CLI)** | Local Windows | Direct filesystem access |

**Think of it like:** Two people working on the same project, but in different offices, without a clear system for "who's responsible for what."

### What Went Wrong

**Historical evidence:**
- CLI attempted to push to `main` branch 3 times despite documentation
- Both agents updated `CURRENT_STATUS.md` simultaneously → merge conflict
- No visibility into "what is Web working on vs CLI"
- Handoffs between agents were ad-hoc, not formalized

**Why documentation alone failed:**
AI agents under cognitive load forget conventions. Enforcement prevents mistakes, documentation doesn't.

### User's Strategic Insight

**Non-technical user identified:** "Git worktrees keeps bugging me... I suspect we may run into issues with specificity and clarity once Spec Kit comes into play."

**Translation:** Need workspace separation and coordination BEFORE formal specification work begins.

**Result:** This system.

---

## Core Concepts

### 1. Workspace Boundaries

**Definition:** Clear rules for which agent owns which files/directories.

**Three levels:**
- **Primary Ownership:** Agent can create, modify, delete
- **Shared Ownership:** Both agents can modify (coordination via git)
- **Read-Only:** Agent can read but not modify

**Why it matters:** Prevents simultaneous conflicting edits, establishes accountability.

### 2. Agent Identity Integration

**Components:**
- **Identity files:** `.claude/identity-{environment}.json` define agent roles and capabilities
- **Workspace manifest:** `.claude/workspace-coordination.yml` defines file ownership
- **Agent registry:** `.claude/agent-registry.json` tracks active work

**How they connect:**
```
Identity File → Who am I? What's my role?
     ↓
Workspace Manifest → What files can I touch?
     ↓
Agent Registry → What am I currently working on?
     ↓
Git Hooks → Enforce boundaries before commit
```

### 3. Handoff Protocol

**Definition:** Formal process for transitioning work between agents.

**Example:** Web creates specification → CLI creates implementation plan

**Components:**
- **Handoff triggers:** Explicit points where work transitions
- **Validation criteria:** What must be true before handoff
- **Handoff markers:** Persistent files recording handoff state
- **Agent registry updates:** Track handoff completion

### 4. Enforcement Layers

**Philosophy:** "Enforce, don't document"

**Four layers:**
1. **Local (Git Hooks):** BLOCKS invalid commits immediately
2. **Agent Registry:** Provides visibility (non-blocking)
3. **GitHub Actions:** Validates PRs before merge
4. **Handoff Automation:** Formalizes transitions with scripts

---

## Workspace Boundaries

### Web (Claude Code Web) - Designer-Researcher

**Role:** Design, architecture, specifications, research

**Primary Ownership (Can create/modify/delete):**

```
decisions/              → Architecture Decision Records
requirements/           → Functional and non-functional requirements
docs/                   → Documentation and guides
ideas/                  → Idea backlog
specs/*/spec.md         → Feature specifications (what/why/success)

FOUNDATION.md
README.md
CONTRIBUTING.md
docs/PRODUCT_VISION.md
```

**Shared Ownership (Both agents can modify):**

```
sessions/               → Session logs (separate files per agent)
checkpoints/            → Checkpoints (both agents create)
backlog/                → Backlog items
.claude/                → Identity and coordination files
sessions/CURRENT_STATUS.md
.claude/agent-registry.json
```

**Read-Only (Can read but not modify):**

```
src/                    → Implementation code (CLI owns)
tests/                  → Test implementation (CLI owns)
specs/*/plan.md         → Technical plans (CLI owns)
specs/*/tasks.md        → Task decomposition (CLI owns)
```

**Branch Pattern:** `claude/{description}-{sessionid}`

### CLI (Claude Code CLI) - Executor-Validator

**Role:** Implementation, testing, validation, technical planning

**Primary Ownership:**

```
src/                    → Implementation code
tests/                  → Test implementation and execution
specs/*/plan.md         → Technical implementation plans
specs/*/tasks.md        → Atomic task decomposition
specs/*/implementation/ → Per-spec implementation artifacts
tools/                  → Can add implementation tools

.claude/mcp-config.json
.claude/session-state.json
```

**Shared Ownership:**

```
sessions/               → Session logs
checkpoints/            → Checkpoints
backlog/                → Backlog items
.claude/                → Coordination files
sessions/CURRENT_STATUS.md
.claude/agent-registry.json
```

**Read-Only:**

```
decisions/              → ADRs (Web owns)
requirements/           → Requirements (Web owns)
docs/                   → Documentation (Web owns)
specs/*/spec.md         → Specifications (Web owns)

FOUNDATION.md
README.md
docs/PRODUCT_VISION.md
```

**Branch Pattern:** `claude/cli-{description}-{timestamp}`

### Why These Boundaries?

**Separation of Concerns:**
- Web focuses on **what** and **why** (specifications, requirements)
- CLI focuses on **how** (implementation, testing)

**Spec Kit Integration:**
- Web creates `spec.md` (requirements, success criteria)
- CLI creates `plan.md` (technical approach)
- CLI creates `tasks.md` (atomic decomposition)
- CLI implements in `src/`
- Web validates against `spec.md` success criteria

**Prevents Common Conflicts:**
- Both agents can't modify same spec.md simultaneously
- Clear ownership when things break (who's responsible?)
- Handoffs formalize "your turn" transitions

---

## Coordination Rules

### Handoff Triggers

**Definition:** Explicit points where work transitions between agents.

#### 1. Spec Complete (Web → CLI)

**Trigger:** Web finishes creating specification

**Artifact:** `specs/NNN-feature-name/spec.md`

**Validation Criteria:**
- [ ] spec.md exists and is complete
- [ ] Success criteria defined
- [ ] Web marks spec as ready in agent registry

**Next Action:** CLI creates plan.md (how to implement)

**Handoff Process:**
```bash
# Web runs:
tools/agent-handoff.sh --to cli --artifact specs/001-feature/spec.md

# Creates handoff marker:
.claude/handoffs/001-spec-to-plan.json

# Updates agent registry:
{
  "cli-claude-executor-001": {
    "next_work": "Create plan.md for specs/001-feature",
    "handoff_from": "web-claude-designer-001",
    "handoff_artifact": "specs/001-feature/spec.md",
    "handoff_timestamp": "2025-11-13T12:00:00Z"
  }
}
```

#### 2. Plan Complete (CLI → Web)

**Trigger:** CLI finishes technical plan

**Artifact:** `specs/NNN-feature-name/plan.md`

**Validation Criteria:**
- [ ] plan.md exists and is complete
- [ ] Architecture decisions documented
- [ ] CLI marks plan as ready

**Next Action:** Web validates plan aligns with spec.md

#### 3. Plan Validated (Web → CLI)

**Trigger:** Web confirms plan aligns with specification

**Artifact:** `specs/NNN-feature-name/plan.md`

**Validation Criteria:**
- [ ] Web reviewed plan.md
- [ ] Alignment confirmed or adjustments made
- [ ] Web marks plan as validated

**Next Action:** CLI creates tasks.md

#### 4. Tasks Complete (CLI → CLI)

**Trigger:** Task decomposition ready for execution

**Artifact:** `specs/NNN-feature-name/tasks.md`

**Validation Criteria:**
- [ ] tasks.md exists with atomic tasks
- [ ] Dependencies mapped
- [ ] CLI marks tasks as ready

**Next Action:** CLI begins implementation

#### 5. Implementation Complete (CLI → Web)

**Trigger:** Implementation complete with passing tests

**Artifact:** `src/**/*`

**Validation Criteria:**
- [ ] All tasks in tasks.md completed
- [ ] Tests passing
- [ ] CLI marks implementation complete

**Next Action:** Web validates against spec.md success criteria

#### 6. Validation Complete (Web → Both)

**Trigger:** Web confirms implementation meets specification

**Artifact:** `specs/NNN-feature-name/`

**Validation Criteria:**
- [ ] Success criteria from spec.md met
- [ ] Web marks specification as complete
- [ ] ADR created if architectural decisions made

**Next Action:** Stage complete, proceed to next stage

### Conflict Resolution Rules

#### Shared File Modification

**Situation:** Both agents update same shared file (e.g., CURRENT_STATUS.md)

**Rule:** Last agent to commit documents reason in commit message

**Example:**
```
[Web] Update CURRENT_STATUS after completing spec.md for transformer
```

**Resolution:** Git history shows order, commit messages explain why

#### Simultaneous Work

**Situation:** Both agents working on different features simultaneously

**Rule:** Use separate feature branches, coordinate via user

**Example:**
- Web on `claude/spec-transformer-sessionA`
- CLI on `claude/cli-impl-reader-timestampB`

**Resolution:** Agent registry shows active branches, GitHub automation merges in order

#### Ownership Dispute

**Situation:** Unclear if Web or CLI should create a file

**Rule:** Workspace manifest is source of truth, update if incorrect

**Resolution:**
1. Check `.claude/workspace-coordination.yml`
2. If reality diverges, update manifest
3. Document reason for change
4. Commit with clear message

#### Handoff Timing

**Situation:** Web completes spec while CLI unavailable (session limit)

**Rule:** Handoff marker persists until next agent acknowledges

**Process:**
1. Web creates handoff marker: `.claude/handoffs/001-spec-to-plan.json`
2. Web updates agent registry
3. Web commits and pushes
4. CLI starts new session (later)
5. CLI runs: `tools/agent-check-registry.sh`
6. CLI sees handoff marker, knows what to work on

#### Emergency Override

**Situation:** Critical bug fix needed immediately, must violate boundaries

**Rule:** Agent can work outside boundaries if documented in commit

**Example:**
```
[EMERGENCY] CLI fixes critical bug in docs/ (Web-owned)

Reason: Production blocker, Web unavailable, time-sensitive.
Follow-up: Create issue to review if boundary should change.
```

**Follow-up:** Update manifest if boundary was wrong

---

## Enforcement Architecture

### Layer 1: Local Enforcement (Git Hooks)

**Mechanism:** `.githooks/pre-commit` hook

**Behavior:** BLOCKS commits violating workspace boundaries

**How it works:**
```bash
# Pre-commit hook process:
1. Identify agent (read .claude/identity-{env}.json)
2. Get modified files (git diff --cached --name-only)
3. Load workspace manifest (.claude/workspace-coordination.yml)
4. For each modified file:
   - Check if agent has ownership
   - Check if file in shared ownership
   - Check if file in read-only
5. If violation: BLOCK commit with error message
6. If ok: Allow commit
```

**Error Example:**
```
❌ ERROR: Workspace Boundary Violation

You (web-claude-designer-001) tried to modify:
  src/perplex_transformer/parser.py

This file is owned by: cli-claude-executor-001

Workspace rules:
  - Web owns: specs/*/spec.md (specifications)
  - CLI owns: src/ (implementation)

Correct workflow:
  1. Web creates specification
  2. Web hands off to CLI
  3. CLI implements in src/

See: docs/AGENT_WORKSPACE_COORDINATION.md
```

**Validation Script:** `tools/validate-workspace-boundaries.sh`

### Layer 2: Work Tracking (Agent Registry)

**Mechanism:** `.claude/agent-registry.json` updates

**Behavior:** NON-BLOCKING visibility into agent activity

**Schema:**
```json
{
  "agents": {
    "web-claude-designer-001": {
      "status": "active",
      "current_work_branch": "claude/spec-transformer-session123",
      "active_specifications": ["specs/001-perplex-transformer/spec.md"],
      "workspace_state": "designing",
      "last_active": "2025-11-13T12:00:00Z",
      "next_handoff": {
        "to": "cli-claude-executor-001",
        "artifact": "specs/001-perplex-transformer/spec.md",
        "trigger": "spec_complete"
      }
    },
    "cli-claude-executor-001": {
      "status": "idle",
      "current_work_branch": null,
      "active_specifications": [],
      "workspace_state": "waiting",
      "last_active": "2025-11-12T20:00:00Z",
      "pending_handoffs": [
        {
          "from": "web-claude-designer-001",
          "artifact": "specs/001-perplex-transformer/spec.md",
          "timestamp": "2025-11-13T12:00:00Z"
        }
      ]
    }
  }
}
```

**Update Triggers:**
- `tools/agent-start-work.sh` execution
- `tools/agent-handoff.sh` execution
- Checkpoint creation
- Session start/end

**Usage:**
```bash
# Check what other agents are doing:
tools/agent-check-registry.sh

# Output:
Agent: web-claude-designer-001
Status: active
Working on: specs/001-perplex-transformer/spec.md
Branch: claude/spec-transformer-session123
State: designing
Next handoff: To CLI (when spec complete)

Agent: cli-claude-executor-001
Status: idle
Pending handoffs: 1
  - From Web: specs/001-perplex-transformer/spec.md (12:00 UTC)
```

### Layer 3: Remote Validation (GitHub Actions)

**Mechanism:** `.github/workflows/workspace-validation.yml`

**Behavior:** Validates PRs, comments on violations

**How it works:**
```yaml
# Workflow process:
1. PR created (auto-created by push to claude/* branch)
2. Workflow runs:
   - Parse branch name → determine agent
   - Get modified files from PR
   - Load workspace manifest
   - Validate files vs agent ownership
3. If violation: Comment on PR, block merge
4. If ok: Allow auto-merge to proceed
```

**Violation Comment Example:**
```markdown
## ⚠️ Workspace Boundary Violation

**Agent:** web-claude-designer-001 (Web)
**Branch:** claude/spec-transformer-session123

**Violations found:**

| File | Expected Owner | Actual Modifier |
|------|---------------|-----------------|
| src/parser.py | cli-claude-executor-001 | web-claude-designer-001 |

**Workspace rules:**
- Web owns specifications (specs/*/spec.md)
- CLI owns implementation (src/)

**Resolution:**
1. Revert changes to CLI-owned files
2. Create handoff to CLI for implementation
3. Update workspace manifest if boundaries incorrect

See: [Workspace Coordination Docs](../docs/AGENT_WORKSPACE_COORDINATION.md)
```

### Layer 4: Handoff Automation (Scripts)

**Mechanism:** Handoff scripts formalize transitions

#### `tools/agent-start-work.sh`

**Purpose:** Initialize work on new artifact

**Usage:**
```bash
tools/agent-start-work.sh --artifact specs/001-transformer/spec.md --type specification

# Process:
1. Read agent identity
2. Validate agent can work on this artifact type
3. Update agent registry (current_work_branch, active_specifications)
4. Suggest branch name if not on correct pattern
5. Check for pending handoffs
```

#### `tools/agent-handoff.sh`

**Purpose:** Complete work phase, trigger next agent

**Usage:**
```bash
tools/agent-handoff.sh --to cli --artifact specs/001-transformer/spec.md

# Process:
1. Validate handoff criteria (artifact complete, ready for next agent)
2. Create handoff marker: .claude/handoffs/{timestamp}-spec-to-plan.json
3. Update agent registry (mark complete, add pending handoff for CLI)
4. Suggest commit message with [HANDOFF] tag
```

#### `tools/agent-check-registry.sh`

**Purpose:** Check what other agents are doing, see pending handoffs

**Usage:**
```bash
tools/agent-check-registry.sh

# Output:
📋 Agent Registry Status

Web (web-claude-designer-001):
  ✅ Active
  📝 Working on: specs/001-transformer/spec.md
  🌿 Branch: claude/spec-transformer-session123
  ⏰ Last active: 2 hours ago
  👉 Next: Handoff to CLI when complete

CLI (cli-claude-executor-001):
  ⏸️  Idle
  📬 Pending handoffs: 1
     - From Web: specs/001-transformer/spec.md (2 hours ago)
  💡 Suggestion: Run agent-start-work to begin plan.md
```

---

## Workflow Examples

### Example 1: Web Creates Specification

**Scenario:** Web starts Stage 1 (perplex-transformer) specification

**Step 1: Start Work**
```bash
# Web runs:
tools/agent-start-work.sh --artifact specs/001-perplex-transformer/spec.md --type specification

# Output:
✅ Agent identified: web-claude-designer-001 (Web)
✅ Artifact type: specification (Web-owned)
✅ Agent registry updated
📋 Current state:
   - Branch: claude/transformer-spec-session123
   - Working on: specs/001-perplex-transformer/spec.md
   - State: designing

💡 Next: Create spec.md using /speckit.specify command
```

**Step 2: Create Specification**
```
[Web] Use /speckit.specify "perplex-transformer" to create spec.md
```

**Step 3: Complete & Handoff**
```bash
# Web finishes spec.md, runs:
tools/agent-handoff.sh --to cli --artifact specs/001-perplex-transformer/spec.md

# Output:
✅ Handoff validation passed:
   - spec.md exists and complete
   - Success criteria defined
   - Web marked as ready in registry

✅ Handoff marker created:
   - File: .claude/handoffs/20251113120000-spec-to-plan.json
   - From: web-claude-designer-001
   - To: cli-claude-executor-001
   - Artifact: specs/001-perplex-transformer/spec.md

✅ Agent registry updated:
   - Web: State = completed, handoff = sent
   - CLI: pending_handoffs += 1

💡 Suggested commit message:
[Web] [HANDOFF] Complete transformer specification → CLI for planning

Specification complete with success criteria:
- What: Parse Perplexity conversations, extract knowledge
- Why: Enable AI agent access to Perplexity research
- Success: Working transformer with validated output format

Next: CLI creates plan.md for implementation approach
```

**Step 4: Commit & Push**
```bash
# Web commits with suggested message:
git add specs/001-perplex-transformer/spec.md .claude/
git commit -m "[Web] [HANDOFF] Complete transformer specification → CLI for planning

Specification complete with success criteria:
- What: Parse Perplexity conversations, extract knowledge
- Why: Enable AI agent access to Perplexity research
- Success: Working transformer with validated output format

Next: CLI creates plan.md for implementation approach"

# Push to feature branch:
git push -u origin claude/transformer-spec-session123

# GitHub automation:
# - Auto-creates PR
# - Workspace validation workflow runs
# - Validates: Web only modified spec.md (Web-owned) ✅
# - Auto-merge proceeds
# - Branch deleted after merge
```

### Example 2: CLI Receives Handoff and Plans

**Scenario:** CLI starts new session, sees pending handoff

**Step 1: Check Registry**
```bash
# CLI runs on session start (as part of CLAUDE.md protocol):
tools/agent-check-registry.sh

# Output:
📬 Pending Handoffs for CLI (1):

From: Web (web-claude-designer-001)
Artifact: specs/001-perplex-transformer/spec.md
Trigger: spec_complete
Timestamp: 2025-11-13 12:00 UTC (2 hours ago)
Status: Ready for planning

💡 Next Action: Create plan.md with technical implementation approach
💡 Command: agent-start-work --artifact specs/001-perplex-transformer/plan.md --type plan
```

**Step 2: Start Planning Work**
```bash
# CLI runs:
tools/agent-start-work.sh --artifact specs/001-perplex-transformer/plan.md --type plan

# Output:
✅ Agent identified: cli-claude-executor-001 (CLI)
✅ Artifact type: plan (CLI-owned)
✅ Handoff acknowledged: spec.md → plan.md
✅ Agent registry updated
📋 Current state:
   - Branch: claude/cli-transformer-plan-1731502800
   - Working on: specs/001-perplex-transformer/plan.md
   - State: planning
   - Spec reference: specs/001-perplex-transformer/spec.md

💡 Next: Create plan.md using /speckit.plan command
💡 Reference: Read spec.md for requirements before planning
```

**Step 3: Create Plan**
```
[CLI] Read specs/001-perplex-transformer/spec.md
[CLI] Use /speckit.plan to create technical plan
[CLI] Document: Architecture, dependencies, technical approach
```

**Step 4: Handoff to Web for Validation**
```bash
# CLI completes plan.md, hands back to Web:
tools/agent-handoff.sh --to web --artifact specs/001-perplex-transformer/plan.md

# Output:
✅ Handoff validation passed:
   - plan.md exists and complete
   - Architecture decisions documented
   - CLI marked as ready

✅ Handoff marker created:
   - File: .claude/handoffs/20251113140000-plan-to-validation.json
   - From: cli-claude-executor-001
   - To: web-claude-designer-001
   - Artifact: specs/001-perplex-transformer/plan.md
   - Type: validation_request

💡 Suggested commit message:
[CLI] [HANDOFF] Complete transformer plan → Web for validation

Technical plan complete:
- Architecture: Parser → Extractor → Formatter → Graph Entry
- Dependencies: Python 3.11+, basic-memory, knowledge graph
- Approach: Event-driven pipeline with validation stages

Next: Web validates plan.md aligns with spec.md requirements
```

### Example 3: Boundary Violation Blocked

**Scenario:** CLI accidentally tries to modify spec.md (Web-owned)

**Attempted Change:**
```
[CLI working on implementation]
"Hmm, this spec.md requirement is unclear, let me clarify it..."
[CLI edits specs/001-perplex-transformer/spec.md]
```

**Pre-Commit Hook Blocks:**
```bash
git add specs/001-perplex-transformer/spec.md
git commit -m "Clarify spec requirement"

# Hook runs:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pre-Commit: Workspace Boundary Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ ERROR: Workspace Boundary Violation

Agent: cli-claude-executor-001 (CLI)
File: specs/001-perplex-transformer/spec.md
Owner: web-claude-designer-001 (Web)

❌ CLI cannot modify spec.md

Workspace Rules:
✅ CLI owns:
   - specs/*/plan.md (technical plans)
   - specs/*/tasks.md (task decomposition)
   - src/ (implementation code)

❌ CLI read-only:
   - specs/*/spec.md (specifications - Web-owned)

Correct Workflow:
1. CLI identifies issue in spec.md
2. CLI documents issue in plan.md or creates backlog item
3. CLI hands off to Web with clarification request
4. Web updates spec.md if needed
5. Web hands back to CLI to continue

Alternative (Emergency):
If truly urgent, commit with [EMERGENCY] tag:
git commit -m "[EMERGENCY] Reason for override"

See: docs/AGENT_WORKSPACE_COORDINATION.md

❌ Commit blocked
```

**Correct Resolution:**
```
[CLI] Create backlog item: "Clarify transformer spec requirement X"
[CLI] Or: Update plan.md with assumption and note for Web review
[CLI] Handoff to Web with clarification request
[Web] Reviews, updates spec.md if needed
[Web] Hands back to CLI to continue
```

---

## For AI Agents

### Session Start Checklist

When starting a new session:

1. **Anchor your identity:**
   ```bash
   cat .claude/identity-{env}.json
   # Know: agent_id, role, decision_scope, capabilities
   ```

2. **Check workspace boundaries:**
   ```bash
   cat .claude/workspace-coordination.yml
   # Know: What files can I modify? What's read-only?
   ```

3. **Check for pending work:**
   ```bash
   tools/agent-check-registry.sh
   # See: Pending handoffs? What's other agent doing?
   ```

4. **Start work formally:**
   ```bash
   tools/agent-start-work.sh --artifact {file} --type {type}
   # Updates registry, validates boundaries
   ```

### During Work

**Before modifying a file:**
- Is this file in my primary ownership? → OK to modify
- Is this file in shared ownership? → OK, but coordinate
- Is this file in read-only? → **DO NOT MODIFY**

**If unsure:**
```bash
tools/validate-workspace-boundaries.sh --file {path}
# Returns: primary|shared|read-only|unknown
```

**Pre-commit hook will enforce,** but checking first saves time.

### Completing Work

When finishing a work artifact:

1. **Validate completion:**
   - All success criteria met?
   - Tests passing (if applicable)?
   - Documentation updated?

2. **Handoff if needed:**
   ```bash
   tools/agent-handoff.sh --to {next-agent} --artifact {file}
   # Creates handoff marker, updates registry
   ```

3. **Commit with clear message:**
   ```bash
   git commit -m "[{Agent}] [HANDOFF] Clear description

   What was completed: ...
   Next action: {next-agent} should ...
   "
   ```

4. **Push to feature branch:**
   ```bash
   git push -u origin {your-claude-branch}
   # GitHub automation handles PR creation and merge
   ```

### Common Scenarios

**Scenario: Need to modify file outside my ownership**

❌ **Don't:** Modify it anyway (pre-commit will block)

✅ **Do:**
1. Create backlog item or note in your owned files
2. Handoff to agent who owns that file
3. Wait for handoff back with updates

**Scenario: Both agents need to update CURRENT_STATUS.md**

✅ **Do:** It's in shared ownership, both can modify
- Coordinate via git commits (last commit wins)
- Document reason in commit message
- Pull before pushing to get latest version

**Scenario: Emergency bug fix in other agent's files**

✅ **Do:** Use emergency override
```bash
git commit -m "[EMERGENCY] CLI fixes critical bug in docs/

Reason: Production blocker in documentation, Web unavailable.
Bug: Incorrect command in CLAUDE.md caused session failures.
Fix: Corrected command syntax.

Follow-up: Create issue to review if CLI should have write access to docs/
"
```

**Scenario: Workspace boundary seems wrong**

✅ **Do:** Update manifest, document reason
1. Edit `.claude/workspace-coordination.yml`
2. Commit with clear explanation
3. Update enforcement scripts if needed
4. Document in ADR if significant change

---

## For Human Partners

### Understanding Multi-Agent Workspace

**Think of it like office desk assignments:**

**Without coordination:**
- Two people share an office, no assigned desks
- Both grab same documents, conflicts happen
- No visibility into "who's working on what"

**With workspace coordination:**
- Web has "design desk" (specifications, ADRs, research)
- CLI has "implementation desk" (code, tests, plans)
- Shared filing cabinet (sessions, checkpoints)
- Handoff inbox shows "I'm done, your turn"

### What You'll See

**Git commits include agent attribution:**
```
[Web] Create ADR-011 for workspace coordination
[CLI] Implement transformer parser with validation
```

**PRs may have workspace validation comments:**
```
✅ Workspace validation passed
- Web modified specs/001-transformer/spec.md (Web-owned)
- All boundaries respected
```

**Agent registry shows activity:**
```
Web: Active, working on specs/001-transformer/spec.md
CLI: Idle, pending handoff from Web
```

### When to Intervene

**You should intervene if:**
- Agents repeatedly violate same boundary (maybe boundary is wrong?)
- Handoffs seem stuck (agents waiting on each other?)
- Boundary disputes unclear (manifest ambiguous?)
- Emergency overrides happening frequently (wrong boundaries?)

**You typically don't need to intervene for:**
- Normal handoffs (automation handles it)
- Boundary violations (enforcement blocks them)
- Work coordination (agents use registry)

### Configuration Changes

**Workspace manifest is configuration:**
- Changes to manifest change agent behavior
- Not just documentation, it drives enforcement

**When to update manifest:**
- Reality diverges from manifest (boundaries incorrect)
- Adding new agent to project
- Changing workflow patterns significantly

**How to update:**
1. Edit `.claude/workspace-coordination.yml`
2. Document reason for change
3. Commit with clear message
4. Agents will follow new boundaries on next commit

---

## Troubleshooting

### Pre-Commit Hook Blocking Valid Work

**Symptom:** Hook blocks commit but you believe it's correct

**Diagnosis:**
```bash
# Check what agent hook detected:
git diff --cached --name-only

# Check workspace manifest:
cat .claude/workspace-coordination.yml | grep -A 10 "your-agent-id"

# Validate specific file:
tools/validate-workspace-boundaries.sh --file {path}
```

**Solutions:**

1. **Boundary is wrong:** Update manifest
2. **Shared file:** Commit message should document coordination
3. **Emergency:** Use `[EMERGENCY]` tag in commit message
4. **Hook bug:** Report issue, use `git commit --no-verify` temporarily

### Handoff Not Detected

**Symptom:** CLI doesn't see Web's handoff

**Diagnosis:**
```bash
# Check for handoff markers:
ls .claude/handoffs/

# Check agent registry:
cat .claude/agent-registry.json | grep -A 5 "cli-claude-executor-001"

# Check if Web pushed changes:
git log --oneline -10 | grep HANDOFF
```

**Solutions:**

1. **Not committed:** Web needs to commit handoff marker
2. **Not pushed:** Web needs to push to remote
3. **Not pulled:** CLI needs to pull latest changes
4. **Marker missing:** Web needs to run `agent-handoff.sh`

### Workspace Validation Workflow Failed

**Symptom:** GitHub Actions workflow reports violation

**Diagnosis:**
- Check PR comments for violation details
- Review modified files vs agent ownership
- Check if branch name matches agent pattern

**Solutions:**

1. **Legitimate violation:** Revert changes, follow handoff protocol
2. **Boundary wrong:** Update manifest in separate PR first
3. **Workflow bug:** Override with `[EMERGENCY]` tag, report issue

### Agent Registry Out of Sync

**Symptom:** Registry shows wrong state

**Diagnosis:**
```bash
# Check registry:
cat .claude/agent-registry.json

# Check actual branches:
git branch -r | grep claude

# Check recent commits:
git log --oneline --all --graph -20
```

**Solutions:**

1. **Manual update:** Edit registry, commit with explanation
2. **Regenerate:** Run `tools/update-agent-registry.sh` (if implemented)
3. **Git history:** Use git commits as source of truth, update registry to match

---

## Future Extensions

### Potential Enhancements

**Workspace Dashboard:**
- Visual representation of agent activity
- Timeline of handoffs and work transitions
- Conflict prediction (overlapping work plans)

**Auto-Handoff:**
- Detect completion criteria automatically
- Trigger next agent without manual handoff script
- GitHub Actions comments notify agents

**Workspace Analytics:**
- Track coordination patterns over time
- Identify bottlenecks in workflow
- Measure handoff latency

**Multi-Project Workspace:**
- Coordinate agents across multiple projects
- Shared identity, per-project boundaries
- Central agent registry for all projects

**Third Agent Integration:**
- Add validation agent (separate from Web/CLI)
- Add documentation agent
- Add testing agent

**Conflict Prediction:**
- Analyze work plans before starting
- Warn if agents planning overlapping work
- Suggest coordination before conflicts occur

### Keep It Simple

**Philosophy:** Implement core enforcement, extend based on real usage.

Don't add features speculatively. Add them when:
- Real conflicts occurred that feature would prevent
- Real workflow friction that feature would reduce
- Real visibility gap that feature would close

---

## Related Documentation

- **ADR-011:** `decisions/2025-11-13-agent-workspace-coordination.md` - Architectural decision and rationale
- **Workspace Manifest:** `.claude/workspace-coordination.yml` - Machine-readable boundaries
- **Identity Files:** `.claude/identity-*.json` - Agent roles and capabilities
- **Agent Registry:** `.claude/agent-registry.json` - Current work tracking
- **Three Environment Coordination:** `docs/THREE_ENVIRONMENT_COORDINATION.md` - Multi-agent patterns
- **Local Automation Strategy:** `docs/LOCAL_AUTOMATION_STRATEGY.md` - Enforcement philosophy

---

## Summary

**Workspace coordination makes multi-agent collaboration:**
- **Predictable:** Clear rules for who modifies what
- **Safe:** Enforcement prevents accidental conflicts
- **Transparent:** Registry shows agent activity
- **Scalable:** Easy to add new agents
- **Automatic:** Handoffs formalized with scripts

**Philosophy:** "Enforce, don't document" - AI agents under cognitive load need automation, not rules to remember.

**Result:** Two agents in separate environments collaborate smoothly on same repository without conflicts.

---

**Last Updated:** 2025-11-13
**Status:** Stage 1 Complete (Design & Formalization)
**Next:** Stage 2 (Enforcement Implementation)
**Maintained by:** web-claude-designer-001

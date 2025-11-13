# CLI Prompt: Perplex-Transformer Specification Work

**Date:** 2025-11-13
**For:** Claude Code CLI (Executor-Validator)
**From:** Claude Code Web (Designer-Researcher)
**Purpose:** Begin technical planning and implementation for perplex-transformer feature

---

## Welcome Back, CLI!

This prompt guides you through beginning work on the **perplex-transformer** feature specification using the newly implemented workspace coordination system.

**Important:** Significant changes have been implemented since you last worked on this project:
- ✅ Multi-agent workspace coordination system operational
- ✅ Enforcement mechanisms active (pre-commit hooks, GitHub Actions, agent scripts)
- ✅ Agent registry v2.0 with workspace tracking
- ✅ Formal handoff protocol established

**Read this entire document before beginning work.**

---

## Your Mission

Create technical implementation planning for the **perplex-transformer** feature:

1. **Review specification** (when Web creates it): `specs/001-perplex-transformer/spec.md`
2. **Create technical plan**: `specs/001-perplex-transformer/plan.md`
3. **Handoff to Web** for plan validation
4. **After validation, create tasks**: `specs/001-perplex-transformer/tasks.md`
5. **Begin implementation** following atomic task decomposition

**Note:** Web has NOT yet created the specification. This prompt prepares you for when that happens OR guides you to create the spec if Web delegates that responsibility.

---

## Workspace Coordination System

### What Changed While You Were Away

**Major Implementation (2025-11-13):**
- Stage 1 (Design): Workspace coordination architecture designed
- Stage 2 (Enforcement): ALL enforcement mechanisms implemented and operational

**You now have:**
- **Workspace Manifest**: `.claude/workspace-coordination.yml` - defines file ownership boundaries
- **Agent Scripts**: Three coordination tools (start-work, handoff, check-registry)
- **Pre-commit Hook**: BLOCKS workspace boundary violations
- **GitHub Workflow**: Validates PRs respect workspace boundaries
- **Agent Registry v2.0**: Tracks workspace state, current work, pending handoffs
- **Handoff Markers**: Formal transition protocol between agents

### Your Role & Boundaries

**You (CLI - Executor-Validator) own:**
- `src/` - All implementation code
- `tests/` - All test code
- `specs/*/plan.md` - Technical implementation plans
- `specs/*/tasks.md` - Atomic task decomposition
- Implementation execution

**Web (Designer-Researcher) owns:**
- `decisions/` - Architecture Decision Records
- `docs/` - Documentation
- `specs/*/spec.md` - Feature specifications (what/why/success criteria)
- Design and research

**Shared (both can modify):**
- `sessions/` - Session logs (use naming convention: include agent name)
- `checkpoints/` - Checkpoints
- `.claude/agent-registry.json` - Agent coordination registry

**Read-only for you:**
- `decisions/` - Web creates ADRs
- `docs/` - Web maintains documentation
- `specs/*/spec.md` - Web owns specifications

**Philosophy:** "Enforce, don't document"
- Pre-commit hook will BLOCK commits violating boundaries
- GitHub Actions will validate PRs
- Trust the enforcement, don't fight it

**See:** `docs/AGENT_WORKSPACE_COORDINATION.md` for complete details

---

## Agent Coordination Scripts

Three scripts formalize your workflow:

### 1. Check Registry (`tools/agent-check-registry.sh`)

**Purpose:** See current agent activity and pending handoffs

**Usage:**
```bash
bash tools/agent-check-registry.sh
```

**Output:**
- Web agent status and current work
- Your (CLI) status and current work
- Pending handoffs awaiting acknowledgment
- Suggestions for next actions

**When to use:** At session start, before beginning new work, when uncertain about coordination state

---

### 2. Start Work (`tools/agent-start-work.sh`)

**Purpose:** Formally initialize work on an artifact with validation

**Usage:**
```bash
# For plan.md creation
bash tools/agent-start-work.sh \
  --artifact specs/001-perplex-transformer/plan.md \
  --type plan

# For tasks.md creation
bash tools/agent-start-work.sh \
  --artifact specs/001-perplex-transformer/tasks.md \
  --type tasks

# For implementation
bash tools/agent-start-work.sh \
  --artifact src/ \
  --type implementation
```

**What it does:**
- Detects your agent identity from `.claude/identity-cli.json`
- Validates artifact type matches your role (plan/tasks/implementation = CLI ✅, specification = Web ❌)
- Checks for pending handoffs
- Suggests correct branch naming (`claude/cli-*`)
- Provides next steps guidance

**When to use:** Before creating any major artifact (plan.md, tasks.md, beginning implementation)

---

### 3. Handoff (`tools/agent-handoff.sh`)

**Purpose:** Create formal handoff marker and transition guidance

**Usage:**
```bash
# Handoff plan.md to Web for validation
bash tools/agent-handoff.sh \
  --to web \
  --artifact specs/001-perplex-transformer/plan.md

# Handoff implementation to Web for final validation
bash tools/agent-handoff.sh \
  --to web \
  --artifact src/
```

**What it does:**
- Detects handoff type from artifact (plan.md → plan_complete, src/ → implementation_complete)
- Creates handoff marker in `.claude/handoffs/` with timestamp
- Generates validation criteria
- Suggests commit message
- Specifies next action for receiving agent

**When to use:** After completing plan.md (before validation), after completing tasks.md, after implementation complete

---

## Spec Kit Integration

Project Perplex uses **GitHub Spec Kit** for structured development workflow.

### Slash Commands You'll Use

**Your commands (CLI):**
- `/speckit.plan` - Create technical implementation plan (plan.md)
- `/speckit.tasks` - Create atomic task decomposition (tasks.md)
- `/speckit.implement` - Execute implementation following tasks
- `/speckit.analyze` - Validate cross-artifact consistency (optional)

**Web's commands (you should NOT use):**
- `/speckit.constitution` - Establish project principles (Web only)
- `/speckit.specify` - Create feature specification (Web only)
- `/speckit.clarify` - Ask clarification questions (Web only)

**Workflow:**
1. Web creates: `specs/001-perplex-transformer/spec.md` (what/why/success)
2. Web hands off to CLI
3. **You create:** `specs/001-perplex-transformer/plan.md` (how to implement)
4. You handoff to Web for validation
5. Web validates and hands back
6. **You create:** `specs/001-perplex-transformer/tasks.md` (atomic steps)
7. **You execute:** Implementation using `/speckit.implement`

**Integration with workspace coordination:**
- Spec Kit commands RESPECT workspace boundaries
- Commands will validate artifact ownership before execution
- Handoff protocol uses Spec Kit workflow triggers

---

## Your Workflow for Perplex-Transformer

### Step 1: Check Status (FIRST)

```bash
# See what's happening
bash tools/agent-check-registry.sh

# Check for pending handoffs
ls -lh .claude/handoffs/
```

**Questions to answer:**
- Is Web's specification complete?
- Are there pending handoffs for you?
- What branch should you work on?

---

### Step 2: Create Branch (if needed)

**Branch naming:** `claude/cli-perplex-transformer-{session-id}`

```bash
# Create feature branch
git checkout -b claude/cli-perplex-transformer-011CV35RoubgSRMHNVuYa7Si

# Or use session ID from your environment
```

**Why `claude/cli-*` pattern?**
- GitHub Actions detects CLI agent from branch name
- Workspace validation workflow enforces CLI boundaries
- Auto-merge workflow recognizes CLI branches

---

### Step 3: Review Specification (when available)

**File:** `specs/001-perplex-transformer/spec.md`

**What to look for:**
- What is perplex-transformer? (purpose)
- Why do we need it? (motivation)
- What does success look like? (acceptance criteria)
- What are the requirements? (functional and non-functional)
- What constraints exist? (technical, user, system)

**If specification doesn't exist yet:**
- Check with user: Should you wait for Web to create it?
- Or: Should you create it yourself (taking on Web's role for this feature)?

**Decision point:** Clarify with user which approach to take.

---

### Step 4: Start Work on Plan

```bash
# Initialize work on plan.md
bash tools/agent-start-work.sh \
  --artifact specs/001-perplex-transformer/plan.md \
  --type plan
```

**What this validates:**
- You (CLI) can create plan.md ✅
- Artifact type matches your role
- Suggests next steps

**Then create plan using Spec Kit:**
```bash
# Execute plan creation
/speckit.plan
```

**What plan.md should contain:**
- Technical approach (architecture, design patterns)
- Dependencies and integration points
- Data models and interfaces
- Error handling strategy
- Testing approach
- Migration path (if needed)
- Risk mitigation

**Reference:** Specification's requirements and success criteria

---

### Step 5: Handoff Plan for Validation

```bash
# Create handoff marker
bash tools/agent-handoff.sh \
  --to web \
  --artifact specs/001-perplex-transformer/plan.md
```

**What happens:**
- Handoff marker created in `.claude/handoffs/`
- Commit message template generated
- Next action specified: "Web validates plan.md aligns with spec.md"

**Commit your work:**
```bash
git add specs/001-perplex-transformer/plan.md .claude/handoffs/
git commit --no-gpg-sign -m "Complete perplex-transformer technical plan → Web for validation

Technical plan complete:
- Architecture: [Brief description]
- Dependencies: [Key dependencies]
- Approach: [Technical approach]

Next: Web validates plan.md aligns with spec.md

Executed by: Claude Code CLI
Phase: Discovery
"
git push -u origin claude/cli-perplex-transformer-011CV35RoubgSRMHNVuYa7Si
```

**GitHub Actions will:**
- Validate workspace boundaries (plan.md is CLI-owned ✅)
- Run tests
- Create PR automatically (auto-create-pr workflow)
- Potentially auto-merge if validation passes

**Then:** Wait for Web to validate plan before proceeding to tasks.

---

### Step 6: After Validation - Create Tasks

**Trigger:** Web hands back validated plan with `--validated` flag

**Check for handoff:**
```bash
ls -lh .claude/handoffs/
# Look for plan_validated handoff marker
```

**Start work on tasks:**
```bash
bash tools/agent-start-work.sh \
  --artifact specs/001-perplex-transformer/tasks.md \
  --type tasks
```

**Create tasks using Spec Kit:**
```bash
/speckit.tasks
```

**What tasks.md should contain:**
- Atomic, executable tasks (each completable in one focused session)
- Dependency ordering (what must happen first)
- Validation criteria per task
- Estimated complexity
- File/component mapping

**Commit tasks:**
```bash
git add specs/001-perplex-transformer/tasks.md
git commit --no-gpg-sign -m "Create perplex-transformer atomic task decomposition

Tasks decomposed:
- [Number] atomic tasks defined
- Dependencies mapped
- Ready for implementation execution

Executed by: Claude Code CLI
Phase: Discovery → Implementation
"
git push
```

---

### Step 7: Execute Implementation

**Start implementation:**
```bash
bash tools/agent-start-work.sh \
  --artifact src/ \
  --type implementation
```

**Execute using Spec Kit:**
```bash
/speckit.implement
```

**What this does:**
- Reads tasks.md
- Executes tasks in dependency order
- Validates completion criteria
- Updates task status
- Commits incrementally

**Implementation guidelines:**
- Follow atomic task decomposition
- Commit after each completed task (or logical group)
- Validate against specification's success criteria
- Write tests as you go (if testing infrastructure exists)
- Document complex logic

**When complete, handoff to Web:**
```bash
bash tools/agent-handoff.sh \
  --to web \
  --artifact src/
```

---

## Validation Mechanisms

### Pre-Commit Hook

**What it does:** BLOCKS commits that violate workspace boundaries

**Example - This will FAIL:**
```bash
# You try to modify Web-owned file
git add decisions/2025-11-13-some-decision.md
git commit -m "Update ADR"

# Pre-commit hook BLOCKS with:
# ❌ Workspace Boundary Violations Detected
# ❌ decisions/2025-11-13-some-decision.md
```

**Example - This will SUCCEED:**
```bash
# You modify CLI-owned files
git add specs/001-perplex-transformer/plan.md
git add src/transformer.py
git commit -m "Add transformer implementation"

# Pre-commit hook validates:
# ✅ All files respect workspace boundaries
```

**Emergency override (use sparingly):**
```bash
# Document reason in commit message
git commit -m "[EMERGENCY] Urgent fix needed because..."
```

**See:** Pre-commit hook will detect `[EMERGENCY]` prefix and allow (but warn)

---

### GitHub Actions Validation

**Workflow:** `.github/workflows/workspace-validation.yml`

**Triggers:** On every push to `claude/cli-*` branches, on PR open/sync

**What it does:**
1. Detects agent from branch name (`claude/cli-*` = CLI)
2. Gets changed files in PR/push
3. Validates each file against workspace boundaries
4. Comments on PR with violations or success
5. Sets check status (pass/fail)

**PR comment example (success):**
```
✅ Workspace Validation Passed

Agent: Claude Code CLI (cli-claude-executor-001)
Files checked: 12
Status: All files respect workspace boundaries

---

Workspace coordination enforces proper agent boundaries. Great work!
```

**PR comment example (failure):**
```
⚠️ Workspace Boundary Violations

Agent: Claude Code CLI (cli-claude-executor-001)
Branch: claude/cli-perplex-transformer-...
Violations: 2

Files Violating Workspace Boundaries:
- decisions/2025-11-13-transformer-architecture.md
- docs/TRANSFORMER_DESIGN.md

[Resolution options and workspace rules included]
```

**If validation fails:**
- Remove violating files from PR
- Or use emergency override with documented reason
- Or update workspace manifest if boundaries are incorrect

---

## Agent Registry v2.0

**File:** `.claude/agent-registry.json`

**Your entry:**
```json
{
  "agent_id": "cli-claude-executor-001",
  "display_name": "Claude Code CLI",
  "status": "active",
  "environment": "local-windows",
  "role": "executor-validator",
  "workspace": {
    "current_work_branch": "claude/cli-perplex-transformer-...",
    "active_specifications": ["specs/001-perplex-transformer"],
    "workspace_state": "planning",
    "current_work": "specs/001-perplex-transformer/plan.md",
    "next_handoff": "web-claude-designer-001",
    "pending_handoffs": []
  }
}
```

**Update when:**
- Starting new work (change workspace_state, current_work)
- Creating handoffs (update next_handoff)
- Receiving handoffs (acknowledge pending_handoffs)
- Switching branches (update current_work_branch)

**Workspace states:**
- `idle` - No active work
- `planning` - Creating plan.md or tasks.md
- `implementing` - Executing implementation
- `validating` - Running tests, checking success criteria
- `handoff_pending` - Waiting for Web validation

---

## Troubleshooting

### "Pre-commit hook blocked my commit"

**Why:** You're trying to modify files outside your ownership

**Solution:**
1. Check file ownership: `bash tools/validate-workspace-boundaries.sh --file <path>`
2. If file is CLI-owned: Something else wrong (check hook output)
3. If file is Web-owned: Remove from commit or use emergency override
4. If file should be CLI-owned: Update `.claude/workspace-coordination.yml` in separate PR

### "GitHub Actions validation failed"

**Why:** PR contains files violating workspace boundaries

**Solution:**
1. Check PR comment for violated files
2. Remove violating files: `git restore --staged <file>`
3. Commit: `git commit --amend`
4. Force push: `git push --force`
5. Or: Update workspace manifest if boundaries incorrect

### "Agent script says artifact type invalid"

**Why:** You're trying to work on artifact not owned by CLI

**Example:**
```bash
bash tools/agent-start-work.sh --artifact specs/001/spec.md --type specification
# Error: Invalid artifact type for agent
#   Web can work on: specification
#   CLI can work on: plan, tasks, implementation
```

**Solution:** Work on correct artifact type (plan.md, tasks.md, src/)

### "Can't find handoff marker"

**Why:** Handoff not created yet, or looking in wrong place

**Solution:**
```bash
# Check handoffs directory
ls -lh .claude/handoffs/

# Check agent registry for pending_handoffs
cat .claude/agent-registry.json | grep -A 5 "pending_handoffs"
```

### "Spec Kit command blocked"

**Why:** Command access restricted by role

**Solution:**
- Use CLI commands only: `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`
- Don't use Web commands: `/speckit.constitution`, `/speckit.specify`, `/speckit.clarify`

---

## Success Criteria

**You'll know you're successful when:**

1. ✅ Plan.md created and aligns with specification
2. ✅ Web validates plan without major concerns
3. ✅ Tasks.md breaks down work into atomic, executable steps
4. ✅ Implementation follows task decomposition
5. ✅ All commits respect workspace boundaries (pre-commit hook passes)
6. ✅ All PRs pass GitHub Actions validation
7. ✅ Handoff markers created at appropriate transitions
8. ✅ Agent registry reflects current work state
9. ✅ Specification success criteria met
10. ✅ No workspace boundary violations

---

## Quick Start Checklist

Before beginning work:

- [ ] Read `.claude/identity-cli.json` (anchor your persona)
- [ ] Run `bash tools/agent-check-registry.sh` (check coordination state)
- [ ] Read `docs/AGENT_WORKSPACE_COORDINATION.md` (understand boundaries)
- [ ] Review `specs/001-perplex-transformer/spec.md` (if exists - understand requirements)
- [ ] Create branch `claude/cli-perplex-transformer-{session-id}`
- [ ] Run `bash tools/agent-start-work.sh` (initialize work formally)

During work:

- [ ] Use Spec Kit commands (`/speckit.plan`, `/speckit.tasks`, `/speckit.implement`)
- [ ] Respect workspace boundaries (pre-commit hook will enforce)
- [ ] Update agent registry when changing work state
- [ ] Create handoff markers at transitions
- [ ] Commit incrementally with descriptive messages
- [ ] Push to remote regularly

After completion:

- [ ] Run `bash tools/agent-handoff.sh` (create formal handoff)
- [ ] Validate all files CLI-owned (no boundary violations)
- [ ] Ensure GitHub Actions passes
- [ ] Update session log
- [ ] Run `bash tools/session-end.sh` (if ending session)

---

## Questions?

**About workspace coordination:**
- Read: `docs/AGENT_WORKSPACE_COORDINATION.md`
- Check: `.claude/workspace-coordination.yml`
- Review: ADR-011 (`decisions/2025-11-13-agent-workspace-coordination.md`)

**About Spec Kit:**
- Use: `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`
- Reference: Spec Kit documentation (if available)

**About perplex-transformer:**
- Read: `specs/001-perplex-transformer/spec.md` (when Web creates it)
- Clarify: Ask user if specification unclear

**About enforcement:**
- Test: `bash tools/validate-workspace-boundaries.sh --file <path>`
- Scripts: `tools/agent-start-work.sh`, `tools/agent-handoff.sh`, `tools/agent-check-registry.sh`

---

## Summary

**Your mission:** Create technical plan, atomic tasks, and implementation for perplex-transformer

**Your tools:**
- Workspace coordination system (enforced boundaries)
- Agent scripts (start-work, handoff, check-registry)
- Spec Kit commands (plan, tasks, implement)
- Pre-commit hook (local validation)
- GitHub Actions (remote validation)

**Your workflow:**
1. Review specification
2. Create plan.md → handoff to Web
3. After validation, create tasks.md
4. Execute implementation
5. Handoff to Web for final validation

**Your boundaries:**
- Own: src/, tests/, specs/*/plan.md, specs/*/tasks.md
- Read-only: decisions/, docs/, specs/*/spec.md
- Shared: sessions/, checkpoints/, agent registry

**Your commitment:**
- Respect enforcement (don't fight pre-commit hook)
- Use agent scripts (formalize coordination)
- Update agent registry (maintain visibility)
- Create handoff markers (document transitions)
- Follow Spec Kit workflow (structured development)

---

**Prepared by:** Claude Code Web
**For:** Claude Code CLI
**Date:** 2025-11-13
**Status:** Ready for CLI execution

**All enforcement mechanisms operational. You're cleared for takeoff.** 🚀

# Phase 5: Documentation Update

**Agent:** CLI-Director (CDIR)
**Prerequisites:** Phase 4 complete (automation and hooks updated)
**Execution Environment:** PowerShell Terminal Window 1 + Text Editor
**OS:** Windows
**Project Path:** `C:\Development\perplex`
**Branch:** `claude/design-three-agent-config` (continue)
**Duration Estimate:** 60-90 minutes

---

## IMPORTANT: Environment Setup

**You are running on Windows with PowerShell.**

**File Editing:** Documentation files (markdown) should be edited in a text editor (VS Code, Notepad++, etc.). Use PowerShell only for file operations and git commands.

**PowerShell Commands:** Used for file operations (copy, rename, list) and git commands.

---

## Mission

Update all documentation to reflect three-agent architecture (CDIR, CEXE, Web).

---

## Files to Update

### Core Documents
1. `CLAUDE.md` - Session protocols and coordination
2. `FOUNDATION.md` - Team structure and methodologies
3. `README.md` - Project overview and agent roster
4. `CONTRIBUTING.md` - Collaboration guide

### Identity Documentation
5. `docs\IDENTITY_SETUP_PROMPT_CDIR.md` - NEW (create for CDIR)
6. `docs\IDENTITY_SETUP_PROMPT_CEXE.md` - Rename and update from CLI
7. `docs\SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md` - Update coordination
8. `docs\AGENT_WORKSPACE_COORDINATION.md` - Update workspace

---

## Step 1: Verify Phase 4 Complete

```powershell
cat .claude\migration-phase-4-complete.txt
git log --oneline -1 | Select-String "Phase 4"
```

Should show Phase 4 marker and recent commit.

---

## Step 2: Update `CLAUDE.md`

**Open `CLAUDE.md` in your text editor**

**Update the following sections:**

### A. Session Start Protocol (Step 0) - Identity Anchoring

**Find the section that says "0. **Anchor your identity:**" and replace with:**

```markdown
0. **Anchor your identity:**
   ```bash
   # If you're CDIR (PowerShell Terminal 1)
   cat .claude\identity-cli-director.json

   # If you're CEXE (PowerShell Terminal 2)
   cat .claude\identity-cli-executor.json

   # If you're Web (browser, emergency only)
   cat .claude\identity-web.json

   # Check all active agents
   cat .claude\agent-registry.json
   ```

   **Why this matters:** Know WHO you are before loading WHAT you're working on. Your identity file defines your role (designer vs executor), capabilities, autonomy level, and coordination protocols. Without identity anchoring, you risk confusing your actions with other agents or losing strategic awareness.

   **Quick self-check:**
   - What's your agent_id? (CDIR: cli-claude-director-001, CEXE: cli-claude-executor-001, Web: web-claude-designer-001)
   - What's your short_name? (CDIR, CEXE, or Web)
   - What's your role? (designer-researcher, executor-validator, or standby-emergency)
   - What's your terminal? (PowerShell-Terminal-1, PowerShell-Terminal-2, or browser)
   - What's your communication prefix? (e.g., `[From: CDIR]`)
   - Who else is active? (check agent registry)
```

### B. Multi-Agent Coordination Section

**Find the "Multi-Agent Coordination" section and replace with:**

```markdown
## 🤝 Multi-Agent Coordination

**Project Perplex uses three AI agents with distinct roles:**

### Active Agents

**CDIR (CLI-Director) - Primary Designer:**
- **Environment:** PowerShell Terminal Window 1 (local Windows)
- **Agent ID:** cli-claude-director-001
- **Role:** Designer-researcher
- **Primary Function:** Create specifications, ADRs, documentation, requirements
- **Spec Kit Commands:** `/speckit.constitution`, `/speckit.specify`, `/speckit.clarify`, `/speckit.analyze`, `/speckit.checklist`
- **Branch Pattern:** `claude/design-*`
- **Workspace Ownership:** `decisions/`, `docs/`, `requirements/`, `ideas/`, `specs/*/spec.md`

**CEXE (CLI-Executor) - Primary Executor:**
- **Environment:** PowerShell Terminal Window 2 (local Windows)
- **Agent ID:** cli-claude-executor-001
- **Role:** Executor-validator
- **Primary Function:** Implement features, write tests, validate implementations
- **Spec Kit Commands:** `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`, `/speckit.analyze`, `/speckit.checklist`
- **Branch Pattern:** `claude/impl-*`
- **Workspace Ownership:** `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`, `specs/*/implementation/`

**Web (Standby) - Emergency Backup:**
- **Environment:** Browser-based (inactive unless emergency)
- **Agent ID:** web-claude-designer-001
- **Role:** Standby-emergency
- **Status:** Inactive (standby)
- **Activation:** Manual, only if CDIR unavailable >24 hours
- **Branch Pattern:** `claude/web-emergency-*`

### Identity Configuration

Check `.claude\agent-registry.json` for current agent status.

**Your identity file defines:**
- agent_id and display_name (who you are)
- role and primary_function (what you do)
- capabilities and constraints (how you operate)
- coordination protocols (how you collaborate)

**At session start:** Read your identity file to anchor your persona and role.

### Communication Protocol

**Envelope Format:** All agent communications use prefix to prevent confusion.

**Usage:**
```
[From: CDIR] Designed feature specification. Ready for CEXE implementation.
[From: CEXE] Implementation complete. Validation requested from CDIR.
[From: Web] Emergency: Continuing CDIR's work during unavailability.
```

**Why this matters:**
- User immediately knows which agent is speaking
- No confusion between CDIR's design and CEXE's execution
- Clear handoff points in multi-agent workflows
- Maintains role clarity

**Your prefix:** Check your identity file's `coordination.message_prefix` field.

### Coordination Conventions

**Role Boundaries:**
- **CDIR (Designer):** Architecture, specifications, ADRs, documentation, requirements
- **CEXE (Executor):** Implementation, testing, validation, technical decomposition
- **Web (Standby):** Emergency backup, research support only

**Handoff Pattern (CDIR ↔ CEXE):**
1. CDIR creates specification (`spec.md`)
2. CDIR updates agent registry: spec ready for CEXE
3. CEXE reads spec, creates plan (`plan.md`)
4. CEXE updates agent registry: plan ready for CDIR validation
5. CDIR reviews plan, validates against spec
6. CDIR updates agent registry: plan approved
7. CEXE creates tasks (`tasks.md`), implements
8. CEXE updates agent registry: implementation ready for validation
9. CDIR validates implementation against spec success criteria

**Autonomy:** Both CDIR and CEXE operate with high autonomy. Make technical decisions independently, escalate only strategic questions.

**Git Coordination:**
- CDIR: Works on `claude/design-*` branches
- CEXE: Works on `claude/impl-*` branches
- Coordinate merge strategy via agent registry notes
```

### C. Spec-Driven Development Section

**Find the "Spec-Driven Development" section and replace with:**

```markdown
**Spec-Driven Development (CDIR and CEXE only):**

**IMPORTANT:** CDIR and CEXE have different Spec Kit command access based on their roles.

### CDIR Commands (PowerShell Terminal 1)

```bash
# Establish project principles (one-time, or update when needed)
/speckit.constitution

# Create feature specification (what to build, why, success criteria)
/speckit.specify "Feature description"

# Optional: Clarify ambiguities (max 3 targeted questions)
/speckit.clarify

# Validate cross-artifact consistency
/speckit.analyze

# Generate quality validation checklist
/speckit.checklist
```

**CDIR Workflow:**
1. Define project constitution (principles, standards)
2. Create feature specification (what, why, success criteria)
3. Clarify ambiguities with user if needed
4. Validate specification completeness
5. Hand off to CEXE via agent registry

### CEXE Commands (PowerShell Terminal 2)

```bash
# Generate technical plan from CDIR's specification
/speckit.plan

# Break down plan into atomic tasks
/speckit.tasks

# Execute implementation following tasks
/speckit.implement

# Validate cross-artifact consistency
/speckit.analyze

# Generate quality validation checklist
/speckit.checklist
```

**CEXE Workflow:**
1. Read CDIR's specification
2. Create technical plan (how to build it)
3. Get CDIR validation on plan
4. Decompose plan into atomic tasks
5. Execute implementation
6. Hand back to CDIR for validation

### Full Three-Agent Workflow

**Phase 0: Specification (CDIR)**
- CDIR creates `spec.md` (what, why, success criteria)
- CDIR hands off to CEXE

**Phase 1: Planning (CEXE)**
- CEXE reads spec
- CEXE creates `plan.md` (how to build it)
- CEXE hands back to CDIR for validation

**Phase 2: Plan Validation (CDIR)**
- CDIR reviews plan against spec
- CDIR validates or requests changes
- CDIR approves → hands back to CEXE

**Phase 3: Execution (CEXE)**
- CEXE creates `tasks.md` (atomic steps)
- CEXE implements following tasks
- CEXE runs tests
- CEXE hands back to CDIR for validation

**Phase 4: Implementation Validation (CDIR)**
- CDIR validates against spec success criteria
- CDIR marks complete or requests changes

**Coordination:** Via agent registry (`.claude\agent-registry.json`) and optional handoff markers (`.claude\handoffs\*.json`)

**When to use Spec-Driven Development:**
- Phase 1 implementations (perplex-transformer, perplex-reader)
- New feature development requiring formal specifications
- Complex work needing structured decomposition
- When building something Web has designed/specified

**When NOT to use Spec-Driven Development:**
- Discovery phase exploration
- Bug fixes or minor changes
- Infrastructure setup
- Documentation work
```

**Save the file.**

---

## Step 3: Update `FOUNDATION.md`

**Open `FOUNDATION.md` in your text editor**

**Find the section about "Project = Repository" or "Core Identity" and add after it:**

```markdown
## AI Development Team

**Three-Agent Architecture:**

- **CDIR (CLI-Director):** Primary designer, local Windows environment (PowerShell Terminal 1)
- **CEXE (CLI-Executor):** Primary executor, local Windows environment (PowerShell Terminal 2)
- **Web:** Standby emergency backup, browser-based (inactive unless needed)

**Coordination:** Clear workspace boundaries, handoff procedures, envelope communication.
```

**Find the "Proper Product Management & Development Methodologies" section and update:**

**In the "Implementation Level - Spec-Driven Development" subsection, add:**

```markdown
**Agent Responsibilities:**

**CDIR executes:**
- `/speckit.constitution` - Establish project principles
- `/speckit.specify` - Create feature specifications
- `/speckit.clarify` - Clarify ambiguities
- `/speckit.analyze` - Cross-artifact validation
- `/speckit.checklist` - Quality validation

**CEXE executes:**
- `/speckit.plan` - Generate technical plans from specs
- `/speckit.tasks` - Decompose into atomic tasks
- `/speckit.implement` - Execute implementation
- `/speckit.analyze` - Cross-artifact validation
- `/speckit.checklist` - Quality validation

**Coordination Pattern:**
1. CDIR creates spec → handoff to CEXE
2. CEXE creates plan → handoff to CDIR for validation
3. CDIR validates plan → handoff back to CEXE
4. CEXE implements → handoff to CDIR for final validation

**Handoff mechanism:** Agent registry (`.claude\agent-registry.json`) + optional handoff markers
```

**Save the file.**

---

## Step 4: Update `README.md`

**Open `README.md` in your text editor**

**Find the team or "About" section and add/replace with:**

```markdown
## AI-First Development Team

**Three-Agent Architecture:**

### Primary Designer: Claude Code CLI-Director (CDIR)
- **Environment:** PowerShell Terminal Window 1, Local Windows
- **Agent ID:** cli-claude-director-001
- **Responsibilities:**
  - Create specifications, ADRs, documentation, requirements
  - Define what to build and success criteria
  - Validate technical plans and implementations
  - Strategic planning and research
- **Branch Pattern:** `claude/design-*`
- **Workspace:** `decisions/`, `docs/`, `requirements/`, `ideas/`, `specs/*/spec.md`

### Primary Executor: Claude Code CLI-Executor (CEXE)
- **Environment:** PowerShell Terminal Window 2, Local Windows
- **Agent ID:** cli-claude-executor-001
- **Responsibilities:**
  - Implement features from CDIR specifications
  - Write tests and validate implementations
  - Create technical plans and task decomposition
  - Execute Spec Kit implementation workflow
- **Branch Pattern:** `claude/impl-*`
- **Workspace:** `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`

### Standby Support: Claude Code Web
- **Environment:** Browser-based, limited access
- **Agent ID:** web-claude-designer-001
- **Status:** Inactive (standby)
- **Activation:** Manual, only if CDIR unavailable >24 hours
- **Responsibilities:**
  - Emergency backup designer
  - Research support when requested
  - Standby only, not active development

**Coordination:** CDIR and CEXE collaborate via agent registry and workspace boundaries. Web remains inactive unless emergency.

**Human Partner Role:** Set strategic direction, validate alignment, approve major decisions, provide domain context.
```

**Save the file.**

---

## Step 5: Update `CONTRIBUTING.md`

**Open `CONTRIBUTING.md` in your text editor**

**Add a new section: "Working with Multiple AI Agents"**

```markdown
## Working with Multiple AI Agents

Project Perplex uses three AI agents with distinct roles and responsibilities.

### Agent Roster

**CDIR (CLI-Director) - Designer:**
- Creates specifications, ADRs, documentation
- Defines what to build and why
- Validates plans and implementations
- **Terminal:** PowerShell Window 1
- **Commands:** `/speckit.specify`, `/speckit.constitution`, `/speckit.clarify`

**CEXE (CLI-Executor) - Executor:**
- Implements features from specifications
- Creates technical plans and tasks
- Writes tests and validates code
- **Terminal:** PowerShell Window 2
- **Commands:** `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`

**Web - Standby:**
- Emergency backup only
- Research support when requested
- Inactive unless CDIR unavailable
- **Environment:** Browser-based

### When to Use Which Agent

**Use CDIR when you need:**
- New feature specifications
- Architecture decisions (ADRs)
- Documentation updates
- Requirements analysis
- Strategic planning

**Use CEXE when you need:**
- Feature implementation
- Technical planning
- Test writing
- Bug fixes
- Code validation

**Use Web when:**
- CDIR unavailable for >24 hours (emergency)
- Research support explicitly requested
- NOT for routine development

### Coordination Between CDIR and CEXE

**Handoff Workflow:**
1. **Specification Phase (CDIR):** CDIR creates `specs/NNN-feature/spec.md`
2. **Planning Phase (CEXE):** CEXE creates `specs/NNN-feature/plan.md`
3. **Plan Validation (CDIR):** CDIR reviews plan, approves or requests changes
4. **Implementation Phase (CEXE):** CEXE creates tasks and implements
5. **Final Validation (CDIR):** CDIR validates against spec success criteria

**Communication:**
- Both agents use envelope format: `[From: CDIR]` or `[From: CEXE]`
- Updates go to agent registry: `.claude\agent-registry.json`
- Optional handoff markers: `.claude\handoffs\*.json`

**Branch Strategy:**
- CDIR: `claude/design-*` branches
- CEXE: `claude/impl-*` branches
- Web: `claude/web-emergency-*` branches (emergency only)

**Workspace Boundaries:**
- CDIR cannot directly modify: `src/`, `tests/`, implementation artifacts
- CEXE cannot directly modify: `decisions/`, `requirements/`, `specs/*/spec.md`
- Enforced by pre-commit hooks (can override with `--no-verify` if needed)

### Emergency Web Activation

**Trigger:** CDIR unavailable for >24 hours

**Activation Process:**
1. User manually activates Web in browser
2. Web reads agent registry and latest checkpoint
3. Web updates registry status to "active"
4. Web creates branch: `claude/web-emergency-{reason}`
5. Web assumes CDIR responsibilities temporarily

**Handback Process:**
1. CDIR announces return
2. CDIR reads agent registry and reviews Web's work
3. CDIR integrates or requests changes
4. Web updates status to "standby"
5. Web returns to inactive state

### Best Practices

**For CDIR:**
- Create clear, complete specifications
- Define success criteria explicitly
- Validate CEXE's plans before implementation
- Review implementations against spec

**For CEXE:**
- Read specifications thoroughly
- Ask clarifying questions if needed
- Create technical plans for CDIR validation
- Implement according to approved plans

**For Human Partner:**
- Set strategic direction for CDIR
- Approve major architectural decisions
- Coordinate between agents when needed
- Activate Web only in emergency
```

**Save the file.**

---

## Step 6: Create `docs\IDENTITY_SETUP_PROMPT_CDIR.md`

**Create new file:** `docs\IDENTITY_SETUP_PROMPT_CDIR.md`

**Content:** Use Phase 1 prompt as base, create complete identity setup guide for CDIR.

**Key sections:**
- Identity file structure for CDIR
- Agent registry entry
- Workspace boundaries
- Spec Kit command access
- Session protocols
- Coordination with CEXE

**Note:** This should be a comprehensive guide similar to Phase 1 prompt content.

**Save the file.**

---

## Step 7: Rename and Update CEXE Identity Doc

```powershell
mv docs\IDENTITY_SETUP_PROMPT_CLI.md docs\IDENTITY_SETUP_PROMPT_CEXE.md
ls docs\IDENTITY_SETUP_PROMPT_CEXE.md
```

**Open `docs\IDENTITY_SETUP_PROMPT_CEXE.md` in your text editor**

**Update for CEXE:**
- Change all references from "CLI" to "CEXE"
- Update agent_id to `cli-claude-executor-001`
- Update short_name to `CEXE`
- Update role to `executor-validator`
- Update Spec Kit commands to executor set (plan, tasks, implement)
- Update workspace ownership to implementation artifacts
- Add coordination section with CDIR
- Update branch pattern to `claude/impl-*`

**Save the file.**

---

## Step 8: Update Multi-Agent Coordination Docs

### A. Update `docs\SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md`

**Open file in text editor**

**Key updates:**
- Add CDIR as primary designer (replacing Web)
- Update coordination patterns: CDIR ↔ CEXE (not Web ↔ CLI)
- Document Web's transition to standby
- Update three-environment analysis to two active environments (CDIR + CEXE)
- Add Windows PowerShell environment details

**Save the file.**

### B. Update `docs\AGENT_WORKSPACE_COORDINATION.md`

**Open file in text editor**

**Key updates:**
- Update ownership tables:
  - CDIR owns: `decisions/`, `docs/`, `requirements/`, `ideas/`, `specs/*/spec.md`
  - CEXE owns: `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`, `specs/*/implementation/`
  - Web: standby, emergency-only access
- Update handoff procedures for three-agent workflow
- Add emergency Web activation procedures
- Update enforcement sections (pre-commit/pre-push hooks)

**Save the file.**

---

## Step 9: Commit Documentation Changes

```powershell
git add CLAUDE.md
git add FOUNDATION.md
git add README.md
git add CONTRIBUTING.md
git add docs\IDENTITY_SETUP_PROMPT_CDIR.md
git add docs\IDENTITY_SETUP_PROMPT_CEXE.md
git add docs\SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md
git add docs\AGENT_WORKSPACE_COORDINATION.md
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CDIR] Phase 5: Documentation for three-agent architecture

- Updated CLAUDE.md (session protocols, three agents, Spec Kit workflows)
- Updated FOUNDATION.md (team structure, agent responsibilities)
- Updated README.md (agent roster, roles, coordination)
- Updated CONTRIBUTING.md (multi-agent collaboration guide)
- Created IDENTITY_SETUP_PROMPT_CDIR.md (designer identity setup)
- Renamed/updated IDENTITY_SETUP_PROMPT_CEXE.md (executor identity setup)
- Updated SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md (CDIR ↔ CEXE)
- Updated AGENT_WORKSPACE_COORDINATION.md (workspace boundaries)

All documentation now reflects CDIR (designer) + CEXE (executor) + Web (standby) architecture.

Migration Phase: 5 of 9
Next: Phase 6 - GitHub Workflows Update

Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/design-three-agent-config
Environment: Windows PowerShell at C:\Development\perplex
"
```

---

## Step 10: Create Phase 5 Marker

```powershell
"Phase 5 complete: $(Get-Date)" | Set-Content -Path .claude\migration-phase-5-complete.txt
cat .claude\migration-phase-5-complete.txt
```

---

## Validation Checklist

- [ ] CLAUDE.md reflects three agents in session protocol
- [ ] CLAUDE.md shows Spec Kit command distribution (CDIR vs CEXE)
- [ ] FOUNDATION.md shows agent team structure
- [ ] README.md lists three agents with roles and responsibilities
- [ ] CONTRIBUTING.md explains multi-agent coordination workflow
- [ ] CDIR identity setup prompt exists and complete
- [ ] CEXE identity setup prompt renamed and updated
- [ ] Multi-agent coordination docs updated (CDIR ↔ CEXE)
- [ ] Workspace coordination docs updated (three-agent boundaries)
- [ ] All documentation consistent with three-agent architecture
- [ ] Changes committed to git
- [ ] Phase 5 marker created

---

## If Validation Fails

**Problem: Markdown syntax errors**
- Open in VS Code (has markdown preview)
- Check for broken links, malformed lists
- Preview before committing

**Problem: Git won't stage renamed file**
- Use `git add` for both old and new names
- Or use `git mv` command instead of PowerShell `mv`
- Check `git status` to see rename status

**Problem: Documentation inconsistencies**
- Review agent registry for correct agent IDs
- Verify workspace boundaries match `.claude\workspace-coordination.yml`
- Check Spec Kit command distributions against identity files

---

## Announce Completion

```
[From: CDIR] Phase 5 COMPLETE. Documentation updated for three-agent architecture.

Core documents updated:
- CLAUDE.md: Session protocols for CDIR/CEXE/Web
- FOUNDATION.md: Team structure and Spec Kit workflow distribution
- README.md: Agent roster with roles and responsibilities
- CONTRIBUTING.md: Multi-agent collaboration guide with workflows

Identity documentation:
- CDIR setup guide created (docs\IDENTITY_SETUP_PROMPT_CDIR.md)
- CEXE setup guide updated (docs\IDENTITY_SETUP_PROMPT_CEXE.md)
- Coordination patterns documented (CDIR ↔ CEXE handoffs)
- Workspace boundaries clarified

All documentation now consistent with three-agent architecture.

Validation: PASSED (markdown valid, git committed)

Environment: Windows PowerShell at C:\Development\perplex
Ready for Phase 6: GitHub Workflows Update
```

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001
**Environment:** Windows PowerShell
**Project Path:** C:\Development\perplex
**Phase:** 5 of 9
**Next:** Phase 6 - GitHub Workflows Update

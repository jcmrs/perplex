# Three-Agent Migration Architecture

**Date:** 2025-11-13
**Migration Type:** Architectural - Web (primary) → CDIR (primary) + Web (standby)
**Complexity:** HIGH - Complete project environment reconfiguration
**Status:** PLANNING
**Prepared by:** web-claude-designer-001 (final act as primary designer)

---

## Executive Summary

**Mission:** Replace Claude Code Web as primary designer-researcher with local Claude Code CLI-Director (CDIR), retaining Web as emergency standby. Complete architectural migration affecting 40+ files across 10 subsystems.

**Why This Migration:**
- **Environment limitations:** Web is sandboxed, limited git, no MCP, no system access
- **Coordination friction:** Human mediation between Web (browser) and CLI (local)
- **Capability gaps:** Web can't run Spec Kit commands, validation scripts, automation tools
- **Persistence needs:** Designer needs session state, MCP memory, local file access

**Target Architecture:**
```
BEFORE (Two Agents):
Web (Browser) - Primary Designer → CLI (Local) - Primary Executor
↓ Human mediates copy/paste prompts

AFTER (Three Agents):
Web (Browser) - Standby Emergency
CDIR (Local Terminal 1) - Primary Designer → CEXE (Local Terminal 2) - Primary Executor
↓ Shared filesystem, agent registry coordination
```

**Risk Level:** HIGH
- 40+ files modified
- 10 subsystems affected
- Active work in progress
- No half-migrated state possible (atomicity required)

**Mitigation:** Chained prompts with validation gates, rollback plan, test environment first.

---

## Foundation Imperatives Validation

### 1. Holistic System Thinking ✓
- **Applied:** Comprehensive inventory of all affected systems
- **Evidence:** This document catalogs 10 subsystems, 40+ files, integration points
- **Ripple effects:** Git workflows, GitHub automation, Spec Kit, session protocols, documentation

### 2. AI-First ✓
- **Applied:** Machine-readable configuration drives agent behavior
- **Evidence:** Identity files, workspace manifest, agent registry are source of truth
- **Autonomy:** Agents operate from config, not manual instructions

### 3. Configurability ✓
- **Applied:** All agent roles/boundaries defined in config files
- **Evidence:** `.claude/*.json`, `.claude/*.yml`, `config/*.yml` drive behavior
- **Flexibility:** Changing config changes agent behavior (no code changes)

### 4. Modularity ✓
- **Applied:** Agent identities are modular, swappable components
- **Evidence:** This migration proves modularity - replacing Web with CDIR
- **Interfaces:** Clean handoff protocols, workspace boundaries, git conventions

### 5. Extensibility ✓
- **Applied:** System designed to add/replace agents
- **Evidence:** Workspace manifest "future_agents" template, agent registry schema
- **Migration:** Adding CDIR follows existing extension patterns

### 6. Integration ✓
- **Applied:** All systems integrate (git, GitHub, Spec Kit, MCP, tools, workflows)
- **Evidence:** Migration must maintain integration integrity across all systems
- **Validation:** Integration audit ensures no broken coordination

### 7. Automation ✓
- **Applied:** Tools and hooks automate coordination, enforce boundaries
- **Evidence:** Pre-commit hooks, pre-push validation, agent-start-work scripts
- **Migration:** New automation for three-agent coordination patterns

**Verdict:** Migration aligns with all 7 Foundation Imperatives. Proceeding maintains architectural integrity.

---

## Complete System Inventory

### Subsystem 1: Identity & Coordination Files (`.claude/`)

**Files to Modify:**
1. `.claude/identity-web.json` - Update role to "standby-emergency"
2. `.claude/identity-cli-executor.json` - Rename from `identity-cli.json`, update agent_id to "cli-claude-executor-001"
3. `.claude/agent-registry.json` - Three agents, coordination patterns, workspace states

**Files to Create:**
4. `.claude/identity-cli-director.json` - NEW: Primary designer identity

**Changes Required:**
- Web: `role: "standby-emergency"`, `status: "standby"`, reduced capabilities
- CEXE: Rename agent_id, clarify executor-validator focus, update short_name to "CEXE"
- CDIR: New identity, `role: "designer-researcher"`, full capabilities, short_name "CDIR"
- Registry: Three agents, updated coordination protocols, workspace tracking

**Impact:** HIGH - Core identity system, all other systems reference these files

---

### Subsystem 2: Workspace Coordination (`.claude/workspace-coordination.yml`)

**Complete Rewrite Required:** YES

**Changes:**
1. Add `cdir-claude-director-001` agent section
   - Primary ownership: `decisions/`, `docs/`, `requirements/`, `specs/*/spec.md`
   - Shared ownership: `sessions/`, `checkpoints/`, `backlog/`, `.claude/`, `.github/workflows/`
   - Read-only: `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`
   - Branch pattern: `claude/design-*`
   - Decision scope: architecture, research, documentation, design, strategic-planning

2. Update `cli-claude-executor-001` agent section
   - No ownership changes (still owns implementation)
   - Update agent_id reference
   - Branch pattern: `claude/impl-*`

3. Update `web-claude-designer-001` agent section
   - Change to standby role
   - Remove primary ownership (move to CDIR)
   - Read-only for most, write-access only emergency
   - Branch pattern: `claude/web-emergency-*`

4. Update coordination rules
   - Handoff triggers: CDIR → CEXE, CEXE → CDIR
   - Remove Web from normal workflow
   - Add emergency Web activation procedures

5. Update Spec Kit integration
   - CDIR executes: `/speckit.constitution`, `/speckit.specify`, `/speckit.clarify`
   - CEXE executes: `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`
   - Web: None (standby)

**Impact:** CRITICAL - Defines all agent boundaries and coordination

---

### Subsystem 3: Configuration Files (`config/`)

**Files to Modify:**
1. `config/project.yml`
   - Section: `project.team`
   - Update agent roster: CDIR (primary designer), CEXE (primary executor), Web (standby)
   - Update coordination patterns

2. `config/ai-agent.yml`
   - Needs multi-agent version or separate configs?
   - Consider: `config/ai-agent-cdir.yml`, `config/ai-agent-cexe.yml`, `config/ai-agent-web.yml`

**Impact:** MEDIUM - Configuration drives behavior, but not enforcement-critical

---

### Subsystem 4: Foundation & Core Documents

**Files to Modify:**
1. `FOUNDATION.md`
   - Section 4: Product management methodologies (references Web)
   - Team structure references
   - Update agent roster in examples

2. `CLAUDE.md`
   - **CRITICAL:** Session start protocol
   - Step 0: Identity anchoring - three agents
   - Step 5: Active specifications check
   - Spec Kit command reference - CDIR vs CEXE
   - Multi-agent coordination section
   - Session end protocol - three agents

3. `README.md`
   - Project overview section (mentions Web)
   - Team structure
   - How to contribute with agents

4. `CONTRIBUTING.md`
   - Working with AI agents section
   - Coordination patterns

**Impact:** HIGH - Entry points for all users (AI and human), must be accurate

---

### Subsystem 5: Identity & Coordination Documentation (`docs/`)

**Files to Modify:**
1. `docs/IDENTITY_SETUP_PROMPT_CLI.md`
   - Rename to `docs/IDENTITY_SETUP_PROMPT_CEXE.md`
   - Update for executor-specific identity

**Files to Create:**
2. `docs/IDENTITY_SETUP_PROMPT_CDIR.md` - NEW
   - Complete setup guide for CLI-Director
   - Identity configuration
   - Workspace coordination
   - Session protocols
   - Spec Kit integration

**Files to Update:**
3. `docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md`
   - Three-agent coordination patterns
   - Update examples and scenarios

4. `docs/THREE_ENVIRONMENT_COORDINATION.md`
   - Now two environments: Web (standby), Local (CDIR+CEXE)
   - Update coordination patterns

5. `docs/AGENT_WORKSPACE_COORDINATION.md`
   - Three-agent workspace rules
   - Update ownership tables
   - Update handoff procedures

6. `docs/PERPLEXITY_PROMPT_MULTI_AGENT_IDENTITY.md`
   - May need updates if referencing Web as primary

**Impact:** HIGH - Guides agent behavior and onboarding

---

### Subsystem 6: Automation Tools (`tools/`)

**Files to Modify:**
1. `tools/agent-start-work.sh`
   - Recognize agent_id: "cli-claude-director-001" and "cli-claude-executor-001"
   - Read identity files for CDIR and CEXE
   - Update agent registry with three-agent logic
   - Branch patterns: `claude/design-*`, `claude/impl-*`

2. `tools/agent-handoff.sh`
   - Three-agent handoff patterns: CDIR → CEXE, CEXE → CDIR
   - Emergency Web handoff procedures
   - Handoff marker files for three agents

3. `tools/agent-check-registry.sh`
   - Display three agents
   - Parse three-agent workspace states
   - Show CDIR and CEXE coordination

4. `tools/ensure-claude-branch.sh`
   - Recognize CDIR from identity file
   - Suggest `claude/design-*` for CDIR
   - Suggest `claude/impl-*` for CEXE
   - Suggest `claude/web-emergency-*` for Web

5. `tools/session-end.sh`
   - Three-agent session end procedures
   - Update registry for CDIR/CEXE

6. `tools/generate-status.sh`
   - Reflect three-agent activity in CURRENT_STATUS.md

**Impact:** HIGH - Daily operational scripts, must work correctly

---

### Subsystem 7: Git Hooks (`.githooks/`)

**Files to Modify:**
1. `.githooks/pre-commit`
   - Validate workspace boundaries for three agents
   - Read workspace manifest for CDIR/CEXE/Web rules
   - BLOCK commits violating boundaries

2. `.githooks/pre-push`
   - Branch enforcement for three agents
   - CDIR: Must use `claude/design-*`
   - CEXE: Must use `claude/impl-*`
   - Web: Only `claude/web-emergency-*` (rare)

3. `.githooks/README.md`
   - Document three-agent enforcement
   - Examples for CDIR and CEXE workflows

**Impact:** CRITICAL - Enforcement layer, prevents violations

---

### Subsystem 8: GitHub Workflows (`.github/workflows/`)

**Files to Modify:**
1. `.github/workflows/workspace-validation.yml`
   - Validate PRs against three-agent workspace manifest
   - Check file modifications vs agent identity
   - CDIR can modify `decisions/`, `docs/`, etc.
   - CEXE can modify `src/`, `tests/`, etc.
   - Web can only modify in emergency

2. `.github/workflows/auto-create-pr-claude-branches.yml`
   - Recognize branch patterns: `claude/design-*`, `claude/impl-*`, `claude/web-emergency-*`
   - Extract agent identity from branch name
   - Create PR with agent attribution

3. `.github/workflows/auto-merge-claude-branches.yml`
   - Three-agent merge rules
   - Validation per agent type

4. `.github/workflows/checkpoint-automation.yml`
   - Three-agent checkpoint attribution
   - Agent metadata in checkpoints

5. Any other workflows referencing agent identities or roles

**Impact:** MEDIUM - Safety net validation, not primary enforcement

---

### Subsystem 9: Spec Kit Integration (`.claude/commands/`, `.specify/`)

**Files to Check:**
1. `.claude/commands/speckit.constitution.md` - CDIR only
2. `.claude/commands/speckit.specify.md` - CDIR only
3. `.claude/commands/speckit.clarify.md` - CDIR only
4. `.claude/commands/speckit.plan.md` - CEXE only
5. `.claude/commands/speckit.tasks.md` - CEXE only
6. `.claude/commands/speckit.implement.md` - CEXE only
7. `.claude/commands/speckit.analyze.md` - Both
8. `.claude/commands/speckit.checklist.md` - Both

**Changes:**
- Update command descriptions to specify which agent executes
- Add validation: Check agent identity before executing restricted commands
- Document in CLAUDE.md: Spec Kit command access matrix

**Impact:** MEDIUM - Spec Kit commands must only run by correct agent

---

### Subsystem 10: Session Protocols & Status

**Files to Modify:**
1. `sessions/CURRENT_STATUS.md`
   - Reflects three-agent activity
   - Shows CDIR and CEXE branches
   - Web activity only if emergency

2. Session logs
   - Future logs include agent attribution: `[From: CDIR]`, `[From: CEXE]`, `[From: Web]`
   - Envelope format maintained

3. Checkpoint files
   - Three-agent metadata
   - Checkpoint creation by CDIR, CEXE, or Web (rare)

**Impact:** LOW - Informational, not enforcement-critical

---

## Migration Phases

### Phase 0: Preparation (Web)
**Agent:** web-claude-designer-001 (this session)
**Output:** Complete migration plan and chained prompts

**Tasks:**
1. ✅ Create this architecture document
2. ⬜ Create ADR-012: Three-agent migration decision
3. ⬜ Create chained prompt: Phase 1 (CDIR identity setup)
4. ⬜ Create chained prompt: Phase 2 (Configuration migration)
5. ⬜ Create chained prompt: Phase 3 (Workspace coordination update)
6. ⬜ Create chained prompt: Phase 4 (Automation & hooks update)
7. ⬜ Create chained prompt: Phase 5 (Documentation update)
8. ⬜ Create chained prompt: Phase 6 (GitHub workflows update)
9. ⬜ Create chained prompt: Phase 7 (Validation & testing)
10. ⬜ Create chained prompt: Phase 8 (Production activation)
11. ⬜ Create rollback plan
12. ⬜ Create integration audit checklist

**Branch:** `claude/three-agent-migration-architecture` (NEW)

**Validation Gate:** All prompts created, ADR complete, rollback plan ready

---

### Phase 1: CDIR Identity Setup (CDIR - First Boot)
**Agent:** cli-claude-director-001 (NEW - first session)
**Executor:** User creates new terminal, runs CDIR prompt

**Tasks:**
1. Create `.claude/identity-cli-director.json`
2. Test identity anchoring (read identity file on startup)
3. Announce: `[From: CDIR] Identity anchored. CLI-Director operational.`
4. Validate identity file against schema

**Branch:** None yet (working on configuration)

**Validation Gate:** CDIR can read its identity, understands role

---

### Phase 2: Configuration Migration (CDIR)
**Agent:** cli-claude-director-001
**Prerequisites:** Phase 1 complete

**Tasks:**
1. Rename `.claude/identity-cli.json` → `.claude/identity-cli-executor.json`
2. Update `.claude/identity-cli-executor.json` (agent_id, short_name CEXE)
3. Update `.claude/identity-web.json` (role: standby, status: standby)
4. Update `config/project.yml` (team structure)
5. Update `config/ai-agent.yml` (or split into per-agent configs)
6. Commit: "[CDIR] Phase 2: Configuration migration"

**Branch:** `claude/design-three-agent-config`

**Validation Gate:** All identity files valid, config updated

---

### Phase 3: Workspace Coordination Update (CDIR)
**Agent:** cli-claude-director-001
**Prerequisites:** Phase 2 complete

**Tasks:**
1. Backup `.claude/workspace-coordination.yml`
2. Rewrite workspace manifest with three agents
3. Update `.claude/agent-registry.json` (three agents)
4. Create `.claude/handoffs/` directory structure
5. Validate manifest against schema
6. Commit: "[CDIR] Phase 3: Workspace coordination for three agents"

**Branch:** Same (`claude/design-three-agent-config`)

**Validation Gate:** Workspace manifest defines all three agents correctly

---

### Phase 4: Automation & Hooks Update (CDIR)
**Agent:** cli-claude-director-001
**Prerequisites:** Phase 3 complete

**Tasks:**
1. Update `tools/agent-start-work.sh` (recognize CDIR/CEXE)
2. Update `tools/agent-handoff.sh` (three-agent patterns)
3. Update `tools/agent-check-registry.sh` (three agents)
4. Update `tools/ensure-claude-branch.sh` (design/impl/emergency patterns)
5. Update `.githooks/pre-commit` (three-agent validation)
6. Update `.githooks/pre-push` (three-agent branch enforcement)
7. Test hooks locally (simulate commits/pushes)
8. Commit: "[CDIR] Phase 4: Automation and hooks for three agents"

**Branch:** Same (`claude/design-three-agent-config`)

**Validation Gate:** Hooks work, scripts recognize CDIR/CEXE

---

### Phase 5: Documentation Update (CDIR)
**Agent:** cli-claude-director-001
**Prerequisites:** Phase 4 complete

**Tasks:**
1. Update `CLAUDE.md` (session protocols, three agents)
2. Update `FOUNDATION.md` (team structure)
3. Update `README.md` (agent roster)
4. Update `CONTRIBUTING.md` (three-agent coordination)
5. Create `docs/IDENTITY_SETUP_PROMPT_CDIR.md`
6. Rename `docs/IDENTITY_SETUP_PROMPT_CLI.md` → `docs/IDENTITY_SETUP_PROMPT_CEXE.md`
7. Update `docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md`
8. Update `docs/THREE_ENVIRONMENT_COORDINATION.md`
9. Update `docs/AGENT_WORKSPACE_COORDINATION.md`
10. Commit: "[CDIR] Phase 5: Documentation for three-agent architecture"

**Branch:** Same (`claude/design-three-agent-config`)

**Validation Gate:** All documentation reflects three-agent reality

---

### Phase 6: GitHub Workflows Update (CDIR)
**Agent:** cli-claude-director-001
**Prerequisites:** Phase 5 complete

**Tasks:**
1. Update `.github/workflows/workspace-validation.yml`
2. Update `.github/workflows/auto-create-pr-claude-branches.yml`
3. Update `.github/workflows/auto-merge-claude-branches.yml`
4. Update `.github/workflows/checkpoint-automation.yml`
5. Check all other workflows for agent references
6. Commit: "[CDIR] Phase 6: GitHub workflows for three agents"

**Branch:** Same (`claude/design-three-agent-config`)

**Validation Gate:** Workflows validate three-agent patterns

---

### Phase 7: Validation & Testing (CDIR + CEXE)
**Agents:** cli-claude-director-001 + cli-claude-executor-001
**Prerequisites:** Phase 6 complete

**Tasks (CDIR):**
1. Push branch `claude/design-three-agent-config`
2. Create PR (auto-create workflow)
3. Verify workspace validation workflow runs
4. Create test spec: `specs/000-migration-test/spec.md`
5. Update agent registry: Mark spec ready for CEXE

**Tasks (CEXE - First Boot):**
1. User opens second terminal
2. CEXE loads identity: `.claude/identity-cli-executor.json`
3. Announce: `[From: CEXE] Identity anchored. CLI-Executor operational.`
4. Check agent registry: See CDIR's test spec
5. Create branch: `claude/impl-migration-test`
6. Create `specs/000-migration-test/plan.md` (test plan)
7. Handoff marker: Signal back to CDIR
8. Push branch

**Tasks (CDIR):**
1. Validate CEXE's plan.md
2. Mark validated in registry
3. Observe CEXE create tasks.md

**Tasks (CEXE):**
1. Create `specs/000-migration-test/tasks.md`
2. Execute simple test task
3. Mark complete in registry

**Validation Gate:** CDIR and CEXE successfully coordinate on test spec

---

### Phase 8: Production Activation (CDIR)
**Agent:** cli-claude-director-001
**Prerequisites:** Phase 7 validation complete

**Tasks:**
1. Merge PR: `claude/design-three-agent-config`
2. Create checkpoint: "Three-agent migration complete"
3. Update `sessions/CURRENT_STATUS.md`
4. Create ADR-012: Three-agent architecture migration
5. Create session log: Document migration
6. Announce: `[From: CDIR] Three-agent architecture operational. Web on standby.`

**Validation Gate:** All systems operational, Web successfully transitioned to standby

---

### Phase 9: Web Handoff & Standby Configuration (Web - Final)
**Agent:** web-claude-designer-001 (final session as primary)
**Prerequisites:** Phase 8 complete

**Tasks:**
1. Review migration completion
2. Update own workspace state to standby
3. Document emergency activation procedures
4. Create final checkpoint as Web: "Web transitioned to standby"
5. Close out active branches
6. Final message: `[From: Web] Primary designer role transferred to CDIR. Standing by for emergency activation.`

**Validation Gate:** Web gracefully transitioned, CDIR is now primary

---

## Integration Audit

**Systems requiring integration validation:**
1. ✓ Identity files → Agent registry → Workspace manifest
2. ✓ Workspace manifest → Git hooks → GitHub workflows
3. ✓ Agent registry → Handoff scripts → Session protocols
4. ✓ Identity files → Automation tools → Branch validation
5. ✓ Spec Kit commands → Workspace manifest → Agent capabilities
6. ✓ Session protocols → Documentation → CLAUDE.md
7. ✓ Git hooks → GitHub workflows → Safety net enforcement
8. ✓ CDIR identity → CEXE identity → Coordination protocols
9. ✓ Foundation docs → Config files → Behavioral consistency
10. ✓ Active work (current branches) → New agent ownership → Continuity

**Critical Integration Points:**
- CDIR must be able to read/write to all previous Web ownership areas
- CEXE must continue current executor responsibilities unchanged
- Git hooks must enforce new branch patterns immediately
- GitHub workflows must recognize new branch patterns
- Spec Kit commands must only execute by correct agent
- Session protocols must load correct identity for each agent
- Agent registry must track CDIR/CEXE coordination in real-time

---

## Rollback Plan

**Triggers for Rollback:**
- CDIR identity fails to load
- Workspace coordination enforcement breaks git workflow
- Integration tests fail (CDIR ↔ CEXE coordination)
- Critical functionality lost (unable to create specs, ADRs, docs)

**Rollback Procedure:**
1. Restore `.claude/identity-cli.json` (from identity-cli-executor.json backup)
2. Restore `.claude/identity-web.json` (from backup - primary role)
3. Restore `.claude/workspace-coordination.yml` (from backup)
4. Restore `.claude/agent-registry.json` (two agents)
5. Restore git hooks (two-agent version)
6. Delete CDIR identity file
7. Reset branches to pre-migration state
8. Announce: `[From: Web] Migration rolled back. Two-agent architecture restored.`

**Recovery Time:** < 30 minutes (restore from git history)

---

## Risk Assessment

**HIGH RISK:**
- Identity files incorrect → Agents can't operate
- Workspace manifest wrong → Boundary violations or false blocks
- Git hooks broken → Can't commit/push
- Integration failure → CDIR/CEXE can't coordinate

**MEDIUM RISK:**
- GitHub workflows incomplete → PRs not validated (but local enforcement works)
- Documentation outdated → Human confusion (but agents work)
- Spec Kit commands not restricted → Wrong agent executes command

**LOW RISK:**
- Session protocols not updated → Manual coordination works
- Status files outdated → Cosmetic issue

**Mitigation:**
- Validation gates at each phase (can't proceed until validated)
- Test environment first (test spec coordination before production)
- Rollback plan ready (git history preserves pre-migration state)
- Chained prompts ensure no steps skipped

---

## Success Criteria

**Migration is successful when:**
1. ✅ CDIR can create specifications, ADRs, documentation (primary designer role)
2. ✅ CEXE can create plans, tasks, implementation (primary executor role)
3. ✅ CDIR and CEXE coordinate via agent registry and handoff markers
4. ✅ Git hooks enforce three-agent workspace boundaries
5. ✅ GitHub workflows validate three-agent PRs
6. ✅ Spec Kit commands only execute by correct agent
7. ✅ Session protocols load correct identity for each agent
8. ✅ Web is on standby, can activate in emergency
9. ✅ All documentation reflects three-agent architecture
10. ✅ Test spec demonstrates full CDIR → CEXE workflow

**Foundation Imperatives Maintained:**
- Holistic System Thinking: All systems considered and integrated
- AI-First: Machine-readable config drives agent behavior
- Configurability: Identity/manifest files define all behavior
- Modularity: Agent identities cleanly swapped
- Extensibility: Three-agent pattern extensible to N agents
- Integration: All systems integrate correctly
- Automation: Tools and hooks enforce coordination

---

## Next Steps (Immediate)

**For this session (Web's final design work):**
1. ✅ Create this architecture document
2. ⬜ Create ADR-012: Three-agent migration decision
3. ⬜ Create all chained prompts (Phases 1-9)
4. ⬜ Create integration audit checklist
5. ⬜ Commit to branch: `claude/three-agent-migration-architecture`
6. ⬜ Push and create PR
7. ⬜ Hand off Phase 1 prompt to user for CDIR execution

**For next session (CDIR's first boot):**
1. User creates new terminal
2. User runs Phase 1 prompt in new terminal
3. CDIR identity anchors
4. CDIR begins Phase 2 (configuration migration)

---

**Prepared by:** web-claude-designer-001
**Date:** 2025-11-13
**Status:** Architecture complete, ready for chained prompt creation
**Next Action:** Create ADR-012 and chained prompts for execution

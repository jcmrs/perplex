# Workspace Coordination Integration Audit

**Purpose:** Track integration of workspace coordination across all Project Perplex systems

**Status:** Stage 1 Complete (Design & Formalization)

**Last Updated:** 2025-11-13

---

## Integration Status Overview

| System | Integration Points | Status | Stage |
|--------|-------------------|--------|-------|
| **Documentation Layer** | 6 files | ⬜ Pending | Stage 3 |
| **Enforcement Layer** | 5 components | ⬜ Pending | Stage 2 |
| **Identity Integration** | 3 components | ⬜ Pending | Stage 2 |
| **Process Layer** | 4 templates | ⬜ Pending | Stage 3 |
| **Spec Kit Integration** | 3 components | ⬜ Pending | Stage 3 |

**Legend:**
- ✅ Complete
- 🔄 In Progress
- ⬜ Pending
- ⏭️ Deferred

---

## Stage 1: Design & Formalization ✅

**Completed:** 2025-11-13

### Artifacts Created

- [x] **ADR-011:** `decisions/2025-11-13-agent-workspace-coordination.md`
  - Status: ✅ Complete
  - Content: Decision rationale, enforcement architecture, foundation alignment
  - Agent: web-claude-designer-001

- [x] **Workspace Manifest:** `.claude/workspace-coordination.yml`
  - Status: ✅ Complete
  - Content: Agent boundaries, coordination rules, Spec Kit integration, enforcement config
  - Agent: web-claude-designer-001

- [x] **Documentation:** `docs/AGENT_WORKSPACE_COORDINATION.md`
  - Status: ✅ Complete
  - Content: Complete guide for AI agents and human partners
  - Agent: web-claude-designer-001

- [x] **Integration Audit:** This document
  - Status: ✅ Complete
  - Content: Checklist for Stage 2 and Stage 3 integration
  - Agent: web-claude-designer-001

### Stage 1 Summary

**What was delivered:**
- Architectural decision documented (ADR-011)
- Workspace boundaries defined for both agents
- Coordination rules formalized
- Enforcement approach designed (4 layers)
- Comprehensive documentation created
- Integration checklist for implementation

**Next:** Stage 2 (Enforcement Implementation)

---

## Stage 2: Enforcement Implementation ⬜

**Target:** Next session
**Focus:** Git hooks, agent scripts, GitHub Actions

### Enforcement Layer

#### 1. Git Hook Enhancement ⬜

**File:** `.githooks/pre-commit`

**Changes Needed:**
- [ ] Add workspace boundary validation
- [ ] Read agent identity file
- [ ] Parse workspace manifest (YAML)
- [ ] Check modified files against ownership rules
- [ ] Display clear error messages with resolution guidance
- [ ] Handle shared files gracefully
- [ ] Support emergency override pattern

**Dependencies:**
- Requires: `tools/validate-workspace-boundaries.sh`
- Reads: `.claude/identity-*.json`, `.claude/workspace-coordination.yml`

**Testing:**
- [ ] Test Web modifying CLI-owned files (should block)
- [ ] Test CLI modifying Web-owned files (should block)
- [ ] Test both modifying shared files (should allow)
- [ ] Test emergency override (should allow with warning)
- [ ] Test error message clarity

**Estimated Effort:** Medium (30-40 lines addition, YAML parsing complexity)

#### 2. Workspace Validation Script ⬜

**File:** `tools/validate-workspace-boundaries.sh` (NEW)

**Purpose:** Standalone script for boundary validation (called by git hook)

**Functionality:**
- [ ] Read agent identity from file
- [ ] Parse workspace manifest (YAML)
- [ ] Validate file path against agent ownership
- [ ] Return: primary|shared|read-only|unknown|emergency-override
- [ ] Provide clear explanations

**CLI Usage:**
```bash
tools/validate-workspace-boundaries.sh --file path/to/file.md
# Returns exit code 0 (ok) or 1 (violation)
# Outputs: ownership status and explanation
```

**Dependencies:**
- Reads: `.claude/identity-*.json`, `.claude/workspace-coordination.yml`
- Requires: `yq` or `jq` for YAML parsing (check availability)

**Testing:**
- [ ] Test all ownership categories
- [ ] Test edge cases (non-existent files, etc.)
- [ ] Test both agent identities
- [ ] Test Spec Kit paths specifically

**Estimated Effort:** Medium (50-60 lines, YAML parsing)

#### 3. Agent Start Work Script ⬜

**File:** `tools/agent-start-work.sh` (NEW)

**Purpose:** Formalize work initialization, update registry

**Functionality:**
- [ ] Read agent identity
- [ ] Validate artifact type matches agent role
- [ ] Check for pending handoffs
- [ ] Suggest branch name if needed
- [ ] Update `.claude/agent-registry.json`
- [ ] Display current state and next actions

**CLI Usage:**
```bash
tools/agent-start-work.sh --artifact specs/001-feature/spec.md --type specification
```

**Dependencies:**
- Reads: `.claude/identity-*.json`, `.claude/agent-registry.json`, `.claude/handoffs/`
- Writes: `.claude/agent-registry.json`

**Testing:**
- [ ] Test Web starting spec work
- [ ] Test CLI starting plan work
- [ ] Test with pending handoff
- [ ] Test invalid artifact type for agent
- [ ] Test registry update correctness

**Estimated Effort:** Medium (60-70 lines, JSON manipulation)

#### 4. Agent Handoff Script ⬜

**File:** `tools/agent-handoff.sh` (NEW)

**Purpose:** Formalize work completion, create handoff markers

**Functionality:**
- [ ] Validate handoff criteria (artifact complete)
- [ ] Create handoff marker: `.claude/handoffs/{timestamp}-{type}.json`
- [ ] Update agent registry (mark complete, add pending for next agent)
- [ ] Suggest commit message with [HANDOFF] tag
- [ ] Display next actions

**CLI Usage:**
```bash
tools/agent-handoff.sh --to cli --artifact specs/001-feature/spec.md
```

**Dependencies:**
- Reads: `.claude/identity-*.json`, `.claude/workspace-coordination.yml`
- Writes: `.claude/agent-registry.json`, `.claude/handoffs/*.json`

**Testing:**
- [ ] Test Web → CLI handoff
- [ ] Test CLI → Web handoff
- [ ] Test handoff marker creation
- [ ] Test registry updates
- [ ] Test validation criteria

**Estimated Effort:** Medium (70-80 lines, validation logic)

#### 5. Agent Check Registry Script ⬜

**File:** `tools/agent-check-registry.sh` (NEW)

**Purpose:** Check other agents' activity, see pending handoffs

**Functionality:**
- [ ] Read agent registry
- [ ] Display all agents' status
- [ ] Highlight pending handoffs for current agent
- [ ] Suggest next actions
- [ ] Check for handoff markers

**CLI Usage:**
```bash
tools/agent-check-registry.sh
```

**Dependencies:**
- Reads: `.claude/agent-registry.json`, `.claude/handoffs/`, `.claude/identity-*.json`

**Testing:**
- [ ] Test with active agents
- [ ] Test with pending handoffs
- [ ] Test with idle agents
- [ ] Test output clarity

**Estimated Effort:** Low (40-50 lines, mostly display logic)

#### 6. GitHub Validation Workflow ⬜

**File:** `.github/workflows/workspace-validation.yml` (NEW)

**Purpose:** Validate PRs respect workspace boundaries

**Functionality:**
- [ ] Trigger on PR (opened, synchronize)
- [ ] Parse branch name → determine agent
- [ ] Get PR modified files
- [ ] Load workspace manifest
- [ ] Validate files vs agent ownership
- [ ] Comment on PR if violations
- [ ] Set check status (pass/fail)

**Dependencies:**
- Reads: `.claude/workspace-coordination.yml`
- Uses: GitHub API for PR files, comments

**Testing:**
- [ ] Test Web PR modifying Web-owned files (pass)
- [ ] Test Web PR modifying CLI-owned files (fail)
- [ ] Test CLI PR modifying CLI-owned files (pass)
- [ ] Test comment format and clarity
- [ ] Test check status integration

**Estimated Effort:** Medium (60-70 lines, GitHub API usage)

### Identity Integration

#### 7. Agent Registry Schema Enhancement ⬜

**File:** `.claude/agent-registry.json`

**Changes Needed:**
- [ ] Add `current_work_branch` field
- [ ] Add `active_specifications` array
- [ ] Add `workspace_state` field (designing, planning, implementing, validating, idle)
- [ ] Add `next_handoff` object
- [ ] Add `pending_handoffs` array

**New Schema:**
```json
{
  "agents": {
    "agent-id": {
      "status": "active|idle",
      "current_work_branch": "claude/branch-name",
      "active_specifications": ["specs/001-feature/spec.md"],
      "workspace_state": "designing|planning|implementing|validating|idle",
      "last_active": "ISO 8601 timestamp",
      "next_handoff": {
        "to": "target-agent-id",
        "artifact": "file-path",
        "trigger": "handoff-trigger-name"
      },
      "pending_handoffs": [
        {
          "from": "source-agent-id",
          "artifact": "file-path",
          "timestamp": "ISO 8601 timestamp"
        }
      ]
    }
  }
}
```

**Testing:**
- [ ] Validate JSON schema
- [ ] Test agent scripts read/write correctly
- [ ] Test backward compatibility

**Estimated Effort:** Low (schema definition, update scripts)

#### 8. Identity File Validation ⬜

**Enhancement:** Validate `decision_scope` matches workspace ownership

**Functionality:**
- [ ] When creating ADR, check agent's decision_scope
- [ ] Alert if ADR type outside scope
- [ ] Workspace manifest references decision_scope

**Implementation:**
- Could be part of ADR template
- Or separate validation script
- Or integrated into pre-commit hook

**Testing:**
- [ ] Test Web creating architecture ADR (allowed)
- [ ] Test CLI creating architecture ADR (alert)
- [ ] Test Web creating implementation ADR (alert)

**Estimated Effort:** Low (validation logic in templates or scripts)

### Handoff Infrastructure

#### 9. Handoff Markers Directory ⬜

**Directory:** `.claude/handoffs/` (NEW)

**Purpose:** Persistent handoff state across sessions

**Structure:**
```
.claude/handoffs/
├── 20251113120000-spec-to-plan.json
├── 20251113140000-plan-to-validation.json
└── 20251113160000-validation-to-tasks.json
```

**Marker Schema:**
```json
{
  "timestamp": "2025-11-13T12:00:00Z",
  "from_agent": "web-claude-designer-001",
  "to_agent": "cli-claude-executor-001",
  "artifact": "specs/001-feature/spec.md",
  "trigger": "spec_complete",
  "validation_criteria": [
    "spec.md exists and is complete",
    "Success criteria defined"
  ],
  "status": "pending|acknowledged|complete",
  "acknowledged_at": null
}
```

**Changes Needed:**
- [ ] Create directory (gitignore or commit)
- [ ] Decide: Git-tracked or local-only?
- [ ] Document marker lifecycle

**Testing:**
- [ ] Test marker creation by handoff script
- [ ] Test marker reading by check-registry script
- [ ] Test marker cleanup (when?)

**Estimated Effort:** Low (directory structure, schema definition)

### Stage 2 Summary

**Deliverables:**
- Enhanced pre-commit hook with workspace validation
- 4 new agent coordination scripts
- GitHub Actions workspace validation workflow
- Enhanced agent registry schema
- Handoff markers infrastructure

**Testing Requirements:**
- Simulated violations (Web modifies CLI files, etc.)
- Handoff workflow end-to-end
- Emergency override patterns
- All error messages clear and actionable

**Success Criteria:**
- Pre-commit hook blocks violations 100% of time
- Agent scripts update registry correctly
- GitHub workflow validates PRs accurately
- Handoffs persist across sessions reliably

---

## Stage 3: Integration & Validation ⬜

**Target:** Follow-up session after Stage 2
**Focus:** Update documentation, templates, test with Spec Kit

### Documentation Layer

#### 10. CLAUDE.md Updates ⬜

**File:** `CLAUDE.md`

**Changes Needed:**
- [ ] Add workspace coordination to session start protocol (Step 6)
- [ ] Reference workspace manifest in "Common Commands"
- [ ] Add agent coordination scripts to tooling section
- [ ] Update multi-agent coordination section

**New Section:**
```markdown
## Session Start Protocol

1. Anchor identity (read identity file)
2. Load checkpoint
3. Review specifications
4. Check tasks status
5. Check active specifications
6. **NEW: Check workspace boundaries and pending handoffs**
   - Read `.claude/workspace-coordination.yml` (know your boundaries)
   - Run `tools/agent-check-registry.sh` (see pending work)
   - If pending handoffs: Run `tools/agent-start-work.sh`

## Agent Coordination Commands

**Workspace Coordination:**
- `tools/agent-start-work.sh` - Initialize work on artifact
- `tools/agent-handoff.sh` - Complete work, trigger next agent
- `tools/agent-check-registry.sh` - See other agents' activity
- `tools/validate-workspace-boundaries.sh` - Check file ownership
```

**Testing:**
- [ ] Test protocol with fresh agent session
- [ ] Validate commands work as documented

**Estimated Effort:** Low (documentation updates)

#### 11. README.md Updates ⬜

**File:** `README.md`

**Changes Needed:**
- [ ] Add "Multi-Agent Workspace" section
- [ ] Explain workspace coordination concept
- [ ] Update agent collaboration description
- [ ] Reference workspace coordination docs

**New Section:**
```markdown
## Multi-Agent Workspace Coordination

Project Perplex uses multiple AI agents collaborating with formal workspace boundaries:

**Web (Designer-Researcher):**
- Owns: Specifications, ADRs, requirements, documentation
- Creates: What and why (design responsibility)

**CLI (Executor-Validator):**
- Owns: Implementation, tests, technical plans, tasks
- Creates: How (execution responsibility)

**Coordination:**
- Workspace manifest defines ownership boundaries
- Git hooks enforce boundaries automatically
- Agent registry tracks activity and handoffs
- Formal scripts (start-work, handoff) coordinate transitions

See: [Agent Workspace Coordination](docs/AGENT_WORKSPACE_COORDINATION.md)
```

**Testing:**
- [ ] README accurately reflects current system
- [ ] Links work correctly

**Estimated Effort:** Low (documentation updates)

#### 12. THREE_ENVIRONMENT_COORDINATION.md Updates ⬜

**File:** `docs/THREE_ENVIRONMENT_COORDINATION.md`

**Changes Needed:**
- [ ] Add workspace boundaries section
- [ ] Reference workspace manifest
- [ ] Update conflict resolution patterns
- [ ] Add enforcement layer description

**New Sections:**
- Workspace boundaries per environment
- How enforcement works in each environment
- Handoff patterns with examples

**Testing:**
- [ ] Verify accuracy after enforcement implementation

**Estimated Effort:** Low (documentation updates)

#### 13. CONTRIBUTING.md Updates ⬜

**File:** `CONTRIBUTING.md`

**Changes Needed:**
- [ ] Add workspace coordination section
- [ ] Explain agent boundaries for contributors
- [ ] Reference workspace manifest
- [ ] Add commit message conventions ([Agent] prefix)

**New Section:**
```markdown
## Multi-Agent Coordination

This project uses AI agents with formal workspace boundaries:

**If you're contributing code:**
- Be aware agents have file ownership patterns
- Check `.claude/workspace-coordination.yml` if unsure
- Commit messages include `[Agent]` prefix for clarity

**If you're adding documentation:**
- Web typically owns documentation files
- CLI can suggest updates via issues or PRs

**Workspace validation:**
- Pre-commit hooks validate boundaries
- GitHub Actions check PRs
- Violations are blocked automatically
```

**Testing:**
- [ ] Review for human contributor clarity

**Estimated Effort:** Low (documentation updates)

#### 14. FOUNDATION.md Updates ⬜

**File:** `FOUNDATION.md`

**Changes Needed:**
- [ ] Reference workspace coordination as enforcement mechanism
- [ ] Add to "Automation" imperative examples
- [ ] Link to ADR-011 in related decisions

**Addition:**
```markdown
### Automation Examples

**Workspace Coordination Enforcement:**
- Git hooks validate agent boundaries before commits
- Agent registry tracks work automatically
- Handoff scripts formalize transitions
- GitHub Actions validate PRs

See: ADR-011 (Agent Workspace Boundaries)
```

**Testing:**
- [ ] Verify foundation alignment claims

**Estimated Effort:** Low (documentation updates)

#### 15. Branch Management Docs Updates ⬜

**File:** `docs/BRANCH_MANAGEMENT.md` or `docs/LOCAL_AUTOMATION_STRATEGY.md`

**Changes Needed:**
- [ ] Add workspace coordination context
- [ ] Explain how branch conventions tie to workspace ownership
- [ ] Reference agent-specific branch patterns

**Context Addition:**
- Branch names indicate agent ownership
- Workspace validation uses branch patterns
- Pre-push hook checks workspace + branch alignment

**Testing:**
- [ ] Verify branch strategy documentation complete

**Estimated Effort:** Low (documentation updates)

### Process Layer

#### 16. ADR Template Enhancement ⬜

**File:** `decisions/TEMPLATE.md`

**Changes Needed:**
- [ ] Add `agent_creator` front matter field
- [ ] Add `decision_scope` validation field
- [ ] Add note about decision scope matching agent role

**New Front Matter:**
```markdown
# [Number]. [Decision Title]

**Date:** YYYY-MM-DD
**Status:** [Proposed | Accepted | Deprecated | Superseded]
**Deciders:** [AI Agent / Human Partner / Both]
**Agent Creator:** [agent-id from identity file]
**Decision Scope:** [architecture | implementation | etc.]

# ... rest of template
```

**Validation Note:**
```markdown
**For AI Agents:** Ensure your `decision_scope` matches your role's allowed scopes.
Check `.claude/identity-{env}.json` → `persona_profile.decision_scope`
```

**Testing:**
- [ ] Test with Web creating architecture ADR
- [ ] Test with CLI creating implementation note

**Estimated Effort:** Low (template enhancement)

#### 17. Session Log Template Enhancement ⬜

**File:** `sessions/SESSION_LOG_TEMPLATE.md`

**Changes Needed:**
- [ ] Add `agent_id` field
- [ ] Add `workspace_activity` section
- [ ] Add `handoffs` section

**New Fields:**
```markdown
# Session Log: [Title]

**Date:** YYYY-MM-DD
**Agent:** [agent-id from identity file]
**Agent Role:** [designer-researcher | executor-validator]
**Collaborating Agents:** [list if applicable]

## Workspace Activity

**Files Modified:**
- Primary ownership: [files in agent's ownership]
- Shared ownership: [files both agents can modify]
- Read-only accessed: [files agent consulted]

**Boundary Violations:** None | [if any, explain and justify]

## Handoffs

**Received:**
- From: [agent-id]
- Artifact: [file]
- Trigger: [handoff-trigger-name]
- Timestamp: [ISO 8601]

**Sent:**
- To: [agent-id]
- Artifact: [file]
- Trigger: [handoff-trigger-name]
- Timestamp: [ISO 8601]
```

**Testing:**
- [ ] Test template with real session log

**Estimated Effort:** Low (template enhancement)

#### 18. Checkpoint Template Enhancement ⬜

**File:** `checkpoints/TEMPLATE.md`

**Changes Needed:**
- [ ] Add `workspace_state` section
- [ ] Capture active specifications per agent
- [ ] Capture pending handoffs

**New Section:**
```markdown
## Workspace State

**Web (web-claude-designer-001):**
- Status: [active | idle]
- Working on: [artifacts]
- Branch: [branch-name]
- State: [designing | validating | idle]
- Pending handoffs: [to-agent → artifact]

**CLI (cli-claude-executor-001):**
- Status: [active | idle]
- Working on: [artifacts]
- Branch: [branch-name]
- State: [planning | implementing | testing | idle]
- Pending handoffs: [from-agent ← artifact]
```

**Testing:**
- [ ] Test checkpoint includes workspace state
- [ ] Test resume-from-checkpoint handles workspace info

**Estimated Effort:** Low (template enhancement)

#### 19. Completeness Review Enhancement ⬜

**File:** `tools/review-completeness.sh`

**Changes Needed:**
- [ ] Add "Workspace Coordination" section
- [ ] Check agent registry is current
- [ ] Check for unacknowledged handoffs
- [ ] Validate workspace manifest accuracy

**New Checks:**
```bash
section "7. Workspace Coordination"

# Check agent registry updated
if [ ! -f ".claude/agent-registry.json" ]; then
    issue "Agent registry missing"
else
    LAST_REGISTRY_UPDATE=$(stat -c %Y .claude/agent-registry.json)
    AGE=$(($(date +%s) - LAST_REGISTRY_UPDATE))
    if [ $AGE -gt 7200 ]; then  # 2 hours
        warning "Agent registry not updated in 2+ hours"
    else
        ok "Agent registry current"
    fi
fi

# Check for unacknowledged handoffs
PENDING_HANDOFFS=$(ls .claude/handoffs/ 2>/dev/null | wc -l)
if [ $PENDING_HANDOFFS -gt 0 ]; then
    warning "$PENDING_HANDOFFS pending handoff(s)"
    info "Run: tools/agent-check-registry.sh"
fi

# Check workspace manifest exists
if [ ! -f ".claude/workspace-coordination.yml" ]; then
    issue "Workspace manifest missing"
else
    ok "Workspace manifest present"
fi
```

**Testing:**
- [ ] Test checks with various states
- [ ] Test recommendations helpful

**Estimated Effort:** Low (add checks to script)

### Spec Kit Integration

#### 20. Spec Kit Command Validation ⬜

**Files:** `.claude/commands/speckit.*.md`

**Changes Needed:**
- [ ] Add agent identity check to each command
- [ ] Validate agent can execute command (per workspace manifest)
- [ ] Reference workspace ownership in command descriptions

**Example for `/speckit.specify`:**
```markdown
# /speckit.specify - Create Feature Specification

**Agent Requirement:** web-claude-designer-001 (Web)

**Workspace Validation:**
- Web owns specs/*/spec.md (specifications)
- This command creates specification artifacts
- CLI cannot execute this command (executor role)

Before running:
- Ensure you are Web agent (check identity file)
- Ensure you're on correct branch (claude/*)
- Run: tools/agent-start-work --artifact specs/NNN-feature/spec.md --type specification

# ... rest of command prompt
```

**Testing:**
- [ ] Test Web executing /speckit.specify (allowed)
- [ ] Test CLI attempting /speckit.specify (should show error)

**Estimated Effort:** Medium (update 8 command files, add validation)

#### 21. Constitution Integration ⬜

**File:** `.specify/memory/constitution.md`

**Changes Needed:**
- [ ] Integrate Foundation Imperatives (already planned)
- [ ] Add workspace coordination principles
- [ ] Reference agent boundaries in governance

**Addition:**
```markdown
## Article X: Multi-Agent Coordination

**Workspace Boundaries:**
- Designer agents (Web) own specifications, requirements, ADRs
- Executor agents (CLI) own implementations, tests, plans, tasks
- Boundaries enforced automatically via git hooks
- Handoffs formalized via agent coordination scripts

**Governance:**
- Agents work within defined boundaries
- Emergency overrides allowed but documented
- Workspace manifest is source of truth
- Violations are blocked at commit time
```

**Testing:**
- [ ] Validate constitution after CLI runs /speckit.constitution

**Estimated Effort:** Low (constitution update after creation)

#### 22. Spec Kit Workflow Documentation ⬜

**File:** `docs/SPEC_KIT_WORKFLOW.md` or section in CLAUDE.md

**Changes Needed:**
- [ ] Document complete Spec Kit workflow with workspace coordination
- [ ] Show handoff points explicitly
- [ ] Include agent coordination commands in workflow

**Example Workflow:**
```markdown
## Spec Kit Workflow with Workspace Coordination

### Phase -1: Constitution (Web, one-time)
1. Web: /speckit.constitution
2. Output: .specify/memory/constitution.md
3. Handoff: Constitution informs all future specs

### Phase 0: Specification (Web)
1. Web: tools/agent-start-work --artifact specs/001-feature/spec.md --type specification
2. Web: /speckit.specify "feature-name"
3. Web: /speckit.clarify (optional)
4. Web: tools/agent-handoff --to cli --artifact specs/001-feature/spec.md
5. Commit: [Web] [HANDOFF] Complete feature specification → CLI for planning

### Phase 1: Planning (CLI)
1. CLI: tools/agent-check-registry (sees pending handoff)
2. CLI: tools/agent-start-work --artifact specs/001-feature/plan.md --type plan
3. CLI: Read specs/001-feature/spec.md (reference)
4. CLI: /speckit.plan
5. CLI: tools/agent-handoff --to web --artifact specs/001-feature/plan.md
6. Commit: [CLI] [HANDOFF] Complete technical plan → Web for validation

### Phase 1.5: Validation (Web)
1. Web: tools/agent-check-registry (sees pending handoff)
2. Web: Review specs/001-feature/plan.md against spec.md
3. Web: Confirm alignment or request adjustments
4. Web: tools/agent-handoff --to cli --artifact specs/001-feature/plan.md --validated
5. Commit: [Web] [HANDOFF] Validate plan → CLI for task decomposition

### Phase 2: Task Decomposition (CLI)
1. CLI: tools/agent-start-work --artifact specs/001-feature/tasks.md --type tasks
2. CLI: /speckit.tasks
3. CLI: (No handoff, moves directly to implementation)

### Phase 3: Implementation (CLI)
1. CLI: /speckit.implement
2. CLI: Implements in src/ (CLI-owned)
3. CLI: Tests pass
4. CLI: tools/agent-handoff --to web --artifact src/** (implementation complete)
5. Commit: [CLI] [HANDOFF] Complete implementation → Web for validation

### Phase 4: Final Validation (Web)
1. Web: Review implementation against spec.md success criteria
2. Web: Confirm success criteria met
3. Web: Mark specification complete in registry
4. Web: Create ADR if architectural decisions made
5. Stage complete
```

**Testing:**
- [ ] Test workflow end-to-end with real Spec Kit
- [ ] Validate handoff points work smoothly

**Estimated Effort:** Medium (comprehensive workflow documentation)

### Stage 3 Summary

**Deliverables:**
- All documentation updated with workspace coordination
- All templates enhanced with agent metadata
- Completeness review includes workspace checks
- Spec Kit workflow fully integrated

**Testing Requirements:**
- End-to-end Spec Kit workflow with workspace coordination
- All integration points validated
- Documentation accuracy verified
- Templates tested with real usage

**Success Criteria:**
- All documentation current and accurate
- Agents follow workflow naturally
- No gaps in integration discovered
- Completeness review catches workspace issues

---

## Testing Plan

### Unit Testing (Stage 2)

**Git Hook:**
- [ ] Web modifying CLI-owned files (block)
- [ ] CLI modifying Web-owned files (block)
- [ ] Both modifying shared files (allow)
- [ ] Emergency override (allow with warning)
- [ ] Error messages clear and actionable

**Agent Scripts:**
- [ ] agent-start-work updates registry correctly
- [ ] agent-handoff creates markers correctly
- [ ] agent-check-registry displays accurate info
- [ ] validate-workspace-boundaries returns correct status

**GitHub Workflow:**
- [ ] Detects violations in PRs
- [ ] Comments on PRs with clear guidance
- [ ] Sets check status correctly
- [ ] Handles multiple files

### Integration Testing (Stage 3)

**End-to-End Spec Kit Workflow:**
- [ ] Web creates specification
- [ ] Web hands off to CLI
- [ ] CLI creates plan
- [ ] CLI hands off to Web for validation
- [ ] Web validates and hands back
- [ ] CLI creates tasks
- [ ] CLI implements
- [ ] CLI hands off to Web for final validation
- [ ] Web validates and completes

**Multi-Session Handoff:**
- [ ] Web completes spec, pushes
- [ ] CLI starts new session (later)
- [ ] CLI sees pending handoff
- [ ] CLI acknowledges and starts work

**Conflict Scenarios:**
- [ ] Both agents update CURRENT_STATUS.md (shared, should handle)
- [ ] Both agents on separate branches (should coordinate)
- [ ] Emergency override used correctly

### Validation Testing (Stage 3)

**Foundation Imperatives:**
- [ ] Holistic System Thinking: All integration points updated
- [ ] AI-First: Enforcement automatic, no human intervention
- [ ] Automation: Scripts handle coordination
- [ ] Configurability: Manifest drives behavior
- [ ] Modularity: Workspace coordination separate system

**Completeness Review:**
- [ ] Workspace coordination section catches issues
- [ ] Agent registry staleness detected
- [ ] Unacknowledged handoffs flagged

**Documentation Accuracy:**
- [ ] CLAUDE.md reflects actual workflow
- [ ] README.md describes system accurately
- [ ] AGENT_WORKSPACE_COORDINATION.md guides agents effectively

---

## Success Criteria

### Overall Success

Workspace coordination is successful when:

1. ✅ **Conflicts prevented:** No merge conflicts due to simultaneous work on same files
2. ✅ **Boundaries enforced:** Pre-commit hook blocks violations 100% of time
3. ✅ **Handoffs formalized:** All work transitions use handoff scripts
4. ✅ **Visibility maintained:** Agent registry shows accurate current state
5. ✅ **Spec Kit integrated:** Workflow uses workspace coordination naturally
6. ✅ **Documentation complete:** All integration points updated
7. ✅ **Testing passed:** All unit, integration, validation tests pass
8. ✅ **Foundation aligned:** All 7 imperatives satisfied

### Per-Stage Success

**Stage 1 (Design):**
- [x] ADR-011 complete and thorough
- [x] Workspace manifest covers all cases
- [x] Documentation comprehensive
- [x] Integration audit created

**Stage 2 (Enforcement):**
- [ ] Git hooks enforce boundaries
- [ ] Agent scripts work correctly
- [ ] GitHub workflow validates PRs
- [ ] Unit tests pass

**Stage 3 (Integration):**
- [ ] All documentation updated
- [ ] All templates enhanced
- [ ] Spec Kit workflow validated
- [ ] Integration tests pass

---

## Deferred Items

**Not implemented in Stages 1-3, consider for future:**

- [ ] Workspace dashboard (visual agent activity)
- [ ] Auto-handoff (detect completion, trigger automatically)
- [ ] Conflict prediction (warn before overlapping work)
- [ ] Workspace analytics (track patterns over time)
- [ ] Multi-project coordination (extend beyond single project)
- [ ] Third agent integration (add validation/docs agents)

**Rationale:** Implement core enforcement first, extend based on real usage and needs.

---

## Notes

### Holistic System Thinking in Practice

This integration audit demonstrates the imperative:

**14 integration points identified** across:
- Documentation (6 files)
- Enforcement (5 components)
- Identity (3 components)
- Process (4 templates)
- Spec Kit (3 components)

**Ripple effects considered:**
- Git hooks affect commit workflow
- Agent registry affects session start
- Handoff scripts affect coordination
- Templates affect documentation
- Spec Kit commands affect implementation

**This is NOT just adding features. This is integrating a system into the project's fabric.**

### AI-First Enforcement Philosophy

**"Enforce, don't document"** - Proven pattern:
- Branch conventions: 3 violations before enforcement, 0 after
- Workspace coordination: Following same pattern

**Automation handles:**
- Boundary validation (git hooks)
- Registry updates (agent scripts)
- Handoff formalization (handoff scripts)
- PR validation (GitHub Actions)

**Agents don't need to "remember" - enforcement ensures correctness.**

---

**Last Updated:** 2025-11-13
**Created by:** web-claude-designer-001
**Stage:** Stage 1 Complete, Stage 2 & 3 Pending
**Next:** Implement Stage 2 enforcement mechanisms

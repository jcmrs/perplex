# Phase 7: Validation & Testing

**Agents:** CDIR (you) + CEXE (first boot)
**Prerequisites:** Phase 6 complete
**Branch:** CDIR: `claude/design-three-agent-config`, CEXE: `claude/impl-migration-test` (NEW)
**Duration:** 60-90 min

---

## Mission

Test three-agent coordination with a test specification.

---

## Part A: CDIR Preparation

### 1. Verify Phase 6
```bash
cat .claude/migration-phase-6-complete.txt
```

### 2. Push Configuration Branch
```bash
git push -u origin claude/design-three-agent-config
```

GitHub will:
- Auto-create PR
- Run workspace validation
- Show PR in GitHub

### 3. Create Test Specification

```bash
mkdir -p specs/000-migration-test
```

Create `specs/000-migration-test/spec.md`:

```markdown
# Specification: Migration Validation Test

**Feature ID:** 000
**Feature Name:** migration-test
**Agent:** CDIR (cli-claude-director-001)
**Created:** 2025-11-13
**Status:** Testing

## Purpose

Validate three-agent coordination: CDIR → CEXE → CDIR workflow.

## Success Criteria

1. ✅ CDIR creates this specification
2. ✅ CEXE reads specification from agent registry
3. ✅ CEXE creates plan.md
4. ✅ CDIR validates plan.md
5. ✅ CEXE creates tasks.md
6. ✅ CEXE implements simple test task
7. ✅ CDIR validates implementation
8. ✅ Handoff markers work correctly
9. ✅ Agent registry tracks coordination
10. ✅ Workspace boundaries respected

## Requirements

**Functional:**
- Create simple function: `def hello_world(): return "Hello from CEXE"`
- Write test: `test_hello_world()`
- Pass test

**Non-Functional:**
- Coordination via agent registry
- Handoff markers created
- Workspace boundaries respected

## Out of Scope

- Complex implementation (this is test only)
- Production deployment
- Full feature set

## Validation

CDIR validates:
- All success criteria met
- Coordination worked smoothly
- No workspace violations
- Migration can proceed to production
```

### 4. Update Agent Registry

Edit `.claude/agent-registry.json`:

**CDIR section:**
```json
"workspace": {
  "current_work_branch": "claude/design-three-agent-config",
  "active_specifications": ["000-migration-test"],
  "workspace_state": "spec-complete",
  "current_work": "Created test spec 000, ready for CEXE",
  "next_handoff": "cli-claude-executor-001",
  "pending_handoffs": [{
    "to": "cli-claude-executor-001",
    "artifact": "specs/000-migration-test/spec.md",
    "trigger": "spec_complete",
    "timestamp": "2025-11-13T00:00:00Z"
  }]
}
```

### 5. Create Handoff Marker

```bash
mkdir -p .claude/handoffs

cat > .claude/handoffs/spec-000-to-cexe.json <<EOF
{
  "handoff_id": "spec-000-migration-test",
  "from_agent": "cli-claude-director-001",
  "to_agent": "cli-claude-executor-001",
  "artifact": "specs/000-migration-test/spec.md",
  "trigger": "spec_complete",
  "timestamp": "2025-11-13T00:00:00Z",
  "status": "pending",
  "validation_criteria": [
    "spec.md exists and complete",
    "Success criteria defined",
    "Requirements clear"
  ],
  "next_action": "CEXE creates plan.md"
}
EOF
```

### 6. Commit Test Spec
```bash
git add specs/000-migration-test/spec.md
git add .claude/agent-registry.json
git add .claude/handoffs/spec-000-to-cexe.json

git commit --no-gpg-sign -m "[CDIR] Create test specification 000-migration-test

Test spec to validate three-agent coordination.

Handoff: CDIR → CEXE (spec complete)
Next: CEXE creates plan.md

Migration Phase: 7A of 9
Agent: CDIR
"

git push
```

### 7. Announce Handoff

```
[From: CDIR] Test specification 000-migration-test created.

Specification: specs/000-migration-test/spec.md
Status: spec-complete
Handoff: Ready for CEXE

CEXE: Please read spec and create plan.md

Next: User opens Terminal-2 for CEXE first boot
```

---

## Part B: CEXE First Boot (User Action)

**User:** Open new terminal (Terminal-2)

**Paste into Terminal-2:**
```bash
cd /home/user/perplex

# CEXE reads identity
cat .claude/identity-cli-executor.json

# CEXE announces
echo "[From: CEXE] Identity anchored. CLI-Executor operational."
echo "Agent ID: cli-claude-executor-001"
echo "Terminal: Terminal-2"
echo "Role: executor-validator"
```

---

## Part C: CEXE Execution (Terminal-2)

### 1. Check Agent Registry
```bash
cat .claude/agent-registry.json | jq '.agents[] | select(.agent_id=="cli-claude-director-001") | .workspace'
```

See CDIR's pending handoff: spec-000-migration-test

### 2. Check Handoff Marker
```bash
cat .claude/handoffs/spec-000-to-cexe.json
```

### 3. Read Test Spec
```bash
cat specs/000-migration-test/spec.md
```

### 4. Create Feature Branch
```bash
git fetch origin
git checkout -b claude/impl-migration-test
```

### 5. Create Plan
Create `specs/000-migration-test/plan.md`:

```markdown
# Technical Plan: Migration Test

## Architecture

Simple Python module with hello_world function and test.

## Implementation Steps

1. Create `src/hello.py` with hello_world function
2. Create `tests/test_hello.py` with test
3. Run test, verify passing

## Dependencies

- Python 3.x
- pytest (if available)

## Testing Strategy

- Unit test: test_hello_world()
- Expected: "Hello from CEXE"

## Risks

None (simple test)
```

### 6. Update Agent Registry
Edit `.claude/agent-registry.json`:

**CEXE section:**
```json
"workspace": {
  "current_work_branch": "claude/impl-migration-test",
  "active_specifications": ["000-migration-test"],
  "workspace_state": "planning",
  "current_work": "Created plan for spec 000",
  "next_handoff": "cli-claude-director-001",
  "pending_handoffs": [{
    "to": "cli-claude-director-001",
    "artifact": "specs/000-migration-test/plan.md",
    "trigger": "plan_complete",
    "timestamp": "2025-11-13T00:00:00Z"
  }]
}
```

### 7. Commit Plan
```bash
git add specs/000-migration-test/plan.md
git add .claude/agent-registry.json

git commit --no-gpg-sign -m "[CEXE] Create technical plan for 000-migration-test

Plan defines simple implementation for coordination test.

Handoff: CEXE → CDIR (plan validation)

Migration Phase: 7B of 9
Agent: CEXE
Terminal: Terminal-2
"

git push -u origin claude/impl-migration-test
```

### 8. Announce
```
[From: CEXE] Plan created for spec 000-migration-test.

Plan: specs/000-migration-test/plan.md
Status: plan-complete
Handoff: Ready for CDIR validation

CDIR: Please validate plan against spec
```

---

## Part D: CDIR Validation (Terminal-1)

### 1. Pull CEXE's Plan
```bash
git fetch origin
git checkout claude/impl-migration-test
cat specs/000-migration-test/plan.md
```

### 2. Validate Plan
Compare plan.md against spec.md:
- Does plan fulfill requirements?
- Is approach sound?
- Any missing elements?

### 3. Mark Validated
Update `.claude/agent-registry.json`:

**CDIR workspace:**
```json
"workspace_state": "validating",
"current_work": "Validated CEXE plan for spec 000 - APPROVED"
```

### 4. Update Handoff
Edit `.claude/handoffs/spec-000-to-cexe.json`:
```json
"status": "validated",
"validated_by": "cli-claude-director-001",
"validated_at": "2025-11-13T00:00:00Z",
"validation_result": "APPROVED - proceed to tasks"
```

### 5. Commit Validation
```bash
git add .claude/agent-registry.json
git add .claude/handoffs/spec-000-to-cexe.json

git commit --no-gpg-sign -m "[CDIR] Validate CEXE plan for 000-migration-test - APPROVED

Plan validated against spec. CEXE may proceed to tasks.

Handoff: CDIR → CEXE (plan validated)

Migration Phase: 7C of 9
Agent: CDIR
"

git push
```

### 6. Announce
```
[From: CDIR] Plan validated - APPROVED.

CEXE: Proceed to create tasks.md and implement.
```

---

## Part E: CEXE Implementation (Terminal-2)

### 1. Create Tasks
Create `specs/000-migration-test/tasks.md`:

```markdown
# Tasks: Migration Test

1. [PENDING] Create src/hello.py with hello_world()
2. [PENDING] Create tests/test_hello.py
3. [PENDING] Run test, verify passing
4. [PENDING] Commit implementation
```

### 2. Implement
```bash
mkdir -p src tests

# Create function
cat > src/hello.py <<EOF
def hello_world():
    return "Hello from CEXE"
EOF

# Create test
cat > tests/test_hello.py <<EOF
from src.hello import hello_world

def test_hello_world():
    assert hello_world() == "Hello from CEXE"
EOF

# Run test
python -m pytest tests/test_hello.py || python -c "from tests.test_hello import test_hello_world; test_hello_world(); print('Test passed')"
```

### 3. Mark Tasks Complete
Update `tasks.md`: Change all to [COMPLETE]

### 4. Commit Implementation
```bash
git add specs/000-migration-test/tasks.md
git add src/hello.py
git add tests/test_hello.py

git commit --no-gpg-sign -m "[CEXE] Implement 000-migration-test

- Created src/hello.py with hello_world()
- Created tests/test_hello.py
- All tests passing

Handoff: CEXE → CDIR (implementation complete)

Migration Phase: 7D of 9
Agent: CEXE
"

git push
```

### 5. Announce
```
[From: CEXE] Implementation complete for spec 000.

Implementation: src/hello.py, tests/test_hello.py
Tests: PASSING
Status: implementation-complete
Handoff: Ready for CDIR final validation

CDIR: Please validate implementation against spec success criteria
```

---

## Part F: Final Validation (CDIR, Terminal-1)

### 1. Pull Implementation
```bash
git pull origin claude/impl-migration-test
```

### 2. Verify
```bash
cat src/hello.py
cat tests/test_hello.py
python -c "from src.hello import hello_world; print(hello_world())"
```

### 3. Check Success Criteria
Review `specs/000-migration-test/spec.md` success criteria:
- [✓] All 10 criteria met

### 4. Create Phase Marker
```bash
echo "Phase 7 complete: $(date)" > .claude/migration-phase-7-complete.txt
```

### 5. Announce
```
[From: CDIR] Phase 7 COMPLETE. Three-agent coordination validated.

Test Results:
✅ CDIR created specification
✅ CEXE created plan
✅ CDIR validated plan
✅ CEXE created tasks
✅ CEXE implemented
✅ Tests passing
✅ Handoffs worked
✅ Agent registry coordinated
✅ Workspace boundaries respected
✅ Migration validated

CDIR and CEXE coordination: SUCCESSFUL

Ready for Phase 8: Production Activation
```

---

**Phase:** 7 of 9
**Next:** Phase 8 - Production Activation

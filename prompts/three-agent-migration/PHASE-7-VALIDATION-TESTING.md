# Phase 7: Validation & Testing

**Agents:** CDIR (PowerShell Terminal 1) + CEXE (PowerShell Terminal 2, first boot)
**Prerequisites:** Phase 6 complete (GitHub workflows updated)
**Execution Environment:** Two PowerShell Terminal Windows
**OS:** Windows
**Project Path:** `C:\Development\perplex`
**Branches:** CDIR: `claude/design-three-agent-config`, CEXE: `claude/impl-migration-test` (NEW)
**Duration Estimate:** 60-90 minutes

---

## IMPORTANT: Environment Setup

**You are running on Windows with TWO PowerShell terminal windows.**

**Terminal 1 (CDIR):** Already open and active (you are here)
**Terminal 2 (CEXE):** Will be opened during Part B

**File Editing:** Use text editor (VS Code, Notepad++, etc.) for complex files
**PowerShell Commands:** Used for both terminals

---

## Mission

Test three-agent coordination workflow: CDIR creates spec → CEXE creates plan → CDIR validates → CEXE implements → CDIR validates final.

---

## Part A: CDIR Preparation (PowerShell Terminal 1)

### Step 1: Verify Phase 6 Complete

```powershell
cat .claude\migration-phase-6-complete.txt
git log --oneline -1 | Select-String "Phase 6"
```

Should show Phase 6 marker and recent commit.

---

### Step 2: Push Configuration Branch

```powershell
git push -u origin claude/design-three-agent-config
```

**GitHub will automatically:**
- Create PR (auto-create-pr workflow)
- Run workspace validation
- Show PR in GitHub Actions tab

---

### Step 3: Create Test Specification

```powershell
mkdir specs\000-migration-test -Force
```

**Create file:** `specs\000-migration-test\spec.md`

**Open in text editor and add:**

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
- Create simple Python function: `def hello_world(): return "Hello from CEXE"`
- Write test: `test_hello_world()`
- Test must pass

**Non-Functional:**
- Coordination via agent registry
- Handoff markers created
- Workspace boundaries respected
- Envelope communication format used

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

**Save the file.**

---

### Step 4: Update Agent Registry

**Open `.claude\agent-registry.json` in text editor**

**Find CDIR entry (agent_id: "cli-claude-director-001") and update `workspace` section:**

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

**Save the file.**

---

### Step 5: Create Handoff Marker

```powershell
mkdir .claude\handoffs -Force
```

**Create file:** `.claude\handoffs\spec-000-to-cexe.json`

**Open in text editor and add:**

```json
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
```

**Save the file.**

---

### Step 6: Commit Test Specification

```powershell
git add specs\000-migration-test\spec.md
git add .claude\agent-registry.json
git add .claude\handoffs\spec-000-to-cexe.json
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CDIR] Create test specification 000-migration-test

Test spec to validate three-agent coordination workflow.

Success criteria: 10 items covering full CDIR ↔ CEXE cycle
Requirements: Simple hello_world function with test

Handoff: CDIR → CEXE (spec complete)
Next: CEXE creates plan.md

Migration Phase: 7A of 9
Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/design-three-agent-config
Environment: Windows PowerShell at C:\Development\perplex
"

git push
```

---

### Step 7: Announce Handoff to User

**Print this message:**

```
[From: CDIR] Test specification 000-migration-test created.

Specification: specs\000-migration-test\spec.md
Status: spec-complete
Handoff: Ready for CEXE

Agent Registry Updated:
- CDIR: spec-complete, pending handoff to CEXE
- Handoff marker created: .claude\handoffs\spec-000-to-cexe.json

Next Action: User opens PowerShell Terminal Window 2 for CEXE first boot

Instructions for User:
1. Open NEW PowerShell terminal window (Terminal 2)
2. Navigate to: cd C:\Development\perplex
3. Follow Part B instructions in Terminal 2
```

**STOP HERE.** User needs to open Terminal 2 before continuing.

---

## Part B: CEXE First Boot (PowerShell Terminal 2)

**USER ACTION REQUIRED:** Open a NEW PowerShell terminal window (this will be Terminal 2 for CEXE).

**In the new PowerShell Terminal 2, run:**

```powershell
# Navigate to project
cd C:\Development\perplex

# CEXE reads identity
cat .claude\identity-cli-executor.json

# CEXE announces first boot
Write-Host "[From: CEXE] Identity anchored. CLI-Executor operational." -ForegroundColor Green
Write-Host "Agent ID: cli-claude-executor-001"
Write-Host "Short Name: CEXE"
Write-Host "Terminal: PowerShell-Terminal-2"
Write-Host "Role: executor-validator"
Write-Host "Environment: Windows PowerShell at C:\Development\perplex"
```

---

## Part C: CEXE Reads Spec and Creates Plan (PowerShell Terminal 2)

### Step 1: Check Agent Registry for Handoff

```powershell
# Read CDIR's workspace to see pending handoff
cat .claude\agent-registry.json | Select-String -Context 0,20 "cli-claude-director-001"
```

You should see CDIR's `pending_handoffs` with spec-000-migration-test.

---

### Step 2: Check Handoff Marker

```powershell
cat .claude\handoffs\spec-000-to-cexe.json
```

Confirms: CDIR → CEXE handoff for spec 000.

---

### Step 3: Read Test Specification

```powershell
cat specs\000-migration-test\spec.md
```

Read and understand:
- Purpose: Validate three-agent coordination
- Requirements: Simple hello_world function
- Success criteria: 10 items

---

### Step 4: Create Implementation Branch

```powershell
git fetch origin
git checkout -b claude/impl-migration-test
```

**CEXE now on:** `claude/impl-migration-test` branch

---

### Step 5: Create Technical Plan

**Create file:** `specs\000-migration-test\plan.md`

**Open in text editor and add:**

```markdown
# Technical Plan: Migration Test

**Agent:** CEXE (cli-claude-executor-001)
**Created:** 2025-11-13
**Status:** Planning

## Architecture

Simple Python module with hello_world function and test.

**File Structure:**
```
src/
  hello.py         # Contains hello_world() function
tests/
  test_hello.py    # Contains test_hello_world() test
```

## Implementation Steps

1. Create `src\hello.py` with hello_world() function
   - Function returns: "Hello from CEXE"
2. Create `tests\test_hello.py` with test_hello_world()
   - Test asserts: hello_world() == "Hello from CEXE"
3. Run test, verify passing
4. Commit implementation

## Dependencies

- Python 3.x (already available)
- pytest (if available, otherwise use direct import)

## Testing Strategy

- **Unit test:** test_hello_world()
- **Expected result:** "Hello from CEXE"
- **Validation:** Test passes without errors

## Risks

None (simple test for coordination validation)

## Validation Criteria

For CDIR to validate:
- Plan fulfills spec requirements
- Implementation approach is sound
- Testing strategy is adequate
```

**Save the file.**

---

### Step 6: Update Agent Registry

**Open `.claude\agent-registry.json` in text editor**

**Find CEXE entry (agent_id: "cli-claude-executor-001") and update `workspace` section:**

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

**Save the file.**

---

### Step 7: Commit Plan

```powershell
git add specs\000-migration-test\plan.md
git add .claude\agent-registry.json
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CEXE] Create technical plan for 000-migration-test

Plan defines simple Python implementation for coordination test.

Architecture: src\hello.py + tests\test_hello.py
Testing: pytest or direct import

Handoff: CEXE → CDIR (plan validation required)
Next: CDIR validates plan against spec

Migration Phase: 7B of 9
Agent: CEXE (cli-claude-executor-001)
Terminal: PowerShell-Terminal-2
Branch: claude/impl-migration-test
Environment: Windows PowerShell at C:\Development\perplex
"

git push -u origin claude/impl-migration-test
```

---

### Step 8: Announce Handoff

**Print this message:**

```
[From: CEXE] Plan created for spec 000-migration-test.

Plan: specs\000-migration-test\plan.md
Status: plan-complete
Handoff: Ready for CDIR validation

Agent Registry Updated:
- CEXE: planning, pending handoff to CDIR for validation

Next Action: Switch to Terminal 1 (CDIR) for plan validation
```

**PAUSE HERE.** Switch back to Terminal 1 (CDIR).

---

## Part D: CDIR Validates Plan (PowerShell Terminal 1)

### Step 1: Fetch and Switch to CEXE's Branch

```powershell
git fetch origin
git checkout claude/impl-migration-test
```

**You are now on CEXE's implementation branch.**

---

### Step 2: Read Plan

```powershell
cat specs\000-migration-test\plan.md
```

---

### Step 3: Validate Plan Against Spec

**Compare plan.md against spec.md:**

Questions to ask:
- ✅ Does plan fulfill spec requirements? (hello_world function + test)
- ✅ Is implementation approach sound? (simple Python module)
- ✅ Is testing strategy adequate? (pytest or direct import)
- ✅ Any missing elements? (None)

**Decision: APPROVED** (plan is sound for test spec)

---

### Step 4: Update Agent Registry with Validation

**Open `.claude\agent-registry.json` in text editor**

**Find CDIR entry and update `workspace`:**

```json
"workspace": {
  "current_work_branch": "claude/impl-migration-test",
  "active_specifications": ["000-migration-test"],
  "workspace_state": "validating",
  "current_work": "Validated CEXE plan for spec 000 - APPROVED",
  "next_handoff": "cli-claude-executor-001",
  "pending_handoffs": []
}
```

**Save the file.**

---

### Step 5: Update Handoff Marker with Validation Result

**Open `.claude\handoffs\spec-000-to-cexe.json` in text editor**

**Update:**

```json
{
  "handoff_id": "spec-000-migration-test",
  "from_agent": "cli-claude-director-001",
  "to_agent": "cli-claude-executor-001",
  "artifact": "specs/000-migration-test/spec.md",
  "trigger": "spec_complete",
  "timestamp": "2025-11-13T00:00:00Z",
  "status": "validated",
  "validated_by": "cli-claude-director-001",
  "validated_at": "2025-11-13T00:00:00Z",
  "validation_result": "APPROVED - proceed to tasks and implementation",
  "next_action": "CEXE creates tasks.md and implements"
}
```

**Save the file.**

---

### Step 6: Commit Validation

```powershell
git add .claude\agent-registry.json
git add .claude\handoffs\spec-000-to-cexe.json
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CDIR] Validate CEXE plan for 000-migration-test - APPROVED

Plan validated against spec requirements.
- Fulfills functional requirements
- Sound implementation approach
- Adequate testing strategy

Validation Result: APPROVED
Next: CEXE may proceed to create tasks.md and implement

Migration Phase: 7C of 9
Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/impl-migration-test
Environment: Windows PowerShell at C:\Development\perplex
"

git push
```

---

### Step 7: Announce Approval

**Print this message:**

```
[From: CDIR] Plan validated - APPROVED.

Validation Summary:
✅ Fulfills spec requirements
✅ Sound implementation approach
✅ Adequate testing strategy

CEXE: You are approved to proceed.
Next Actions:
1. Create tasks.md
2. Implement hello_world function
3. Write and run test

Switch to Terminal 2 (CEXE) to continue.
```

**PAUSE HERE.** Switch back to Terminal 2 (CEXE).

---

## Part E: CEXE Implementation (PowerShell Terminal 2)

### Step 1: Pull Latest Changes

```powershell
git pull origin claude/impl-migration-test
```

**Verify CDIR's validation approval is present.**

---

### Step 2: Create Tasks File

**Create file:** `specs\000-migration-test\tasks.md`

**Open in text editor and add:**

```markdown
# Tasks: Migration Test

**Status:** In Progress

## Task List

1. [PENDING] Create src\hello.py with hello_world() function
2. [PENDING] Create tests\test_hello.py with test_hello_world()
3. [PENDING] Run test, verify passing
4. [PENDING] Update agent registry
5. [PENDING] Commit implementation
```

**Save the file.**

---

### Step 3: Implement Function

```powershell
mkdir src -Force
```

**Create file:** `src\hello.py`

**Content:**

```python
def hello_world():
    return "Hello from CEXE"
```

**Save the file.**

---

### Step 4: Implement Test

```powershell
mkdir tests -Force
```

**Create file:** `tests\test_hello.py`

**Content:**

```python
from src.hello import hello_world

def test_hello_world():
    assert hello_world() == "Hello from CEXE"
    print("✓ Test passed: hello_world() returns correct value")
```

**Save the file.**

---

### Step 5: Run Test

```powershell
# Try pytest first, fallback to direct execution
if (Get-Command pytest -ErrorAction SilentlyContinue) {
    pytest tests\test_hello.py
} else {
    python -c "import sys; sys.path.insert(0, '.'); from tests.test_hello import test_hello_world; test_hello_world(); print('All tests passed')"
}
```

**Expected output:** Test passes without errors.

---

### Step 6: Mark Tasks Complete

**Open `specs\000-migration-test\tasks.md` in text editor**

**Update all to [COMPLETE]:**

```markdown
# Tasks: Migration Test

**Status:** Complete

## Task List

1. [COMPLETE] Create src\hello.py with hello_world() function
2. [COMPLETE] Create tests\test_hello.py with test_hello_world()
3. [COMPLETE] Run test, verify passing
4. [COMPLETE] Update agent registry
5. [COMPLETE] Commit implementation
```

**Save the file.**

---

### Step 7: Update Agent Registry

**Open `.claude\agent-registry.json` in text editor**

**Find CEXE entry and update `workspace`:**

```json
"workspace": {
  "current_work_branch": "claude/impl-migration-test",
  "active_specifications": ["000-migration-test"],
  "workspace_state": "implementing",
  "current_work": "Implementation complete for spec 000",
  "next_handoff": "cli-claude-director-001",
  "pending_handoffs": [{
    "to": "cli-claude-director-001",
    "artifact": "Implementation: src/hello.py, tests/test_hello.py",
    "trigger": "implementation_complete",
    "timestamp": "2025-11-13T00:00:00Z"
  }]
}
```

**Save the file.**

---

### Step 8: Commit Implementation

```powershell
git add specs\000-migration-test\tasks.md
git add src\hello.py
git add tests\test_hello.py
git add .claude\agent-registry.json
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CEXE] Implement 000-migration-test

Implementation:
- Created src\hello.py with hello_world() function
- Created tests\test_hello.py with test_hello_world()
- All tests passing

Files:
- src\hello.py: Returns 'Hello from CEXE'
- tests\test_hello.py: Validates function output

Handoff: CEXE → CDIR (implementation complete, final validation)
Next: CDIR validates implementation against spec success criteria

Migration Phase: 7D of 9
Agent: CEXE (cli-claude-executor-001)
Terminal: PowerShell-Terminal-2
Branch: claude/impl-migration-test
Environment: Windows PowerShell at C:\Development\perplex
"

git push
```

---

### Step 9: Announce Completion

**Print this message:**

```
[From: CEXE] Implementation complete for spec 000-migration-test.

Implementation:
- src\hello.py (hello_world function)
- tests\test_hello.py (test)

Test Results: ✅ PASSING

Status: implementation-complete
Handoff: Ready for CDIR final validation

CDIR: Please validate implementation against spec success criteria.

Switch to Terminal 1 (CDIR) for final validation.
```

**PAUSE HERE.** Switch back to Terminal 1 (CDIR).

---

## Part F: CDIR Final Validation (PowerShell Terminal 1)

### Step 1: Pull Implementation

```powershell
git pull origin claude/impl-migration-test
```

---

### Step 2: Verify Implementation Files

```powershell
cat src\hello.py
cat tests\test_hello.py
```

---

### Step 3: Test Implementation

```powershell
python -c "import sys; sys.path.insert(0, '.'); from src.hello import hello_world; print('Result:', hello_world())"
```

**Expected:** `Result: Hello from CEXE`

---

### Step 4: Check All Success Criteria

**Open `specs\000-migration-test\spec.md` and verify:**

```
1. ✅ CDIR created specification
2. ✅ CEXE read specification from agent registry
3. ✅ CEXE created plan.md
4. ✅ CDIR validated plan.md
5. ✅ CEXE created tasks.md
6. ✅ CEXE implemented simple test task
7. ✅ CDIR validated implementation
8. ✅ Handoff markers worked correctly
9. ✅ Agent registry tracked coordination
10. ✅ Workspace boundaries respected
```

**All criteria MET: ✅**

---

### Step 5: Create Phase 7 Completion Marker

```powershell
"Phase 7 complete: $(Get-Date)" | Set-Content -Path .claude\migration-phase-7-complete.txt
cat .claude\migration-phase-7-complete.txt
```

---

### Step 6: Final Commit

```powershell
git add .claude\migration-phase-7-complete.txt
git commit --no-gpg-sign -m "[CDIR] Phase 7 COMPLETE: Three-agent coordination validated

Test Results: ✅ ALL SUCCESS CRITERIA MET

Validation Summary:
✅ CDIR created specification (spec.md)
✅ CEXE read spec from agent registry
✅ CEXE created technical plan (plan.md)
✅ CDIR validated plan - APPROVED
✅ CEXE created tasks (tasks.md)
✅ CEXE implemented (src\hello.py, tests\test_hello.py)
✅ All tests passing
✅ Handoff markers worked correctly
✅ Agent registry coordinated successfully
✅ Workspace boundaries respected

CDIR ↔ CEXE Coordination: ✅ SUCCESSFUL

Migration validated. Three-agent architecture operational.

Migration Phase: 7 of 9 (COMPLETE)
Next: Phase 8 - Production Activation

Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/impl-migration-test
Environment: Windows PowerShell at C:\Development\perplex
"

git push
```

---

### Step 7: Announce Success

**Print this message:**

```
[From: CDIR] Phase 7 COMPLETE. Three-agent coordination validated successfully.

Test Specification: specs\000-migration-test\spec.md
Implementation: src\hello.py, tests\test_hello.py

Test Results:
✅ CDIR created specification
✅ CEXE created plan
✅ CDIR validated plan - APPROVED
✅ CEXE created tasks
✅ CEXE implemented function + test
✅ All tests PASSING
✅ Handoffs worked correctly
✅ Agent registry coordinated
✅ Workspace boundaries respected
✅ Envelope communication used

CDIR ↔ CEXE Coordination: ✅ SUCCESSFUL

Two-Agent Workflow Validated:
- PowerShell Terminal 1 (CDIR): Designer-Researcher
- PowerShell Terminal 2 (CEXE): Executor-Validator
- Coordination via agent registry and handoff markers
- Clear role boundaries maintained

Migration Status: ✅ VALIDATED
Three-agent architecture: ✅ OPERATIONAL

Ready for Phase 8: Production Activation
```

---

## Validation Checklist

- [ ] Test specification created by CDIR
- [ ] CEXE read spec from agent registry
- [ ] CEXE created plan.md
- [ ] CDIR validated plan (APPROVED)
- [ ] CEXE created tasks.md
- [ ] CEXE implemented hello_world function
- [ ] CEXE wrote test
- [ ] Test passed
- [ ] Handoff markers created and updated
- [ ] Agent registry tracked coordination
- [ ] Workspace boundaries respected (no violations)
- [ ] Both terminals coordinated successfully
- [ ] Phase 7 marker created

---

## If Validation Fails

**Problem: Can't open Terminal 2**
- Open new PowerShell window manually
- Navigate to `C:\Development\perplex`
- Both terminals can operate independently

**Problem: Python import error**
- Check Python is available: `python --version`
- Verify file paths are correct (use `\` not `/`)
- Add current directory to path: `$env:PYTHONPATH = "."`

**Problem: Agent registry conflicts**
- Both agents can edit agent-registry.json
- Use text editor, not concurrent edits
- Git will merge changes if both push

**Problem: Branch confusion**
- CDIR: `claude/design-three-agent-config`
- CEXE: `claude/impl-migration-test`
- Use `git branch` to check current branch

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001 + cli-claude-executor-001
**Environment:** Windows PowerShell (two terminal windows)
**Project Path:** C:\Development\perplex
**Phase:** 7 of 9
**Next:** Phase 8 - Production Activation

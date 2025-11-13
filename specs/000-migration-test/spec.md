# Feature Specification: Three-Agent Migration Test

**Feature ID:** 000-migration-test
**Status:** Draft
**Owner:** CDIR (cli-claude-director-001)
**Created:** 2025-11-13
**Phase:** Migration Testing

---

## Overview

This is a minimal test specification to validate the three-agent coordination workflow (CDIR → CEXE → CDIR handoff cycle) during the migration to the new architecture.

## Purpose

Validate that:
1. CDIR can create specifications and hand off to CEXE
2. CEXE can receive handoff, create plan, and implement
3. Agent registry coordination works correctly
4. Handoff markers function as expected
5. Workspace boundaries are enforced
6. GitHub workflows recognize all three agents correctly

## Scope

**In Scope:**
- Simple Python function implementation: `hello_world()`
- Test file creation: `tests/test_hello.py`
- Agent registry updates
- Handoff marker creation
- Full CDIR → CEXE → CDIR cycle

**Out of Scope:**
- Complex implementation logic
- Production features
- Extensive testing scenarios

## Requirements

### Functional Requirements

**FR-1: Hello World Function**
- Function name: `hello_world()`
- Location: `src/hello.py`
- Returns: String `"Hello from CEXE"`
- No parameters

**FR-2: Test Coverage**
- Test file: `tests/test_hello.py`
- Single test: `test_hello_world()`
- Validates return value matches expected string

### Non-Functional Requirements

**NFR-1: Coordination Protocol**
- Agent registry must be updated at each handoff
- Handoff markers must be created with correct metadata
- Workspace boundaries must be respected (CDIR owns spec.md, CEXE owns plan.md/tasks.md/src/)

**NFR-2: GitHub Integration**
- PRs created automatically for each agent's branch
- Workflow validation passes
- Agent attribution visible in PR titles and comments

## Success Criteria

1. ✅ Specification created by CDIR
2. ⬜ Handoff marker created: `.claude/handoffs/spec-000-to-cexe.json`
3. ⬜ CEXE receives handoff and creates plan: `specs/000-migration-test/plan.md`
4. ⬜ CEXE creates tasks: `specs/000-migration-test/tasks.md`
5. ⬜ CEXE implements: `src/hello.py` and `tests/test_hello.py`
6. ⬜ Tests pass: `pytest tests/test_hello.py`
7. ⬜ CDIR validates implementation matches specification
8. ⬜ Agent registry shows correct state transitions
9. ⬜ GitHub workflows detect agents correctly (CDIR/CEXE branch patterns)
10. ⬜ No workspace boundary violations

## Technical Design

### Implementation Details

**File Structure:**
```
src/
  hello.py          # CEXE implements
tests/
  test_hello.py     # CEXE implements
specs/000-migration-test/
  spec.md           # CDIR owns (this file)
  plan.md           # CEXE creates
  tasks.md          # CEXE creates
  implementation/   # CEXE working directory
```

**Function Signature:**
```python
def hello_world() -> str:
    """Return greeting message from CEXE agent."""
    return "Hello from CEXE"
```

**Test Signature:**
```python
def test_hello_world():
    """Test that hello_world returns expected greeting."""
    from src.hello import hello_world
    assert hello_world() == "Hello from CEXE"
```

### Coordination Protocol

**Agent Registry Updates:**
- CDIR: Update status to "waiting" after creating spec
- CEXE: Update status to "active" when receiving handoff
- CEXE: Update status to "waiting" after implementation
- CDIR: Update status to "active" during validation

**Handoff Markers:**
- `.claude/handoffs/spec-000-to-cexe.json` - CDIR → CEXE
- `.claude/handoffs/impl-000-to-cdir.json` - CEXE → CDIR

### Validation Criteria

**CDIR Validation (Final):**
- Function exists at `src/hello.py`
- Test exists at `tests/test_hello.py`
- Tests pass with `pytest`
- Implementation matches specification exactly
- No workspace boundary violations
- Agent registry reflects complete cycle

## Dependencies

- Python 3.x installed
- pytest available
- Git repository initialized
- Agent registry file exists: `.claude/agent-registry.json`
- GitHub workflows configured for three-agent architecture

## Risks and Mitigations

**Risk:** Agent registry conflicts during concurrent updates
**Mitigation:** Sequential handoff protocol prevents concurrent modifications

**Risk:** Workspace boundary violations
**Mitigation:** Clear ownership defined, validation enforced in GitHub workflows

**Risk:** GitHub workflow failures due to misconfiguration
**Mitigation:** Phase 6 already updated all workflows, validation tested in Phase 7

## Timeline

- CDIR specification: 10 minutes
- CEXE planning: 15 minutes
- CEXE implementation: 20 minutes
- CDIR validation: 10 minutes
- **Total:** ~55 minutes for full cycle

## Notes

This is a migration validation test, not a production feature. The goal is to validate coordination mechanisms work correctly before proceeding with production activation in Phase 8.

**Handoff to CEXE:** After CDIR creates handoff marker, CEXE will receive this specification and create technical plan (plan.md) and atomic tasks (tasks.md) in this directory.

---

**Created by:** CDIR (cli-claude-director-001)
**Date:** 2025-11-13
**Status:** Ready for handoff to CEXE

# Foundation Validation Checklist

Use this checklist to validate alignment with foundation imperatives before committing significant work.

---

## Core Documents

- [ ] `/FOUNDATION.md` exists and is current
- [ ] `/docs/PRODUCT_VISION.md` exists and reflects true intent
- [ ] `/sessions/CURRENT_STATUS.md` exists and is updated
- [ ] `/config/project.yml` exists with accurate configuration
- [ ] `/config/ai-agent.yml` exists with operational parameters

---

## Directory Structure

- [ ] `/config` - Configuration files present
- [ ] `/decisions` - ADR system in place
- [ ] `/docs` - Documentation exists
- [ ] `/knowledge` - Knowledge base structure present
- [ ] `/sessions` - Session logs exist
- [ ] `/src` - Source directory ready (even if empty)
- [ ] `/tools` - Automation scripts present and executable
- [ ] `/examples` - Examples directory created
- [ ] `/.claude` - Claude Code config ready

---

## Automation & Tools

- [ ] `tools/session-start.sh` exists and is executable
- [ ] `tools/session-end.sh` exists and is executable
- [ ] `tools/validate-foundation.sh` exists and is executable
- [ ] `tools/generate-status.sh` exists and is executable
- [ ] All scripts run without errors
- [ ] Scripts provide useful output

---

## Git & Version Control

- [ ] Git repository initialized
- [ ] Working on correct branch
- [ ] `.gitignore` appropriate for project type
- [ ] Commits have clear, descriptive messages
- [ ] No sensitive data in repository
- [ ] Remote repository connected

---

## Foundation Imperatives Alignment

### 1. Holistic System Thinking

Ask yourself:
- [ ] Have I considered ripple effects of this change?
- [ ] Do I understand how this affects other components?
- [ ] Have I thought through long-term implications?
- [ ] Are there emergent behaviors I should consider?

### 2. AI-First

Validate:
- [ ] Can a fresh AI session understand this without human explanation?
- [ ] Is context preserved for future sessions?
- [ ] Does this enable autonomous AI operation?
- [ ] Is documentation machine-readable AND human-readable?

### 3. Configurability

Check:
- [ ] Are behavioral settings in `/config` not hardcoded?
- [ ] Are configuration files documented?
- [ ] Can behavior be changed without code changes?
- [ ] Are environment-specific settings separated?

### 4. Modularity

Verify:
- [ ] Are component boundaries clear?
- [ ] Can components evolve independently?
- [ ] Is each module focused on single responsibility?
- [ ] Are dependencies minimal and explicit?

### 5. Extensibility

Confirm:
- [ ] Can new capabilities be added without core changes?
- [ ] Are extension points identified?
- [ ] Will this design accommodate future unknowns?
- [ ] Does this close off options prematurely?

### 6. Integration

Ensure:
- [ ] Are interfaces for component communication defined?
- [ ] Are data formats consistent and documented?
- [ ] Can external systems integrate if needed?
- [ ] Are integration assumptions documented?

### 7. Automation

Validate:
- [ ] Are repetitive tasks scripted?
- [ ] Can common operations run without human intervention?
- [ ] Are manual processes documented as automation candidates?
- [ ] Do automation tools handle errors gracefully?

---

## Documentation Quality

- [ ] Documentation matches reality (no stale docs)
- [ ] New capabilities are documented
- [ ] Changes to existing capabilities are reflected
- [ ] Decision rationale is captured (ADRs)
- [ ] Examples are provided where helpful
- [ ] Documentation explains "why" not just "what"

---

## Session Continuity

- [ ] Session log exists for current work
- [ ] Session log documents significant actions
- [ ] Discoveries and learnings are captured
- [ ] Blockers are noted
- [ ] Next steps are clear
- [ ] `CURRENT_STATUS.md` will be updated at session end

---

## Product Vision Alignment

- [ ] Work aligns with documented product vision
- [ ] Changes don't conflict with core principles
- [ ] Non-negotiables are preserved
- [ ] If vision changed, it's documented with rationale
- [ ] Human partner would agree with direction

---

## Decision Logging

For significant decisions:
- [ ] ADR created in `/decisions`
- [ ] Context provided for future understanding
- [ ] Alternatives considered and documented
- [ ] Consequences (positive/negative) documented
- [ ] Foundation alignment checked
- [ ] Related decisions cross-referenced

---

## Progress Tracking

- [ ] Milestones document reflects current state
- [ ] Completed work is marked as done
- [ ] Active todos are tracked
- [ ] Progress is visible to human partner
- [ ] Blockers are documented

---

## Pre-Commit Validation

Before committing:
- [ ] All changed files are intentional
- [ ] No debug code or temporary files included
- [ ] Commit message is clear and descriptive
- [ ] Foundation validation script passes
- [ ] Documentation is updated
- [ ] Session log is current

---

## Usage Instructions

### For AI Agents

**When to use this checklist:**
- Before committing significant work
- When completing a milestone
- At end of session before finalizing
- When making architectural decisions
- If unsure about alignment

**How to use:**
1. Read through entire checklist
2. Mark items as complete honestly
3. Address any failures before proceeding
4. Document any intentional exceptions with rationale
5. Include checklist completion in session log

### For Humans

Use this checklist to:
- Audit AI agent work
- Validate foundation integrity
- Ensure principles are maintained
- Check project health

---

## Checklist Maintenance

This checklist should evolve:
- Add items as new patterns emerge
- Remove items that prove unnecessary
- Refine questions based on learnings
- Update when foundation imperatives change

**Last Updated:** 2025-11-10

---

*When in doubt, err on the side of over-documentation and transparency.*

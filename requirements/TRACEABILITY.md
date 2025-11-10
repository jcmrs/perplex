# Traceability Matrix

**Purpose:** Track relationships between vision, requirements, decisions, and implementation.

**Last Updated:** 2025-11-10

---

## How to Read This

```
Vision Element
  → Requirement (REQ-XXX)
    → Decision (ADR-XXX)
      → Implementation (file:line)
        → Validation (test/check)
```

This shows the complete chain from "what we want" to "proof it works."

---

## Product Vision → Requirements

### Vision: Seamless AI-to-AI Collaboration

**Requirements:**
- *No requirements defined yet - still in foundation/discovery phase*

### Vision: Project-Specific Research Organization

**Requirements:**
- *No requirements defined yet*

### Vision: Context Isolation and Preservation

**Requirements:**
- *No requirements defined yet*

---

## Requirements → Decisions

### REQ-XXX: [Requirement Title]

**Addressed by:**
- ADR-XXX: [Decision title]

---

## Decisions → Implementation

### ADR-001: Discovery-Driven Methodology

**Implementation:**
- `config/project.yml` - Methodology configuration
- `docs/MILESTONES.md` - Phased approach
- Session logs structure - Learning tracking

**Validation:**
- Foundation validation script checks structure
- Session logs demonstrate discovery approach

---

## Implementation → Validation

### Component: Session Continuity System

**Validates Requirements:**
- *(Foundation phase - no formal requirements yet)*

**Validation Method:**
- `tools/validate-foundation.sh` checks existence
- Session start/end scripts verify functionality

---

## Orphaned Elements (Gaps)

### Decisions Without Requirements
- ADR-001 (methodology) - Pre-dates requirement system

### Requirements Without Implementation
- *(No requirements defined yet)*

### Implementation Without Requirements
- Foundation infrastructure - Built before requirements system

**Note:** During discovery phase, this is expected. As we move to implementation, orphaned elements indicate gaps.

---

## Traceability Health Check

**Questions to ask:**
- [ ] Does every requirement trace to vision?
- [ ] Does every decision address a requirement?
- [ ] Does every implementation fulfill a requirement?
- [ ] Is every requirement validated?

**Current Status:**
Foundation phase - Traceability system established, but no formal requirements yet. This is expected and appropriate for discovery phase.

---

## For AI Agents

**When adding requirements:**
1. Link to vision element
2. Create this traceability entry
3. Update when decisions made
4. Update when implemented
5. Update when validated

**When making decisions:**
1. Reference which requirement(s) it addresses
2. Update traceability

**When implementing:**
1. Reference requirement ID in code/commits
2. Update implementation section here

**Regular checks:**
Run through traceability matrix to ensure no orphans.

---

## For Humans

This matrix shows the complete "chain of reasoning" from product vision down to actual code. If the chain breaks anywhere, we have drift.

---

*Traceability is tedious but critical. It prevents building the wrong thing well.*

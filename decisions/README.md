# Architecture Decision Records (ADRs)

**Purpose:** Document significant decisions with context, rationale, and consequences.

## Why This Exists

- **AI-First:** Future Claude sessions need to understand WHY decisions were made
- **Holistic Thinking:** Documents ripple effects and trade-offs
- **Learning:** Captures mistakes and learnings for institutional memory

## Structure

Each decision is a markdown file: `YYYY-MM-DD-decision-title.md`

### Template

```markdown
# [Decision Number]. [Decision Title]

**Date:** YYYY-MM-DD
**Status:** [Proposed | Accepted | Deprecated | Superseded]
**Deciders:** [Who was involved]

## Context

What is the issue we're trying to address?

## Decision

What is the change that we're proposing/have agreed to?

## Rationale

Why this decision over alternatives?

## Consequences

### Positive
- What becomes easier/better?

### Negative
- What becomes harder/worse?

### Neutral
- What changes without clear positive/negative?

## Alternatives Considered

What other options did we evaluate?

## Foundation Alignment

How does this align with our imperatives?
- Holistic System Thinking:
- AI-First:
- Configurability:
- Modularity:
- Extensibility:
- Integration:
- Automation:

## Related Decisions

Links to related ADRs

## Notes

Additional context or future considerations
```

## For AI Agents

1. Read recent ADRs at session start for context
2. Create new ADR for any significant architectural decision
3. Reference ADR numbers in commits

## For Humans

Review ADRs to understand project evolution and decision history.

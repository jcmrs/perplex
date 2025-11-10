# Ideas Directory

**Purpose:** Lightweight capture of ideas generated throughout the project lifecycle.

## Philosophy

Ideas emerge organically during:
- Conversations and discussions
- Problem-solving moments
- Research and discovery
- When encountering blockers
- During implementation

Both human partners and AI agents generate ideas. This system captures them without imposing heavy process.

## Workflow

### Capture (Lightweight)
When an idea emerges:
1. Create file: `ideas/YYYY-MM-DD-brief-title.md`
2. Use template (keep it simple)
3. Continue working

### Review Points
Check ideas when:
- Stuck on a problem
- Completing a phase
- Planning next steps
- Looking for alternatives
- During retrospectives

### Status Progression
- **New** - Just captured
- **Researching** - Actively exploring
- **Decided** - Became a decision (link to ADR)
- **Deferred** - On backburner
- **Discarded** - Not pursuing (with reason)
- **Implemented** - Became reality

## Structure

```
ideas/
├── README.md (this file)
├── TEMPLATE.md
├── YYYY-MM-DD-idea-title.md
└── INDEX.md (auto-generated list by status)
```

## Integration Points

- **To Decisions:** When idea becomes decision, create ADR and link
- **To Research:** Ideas can trigger research in `/knowledge/research`
- **To Roadmap:** Ideas can be incorporated into milestones
- **To Backlog:** Deferred ideas are essentially a backlog

## For AI Agents

**When to create an idea:**
- You think of a potential approach
- User mentions a possibility
- Research reveals an option
- Problem suggests alternative solutions

**Don't overthink it:** Just capture and continue. Review during natural break points.

## For Humans

Ideas aren't commitments. They're possibilities. Capturing them prevents losing potentially valuable thoughts while keeping focus on current work.

---

*Simple, lightweight, integrated. Ideas flow, we capture, we review when relevant.*

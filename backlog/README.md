# Backlog

**Purpose:** Track identified work that's not active yet but needs doing.

## What Is the Backlog?

The backlog is our "to-do list for later" - work we know needs to happen but isn't being actively worked on right now.

## Backlog vs. Other Systems

| System | Purpose | When Used |
|--------|---------|-----------|
| **Backlog** | Work identified but not active | "We know this needs doing, but not now" |
| **TodoWrite** | Active work RIGHT NOW | "I'm working on this in this session" |
| **Ideas** | Possibilities to explore | "This might be worth pursuing" |
| **Requirements** | What must be built | "The product MUST do this" |
| **Decisions** | What we decided | "We chose approach X over Y" |

## Workflow

### Adding to Backlog
When you identify work that needs doing:
1. Create item: `backlog/items/ITEM-XXX-brief-title.md`
2. Use template
3. Add to `BACKLOG.md` master list
4. Continue working

### Backlog Review
Regularly review backlog to:
- Re-prioritize items
- Move items to active work (TodoWrite)
- Discard items no longer relevant
- Update status based on context changes

### Activating Work
When ready to work on a backlog item:
1. Create TodoWrite entry
2. Update backlog item status to "Active"
3. Do the work
4. Mark backlog item as "Complete"

### Completing Work
When backlog work is done:
- Update item status to "Complete"
- Link to commits/PRs/ADRs
- Keep item for historical record

## Backlog Item Format

```
backlog/items/ITEM-XXX-brief-title.md
```

Sequential numbering: ITEM-001, ITEM-002, etc.

## Priority Levels

- **High:** Blocks other work or critical gap
- **Medium:** Important but not blocking
- **Low:** Nice to have, no urgency
- **Deferred:** Explicitly postponed to specific future phase

## Integration Points

**From Ideas:**
- Idea becomes concrete work → Create backlog item

**To Requirements:**
- Backlog item for implementation → Becomes requirement

**To Decisions:**
- Backlog item needs approach choice → Create ADR

**To TodoWrite:**
- Ready to work on backlog item → Activate in session

## For AI Agents

**When to add to backlog:**
- Discover technical debt
- Identify missing infrastructure
- Find gaps during implementation
- Defer work for later phase
- Low/medium priority items from discussions

**When NOT to use backlog:**
- Current session work (use TodoWrite)
- Possibilities to explore (use Ideas)
- Requirements for product (use Requirements)

**Backlog review frequency:**
- End of each phase
- When planning next session
- When blocked on current work

## For Humans

The backlog gives you visibility into:
- What work is outstanding
- What's been deferred and why
- Priority of pending work
- Progress as items complete

---

**Philosophy:** The backlog prevents "out of sight, out of mind." If work is identified, it's tracked until completed or explicitly discarded.

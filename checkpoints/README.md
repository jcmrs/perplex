# Checkpoint System

**Purpose:** Preserve project state at key moments to enable seamless session continuation and recovery.

## The Continuity Challenge

**Problem:** Claude Code sessions are stateless. When a session ends or crashes:
- Conversational context is lost
- Mental models disappear
- Nuanced understanding evaporates
- New sessions must rebuild context from scratch

**Solution:** Checkpoint + Memory Graph system that enables:
- Just-in-time context loading
- Selective file reading (guided by memory graph)
- Phase-based state preservation
- Quick resume after interruptions

## How It Works

### Checkpoint File
Curated summary of project state at a moment in time:
- Current phase and focus
- State summary (30-second version)
- Prioritized reading list
- Recent decisions and active work
- Mental models and key concepts
- What NOT to read (token efficiency)

### Memory Graph
JSON file mapping relationships and required context:
- What files matter for current phase
- Relationships between decisions/ideas/requirements
- Priority levels (critical/important/optional/skip)
- Section-specific references (not entire files)

### Resume Process
New session uses checkpoint as entry point:
1. Read checkpoint file (curated summary)
2. Load memory graph (relationship map)
3. Read only files/sections marked critical
4. Continue work with minimal context loss

## Just-in-Time Loading

**Traditional approach:**
- Read everything → hope it's relevant → waste tokens

**Checkpoint approach:**
- Read checkpoint → consult memory graph → read only what's needed
- Example: Discovery phase needs PRODUCT_VISION, ADR-001, active experiments
- Skip: All templates, old session logs, completed backlog items

**This is selective and sufficient.**

---

## Checkpoint Triggers

### Manual
```bash
./tools/create-checkpoint.sh "phase-complete" "Foundation complete, ready for discovery"
```

### Automated (Integrated)
- Phase completion (via session-end script)
- Major milestone completion
- Before risky operations
- Context window warnings (if detectable)

### GitHub Integration
- PR merge to main → checkpoint
- Release tags → checkpoint

---

## Directory Structure

```
checkpoints/
├── README.md (this file)
├── TEMPLATE.md (checkpoint template)
├── checkpoint-YYYYMMDD-HHMMSS.md (individual checkpoints)
├── checkpoint-YYYYMMDD-HHMMSS-graph.json (memory graphs)
└── LATEST.md (symlink to most recent checkpoint)
```

---

## Memory Graph Schema

```json
{
  "checkpoint_id": "foundation-complete",
  "timestamp": "2025-11-10T23:59:00Z",
  "phase": "foundation",
  "next_phase": "discovery",

  "critical_files": [
    {"path": "FOUNDATION.md", "reason": "core principles"},
    {"path": "docs/PRODUCT_VISION.md", "sections": [1, 2], "reason": "mission"}
  ],

  "active_work": {
    "focus": "Begin discovery or tackle Question 1",
    "blockers": [],
    "next_steps": ["option-a", "option-b"]
  },

  "relationships": {
    "ADR-001": {
      "type": "decision",
      "relates_to": ["methodology", "foundation"],
      "informs": ["session-protocols"],
      "status": "active"
    },
    "Idea-001": {
      "type": "idea",
      "status": "deferred",
      "reason": "validate on Perplex first"
    }
  },

  "skip_for_now": [
    "templates/*",
    "sessions/session-*.md",
    "examples/*"
  ]
}
```

---

## Usage

### Creating Checkpoint

```bash
# Manual creation
./tools/create-checkpoint.sh

# With description
./tools/create-checkpoint.sh "Foundation complete"

# Automated (integrated in session-end)
./tools/session-end.sh
# Prompts: "Create checkpoint? (y/n)"
```

### Resuming from Checkpoint

```bash
# Resume from latest
./tools/resume-from-checkpoint.sh

# Resume from specific checkpoint
./tools/resume-from-checkpoint.sh checkpoints/checkpoint-20251110-235900.md

# Just show what to read (dry-run)
./tools/resume-from-checkpoint.sh --dry-run
```

### Output Example

```
=== Resuming from Checkpoint: Foundation Complete ===

Phase: Foundation → Discovery
Last updated: 2025-11-10

📋 Read These Files (in order):
  1. FOUNDATION.md (core principles)
  2. docs/PRODUCT_VISION.md - sections 1-2 (mission)
  3. sessions/CURRENT_STATUS.md (current state)

🔗 Key Relationships:
  - ADR-001 → methodology
  - ADR-002 → enforcement, traceability
  - Idea-001 → deferred (validate first)

🎯 Next Actions:
  - Option A: Begin Question 1 discussion
  - Option B: Start discovery phase research
  - Option C: Test foundation with fresh session

✅ Context restored. Ready to continue.
```

---

## Best Practices

### When to Checkpoint

**Do checkpoint:**
- ✅ Phase completions (Foundation → Discovery → Implementation)
- ✅ Major milestones
- ✅ Before major refactoring
- ✅ After significant decisions (multiple ADRs)
- ✅ When context is complex and valuable

**Don't checkpoint:**
- ❌ Every commit
- ❌ Minor changes
- ❌ In middle of work (wait for logical pause)

### Checkpoint Quality

**Good checkpoint:**
- Concise (200-300 lines max)
- Prioritized reading list
- Clear mental models
- Explicit skip list
- Actionable next steps

**Bad checkpoint:**
- Dumps everything
- No prioritization
- Vague summaries
- Missing relationships

### Memory Graph Maintenance

**Update graph when:**
- New decisions made (ADRs)
- Phase transitions
- Requirements created
- Major file additions

**Keep graph simple:**
- Focus on relationships, not details
- Use reason fields (why this matters)
- Mark what's critical vs. optional

---

## Integration with Other Systems

### Session Logs
- Session logs = detailed history
- Checkpoints = curated snapshots
- Checkpoints reference logs, don't replace them

### ADRs
- Memory graph tracks decision relationships
- Checkpoint mentions recent ADRs
- Full ADR text stays in /decisions

### Current Status
- CURRENT_STATUS.md = always-current state
- Checkpoint = point-in-time state
- Both serve different purposes

---

## Recovery Scenarios

### Session Crash
1. New session runs `./tools/resume-from-checkpoint.sh`
2. Reads checkpoint + memory graph
3. Loads only critical files
4. Checks what work happened after checkpoint
5. Continues from interruption point

### Long Absence
1. Resume from latest checkpoint
2. Read CURRENT_STATUS.md
3. Check commits since checkpoint
4. Review recent session logs
5. Create new checkpoint if state changed significantly

### Complete Context Loss
1. Start with latest checkpoint
2. Memory graph provides relationship map
3. Selective reading based on phase
4. Accept some context loss but minimize it

---

## Future Enhancements

**Potential additions:**
- Automatic checkpoint on context window warnings
- Integration with Claude Code Skills (local Windows)
- Checkpoint diffing (compare two checkpoints)
- Visual memory graph explorer
- Checkpoint validation (ensure references exist)

**Keep it simple for now. Enhance based on real usage.**

---

## For AI Agents

**Creating checkpoints:**
- Use template
- Fill honestly and concisely
- Focus on just-in-time needs
- Update memory graph relationships
- Test that resume works

**Resuming from checkpoints:**
- Trust the checkpoint's guidance
- Read only critical files initially
- Expand to optional files if needed
- Don't re-read everything "just in case"

**Maintaining memory graph:**
- Update when relationships change
- Keep schema consistent
- Use reason fields (future sessions need context)

---

## For Humans

Checkpoints give you:
- Visibility into project state at key moments
- Understanding of what AI considers critical
- Ability to audit context restoration
- Transparency into continuity mechanisms

Review checkpoints to:
- Verify AI understands project correctly
- Catch misalignments early
- See what's being prioritized

---

**Philosophy:** "Just-in-time and selective but sufficient."

Read what you need, when you need it. Skip the rest. Preserve the relationships. Enable continuation.

---

**Last Updated:** 2025-11-10
**Status:** Active System
**Integration:** Session protocols, automation ready

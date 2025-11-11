# Learning Capture System

**Purpose:** Preserve and apply learnings so we don't repeat mistakes and can replicate successes.

---

## Quick Start

### For AI Agents

**Made a mistake?**
1. Document in session log (what, why, fix, prevention)
2. At session end: decide if pattern-worthy
3. If yes: create pattern doc in `patterns/`

**After milestone?**
1. Create retrospective: `cp RETROSPECTIVE_TEMPLATE.md retrospectives/YYYY-MM-DD-milestone.md`
2. Fill it out based on session logs and experience
3. Extract patterns and update processes

**Starting work?**
1. Check latest retrospective for learnings
2. Review `patterns/` for applicable patterns
3. Apply to current work

### For Humans

**Your role:**
- Identify patterns AI might miss
- Validate learnings are being captured
- Prioritize which learnings matter most
- Trigger retrospectives at milestones

---

## Directory Structure

```
knowledge/learnings/
├── README.md                           # This file - Overview
├── LEARNING_CAPTURE_WORKFLOW.md        # Complete workflow guide
├── RETROSPECTIVE_TEMPLATE.md           # Template for milestone retrospectives
├── retrospectives/                     # Completed retrospectives
│   └── YYYY-MM-DD-milestone-name.md
└── patterns/                           # Extracted, formalized patterns
    └── pattern-name.md
```

---

## System Components

### 1. Retrospective Template
**File:** `RETROSPECTIVE_TEMPLATE.md`

**Purpose:** Structured reflection after milestones

**Use when:**
- Phase completion
- Major feature complete
- Significant learning moment

**Process:**
```bash
# Copy template
cp knowledge/learnings/RETROSPECTIVE_TEMPLATE.md \
   knowledge/learnings/retrospectives/2025-11-11-foundation-complete.md

# Fill it out based on:
# - Session logs
# - Personal experience
# - Team discussions

# Commit when complete
git add knowledge/learnings/retrospectives/
git commit -m "Add foundation phase retrospective"
```

### 2. Learning Capture Workflow
**File:** `LEARNING_CAPTURE_WORKFLOW.md`

**Purpose:** Comprehensive guide to mistake → pattern process

**Covers:**
- When to capture learnings
- Types of learnings (mistakes, patterns, discoveries, etc.)
- Where learnings live
- Integration with existing systems
- Continuous improvement loop

**Read:** Before first retrospective, when uncertain about learning capture

### 3. Patterns Library
**Location:** `patterns/`

**Purpose:** Formalized, reusable patterns extracted from experience

**Format:**
```markdown
# Pattern: [Name]

**Category:** [Mistake/Process/Architecture]
**Frequency:** [One-time/Occasional/Frequent]
**Severity:** [Low/Medium/High]

## Description
[What is the pattern?]

## When It Occurs
[Conditions]

## Recognition
[How to identify]

## Response
[What to do]

## Prevention
[How to avoid]

## Example
[Real example from project]
```

**Example patterns to watch for:**
- "Gaps found at every corner" (completeness pattern)
- "Assumed X without validation" (assumption pattern)
- "Forgot to integrate Y" (integration pattern)

### 4. Retrospectives Archive
**Location:** `retrospectives/`

**Purpose:** Historical milestone retrospectives

**Naming:** `YYYY-MM-DD-milestone-name.md`

**Examples:**
- `2025-11-11-foundation-complete.md`
- `2025-11-XX-discovery-complete.md`
- `2025-XX-XX-mvp-launch.md`

---

## Integration with Project Systems

### Session Logs
Session logs (`/sessions/`) capture real-time learnings:
- Mistakes encountered and fixed
- Decisions made and why
- Gaps discovered
- Patterns recognized

At session end, review log for learnings worth preserving.

### ADRs
ADRs (`/decisions/`) capture architectural learnings:
- Context that informed decision
- Alternatives considered (anti-patterns)
- Consequences (expected outcomes)
- Rationale (why this approach)

When significant architectural learning occurs, create ADR.

### Checkpoints
Checkpoints (`/checkpoints/`) preserve mental models:
- Key concepts understood at that moment
- Relationships between systems
- What matters vs. what to skip

Include recent learnings in checkpoint mental models section.

### Completeness Review
Completeness review (`tools/review-completeness.sh`) could prompt:
- "Extract any patterns from this work?" (future enhancement)
- "Document any significant learnings?" (future enhancement)

### Session End Protocol
Session end already integrates learning capture:
1. Finalize session log (includes learnings)
2. Update documentation (incorporates learnings)
3. Create checkpoint (preserves mental models)

Could add:
4. Extract patterns (if significant learning occurred)
5. Update pattern library (if new pattern identified)

---

## Example: Foundation Phase

**Learnings captured during foundation:**

1. **Pattern: "Gaps found at every corner"**
   - Documented in session logs
   - Synthesized in retrospective
   - Formalized as completeness review system
   - Referenced in CLAUDE.md session protocols

2. **Pattern: "Token efficiency via selective loading"**
   - Discovered through checkpoint design
   - Documented in ADR-003
   - Implemented as memory graph system
   - Applied in session start protocol

3. **Mistake: "Assumed GitHub integration existed"**
   - User identified gap
   - Root cause: Local-only thinking
   - Fix: Built GitHub automation workflows
   - Prevention: Consider CI/CD equivalents for all local scripts

4. **Discovery: "CLAUDE.md is orchestration layer"**
   - Realized during planning
   - Documented in ADR-003
   - Created using Table of Contents pattern
   - Made session start protocol front-loaded

**Result:** Foundation learnings inform discovery phase approach.

---

## Workflow Diagrams

### Learning Capture Flow
```
Experience → Document in session log
    ↓
Session end → Review for patterns
    ↓
Pattern identified? → Formalize in patterns/
    ↓
Milestone reached? → Create retrospective
    ↓
Extract patterns → Update processes
    ↓
Apply to next work → (repeat)
```

### Retrospective Flow
```
Milestone complete
    ↓
Copy retrospective template
    ↓
Fill out based on session logs
    ↓
Extract patterns
    ↓
Create pattern docs
    ↓
Update processes
    ↓
Log action items in backlog
    ↓
Commit retrospective
```

---

## Success Criteria

**Learning capture is working when:**
- ✅ Same mistakes don't repeat across phases
- ✅ Patterns are identified and documented
- ✅ Retrospectives happen after milestones
- ✅ Processes improve based on learnings
- ✅ Future sessions reference past learnings
- ✅ Pattern library grows with project

**Learning capture is failing when:**
- ❌ Repeating same mistakes
- ❌ Retrospectives skipped
- ❌ Patterns identified but not formalized
- ❌ Learnings documented but not applied
- ❌ Pattern library empty or ignored

---

## Getting Started

### First Retrospective
If you've just completed a milestone:

```bash
# 1. Copy template
cp knowledge/learnings/RETROSPECTIVE_TEMPLATE.md \
   knowledge/learnings/retrospectives/$(date +%Y-%m-%d)-milestone-name.md

# 2. Fill it out (refer to session logs)

# 3. Extract any patterns

# 4. Update processes based on learnings

# 5. Commit
git add knowledge/learnings/
git commit -m "Add [milestone] retrospective and learnings"
```

### First Pattern
If you've identified a recurring pattern:

```bash
# 1. Create pattern doc
cat > knowledge/learnings/patterns/pattern-name.md << 'EOF'
# Pattern: [Name]

[Fill in pattern template]
EOF

# 2. Update relevant processes

# 3. Reference in documentation

# 4. Commit
git add knowledge/learnings/patterns/
git commit -m "Document [pattern name] pattern"
```

---

## Maintenance

**Weekly:** Review session logs for patterns
**After milestone:** Create retrospective
**Monthly:** Review pattern library for updates
**Quarterly:** Evaluate if learning capture is working (meta-retrospective)

---

## For Next Phase

Discovery phase should:
1. Create retrospective after discovery complete
2. Document experiment learnings inline
3. Extract patterns from discoveries
4. Apply foundation learnings to discovery work

---

**Philosophy:** "Every mistake is a pattern waiting to be recognized. Every success is a template for replication."

**Goal:** Build organizational memory across AI sessions so each phase learns from previous phases.

---

**Last Updated:** 2025-11-11
**Status:** Active System
**Next Review:** After discovery phase retrospective

# Learning Capture Workflow

**Purpose:** Systematically capture and preserve learnings so they inform future work instead of being forgotten.

**Philosophy:** "Every mistake is a pattern waiting to be recognized. Every success is a template for replication."

---

## The Problem

During foundation development, we discovered a recurring issue: **valuable learnings were nearly lost**.

**Examples:**
- Gap pattern recognized → almost didn't build completeness system
- CLAUDE.md orchestration critical → almost forgot it entirely
- Checkpoint GitHub integration → user had to identify the gap

**Root cause:** No systematic process for capturing what we learn as we learn it.

---

## The Learning Lifecycle

```
Experience → Reflection → Pattern → Documentation → Application
    ↑                                                      ↓
    └──────────────── Continuous Improvement ─────────────┘
```

---

## When to Capture Learnings

### During Work
- ✅ When you make a mistake and fix it
- ✅ When you find a gap in the system
- ✅ When you discover a better way to do something
- ✅ When you realize something is harder/easier than expected
- ✅ When you identify a recurring pattern

### End of Session
- ✅ Review session log for learnings
- ✅ Identify what would help future sessions
- ✅ Note what was confusing or unclear

### After Milestones
- ✅ Conduct retrospective (use template)
- ✅ Extract patterns from retrospective
- ✅ Update process documentation based on learnings

---

## Types of Learnings

### 1. Mistakes → Corrections
**What:** Things we got wrong and how we fixed them

**Capture:**
- What happened (the mistake)
- Why it happened (root cause)
- How we fixed it (correction)
- How to prevent it (process change)

**Example from Foundation:**
- **Mistake:** Assumed foundation was complete, but enforcement/continuity gaps existed
- **Root cause:** No systematic completeness checking
- **Fix:** Built completeness review system
- **Prevention:** Run completeness review before declaring milestone complete

**Where to log:** Session logs (inline), retrospectives (milestone-level)

---

### 2. Patterns → Templates
**What:** Recurring situations that have repeatable solutions

**Capture:**
- Pattern name
- When it occurs
- How to recognize it
- Standard response/solution
- Variations to watch for

**Example from Foundation:**
- **Pattern:** "Gaps found at every corner"
- **Occurs:** When work seems complete but hasn't been systematically reviewed
- **Recognition:** User finds missing elements we didn't identify
- **Solution:** Run completeness review proactively
- **Variations:** Different types of work need different completeness criteria

**Where to log:** `knowledge/learnings/patterns/` (create as needed)

---

### 3. Discoveries → Insights
**What:** New realizations, capabilities, or understandings

**Capture:**
- What we discovered
- Context of discovery
- Impact on project
- How to leverage it

**Example from Foundation:**
- **Discovery:** Just-in-time selective loading via checkpoint + memory graph
- **Context:** Trying to solve continuity across sessions
- **Impact:** Saves 6,000-8,000 tokens per session start
- **Leverage:** Make checkpoint loading FIRST step in session start protocol

**Where to log:** Session logs, checkpoints (as mental models), retrospectives

---

### 4. Effectiveness → Best Practices
**What:** Approaches that worked particularly well

**Capture:**
- What we did
- Why it worked
- When to use it again
- Conditions for success

**Example from Foundation:**
- **What:** Table of Contents pattern for CLAUDE.md with @import
- **Why:** Avoids duplication, keeps orchestration concise, scales well
- **When:** Any time creating long prompt or documentation structure
- **Conditions:** Need comprehensive docs referenced from central index

**Where to log:** ADRs (when architectural), retrospectives, process docs

---

### 5. Anti-patterns → Warnings
**What:** Approaches to avoid

**Capture:**
- What not to do
- Why it doesn't work
- What to do instead
- Red flags to watch for

**Example from Foundation:**
- **Don't:** Assume work is complete when it "looks done"
- **Why:** Gaps consistently found during systematic review
- **Instead:** Run completeness review explicitly
- **Red flags:** User finding gaps we missed, feeling uncertain about completeness

**Where to log:** Retrospectives, decision docs (as "alternatives rejected")

---

## Mistake → Pattern Workflow

### Step 1: Recognize the Mistake
When you realize something went wrong or was missing:

1. **Stop and document immediately** in session log
2. Note: What you expected vs. what actually happened
3. Note: How you discovered it (self-identified? User-identified?)

### Step 2: Analyze Root Cause
Ask "why" repeatedly:

- Why did this happen?
- Why didn't we catch it earlier?
- Why was our process insufficient?
- Why did we make that assumption?

Document in session log or ADR if significant.

### Step 3: Identify the Pattern
Ask if this is recurring:

- Have we seen this before?
- Is this specific to this case or general?
- What category does this fall into? (gap, assumption, process, etc.)
- What's the underlying principle?

### Step 4: Formalize the Pattern
Create pattern documentation:

```markdown
# Pattern: [Name]

**Category:** [Mistake/Process/Architecture/etc.]
**Frequency:** [One-time/Occasional/Frequent]
**Severity:** [Low/Medium/High]

## Description
[What is the pattern?]

## When It Occurs
[Under what conditions does this happen?]

## Recognition
[How do you know you're in this pattern?]

## Response
[What should you do?]

## Prevention
[How to avoid getting into this pattern?]

## Example
[Real example from project]

## Related
[Links to ADRs, session logs, retrospectives]
```

### Step 5: Update Processes
Based on the pattern:

- Update checklists (like completeness review)
- Add validation checks (like foundation validation)
- Modify templates (like retrospective template)
- Create automation (like git hooks)

### Step 6: Apply Going Forward
Ensure pattern is used:

- Reference in CLAUDE.md (if critical)
- Include in session start/end protocols
- Add to relevant guides
- Mention in retrospectives

---

## Where Learnings Live

### Session Logs (`sessions/`)
- **What:** Real-time capture during work
- **Format:** Inline narrative, mistakes → corrections section
- **Audience:** Future sessions needing historical context
- **Detail:** High - includes thought process, iterations

### Retrospectives (`knowledge/learnings/retrospectives/`)
- **What:** Milestone-level reflection
- **Format:** Structured template
- **Audience:** End-of-phase reviews, future planning
- **Detail:** Medium - synthesized from session logs

### Pattern Library (`knowledge/learnings/patterns/`)
- **What:** Extracted, formalized patterns
- **Format:** Pattern documentation template
- **Audience:** AI agents encountering similar situations
- **Detail:** Low - just the pattern essence

### ADRs (`decisions/`)
- **What:** Architectural learnings embedded in decisions
- **Format:** ADR template (context, decision, consequences)
- **Audience:** Understanding why systems are designed as they are
- **Detail:** High for context, medium for alternatives

### Checkpoints (`checkpoints/`)
- **What:** Mental models and key concepts at moment in time
- **Format:** Checkpoint template with mental models section
- **Audience:** Session restoration
- **Detail:** Medium - enough to restore understanding

---

## Integration with Existing Systems

### Completeness Review
The completeness review prompts for learnings:

- "Did you encounter ideas for future exploration?" → Ideas
- "Were significant technical decisions made?" → ADRs
- Retrospective question could be added for milestone-level work

### Session End Protocol
Already includes:
1. Finalize session log (capture learnings inline)
2. Update documentation (incorporate learnings)
3. Create checkpoint (preserve mental models)

Could add:
4. **Extract patterns** (if significant learnings occurred)
5. **Update pattern library** (if new pattern identified)

### Checkpoints
Memory graph could include:

```json
"learnings": [
  {
    "type": "pattern",
    "name": "Gaps at every corner",
    "reference": "knowledge/learnings/patterns/gap-detection.md"
  },
  {
    "type": "mistake",
    "summary": "Assumed completeness without validation",
    "correction": "Built completeness review system"
  }
]
```

---

## For AI Agents

### During Work
When you make a mistake or discover something:
1. **Document immediately** in session log
2. Note root cause and fix
3. Mark for pattern extraction at session end

### End of Session
Before session end:
1. Review session log for learnings
2. Decide if patterns warrant formalization
3. Update pattern library if needed
4. Include key learnings in checkpoint

### After Milestone
Conduct retrospective:
1. Use template: `knowledge/learnings/RETROSPECTIVE_TEMPLATE.md`
2. Extract patterns from retrospective
3. Update processes based on learnings
4. Create ADR if significant architectural learning

### When Resuming
Check for relevant learnings:
1. Load checkpoint (includes recent learnings)
2. Check pattern library for applicable patterns
3. Review relevant retrospectives
4. Apply learnings to current work

---

## For Humans

### Your Role
- Identify when AI missed a pattern
- Highlight learnings from your perspective
- Validate that learnings are being captured
- Prioritize which learnings matter most

### What to Watch For
- Same mistakes repeating
- Learnings documented but not applied
- Patterns identified but not formalized
- Retrospectives skipped

---

## Success Metrics

**Good learning capture:**
- ✅ Patterns identified and documented
- ✅ Same mistakes don't repeat
- ✅ Processes improve over time
- ✅ Retrospectives inform next phase
- ✅ Future sessions benefit from past learnings

**Poor learning capture:**
- ❌ Repeating same mistakes
- ❌ Learnings forgotten between sessions
- ❌ No process improvements
- ❌ Retrospectives skipped or superficial
- ❌ Pattern library empty or unused

---

## Example: Foundation Phase Learning Capture

**Pattern Identified:** "Gaps found at every corner"
- Session logs documented each gap discovery
- Retrospective synthesized pattern
- Built completeness review system (automation)
- Updated session end protocol (process)
- Documented in ADR-002 (decision)
- Referenced in CLAUDE.md (session protocol)
- Included in checkpoint (mental model)

**Result:** Next phase won't repeat the "assume complete without validation" mistake.

---

## Quick Reference

**Made a mistake?**
1. Document in session log: what, why, how fixed, prevention
2. At session end: evaluate if pattern worthy
3. If pattern: formalize in pattern library

**Found a pattern?**
1. Create pattern doc in `knowledge/learnings/patterns/`
2. Update relevant processes
3. Reference in CLAUDE.md if critical
4. Include in next retrospective

**After milestone?**
1. Create retrospective using template
2. Extract patterns
3. Update processes
4. Log action items in backlog

**Starting work?**
1. Check checkpoint for recent learnings
2. Review pattern library for applicable patterns
3. Apply learnings proactively

---

## Continuous Improvement Loop

```
Work → Mistakes/Discoveries → Document → Reflect →
  Extract Patterns → Formalize → Update Processes →
    Apply to Work → (repeat)
```

**The goal:** Each phase is informed by previous phases, building organizational memory across AI sessions.

---

**Last Updated:** 2025-11-11
**Status:** Active System
**Next Review:** After Discovery Phase retrospective

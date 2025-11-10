# Continuity & Recovery

**Last Updated:** 2025-11-10
**Status:** Living Document

---

## The Continuity Challenge

### The Problem

**Process Memory Loss:**
AI agents (Claude Code sessions) have conversational context that exists only during the session. If catastrophic failure occurs:
- Session context is lost
- Conversational understanding evaporates
- Mental models of problem disappear
- Nuanced decisions lose their rationale

**Repository is NOT enough:**
Files and code persist, but the *thinking* behind them can be lost.

### What We Can vs. Can't Control

**❌ What We CAN'T Solve:**
- Claude Code Web lacks persistent memory (no MCP server access)
- Session context is ephemeral by nature
- Conversational flow can't be fully captured
- True catastrophic failure (repository loss) recovery is limited

**✅ What We CAN Mitigate:**
- Capture critical context in session logs
- Document mental models explicitly
- Make decisions transparent (ADRs)
- Structure repositories for self-documentation
- Create recovery protocols

---

## Mitigation Strategies

### 1. Enhanced Session Logs

**Purpose:** Preserve "process memory" beyond files

**What We Capture:**
- **Mental Models:** How we're thinking about problems
- **Context:** Why decisions were made
- **Assumptions:** What we're taking for granted
- **Vocabulary:** Project-specific terms and meanings
- **Critical State:** Where we are, where we're going

**Template:** `sessions/SESSION_LOG_TEMPLATE.md`

**Protocol:**
- Update throughout session, not just at end
- Capture "why" not just "what"
- Write for future sessions who don't have your context

### 2. Self-Documenting Repository

**Principle:** Repository tells its own story

**Mechanisms:**
- `README.md` - Project overview and entry point
- `FOUNDATION.md` - Core principles and philosophy
- `docs/PRODUCT_VISION.md` - The "why" behind everything
- ADRs - Decision history with rationale
- Traceability - Links showing relationships
- Inline comments - Explain non-obvious choices

**Goal:** Fresh session can understand project by reading repository alone

### 3. Redundant Critical Information

**Strategy:** Most critical information appears in multiple places

**Example:**
- Product vision in `PRODUCT_VISION.md` (primary)
- Vision summarized in `README.md` (overview)
- Vision referenced in ADRs (context)
- Vision linked in requirements (traceability)
- Vision summarized in session logs (continuity)

**Why:** If one document is unclear, others provide context

### 4. Explicit Mental Models

**Problem:** AI agents develop mental models of problems that aren't written down

**Solution:** Document mental models explicitly in session logs

**Example:**
Instead of just documenting what was done, capture:
```
Mental Model:
We're thinking of the Perplexity integration problem as a "bridge"
between two systems rather than an "API wrapper." This frames
solutions as bidirectional communication rather than one-way calls.

This mental model drove decisions about data flow and state management.
```

### 5. Recovery Sections in Session Logs

**Purpose:** Quick context restoration if session interrupted

**Contents:**
- Current state in ONE sentence
- Mental model summary (2-3 sentences)
- Critical recent decisions
- What was about to happen next

**Location:** End of every session log

### 6. Commit Message Richness

**Strategy:** Commits tell a story, not just list changes

**Good Commit:**
```
Add ideas logging system with status workflow

Ideas emerge throughout development but were being lost. This system
provides lightweight capture with status progression (new → researching
→ decided → discarded → implemented).

Integrates with: Decision logging (ideas become ADRs), Research (ideas
trigger investigation), Milestones (ideas feed roadmap).

Addresses gap identified in foundation review discussion.
```

**Why:** Commit history becomes a narrative of project evolution

### 7. Regular Status Snapshots

**Mechanism:** `sessions/CURRENT_STATUS.md` (auto-generated)

**Purpose:** Always-current project state snapshot

**Update Frequency:** Every session end

**Contents:**
- Current phase and focus
- Recent commits and decisions
- Active work and next steps

### 8. Traceability as Memory

**Mechanism:** `requirements/TRACEABILITY.md`

**Purpose:** Shows "why this exists"

**Benefit:** Even if context is lost, traceability chains show purpose

---

## Recovery Protocols

### Scenario 1: Session Interrupted/Crashed

**Recovery Steps:**
1. Read `sessions/CURRENT_STATUS.md` for quick overview
2. Find most recent session log in `sessions/`
3. Read "Recovery Information" section
4. Check last commit message for recent work
5. Review any open PRs for in-flight work
6. Continue from "What Was About to Happen"

**Expected Context Loss:** Minimal (10-20%)

### Scenario 2: New AI Agent/Session Starting Work

**Recovery Steps:**
1. Read `FOUNDATION.md` for principles
2. Read `docs/PRODUCT_VISION.md` for purpose
3. Read `sessions/CURRENT_STATUS.md` for state
4. Review recent session logs (last 2-3)
5. Check recent ADRs for decision context
6. Review `docs/MILESTONES.md` for direction
7. Check `ideas/INDEX.md` for possibilities
8. Begin work

**Expected Context Loss:** Moderate (30-40%)

### Scenario 3: Returning After Long Absence

**Recovery Steps:**
1. Start with `README.md` to re-orient
2. Read `docs/PRODUCT_VISION.md` to remember goals
3. Check `docs/MILESTONES.md` for progress
4. Review `sessions/CURRENT_STATUS.md`
5. Read recent session logs to understand recent thinking
6. Review recent ADRs for important decisions
7. Check `requirements/TRACEABILITY.md` for relationships
8. Ease back into work

**Expected Context Loss:** Significant (50-60%)

### Scenario 4: Complete Repository Loss (Catastrophic)

**Recovery Steps:**
1. Clone from GitHub (repository is remote backup)
2. Follow "New AI Agent" protocol above
3. Accept that conversational context is lost
4. Rely on documentation to rebuild understanding

**Expected Context Loss:** High (70-80%)
**Unrecoverable:** Conversational nuance, unstated assumptions, emergent insights not documented

---

## What Gets Lost vs. What Persists

### Persists (Repository-Based)
- ✅ Code and files
- ✅ Documented decisions (ADRs)
- ✅ Explicit requirements
- ✅ Product vision statements
- ✅ Configuration
- ✅ Session logs (if committed)
- ✅ Commit history

### Lost (Conversation-Based)
- ❌ Tone and context of discussions
- ❌ Nuanced understanding developed in conversation
- ❌ Human preferences not explicitly documented
- ❌ Thought processes between documented decisions
- ❌ Failed experiments not logged
- ❌ Assumptions so obvious they weren't written down

### Partially Recoverable
- 🟡 Mental models (if session logs are detailed)
- 🟡 Project momentum and "flow state"
- 🟡 Vocabulary and shared language
- 🟡 Trust and working relationship between human/AI

---

## Continuous Improvement

### After Any Continuity Gap

**Retrospective Questions:**
1. What context was hardest to recover?
2. What documentation would have helped?
3. What assumptions weren't written down?
4. How can we improve session logs?

**Update Protocols:**
Adjust session log template, documentation standards, or recovery protocols based on learnings.

---

## Honest Assessment

### What This System Provides

**✅ Good for:**
- Recovering from session crashes
- Onboarding new AI agents
- Understanding project after absence
- Preserving decision rationale
- Maintaining project direction

**❌ NOT sufficient for:**
- Perfect context restoration
- Replacing conversational understanding
- Capturing all nuance
- Preserving "feel" of collaboration

### The Gap We Can't Close

**Reality:** True catastrophic context loss will always result in some degradation.

**Acceptance:** This is a limitation of stateless AI sessions. We mitigate, but can't eliminate.

**Philosophy:** Better to acknowledge the gap and build what mitigation we can than to pretend it doesn't exist.

---

## For AI Agents

**Your Responsibility:**
- Maintain session logs diligently
- Document mental models explicitly
- Write for future sessions who lack your context
- Update recovery information even if session going smoothly
- Commit frequently so work is preserved

**When Starting a Session:**
- Always run `tools/session-start.sh`
- Read recovery-oriented documentation
- Don't assume you have context you don't have
- Ask questions if documentation unclear

---

## For Humans

**Your Role:**
- Understand context loss is a real risk
- Appreciate AI efforts to document thoroughly
- Provide feedback when documentation isn't clear
- Contribute to recovery protocols based on experience

**If Recovery Needed:**
- Be patient with context restoration
- Provide missing context when possible
- Help rebuild mental models through conversation

---

## Future Improvements

**Potential Enhancements:**
- Automated session summary generation
- Vector-based memory search (if tooling available)
- Integration with MCP servers (if access granted)
- Conversation transcript preservation
- AI-to-AI handoff protocols

**Current Status:**
Using best practices available within Claude Code Web constraints.

---

## Key Principle

**"Write today for the session that has to resume without you tomorrow."**

Every session log, every ADR, every commit message should enable future sessions to continue with minimal context loss.

---

**Last Updated:** 2025-11-10
**Next Review:** After first context loss event or long absence

---

*Acknowledgment: This document exists because we recognize the limitation. That's progress.*

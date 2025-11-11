# 003. CLAUDE.md Architecture - Table of Contents Pattern

**Date:** 2025-11-11
**Status:** Accepted
**Context:** Foundation Phase Completion
**Related:** ADR-001 (Discovery-Driven Development), ADR-002 (Foundation Enhancements - Continuity)

## Context

After building comprehensive continuity infrastructure (checkpoints, memory graphs, completeness review), we discovered a critical gap: **CLAUDE.md orchestration was missing**. Without CLAUDE.md, the next Claude Code web session would have no guidance to actually USE the infrastructure we built.

### The Challenge

CLAUDE.md needs to:
1. **Orchestrate all systems** - Direct session start/end protocols
2. **Anchor to foundation imperatives** - Reference FOUNDATION.md correctly
3. **Balance brevity with completeness** - Concise yet comprehensive
4. **Avoid duplication** - Single source of truth via @import
5. **Work for Claude Code web** - Different from local CLI expectations
6. **Prioritize checkpoint loading** - Make continuity system actually work

### The Risk

If done poorly:
- Next session doesn't load checkpoints → continuity system unused
- Duplicated content → contradictions, maintenance burden
- Too long → overwhelming, unread
- Too short → missing critical guidance
- Wrong priorities → infrastructure built but never utilized

## Decision

**Adopt the "Table of Contents" pattern** from Anthropic's documented best practices, creating a ~277-line CLAUDE.md that:

1. **Front-loads session start protocol** - Checkpoint loading is FIRST and CRITICAL
2. **Uses @import extensively** - References comprehensive docs, doesn't duplicate
3. **Provides operational guidance** - Commands, workflows, quick reference
4. **Establishes session protocols** - Start and end procedures explicit
5. **Can be iterated** - Following Anthropic's recommendation to start lean, refine

## Architecture

### Structure (277 lines)

```
CLAUDE.md (277 lines) - Orchestration + Operational Guide
├── 🚀 SESSION START PROTOCOL (CRITICAL)
│   └── Load checkpoint → Read checkpoint → Follow reading list
├── 📋 Foundation Imperatives (@FOUNDATION.md)
├── 🎯 Product Vision (@docs/PRODUCT_VISION.md)
├── 📚 Documentation & Knowledge Base
│   ├── Checkpoints: @checkpoints/README.md, @checkpoints/GITHUB_AUTOMATION.md
│   ├── Completeness: @docs/COMPLETENESS_REVIEW.md
│   ├── ADRs: @decisions/
│   ├── Sessions: @sessions/CURRENT_STATUS.md
│   └── Config: @config/project.yml, @config/ai-agent.yml
├── ⚡ Common Commands (Quick Reference)
├── 🎨 Code Style & Conventions
├── 🔀 Git Workflow
├── 🔚 SESSION END PROTOCOL
├── 📖 For Next Session (What to Expect)
└── 🆘 Quick Reference
```

### Comprehensive Documentation (Separate Files)

- `FOUNDATION.md` (271 lines) - Foundation imperatives, success criteria, protocols
- `docs/PRODUCT_VISION.md` (185 lines) - Problem, vision, principles, open questions
- `checkpoints/README.md` (200+ lines) - Checkpoint system deep dive
- `checkpoints/GITHUB_AUTOMATION.md` (322 lines) - GitHub automation guide
- `docs/COMPLETENESS_REVIEW.md` (372 lines) - Gap detection comprehensive guide
- ADRs (various) - Architecture decision records
- Session logs - Historical context

**Total documentation: ~2,000+ lines**
**CLAUDE.md references ALL of it via @import: 277 lines**

### Key Design Decisions

#### 1. Session Start Protocol Front-Loaded

**Decision:** First section after header is "CRITICAL: Session Start Protocol"

**Rationale:**
- Checkpoint loading is THE critical path for continuity
- Next session MUST see this first
- Explicit "YOU MUST DO THIS FIRST" language
- Makes infrastructure actually get used

**Alternative Rejected:** Burying checkpoint loading in middle/end of file (would be ignored/forgotten)

#### 2. @import Extensively

**Decision:** Use `@path/to/file` syntax for all detailed content

**Rationale:**
- Single source of truth (no duplication)
- Comprehensive docs exist, just reference them
- Keep CLAUDE.md as index/orchestrator
- Follows Anthropic best practices

**Files Imported:**
- `@FOUNDATION.md` - Foundation imperatives
- `@docs/PRODUCT_VISION.md` - Product vision
- `@checkpoints/README.md` - Checkpoint system
- `@checkpoints/GITHUB_AUTOMATION.md` - GitHub automation
- `@docs/COMPLETENESS_REVIEW.md` - Completeness guide
- `@sessions/CURRENT_STATUS.md` - Current status
- `@config/project.yml` - Project config
- `@config/ai-agent.yml` - AI agent config
- `@decisions/` - All ADRs

**Alternative Rejected:** Duplicating content in CLAUDE.md (creates maintenance burden, contradictions)

#### 3. Operational Guidance Included

**Decision:** Include common commands, git workflow, code style directly in CLAUDE.md

**Rationale:**
- Frequent operations need quick reference
- Commands don't change often (stable)
- Prevents repeated file searches
- Anthropic docs recommend this

**What's Included:**
- Foundation validation: `./tools/validate-foundation.sh`
- Completeness review: `./tools/review-completeness.sh`
- Status update: `./tools/generate-status.sh`
- Create checkpoint: `./tools/create-checkpoint.sh`
- Resume checkpoint: `./tools/resume-from-checkpoint.sh`
- Session end: `./tools/session-end.sh`
- Git workflow (branching, commit messages, hooks)
- Code style (naming, organization)

**Alternative Rejected:** Making user search for commands every session (inefficient)

#### 4. Session End Protocol Explicit

**Decision:** Dedicated section outlining pre-session-end requirements

**Rationale:**
- Completeness review finds gaps "at every corner"
- Explicit checklist prevents forgotten steps
- References `./tools/session-end.sh` for automation
- Closes the continuity loop (start + end protocols)

**Checklist:**
1. Run completeness review
2. Update documentation
3. Commit remaining changes
4. Push to remote
5. Create checkpoint (if milestone)

**Alternative Rejected:** Implicit expectations (leads to gaps)

#### 5. "For Next Session" Section

**Decision:** Explicit guidance on what to expect when resuming

**Rationale:**
- Sets expectations for next Claude instance
- Explains checkpoint → memory graph → reading list flow
- Emphasizes token efficiency (6,000-8,000 tokens saved)
- Encourages foundation imperative adherence

**Alternative Rejected:** Assuming next session will figure it out (risky)

## Rationale

### Why This Pattern Works

1. **Separation of Concerns:**
   - CLAUDE.md = Orchestration + Quick Reference
   - Detailed docs = Depth + Single Source of Truth

2. **Discoverability:**
   - Clear sections with emojis for scanning
   - "When to use X" guidance
   - Quick reference section for common questions

3. **Maintainability:**
   - Update patterns in source files (one place)
   - CLAUDE.md rarely needs updates (stable commands, protocols)
   - No duplication = No contradictions

4. **Scalability:**
   - Easy to add new documentation (just add @import reference)
   - Can break CLAUDE.md into `.claude/skills/` later if needed
   - Follows pattern that scales to 10,000+ line codebases

5. **Actually Gets Used:**
   - Session start protocol is FIRST (can't miss it)
   - Commands are quick reference (don't need to search)
   - Session end protocol reminds about completeness

### Alignment with Best Practices

From Anthropic documentation:
- ✅ "Keep them concise and human-readable" (277 lines vs comprehensive docs)
- ✅ "Treat CLAUDE.md like a prompt... iterate" (we can refine)
- ✅ "Break up large files using @path/to/import" (extensively used)
- ✅ "Frequently used commands to avoid repeated searches" (common commands section)
- ✅ "Important architectural patterns" (foundation imperatives, session protocols)

From documented case study (497 → 287 lines):
- ✅ Table of contents structure (CLAUDE.md as index)
- ✅ Specialized documents for depth (checkpoints/, docs/)
- ✅ Zero duplication via @import
- ✅ Clear "when to use X" guidance

### What Makes This Different

**Compared to typical CLAUDE.md:**
- Session start/end protocols front and center (not buried)
- Checkpoint system as critical path (token efficiency)
- Completeness review integration (gap detection)
- References comprehensive documentation (2,000+ lines) via @import

**Compared to monolithic approach:**
- No duplication (single source of truth)
- Easier to maintain (update source files)
- Scales better (can add more docs without bloating CLAUDE.md)
- More readable (index vs manual)

## Consequences

### Positive

1. **Next session will actually use infrastructure:**
   - Session start protocol explicitly directs checkpoint loading
   - Can't miss it (it's first and marked CRITICAL)

2. **Token efficiency realized:**
   - Checkpoint + memory graph saves 6,000-8,000 tokens
   - Just-in-time selective loading works as designed

3. **Maintainable:**
   - Update docs in source files
   - CLAUDE.md rarely needs changes
   - No duplication to keep in sync

4. **Discoverable:**
   - Clear sections with emojis
   - Quick reference for common tasks
   - "For Next Session" explains what to expect

5. **Iterative:**
   - Can refine based on actual usage
   - Follow Anthropic's recommendation to iterate
   - Can break into `.claude/skills/` if needed

### Negative

1. **Length:**
   - 277 lines is longer than ideal ~150 target
   - Still much less than 497-line example
   - Justified by operational guidance + protocols

2. **Assumes @import works:**
   - Depends on Claude Code web supporting @path/to/import
   - If not supported, would need to inline referenced content
   - Documentation says it's supported, but unverified in web

3. **May need iteration:**
   - First version, not yet battle-tested
   - May find missing elements or unnecessary sections
   - Anthropic recommends iterating - this is expected

4. **Context switch cost:**
   - Jumping between files via @import
   - Trade-off: conciseness vs all-in-one
   - Justified by avoiding duplication

### Mitigations

1. **Monitor effectiveness:**
   - Track if next session actually loads checkpoints
   - Refine language if protocol isn't followed
   - Add emphasis ("IMPORTANT", "YOU MUST") if needed

2. **Verify @import support:**
   - Test in actual Claude Code web session
   - If not supported, can inline critical content
   - Document findings in follow-up ADR if needed

3. **Iterate based on usage:**
   - Follow Anthropic's recommendation
   - Trim unnecessary sections
   - Add missing guidance
   - Run through prompt improver periodically

## Alternatives Considered

### Alternative 1: Minimal CLAUDE.md (~50 lines)

**Approach:** Just checkpoint loading + foundation reference

**Pros:**
- Very concise
- Forces reading comprehensive docs

**Cons:**
- No quick reference for common commands
- Session protocols not explicit
- Likely to be forgotten/ignored

**Why Rejected:** Too minimal, doesn't provide operational guidance

### Alternative 2: Comprehensive CLAUDE.md (500+ lines)

**Approach:** Include all guidance directly, no @import

**Pros:**
- Everything in one place
- No context switching

**Cons:**
- Duplication (maintenance burden)
- Contradictions likely
- Overwhelming length
- Violates single source of truth

**Why Rejected:** Documented anti-pattern, creates technical debt

### Alternative 3: Skills Documents Pattern

**Approach:** CLAUDE.md + `.claude/skills/*.md` for domains

**Pros:**
- Clear domain separation
- Agent routing strategy
- Scales to complex projects

**Cons:**
- More complex structure
- Perplex doesn't have distinct domains yet
- Premature optimization

**Why Rejected:** Can adopt later if needed, simpler structure works for now

### Alternative 4: No CLAUDE.md

**Approach:** Rely on checkpoints alone

**Pros:**
- One less file to maintain

**Cons:**
- Next session wouldn't know to load checkpoints
- No operational guidance
- Infrastructure unused
- Violates Claude Code best practices

**Why Rejected:** Makes infrastructure useless

## Implementation

**Files Created:**
- `CLAUDE.md` (277 lines)
- `decisions/2025-11-11-claude-md-architecture.md` (this ADR)

**Files Referenced (via @import):**
- `FOUNDATION.md`
- `docs/PRODUCT_VISION.md`
- `checkpoints/README.md`
- `checkpoints/GITHUB_AUTOMATION.md`
- `docs/COMPLETENESS_REVIEW.md`
- `sessions/CURRENT_STATUS.md`
- `config/project.yml`
- `config/ai-agent.yml`
- `decisions/` (directory)

**Testing:**
- Verified all @import references point to existing files
- Manual review for readability
- Will be tested in actual next session

## Future Considerations

1. **Iteration based on usage:**
   - Next session will reveal what works and what doesn't
   - Refine based on actual experience
   - Follow Anthropic's recommendation to iterate

2. **Skills documents if needed:**
   - If project grows complex with distinct domains
   - Can break into `.claude/skills/domain.md` pattern
   - CLAUDE.md remains table of contents

3. **Prompt improver:**
   - Run CLAUDE.md through prompt improver periodically
   - Optimize instruction following
   - Add emphasis where needed

4. **Monitor checkpoint adoption:**
   - Track if sessions actually load checkpoints
   - If not, strengthen language in session start protocol
   - Consider adding "IMPORTANT" or "YOU MUST" emphasis

5. **Verify @import support:**
   - Test in actual Claude Code web session
   - Document findings
   - Adjust approach if needed

## Validation

**Success Criteria:**
- ✅ CLAUDE.md created and readable
- ✅ All @import references valid
- ✅ Session start/end protocols explicit
- ✅ Common commands documented
- ✅ Foundation imperatives referenced
- 🔄 Next session loads checkpoint (to be validated)
- 🔄 Infrastructure actually gets used (to be validated)

**Validation Method:**
- Next Claude Code web session will be the real test
- Monitor if checkpoint is loaded first
- Track if completeness review is run
- Evaluate if session protocols are followed

## References

- [Anthropic Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Claude Code Memory Documentation](https://code.claude.com/docs/en/memory)
- [Skills Documents Pattern Example](https://github.com/anthropics/claude-code/issues/9959) (497 → 287 line case study)
- ADR-001: Discovery-Driven Development with Lean Principles
- ADR-002: Foundation Enhancements - Enforcement, Traceability, and Continuity
- User quote: "Never just readily agree with me, I must rely on you"
- User quote: "In context every token is sacred"

---

**Decision:** Accepted
**Implementation:** Complete
**Next:** Test in actual session, iterate based on findings

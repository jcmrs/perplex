# Specification: perplex-transformer

**Feature ID:** 001
**Feature Name:** perplex-transformer
**Phase:** Discovery / Phase 1 Implementation
**Owner:** Project Perplex Team
**Created:** 2025-11-13
**Status:** Draft

---

## Overview

The perplex-transformer is the core component that transforms Perplexity AI research conversations into structured, project-specific artifacts. It enables AI agents (Claude Code CLI, Gemini CLI) to leverage Perplexity AI's research capabilities while maintaining proper context isolation and artifact organization.

**Purpose:** Bridge local AI development tools with Perplexity AI research in a structured, maintainable way.

---

## Problem Statement

### Current Pain Points

AI development tools (Claude Code, Gemini CLI) frequently need deep research that Perplexity AI excels at providing. However:

1. **Manual friction:** Constant context-switching between AI tool and browser
2. **Context contamination:** No project-specific isolation of Perplexity conversations
3. **Lost artifacts:** Research findings not systematically captured
4. **No integration path:** Perplexity has no API, no CLI, no programmatic access
5. **Broken workflow:** Human must manually copy-paste between systems

### Impact

For non-technical users working with AI development tools, this creates:
- Interruption of development flow
- Risk of losing valuable research
- Difficulty tracking what research informed which decisions
- No way to resume research context across sessions

---

## Goals

### Phase 1 (Foundation - Manual Capture)

1. **Structured Capture Process**
   - Clear workflow for capturing Perplexity conversations
   - Templates for consistent research artifact format
   - Project-specific storage organization

2. **Context Isolation**
   - Separate Perplexity conversations per project
   - No cross-contamination between projects
   - Clear association between research and project artifacts

3. **AI Agent Integration**
   - AI agents can request specific research
   - Clear process for incorporating research into development
   - Research artifacts readable by AI agents in future sessions

4. **Non-Technical Friendly**
   - Process usable by non-programmers
   - Configuration over implementation
   - Clear, documented steps

### Phase 2+ (Future - Automation)

- Browser automation for conversation capture
- Programmatic extraction of research findings
- Reduced manual steps in workflow
- (Details to be determined during Phase 1 learnings)

---

## Non-Goals

Explicitly **out of scope** for Phase 1:

1. ❌ **Not building a Perplexity API** - We work with what exists
2. ❌ **Not replicating Perplexity's research** - We bridge, not replace
3. ❌ **Not a general AI orchestration platform** - Specific to Perplexity integration
4. ❌ **Not requiring programming skills** - Must work for non-technical users
5. ❌ **Not automated extraction** - Phase 1 is manual with structure
6. ❌ **Not real-time integration** - Manual capture is acceptable for Phase 1

---

## Requirements

### Functional Requirements

#### FR-001: Research Request Workflow
- AI agent can identify need for Perplexity research
- Clear format for expressing research request
- Template for research request structure
- Request includes: topic, context, specific questions

#### FR-002: Research Capture Workflow
- Human-friendly process for capturing Perplexity conversation
- Template for conversation capture
- Includes: original request, research findings, sources, timestamp
- Preserves full conversation context (questions, answers, follow-ups)

#### FR-003: Storage Organization
- Research artifacts stored in project-specific location
- Clear naming convention for research files
- Indexing/catalog of research artifacts
- Easy retrieval by topic or date

#### FR-004: AI Agent Integration
- Research artifacts in AI-readable format (Markdown)
- Clear metadata (what, when, why, who requested)
- Cross-references to related project artifacts (ADRs, requirements)
- Future sessions can access past research

#### FR-005: Context Preservation
- Full conversation captured (not just final answer)
- Sources and references preserved
- Research reasoning visible (why Perplexity answered as it did)
- Follow-up questions captured

### Non-Functional Requirements

#### NFR-001: Simplicity
- No more than 5 manual steps for capture
- Process documented in single page
- Templates are self-explanatory

#### NFR-002: Maintainability
- Research artifacts version-controlled
- Format is future-proof (plain Markdown)
- No proprietary storage formats

#### NFR-003: Scalability
- Supports multiple projects
- Handles hundreds of research artifacts per project
- No performance degradation with growth

#### NFR-004: Usability (Non-Technical Users)
- No command-line knowledge required
- Copy-paste workflow acceptable
- Clear error messages if process fails

---

## Architecture Overview

### Component Structure

```
perplex-transformer/
├── templates/
│   ├── research-request.md      # Template for AI agent to request research
│   ├── conversation-capture.md  # Template for capturing Perplexity conversation
│   └── research-index.md        # Template for cataloging research
│
├── workflows/
│   ├── request-research.md      # How AI agent requests research
│   ├── capture-research.md      # How human captures Perplexity conversation
│   └── integrate-research.md    # How AI agent uses captured research
│
└── storage/
    └── research/
        ├── YYYYMMDD-topic-name.md   # Individual research artifacts
        └── INDEX.md                  # Catalog of all research
```

### Workflow Overview

**1. Research Request (AI Agent → Human)**
- AI agent identifies research need
- Creates research request using template
- Saves to project (git tracked)
- Notifies human (via session log or explicit marker)

**2. Research Execution (Human → Perplexity)**
- Human reviews research request
- Opens Perplexity AI
- Conducts research following request guidance
- Captures full conversation

**3. Research Capture (Human → Project)**
- Human uses conversation capture template
- Copies Perplexity conversation into template
- Adds metadata (date, requestor, topic)
- Saves to research storage
- Updates research index

**4. Research Integration (AI Agent → Development)**
- AI agent reads captured research
- References research in decisions (ADRs)
- Links research to requirements
- Continues development with research insights

### Data Flow

```
AI Agent (identifies need)
    ↓
Research Request (template)
    ↓
Human Partner (conducts research)
    ↓
Perplexity AI (provides research)
    ↓
Research Artifact (captured)
    ↓
AI Agent (integrates findings)
    ↓
Project Artifacts (ADRs, requirements, code)
```

---

## Success Criteria

### Acceptance Criteria

The perplex-transformer is successful when:

1. ✅ **AI agent can request research** without human guessing what's needed
2. ✅ **Research artifacts are captured** consistently with full context
3. ✅ **No context contamination** between different projects
4. ✅ **Research is reusable** across sessions (AI can access past research)
5. ✅ **Process is documented** clearly for non-technical users
6. ✅ **Templates exist** for all manual steps
7. ✅ **Research is traceable** (can find why decision was made → which research informed it)

### Quality Metrics

- **Capture completeness:** 100% of research conversations preserved
- **Time to capture:** < 5 minutes per conversation
- **Discoverability:** AI agent can find relevant research in < 30 seconds
- **Usability:** Non-technical user can follow process without assistance

---

## Open Questions

*To be resolved during technical planning (CLI's responsibility):*

### OQ-001: Template Format
- What specific fields should research-request.md include?
- What metadata is essential vs. optional?
- How to balance completeness with simplicity?

### OQ-002: Storage Strategy
- Single file per research conversation or multi-file structure?
- How to handle research spanning multiple Perplexity sessions?
- Index format: YAML frontmatter, JSON, or Markdown table?

### OQ-003: Integration Patterns
- How does AI agent discover relevant past research?
- Should research be tagged/categorized?
- How to link research to specific ADRs or requirements?

### OQ-004: Workflow Automation Hooks
- Where in session protocol should research requests be surfaced?
- How does human know a research request exists?
- Should research requests block AI agent progress?

### OQ-005: Version Control
- Should research artifacts be committed directly to main?
- Or use separate research branch?
- How to handle large research artifacts?

---

## Constraints

### Technical Constraints

1. **No Perplexity API exists** - Cannot automate extraction (Phase 1)
2. **Browser-only access** - Perplexity requires web browser interaction
3. **Manual capture required** - No programmatic access to conversations
4. **Non-technical users** - Solution must work without programming skills

### Project Constraints

1. **AI-First principle** - AI agent is primary user, not human
2. **Configuration over code** - Prefer declarative configuration
3. **Foundation imperatives** - Must align with modularity, extensibility, etc.
4. **Stateless sessions** - AI agent sessions are stateless (context must persist)

### User Constraints

1. **Non-technical partner** - Cannot write code or use command-line extensively
2. **Copy-paste acceptable** - Manual steps okay if well-documented
3. **Clear process required** - Ambiguity will cause errors

---

## Dependencies

### Internal Dependencies

- **Foundation Phase:** Must be complete (documentation systems, session protocols)
- **Session Management:** Research requests integrate with session logs
- **Checkpoints:** Research artifacts should be checkpoint-friendly
- **ADR System:** Research should be referenceable from decisions

### External Dependencies

- **Perplexity AI:** Service must remain accessible
- **Browser:** User must have web browser access
- **Git:** Version control for research artifacts

---

## Phases

### Phase 1: Manual Capture Foundation (CURRENT)

**Deliverables:**
1. ✅ Research request template
2. ✅ Conversation capture template
3. ✅ Storage organization structure
4. ✅ Workflow documentation
5. ✅ Integration with session protocols
6. ✅ Example research artifacts (test validation)

**Timeline:** Foundation → Early Discovery

**Exit Criteria:**
- AI agent successfully requests research
- Human captures Perplexity conversation using template
- Research artifact is usable by AI in future session
- Process documented and validated with real usage

### Phase 2: Exploration (FUTURE)

**Goals:**
- Investigate browser automation possibilities
- Research conversation extraction methods
- Evaluate technical feasibility of automation

**Dependencies:** Phase 1 learnings, real-world usage patterns

### Phase 3: Automation (FUTURE)

**Goals:**
- Reduce manual steps
- Automated capture where possible
- Seamless integration into development workflow

**Dependencies:** Phase 2 feasibility assessment

---

## References

### Related Documents

- [`docs/PRODUCT_VISION.md`](../../docs/PRODUCT_VISION.md) - Overall product vision
- [`FOUNDATION.md`](../../FOUNDATION.md) - Foundation imperatives
- [`decisions/2025-11-10-foundation-methodology.md`](../../decisions/2025-11-10-foundation-methodology.md) - ADR-001: Discovery-Driven methodology
- [`decisions/2025-11-12-methodology-architecture.md`](../../decisions/2025-11-12-methodology-architecture.md) - ADR-012: Two-layer methodology

### Related Ideas

- Check `ideas/` directory for research integration patterns
- Check `backlog/` for deferred automation items

### Related Requirements

- (To be created during technical planning)

---

## Approval & Sign-Off

**Specification Status:** Draft

**Review Status:**
- [ ] Web Agent (me) - Specification complete
- [ ] CLI Agent - Technical planning ready
- [ ] Human Partner - Strategic alignment confirmed

**Next Steps:**
1. CLI receives this specification
2. CLI runs `/speckit.plan` to create technical plan
3. CLI runs `/speckit.tasks` to decompose into atomic tasks
4. CLI runs `/speckit.implement` to execute

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2025-11-13 | Claude Code Web | Initial specification draft |

---

**Document Owner:** Claude Code Web (Designer-Researcher)
**Implementation Owner:** Claude Code CLI (Executor-Validator)
**Strategic Approval:** Human Partner

---

*This specification follows Spec-Driven Development methodology (ADR-012). Living document - will be updated based on implementation learnings.*

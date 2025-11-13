# ADR-010: Methodology Architecture - Discovery-Driven + Spec-Driven Integration

**Date:** 2025-11-12
**Status:** Accepted
**Deciders:** AI Agent with Human Partner alignment

---

## Context

Project Perplex documents two methodologies:
1. **ADR-001:** Discovery-Driven Development with Lean Principles
2. **STAGE1_DELIVERABLES:** Spec-Driven Development with GitHub Spec Kit

Without explicit integration documentation, this creates potential confusion:
- Are these sequential phases?
- Do they conflict?
- Which applies when?
- How do they work together?

Human partner identified this gap during Spec Kit integration planning, observing that foundation/discovery work appeared to be "preparing the context Spec Kit needs."

---

## Decision

**Adopt two-layer methodology architecture** where Discovery-Driven and Spec-Driven development are **complementary scopes** at different levels, not sequential phases.

### Layer 1: Discovery-Driven Development (Project Level)
**Scope:** Exploration, validation, strategic decisions
**Source:** ADR-001 (Foundation Methodology)
**Active:** Throughout entire project lifecycle

**Governs:**
- How we explore unknown territory
- How we validate assumptions
- How we make strategic decisions
- How we adapt to learnings

**Produces:**
- Product vision (PRODUCT_VISION.md)
- Foundation principles (FOUNDATION.md)
- Architecture decisions (ADRs)
- Research findings (session logs, process memory)
- Validated constraints and requirements

### Layer 2: Spec-Driven Development (Implementation Level)
**Scope:** Formalization of validated ideas, structured execution
**Source:** STAGE1_DELIVERABLES (GitHub Spec Kit)
**Active:** When implementing what discovery validated

**Governs:**
- How we formalize discoveries into specifications
- How we plan technical implementation
- How we decompose work into atomic tasks
- How we execute and validate incrementally

**Consumes:**
- Product vision → User-centric specifications
- Foundation principles → Constitution/governing rules
- Architecture decisions → Technical preferences
- Research findings → "What to build" input
- Constraints → Real-world limitations in specs

**Produces:**
- Formal specifications (specs/*/1-specify.md)
- Technical plans (specs/*/2-plan.md)
- Atomic task lists (specs/*/3-tasks.md)
- Implemented, validated code

### The Relationship

**NOT sequential:**
```
Discovery Phase → THEN → Spec-Driven Phase  ❌
```

**Complementary scopes:**
```
Discovery-Driven Development (Outer Layer - Always Active)
    └── Contains: Spec-Driven Development (Inner Layer - When Building)
```

**Living cycle:**
```
Discovery (Explore & Validate)
    ↓ produces context
Spec-Driven (Formalize & Execute)
    ↓ implementation learnings
Discovery (Adapt & Refine)
    ↓ updated context
Spec-Driven (Update Specs & Continue)
```

---

## Rationale

### Why Two Layers Are Needed

**Discovery-Driven alone:**
- ✅ Excellent for exploration and validation
- ✅ Enables rapid pivots based on learnings
- ❌ Lacks structure for implementation execution
- ❌ AI agents can "lose sight" during coding without continuous reference

**Spec-Driven alone:**
- ✅ Excellent for structured implementation
- ✅ Prevents scope creep with living specifications
- ❌ Requires validated "what to build" as input
- ❌ Can't adapt if fundamental assumptions prove wrong

**Together:**
- ✅ Discovery validates what/why, Spec-Driven structures how
- ✅ Discovery produces Spec-Driven's required foundation
- ✅ Spec-Driven learnings feed back to Discovery refinement
- ✅ Enables both exploration AND execution without losing sight

### Validation: We've Been Building Spec Kit's Foundation

Analysis validated user's intuition that foundation/discovery work prepared Spec Kit integration:

| Spec Kit Requirement | What We Built | Document/Artifact |
|---------------------|---------------|-------------------|
| Constitution (governing principles) | Foundation Imperatives | FOUNDATION.md |
| Project memory | Process memory, session logs, checkpoints | /docs, /sessions, /checkpoints |
| User-centric info | Product vision, user journey | PRODUCT_VISION.md |
| Technical preferences | Technology stack decisions | ADR-009, ADR-008 |
| Real-world constraints | Documented limitations | PROCESS_MEMORY.md |
| Organizational standards | AI-First, Foundation imperatives | FOUNDATION.md, config/ |
| Discovery findings | Research, validation, architecture | PERPLEXITY_VALIDATION_ANALYSIS.md |
| Living artifacts | Continuous refinement | Checkpoints, session logs |

**Complete alignment.** Discovery-Driven work produced exactly what Spec-Driven needs.

---

## Consequences

### Positive
- ✅ Clear methodology architecture (when each applies)
- ✅ Spec Kit integration leverages existing foundation (not starting from scratch)
- ✅ Discovery and implementation work together seamlessly
- ✅ Prevents "losing sight" during coding (living specs as reference)
- ✅ Enables both exploration flexibility AND execution structure
- ✅ Foundation work validated as valuable preparation (not wasted time)

### Negative
- ⚠️ More complex to explain (two-layer architecture vs. single methodology)
- ⚠️ Requires AI agents to understand both scopes and when each applies
- ⚠️ Documentation needs to reflect both layers consistently

### Neutral
- 📝 Spec Kit tool only needed for implementation phases (not discovery)
- 📝 Discovery methodology continues throughout (doesn't "end" when Spec-Driven starts)
- 📝 Phase 1 specifications bridge discovery and implementation

---

## Alternatives Considered

### 1. Sequential Phases (Discovery → Spec-Driven)
**Rejected:** Implies discovery stops when implementation begins. Reality: strategic discoveries continue, specs update based on learnings.

### 2. Replace Discovery-Driven with Spec-Driven
**Rejected:** Spec-Driven requires validated "what to build" as input. Can't explore unknown feasibility with specs alone.

### 3. Replace Spec-Driven with Discovery-Driven
**Rejected:** Discovery-Driven lacks structure for implementation execution. AI agents lose sight during coding without continuous specification reference.

### 4. Adopt Single Unified Methodology
**Rejected:** No single methodology addresses both exploration and execution adequately. Two layers at different scopes is the right architecture.

---

## Foundation Alignment

### Holistic System Thinking ✓
- **Discovery-Driven:** Experiments validate system-wide feasibility
- **Spec-Driven:** Specifications capture system-wide context and dependencies
- **Together:** Prevent tunnel vision at both strategic and tactical levels

### AI-First ✓
- **Discovery-Driven:** Decision logs create institutional memory
- **Spec-Driven:** Living specs enable continuous AI reference
- **Together:** AI agents operate autonomously with persistent context

### Configurability ✓
- **Discovery-Driven:** Methodology configurable based on learnings
- **Spec-Driven:** Specifications are configuration for development
- **Together:** Behavior driven by documented artifacts

### Modularity ✓
- **Discovery-Driven:** Small experiments = modular learning units
- **Spec-Driven:** Atomic tasks = modular work units
- **Together:** Independent, testable components at all levels

### Extensibility ✓
- **Discovery-Driven:** New experiment types can be added
- **Spec-Driven:** Process extends to any sub-project
- **Together:** Scales from exploration to implementation

### Integration ✓
- **Discovery-Driven:** Experiments focus on integration feasibility
- **Spec-Driven:** Specifications define integration contracts
- **Together:** Ensures components work together

### Automation ✓
- **Discovery-Driven:** Session protocols enforce rigor
- **Spec-Driven:** Commands automate planning/decomposition
- **Together:** Reduces manual overhead, enables AI autonomy

---

## Implementation Notes

### Configuration Updates Required

**FOUNDATION.md:**
```markdown
## Methodology Architecture

**Project Level:** Discovery-Driven Development with Lean Principles (ADR-001)
- Exploration, validation, strategic decisions
- Active throughout project lifecycle

**Implementation Level:** Spec-Driven Development with GitHub Spec Kit (ADR-010)
- Formalize validated ideas into specifications
- Structure execution to prevent "losing sight"
- Active during implementation phases

**Relationship:** Complementary scopes, not sequential phases
```

**config/project.yml:**
```yaml
methodologies:
  project_level:
    name: "Discovery-Driven Development with Lean Principles"
    scope: "Exploration, validation, strategic decisions"
    active: "Throughout project lifecycle"
    reference: "decisions/2025-11-10-foundation-methodology.md"

  implementation_level:
    name: "Spec-Driven Development with GitHub Spec Kit"
    scope: "Formalized specifications, structured execution"
    active: "During implementation phases"
    reference: "decisions/2025-11-12-methodology-architecture.md"

  relationship: "Complementary - Discovery feeds Spec, Spec learnings feed Discovery"
  integration_analysis: "docs/METHODOLOGY_INTEGRATION_ANALYSIS.md"
```

### When Each Methodology Applies

**Discovery-Driven applies when:**
- Exploring feasibility (technical unknowns)
- Researching options (architecture, tools, approaches)
- Making strategic decisions (technology stack, methodology)
- Validating assumptions (experiments, prototypes)
- Pivoting based on learnings (course corrections)

**Spec-Driven applies when:**
- We know WHAT to build (discovery validated it)
- Ready to implement (foundation stable)
- Need atomic task decomposition (prevent scope creep)
- Executing code (perplex-transformer, perplex-reader)

**BOTH apply simultaneously when:**
- Writing Phase 1 specifications (discovery findings → formal specs)
- Implementation reveals new discoveries (specs update, decisions logged)
- Refining architecture (iterative learning + structured execution)

### Current Project Phase

**Status:** Foundation complete, Discovery phase active

**Discovery-Driven activities:**
- ✅ Explored Perplexity integration feasibility
- ✅ Validated Stage 1 architecture (MCP + basic-memory)
- ✅ Researched memory server options
- ✅ Documented constraints and requirements

**Spec-Driven activities:**
- ⏳ Prepare to formalize discoveries (Phase 1 specifications)
- ⏳ Install Spec Kit tool (implementation layer)
- ⏳ Generate technical plans from specifications
- ⏳ Execute perplex-transformer and perplex-reader implementation

**Bridge:** Phase 1 specifications translate discovery findings into Spec-Driven format.

---

## Related Decisions

- **ADR-001:** Discovery-Driven Development with Lean Principles (Project Level methodology)
- **ADR-002:** Foundation Enhancements (Enforcement, traceability, continuity)
- **ADR-006:** Checkpoint System (Session continuity)
- **ADR-008:** Stage 1 Architecture - Methodology and Framework
- **ADR-009:** Technology Stack (Python 3.11 + uv)

---

## Follow-up Actions

- [x] Create this ADR (ADR-010)
- [ ] Update FOUNDATION.md (methodology architecture section)
- [ ] Update config/project.yml (methodologies section)
- [ ] Revise Spec Kit integration prompt (reflect complementary role)
- [ ] Add Spec Kit documentation to repository (docs/external/spec-kit/)
- [ ] Update CLAUDE.md (reference both methodologies in session start)

---

## Review Date

After Phase 1 specifications complete - validate methodology architecture works in practice.

---

## Notes

**User's Strategic Insight:**
This ADR resulted from user identifying that foundation/discovery work appeared to be "preparing the context Spec Kit needs." Analysis validated this intuition completely - we've been building Spec Kit's required foundation through Discovery-Driven approach.

**Key Learning:**
Methodologies at different scopes can work together beautifully when their relationship is explicit. Discovery-Driven (project level) and Spec-Driven (implementation level) complement each other because Discovery produces what Spec-Driven consumes.

**For Future AI Agents:**
Read both ADR-001 (Discovery-Driven) and this ADR (Integration Architecture) to understand the complete methodology picture. They're not competing - they're complementary layers.

---

**Analysis Document:** docs/METHODOLOGY_INTEGRATION_ANALYSIS.md (comprehensive mapping and validation)

**Status:** Accepted - Methodology architecture formalized

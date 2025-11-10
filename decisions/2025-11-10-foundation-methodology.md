# 001. Adopt Discovery-Driven Development with Lean Principles

**Date:** 2025-11-10
**Status:** Accepted
**Deciders:** AI Agent with Human Partner alignment

## Context

Project Perplex is in its inception phase with:
- No existing codebase or implementation
- Unclear technical feasibility for core integration (Perplexity has no API/CLI)
- Non-technical human partner requiring AI-first autonomous development
- Need for rapid learning and adaptation

We need to choose a development methodology that fits these constraints.

## Decision

Adopt **Discovery-Driven Development with Lean Principles** as our core methodology:

- **Small Experiments:** Focus on learning over building
- **Fast Feedback Loops:** Quick validation of assumptions
- **Decision Logs as First-Class Artifacts:** ADRs for all significant decisions
- **Autonomous Work Within Clear Boundaries:** AI agent operates independently within strategic direction
- **Regular Vision Alignment:** Check progress against product vision, not just tasks

## Rationale

Traditional methodologies don't fit our unique situation:

- **Waterfall:** Too rigid for unknown feasibility
- **Pure Agile:** Assumes known solution space, requires human-in-loop ceremonies
- **Pure Lean Startup:** Too product/market focused vs. technical feasibility
- **Pure Research:** Lacks delivery structure

Discovery-Driven Development fits because:
1. Embraces uncertainty about technical feasibility
2. Prioritizes learning over premature building
3. Works with AI-first autonomous development
4. Allows rapid pivots based on discoveries
5. Maintains strategic direction while enabling tactical flexibility

## Consequences

### Positive
- Can explore integration possibilities without commitment
- Fast adaptation to learnings
- No wasted effort on infeasible approaches
- AI agent can operate autonomously within experimental boundaries
- Continuous learning and improvement

### Negative
- May feel slow initially (learning vs. building)
- Requires discipline to document learnings
- Harder to estimate timelines
- Less predictable than traditional methods

### Neutral
- Milestone-based progress rather than sprint-based
- Deliverables are learnings + working experiments
- Success metrics focus on validated learnings

## Alternatives Considered

### 1. Traditional Agile/Scrum
- **Rejected:** Requires human-in-loop ceremonies (standups, sprint planning)
- Assumes known solution space
- Not optimized for AI-first development

### 2. Shape Up (Basecamp)
- **Considered:** Good principles for autonomous work
- Partial adoption: "shaping" concepts used in boundaries setting
- Too prescriptive for discovery phase

### 3. Extreme Programming (XP)
- **Rejected:** Assumes building code from day one
- Test-driven approach premature when feasibility unknown
- Requires pair programming (not applicable)

### 4. Kanban
- **Partial adoption:** Flow-based work useful
- But lacks structure for learning and discovery
- Will use for task visualization

## Foundation Alignment

### Holistic System Thinking
- [x] Forces consideration of entire problem space
- [x] Experiments validate system-wide feasibility
- [x] Prevents premature optimization

### AI-First
- [x] Enables autonomous experimentation
- [x] Decision logs create institutional memory
- [x] Self-documenting process fits AI continuity

### Configurability
- [x] Methodology itself is configurable based on learnings
- [x] Experiments can have varying parameters

### Modularity
- [x] Small experiments are modular learning units
- [x] Can explore different aspects independently

### Extensibility
- [x] Methodology can evolve as project matures
- [x] New experiment types can be added

### Integration
- [x] Experiments focus on integration feasibility
- [x] Learnings integrate into decision-making

### Automation
- [x] Session protocols automate continuity
- [x] Documentation generation can be automated
- [x] Validation scripts enforce rigor

## Related Decisions

- This is the first ADR
- Future decisions will reference this methodology choice

## Implementation Notes

Practical application:
1. Each exploration phase = experiment with hypothesis
2. Document hypothesis, execution, results in `/knowledge/research`
3. Create ADR when learning leads to decision
4. Review product vision regularly to stay aligned
5. Milestones = validated learnings, not features shipped

## Follow-up Actions

- [x] Document methodology in configuration
- [ ] Create experiment template in `/knowledge/research`
- [ ] Define what constitutes "validated learning"
- [ ] Establish milestone criteria for phase transitions

## Review Date

End of Foundation Phase - reassess if methodology fits

## Notes

This methodology choice itself is an experiment. If we discover it doesn't serve the project well, we'll document learnings and adapt.

The key is: **We're not building a product yet. We're validating whether we CAN build it, and HOW.**

---

**Session Note:** This decision was implicit in initial foundation setup conversations. Documenting explicitly for future session context and to validate the choice.

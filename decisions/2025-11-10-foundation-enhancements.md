# 002. Foundation Enhancements - Enforcement, Traceability, and Continuity

**Date:** 2025-11-10
**Status:** Accepted
**Deciders:** AI Agent with Human Partner validation

## Context

After completing initial foundation (ADR-001), human partner identified critical gaps:

1. **Alignment checks were manual, not automated** - Relies on discipline, no enforcement
2. **No formal specification/requirements layer** - Gap between vision and implementation
3. **No branching strategy or CI/CD** - Undefined git workflow
4. **No enforcement mechanisms** - Missing git hooks, automated validation
5. **Continuity gap** - Risk of catastrophic context loss (Claude Code Web lacks persistent memory)

Additionally, human partner requested:
- **Ideas logging system** - Capture possibilities throughout process
- **Honest assessment** - Don't just agree, identify real gaps

This ADR documents the comprehensive enhancements made to address these gaps.

## Decision

Implement six major foundation enhancements:

### 1. Ideas Logging System
Create lightweight capture mechanism for ideas (from both human and AI) with status workflow.

### 2. Automated Enforcement (Git Hooks)
Implement pre-commit and commit-msg hooks to automatically enforce standards.

### 3. Requirements & Traceability System
Add formal specification layer bridging vision and implementation with full traceability matrix.

### 4. Branching Strategy
Document AI-autonomous, examinable git workflow aligned with "trusted employee" model.

### 5. Enhanced Session Logs
Improve session logs to capture mental models, context, and recovery information.

### 6. Continuity & Recovery Protocols
Document the continuity gap honestly and create mitigation strategies.

## Rationale

### Why Ideas System
- Ideas emerge throughout development (from human and AI)
- Current ad-hoc capture loses potentially valuable insights
- Lightweight system prevents forgetting without heavy process
- Integration with decisions (ideas → ADRs) and research flows naturally

### Why Automated Enforcement
- Manual validation relies on discipline
- AI agents face cognitive load just like humans
- Automated checks prevent drift without burden
- Git hooks run automatically - no way to forget
- Protects against "just get it done" shortcuts under pressure

### Why Requirements & Traceability
- Gap between vision (what we want) and implementation (what we build)
- Requirements formalize vision into measurable specifications
- Traceability prevents building wrong things well
- Links vision → requirements → decisions → implementation → validation
- Makes "alignment" concrete and verifiable

### Why Branching Strategy
- No defined workflow creates uncertainty
- "AI-autonomous but examinable" requires clear process
- "Trusted employee filing reports" model fits perfectly
- PRs provide transparency without approval gates
- Branch protection ensures main stays stable

### Why Enhanced Session Logs
- Basic logs don't capture mental models
- Context loss is real risk (Claude Code Web limitation)
- Future sessions need more than "what" - need "why" and "how we're thinking"
- Recovery information enables continuation after failure
- Explicit mental model documentation preserves understanding

### Why Continuity Documentation
- Honesty about limitations builds trust
- Acknowledging gap enables mitigation
- MCP servers not available, but we can still improve
- "Write for the session that has to resume without you" principle
- Recovery protocols turn abstract into concrete

## Consequences

### Positive
- ✅ **Automated enforcement** prevents drift without cognitive load
- ✅ **Traceability** makes alignment verifiable, not aspirational
- ✅ **Ideas system** captures possibilities without heavy process
- ✅ **Branching strategy** enables autonomous but examinable work
- ✅ **Enhanced logs** improve context preservation significantly
- ✅ **Continuity protocols** mitigate (though don't eliminate) memory gap
- ✅ **Honest gap documentation** builds trust and sets realistic expectations

### Negative
- ⬜ **More upfront work** - Additional documentation to maintain
- ⬜ **Learning curve** - More systems to understand
- ⬜ **Commit overhead** - Git hooks add validation time
- ⬜ **Can't eliminate continuity gap** - Limitation remains, only mitigated

### Neutral
- 🟡 **More structure** - Some may find constraining, others liberating
- 🟡 **Visible gaps** - Honest assessment exposes limitations
- 🟡 **Process evolution** - Systems will adapt based on learnings

## Alternatives Considered

### 1. Keep Foundation Minimal
**Rejected:** Gaps identified were real and would cause problems
- Would rely on perfect discipline
- No safety nets for cognitive load
- Context loss risk unmitigated

### 2. Add Only Automation (Skip Requirements/Traceability)
**Considered:** Less upfront work
**Rejected:** Would automate checking against... what? Requirements make checks meaningful

### 3. Pretend Continuity Gap Doesn't Exist
**Rejected:** Dishonest and unhelpful
- Better to acknowledge and mitigate
- False confidence worse than honest limitation

### 4. Wait to Add These Until Needed
**Rejected:** Gaps cause more pain during implementation
- Harder to retrofit than build in foundation
- Enforcement prevents problems before they occur

## Foundation Alignment

### Holistic System Thinking
- [x] Each system integrates with others (ideas → research/decisions, traceability links all, etc.)
- [x] Considered ripple effects of adding structure
- [x] Branching strategy thinks through whole development lifecycle

### AI-First
- [x] All systems designed for AI agent primary use
- [x] Automation removes manual burden
- [x] Session logs written for future AI sessions
- [x] Branching enables AI autonomy

### Configurability
- [x] Git hooks can be customized
- [x] Branching strategy documented but can evolve
- [x] Session log template can be adapted

### Modularity
- [x] Each system (ideas, requirements, etc.) is independent
- [x] Can be adopted incrementally if needed
- [x] Clear boundaries between systems

### Extensibility
- [x] Ideas system can add new statuses
- [x] Requirements can expand types
- [x] Branching strategy supports multiple AI agents
- [x] Session logs template can be enhanced

### Integration
- [x] Ideas integrate with decisions and research
- [x] Requirements link to vision and decisions
- [x] Traceability shows all integration points
- [x] Git hooks integrate validation into workflow

### Automation
- [x] Git hooks automate enforcement
- [x] Ideas index auto-generated
- [x] Status updates automated
- [x] Validation runs automatically

## Related Decisions

**Builds on:**
- ADR-001: Discovery-Driven Methodology - These enhancements support that methodology

**Future decisions:**
- Will reference requirements system when formalizing feature specs
- Will use branching strategy for all development
- Will leverage ideas system throughout discovery

## Implementation Notes

**Created Systems:**

1. **Ideas:** `/ideas` directory with template, README, index
   - Script: `tools/generate-ideas-index.sh`

2. **Git Hooks:** `.githooks/` with pre-commit and commit-msg
   - Configured: `git config core.hooksPath .githooks`

3. **Requirements:** `/requirements` with template, README, traceability
   - Subdirs: `functional/` and `non-functional/`

4. **Branching Docs:** `docs/BRANCHING_STRATEGY.md`
   - Comprehensive workflow documentation
   - PR standards and templates

5. **Enhanced Logs:** `sessions/SESSION_LOG_TEMPLATE.md`
   - Recovery information sections
   - Mental model documentation

6. **Continuity:** `docs/CONTINUITY_AND_RECOVERY.md`
   - Honest gap assessment
   - Recovery protocols
   - Mitigation strategies

**Updated:**
- README.md - Added new directories
- Directory structure - Added `/ideas` and `/requirements`
- Validation script - Now runs via git hooks
- Session protocols - Enhanced for better context capture

## Follow-up Actions

- [x] Create all directory structures
- [x] Write comprehensive documentation
- [x] Implement git hooks and configure
- [x] Create templates for new systems
- [x] Document honestly about limitations
- [ ] Test git hooks in practice (next commit will test)
- [ ] Validate session log template in next session
- [ ] Create first requirement when moving to implementation
- [ ] Use ideas system when possibilities emerge

## Review Date

After 5-10 sessions using these systems - validate they work in practice and refine.

## Notes

### On Honest Assessment

The human partner explicitly valued honesty over agreement. They've experienced Claude instances that fail to identify gaps, leading to problems.

This ADR documents both strengths and honest gaps. That's the right foundation for trust.

### On "Trust But Verify"

The branching strategy embodies "work autonomously, make everything examinable" - like a trusted employee filing status reports.

Not approval gates. Transparency mechanisms.

### On Continuity

We can't eliminate the continuity gap (Claude Code Web limitation), but we can mitigate significantly through:
- Richer session logs
- Mental model documentation
- Recovery protocols
- Self-documenting repository

Acknowledging what we can't fix while maximizing what we can.

### On Integration

These six enhancements form an integrated system:
- Ideas feed research and decisions
- Requirements formalize vision
- Traceability links everything
- Git hooks enforce standards
- Branching enables workflow
- Continuity preserves understanding

Together, they close the gaps identified in foundation review.

---

**Key Insight:** "Most Claude Code instances find it very difficult to say out loud when something is missing."

This ADR exists because we said out loud what was missing, then built it.

That's the foundation working as intended.

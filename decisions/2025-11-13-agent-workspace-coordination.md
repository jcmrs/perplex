# ADR-011. Agent Workspace Boundaries and Coordination Protocol

**Date:** 2025-11-13
**Status:** Accepted
**Deciders:** Both (User strategic insight, AI agent implementation design)
**Agent Creator:** web-claude-designer-001
**Decision Scope:** architecture, strategic-planning

## Context

Project Perplex uses multiple AI agents collaborating on the same repository:
- **Claude Code Web (Web):** Designer-researcher role, browser-based environment
- **Claude Code CLI (CLI):** Executor-validator role, local Windows environment

While we've established identity management (`.claude/identity-*.json`, agent registry) and communication protocols (envelope format), we have **not formalized workspace boundaries** - which agent owns which files, who can modify what, and how agents coordinate work transitions.

### The Problem

**Current state creates conflict risks:**
1. Both agents can modify any file without boundary enforcement
2. No visibility into "what is Web working on vs CLI"
3. Potential simultaneous work on same files (e.g., CURRENT_STATUS.md conflict)
4. No clear ownership or accountability for artifacts
5. Handoffs between agents are ad-hoc, not formalized
6. Documentation alone insufficient - agents under cognitive load forget conventions

**User's Strategic Insight:**
"Git worktrees concept keeps bugging me... I suspect highly we may run into issues with specificity and clarity once Spec Kit comes into play."

**Analysis reveals:** User sensed need for workspace separation before formal specification work begins. Two agents in separate physical environments need formalized coordination, not just documentation.

**Critical timing:** Spec Kit will create living specifications (spec.md, plan.md, tasks.md) that both agents reference and update. Without clear boundaries:
- Conflicting updates to specifications
- Unclear responsibility for artifact maintenance
- No enforcement of proper workflow (design → plan → implement → validate)

### Foundation Imperative Violation

**Automation imperative:** "Repetitive tasks are scripted; manual processes are temporary."

We're relying on agents "remembering" to:
- Work in correct file boundaries
- Coordinate handoffs properly
- Track who's working on what
- Follow workspace conventions

**Historical evidence:** Branch convention violated 3 times by CLI before git hook enforcement prevented 4th violation. **Enforcement works, documentation alone doesn't.**

## Decision

Implement **Agent Workspace Coordination Protocol** with four enforcement layers:

### 1. Workspace Manifest (`.claude/workspace-coordination.yml`)

Machine-readable definition of:
- Which agent owns which directories/files
- Shared vs read-only access patterns
- Current work tracking per agent
- Handoff triggers and coordination rules

### 2. Local Enforcement (Git Hooks Enhancement)

Pre-commit hook validates:
- Agent identity (from identity file)
- Files being modified (git diff)
- Ownership boundaries (from workspace manifest)
- **BLOCKS commits** that violate boundaries

### 3. Work Tracking (Agent Registry Enhancement)

Agent registry tracks:
- `current_work_branch`: Active feature branch
- `active_specifications`: What specs agent is working on
- `workspace_state`: Current phase of work (designing, planning, implementing, validating)
- Timestamps for coordination visibility

### 4. Handoff Automation (New Tooling)

Formal scripts:
- `tools/agent-start-work.sh`: Initialize work, update registry, create branch
- `tools/agent-handoff.sh`: Complete work phase, validate artifacts, trigger next agent
- `tools/agent-check-registry.sh`: Check what other agents are doing

### 5. GitHub Validation (Workflow)

New workflow (`.github/workflows/workspace-validation.yml`):
- Validates PRs respect workspace boundaries
- Checks modified files against branch owner
- Enforces proper agent workflow patterns

## Rationale

**Why enforcement over documentation:**
- Git hook enforcement prevented 4th branch violation (working proof)
- Agents under cognitive load forget conventions
- Automation aligns with AI-First foundation imperative
- Machine-readable rules enable consistent enforcement

**Why before Spec Kit work:**
- Spec Kit creates living specifications both agents will modify
- Clear ownership prevents specification conflicts
- Formal handoffs enable design → plan → implement workflow
- Specifications require traceability to agent creators

**Why layered approach:**
- Local enforcement (git hooks): Fast feedback, blocks mistakes immediately
- Agent registry: Coordination visibility without blocking
- GitHub validation: Safety net for remote work
- Handoff automation: Formalizes transitions, not just detects violations

**Why manifest-driven:**
- Configurability: Ownership rules in YAML, not hardcoded
- Extensibility: Easy to add new agents or change boundaries
- AI-First: Agents can read manifest to understand boundaries
- Modularity: Workspace coordination is separate system with defined interfaces

## Consequences

### Positive

**Conflict Prevention:**
- Impossible to accidentally modify files outside ownership
- Clear boundaries reduce coordination friction
- Handoff automation prevents workflow mistakes

**Accountability & Traceability:**
- Every artifact has clear owner agent
- Decision scope validation (ADRs match agent's role)
- Audit trail: agent identity + workspace + git commits = full traceability

**Cognitive Load Reduction:**
- Agents don't need to "remember" boundaries
- Enforcement handles coordination automatically
- Registry provides state visibility without mental tracking

**Spec Kit Preparation:**
- Clear ownership: spec.md (Web), plan.md/tasks.md (CLI)
- Formal workflow: design → plan → implement → validate
- Living specs can evolve without conflict risks

**Foundation Alignment:**
- Automation: Enforced coordination, not manual
- AI-First: Machine-readable state and rules
- Modularity: Workspace coordination as separate system
- Holistic: Integration audit ensures ripple effects considered

### Negative

**Additional Complexity:**
- More systems to maintain (manifest, scripts, workflows)
- Learning curve for understanding boundaries
- Potential for over-constraining flexibility

**Enforcement Rigidity:**
- Legitimate cross-boundary work requires manifest updates
- May slow down exploratory work
- Could create false-positive blocks

**Maintenance Burden:**
- Workspace manifest must stay synchronized with reality
- Scripts need testing and validation
- GitHub workflow adds CI/CD overhead

### Neutral

**Explicit vs Implicit:**
- Makes existing informal practices formal
- Changes agent workflow (now runs start-work/handoff scripts)
- Git commits include workspace validation step

**Centralized Coordination:**
- Agent registry becomes source of truth for work state
- Single point of coordination (benefit and risk)

## Alternatives Considered

### Alternative 1: Documentation Only

**What:** Document workspace boundaries in CLAUDE.md, rely on agents following conventions.

**Why not chosen:**
- Historical evidence: 3 branch violations before enforcement
- Documentation violated under cognitive load
- No prevention mechanism, only post-hoc detection
- Conflicts with Automation imperative

### Alternative 2: Git Worktrees (User's Initial Intuition)

**What:** Use git worktrees to give each agent separate working directory.

**Why not chosen:**
- Worktrees are local feature, doesn't work across Web (browser) and CLI (local)
- Doesn't solve coordination problem, only separation
- GitHub repository doesn't have worktree concept
- User's intuition was correct about NEED, not the tool

**What we learned:** Need is workspace separation and coordination, solution is manifest + enforcement.

### Alternative 3: Separate Repositories

**What:** Web works in perplex-design repo, CLI works in perplex-implementation repo.

**Why not chosen:**
- Loses unified history and traceability
- Creates integration complexity (syncing between repos)
- Violates "Project = Repository" foundation principle
- GitHub coordination becomes primary workflow (overhead)

### Alternative 4: Branch Protection Rules (GitHub Only)

**What:** Use GitHub branch protection, CODEOWNERS for file-level rules.

**Why not chosen:**
- No local enforcement (mistakes pushed before detection)
- CODEOWNERS requires human approval (conflicts with AI-First)
- Doesn't solve agent coordination problem
- No handoff automation or work tracking

**Why we include GitHub validation anyway:** Safety net, not primary enforcement.

### Alternative 5: Manual Coordination (Status Quo)

**What:** Continue with informal "Web does design, CLI does implementation."

**Why not chosen:**
- Already caused CURRENT_STATUS.md conflict
- Spec Kit will increase coordination complexity
- Doesn't scale to future additional agents
- User correctly predicted "specificity and clarity issues"

## Foundation Alignment

### Holistic System Thinking
- [x] Considered ripple effects: Identity, git workflows, Spec Kit, documentation, automation
- [x] Understood interactions: Created integration audit (14 points across 5 systems)
- [x] Long-term implications: Designed for 3+ agents, extensible manifest

### AI-First
- [x] Enables autonomy: Agents know boundaries without human clarification
- [x] Preserves context: Workspace state in registry, manifest survives sessions
- [x] Non-human-in-loop: Enforcement automatic, no approval gates

### Configurability
- [x] External configuration: Workspace manifest drives all behavior
- [x] Avoids hardcoding: Ownership rules in YAML
- [x] Environment flexibility: Works across Web/CLI/future agents

### Modularity
- [x] Clear boundaries: Workspace coordination is separate system
- [x] Independent evolution: Can change manifest without touching git hooks
- [x] Single responsibility: Each layer has distinct role

### Extensibility
- [x] Future additions: Easy to add new agents to manifest
- [x] Doesn't close options: Can relax boundaries if needed
- [x] Extension points: Handoff protocol can add new triggers

### Integration
- [x] Component connections: Explicit integration audit created
- [x] Standard interfaces: Git hooks, agent registry, GitHub Actions
- [x] System communication: Agent registry provides coordination state

### Automation
- [x] Repetitive automation: Start-work, handoff scripts formalize transitions
- [x] Scripting enabled: All coordination machine-readable and scriptable
- [x] Reduced manual: Enforcement prevents mistakes without human intervention

## Related Decisions

**Builds Upon:**
- ADR-010: Methodology Architecture - Workspace coordinates Discovery-Driven (Web) vs Spec-Driven (CLI) workflow
- Multi-agent identity management - Identity files define roles, workspace defines boundaries
- Local automation strategy - Pre-push hook pattern extended to workspace validation

**Enables:**
- Spec Kit integration - Clear ownership of spec.md, plan.md, tasks.md
- Sequential sub-projects strategy - Formal handoff between transformer → reader stages
- Future agent additions - Manifest extensible to additional agents

**Related Systems:**
- `.claude/identity-*.json` - Defines agent capabilities and roles
- `.claude/agent-registry.json` - Tracks active work and coordination
- `.githooks/pre-commit` - Local enforcement mechanism
- GitHub Actions workflows - Remote validation and automation

## Implementation Notes

### Stage 1: Design & Formalization (This ADR)
- [x] ADR-011 creation
- [ ] Workspace manifest structure (`.claude/workspace-coordination.yml`)
- [ ] Documentation (`docs/AGENT_WORKSPACE_COORDINATION.md`)
- [ ] Integration audit with checklist

### Stage 2: Enforcement Implementation (Next Session)
- [ ] Enhance `.githooks/pre-commit` with workspace validation
- [ ] Create `tools/agent-start-work.sh`
- [ ] Create `tools/agent-handoff.sh`
- [ ] Create `tools/agent-check-registry.sh`
- [ ] Create `.github/workflows/workspace-validation.yml`
- [ ] Update `.claude/agent-registry.json` schema

### Stage 3: Integration & Validation (Follow-up Session)
- [ ] Update all 14 integration points from audit
- [ ] Test with simulated conflicts
- [ ] Run completeness review
- [ ] Validate against foundation imperatives
- [ ] Update README.md with multi-agent workspace concept

### Critical Gotchas

**Pre-commit hook complexity:**
- Must read identity file to determine agent
- Must parse workspace manifest (YAML in bash or call Python)
- Must handle shared files gracefully (both agents allowed)
- Error messages must be clear and actionable

**Agent registry race conditions:**
- Both agents could update registry simultaneously
- Solution: Registry updates happen in commits (git serialization)
- Agents must pull before checking registry

**Workspace manifest maintenance:**
- Must stay synchronized with actual usage
- Solution: GitHub validation workflow detects violations
- Completeness review checks manifest accuracy

**Handoff automation timing:**
- Web might finish spec while CLI unavailable (session limit)
- Solution: Handoff creates marker file, CLI checks on startup
- Agent registry records handoff state persistently

**Spec Kit integration:**
- Slash commands (e.g., `/speckit.specify`) need agent identity awareness
- Solution: Commands check identity file, validate agent can execute
- Web executes constitution/specify, CLI executes plan/tasks/implement

## Follow-up Actions

**Stage 1 (Current Session):**
- [x] Create ADR-011
- [ ] Create workspace manifest structure
- [ ] Create AGENT_WORKSPACE_COORDINATION.md documentation
- [ ] Create integration audit checklist
- [ ] Commit Stage 1 artifacts

**Stage 2 (Next Session):**
- [ ] Implement git hook enhancement
- [ ] Create agent coordination scripts
- [ ] Create GitHub validation workflow
- [ ] Test enforcement with simulated violations

**Stage 3 (Follow-up Session):**
- [ ] Complete integration audit updates
- [ ] Test with real Spec Kit workflow
- [ ] Document learnings and adjust manifest
- [ ] Create checkpoint: "Workspace coordination operational"

## Review Date

**Before Stage 1 (perplex-transformer) specification work begins.**

Review questions:
- Are boundaries too rigid or too loose?
- Do handoff triggers cover all transitions?
- Is manifest easy to understand and maintain?
- Are error messages helpful for agents?

**Ongoing reviews:**
- After first Spec Kit workflow completion
- When adding third agent (future)
- If conflicts occur despite enforcement

## Notes

### User's Strategic Insight

**Non-technical user correctly identified:**
1. Git worktrees concept → sensed need for workspace separation
2. "Specificity and clarity issues once Spec Kit comes into play" → predicted conflict risks
3. "Can't just rely on remembering to do X and Y" → recognized enforcement necessity

**This validates AI-First principle:** Non-technical strategic partners can identify architectural needs even without technical implementation knowledge.

### Design Philosophy

**"Enforce, don't document"** - Lessons from branch convention violations:
- 3 attempts to push to main (documented but not enforced)
- Git hook blocks 4th attempt (enforced)
- Workspace coordination follows same pattern

**"Just-in-time and selective"** - Lessons from checkpoint system:
- Agent registry provides "what's happening now" visibility
- Workspace manifest provides "what's allowed" rules
- Handoff markers provide "what's next" coordination

**"Complementary layers"** - Lessons from methodology architecture:
- Local enforcement: Fast feedback
- Agent registry: Coordination visibility
- GitHub validation: Safety net
- Handoff automation: Workflow formalization

Each layer has distinct purpose, together create robust system.

### Future Extensions

**Potential additions:**
- Workspace dashboard (visualize agent activity)
- Conflict prediction (detect overlapping work plans)
- Auto-handoff (trigger next agent when criteria met)
- Workspace analytics (track coordination patterns)
- Multi-project workspace (coordinate agents across multiple Perplex projects)

**Keep it simple for now:** Implement core enforcement, extend based on real usage.

---

**For AI Agents:**

When creating artifacts in this repository, check:
1. **Your identity:** Read `.claude/identity-{environment}.json`
2. **Workspace boundaries:** Read `.claude/workspace-coordination.yml`
3. **Active work:** Check `.claude/agent-registry.json`
4. **Pre-commit validation:** Git hook will verify your work

When handing off work:
1. Run `tools/agent-handoff.sh` (when implemented)
2. Update agent registry with completion status
3. Commit with clear handoff message

**For Humans:**

This decision formalizes what was informal. Benefits:
- Transparency: See which agent is responsible for what
- Predictability: Clear workflow patterns
- Conflict prevention: Enforcement prevents mistakes
- Scalability: System ready for additional agents

Workspace coordination makes multi-agent collaboration systematic, not ad-hoc.

---

**Last Updated:** 2025-11-13
**Status:** Accepted - Stage 1 in progress
**Next Review:** Before perplex-transformer specification begins

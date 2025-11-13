# Project Perplex - Foundation Manifesto

**Project = Repository**
Everything lives here. Version controlled. Persistent. Accessible.

## Core Identity

Project Perplex aims to bridge local AI development tools (Claude Code, Gemini CLI) with Perplexity AI's research capabilities, enabling seamless collaboration without manual context-switching.

## AI Development Team

**Three-Agent Architecture:**

- **CDIR (CLI-Director):** Primary designer, local Windows environment (PowerShell Terminal 1)
- **CEXE (CLI-Executor):** Primary executor, local Windows environment (PowerShell Terminal 2)
- **Web:** Standby emergency backup, browser-based (inactive unless needed)

**Coordination:** Clear workspace boundaries, handoff procedures, envelope communication.

## Foundation Imperatives

These are not guidelines - they are non-negotiable constraints that shape every decision.

### 1. Holistic System Thinking
**What it means:** Every decision affects the whole system. Consider ripple effects, interactions, and emergent behaviors.

**Enforcement:**
- [ ] Before any significant change, document expected system-wide impacts
- [ ] Consider: How does this affect future Claude sessions? Documentation? User workflows?
- [ ] Ask: What breaks if this changes? What becomes possible?

### 2. AI-First
**What it means:** The primary user is the AI agent. The human is a strategic partner, not a human-in-the-loop.

**Enforcement:**
- [ ] Can a fresh Claude session understand this without human explanation?
- [ ] Is documentation machine-readable AND human-readable?
- [ ] Do automation scripts exist for repetitive tasks?
- [ ] Are decisions preserved with full context for future sessions?

### 3. Five Cornerstones

#### Configurability
**What it means:** Behavior driven by external configuration, not hardcoded values.

**Enforcement:**
- [ ] All settings in `/config` directory
- [ ] Configuration files version-controlled
- [ ] Defaults documented with rationale
- [ ] Environment-specific configs clearly separated

#### Modularity
**What it means:** Components can evolve, be replaced, or removed independently.

**Enforcement:**
- [ ] Clear component boundaries and interfaces
- [ ] Dependencies explicitly documented
- [ ] Each module has single, clear responsibility
- [ ] Coupling minimized, cohesion maximized

#### Extensibility
**What it means:** New capabilities can be added without modifying core systems.

**Enforcement:**
- [ ] Plugin/extension points identified
- [ ] APIs designed for future unknown use cases
- [ ] Hooks and integration points documented
- [ ] Core remains stable as extensions grow

#### Integration
**What it means:** Systems connect and communicate effectively.

**Enforcement:**
- [ ] Standard interfaces for component interaction
- [ ] Data formats documented and consistent
- [ ] Integration points explicitly designed
- [ ] External system assumptions documented

#### Automation
**What it means:** Repetitive tasks are scripted; manual processes are temporary.

**Enforcement:**
- [ ] Common operations have scripts in `/tools`
- [ ] Session start/end procedures automated
- [ ] Validation and checks run automatically
- [ ] Manual steps documented as automation candidates

### 4. Proper Product Management & Development Methodologies

**Methodology Architecture:** Two complementary layers operating at different scopes

**Project Level - Discovery-Driven Development with Lean Principles** (ADR-001)
- **Scope:** Exploration, validation, strategic decisions
- **Active:** Throughout entire project lifecycle
- **Principles:** Small experiments, fast learning cycles, decision logs, autonomous work, vision alignment

**Implementation Level - Spec-Driven Development with GitHub Spec Kit** (ADR-010)
- **Scope:** Formalize validated ideas, structure execution
- **Active:** When implementing what discovery validated
- **Principles:** Living specifications, atomic tasks, continuous reference, test-driven validation

**Agent Responsibilities:**

**CDIR executes:**
- `/speckit.constitution` - Establish project principles
- `/speckit.specify` - Create feature specifications
- `/speckit.clarify` - Clarify ambiguities
- `/speckit.analyze` - Cross-artifact validation
- `/speckit.checklist` - Quality validation

**CEXE executes:**
- `/speckit.plan` - Generate technical plans from specs
- `/speckit.tasks` - Decompose into atomic tasks
- `/speckit.implement` - Execute implementation
- `/speckit.analyze` - Cross-artifact validation
- `/speckit.checklist` - Quality validation

**Coordination Pattern:**
1. CDIR creates spec → handoff to CEXE
2. CEXE creates plan → handoff to CDIR for validation
3. CDIR validates plan → handoff back to CEXE
4. CEXE implements → handoff to CDIR for final validation

**Handoff mechanism:** Agent registry (`.claude\agent-registry.json`) + optional handoff markers

**Relationship:** Complementary scopes, not sequential phases
- Discovery produces what Spec-Driven consumes (foundation, constraints, validated "what to build")
- Spec-Driven learnings feed back to Discovery refinement
- Both active simultaneously during implementation (specs update as we learn)

**Enforcement:**
- [ ] Every significant decision logged in `/decisions`
- [ ] Discovery: Experiments documented with hypothesis, execution, learnings
- [ ] Spec-Driven: Specifications formalize discoveries, plans decompose into atomic tasks
- [ ] Progress tracked against vision, not just tasks
- [ ] Retrospectives captured after significant milestones

**Reference:** docs/METHODOLOGY_INTEGRATION_ANALYSIS.md for complete architecture and rationale

## Success Criteria for Foundation Phase

Foundation is considered complete when:

1. ✅ This document exists and is enforced
2. ⬜ AI agent can start any session and immediately understand project state
3. ⬜ All decisions are logged with context and rationale
4. ⬜ Progress is visible and tracked automatically
5. ⬜ Product vision is preserved and regularly referenced
6. ⬜ Foundation imperatives have enforcement mechanisms
7. ⬜ Automation exists for common operations
8. ⬜ Knowledge persists across sessions
9. ⬜ Configuration drives behavior
10. ⬜ System can self-validate alignment with principles

## For Claude Sessions: Start Here

When beginning a session on this project:

1. Read this document first
2. Check `/sessions/CURRENT_STATUS.md` for latest state
3. Review recent `/decisions/*.md` for context
4. Check `/docs/PRODUCT_VISION.md` for alignment
5. Update session log at end of session

## For Human Partner: Your Role

- Set strategic direction
- Validate alignment with vision
- Challenge assumptions
- Approve major architectural decisions
- Provide domain context AI cannot infer

---

*This is a living document. Updates must preserve intent while adapting to learnings.*

**Last Updated:** 2025-11-10
**Status:** Foundation phase - Initial creation

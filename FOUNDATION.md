# Project Perplex - Foundation Manifesto

**Project = Repository**
Everything lives here. Version controlled. Persistent. Accessible.

## Core Identity

Project Perplex aims to bridge local AI development tools (Claude Code, Gemini CLI) with Perplexity AI's research capabilities, enabling seamless collaboration without manual context-switching.

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

**Current Methodology:** Discovery-Driven with Lean Principles
- Small experiments, fast learning cycles
- Decision logs as first-class artifacts
- Autonomous work within clear boundaries
- Regular vision alignment checks

**Enforcement:**
- [ ] Every significant decision logged in `/decisions`
- [ ] Experiments documented with hypothesis, execution, learnings
- [ ] Progress tracked against vision, not just tasks
- [ ] Retrospectives captured after significant milestones

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

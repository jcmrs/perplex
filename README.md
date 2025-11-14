# Project Perplex

**Bridging Local AI Development Tools with Perplexity AI**

> An AI-first project exploring seamless collaboration between Claude Code, Gemini CLI, and Perplexity AI's research capabilities.

---

## 🎯 What is Perplex?

Perplex aims to solve a common problem in AI-assisted development: the friction of manually coordinating between local AI tools (Claude Code, Gemini CLI) and Perplexity AI for research tasks.

**Current Reality:**
- Copy-paste workflows between AI tools and browser
- Context contamination between projects
- Lost research artifacts and conversation history
- No integration path (Perplexity has no API or CLI)

**Perplex Vision:**
- Seamless AI-to-AI collaboration
- Project-specific research organization
- Minimal human intervention required
- Context isolation and preservation

---

## 📊 Project Status

**Phase:** Foundation Complete ✅ → Discovery Phase Ready
**Status:** Multi-agent autonomous workflow operational with workflow duplication fix deployed

**Major Breakthroughs:**
- **2025-11-11:** Fully autonomous PR workflow (GitHub Actions + REST API)
- **2025-11-13 AM:** Multi-agent workspace coordination with enforcement (ADR-011)
- **2025-11-13 PM:** Workflow duplication fix - ref-specific concurrency groups deployed

**Active Agents:**
- **CDIR (CLI-Director)** - Primary designer (PowerShell Terminal 1): Specifications, ADRs, documentation
- **CEXE (CLI-Executor)** - Primary executor (PowerShell Terminal 2): Implementation, testing, validation
- **Web (Standby)** - Emergency backup (browser-based, inactive)

See [`sessions/CURRENT_STATUS.md`](sessions/CURRENT_STATUS.md) for latest state.

---

## 🏗️ Foundation Imperatives

This project is built on non-negotiable principles:

1. **Holistic System Thinking** - Consider ripple effects and interactions
2. **AI-First** - AI agent is the primary user, not human-in-loop
3. **Five Cornerstones:**
   - **Configurability** - Behavior driven by external config
   - **Modularity** - Independent, evolvable components
   - **Extensibility** - New capabilities without core changes
   - **Integration** - Standard interfaces and communication
   - **Automation** - Scripts for repetitive tasks

See [`FOUNDATION.md`](FOUNDATION.md) for complete details.

---

## 📁 Project Structure

```
perplex/
├── FOUNDATION.md           # Core principles and imperatives
├── README.md               # This file
├── LICENSE                 # MIT License
├── CONTRIBUTING.md         # Contribution guidelines
├── CHANGELOG.md            # Version history
│
├── .github/                # GitHub configuration
│   ├── workflows/          # GitHub Actions (PR validation)
│   ├── ISSUE_TEMPLATE/     # Issue templates
│   ├── pull_request_template.md  # PR template
│   └── CODEOWNERS          # Code ownership rules
│
├── .githooks/             # Git hooks for automated enforcement
│   ├── pre-commit         # Foundation validation before commits
│   ├── commit-msg         # Commit message validation
│   └── README.md          # Hook documentation
│
├── config/                # Configuration files
│   ├── project.yml        # Project metadata and settings
│   └── ai-agent.yml       # AI agent operational parameters
│
├── decisions/             # Architecture Decision Records (ADRs)
│   ├── TEMPLATE.md        # ADR template
│   └── *.md              # Individual decisions
│
├── docs/                  # Living documentation
│   ├── PRODUCT_VISION.md          # What we're building and why
│   ├── MILESTONES.md              # Progress tracking
│   ├── VALIDATION_CHECKLIST.md   # Foundation alignment checks
│   ├── BRANCHING_STRATEGY.md     # Git workflow and PR standards
│   ├── CONTINUITY_AND_RECOVERY.md # Context preservation strategies
│   └── *.md                       # Additional documentation
│
├── ideas/                 # Idea capture and tracking
│   ├── TEMPLATE.md        # Idea template
│   ├── INDEX.md           # Ideas by status (auto-generated)
│   └── *.md              # Individual ideas
│
├── knowledge/             # Research and learnings
│   ├── research/          # Investigation findings
│   ├── learnings/         # Mistakes and discoveries
│   ├── external/          # External sources (Perplexity, etc.)
│   └── patterns/          # Reusable patterns
│
├── requirements/          # Specifications and traceability
│   ├── TEMPLATE.md        # Requirement template
│   ├── TRACEABILITY.md    # Vision → Requirements → Implementation links
│   ├── functional/        # Functional requirements
│   └── non-functional/    # Non-functional requirements
│
├── backlog/               # Pending work tracking
│   ├── BACKLOG.md         # Master list by priority
│   ├── items/             # Individual backlog items
│   └── TEMPLATE.md        # Backlog item template
│
├── sessions/              # Session continuity
│   ├── CURRENT_STATUS.md  # Always-current project snapshot
│   └── session-*.md       # Individual session logs
│
├── src/                   # Source code (structure TBD)
│
├── tools/                 # Automation scripts
│   ├── session-start.sh   # Initialize session with context
│   ├── session-end.sh     # Finalize and commit session work
│   ├── validate-foundation.sh # Check alignment with principles
│   ├── validate-workspace-boundaries.sh # Workspace coordination enforcement
│   ├── agent-start-work.sh # Formalize work initialization
│   ├── agent-handoff.sh    # Create handoff markers between agents
│   ├── agent-check-registry.sh # Check agent coordination state
│   └── generate-status.sh # Update CURRENT_STATUS.md
│
├── specs/                 # Feature specifications (Spec Kit)
│   └── NNN-feature-name/  # Individual feature directories
│       ├── spec.md        # Feature specification (Web creates)
│       ├── plan.md        # Technical plan (CLI creates)
│       └── tasks.md       # Atomic task decomposition (CLI creates)
│
├── examples/              # Reference implementations
│   ├── conversations/     # Conversation templates
│   ├── workflows/         # Example workflows
│   └── integrations/      # Integration patterns
│
└── .claude/               # Claude Code configuration and coordination
    ├── identity-web.json  # Web agent identity and role
    ├── identity-cli.json  # CLI agent identity and role
    ├── agent-registry.json # Multi-agent coordination registry (v2.0)
    ├── workspace-coordination.yml # Workspace boundaries and ownership
    ├── handoffs/          # Agent handoff markers
    └── mcp-config.json    # MCP server configuration
```

---

## 🤝 Multi-Agent Coordination (2025-11-13)

Project Perplex uses **three AI agents** with distinct roles collaborating on the same repository with enforced workspace boundaries.

### Active Agents

**CDIR (CLI-Director) - Primary Designer:**
- **Environment:** PowerShell Terminal Window 1, Local Windows
- **Agent ID:** cli-claude-director-001
- **Role:** Designer-researcher
- **Responsibilities:** Create specifications, ADRs, documentation, requirements
- **Branch Pattern:** `claude/design-*`
- **Workspace:** `decisions/`, `docs/`, `requirements/`, `ideas/`, `specs/*/spec.md`

**CEXE (CLI-Executor) - Primary Executor:**
- **Environment:** PowerShell Terminal Window 2, Local Windows
- **Agent ID:** cli-claude-executor-001
- **Role:** Executor-validator
- **Responsibilities:** Implement features, write tests, validate implementations
- **Branch Pattern:** `claude/impl-*`
- **Workspace:** `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`

**Web (Standby) - Emergency Backup:**
- **Environment:** Browser-based, limited access
- **Agent ID:** web-claude-designer-001
- **Status:** Inactive (standby)
- **Activation:** Manual, only if CDIR unavailable >24 hours
- **Responsibilities:** Emergency backup designer, research support when requested

### Coordination System

**Four-layer enforcement architecture:**
1. **Local enforcement:** Pre-commit git hooks validate workspace boundaries
2. **Work tracking:** Agent registry tracks current work and handoffs
3. **Remote validation:** GitHub Actions validates PRs respect boundaries
4. **Handoff automation:** Scripts formalize transitions between agents

**Key tools:**
- `tools/agent-start-work.sh` - Initialize work with validation
- `tools/agent-handoff.sh` - Create formal handoff markers
- `tools/agent-check-registry.sh` - Check coordination state
- `tools/validate-workspace-boundaries.sh` - Validate file ownership

**Philosophy:** "Enforce, don't document" - automation prevents mistakes under cognitive load.

**See:** [Agent Workspace Coordination Guide](docs/AGENT_WORKSPACE_COORDINATION.md) and [ADR-011](decisions/2025-11-13-agent-workspace-coordination.md)

---

## 🚀 Quick Start

### For AI Agents (Claude Code Sessions)

**FIRST - Anchor Your Identity:**
```bash
# Web agent (if in browser environment)
cat .claude/identity-web.json

# CLI agent (if in local environment)
cat .claude/identity-cli.json

# Check coordination state
bash tools/agent-check-registry.sh
```

**Then - Start Session:**
```bash
./tools/session-start.sh
```

This will:
- Display current project status
- Show recent decisions
- List active TODOs
- Check for pending handoffs
- Provide context for continuing work

**Essential Reading (in order):**
1. Your identity file (`.claude/identity-{web|cli}.json`) - Know your role
2. [`FOUNDATION.md`](FOUNDATION.md) - Core principles
3. [`config/project.yml`](config/project.yml) - Project configuration
4. [`sessions/CURRENT_STATUS.md`](sessions/CURRENT_STATUS.md) - Current state
5. [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md) - What we're building
6. [`docs/AGENT_WORKSPACE_COORDINATION.md`](docs/AGENT_WORKSPACE_COORDINATION.md) - Your boundaries

**Ending a Session:**
```bash
./tools/session-end.sh
```

This will:
- Run validation checks
- Show session summary
- Prepare for commit

### For Humans

**Understanding the Project:**
1. Read [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md) - The "soul" of the project
2. Review [`FOUNDATION.md`](FOUNDATION.md) - Core principles
3. Check [`docs/MILESTONES.md`](docs/MILESTONES.md) - Progress tracking
4. Browse [`decisions/`](decisions/) - See why decisions were made

**Your Role:**
- Set strategic direction
- Validate alignment with vision
- Approve major architectural decisions
- Provide domain context AI cannot infer

---

## 🚀 Autonomous Workflow (Breakthrough Achievement)

**Fully autonomous AI-First development workflow achieved (2025-11-11):**

1. AI agent creates feature branch and pushes code
2. **Auto-Create PR workflow** creates pull request automatically (GitHub Actions + REST API)
3. **Tests workflow** validates changes (shellcheck, yamllint, bats)
4. **Auto-Merge workflow** merges to main after validation passes
5. Branch automatically deleted after merge

**No manual "Compare & pull request" clicks required!**

**Workflow Duplication Fix (2025-11-13):**

Critical issue discovered: workflows triggering duplicate runs (push + pull_request events).

**Root cause:** Static concurrency group names caused:
- Push event triggers workflows (auto-create-pr, tests, workspace-validation)
- PR created → pull_request event triggers SAME workflows again
- Result: Tests runs twice, duplicated effort

**Solution:** Ref-specific concurrency groups
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

**Impact:** Eliminates push+pull_request duplicates while maintaining concurrency control per-ref.

**Key Technologies:**
- GitHub Actions workflows for automation
- GitHub REST API for PR creation (gh CLI blocked in environment)
- `jq` for proper JSON construction
- Ref-specific concurrency groups for deduplication
- Idempotency checks throughout

**Result:** True AI-First autonomy - AI agents work without human intervention and without duplicate workflows.

See [`docs/BRANCH_MANAGEMENT.md`](docs/BRANCH_MANAGEMENT.md), [`checkpoints/GITHUB_AUTOMATION.md`](checkpoints/GITHUB_AUTOMATION.md), and [`docs/WORKFLOW_IDEMPOTENCY_IMPLEMENTATION.md`](docs/WORKFLOW_IDEMPOTENCY_IMPLEMENTATION.md) for complete details.

---

## 🔄 Development Methodology

**Two-layer complementary architecture:**

### Project Level: Discovery-Driven Development with Lean Principles
- Scope: Exploration, validation, strategic decisions
- Active throughout project lifecycle
- Small experiments focused on learning
- Fast feedback loops and decision logs
- Regular vision alignment checks

### Implementation Level: Spec-Driven Development with GitHub Spec Kit
- Scope: Formalized specifications, structured execution
- Active during implementation phases
- Living specifications as continuous reference
- Atomic tasks prevent scope creep
- Test-driven validation

**Integration:** Discovery produces what Spec-Driven consumes; learnings feed back to refinement.

**See:** [ADR-001 (Discovery-Driven)](decisions/2025-11-10-foundation-methodology.md) and [ADR-012 (Methodology Architecture)](decisions/2025-11-12-methodology-architecture.md)

---

## 📋 Current Milestones

### Phase 1: Foundation Complete! ✅ (2025-11-13)
**Infrastructure:**
- ✅ Core infrastructure established
- ✅ Documentation systems in place
- ✅ Automation tooling created
- ✅ Enforcement mechanisms (git hooks + workspace validation) implemented
- ✅ Requirements & traceability system
- ✅ Ideas logging system
- ✅ Branching strategy documented
- ✅ Continuity protocols established (checkpoints + memory graphs)
- ✅ Backlog tracking system (15 items: 6 complete, 5 backlog, 3 deferred, 1 discarded)

**Testing & Quality:**
- ✅ Testing infrastructure (shellcheck, bats-core, yamllint)
- ✅ GitHub Actions workflows (tests, foundation validation)
- ✅ Completeness review system with configuration
- ✅ Scheduled health checks (weekly monitoring)

**AI-First Workflow (Breakthrough):**
- ✅ Autonomous PR creation (GitHub Actions + REST API)
- ✅ Auto-merge with validation
- ✅ Checkpoint automation (session-end integration)
- ✅ No manual intervention required

**Multi-Agent Coordination (2025-11-13):**
- ✅ Agent identity management (Web vs CLI)
- ✅ Workspace coordination manifest (boundary definitions)
- ✅ Four-layer enforcement (local hooks, tracking, remote validation, handoff automation)
- ✅ Agent coordination scripts (start-work, handoff, check-registry)
- ✅ Pre-commit workspace boundary validation
- ✅ GitHub Actions workspace validation workflow
- ✅ Agent registry v2.0 with workspace tracking
- ✅ Handoff markers infrastructure
- ✅ Spec Kit integration (methodology architecture)

**Documentation:**
- ✅ 11 Architecture Decision Records
- ✅ GitHub templates (PR, issues)
- ✅ Contributing guidelines (410+ lines)
- ✅ CHANGELOG (Keep a Changelog format)
- ✅ Comprehensive session logs
- ✅ Agent workspace coordination guide

### Phase 2: Discovery & Research (Next)
- ⬜ Perplexity AI interface research
- ⬜ Integration feasibility evaluation
- ⬜ Technical constraints mapped

See [`docs/MILESTONES.md`](docs/MILESTONES.md) for complete roadmap.

---

## 🛠️ Available Tools

**Session Management:**
- `./tools/session-start.sh` - Begin new session with full context
- `./tools/session-end.sh` - Finalize session work

**Agent Coordination:**
- `./tools/agent-check-registry.sh` - Check agent coordination state
- `./tools/agent-start-work.sh` - Initialize work with validation
- `./tools/agent-handoff.sh` - Create formal handoff markers

**Validation & Status:**
- `./tools/validate-foundation.sh` - Check foundation alignment
- `./tools/validate-workspace-boundaries.sh` - Validate file ownership
- `./tools/generate-status.sh` - Update current status
- `./tools/generate-ideas-index.sh` - Update ideas index by status
- `./tools/review-completeness.sh` - Systematic gap detection

**Automated Enforcement:**
- `.githooks/pre-commit` - Foundation + workspace boundary validation (runs automatically)
- `.githooks/commit-msg` - Commit message validation (runs automatically)
- `.github/workflows/workspace-validation.yml` - Remote PR workspace validation

**Templates:**
- `decisions/TEMPLATE.md` - Create new Architecture Decision Record
- `ideas/TEMPLATE.md` - Capture new idea
- `requirements/TEMPLATE.md` - Document new requirement
- `sessions/SESSION_LOG_TEMPLATE.md` - Enhanced session logging

---

## 📝 Key Documents

### Essential Reading
| Document | Purpose | Audience |
|----------|---------|----------|
| [`FOUNDATION.md`](FOUNDATION.md) | Core principles and imperatives | AI & Human |
| [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md) | What we're building and why | AI & Human |
| [`sessions/CURRENT_STATUS.md`](sessions/CURRENT_STATUS.md) | Always-current snapshot | AI Primary |

### Configuration & Operations
| Document | Purpose | Audience |
|----------|---------|----------|
| [`config/project.yml`](config/project.yml) | Project configuration | AI Primary |
| [`config/ai-agent.yml`](config/ai-agent.yml) | AI operational parameters | AI Primary |
| [`.claude/identity-{web\|cli}.json`](.claude/) | Agent identity and role | AI Primary |
| [`.claude/workspace-coordination.yml`](.claude/workspace-coordination.yml) | Workspace boundaries | AI Primary |
| [`docs/AGENT_WORKSPACE_COORDINATION.md`](docs/AGENT_WORKSPACE_COORDINATION.md) | Multi-agent coordination guide | AI & Human |
| [`docs/BRANCHING_STRATEGY.md`](docs/BRANCHING_STRATEGY.md) | Git workflow and PR standards | AI & Human |
| [`docs/CONTINUITY_AND_RECOVERY.md`](docs/CONTINUITY_AND_RECOVERY.md) | Context preservation strategies | AI & Human |

### Quality & Tracking
| Document | Purpose | Audience |
|----------|---------|----------|
| [`docs/MILESTONES.md`](docs/MILESTONES.md) | Progress tracking | AI & Human |
| [`docs/VALIDATION_CHECKLIST.md`](docs/VALIDATION_CHECKLIST.md) | Alignment validation | AI Primary |
| [`requirements/TRACEABILITY.md`](requirements/TRACEABILITY.md) | Vision → Implementation links | AI & Human |
| [`ideas/INDEX.md`](ideas/INDEX.md) | Ideas by status | AI & Human |

---

## 🤝 Contributing

This project follows **AI-First Development**:

- Primary contributions come from AI agents (Claude, Gemini)
- Human partner provides strategic direction
- All significant decisions documented as ADRs
- Foundation imperatives are non-negotiable
- Session continuity is critical

**Before Contributing:**
1. Read [`FOUNDATION.md`](FOUNDATION.md)
2. Review [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md)
3. Check [`docs/VALIDATION_CHECKLIST.md`](docs/VALIDATION_CHECKLIST.md)
4. Create ADR for significant decisions

---

## 🎓 Philosophy

This project recognizes that:

1. Different AI systems have different strengths
2. Collaboration between them creates synergy
3. Humans should set strategy, not execute mechanics
4. Context management is a first-class problem
5. AI-first means infrastructure FOR AI agents
6. Project = Repository (everything lives in git)

**Non-Technical Friendly:**
This project is designed to work for users who don't write code. Configuration over implementation. AI agents handle technical execution.

---

## 📊 Progress Metrics

- **Decisions Logged:** 11 ADRs
- **Foundation Completion:** 100% ✅
- **Multi-Agent Coordination:** Operational with enforcement ✅
- **Backlog Items:** 15 total (6 complete, 5 backlog, 3 deferred, 1 discarded)
- **Testing Infrastructure:** Complete (shellcheck, bats, yamllint)
- **Autonomous Workflow:** Achieved (PR automation + workspace enforcement) ✅
- **Session Logs:** 8+ comprehensive sessions documented
- **Spec Kit Integration:** Complete (methodology architecture) ✅
- **Experiments Conducted:** 0 (discovery phase not started)
- **Requirements Defined:** 0 (pre-implementation)

---

## 🔗 Links

- **Repository:** https://github.com/jcmrs/perplex
- **Active Branches:**
  - Web: `claude/*` pattern
  - CLI: `claude/cli-*` pattern
  - Main: `main` (stable)
- **Issues:** Use GitHub issues for bug reports and feature requests

---

## ✅ Current Phase: Foundation Complete → Discovery Ready

Foundation infrastructure complete with autonomous AI-First workflow achieved (2025-11-11) and multi-agent workspace coordination operational (2025-11-13). All enforcement mechanisms validated and ready.

**What's Complete:**
1. ✅ Foundation validation complete with workspace enforcement
2. ✅ Session continuity tested (checkpoint + memory graph system)
3. ✅ Multi-agent coordination operational (Web + CLI collaboration)
4. ✅ Spec Kit integration ready (methodology architecture)

**What's Next:**
1. ⏭️ CLI begins perplex-transformer specification work
2. ⏭️ Begin discovery research on Perplexity AI integration
3. ⏭️ Document technical feasibility findings
4. ⏭️ Explore browser automation approaches
5. ⏭️ Answer discovery questions from PRODUCT_VISION.md

---

## 📞 Support

For questions or feedback:
- Review existing [decisions](decisions/) and [documentation](docs/)
- Check [session logs](sessions/) for context
- Raise issues on GitHub
- Ensure alignment with [foundation imperatives](FOUNDATION.md)

---

## 📄 License

*To be determined*

---

**Last Updated:** 2025-11-13 14:20 UTC
**Project Phase:** Foundation Complete
**Status:** Discovery Phase Ready
**Major Achievements:**
- Autonomous AI-First workflow (PR automation breakthrough, 2025-11-11)
- Multi-agent workspace coordination with enforcement (2025-11-13 AM)
- Workflow duplication fix deployed (ref-specific concurrency, 2025-11-13 PM)

---

*Built with AI-First principles. Maintained by autonomous multi-agent collaboration. Guided by strategic human partnership.*

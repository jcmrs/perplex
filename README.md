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

**Phase:** Foundation Building
**Status:** Infrastructure complete, ready for discovery phase

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
│   └── generate-status.sh # Update CURRENT_STATUS.md
│
├── examples/              # Reference implementations
│   ├── conversations/     # Conversation templates
│   ├── workflows/         # Example workflows
│   └── integrations/      # Integration patterns
│
└── .claude/               # Claude Code configuration
```

---

## 🚀 Quick Start

### For AI Agents (Claude Code Sessions)

**Starting a Session:**
```bash
./tools/session-start.sh
```

This will:
- Display current project status
- Show recent decisions
- List active TODOs
- Provide context for continuing work

**Essential Reading:**
1. [`FOUNDATION.md`](FOUNDATION.md) - Core principles
2. [`config/project.yml`](config/project.yml) - Project configuration
3. [`sessions/CURRENT_STATUS.md`](sessions/CURRENT_STATUS.md) - Current state
4. [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md) - What we're building

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

## 🔄 Development Methodology

**Discovery-Driven Development with Lean Principles**

- Small experiments focused on learning
- Fast feedback loops
- Decision logs as first-class artifacts
- Autonomous work within clear boundaries
- Regular vision alignment checks

See [ADR 001](decisions/2025-11-10-foundation-methodology.md) for full rationale.

---

## 📋 Current Milestones

### Phase 1: Foundation & GitHub Integration (Complete! ✅)
- ✅ Core infrastructure established
- ✅ Documentation systems in place
- ✅ Automation tooling created
- ✅ Enforcement mechanisms (git hooks) implemented
- ✅ Requirements & traceability system added
- ✅ Ideas logging system created
- ✅ Branching strategy documented
- ✅ Continuity protocols established
- ✅ Backlog tracking system
- ✅ GitHub Actions for PR validation
- ✅ GitHub templates (PR, issues)
- ✅ Local setup automation
- ✅ Experiment tracking template
- ✅ MIT License
- ✅ Contributing guidelines
- ✅ CODEOWNERS and CHANGELOG

### Phase 2: Discovery & Research (Not Started)
- ⬜ Perplexity AI interface research
- ⬜ Integration feasibility evaluation
- ⬜ Technical constraints mapped

See [`docs/MILESTONES.md`](docs/MILESTONES.md) for complete roadmap.

---

## 🛠️ Available Tools

**Session Management:**
- `./tools/session-start.sh` - Begin new session with full context
- `./tools/session-end.sh` - Finalize session work

**Validation & Status:**
- `./tools/validate-foundation.sh` - Check foundation alignment
- `./tools/generate-status.sh` - Update current status
- `./tools/generate-ideas-index.sh` - Update ideas index by status

**Automated Enforcement:**
- `.githooks/pre-commit` - Foundation validation (runs automatically)
- `.githooks/commit-msg` - Commit message validation (runs automatically)

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

- **Decisions Logged:** 2 ADRs
- **Foundation Completion:** 100% ✅
- **Experiments Conducted:** 0 (research phase not started)
- **Validated Learnings:** 0
- **Ideas Captured:** 0
- **Requirements Defined:** 0 (pre-implementation)

---

## 🔗 Links

- **Repository:** https://github.com/jcmrs/perplex
- **Current Branch:** `claude/perplex-initial-setup-011CUzxDPZiWB31A6DM5T2Mc`
- **Issues:** Use GitHub issues for bug reports and feature requests

---

## ⚠️ Current Phase: Foundation

We are currently establishing the infrastructure and systems that enable AI-first development. Research and implementation of Perplexity integration will begin once foundation is validated.

**What's Next:**
1. Complete foundation validation
2. Test session continuity with fresh session
3. Begin discovery research on Perplexity AI integration
4. Document technical feasibility findings

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

**Last Updated:** 2025-11-10
**Project Phase:** Foundation
**Status:** Ready for Discovery

---

*Built with AI-First principles. Maintained by autonomous AI agents. Guided by strategic human partnership.*

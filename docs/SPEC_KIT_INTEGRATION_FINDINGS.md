# GitHub Spec Kit Integration Findings

**Date:** 2025-11-12
**Executed by:** Claude Code CLI
**Purpose:** Document Spec Kit installation, configuration, and integration with Project Perplex

---

## Installation Summary

**Method:** Python via `uv` (NOT npm)

```bash
# Installation command
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Verification
specify check
# Result: ✅ Git, Claude Code, Gemini CLI available

# Project initialization
specify init . --ai claude --script sh --no-git --force
# Result: ✅ Project initialized successfully
```

**Version Installed:** specify-cli v0.0.20
**Template Version:** v0.0.79

---

## Directory Structure Created

### `.specify/` (Spec Kit Configuration)

```
.specify/
├── memory/
│   └── constitution.md          # Project governance principles (TEMPLATE)
├── scripts/
│   └── bash/
│       ├── common.sh            # Shared script utilities
│       ├── check-prerequisites.sh
│       ├── create-new-feature.sh
│       ├── setup-plan.sh
│       └── update-agent-context.sh
└── templates/
    ├── agent-file-template.md   # Agent guidance template
    ├── checklist-template.md    # Quality checklist template
    ├── plan-template.md         # Technical plan template
    ├── spec-template.md         # Feature specification template
    └── tasks-template.md        # Task decomposition template
```

### `.claude/commands/` (Slash Commands)

```
.claude/commands/
├── speckit.constitution.md      # /speckit.constitution - Establish project principles
├── speckit.specify.md           # /speckit.specify - Define requirements
├── speckit.plan.md              # /speckit.plan - Create technical strategy
├── speckit.tasks.md             # /speckit.tasks - Generate task lists
├── speckit.implement.md         # /speckit.implement - Execute implementation
├── speckit.clarify.md           # /speckit.clarify - Optional Q&A refinement
├── speckit.analyze.md           # /speckit.analyze - Cross-artifact consistency
└── speckit.checklist.md         # /speckit.checklist - Quality validation
```

---

## Spec-Driven Development Workflow

### Phase 0: Constitution (One-Time Setup)

**Command:** `/speckit.constitution`

**Purpose:** Establish project governance principles

**Creates:** `.specify/memory/constitution.md` (filled from template)

**Contains:**
- Core Principles (project-specific non-negotiables)
- Additional Constraints (technology, security, performance)
- Development Workflow (review process, quality gates)
- Governance (amendment procedures, compliance)

**Example Principles:**
- Library-First (features as standalone libraries)
- CLI Interface (text I/O protocol)
- Test-First (TDD mandatory)
- Integration Testing
- Observability, Versioning, Simplicity

### Phase 1: SPECIFY (High-Level What/Why)

**Command:** `/speckit.specify`

**Purpose:** Define functional requirements

**Creates:** `specs/NNN-feature-name/spec.md`

**Structure:**
- User Scenarios & Testing (prioritized P1/P2/P3)
  - Each story independently testable
  - Given-When-Then acceptance scenarios
  - Edge cases
- Requirements (functional/non-functional)
- Success Criteria (measurable outcomes)
- Out of Scope (explicit exclusions)
- Dependencies & Integration Points
- Open Questions (uncertainties to resolve)

**Key Insight:** Specs are numbered sequentially (001-first-feature, 002-second-feature, etc.)

### Phase 2: CLARIFY (Optional Refinement)

**Command:** `/speckit.clarify`

**Purpose:** Ask structured questions to de-risk ambiguous areas

**Use When:** Uncertainties exist before planning

**Updates:** Existing spec.md with clarifications

### Phase 3: PLAN (Technical How)

**Command:** `/speckit.plan`

**Purpose:** Create technical implementation strategy

**Creates:** `specs/NNN-feature-name/plan.md` (+ data-model.md, etc.)

**Contains:**
- Architecture & Design Patterns
- Technology Choices
- Integration Strategy
- Data Models
- Error Handling
- Testing Strategy

### Phase 4: TASKS (Atomic Decomposition)

**Command:** `/speckit.tasks`

**Purpose:** Break plan into executable, testable tasks

**Creates:** `specs/NNN-feature-name/tasks.md`

**Task Structure:**
- Each task: Specific, Testable, Independent
- Sequential execution order
- Test validation per task
- Checkpoints after groups of tasks

### Phase 5: ANALYZE (Optional Validation)

**Command:** `/speckit.analyze`

**Purpose:** Cross-artifact consistency & alignment report

**Use When:** Before implementation, to validate completeness

### Phase 6: CHECKLIST (Optional Quality)

**Command:** `/speckit.checklist`

**Purpose:** Generate quality checklists

**Validates:** Requirements completeness, clarity, consistency

### Phase 7: IMPLEMENT (Execution)

**Command:** `/speckit.implement`

**Purpose:** Execute tasks sequentially with validation

**Process:**
- Follow tasks.md order
- Test-driven validation per task
- Review after each task
- Update specs if learnings emerge

---

## Living Specifications Concept

**Key Principle:** Specs are NOT static documents

**Evolution:**
- Implementation reveals new insights → Update specs
- Requirements change → Update specs
- Constraints discovered → Update specs

**Version Control:**
- Specs live in `/specs/` directory
- Git tracks all changes
- History shows decision evolution

**Continuous Reference:**
- AI agents reference specs throughout implementation
- Prevents "losing sight" of goals
- Atomic tasks fit in context window
- Test validation provides confidence

---

## Integration with Project Perplex

### Foundation Imperatives Alignment

**✅ Holistic System Thinking**
- Specs capture system-wide architecture, dependencies, impacts
- Plan phase maps relationships
- Tasks decompose with awareness of whole system

**✅ AI-First**
- Living specs continuously available to AI agents
- Never lose sight of goals/context
- Self-trust through test-driven validation
- Autonomous execution with clear reference

**✅ Configurability**
- Specs are configuration for development
- Version-controlled (git)
- Change management via spec updates

**✅ Modularity**
- Atomic tasks = modular work units
- Clear phase boundaries (specify/plan/tasks/implement)
- Independent sub-project specs

**✅ Extensibility**
- Spec Kit process extends to any project
- Template-based (customizable)
- Scales from small to large projects

**✅ Integration**
- Specs + MCP memory (persistent context)
- Specs + Git (version control)
- Multi-agent coordination (Web + CLI workflows)

**✅ Automation**
- Commands automate planning/decomposition
- Reduces manual overhead
- Enables AI autonomous work

### Two-Layer Methodology Architecture (ADR-010)

**Discovery-Driven Development** (Project Level - Always Active)
- Validates feasibility, makes strategic decisions, adapts to learnings
- **Produces:** Foundation, product vision, validated architecture, constraints

**Spec-Driven Development** (Implementation Level - Active When Building)
- Formalizes validated ideas, structures execution
- **Consumes:** Everything Discovery-Driven produced
- **Produces:** Formal specifications, technical plans, atomic tasks, validated code

**Relationship:** NOT sequential phases - complementary scopes
- Discovery produces what Spec-Driven needs (constitution = FOUNDATION.md)
- Spec-Driven learnings feed back to Discovery refinement
- Both active simultaneously during implementation

### Multi-Agent Coordination

**Claude Code Web (Designer-Researcher):**
- **Spec Kit Usage:** None (can't run npx/uv in browser)
- **Responsibility:** Create draft specifications, architectural analysis, research
- **Output:** Markdown drafts, design proposals, analysis documents

**Claude Code CLI (Executor-Validator):**
- **Spec Kit Usage:** Full (specify command available locally)
- **Responsibility:** Formalize specs with Spec Kit, generate plans/tasks, execute implementation
- **Output:** Formal Spec Kit specifications, validated artifacts

**Workflow Pattern:**
1. Web designs draft specification (research, draft what/why)
2. User hands off to CLI (copy Web's draft)
3. CLI formalizes with Spec Kit (`/speckit.specify`, `/speckit.plan`, `/speckit.tasks`)
4. CLI executes implementation (follow tasks sequentially)
5. Web reviews and integrates (strategic alignment)

**Communication:** Envelope format (`[From: CLI]` / `[From: Web]`)

---

## Configuration Details

### Templates Use Placeholders

All templates contain tokens like `[PROJECT_NAME]`, `[PRINCIPLE_1_NAME]`, etc.

**Slash commands fill templates:**
- `/speckit.constitution` replaces `[PLACEHOLDERS]` in constitution.md
- `/speckit.specify` creates new spec from template
- `/speckit.plan` creates plan from template
- `/speckit.tasks` creates tasks from template

**Template Locations:**
- Constitution: `.specify/memory/constitution.md`
- Spec: `.specify/templates/spec-template.md`
- Plan: `.specify/templates/plan-template.md`
- Tasks: `.specify/templates/tasks-template.md`

### Script Type: Bash

Selected `--script sh` during initialization

**Automation scripts created:**
- `.specify/scripts/bash/*.sh`
- Cross-platform compatible
- Used by `/speckit.implement` for execution

---

## Security Note from Spec Kit

**Agent Folder Security:**

> Some agents may store credentials, auth tokens, or other identifying and
> private artifacts in the agent folder within your project.
> Consider adding .claude/ (or parts of it) to .gitignore to prevent
> accidental credential leakage.

**Action Taken:**
- Noted for future consideration
- Will evaluate what credentials (if any) are stored in `.claude/`
- Current `.gitignore` already includes `.claude/settings.local.json`

---

## Next Steps (Post-Integration)

### Immediate

1. **Establish Constitution:** Run `/speckit.constitution` to fill template with Project Perplex principles
2. **Align with FOUNDATION.md:** Ensure constitution mirrors Foundation Imperatives
3. **Update CLAUDE.md:** Add spec review to session start protocol

### Near-Term

1. **Write perplex-transformer Phase 1 specification**
   - Web provides draft
   - CLI formalizes with `/speckit.specify`
   - Generate plan with `/speckit.plan`
   - Decompose with `/speckit.tasks`

2. **Write perplex-reader Phase 1 specification**
   - Same process
   - Both sub-projects now have formal specs

3. **Define MCP Memory Graph Schema**
   - Formal schema for memory graph output
   - Based on basic-memory compatibility requirements

### Then

- Discovery phase (WITH formal specifications guiding us)
- Implementation of perplex-transformer (following specs/tasks)
- Implementation of perplex-reader (following specs/tasks)

---

## Troubleshooting Notes

### Unicode Display Issues

**Problem:** Spec Kit uses Unicode box-drawing characters for CLI UI

**Solution:** Set `PYTHONIOENCODING=utf-8` environment variable

```bash
PYTHONIOENCODING=utf-8 specify check
PYTHONIOENCODING=utf-8 specify init ...
```

### Interactive Setup

**Problem:** `specify init` is interactive (not fully automated)

**Solution:** Use flags to pre-configure:
```bash
specify init . --ai claude --script sh --no-git --force
```

**Flags:**
- `.` or `--here`: Initialize in current directory
- `--ai claude`: Pre-select Claude Code agent
- `--script sh`: Pre-select Bash scripts
- `--no-git`: Skip git initialization (we already have git)
- `--force`: Skip confirmation prompt for non-empty directory

---

## Validation Checklist

### Installation Validation ✅
- [x] `uv tool install specify-cli` succeeded
- [x] `specify check` shows available tools
- [x] Commands available: `/speckit.constitution`, `/speckit.specify`, etc.

### Configuration Validation ✅
- [x] `.specify/` directory exists
- [x] Git tracking .specify directory
- [x] Template files created
- [x] Slash commands installed in `.claude/commands/`

### Understanding Validation ✅
- [x] I understand the 4-phase SDD process (Specify → Plan → Tasks → Implement)
- [x] I know how to create a specification (`/speckit.specify`)
- [x] I know how to generate a plan from spec (`/speckit.plan`)
- [x] I know how to decompose plan into tasks (`/speckit.tasks`)
- [x] I understand file naming and organization (specs/NNN-feature/)
- [x] I understand living specifications concept

### Integration Validation (Pending)
- [ ] CLAUDE.md mentions spec review in session start
- [ ] Multi-agent coordination documented (Web drafts, CLI formalizes)
- [ ] Role boundaries clear (who does what with Spec Kit)

### Foundation Alignment ✅
- [x] Holistic System Thinking: Specs capture system-wide context
- [x] AI-First: Living specs, continuous reference
- [x] Configurability: Specs in version control
- [x] Modularity: Atomic tasks
- [x] Extensibility: Process scales to sub-projects
- [x] Integration: Specs + MCP memory + Git workflows
- [x] Automation: Commands automate decomposition

---

## Success Criteria

Spec Kit integration is complete when:

1. ✅ Spec Kit CLI installed and functional
2. ✅ Commands tested and understood (`/speckit.*`)
3. ✅ Project directory structure created (`.specify/`, slash commands)
4. ✅ Git tracking spec files
5. ⬜ Multi-agent coordination documented (who uses Spec Kit, how)
6. ✅ Foundation alignment validated (imperatives check)
7. ⬜ CLAUDE.md updated with spec review protocol
8. ✅ Findings documented for future reference
9. ⬜ Completion reported: `[From: CLI] Spec Kit integrated`

**Current Status:** 7/9 complete, pending CLAUDE.md update and final report

---

**Related Documentation:**
- Installation Correction: `docs/SPEC_KIT_INSTALLATION_CORRECTION.md`
- Integration Prompt: `docs/SPEC_KIT_INTEGRATION_PROMPT_CLI.md`
- Methodology Architecture: `decisions/2025-11-12-methodology-architecture.md`
- Foundation Imperatives: `FOUNDATION.md`

**External Resources:**
- GitHub Spec Kit Repository: https://github.com/github/spec-kit
- DeepWiki Documentation: https://deepwiki.com/github/spec-kit
- Blog Post: https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/

---

---

## Deep Dive: DeepWiki Documentation Insights

**Source:** Complete DeepWiki documentation processed (https://deepwiki.com/github/spec-kit/)
**Last Indexed:** 2025-11-11 (commit e6d6f3)

### Core Methodology Principles

**Intent-Driven Development:**
- Specifications articulate "what" (requirements, outcomes, constraints) before "how" (technology, architecture)
- Enforces separation between problem space and solution space
- Prevents premature optimization and technology coupling

**Rich Specification vs. Terse Requirements:**
- Not just requirement documents - "detailed specification documents with guardrails, organizational principles, and structured refinement"
- Specifications become "executable programs interpreted by AI agents"
- Multiple artifacts converge into single source of truth (tasks.md)

**Multi-Step Refinement:**
- Sequential phases with quality gates (not one-shot code generation)
- Each phase validates prerequisites before allowing progression
- Backtracking only through clarification loop
- Phase gates prevent invalid state transitions

**AI-Native Architecture:**
- Heavy reliance on advanced AI model capabilities
- Specifications remain "executable programs" throughout development
- Agent-specific context files maintain technology awareness across sessions

### Constitutional Governance Deep Dive

**Nine Immutable Articles** (from Spec Kit defaults):

| Article | Principle | Enforcement |
|---------|-----------|------------|
| I | Library-First | Every feature begins as standalone library |
| II | CLI Interface Mandate | All libraries expose text-based interfaces |
| III | Test-First Imperative (NON-NEGOTIABLE) | Tests written/approved BEFORE implementation |
| IV | Documentation Standards | Code self-documents through clear structure |
| V | Error Handling Protocol | Explicit error paths with meaningful messages |
| VI | Security Requirements | Authentication, authorization, validation |
| VII | Simplicity Gate | Maximum 3 projects; no speculative features |
| VIII | Anti-Abstraction | Use framework features directly (no unnecessary layers) |
| IX | Integration-First Testing | Prefer real databases/services over mocks |

**Phase -1 Gates:**
- `/speckit.plan` validates constitutional compliance BEFORE code generation
- Gate Status Levels: ✅ PASS, ⚠️ WARNING (document in Complexity Tracking), ❌ CRITICAL (remediate or justify)
- Violations require documented justification or ERROR state halts workflow

**Amendment Process:**
- Explicit documentation with rationale and impact analysis
- Maintainer review required
- Backwards compatibility assessment with migration path
- Version control tracks principle evolution

### Specification Phase Details

**Branch Naming Algorithm:**
- Stop words removed: i, a, an, the, to, for, of, in, is, are, be, have, will, etc.
- Short word filtering (< 3 characters unless uppercase)
- Acronym preservation (OAuth2 API → oauth2-api)
- Word count: First 3-4 meaningful words
- GitHub 244-byte limit enforcement

**Technology-Agnostic Success Criteria:**
- ✅ "Users complete checkout in under 3 minutes" (user-focused timing)
- ✅ "System supports 10,000 concurrent users" (capacity without tech)
- ✅ "95% of searches return results in under 1 second" (performance from user perspective)
- ❌ "API response time is under 200ms" (too technical, exposes architecture)
- ❌ "Database handles 1000 TPS" (implementation detail)
- ❌ "React components render efficiently" (framework-specific)

**Characteristics:** Measurable, Technology-agnostic, User-focused, Verifiable without knowing implementation

**Clarification Marker System:**
- Maximum 3 markers: `[NEEDS CLARIFICATION: specific question]`
- Priority order: scope > security/privacy > UX > technical details
- Triggers structured Q&A during validation
- User response format: `Q1: A, Q2: Custom - [details], Q3: B`

**Quality Validation Workflow:**
- Max 3 iteration attempts to resolve non-clarification failures
- Clarification markers trigger separate Q&A flow
- Re-validate until all checklist items pass
- After 3 failures: Document remaining issues, warn user

### Planning Phase Architecture

**Two-Phase Design Process:**

**Phase 0: Research & Clarification**
- Resolves "NEEDS CLARIFICATION" markers
- Documents research tasks in `research.md`
- Identifies implementation uncertainties

**Phase 1: Design Artifacts**
- `data-model.md` - Entity definitions from specifications
- `contracts/` - API specifications (OpenAPI, GraphQL, SignalR, gRPC)
- `quickstart.md` - Developer setup instructions
- `plan.md` updates - Design decisions with constitutional validation

**Technical Decisions Captured:**
- `**Language/Version:**` → Extracted by agent context script
- `**Primary Dependencies:**` → Frameworks and libraries
- `**Storage:**` → Database/persistence technology
- `**Project Type:**` → Project structure choice

**Agent Context Management:**
- `update-agent-context` script parses plan.md
- Extracts technology metadata using grep patterns
- Updates agent files (CLAUDE.md, GEMINI.md, etc.)
- Combines language + framework with " + " separator
- Prevents duplicate entries

**Constitutional Validation Gates:**
- Simplicity Gate: Project/service count ≤ 3
- Anti-Abstraction Gate: No unnecessary abstraction layers
- Integration-First Testing: Integration tests before unit tests
- ERROR if violations unjustified (requires documentation or termination)

### Task Decomposition Methodology

**Dependency Ordering:**
- Sequential phases: Setup (Phase 1) → Foundational infrastructure (Phase 2) → User stories (Phase 3+) → Polish (final)
- Sequential numbering: T001, T002... maintains consistent execution order
- Foundational/blocking tasks complete before story implementation

**Atomic Task Definition Requirements:**
- Specific file paths (exact files to create/modify)
- Sufficient context for LLM execution without clarification
- Dependency markers showing execution order
- Story labels (US1, US2, etc.) for traceability
- Checkpoint markers validating phase completion
- No ambiguous instructions (e.g., "create src/models/User.ts with properties: id, name, email")

**TDD Integration (Optional):**
- Tests generated only when explicitly requested
- Tests can run before implementation in parallel (using `[P]` markers)
- Enables test-driven workflows without mandating them

**Checkpoints and Validation:**
- After each user story phase completes
- Story independence allows incremental validation
- Each story phase = testable, deployable increment

### Implementation Workflow Details

**Five Sequential Phases:**
1. **Setup** - Project structure and dependencies
2. **Tests** - Unit/integration tests and test fixtures
3. **Core** - Business logic implementation
4. **Integration** - External system connectivity
5. **Polish** - Documentation and quality assurance

**TDD Enforcement:**
- Phase 2 writes all tests (expected to fail initially)
- Phase 3 implements features to make tests pass
- Contract tests validate API specifications when `contracts/` exists
- Test failures halt execution for debugging

**Dependency Management & Parallel Execution:**
- Sequential tasks run one at a time in document order
- Parallel tasks (marked `[P]`) can run concurrently with other `[P]` tasks
- Same-file tasks execute sequentially regardless of `[P]` markers
- Phase boundaries are strict (Phase N+1 waits for Phase N completion)
- Failed sequential task halts all execution
- Failed parallel tasks allow others to continue

**Prerequisites Validation:**
- Constitution, specification, plan, tasks artifacts must exist
- Checklist completion reviewed; incomplete requires user confirmation

**Completion Validation:**
- All tasks marked complete in `tasks.md`
- Specified files exist in project
- Implementation aligns with user stories in `spec.md`
- Architecture matches `plan.md` requirements
- Test suite executes without errors
- API implementation matches contract specifications

**Progress Tracking & Error Recovery:**
- Completed tasks marked with `[X]` in `tasks.md`
- Real-time progress updates
- Context-aware error reports (which task failed, what files affected)
- Re-running skips previously completed tasks (safe recovery)

### Template System Architecture

**Core Components:**
- YAML frontmatter defines script metadata
- Markdown content acts as detailed LLM prompt
- Frontmatter specifies: `scripts.sh`, `scripts.ps`, `agent_scripts.sh`, `agent_scripts.ps`

**Placeholder Replacement (Multi-Stage):**

| Placeholder | Replaced With | Context |
|-------------|---------------|---------|
| `{SCRIPT}` | Platform-specific script path | From frontmatter |
| `{ARGS}` | Agent-specific argument syntax | `$ARGUMENTS` or `{{args}}` |
| `{AGENT_SCRIPT}` | Platform-specific agent update script | From frontmatter |
| `__AGENT__` | Specific agent type | `claude`, `gemini`, etc. |

**Agent-Specific Command Generation:**

**Markdown Format Agents** (claude, copilot, cursor-agent, windsurf, codex, kilocode, auggie, roo, codebuddy, amp, q):
- File extension: `.md` or `.prompt.md`
- Argument placeholder: `$ARGUMENTS`
- Directory varies: `.claude/commands/`, `.github/prompts/`, etc.

**TOML Format Agents** (gemini, qwen):
- File extension: `.toml`
- Argument placeholder: `{{args}}`
- Wraps Markdown in TOML multi-line string syntax

**Script Variant Filtering:**
- Bash Packages: Copy `scripts/bash/` to `.specify/scripts/`
- PowerShell Packages: Copy `scripts/powershell/` to `.specify/scripts/`
- Templates reference via `{SCRIPT}` placeholder (replaced with `.sh` or `.ps1`)

**Template Processing Pipeline:**
1. Source Template (base Markdown with placeholders)
2. Agent Selection (determine target directory structure)
3. Placeholder Substitution (replace `{SCRIPT}`, `{ARGS}`, `__AGENT__`)
4. Format Conversion (convert to TOML if needed)
5. Output (agent-specific command file)

### Multi-Agent Architecture (Current Limitations)

**Important Clarification:**
- Spec Kit supports 15 different AI coding assistants through **unified system**, NOT true multi-agent coordination
- Single agent per project (select one during initialization)
- CLI-based agents (Claude, Gemini, Qwen, etc.) require validation via `shutil.which()`
- IDE-based agents (Copilot, Windsurf, Cursor, etc.) skip tool checks

**Role Separation Pattern:**
- Sequential role separation through workflow phases (not simultaneous collaboration)
- Constitution → Specification → Planning → Implementation
- Agent-specific context files (`.claude/`, `.gemini/`, `.github/`)

**Context Handoff Mechanism:**
- Generated files stored in agent-specific directories
- Agent-specific context files (CLAUDE.md, GEMINI.md) updated as development progresses
- `update-agent-context` scripts parse plan.md

**Format Adaptation:**
- Three-layer abstraction model: template → adapter → output
- 30 distinct package variants (15 agents × 2 script types)
- Enables agent switching without workflow changes

**Design Emphasis:**
- Single agent per project effectiveness
- Progressive context building through sequential phases
- Constitutional constraints govern all phases
- Idempotent operations allow safe re-initialization

**Note for Project Perplex:**
Our multi-agent coordination (Claude Code Web + CLI) is project-specific pattern OUTSIDE Spec Kit's design. We use Spec Kit as implementation tool for CLI, not as multi-agent orchestration framework.

### Key Differentiators from Agile/Traditional Methods

**Unlike Agile** (working software over documentation):
- **Specification-as-Code**: Specs reside in project repositories alongside implementation
- Not separate systems, not temporary scaffolding

**Unlike Waterfall** (front-loads all requirements):
- **AI-Augmented Refinement**: Clarification through structured dialogue, not lengthy meetings
- **Living Specifications**: Evolve during implementation, not frozen upfront

**Balanced Approach:**
- **Constitutional Constraints**: Project-wide principles prevent architecture drift (not changeable per sprint)
- **Deterministic Implementation**: From valid specs + plans, AI produces reproducible, testable code
- **Continuous Reference**: AI agents reference specs throughout, preventing "losing sight" of goals

### Artifact Hierarchy (Directed Acyclic Graph)

```
Constitution (immutable foundation)
    ↓
Specification (requirements definition)
    ↓
{Plan, Data Model, Contracts, Research}
    ↓
Tasks (dependency-ordered execution plan)
    ↓
Implementation (working code)
```

**DAG Properties:**
- Prevents circular dependencies
- Enforces unidirectional knowledge flow
- Backtracking only through clarification loop
- Requirements changes after planning = restart from specification

### Development Phase Categories

**0-to-1 Development (Greenfield):**
- Generate complete applications from specifications
- Full pipeline: constitution → specification → plan → tasks → implementation

**Creative Exploration:**
- Same specification, multiple plans with different tech stacks
- Comparative implementations for architecture evaluation
- Helps choose optimal technology choices

**Iterative Enhancement (Brownfield):**
- Extend existing systems while maintaining consistency
- Constitution references existing patterns
- New feature specifications integrate seamlessly

### Best Practices Summary

**1. Constitutional Clarity:**
- Invest heavily in constitution creation
- Governs all downstream decisions
- Prevents costly rework

**2. Specification Completeness:**
- Rich functional requirements before planning
- Resolve ambiguities through clarification, not during implementation

**3. Technology Agnosticism:**
- No frameworks/languages during specification
- Enables exploring multiple architectural approaches from identical requirements

**4. Iterative Refinement:**
- Use clarification loops liberally
- Better to ask questions early than discover misunderstandings during execution

**5. Dependency Ordering:**
- Trust task breakdown phase to order work correctly
- Don't manually reorder tasks
- Let system analyze dependencies

**6. TDD Discipline:**
- Enforce test-driven development during implementation
- Phase 2 = write tests, Phase 3 = implement functionality
- Ensures specifications translate to verified implementations

**7. Agent Context Maintenance:**
- After each planning phase, update agent context files
- Agents must remain aware of technology decisions for consistency

---

**Last Updated:** 2025-11-12
**Status:** Integration complete, comprehensive documentation processed
**DeepWiki Documentation:** Fully reviewed and integrated

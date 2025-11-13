# Contributing to Project Perplex

Thank you for your interest in contributing to Project Perplex! This guide will help you get started.

---

## Quick Start

### 1. Read the Foundation

**Essential reading before contributing:**
- [`FOUNDATION.md`](FOUNDATION.md) - Core principles (non-negotiable)
- [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md) - What we're building
- [`README.md`](README.md) - Project overview

### 2. Set Up Local Environment

```bash
# Clone repository
git clone https://github.com/jcmrs/perplex.git
cd perplex

# Run setup script
./tools/setup-local.sh

# Verify setup
./tools/validate-foundation.sh
```

See [`docs/LOCAL_SETUP.md`](docs/LOCAL_SETUP.md) for detailed instructions.

### 3. Understand the Workflow

Read [`docs/BRANCHING_STRATEGY.md`](docs/BRANCHING_STRATEGY.md) for complete git workflow.

**Quick version:**
- Work on feature branches
- Use descriptive branch names
- Commit frequently with clear messages
- Create PRs for all changes to main
- Git hooks validate automatically

---

## Project Principles

### AI-First Development

This project follows **AI-First** principles:
- AI agents (Claude, Gemini) are primary contributors
- Human partner provides strategic direction
- Automation over manual processes
- Documentation serves AI agents as primary users

### Foundation Imperatives

All contributions must align with:
1. **Holistic System Thinking** - Consider ripple effects
2. **AI-First** - Enable AI agent autonomy
3. **Configurability** - Behavior driven by config
4. **Modularity** - Independent components
5. **Extensibility** - Future additions considered
6. **Integration** - Standard interfaces
7. **Automation** - Repetitive tasks scripted

See [`FOUNDATION.md`](FOUNDATION.md) for detailed explanations.

### Multi-Agent Coordination (2025-11-13)

Project Perplex uses **multiple AI agents** with enforced workspace boundaries:

**Active Agents:**
- **Claude Code Web (Designer-Researcher):** Specifications, ADRs, documentation
- **Claude Code CLI (Executor-Validator):** Implementation, testing, technical planning

**Workspace Boundaries:**
- Web owns: `decisions/`, `docs/`, `specs/*/spec.md`
- CLI owns: `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`
- Shared: `sessions/`, `checkpoints/`, `.claude/agent-registry.json`

**Enforcement:**
- Pre-commit hooks validate workspace boundaries (BLOCKS violations)
- GitHub Actions validates PRs
- Agent coordination scripts formalize handoffs

**As a contributor:**
- Respect workspace boundaries when contributing
- Use `tools/validate-workspace-boundaries.sh --file <path>` to check ownership
- See [Agent Workspace Coordination Guide](docs/AGENT_WORKSPACE_COORDINATION.md)

---

## How to Contribute

### Reporting Bugs

1. Check if bug already reported in [Issues](https://github.com/jcmrs/perplex/issues)
2. Use bug report template
3. Include reproduction steps
4. Provide environment details

### Suggesting Features

1. Check [Product Vision](docs/PRODUCT_VISION.md) for alignment
2. Check [Ideas](ideas/INDEX.md) to see if already captured
3. Use feature request template
4. Explain vision alignment

### Asking Questions

1. Check documentation first
2. Search existing issues
3. Use question template
4. Provide context

### Submitting Code

#### Before You Start

- Discuss significant changes via issue or discussion
- Ensure alignment with product vision
- Check if work already in [backlog](backlog/BACKLOG.md)

#### Development Process

```bash
# Create feature branch
# For AI agents:
#   Web: claude/feature-description-SESSION_ID
#   CLI: claude/cli-feature-description-SESSION_ID
# For humans: your-name/feature-description
git checkout -b your-name/feature-description-SESSION_ID

# Make changes
# Commit frequently
git add .
git commit -m "Clear description of change"

# Git hooks run automatically (validation)

# Push when ready
git push -u origin your-name/feature-description-SESSION_ID

# Create PR
gh pr create --title "Feature title" \
  --body "See PR template for structure"
```

#### Commit Guidelines

**Format:**
```
Brief summary (imperative mood, max 72 chars)

Optional detailed explanation:
- What changed
- Why it changed
- Any relevant context

References: ADR-XXX, REQ-YYY, Issue #ZZZ
```

**Examples:**
```
✅ Add experiment tracking template for discovery phase
✅ Fix validation script to handle staged changes
✅ Update branching strategy with PR standards

❌ updates
❌ fixed stuff
❌ changes
```

#### Pull Request Guidelines

**Use PR template** (auto-populated when creating PR)

**Must include:**
- Summary of changes
- Links to ADRs for decisions made
- Traceability to requirements/vision
- Validation performed
- Foundation alignment check

**PR will be blocked if:**
- Foundation validation fails
- Commit messages are unclear
- Traceability missing
- No testing/validation documented

---

## Code Standards

### Documentation

- Update docs when changing behavior
- Explain "why" not just "what"
- Keep README current
- Create ADRs for significant decisions

### Decision Logging

For significant architectural decisions:
1. Create ADR using [`decisions/TEMPLATE.md`](decisions/TEMPLATE.md)
2. Document context, alternatives, rationale
3. Link to related requirements/ideas
4. Include in PR

### Requirements

When implementing features:
1. Create requirement using [`requirements/TEMPLATE.md`](requirements/TEMPLATE.md)
2. Link to product vision
3. Define acceptance criteria
4. Update traceability matrix

### Testing

**Test Infrastructure:** shellcheck, bats-core, yamllint

**Run tests:**
```bash
# All tests
./tests/run-tests.sh

# Specific test type
./tests/run-tests.sh --shellcheck
./tests/run-tests.sh --bats
./tests/run-tests.sh --yaml
```

**Add tests:**
- Create `.bats` files in `tests/tools/` for new scripts
- Use helpers from `tests/helpers/test-helpers.bash`
- See `tests/README.md` for comprehensive guide

**Testing Standards:**
- Add tests for new shell scripts (use bats)
- Run shellcheck before committing
- Update tests when fixing bugs
- Focus on high-value paths, not 100% coverage

**CI/CD:**
- Tests run automatically on PR
- Must pass before merge
- See `.github/workflows/tests.yml`

See [`tests/README.md`](tests/README.md) for complete testing guide.

---

## Review Process

### What Gets Reviewed

**Human reviews (non-technical focus):**
- Approach and strategy
- Architectural decisions
- Vision alignment
- Completeness

**Automated reviews (technical):**
- Foundation validation
- Commit message quality
- Tests passing (when we have tests)
- Build success (when applicable)

### Review Expectations

- Be constructive and respectful
- Focus on substance, not style
- Assume positive intent
- Explain reasoning

---

## Getting Help

### Documentation

- `/docs` - Project documentation
- `/decisions` - Decision history
- `/knowledge` - Research and learnings

### Questions

- Create issue with question template
- Start discussion on GitHub Discussions
- Check existing issues and docs first

### Stuck?

- Review recent session logs in `/sessions`
- Check backlog for related items
- Ask via issue or discussion

---

## For AI Agents

### Session Workflow

```bash
# Start session
./tools/session-start.sh

# Work on branch
# Commit frequently
# Update session log throughout

# End session
./tools/session-end.sh
```

### Key Responsibilities

- Maintain session logs diligently
- Create ADRs for significant decisions
- Update traceability when implementing
- Document mental models explicitly
- Write for future sessions

### Autonomy Guidelines

**Decide autonomously:**
- Tactical technical choices
- Implementation details
- Refactoring approaches

**Document decisions:**
- Architectural choices (ADRs)
- Approach selection rationale

**Consult on:**
- Strategic direction changes
- Product vision modifications
- Major architectural shifts

---

## For Humans

### Your Role

- Set strategic direction
- Validate vision alignment
- Approve major architectural decisions
- Provide domain context AI cannot infer

### Not Your Role

- Line-by-line code review
- Syntax checking (automated)
- Micromanaging implementation

### Review Focus

- Does approach make sense?
- Is solution aligned with vision?
- Are decisions well-reasoned?
- Is communication clear?

---

## Project Structure

See [`README.md`](README.md) for complete structure.

**Key directories:**
- `/config` - Configuration
- `/decisions` - ADRs
- `/docs` - Documentation
- `/ideas` - Idea capture
- `/requirements` - Specifications
- `/knowledge` - Research/learnings
- `/backlog` - Pending work
- `/sessions` - Session logs
- `/tools` - Automation scripts

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

See [`LICENSE`](LICENSE) file for details.

---

## Code of Conduct

### Be Respectful

- Respectful communication
- Constructive feedback
- Inclusive language
- Assume positive intent

### Be Honest

- Acknowledge mistakes
- Identify gaps openly
- Ask questions when unclear
- Document limitations

### Be Collaborative

- Share knowledge
- Help others learn
- Build on each other's work
- Credit contributions

---

## Recognition

Contributors are recognized through:
- Git commit history
- PR authorship
- Decision participation (ADRs)
- Documentation contributions

---

## Questions?

- Check documentation
- Search issues
- Ask via issue template
- Start discussion

**Welcome to Project Perplex! We're excited to have you contribute.**

---

**Last Updated:** 2025-11-13
**Status:** Active

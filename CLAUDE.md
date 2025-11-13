# Project Perplex - Claude Code Configuration

**Project:** Bridging local AI development tools with Perplexity AI
**Phase:** Foundation Complete
**AI-First Development:** This project is designed for AI agent autonomy

---

## 🚀 CRITICAL: Session Start Protocol

**YOU MUST DO THIS FIRST - Before anything else:**

0. **Anchor your identity:**
   ```bash
   cat .claude/identity-web.json     # If you're Claude Code Web
   cat .claude/identity-cli.json     # If you're Claude Code CLI
   cat .claude/agent-registry.json   # Check active agents
   ```

   **Why this matters:** Know WHO you are before loading WHAT you're working on. Your identity file defines your role (designer vs executor), capabilities, autonomy level, and coordination protocols. Without identity anchoring, you risk confusing your actions with other agents or losing strategic awareness.

   **Quick self-check:**
   - What's your agent_id and display_name?
   - What's your role and primary function?
   - What's your communication prefix? (e.g., `[From: Web]`)
   - Who else is active? (check agent registry)

1. **Load the latest checkpoint:**
   ```bash
   ./tools/resume-from-checkpoint.sh
   ```

2. **Read the checkpoint file** it displays (usually `checkpoints/LATEST.md`)

3. **Consult the memory graph** (`checkpoints/LATEST-graph.json`) for relationships

4. **Follow the checkpoint's reading list** - It tells you what's critical vs optional

5. **Check for active specifications (CLI agents only):**
   ```bash
   ls -la specs/*/spec.md 2>/dev/null || echo "No active specs"
   ls -la .specify/memory/constitution.md 2>/dev/null || echo "Constitution not yet established"
   ```

   **If specifications exist:**
   - Review constitution first (`.specify/memory/constitution.md`) to understand project principles
   - Check active specifications in `specs/NNN-feature-name/spec.md`
   - Review plans if planning started: `specs/NNN-feature-name/plan.md`
   - Check tasks if decomposition done: `specs/NNN-feature-name/tasks.md`

   **Why this matters:** Specifications are living documents that guide implementation. If they exist, they're THE authoritative reference for what you're building and why. Ignoring specs means losing strategic alignment.

**Why this matters:** Checkpoints provide just-in-time context loading. Reading them FIRST is orders of magnitude more token-efficient than exploring the codebase blindly. The memory graph maps relationships so you know what to read and what to skip.

**If no checkpoint exists:** This is unusual. Start with @FOUNDATION.md, then @docs/PRODUCT_VISION.md, then @sessions/CURRENT_STATUS.md, then check for specs.

---

## 🤝 Multi-Agent Coordination

**Project Perplex uses multiple AI agents collaborating on the same project.**

### Active Agents

Check `.claude/agent-registry.json` for current agents. As of 2025-11-12:

- **Claude Code Web (Web):** Designer-researcher role, web-based environment
- **Claude Code CLI (CLI):** Executor-validator role, local Windows environment

### Identity Configuration

**Each agent has an identity file:**
- `.claude/identity-web.json` - Claude Code Web
- `.claude/identity-cli.json` - Claude Code CLI

**What identity files contain:**
- agent_id and display_name (who you are)
- role and primary_function (what you do)
- capabilities and constraints (how you operate)
- coordination protocols (how you collaborate)

**At session start:** Read your identity file to anchor your persona and role.

### Communication Protocol

**Envelope Format:** All agent communications use prefix to prevent confusion.

**Usage:**
```
[From: Web] Designed identity management system. Implementation complete.
[From: CLI] Stage 1 setup complete. basic-memory operational.
```

**Why this matters:**
- User immediately knows which agent is speaking
- No confusion between Web's analysis and CLI's execution
- Clear handoff points in multi-agent workflows
- Maintains role clarity (designer vs executor)

**Your prefix:** Check your identity file's `coordination.message_prefix` field.

### Coordination Conventions

**Role Boundaries:**
- **Web (Designer-Researcher):** Architecture, research, specifications, detailed prompts
- **CLI (Executor-Validator):** Implementation, testing, validation, hands-on work

**Handoff Pattern:**
1. Web creates detailed guidance/prompts
2. User copies to CLI
3. CLI executes autonomously
4. CLI reports results (with `[From: CLI]` prefix)
5. Web reviews and integrates

**Autonomy:** Both agents operate with high autonomy. Make technical decisions independently, escalate only strategic questions.

**Git Coordination:**
- Web typically works on feature branches (`claude/*`)
- CLI can work on `main` or feature branches
- Coordinate merge strategy via agent registry notes

### Documentation

**Setup Guidance:**
- Web identity setup: Part of this repository
- CLI identity setup: @docs/IDENTITY_SETUP_PROMPT_CLI.md

**Coordination Analysis:**
- Three-environment architecture: @docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md
- Identity research: @docs/PERPLEXITY_PROMPT_MULTI_AGENT_IDENTITY.md

**Agent Registry:**
- Current agents: `.claude/agent-registry.json`
- Update your entry when significant changes occur

---

## 📋 Foundation Imperatives

**IMPORTANT:** All work must align with foundation imperatives. These are non-negotiable principles:

@FOUNDATION.md

**Summary:**
- **Holistic System Thinking** - Consider ripple effects across all systems
- **AI-First** - Design for AI agent autonomy, not human-in-loop
- **Five Cornerstones:** Configurability, Modularity, Extensibility, Integration, Automation

**When in doubt:** Check decisions against these imperatives. If a choice violates an imperative, find a different approach.

---

## 🎯 Product Vision & Context

@docs/PRODUCT_VISION.md

**Quick Context:** Perplex bridges Claude Code/Gemini CLI (local) with Perplexity AI (web) for seamless research collaboration. Problem: No API, no CLI, manual friction. Goal: Autonomous AI-to-AI collaboration.

---

## 📚 Documentation & Knowledge Base

**Checkpoint System** (Session Continuity):
- How it works: @checkpoints/README.md
- GitHub automation: @checkpoints/GITHUB_AUTOMATION.md
- Resume from checkpoint: `./tools/resume-from-checkpoint.sh`

**Completeness Review** (Gap Detection):
- Full guide: @docs/COMPLETENESS_REVIEW.md
- Run check: `./tools/review-completeness.sh`
- What "complete" means for different work types (bug fix, feature, refactor, etc.)

**Architecture Decisions:**
- All ADRs: @decisions/
- Latest: ADR-002 (Foundation Enhancements)
- Create new: `cp decisions/TEMPLATE.md decisions/YYYY-MM-DD-description.md`

**Session Protocols:**
- Current status: @sessions/CURRENT_STATUS.md (always check this!)
- Session logs: `sessions/session-*.md`
- Latest session: `sessions/session-20251111-foundation-completion.md`

**Configuration:**
- Project config: @config/project.yml
- AI agent config: @config/ai-agent.yml

---

## ⚡ Common Commands

**Foundation Validation:**
```bash
./tools/validate-foundation.sh
```
Checks: Core documents exist, directory structure correct, configuration valid, git clean.

**Completeness Review:**
```bash
./tools/review-completeness.sh              # Interactive mode
COMPLETENESS_NON_INTERACTIVE=true ./tools/review-completeness.sh  # CI mode
```
Checks: Git state, documentation current, artifacts logged, quality passing, todos complete.

**Status Update:**
```bash
./tools/generate-status.sh
```
Regenerates `sessions/CURRENT_STATUS.md` with latest commits, stats, branch info.

**Create Checkpoint:**
```bash
./tools/create-checkpoint.sh "Description"
```
Creates checkpoint + memory graph. Use at phase transitions or major milestones.

**Resume from Checkpoint:**
```bash
./tools/resume-from-checkpoint.sh          # Load latest
./tools/resume-from-checkpoint.sh --dry-run  # Preview without running
```

**Session End:**
```bash
./tools/session-end.sh
```
Runs validation, completeness review, shows summary. Use before ending session.

**Spec-Driven Development (CLI agents only):**
```bash
# Establish project principles (one-time)
/speckit.constitution

# Create feature specification
/speckit.specify "Feature description"

# Optional: Clarify ambiguities (max 3 questions)
/speckit.clarify

# Generate technical plan
/speckit.plan

# Break down into atomic tasks
/speckit.tasks

# Optional: Validate cross-artifact consistency
/speckit.analyze

# Execute implementation
/speckit.implement
```

**When to use Spec-Driven Development:**
- Phase 1 implementations (perplex-transformer, perplex-reader)
- New feature development requiring formal specifications
- Complex work needing structured decomposition
- When building something that Web has designed/specified

**When NOT to use Spec-Driven Development:**
- Discovery phase exploration (ADR-010: Discovery-Driven is project level)
- Bug fixes or minor changes
- Infrastructure setup
- Documentation work

---

## 🎨 Code Style & Conventions

**Language & Style:**
- Shell scripts: Bash with `set -e`, portable commands (avoid GNU-specific)
- YAML: GitHub Actions workflows, configuration files
- Markdown: Documentation, ADRs, session logs
- Comments: Explain WHY, not WHAT (code shows what)

**Naming:**
- Shell scripts: `kebab-case.sh`
- Directories: `lowercase-hyphenated/`
- Markdown files: `UPPERCASE.md` (root docs) or `kebab-case.md` (detailed docs)
- ADRs: `YYYY-MM-DD-description.md`
- Session logs: `session-YYYYMMDD-description.md`
- Checkpoints: `checkpoint-YYYYMMDD-HHMMSS-description.md`

**File Organization:**
- Root: Core documents only (FOUNDATION.md, README.md, LICENSE)
- `/config` - Configuration files (project.yml, ai-agent.yml)
- `/decisions` - Architecture Decision Records
- `/docs` - Documentation (product, processes, guides)
- `/tools` - Automation scripts
- `/sessions` - Session logs and status
- `/checkpoints` - Checkpoint + memory graph files

---

## 🔀 Git Workflow

**Branch Strategy:**
- Main branch: `main` (stable, always deployable)
- Feature branches: `claude/description-sessionid` (Claude Code web sessions)
- Commits: Descriptive, imperative mood, explain WHY

**Autonomous Workflow (Full Automation):**
1. Create feature branch: `git checkout -b claude/feature-sessionid`
2. Do work, commit with descriptive messages
3. Push to remote: `git push -u origin claude/feature-sessionid`
4. **Automation handles the rest:**
   - Auto-Create PR workflow creates PR (GitHub Actions + REST API)
   - Tests workflow validates changes (shellcheck, yamllint, bats)
   - Auto-Merge workflow merges to main after validation passes
   - Branch auto-deleted after merge
5. Pull merged changes: `git checkout main && git pull`

**No manual PR creation or merging required!** See `docs/BRANCH_MANAGEMENT.md` for details.

**Commit Messages:**
```
Brief summary (imperative mood, <72 chars)

Detailed explanation if needed. Explain WHY this change
was made, not WHAT changed (diff shows that).

Addresses: [What user request or gap this addresses]
Phase: [foundation/discovery/implementation]
```

**Git Hooks (Automatic):**
- Pre-commit: Runs `./tools/validate-foundation.sh`
- Commit-msg: Validates commit message quality
- Both block commits if validation fails (unless `--no-verify`)

**Never Use:**
- `--no-verify` (skips hooks) - Only if user explicitly requests
- `--force` push to main/master - Warn user if they request this
- `--amend` - Only if user explicitly requests OR adding pre-commit hook fixes

**Signing:**
Always use `--no-gpg-sign` for commits (environment doesn't support signing).

---

## 🔚 Session End Protocol

**Before ending ANY session, you MUST:**

1. **Run session-end script (MANDATORY):**
   ```bash
   ./tools/session-end.sh
   ```
   This automatically:
   - Validates foundation structure
   - **Runs completeness review (MANDATORY - cannot be skipped)**
   - Shows session summary
   - Prompts for final checks

2. **Address completeness issues:**
   - If completeness review finds issues, address them before continuing
   - Issues indicate missing documentation, uncommitted work, or forgotten artifacts
   - Script will prompt to fix or acknowledge issues

3. **Update documentation:**
   - Session log: `sessions/session-YYYYMMDD-description.md`
   - Current status: `./tools/generate-status.sh`

4. **Commit remaining changes:**
   - All work committed with descriptive messages
   - No uncommitted changes (check with `git status`)

5. **Push to remote:**
   ```bash
   git push -u origin $(git branch --show-current)
   ```
   **Note:** Pre-push hook will run completeness review again (non-blocking warning)

6. **Create checkpoint (if milestone):**
   ```bash
   ./tools/create-checkpoint.sh "Description of what was accomplished"
   ```
   Use for: Phase transitions, major features complete, significant milestones.

**Automated Checks:**
- **Pre-push hook:** Runs completeness review as warning before push (non-blocking)
- **GitHub Actions:** Runs completeness review on all PRs and posts results
- **Session-end script:** Runs completeness review mandatorily (blocking if issues found)

**What constitutes "complete":** See @docs/COMPLETENESS_REVIEW.md for work-type-specific definitions (bug fix, feature, refactor, docs, research, infrastructure).

---

## 📖 For Next Session

**What to expect when you resume:**

1. You'll load this CLAUDE.md automatically
2. You'll see the session start protocol (above) directing you to load checkpoint
3. The checkpoint will provide:
   - 30-second summary of project state
   - Prioritized reading list (critical/important/optional/skip)
   - Memory graph with relationships
   - Next actions clearly defined

**If you're a new Claude Code web instance:**
- Follow session start protocol religiously
- Checkpoints are your friend - they save 6,000-8,000 tokens
- When in doubt, run completeness review
- Foundation imperatives are non-negotiable
- Ask clarifying questions rather than assuming

**Current Phase:** Foundation Complete
**Next Phase:** Discovery (see PRODUCT_VISION.md for discovery questions)
**Backlog:** 10 items deferred to discovery/implementation phase

---

## 🆘 Quick Reference

**Something feels wrong?**
```bash
./tools/review-completeness.sh  # Find gaps systematically
```

**Need context fast?**
```bash
cat checkpoints/LATEST.md       # Quick summary
cat sessions/CURRENT_STATUS.md  # Current state
```

**Forgot a command?**
See "Common Commands" section above or run:
```bash
ls tools/*.sh                   # List all automation scripts
```

**Foundation validation failing?**
```bash
./tools/validate-foundation.sh  # Shows what's wrong
```

**Uncertain about a decision?**
Check: @decisions/ for precedent, @FOUNDATION.md for principles, or ask user for clarification.

---

**Remember:** This project values honest feedback over false confidence. "Never just readily agree with me" - if you spot gaps, missing elements, or potential issues, speak up. The completeness review system exists because we found gaps at every corner during foundation development. Use it.

**Token Efficiency:** "In context every token is sacred" - this is why checkpoints + memory graphs exist. Use them.

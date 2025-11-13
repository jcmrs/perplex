# Git Hooks

**Purpose:** Automated enforcement of foundation principles and quality standards.

## What Are Git Hooks?

Git hooks are scripts that run automatically at specific points in the git workflow. They enforce standards without requiring manual checks.

## Three-Agent Architecture

Project Perplex uses a three-agent architecture with distinct roles and workspace boundaries:

- **CDIR (CLI-Director)** - Designer-Researcher
  - Identity: `.claude/identity-cli-director.json`
  - Branches: `claude/design-*`
  - Owns: decisions/, requirements/, docs/, specs/*/spec.md

- **CEXE (CLI-Executor)** - Executor-Validator
  - Identity: `.claude/identity-cli-executor.json`
  - Branches: `claude/impl-*`
  - Owns: src/, tests/, specs/*/plan.md, specs/*/tasks.md

- **Web (Standby-Emergency)** - Emergency Support
  - Identity: `.claude/identity-web.json`
  - Branches: `claude/web-emergency-*`
  - Role: Standby, emergency activation only

Git hooks enforce these boundaries automatically.

## Installed Hooks

### pre-commit
**When:** Before a commit is created
**What:** Runs foundation validation + workspace boundary validation
**Enforces:**
- Foundation documents exist
- Directory structure intact
- Configuration files present
- Git repository clean
- **Workspace boundaries** (three-agent):
  - CDIR cannot modify: src/, tests/, specs/*/plan.md, specs/*/tasks.md
  - CEXE cannot modify: decisions/, requirements/, specs/*/spec.md, .specify/memory/constitution.md
  - Web requires: claude/web-emergency-* branch

**Agent Detection:**
```bash
# Hook detects agent from identity files:
if [ -f ".claude/identity-cli-director.json" ]; then
    AGENT_ID="cli-claude-director-001"
    AGENT_NAME="CDIR"
elif [ -f ".claude/identity-cli-executor.json" ]; then
    AGENT_ID="cli-claude-executor-001"
    AGENT_NAME="CEXE"
elif [ -f ".claude/identity-web.json" ]; then
    AGENT_ID="web-claude-designer-001"
    AGENT_NAME="Web"
fi
```

**Workspace Validation:**
- Loops through staged files
- Blocks commits that violate agent boundaries
- Shows clear error message with file and reason

**Can Skip:** `git commit --no-verify` (not recommended)

### commit-msg
**When:** After commit message is written
**What:** Validates commit message quality
**Enforces:**
- Message not empty
- Minimum 10 characters
- Warns if subject > 72 characters
- Tips for imperative mood

**Can Skip:** `git commit --no-verify` (not recommended)

### pre-push
**When:** Before git push executes
**What:** Two-part enforcement (branch convention + completeness review)

**Agent Detection:**
- Detects CDIR/CEXE/Web from identity files
- Announces: "Pre-push: Agent $AGENT_NAME ($AGENT_ID)"

**Part 1 (BLOCKING):**
- **BLOCKS** direct pushes to main/master
- Enforces claude/* branch convention for AI agents
- **Branch pattern validation** (three-agent):
  - CDIR: warns if not on `claude/design-*`
  - CEXE: warns if not on `claude/impl-*`
  - Web: warns if not on `claude/web-emergency-*`
  - Warnings are non-blocking (allows push)
- Prevents bypassing GitHub automation (PR creation, validation, auto-merge)

**Part 2 (NON-BLOCKING):**
- Runs completeness review (warnings only)
- Checks for missing documentation, uncommitted work, etc.
- Allows push even if issues found (advisory)

**Why:** CLI repeatedly tried to push to main (3 times) despite documentation. Enforcement prevents the mistake.

**Can Skip:** `git push --no-verify` (only for emergencies)

## Setup

Git hooks are stored in `.githooks/` directory (version controlled).

To activate them:
```bash
git config core.hooksPath .githooks
```

This tells git to use our custom hooks instead of `.git/hooks/`.

## Example Workflows (Three-Agent)

### CDIR (Designer-Researcher) Workflow

```bash
# 1. Start work on design branch
git checkout -b claude/design-user-auth-$(date +%s)

# 2. Create specification
echo "..." > specs/001-user-auth/spec.md
git add specs/001-user-auth/spec.md

# 3. Commit (pre-commit validates workspace boundaries)
git commit -m "Create user authentication specification"
# ✓ Pre-commit passes - CDIR owns specs/*/spec.md

# 4. Push (pre-push validates branch pattern)
git push -u origin claude/design-user-auth-12345
# ✓ Pre-push passes - correct claude/design-* pattern
```

### CEXE (Executor-Validator) Workflow

```bash
# 1. Start work on implementation branch
git checkout -b claude/impl-user-auth-$(date +%s)

# 2. Create implementation
echo "..." > src/auth/login.js
echo "..." > specs/001-user-auth/plan.md
git add src/auth/login.js specs/001-user-auth/plan.md

# 3. Commit (pre-commit validates workspace boundaries)
git commit -m "Implement user authentication system"
# ✓ Pre-commit passes - CEXE owns src/ and specs/*/plan.md

# 4. Push (pre-push validates branch pattern)
git push -u origin claude/impl-user-auth-12345
# ✓ Pre-push passes - correct claude/impl-* pattern
```

### Web (Standby-Emergency) Workflow

```bash
# 1. Emergency activation (ONLY when needed)
git checkout -b claude/web-emergency-urgent-fix-sessionid

# 2. Make emergency changes
echo "..." > docs/EMERGENCY_FIX.md
git add docs/EMERGENCY_FIX.md

# 3. Commit (pre-commit validates emergency branch)
git commit -m "[EMERGENCY] Fix critical issue"
# ✓ Pre-commit passes - Web on claude/web-emergency-* branch

# 4. Push (pre-push validates branch pattern)
git push -u origin claude/web-emergency-urgent-fix-sessionid
# ✓ Pre-push passes - correct claude/web-emergency-* pattern
```

### Violation Examples

**CDIR tries to modify implementation:**
```bash
# CDIR on claude/design-* branch
echo "..." > src/auth/login.js
git add src/auth/login.js
git commit -m "Add auth implementation"
# ❌ Pre-commit BLOCKS - CDIR cannot modify src/
```

**CEXE tries to modify specification:**
```bash
# CEXE on claude/impl-* branch
echo "..." > specs/001-feature/spec.md
git add specs/001-feature/spec.md
git commit -m "Update specification"
# ❌ Pre-commit BLOCKS - CEXE cannot modify specs/*/spec.md
```

**Agent tries to push to main:**
```bash
git checkout main
git push origin main
# ❌ Pre-push BLOCKS - Must use claude/* branch
```

## For AI Agents

**Normal workflow:**
- Hooks run automatically
- If validation fails, fix issues and retry commit
- Only use `--no-verify` if hooks are malfunctioning

**When hooks fail:**
1. Read the error message
2. Fix the underlying issue
3. Retry commit
4. Do NOT skip hooks just to "get past" validation

## For Humans

Hooks enforce quality without manual checking. They ensure:
- Foundation stays intact
- Commit messages are meaningful
- Standards are maintained automatically

If a hook blocks a commit, it's protecting project quality.

## Customization

Hooks can be updated as project evolves. Changes to hooks are version controlled, so all team members (human and AI) use same validation.

---

**Philosophy:** Automated enforcement prevents drift. Trust but verify - automatically.

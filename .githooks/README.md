# Git Hooks

**Purpose:** Automated enforcement of foundation principles and quality standards.

## What Are Git Hooks?

Git hooks are scripts that run automatically at specific points in the git workflow. They enforce standards without requiring manual checks.

## Installed Hooks

### pre-commit
**When:** Before a commit is created
**What:** Runs foundation validation checks
**Enforces:**
- Foundation documents exist
- Directory structure intact
- Configuration files present
- Git repository clean

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
**Part 1 (BLOCKING):**
- **BLOCKS** direct pushes to main/master
- Enforces claude/* branch convention for AI agents
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

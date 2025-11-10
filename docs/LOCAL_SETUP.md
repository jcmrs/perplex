# Local Development Setup

**Purpose:** Guide for setting up local development environment for Project Perplex

---

## Prerequisites

**Required:**
- Git installed
- Bash-compatible shell (Linux, macOS, WSL on Windows, Git Bash)
- Text editor or IDE

**Optional:**
- GitHub CLI (`gh`) for PR creation
- Your preferred development tools

---

## Quick Setup

### 1. Clone Repository

```bash
git clone https://github.com/jcmrs/perplex.git
cd perplex
```

### 2. Run Setup Script

```bash
./tools/setup-local.sh
```

This script:
- Configures git hooks for automated validation
- Makes all scripts executable
- Runs foundation validation
- Displays next steps

### 3. Verify Setup

```bash
./tools/validate-foundation.sh
```

Should output: `✅ Validation passed with no issues`

---

## Manual Setup (If Script Fails)

If the automated script doesn't work:

### Configure Git Hooks

```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

### Make Tools Executable

```bash
chmod +x tools/*.sh
```

### Test Validation

```bash
./tools/validate-foundation.sh
```

---

## What Gets Configured?

### Git Hooks

**Pre-commit hook:**
- Runs foundation validation before every commit
- Prevents commits that violate foundation principles
- Can be bypassed with `--no-verify` (not recommended)

**Commit-msg hook:**
- Validates commit message quality
- Ensures messages are meaningful and well-formatted

### Tool Scripts

**Session management:**
- `tools/session-start.sh` - Begin session with context
- `tools/session-end.sh` - Finalize session work

**Validation & maintenance:**
- `tools/validate-foundation.sh` - Check foundation alignment
- `tools/generate-status.sh` - Update project status
- `tools/generate-ideas-index.sh` - Update ideas index

---

## Essential Reading After Setup

**For Everyone:**
1. [`FOUNDATION.md`](/FOUNDATION.md) - Core principles (MUST READ)
2. [`README.md`](/README.md) - Project overview
3. [`docs/PRODUCT_VISION.md`](/docs/PRODUCT_VISION.md) - What we're building

**For AI Agents:**
4. [`config/ai-agent.yml`](/config/ai-agent.yml) - Operational parameters
5. [`sessions/CURRENT_STATUS.md`](/sessions/CURRENT_STATUS.md) - Current state
6. [`docs/BRANCHING_STRATEGY.md`](/docs/BRANCHING_STRATEGY.md) - Git workflow

**For Development:**
7. [`docs/CONTINUITY_AND_RECOVERY.md`](/docs/CONTINUITY_AND_RECOVERY.md) - Context preservation
8. [`docs/VALIDATION_CHECKLIST.md`](/docs/VALIDATION_CHECKLIST.md) - Pre-commit checks

---

## AI Agent Workflow

### Starting a Session

```bash
./tools/session-start.sh
```

This displays:
- Current project status
- Recent decisions
- Active todos
- Session checklist

### During Session

- Work on feature branch
- Commit frequently with clear messages
- Git hooks validate automatically
- Update session logs

### Ending Session

```bash
./tools/session-end.sh
```

This:
- Runs validation
- Shows session summary
- Reminds about push/PR

---

## Branching Workflow

See [`docs/BRANCHING_STRATEGY.md`](/docs/BRANCHING_STRATEGY.md) for complete details.

**Quick version:**

```bash
# Create feature branch
git checkout -b claude/feature-name-SESSION_ID

# Work and commit
git add .
git commit -m "Clear description"

# Push when ready
git push -u origin claude/feature-name-SESSION_ID

# Create PR
gh pr create --title "Feature title" --body "Description"
```

---

## Troubleshooting

### Git Hooks Not Running

**Symptom:** Commits go through without validation

**Fix:**
```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

**Verify:**
```bash
git config --get core.hooksPath
# Should output: .githooks
```

### Validation Script Fails

**Symptom:** `validate-foundation.sh` reports errors

**Fix:**
- Check that you're in project root
- Ensure all required directories exist
- Review error messages for specific issues

### Permission Denied on Scripts

**Symptom:** `Permission denied` when running scripts

**Fix:**
```bash
chmod +x tools/*.sh
chmod +x .githooks/*
```

### Hooks Configured But Not Running

**Symptom:** Hooks don't execute during git operations

**Possible causes:**
1. Hooks not executable: `chmod +x .githooks/*`
2. Wrong hooks path: `git config core.hooksPath .githooks`
3. Using git GUI that bypasses hooks: Use command line

---

## Different Environments

### Linux / macOS

Standard bash scripts work out of the box.

### Windows

**Option 1: WSL (Recommended)**
```bash
# Use Windows Subsystem for Linux
wsl
cd /mnt/c/Development/perplex
./tools/setup-local.sh
```

**Option 2: Git Bash**
```bash
# Use Git Bash (comes with Git for Windows)
cd /c/Development/perplex
./tools/setup-local.sh
```

**Note:** Native Windows PowerShell/CMD may not work with bash scripts.

### Claude Code Web

Already configured in backend environment. No local setup needed unless you want local clone.

---

## Updating Your Local Environment

When remote repository has updates:

```bash
# Fetch latest changes
git fetch origin

# If on feature branch, rebase onto latest main
git checkout main
git pull origin main
git checkout your-feature-branch
git rebase main

# Or merge if preferred
git merge main
```

---

## For First-Time Contributors

1. **Read foundation documents** (listed above)
2. **Run setup script**
3. **Verify hooks are working** (try making a commit)
4. **Explore existing code and documentation**
5. **Ask questions** via GitHub issues or discussions

---

## For Returning Contributors

After long absence:

1. **Pull latest changes:** `git pull origin main`
2. **Re-run setup if needed:** `./tools/setup-local.sh`
3. **Review recent sessions:** Check `sessions/` directory
4. **Check current status:** Read `sessions/CURRENT_STATUS.md`
5. **Review recent decisions:** Browse `decisions/` directory

---

## Environment-Specific Configuration

### AI Agent Settings

Edit `config/ai-agent.yml` to customize AI behavior (but commit changes so others benefit).

### Local-Only Settings

For personal preferences not to be committed:
- Create `.env` file (already in `.gitignore`)
- Add local configurations there

---

## Getting Help

**Documentation:**
- Check `/docs` directory
- Review ADRs in `/decisions`
- Search issues on GitHub

**Questions:**
- Create issue with question template
- Start discussion on GitHub Discussions

**Bugs:**
- Create issue with bug report template
- Include reproduction steps

---

**Last Updated:** 2025-11-10
**Status:** Complete
**Phase:** GitHub Integration

---

*Setup should take < 5 minutes. If it takes longer, please open an issue - we want this to be smooth.*

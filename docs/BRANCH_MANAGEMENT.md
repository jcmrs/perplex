# Branch Management Strategy

**Purpose:** Enable AI-First autonomous development while preventing destructive actions through automated guardrails.

**Status:** ✅ **AUTONOMOUS WORKFLOW ACHIEVED** (2025-11-11)

## Solution Overview

**Autonomous Workflow (Fully Implemented):**
1. ✅ AI pushes to `claude/*` feature branches
2. ✅ Auto-Create PR workflow creates PR automatically (GitHub Actions + REST API)
3. ✅ Auto-Merge workflow validates and merges PR (foundation, tests)
4. ✅ Branch auto-deleted after merge
5. ✅ **No human intervention required**

**Key Technologies:**
- GitHub Actions workflows for automation
- GitHub REST API for PR creation
- Git hooks for local validation
- `jq` for proper JSON construction

**Result:** Full AI autonomy while maintaining safety through automated validation.

---

## Fully Autonomous Workflow

### How It Works (AI Agent Perspective)

**Step 1: Create Feature Branch**
```bash
git checkout -b claude/feature-description-sessionid
```

**Step 2: Do Work, Commit**
```bash
git add .
git commit -m "Descriptive commit message

Detailed explanation of changes.
Why this change was made.
"
```

**Step 3: Push to Remote**
```bash
git push -u origin claude/feature-description-sessionid
```

**What Happens Automatically:**
1. ✅ **Auto-Create PR Workflow Triggers**
   - Detects push to `claude/*` branch
   - Extracts PR title from commit message first line
   - Extracts PR body from remaining commit message
   - Uses GitHub REST API to create PR
   - Idempotency check prevents duplicates

2. ✅ **Tests Workflow Runs**
   - Shellcheck validates shell scripts
   - Yamllint validates YAML files
   - Bats runs integration tests
   - Reports results on PR

3. ✅ **Auto-Merge Workflow Runs**
   - Waits for tests to pass
   - Runs foundation validation
   - Merges PR to main automatically
   - Deletes branch after merge

**Result:** AI pushes once, automation handles the rest. No manual "Compare & pull request" clicks!

### Workflow Files

| Workflow | File | Purpose |
|----------|------|---------|
| Auto-Create PR | `.github/workflows/auto-create-pr-claude-branches.yml` | Creates PR on push to claude/* |
| Auto-Merge | `.github/workflows/auto-merge-claude-branches.yml` | Validates and merges claude/* PRs |
| Tests | `.github/workflows/tests.yml` | Runs validation on all pushes |
| Foundation Validation | `.github/workflows/foundation-validation.yml` | Validates foundation structure |

**Documentation:** See `checkpoints/GITHUB_AUTOMATION.md` for detailed workflow documentation.

### Requirements

**One-Time Repository Setup:**
1. Go to **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, enable:
   - ✅ "Allow GitHub Actions to create and approve pull requests"

**Git Hooks (Local):**
- Pre-push: Validates before pushing
- Pre-commit: Foundation validation
- Commit-msg: Message quality check

**All automated!** No manual steps in execution loop.

---

## Branch Strategy

### Main Branch (`main`)
**Purpose:** Production-ready code, always stable

**Guardrails:**
1. **Pre-push validation** (git hook): Foundation validation + completeness review must pass
2. **Commit quality check** (git hook): Commit messages must be descriptive
3. **No force push** (git hook): Blocks `git push --force` to main
4. **No direct commits to main** (convention): Always work on feature branches, merge to main

### Feature Branches (`claude/description-sessionid`)
**Purpose:** Active development work

**Naming Convention:** `claude/[description]-[session-id]`
- Example: `claude/adr-006-checkpoint-automation-011CV2dMZNr7eHmriBCfPXFe`
- Session ID ensures uniqueness
- Description provides context

**Lifecycle:**
1. Create branch from main
2. Do work, commit frequently
3. When complete, merge to main
4. Delete feature branch after merge

### Automated Checkpoint Branches (`automated-checkpoint-*`)
**Purpose:** Created by checkpoint automation workflow (when re-enabled)

**Naming Convention:** `automated-checkpoint-[timestamp]`
- Auto-created by GitHub Actions
- Auto-deleted after merge (cleanup workflow)

---

## Guardrails (Automated Safety)

### 1. Pre-Push Hook
**Location:** `.git/hooks/pre-push`
**Purpose:** Prevent pushing bad code to main

```bash
#!/bin/bash
# Pre-push hook - validates before pushing to main

TARGET_BRANCH=$(git rev-parse --symbolic --abbrev-ref @{push} 2>/dev/null | cut -d'/' -f2)

if [ "$TARGET_BRANCH" = "main" ]; then
    echo "🔒 Pushing to main - running validation..."

    # 1. Foundation validation
    if ! ./tools/validate-foundation.sh; then
        echo "❌ Foundation validation failed. Push blocked."
        exit 1
    fi

    # 2. Completeness review (non-blocking warning)
    COMPLETENESS_NON_INTERACTIVE=true ./tools/review-completeness.sh
    if [ $? -ne 0 ]; then
        echo "⚠️  Completeness review found issues (non-blocking)"
    fi

    echo "✅ Validation passed. Pushing to main."
fi
```

### 2. Pre-Commit Hook
**Location:** `.git/hooks/pre-commit`
**Purpose:** Validate commit quality before committing

```bash
#!/bin/bash
# Pre-commit hook - validates before committing

# Run foundation validation
if ! ./tools/validate-foundation.sh; then
    echo "❌ Foundation validation failed. Commit blocked."
    exit 1
fi

echo "✅ Pre-commit validation passed."
```

### 3. Commit Message Hook
**Location:** `.git/hooks/commit-msg`
**Purpose:** Ensure commit messages are descriptive

```bash
#!/bin/bash
# Commit message validation

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Check minimum length
if [ ${#COMMIT_MSG} -lt 10 ]; then
    echo "❌ Commit message too short (minimum 10 characters)"
    exit 1
fi

# Check for common lazy messages
if echo "$COMMIT_MSG" | grep -qiE "^(wip|fix|update|change)$"; then
    echo "❌ Commit message too generic. Be descriptive."
    exit 1
fi

echo "✅ Commit message validated."
```

### 4. Force Push Protection
**Location:** `.git/hooks/pre-push`
**Purpose:** Block force pushes to main

```bash
#!/bin/bash
# Detect force push attempt

while read local_ref local_sha remote_ref remote_sha; do
    if [ "$remote_ref" = "refs/heads/main" ]; then
        # Check if this is a force push
        if [ "$remote_sha" != "0000000000000000000000000000000000000000" ]; then
            # Remote ref exists, check if we're force pushing
            if ! git merge-base --is-ancestor "$remote_sha" "$local_sha" 2>/dev/null; then
                echo "❌ Force push to main is blocked!"
                echo "This would rewrite history. Use a feature branch instead."
                exit 1
            fi
        fi
    fi
done
```

---

## Workflow Patterns

### Pattern 1: Autonomous Development (Current)
```bash
# 1. Start from clean main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b claude/new-feature-[session-id]

# 3. Do work, commit frequently with descriptive messages
git add .
git commit -m "Add new feature X

Detailed explanation of what changed and why.
Links to relevant decisions or issues.
"

# 4. Push feature branch
git push -u origin claude/new-feature-[session-id]

# 5. ✅ AUTOMATION TAKES OVER:
#    - Auto-Create PR workflow creates PR
#    - Tests workflow validates changes
#    - Auto-Merge workflow merges to main
#    - Branch auto-deleted after merge
# NO MANUAL STEPS REQUIRED!

# 6. Switch back to main and pull merged changes
git checkout main
git pull origin main
```

**Result:** AI pushes, automation handles PR creation, validation, merge, and cleanup!

### Pattern 2: Checkpoint Creation (After ADR-006 Implementation)
```bash
# Checkpoint creation via session-end or phase-change
./tools/create-checkpoint.sh "milestone-description"

# Checkpoint committed directly to main (discrete event, not PR)
git add checkpoints/
git commit -m "Add checkpoint: milestone-description"
git push origin main
```

### Pattern 3: Emergency Fix
```bash
# For critical fixes that can't wait for validation
git commit --no-verify -m "Emergency fix: description"
git push --no-verify origin main

# But document WHY you bypassed validation
```

---

## Safety Checks

### Before Every Push to Main
- ✅ Foundation validation passes
- ⚠️ Completeness review runs (warning only)
- ✅ Commit messages descriptive
- ✅ No force push

### Before Every Commit
- ✅ Foundation validation passes
- ✅ Commit message quality check

### Bypass (When Needed)
- Use `--no-verify` flag to bypass hooks
- Only for emergencies or when hooks are wrong
- Document why bypass was used

---

## Branch Cleanup

### Automated Cleanup (GitHub Actions)
- Checkpoint branches: Auto-deleted after merge (existing workflow)
- Stale feature branches: Manual cleanup (future enhancement)

### Manual Cleanup
```bash
# List local branches
git branch

# Delete local feature branch
git branch -d claude/old-feature-[session-id]

# Delete remote feature branch
git push origin --delete claude/old-feature-[session-id]

# Prune deleted remote branches from local
git fetch --prune
```

---

## Implementation Status

**Completed (2025-11-11):**
- ✅ Auto-Create PR workflow implemented (`.github/workflows/auto-create-pr-claude-branches.yml`)
- ✅ Auto-Merge workflow implemented (`.github/workflows/auto-merge-claude-branches.yml`)
- ✅ Tests workflow running on all pushes
- ✅ Git hooks installed (pre-push, pre-commit, commit-msg)
- ✅ Force-push protection in pre-push hook
- ✅ Repository setting enabled ("Allow GitHub Actions to create and approve pull requests")
- ✅ Full autonomous workflow tested and working
- ✅ Documentation updated (GITHUB_AUTOMATION.md, BRANCH_MANAGEMENT.md)

**Not Needed:**
- ❌ Remove GitHub branch protection - Using PR-based workflow instead
- ❌ Push directly to main - Using automated PR workflow (safer, audit trail)

**Future Enhancements:**
- [ ] Add hook installation to session-start script
- [ ] Update CONTRIBUTING.md with branch strategy
- [ ] Add branch age monitoring
- [ ] Automatic stale branch cleanup

---

## Guardrails vs Branch Protection

**What We're Replacing:**
- ❌ GitHub branch protection (UI-based, blocks AI)
- ❌ Manual PR review requirement

**What We're Adding:**
- ✅ Automated pre-push validation (git hooks)
- ✅ Automated commit quality checks (git hooks)
- ✅ Force push prevention (git hooks)
- ✅ Completeness review integration (git hooks)

**Key Difference:**
- Branch protection = external enforcement (GitHub blocks push)
- Git hooks = internal enforcement (local validation before push)
- Git hooks = AI-controllable (can bypass with `--no-verify` when justified)

---

## Testing Plan

### Test 1: Normal Push to Main
```bash
echo "test" >> README.md
git add README.md
git commit -m "Test commit for branch management validation"
git push origin main
# Expected: Pre-push hook runs, validation passes, push succeeds
```

### Test 2: Invalid Commit Message
```bash
git commit -m "fix"
# Expected: Commit-msg hook blocks, requires descriptive message
```

### Test 3: Force Push to Main
```bash
git push --force origin main
# Expected: Pre-push hook blocks, shows error message
```

### Test 4: Foundation Validation Failure
```bash
rm FOUNDATION.md
git add FOUNDATION.md
git commit -m "Remove foundation doc"
# Expected: Pre-commit hook blocks, validation fails
```

---

## Future Enhancements

1. **Branch age monitoring:** Warn about branches older than X days
2. **Automatic branch cleanup:** Delete merged feature branches after 7 days
3. **Protected files:** Block deletion of critical files (FOUNDATION.md, etc.)
4. **Commit signature verification:** Ensure commits are from authorized sources
5. **Branch naming validation:** Enforce naming conventions via hook

---

## For AI Agents

**What This Means:**
- You CAN push directly to main (autonomy restored)
- Guardrails will BLOCK bad pushes (safety maintained)
- Work on feature branches (organization)
- Merge to main when complete (simple workflow)

**When Hooks Block You:**
- Don't bypass unless you understand why
- Fix the validation issue first
- Use `--no-verify` only for legitimate reasons
- Document bypass in commit message

**Branch Lifecycle:**
1. Create feature branch from main
2. Work and commit on feature branch
3. Push feature branch to remote
4. Merge to main when complete
5. Delete feature branch

**For Checkpoints (Post-ADR-006):**
- Checkpoints commit directly to main (discrete events)
- No feature branch needed for checkpoints
- Idempotency check prevents duplicates

---

## For Human Partner

**What This Means:**
- AI can work autonomously (no more manual PR steps)
- Safety maintained through automated guardrails
- You can still review work (check git log, diffs)
- Hooks prevent accidents (force push, bad commits)

**If Something Goes Wrong:**
- Hooks can be bypassed (safety valve)
- Git history is preserved (can revert)
- AI documents all actions (commit messages)

**Trust but Verify:**
- Review git log periodically: `git log --oneline -20`
- Check branch list: `git branch -a`
- Inspect recent changes: `git diff HEAD~5..HEAD`

---

**This strategy enables AI-First autonomy while maintaining safety through automation, not external controls.**

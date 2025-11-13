# Local Automation Strategy - Spec Kit Integration

**Date:** 2025-11-13
**Purpose:** Ensure local CLI environment has enforcement mechanisms, not just documentation
**Context:** User strategic insight - "CLI can't be expected to constantly think of everything"

---

## Problem Statement

**GitHub Environment:** Automated workflows enforce practices (PR creation, validation, auto-merge, checkpoints)

**Local CLI Environment:** Relies on AI agent "remembering" to follow practices under cognitive load

**Gap:** Local environment needs **automation equivalents** of GitHub workflows

---

## Foundation Imperative: Automation

**From FOUNDATION.md:**
> **Automation:** Repetitive tasks are scripted; manual processes are temporary.
>
> **Enforcement:**
> - [ ] Common operations have scripts in `/tools`
> - [ ] Session start/end procedures automated
> - [ ] Validation and checks run automatically
> - [ ] Manual steps documented as automation candidates

**Current Status:**
- ✅ Session scripts exist
- ✅ Git hooks enforce foundation validation
- ⚠️ **Spec Kit integration:** Relies on manual invocation, no automation

---

## Existing Local Automation (Baseline)

### Git Hooks (Active)
- **pre-commit**: Foundation validation (blocks if failing)
- **commit-msg**: Message quality validation
- **pre-push**: Branch convention enforcement (blocks main pushes) + Completeness review (warning only)

### Session Management Scripts
- **tools/session-start.sh**: Automated startup protocol
- **tools/session-end.sh**: Automated cleanup and validation
- **tools/resume-from-checkpoint.sh**: Context restoration

### Validation & Quality
- **tools/validate-foundation.sh**: Structure and integrity checks
- **tools/review-completeness.sh**: Systematic gap detection

---

## CRITICAL: Git Workflow Enforcement

**Real-World Validation of User's Insight**

### The Problem (Proven Third Time)

**CLI repeatedly violated branch conventions:**
1. First attempt: Tried to push to main
2. Second attempt: Tried to push to main
3. Third attempt: Tried to push to main

**Despite:**
- Documentation exists (THREE_ENVIRONMENT_COORDINATION.md)
- Instructions provided (use claude/* branches)
- Previous corrections given

**User's Prediction Validated:** "CLI can't be expected to constantly think of everything under cognitive load"

**This is EXACTLY why we need enforcement, not documentation.**

---

### The Solution: ENFORCE, Don't Document

**Created Two Enforcement Mechanisms:**

#### 1. Pre-Push Git Hook (BLOCKS Invalid Pushes)

**File:** `.git/hooks/pre-push`

**What it does:**
- **BLOCKS** direct pushes to main/master branches
- Shows clear error with correct workflow instructions
- Explains GitHub automation (PR creation, validation, auto-merge)
- Validates claude/* branch naming for AI agents
- Provides specific examples for Web vs CLI agents

**Result:** Impossible to accidentally push to main - enforcement prevents the error.

#### 2. Branch Helper Script (MAKES Correct Workflow Easy)

**File:** `tools/ensure-claude-branch.sh`

**What it does:**
- Detects if AI is on main/master branch
- Identifies agent type (Web vs CLI) from identity files
- Suggests proper branch name format:
  - **Web:** `claude/description-sessionid`
  - **CLI:** `claude/cli-description-timestamp`
- Optionally creates branch automatically for CLI
- Provides clear instructions for pushing

**Usage:**
```bash
# CLI runs at session start or before committing work:
./tools/ensure-claude-branch.sh

# If on main, script offers to create proper branch
# If on claude/* branch, confirms and continues
```

**Result:** Making the right thing easy to do.

---

### Why This Matters (Foundation Imperatives)

**Automation Imperative Applied:**
- Don't rely on AI "remembering" under cognitive load
- Automate enforcement, not just documentation
- Make correct behavior the path of least resistance

**AI-First Principle:**
- AI agents have cognitive limitations (context window, memory)
- Design systems that work WITH those limitations
- Enforcement mechanisms support AI autonomy

**Holistic System Thinking:**
- GitHub has automation → Local needs automation
- Asymmetry creates failure points
- Consistent enforcement across environments

---

### Implementation Status

**✅ Implemented:**
- Pre-push hook created: `.git/hooks/pre-push`
- Pre-push hook made executable: `chmod +x`
- Branch helper created: `tools/ensure-claude-branch.sh`
- Helper made executable: `chmod +x`

**✅ Documented:**
- This section documents the enforcement
- Pre-push hook includes usage instructions
- Helper script provides interactive guidance

**✅ Tested:**
- Next attempt to push to main will be BLOCKED
- Clear error message guides to correct workflow

---

### Integration with Workflows

**Session Start (Future Enhancement):**
```bash
# tools/session-start.sh should call:
./tools/ensure-claude-branch.sh

# Ensures AI is on correct branch before starting work
```

**Before Committing Work:**
```bash
# CLI should run:
./tools/ensure-claude-branch.sh

# Confirms proper branch before making commits
```

**Pre-Push (Automatic):**
```bash
# Git automatically calls .git/hooks/pre-push
# BLOCKS if pushing to main
# Enforces claude/* convention
```

---

### Expected CLI Workflow (Corrected)

**1. Session Start:**
```bash
./tools/ensure-claude-branch.sh
# If on main, creates claude/cli-description-timestamp branch
```

**2. Do Work:**
```bash
# Spec Kit integration, code changes, etc.
```

**3. Commit Work:**
```bash
git add .
git commit -m "Descriptive message"
# Pre-commit hook validates
```

**4. Push to Remote:**
```bash
git push -u origin $(git branch --show-current)
# Pre-push hook enforces claude/* branch
# GitHub automation creates PR, validates, merges
```

**5. Result:**
- ✅ PR auto-created
- ✅ Validation runs
- ✅ Auto-merge if passing
- ✅ Branch deleted after merge
- ✅ No manual intervention needed

---

### Lessons Learned

**1. Documentation Alone is Insufficient**
- Documentation exists ≠ Behavior happens
- AI agents under cognitive load forget conventions
- Enforcement mechanisms prevent mistakes

**2. User's Non-Technical Insight Was Correct**
- "CLI can't be expected to constantly think of everything"
- Strategic observation from non-technical user identified critical gap
- Technical expertise without user perspective misses systemic issues

**3. GitHub Automation Model Should Apply Locally**
- What works on GitHub (automation) should work locally
- Asymmetry between environments creates failure points
- Consistent enforcement philosophy across all environments

**4. Make Correct Behavior Easy**
- Pre-push hook BLOCKS incorrect behavior
- Helper script MAKES correct behavior easy
- Path of least resistance = correct path

---

## Spec Kit Automation Requirements

### 1. Session Start Automation

**File:** `tools/session-start.sh`

**Add Spec Kit Checks:**
```bash
# Check Spec Kit status
echo "=== Spec Kit Status ==="

# Check if constitution formalized
if [ ! -f ".specify/memory/constitution.md" ] || grep -q "\[PLACEHOLDER\]" ".specify/memory/constitution.md"; then
    echo "⚠️  Constitution not formalized - consider /speckit.constitution"
fi

# List active specs
if [ -d "specs" ]; then
    ACTIVE_SPECS=$(find specs -name "spec.md" -type f | wc -l)
    echo "📋 Active specifications: $ACTIVE_SPECS"

    # Check for incomplete tasks
    if [ -f "specs/*/tasks.md" ]; then
        INCOMPLETE_TASKS=$(grep -r "- \[ \]" specs/*/tasks.md | wc -l)
        if [ "$INCOMPLETE_TASKS" -gt 0 ]; then
            echo "⚠️  Incomplete tasks: $INCOMPLETE_TASKS"
        fi
    fi
fi

# Show Spec Kit commands available
echo ""
echo "Spec Kit commands available:"
ls .claude/commands/speckit.*.md | sed 's/.*\/speckit\./  \/speckit./' | sed 's/\.md$//'
```

**Purpose:** AI agent sees Spec Kit status immediately on session start, not buried in files.

### 2. Session End Validation

**File:** `tools/session-end.sh`

**Add Spec Kit Completeness:**
```bash
# Check if code changed but specs didn't
GIT_DIFF_CODE=$(git diff --name-only HEAD | grep -E "^src/|^lib/" | wc -l)
GIT_DIFF_SPECS=$(git diff --name-only HEAD | grep -E "^specs/" | wc -l)

if [ "$GIT_DIFF_CODE" -gt 0 ] && [ "$GIT_DIFF_SPECS" -eq 0 ]; then
    echo "⚠️  Code changed but specs unchanged - consider updating specs"
fi

# Check for uncommitted spec files
UNCOMMITTED_SPECS=$(git status --porcelain | grep "^??" | grep "specs/" | wc -l)
if [ "$UNCOMMITTED_SPECS" -gt 0 ]; then
    echo "⚠️  Uncommitted spec files: $UNCOMMITTED_SPECS"
fi
```

**Purpose:** Prompt to update specs when code changes.

### 3. Git Hook: Pre-Commit Spec Validation

**File:** `.git/hooks/pre-commit` (extend existing)

**Add Spec Kit Validation:**
```bash
# Validate spec file format if specs changed
STAGED_SPECS=$(git diff --cached --name-only | grep "^specs/")

if [ -n "$STAGED_SPECS" ]; then
    echo "Validating Spec Kit files..."

    for spec_file in $STAGED_SPECS; do
        # Check for unfilled placeholders
        if grep -q "\[PLACEHOLDER\]" "$spec_file"; then
            echo "❌ Spec file has unfilled placeholders: $spec_file"
            echo "   Please fill all [PLACEHOLDER] sections before committing."
            exit 1
        fi

        # Check for required sections (if spec.md)
        if [[ "$spec_file" == */spec.md ]]; then
            if ! grep -q "## What" "$spec_file" || ! grep -q "## Why" "$spec_file"; then
                echo "❌ Spec missing required sections: $spec_file"
                exit 1
            fi
        fi
    done

    echo "✅ Spec Kit validation passed"
fi
```

**Purpose:** Prevent committing incomplete specs.

### 4. Completeness Review Extension

**File:** `tools/review-completeness.sh`

**Add Spec Kit Section:**
```bash
section "7. Spec Kit Completeness"

# Check constitution
if [ -f ".specify/memory/constitution.md" ]; then
    if grep -q "\[PLACEHOLDER\]" ".specify/memory/constitution.md"; then
        warning "Constitution has unfilled placeholders"
        info "Run: /speckit.constitution to formalize"
    else
        ok "Constitution formalized"
    fi
else
    warning "Constitution file not found"
fi

# Check active specs
if [ -d "specs" ]; then
    TOTAL_SPECS=$(find specs -name "spec.md" -type f | wc -l)

    if [ "$TOTAL_SPECS" -gt 0 ]; then
        info "Active specifications: $TOTAL_SPECS"

        # Check for incomplete specs
        INCOMPLETE_SPECS=$(find specs -name "spec.md" -type f -exec grep -l "\[PLACEHOLDER\]" {} \; | wc -l)
        if [ "$INCOMPLETE_SPECS" -gt 0 ]; then
            warning "$INCOMPLETE_SPECS specs have unfilled placeholders"
        fi

        # Check for specs without tasks
        SPECS_NO_TASKS=$(find specs -type d -mindepth 1 -maxdepth 1 ! -exec test -f {}/tasks.md \; -print | wc -l)
        if [ "$SPECS_NO_TASKS" -gt 0 ]; then
            warning "$SPECS_NO_TASKS specs without task decomposition"
            info "Run: /speckit.tasks for each spec"
        fi
    else
        info "No active specifications"
    fi
else
    info "No specs directory (use /speckit.specify to create first spec)"
fi

# Check spec-code alignment (heuristic)
if [ -d "specs" ] && [ -d "src" ]; then
    # Compare last modified times
    SPECS_LATEST=$(find specs -type f -name "*.md" -printf '%T@\n' | sort -n | tail -1)
    CODE_LATEST=$(find src -type f -printf '%T@\n' | sort -n | tail -1)

    if (( $(echo "$CODE_LATEST > $SPECS_LATEST + 86400" | bc -l) )); then
        warning "Code modified >24h after specs - consider updating specs"
    fi
fi
```

**Purpose:** Systematic check that Spec Kit artifacts are complete.

### 5. Quick Reference File

**File:** `.claude/SPEC_KIT_QUICK_REF.md`

**Content:**
```markdown
# Spec Kit Quick Reference

**Read this when under cognitive load or context window pressure!**

## Commands by Workflow Stage

### Starting New Feature
1. `/speckit.specify` - Define what/why, success criteria
2. `/speckit.clarify` - Resolve unclear requirements (optional)
3. `/speckit.plan` - Design architecture and approach
4. `/speckit.tasks` - Break into atomic work units
5. `/speckit.implement` - Execute implementation

### Quality & Validation
- `/speckit.analyze` - Check cross-artifact consistency
- `/speckit.checklist` - Validate requirements completeness

### Project Governance
- `/speckit.constitution` - Formalize governing principles (do once)

## File Locations

**Templates:** `.specify/templates/`
- spec-template.md
- plan-template.md
- tasks-template.md

**Constitution:** `.specify/memory/constitution.md`

**Active Specs:** `specs/NNN-feature-name/`
- spec.md (what/why)
- plan.md (how - architecture)
- tasks.md (atomic work units)
- data-model.md (if applicable)

## When to Update Specs

**Always update specs when:**
- Requirements change
- Architecture decisions made
- Implementation reveals new constraints
- User feedback changes direction

**Specs are LIVING documents** - they evolve with the project.

## Integration with Existing Workflows

**Session Start:**
- Check spec status (tools/session-start.sh shows this)
- Review incomplete tasks

**Session End:**
- Update specs if code changed
- Commit spec updates with code

**Checkpoints:**
- Include current spec status
- Note which specs are active

## Foundation Alignment

**Spec Kit implements:**
- **Holistic System Thinking:** Specs capture system-wide context
- **AI-First:** Living specs = continuous reference
- **Modularity:** Atomic tasks from /speckit.tasks
- **Automation:** Commands automate planning/decomposition

## Emergency: Context Window Almost Full

1. Read this file (quick orientation)
2. Check current spec: `cat specs/NNN-*/spec.md`
3. Check current tasks: `cat specs/NNN-*/tasks.md`
4. Continue work with spec as reference

## Troubleshooting

**Command not found?**
- Check: `ls .claude/commands/speckit.*.md`
- Reinstall: `specify init . --ai claude --force`

**Template has placeholders?**
- That's normal - templates SHOULD have [PLACEHOLDERS]
- Commands fill them with actual content

**Spec out of date?**
- Update spec file directly
- Or re-run /speckit.specify with updated requirements
```

**Purpose:** Discoverable reference when AI is under pressure.

### 6. Helper Scripts

**File:** `tools/spec-status.sh`

```bash
#!/bin/bash
# Quick spec status overview

echo "=== Spec Kit Status ==="
echo ""

# Constitution
if [ -f ".specify/memory/constitution.md" ]; then
    if grep -q "\[PLACEHOLDER\]" ".specify/memory/constitution.md"; then
        echo "Constitution: ⚠️  Not formalized"
    else
        echo "Constitution: ✅ Formalized"
    fi
else
    echo "Constitution: ❌ Not found"
fi

echo ""

# Active specs
if [ -d "specs" ]; then
    TOTAL=$(find specs -name "spec.md" -type f | wc -l)
    echo "Active Specifications: $TOTAL"
    echo ""

    if [ "$TOTAL" -gt 0 ]; then
        for spec_dir in specs/*/; do
            SPEC_NAME=$(basename "$spec_dir")
            echo "  📋 $SPEC_NAME"

            # Check files
            [ -f "$spec_dir/spec.md" ] && echo "     ✅ spec.md" || echo "     ❌ spec.md"
            [ -f "$spec_dir/plan.md" ] && echo "     ✅ plan.md" || echo "     ⚠️  plan.md (run /speckit.plan)"
            [ -f "$spec_dir/tasks.md" ] && echo "     ✅ tasks.md" || echo "     ⚠️  tasks.md (run /speckit.tasks)"

            # Check task completion
            if [ -f "$spec_dir/tasks.md" ]; then
                TOTAL_TASKS=$(grep -c "^- \[" "$spec_dir/tasks.md" || echo "0")
                DONE_TASKS=$(grep -c "^- \[x\]" "$spec_dir/tasks.md" || echo "0")
                echo "     Tasks: $DONE_TASKS/$TOTAL_TASKS completed"
            fi

            echo ""
        done
    fi
else
    echo "No specs directory"
fi

# Commands available
echo "Commands available:"
ls .claude/commands/speckit.*.md 2>/dev/null | sed 's/.*\/speckit\./  \/speckit./' | sed 's/\.md$//' || echo "  (none - run specify init)"
```

**Usage:** `./tools/spec-status.sh` for quick overview

**File:** `tools/validate-specs.sh`

```bash
#!/bin/bash
# Validate spec files for completeness

echo "=== Spec Kit Validation ==="
echo ""

ERRORS=0
WARNINGS=0

# Check each spec
for spec_file in specs/*/spec.md; do
    if [ -f "$spec_file" ]; then
        SPEC_DIR=$(dirname "$spec_file")
        SPEC_NAME=$(basename "$SPEC_DIR")

        echo "Validating: $SPEC_NAME"

        # Check for placeholders
        if grep -q "\[PLACEHOLDER\]" "$spec_file"; then
            echo "  ❌ Spec has unfilled placeholders"
            ERRORS=$((ERRORS + 1))
        fi

        # Check required sections
        if ! grep -q "## What" "$spec_file"; then
            echo "  ❌ Missing '## What' section"
            ERRORS=$((ERRORS + 1))
        fi

        if ! grep -q "## Why" "$spec_file"; then
            echo "  ❌ Missing '## Why' section"
            ERRORS=$((ERRORS + 1))
        fi

        # Check for plan
        if [ ! -f "$SPEC_DIR/plan.md" ]; then
            echo "  ⚠️  No plan.md (run /speckit.plan)"
            WARNINGS=$((WARNINGS + 1))
        fi

        # Check for tasks
        if [ ! -f "$SPEC_DIR/tasks.md" ]; then
            echo "  ⚠️  No tasks.md (run /speckit.tasks)"
            WARNINGS=$((WARNINGS + 1))
        fi

        echo ""
    fi
done

echo "Summary: $ERRORS errors, $WARNINGS warnings"

exit $ERRORS
```

**Usage:** `./tools/validate-specs.sh` before committing

---

## Implementation Plan

### Phase 1: Essential Automation (Immediate)
1. ✅ Create `.claude/SPEC_KIT_QUICK_REF.md` (reference under pressure)
2. ✅ Update `tools/session-start.sh` (Spec Kit status)
3. ✅ Update `tools/session-end.sh` (Spec update prompts)
4. ✅ Create `tools/spec-status.sh` (quick overview)

### Phase 2: Validation & Quality (Near-term)
1. ⏳ Extend `tools/review-completeness.sh` (Spec Kit section)
2. ⏳ Create `tools/validate-specs.sh` (spec validation)
3. ⏳ Update git pre-commit hook (spec validation)

### Phase 3: Advanced Automation (Future)
1. ⏳ Spec-code alignment checks
2. ⏳ Automatic spec staleness detection
3. ⏳ Integration with checkpoint system
4. ⏳ Spec Kit status in CURRENT_STATUS.md

---

## Success Criteria

**Local automation is sufficient when:**

1. ✅ CLI sees Spec Kit status on every session start
2. ✅ CLI is prompted to update specs when code changes
3. ✅ Incomplete specs cannot be committed (validation blocks)
4. ✅ Quick reference accessible when under cognitive load
5. ✅ Spec Kit status included in completeness review
6. ✅ Helper scripts provide quick status overview
7. ✅ No reliance on "AI remembering" under pressure

**Test:** Simulate high cognitive load scenario - can CLI find guidance quickly?

---

## Foundation Alignment

### Automation ✓
- Scripts in /tools for common operations
- Session start/end automated
- Validation runs automatically
- Manual Spec Kit invocation documented as automation candidate

### AI-First ✓
- Quick reference discoverable
- Status shown on session start
- Validation happens automatically
- Reduces cognitive load on AI agent

### Configurability ✓
- Scripts configurable via environment variables
- Thresholds adjustable (staleness, task counts)
- Validation rules extensible

---

## For Future AI Agents

**When working with Spec Kit under cognitive load:**
1. Read `.claude/SPEC_KIT_QUICK_REF.md` first
2. Run `./tools/spec-status.sh` for quick overview
3. Check current spec: `cat specs/NNN-*/spec.md`
4. Let automation handle validation - focus on implementation

**When extending automation:**
- Add checks to `tools/review-completeness.sh`
- Update session start/end scripts
- Document new automation in this file

---

**Status:** Strategy Defined
**Priority:** High - Implements Automation imperative for local environment
**Next:** Implement Phase 1 automation (essential mechanisms)

**Prepared by:** Claude Code Web (Web)
**Inspired by:** User's strategic insight about local environment needs
**Date:** 2025-11-13

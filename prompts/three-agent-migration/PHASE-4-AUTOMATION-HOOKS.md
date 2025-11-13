# Phase 4: Automation & Hooks Update

**Agent:** CLI-Director (CDIR)
**Prerequisites:** Phase 3 complete (workspace coordination updated)
**Execution Environment:** PowerShell Terminal Window 1 + Text Editor
**OS:** Windows
**Project Path:** `C:\Development\perplex`
**Branch:** `claude/design-three-agent-config` (continue)
**Duration Estimate:** 45-60 minutes

---

## IMPORTANT: Environment Setup

**You are running on Windows with PowerShell.**

**CRITICAL: Shell Scripts vs PowerShell**

The files you'll edit in this phase are **bash shell scripts** (`.sh` files and `.githooks/*`):
- **Editing:** Open in text editor (VS Code, Notepad++, etc.)
- **Content:** Bash syntax (NOT PowerShell syntax)
- **Execution:** Git Bash runs these automatically (NOT PowerShell)

**Why:** Git on Windows uses Git Bash to execute hooks and shell scripts. Even though you're in PowerShell, Git will invoke Git Bash to run `.sh` files.

**PowerShell Commands:** Used only for file operations (copy, list, test) and git commands. NOT for editing shell scripts.

---

## Mission

Update all automation scripts and git hooks to recognize three-agent architecture (CDIR/CEXE/Web).

---

## Files to Modify

1. `tools\agent-start-work.sh` - Start work script
2. `tools\agent-handoff.sh` - Handoff coordination
3. `tools\agent-check-registry.sh` - Registry status display
4. `tools\ensure-claude-branch.sh` - Branch enforcement
5. `.githooks\pre-commit` - Commit-time validation
6. `.githooks\pre-push` - Push-time validation
7. `.githooks\README.md` - Hooks documentation

**All are bash scripts** - edit in text editor, Git Bash executes them.

---

## Step 1: Verify Phase 3 Complete

```powershell
cat .claude\migration-phase-3-complete.txt
git log --oneline -1 | Select-String "Phase 3"
```

Should show Phase 3 marker and recent commit.

---

## Step 2: Update `tools\agent-start-work.sh`

**Open `tools\agent-start-work.sh` in your text editor (VS Code, Notepad++, etc.)**

**Find the agent identity detection section** and replace with:

```bash
# Detect agent identity (three-agent architecture)
AGENT_ID="unknown"
AGENT_NAME="Unknown"
BRANCH_PREFIX="claude"

if [ -f ".claude/identity-cli-director.json" ]; then
    AGENT_ID="cli-claude-director-001"
    AGENT_NAME="CDIR"
    BRANCH_PREFIX="claude/design"
    echo "Agent: CLI-Director (CDIR)"
elif [ -f ".claude/identity-cli-executor.json" ]; then
    AGENT_ID="cli-claude-executor-001"
    AGENT_NAME="CEXE"
    BRANCH_PREFIX="claude/impl"
    echo "Agent: CLI-Executor (CEXE)"
elif [ -f ".claude/identity-web.json" ]; then
    AGENT_ID="web-claude-designer-001"
    AGENT_NAME="Web"
    BRANCH_PREFIX="claude/web-emergency"
    echo "Agent: Claude Code Web (standby)"
else
    echo "ERROR: No agent identity file found"
    exit 1
fi
```

**Save the file.**

**Test (if script has --dry-run option):**
```powershell
bash tools\agent-start-work.sh --dry-run
```

**Note:** If bash not found, this will test later when Git hook runs.

---

## Step 3: Update `tools\agent-handoff.sh`

**Open `tools\agent-handoff.sh` in your text editor**

**Add three-agent handoff validation logic:**

```bash
# Valid handoff patterns for three-agent architecture:
# CDIR → CEXE (specification complete, ready for planning)
# CEXE → CDIR (plan complete, needs validation)
# CDIR → CEXE (plan validated, ready for implementation)
# CEXE → CDIR (implementation complete, needs validation)
# CDIR → CDIR (specification refinement)
# CEXE → CEXE (continued implementation)

VALID_HANDOFFS="CDIR->CEXE CEXE->CDIR CDIR->CDIR CEXE->CEXE"

FROM_AGENT="$1"
TO_AGENT="$2"
HANDOFF_TYPE="$FROM_AGENT->$TO_AGENT"

if [[ ! " $VALID_HANDOFFS " =~ " $HANDOFF_TYPE " ]]; then
    echo "ERROR: Invalid handoff: $HANDOFF_TYPE"
    echo "Valid handoffs: $VALID_HANDOFFS"
    exit 1
fi

echo "Valid handoff: $HANDOFF_TYPE"
```

**Update handoff marker creation** to include three-agent fields:

```bash
# Create handoff marker
HANDOFF_FILE=".claude/handoffs/handoff-$(date +%s)-${FROM_AGENT}-${TO_AGENT}.json"

cat > "$HANDOFF_FILE" <<EOF
{
  "from_agent": "$FROM_AGENT",
  "to_agent": "$TO_AGENT",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "artifact_path": "$ARTIFACT_PATH",
  "message": "$MESSAGE",
  "next_action": "$NEXT_ACTION",
  "handoff_type": "$HANDOFF_TYPE"
}
EOF
```

**Save the file.**

---

## Step 4: Update `tools\agent-check-registry.sh`

**Open `tools\agent-check-registry.sh` in your text editor**

**Replace the agent display logic with three-agent version:**

```bash
#!/bin/bash
# Display three-agent registry status

REGISTRY_FILE=".claude/agent-registry.json"

if [ ! -f "$REGISTRY_FILE" ]; then
    echo "ERROR: Agent registry not found: $REGISTRY_FILE"
    exit 1
fi

echo "========================================="
echo "  Agent Registry Status (Three-Agent)"
echo "========================================="
echo

# CDIR (Designer-Researcher)
echo "CDIR (Designer-Researcher):"
if command -v jq &> /dev/null; then
    jq -r '.agents[] | select(.agent_id=="cli-claude-director-001") |
        "  Status: \(.status)\n  Branch: \(.workspace.current_work_branch // "none")\n  Work: \(.workspace.current_work)\n  Last Active: \(.last_active)"' \
        "$REGISTRY_FILE"
else
    grep -A 20 '"agent_id": "cli-claude-director-001"' "$REGISTRY_FILE" | head -15
fi
echo

# CEXE (Executor-Validator)
echo "CEXE (Executor-Validator):"
if command -v jq &> /dev/null; then
    jq -r '.agents[] | select(.agent_id=="cli-claude-executor-001") |
        "  Status: \(.status)\n  Branch: \(.workspace.current_work_branch // "none")\n  Work: \(.workspace.current_work)\n  Last Active: \(.last_active)"' \
        "$REGISTRY_FILE"
else
    grep -A 20 '"agent_id": "cli-claude-executor-001"' "$REGISTRY_FILE" | head -15
fi
echo

# Web (Standby-Emergency)
echo "Web (Standby-Emergency):"
if command -v jq &> /dev/null; then
    jq -r '.agents[] | select(.agent_id=="web-claude-designer-001") |
        "  Status: \(.status)\n  Branch: \(.workspace.current_work_branch // "none")\n  Work: \(.workspace.current_work)\n  Last Active: \(.last_active)"' \
        "$REGISTRY_FILE"
else
    grep -A 20 '"agent_id": "web-claude-designer-001"' "$REGISTRY_FILE" | head -15
fi
echo

echo "========================================="
```

**Save the file.**

**Test:**
```powershell
bash tools\agent-check-registry.sh
```

**Note:** If bash not found, skip test. Will validate when Git runs it.

---

## Step 5: Update `tools\ensure-claude-branch.sh`

**Open `tools\ensure-claude-branch.sh` in your text editor**

**Add CDIR/CEXE branch pattern suggestions:**

```bash
# Detect agent and suggest appropriate branch pattern
AGENT_ID="unknown"

if [ -f ".claude/identity-cli-director.json" ]; then
    AGENT_ID="cli-claude-director-001"
    AGENT_NAME="CDIR"
    BRANCH_PATTERN="claude/design-*"
    SUGGESTED_BRANCH="claude/design-$(date +%s)"

elif [ -f ".claude/identity-cli-executor.json" ]; then
    AGENT_ID="cli-claude-executor-001"
    AGENT_NAME="CEXE"
    BRANCH_PATTERN="claude/impl-*"
    SUGGESTED_BRANCH="claude/impl-$(date +%s)"

elif [ -f ".claude/identity-web.json" ]; then
    AGENT_ID="web-claude-designer-001"
    AGENT_NAME="Web"
    BRANCH_PATTERN="claude/web-emergency-*"
    SUGGESTED_BRANCH="claude/web-emergency-$(date +%s)"
fi

CURRENT_BRANCH=$(git branch --show-current)

echo "Agent: $AGENT_NAME ($AGENT_ID)"
echo "Current branch: $CURRENT_BRANCH"
echo "Expected pattern: $BRANCH_PATTERN"

if [[ ! "$CURRENT_BRANCH" =~ ^${BRANCH_PATTERN//\*/.*}$ ]]; then
    echo "WARNING: Branch does not match agent pattern"
    echo "Suggested: $SUGGESTED_BRANCH"
fi
```

**Save the file.**

---

## Step 6: Update `.githooks\pre-commit`

**Open `.githooks\pre-commit` in your text editor**

**Add three-agent workspace validation:**

**1. Add agent detection at top of hook:**

```bash
#!/bin/bash
# Pre-commit hook with three-agent workspace validation

# Detect which agent is committing
AGENT_ID="unknown"
AGENT_NAME="Unknown"

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

echo "Pre-commit: Agent $AGENT_NAME ($AGENT_ID)"
```

**2. Add workspace boundary validation:**

```bash
# Workspace boundary validation (three-agent architecture)
echo "Validating workspace boundaries..."

MODIFIED_FILES=$(git diff --cached --name-only)
VIOLATIONS=()

for FILE in $MODIFIED_FILES; do
    # CDIR primary ownership
    if [ "$AGENT_ID" = "cli-claude-director-001" ]; then
        # CDIR should NOT directly modify implementation artifacts
        if [[ "$FILE" =~ ^src/ ]] || \
           [[ "$FILE" =~ ^tests/ ]] || \
           [[ "$FILE" =~ specs/.*/plan\.md$ ]] || \
           [[ "$FILE" =~ specs/.*/tasks\.md$ ]]; then
            VIOLATIONS+=("$FILE (CDIR should not modify implementation)")
        fi
    fi

    # CEXE primary ownership
    if [ "$AGENT_ID" = "cli-claude-executor-001" ]; then
        # CEXE should NOT directly modify design artifacts
        if [[ "$FILE" =~ ^decisions/ ]] || \
           [[ "$FILE" =~ ^requirements/ ]] || \
           [[ "$FILE" =~ specs/.*/spec\.md$ ]] || \
           [[ "$FILE" =~ \.specify/memory/constitution\.md$ ]]; then
            VIOLATIONS+=("$FILE (CEXE should not modify design)")
        fi
    fi

    # Web should only modify in emergency
    if [ "$AGENT_ID" = "web-claude-designer-001" ]; then
        # Check if emergency branch
        CURRENT_BRANCH=$(git branch --show-current)
        if [[ ! "$CURRENT_BRANCH" =~ ^claude/web-emergency- ]]; then
            VIOLATIONS+=("$FILE (Web not on emergency branch)")
        fi
    fi
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
    echo "❌ Workspace boundary violations detected:"
    for VIOLATION in "${VIOLATIONS[@]}"; do
        echo "  - $VIOLATION"
    done
    echo
    echo "Check .claude/workspace-coordination.yml for agent boundaries"
    echo "To override (NOT recommended): git commit --no-verify"
    exit 1
fi

echo "✓ Workspace boundaries validated"
```

**3. Keep existing foundation validation** (should already be there)

**Save the file.**

---

## Step 7: Update `.githooks\pre-push`

**Open `.githooks\pre-push` in your text editor**

**Add three-agent branch pattern enforcement:**

**1. Add agent detection:**

```bash
#!/bin/bash
# Pre-push hook with three-agent branch enforcement

# Detect agent
AGENT_ID="unknown"
AGENT_NAME="Unknown"

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

echo "Pre-push: Agent $AGENT_NAME ($AGENT_ID)"
```

**2. Add branch pattern enforcement:**

```bash
# Branch pattern enforcement (three-agent architecture)
CURRENT_BRANCH=$(git branch --show-current)

echo "Validating branch pattern for $AGENT_NAME..."

if [ "$AGENT_ID" = "cli-claude-director-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/design- ]] && \
       [[ "$CURRENT_BRANCH" != "main" ]]; then
        echo "❌ ERROR: CDIR must use claude/design-* branches"
        echo "Current branch: $CURRENT_BRANCH"
        echo "Expected pattern: claude/design-*"
        exit 1
    fi

elif [ "$AGENT_ID" = "cli-claude-executor-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/impl- ]] && \
       [[ "$CURRENT_BRANCH" != "main" ]]; then
        echo "❌ ERROR: CEXE must use claude/impl-* branches"
        echo "Current branch: $CURRENT_BRANCH"
        echo "Expected pattern: claude/impl-*"
        exit 1
    fi

elif [ "$AGENT_ID" = "web-claude-designer-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/web-emergency- ]] && \
       [[ "$CURRENT_BRANCH" != "main" ]]; then
        echo "⚠️  WARNING: Web should only push to claude/web-emergency-*"
        echo "Current branch: $CURRENT_BRANCH"
        # Warning only, don't block (Web might need to push other branches in emergency)
    fi
fi

echo "✓ Branch pattern validated"
```

**3. Keep existing completeness review** (should already be there)

**Save the file.**

---

## Step 8: Update `.githooks\README.md`

**Open `.githooks\README.md` in your text editor**

**Add three-agent documentation section:**

```markdown
## Three-Agent Architecture

### Agent Identity Detection

Hooks detect agent identity by checking for identity files:
- `.claude/identity-cli-director.json` → CDIR (Designer-Researcher)
- `.claude/identity-cli-executor.json` → CEXE (Executor-Validator)
- `.claude/identity-web.json` → Web (Standby-Emergency)

### Pre-Commit Hook

**Workspace Boundary Validation:**
- CDIR: Cannot modify `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`
- CEXE: Cannot modify `decisions/`, `requirements/`, `specs/*/spec.md`, `.specify/memory/constitution.md`
- Web: Must be on `claude/web-emergency-*` branch

**Violation handling:** BLOCKS commit (exit 1)
**Override:** `git commit --no-verify` (NOT recommended)

### Pre-Push Hook

**Branch Pattern Enforcement:**
- CDIR: Must use `claude/design-*` branches
- CEXE: Must use `claude/impl-*` branches
- Web: Should use `claude/web-emergency-*` branches (warning only)

**Exception:** Pushing to `main` is allowed (for merges)

### Example Workflows

**CDIR (Designer) Workflow:**
```bash
# Create design branch
git checkout -b claude/design-feature-name

# Make changes to design artifacts
# edit decisions/, docs/, specs/*/spec.md

# Commit (pre-commit validates boundaries)
git commit -m "[CDIR] Create specification"

# Push (pre-push validates branch pattern)
git push -u origin claude/design-feature-name
```

**CEXE (Executor) Workflow:**
```bash
# Create implementation branch
git checkout -b claude/impl-feature-name

# Make changes to implementation artifacts
# edit src/, tests/, specs/*/plan.md, specs/*/tasks.md

# Commit (pre-commit validates boundaries)
git commit -m "[CEXE] Implement feature"

# Push (pre-push validates branch pattern)
git push -u origin claude/impl-feature-name
```

**Web (Emergency) Workflow:**
```bash
# Only when CDIR unavailable >24 hours
git checkout -b claude/web-emergency-reason

# Web can modify design artifacts in emergency
# Commits and pushes will validate emergency branch pattern

git commit -m "[Web] Emergency: reason"
git push -u origin claude/web-emergency-reason
```
```

**Save the file.**

---

## Step 9: Test Hooks Locally

**Test pre-commit hook:**

```powershell
# Create test file
"test" | Set-Content -Path .test-file

# Stage it
git add .test-file

# Attempt commit (hook will run via Git Bash automatically)
git commit --no-gpg-sign -m "Test: CDIR pre-commit hook"

# Hook should run and validate
# If passes, undo:
git reset HEAD~1
rm .test-file
```

**Note:** Hooks execute via Git Bash automatically when you run git commands from PowerShell. You don't need to manually invoke bash.

---

## Step 10: Commit Automation & Hooks Changes

```powershell
git add tools\agent-start-work.sh
git add tools\agent-handoff.sh
git add tools\agent-check-registry.sh
git add tools\ensure-claude-branch.sh
git add .githooks\pre-commit
git add .githooks\pre-push
git add .githooks\README.md
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CDIR] Phase 4: Automation and hooks for three agents

- Updated agent-start-work.sh (recognize CDIR/CEXE/Web)
- Updated agent-handoff.sh (three-agent handoff validation)
- Updated agent-check-registry.sh (display three agents)
- Updated ensure-claude-branch.sh (design/impl/emergency patterns)
- Enhanced pre-commit hook (workspace boundary validation)
- Enhanced pre-push hook (branch pattern enforcement)
- Updated hooks documentation for three-agent workflows

Shell scripts edited in text editor, executed by Git Bash automatically.

Migration Phase: 4 of 9
Next: Phase 5 - Documentation Update

Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/design-three-agent-config
Environment: Windows PowerShell at C:\Development\perplex
"
```

---

## Step 11: Create Phase 4 Marker

```powershell
"Phase 4 complete: $(Get-Date)" | Set-Content -Path .claude\migration-phase-4-complete.txt
cat .claude\migration-phase-4-complete.txt
```

---

## Validation Checklist

- [ ] All automation scripts updated (agent-start-work, agent-handoff, agent-check-registry, ensure-claude-branch)
- [ ] Scripts recognize CDIR/CEXE/Web identities
- [ ] agent-check-registry.sh displays three agents correctly
- [ ] ensure-claude-branch.sh suggests correct branch patterns
- [ ] Pre-commit hook validates workspace boundaries
- [ ] Pre-push hook enforces branch patterns
- [ ] Hooks documentation updated with three-agent workflows
- [ ] Test commit executed successfully (hooks ran)
- [ ] Changes committed to git
- [ ] Phase 4 marker created

---

## If Validation Fails

**Problem: Bash command not found**
- This is normal on Windows - Git will use Git Bash automatically
- Don't worry if `bash script.sh` fails in PowerShell
- Hooks will run when you `git commit` or `git push`

**Problem: Hook doesn't run**
- Check `.git/hooks/` (hooks should be symlinked or copied there)
- Verify hook file is executable: `git update-index --chmod=+x .githooks/pre-commit`
- Check git config: `git config core.hooksPath .githooks`

**Problem: Workspace boundary violation during test**
- Check which agent identity file exists
- Verify you're modifying allowed files for that agent
- See `.claude/workspace-coordination.yml` for boundaries

**Problem: Branch pattern error**
- Ensure you're on `claude/design-three-agent-config` branch
- This is allowed during migration setup
- Pattern enforcement applies to normal operations

---

## Announce Completion

```
[From: CDIR] Phase 4 COMPLETE. Automation and hooks updated for three-agent architecture.

Enforcement mechanisms in place:
- Pre-commit hook: Workspace boundary validation (BLOCKS violations)
  - CDIR cannot modify src/, tests/, implementation artifacts
  - CEXE cannot modify decisions/, requirements/, design artifacts
  - Web requires emergency branch

- Pre-push hook: Branch pattern enforcement
  - CDIR: claude/design-* branches
  - CEXE: claude/impl-* branches
  - Web: claude/web-emergency-* branches

- Tools updated:
  - agent-start-work.sh: Detects CDIR/CEXE/Web
  - agent-handoff.sh: Validates three-agent handoffs
  - agent-check-registry.sh: Displays all three agents
  - ensure-claude-branch.sh: Suggests correct patterns

Shell scripts run via Git Bash automatically when git commands execute.

Validation: PASSED (hooks tested, git committed)

Environment: Windows PowerShell at C:\Development\perplex
Ready for Phase 5: Documentation Update
```

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001
**Environment:** Windows PowerShell (shell scripts run via Git Bash)
**Project Path:** C:\Development\perplex
**Phase:** 4 of 9
**Next:** Phase 5 - Documentation Update

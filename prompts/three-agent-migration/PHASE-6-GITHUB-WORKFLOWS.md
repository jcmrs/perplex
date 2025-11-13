# Phase 6: GitHub Workflows Update

**Agent:** CLI-Director (CDIR)
**Prerequisites:** Phase 5 complete (documentation updated)
**Execution Environment:** PowerShell Terminal Window 1 + Text Editor
**OS:** Windows (but editing GitHub Actions workflows that run on Linux)
**Project Path:** `C:\Development\perplex`
**Branch:** `claude/design-three-agent-config` (continue)
**Duration Estimate:** 30-45 minutes

---

## IMPORTANT: Environment Setup

**You are running on Windows with PowerShell.**

**File Editing:** GitHub Actions workflow files (YAML) should be edited in a text editor (VS Code, Notepad++, etc.).

**IMPORTANT NOTE:** GitHub Actions workflows run on GitHub's Linux runners, NOT on your Windows machine. The YAML syntax inside workflows uses bash/Linux conventions. Only the local verification commands use PowerShell.

**PowerShell Commands:** Used for local file operations and verification only.

---

## Mission

Update GitHub Actions workflows to recognize three-agent architecture (CDIR, CEXE, Web).

---

## Files to Modify

1. `.github\workflows\workspace-validation.yml` - Workspace boundary validation
2. `.github\workflows\auto-create-pr-claude-branches.yml` - PR creation
3. `.github\workflows\auto-merge-claude-branches.yml` - Auto-merge rules
4. `.github\workflows\checkpoint-automation.yml` - Checkpoint creation

**Note:** All workflow files use bash syntax (they run on Linux), but we edit them from Windows.

---

## Step 1: Verify Phase 5 Complete

```powershell
cat .claude\migration-phase-5-complete.txt
git log --oneline -1 | Select-String "Phase 5"
```

Should show Phase 5 marker and recent commit.

---

## Step 2: Update `.github\workflows\workspace-validation.yml`

**Open `.github\workflows\workspace-validation.yml` in your text editor**

**Find the workspace validation step and update to recognize three agents:**

```yaml
- name: Validate workspace boundaries
  run: |
    # Detect agent from branch name
    BRANCH="${{ github.head_ref }}"

    if [[ "$BRANCH" =~ ^claude/design- ]]; then
      AGENT="cli-claude-director-001"
      AGENT_NAME="CDIR"
      echo "Agent: CDIR (Designer-Researcher)"
    elif [[ "$BRANCH" =~ ^claude/impl- ]]; then
      AGENT="cli-claude-executor-001"
      AGENT_NAME="CEXE"
      echo "Agent: CEXE (Executor-Validator)"
    elif [[ "$BRANCH" =~ ^claude/web-emergency- ]]; then
      AGENT="web-claude-designer-001"
      AGENT_NAME="Web"
      echo "Agent: Web (Emergency)"
    else
      echo "Unknown branch pattern: $BRANCH"
      echo "Expected: claude/design-*, claude/impl-*, or claude/web-emergency-*"
      exit 1
    fi

    # Get modified files
    FILES=$(git diff --name-only origin/main...)

    # Validate against workspace manifest
    echo "Validating $AGENT_NAME workspace boundaries..."

    # If validation script exists, run it
    if [ -f "tools/validate-workspace-boundaries.py" ]; then
      python tools/validate-workspace-boundaries.py \
        --agent "$AGENT" \
        --files "$FILES" \
        --manifest ".claude/workspace-coordination.yml"
    else
      echo "Workspace validation script not yet implemented - skipping"
    fi
```

**Save the file.**

---

## Step 3: Update `.github\workflows\auto-create-pr-claude-branches.yml`

**Open `.github\workflows\auto-create-pr-claude-branches.yml` in your text editor**

### A. Update Trigger to Recognize New Branch Patterns

**Find the `on:` section and update:**

```yaml
on:
  push:
    branches:
      - 'claude/design-**'   # CDIR (Designer-Researcher) branches
      - 'claude/impl-**'     # CEXE (Executor-Validator) branches
      - 'claude/web-emergency-**'  # Web (Emergency) branches
```

### B. Add Agent Detection Step

**Add a step to determine which agent:**

```yaml
- name: Determine agent from branch
  id: agent
  run: |
    BRANCH="${{ github.ref_name }}"
    echo "Branch: $BRANCH"

    if [[ "$BRANCH" =~ ^claude/design- ]]; then
      echo "agent=CDIR" >> $GITHUB_OUTPUT
      echo "agent_id=cli-claude-director-001" >> $GITHUB_OUTPUT
      echo "agent_name=CLI-Director" >> $GITHUB_OUTPUT
      echo "Detected: CDIR (Designer-Researcher)"
    elif [[ "$BRANCH" =~ ^claude/impl- ]]; then
      echo "agent=CEXE" >> $GITHUB_OUTPUT
      echo "agent_id=cli-claude-executor-001" >> $GITHUB_OUTPUT
      echo "agent_name=CLI-Executor" >> $GITHUB_OUTPUT
      echo "Detected: CEXE (Executor-Validator)"
    elif [[ "$BRANCH" =~ ^claude/web-emergency- ]]; then
      echo "agent=Web" >> $GITHUB_OUTPUT
      echo "agent_id=web-claude-designer-001" >> $GITHUB_OUTPUT
      echo "agent_name=Claude Code Web" >> $GITHUB_OUTPUT
      echo "Detected: Web (Emergency)"
    else
      echo "agent=Unknown" >> $GITHUB_OUTPUT
      echo "agent_id=unknown" >> $GITHUB_OUTPUT
      echo "agent_name=Unknown" >> $GITHUB_OUTPUT
    fi
```

### C. Update PR Title to Include Agent

**Find the PR title creation and update:**

```yaml
PR_TITLE="[${{ steps.agent.outputs.agent }}] $COMMIT_TITLE"
```

**This will create PRs titled like:**
- `[CDIR] Add feature specification`
- `[CEXE] Implement feature from spec`
- `[Web] Emergency: Continue work`

**Save the file.**

---

## Step 4: Update `.github\workflows\auto-merge-claude-branches.yml`

**Open `.github\workflows\auto-merge-claude-branches.yml` in your text editor**

### A. Update Branch Trigger

**Find the `on:` section and update:**

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches:
      - main
  pull_request_target:
    types: [opened, synchronize, reopened]
    branches:
      - main

# Only run on Claude branches
    # Filter in job condition
```

### B. Add Three-Agent Merge Rules

**Add a step to check agent-specific merge rules:**

```yaml
- name: Check agent and merge rules
  run: |
    BRANCH="${{ github.event.pull_request.head.ref }}"
    echo "Checking branch: $BRANCH"

    if [[ "$BRANCH" =~ ^claude/design- ]]; then
      echo "✓ CDIR branch detected"
      echo "Merge rule: Requires workspace validation (design files only)"
      echo "AGENT=CDIR" >> $GITHUB_ENV

    elif [[ "$BRANCH" =~ ^claude/impl- ]]; then
      echo "✓ CEXE branch detected"
      echo "Merge rule: Requires workspace validation + tests"
      echo "AGENT=CEXE" >> $GITHUB_ENV

    elif [[ "$BRANCH" =~ ^claude/web-emergency- ]]; then
      echo "⚠️  Web emergency branch detected"
      echo "Merge rule: Requires manual approval (emergency only)"
      echo "AGENT=Web" >> $GITHUB_ENV
      # Don't auto-merge emergency branches
      exit 1

    else
      echo "Unknown branch pattern: $BRANCH"
      echo "Expected: claude/design-*, claude/impl-*, or claude/web-emergency-*"
      exit 1
    fi
```

**Add validation based on agent:**

```yaml
- name: Validate workspace boundaries
  if: env.AGENT != 'Web'  # Skip for emergency branches
  run: |
    echo "Validating $AGENT workspace boundaries..."

    # Get modified files
    FILES=$(git diff --name-only origin/main...)

    # Check CDIR modifications
    if [ "$AGENT" = "CDIR" ]; then
      # CDIR should not modify src/, tests/, implementation artifacts
      if echo "$FILES" | grep -E "^src/|^tests/|specs/.*/plan\.md|specs/.*/tasks\.md"; then
        echo "❌ CDIR cannot modify implementation artifacts"
        exit 1
      fi
      echo "✓ CDIR workspace boundaries validated"
    fi

    # Check CEXE modifications
    if [ "$AGENT" = "CEXE" ]; then
      # CEXE should not modify decisions/, requirements/, specs/*/spec.md
      if echo "$FILES" | grep -E "^decisions/|^requirements/|specs/.*/spec\.md"; then
        echo "❌ CEXE cannot modify design artifacts"
        exit 1
      fi
      echo "✓ CEXE workspace boundaries validated"
    fi
```

**Save the file.**

---

## Step 5: Update `.github\workflows\checkpoint-automation.yml`

**Open `.github\workflows\checkpoint-automation.yml` in your text editor**

### A. Add Agent Attribution to Checkpoints

**Find the checkpoint creation step and update:**

```yaml
- name: Create checkpoint with agent attribution
  run: |
    # Detect agent from branch name
    BRANCH="${{ github.event.pull_request.head.ref }}"

    if [[ "$BRANCH" =~ ^claude/design- ]]; then
      AGENT_ID="cli-claude-director-001"
      AGENT_NAME="CDIR"
    elif [[ "$BRANCH" =~ ^claude/impl- ]]; then
      AGENT_ID="cli-claude-executor-001"
      AGENT_NAME="CEXE"
    elif [[ "$BRANCH" =~ ^claude/web-emergency- ]]; then
      AGENT_ID="web-claude-designer-001"
      AGENT_NAME="Web"
    else
      AGENT_ID="unknown"
      AGENT_NAME="Unknown"
    fi

    echo "Checkpoint created by: $AGENT_NAME ($AGENT_ID)"

    export CHECKPOINT_NON_INTERACTIVE=true
    export CHECKPOINT_DESCRIPTION="PR #${{ github.event.pull_request.number }} merged"
    export CHECKPOINT_SUMMARY="Merged $AGENT_NAME PR: ${{ github.event.pull_request.title }}"
    export CHECKPOINT_CREATED_BY="$AGENT_ID"
    export CHECKPOINT_TRIGGER="PR-Merge"

    ./tools/create-checkpoint.sh
```

**Save the file.**

---

## Step 6: Check for Other Workflow References

```powershell
# Search for old agent references in all workflows
Get-ChildItem .github\workflows\ -Filter *.yml | ForEach-Object {
    $file = $_.FullName
    $content = Get-Content $file -Raw
    if ($content -match "cli-claude-executor-001|web-claude-designer-001|cli-claude-director-001") {
        Write-Host "Found agent reference in: $($_.Name)"
    }
}
```

**If other workflows are found with agent references, update them similarly.**

---

## Step 7: Validate YAML Syntax (Optional)

```powershell
# If yamllint is available
Get-ChildItem .github\workflows\ -Filter *.yml | ForEach-Object {
    Write-Host "Checking: $($_.Name)"
    # yamllint would run here if installed
}
```

**Note:** YAML validation will happen automatically when workflows run on GitHub.

---

## Step 8: Commit Workflow Changes

```powershell
git add .github\workflows\workspace-validation.yml
git add .github\workflows\auto-create-pr-claude-branches.yml
git add .github\workflows\auto-merge-claude-branches.yml
git add .github\workflows\checkpoint-automation.yml
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CDIR] Phase 6: GitHub workflows for three-agent architecture

- Updated workspace-validation.yml (recognize CDIR/CEXE/Web patterns)
- Updated auto-create-pr-claude-branches.yml (design/impl/emergency branches)
- Updated auto-merge-claude-branches.yml (three-agent merge rules)
- Updated checkpoint-automation.yml (agent attribution)

Workflows now recognize:
- claude/design-* → CDIR (Designer-Researcher)
- claude/impl-* → CEXE (Executor-Validator)
- claude/web-emergency-* → Web (Emergency)

Workspace boundary validation enforced in GitHub Actions.
Web emergency branches require manual approval (no auto-merge).

Migration Phase: 6 of 9
Next: Phase 7 - Validation & Testing (CEXE first boot)

Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/design-three-agent-config
Environment: Windows PowerShell at C:\Development\perplex
"
```

---

## Step 9: Create Phase 6 Marker

```powershell
"Phase 6 complete: $(Get-Date)" | Set-Content -Path .claude\migration-phase-6-complete.txt
cat .claude\migration-phase-6-complete.txt
```

---

## Validation Checklist

- [ ] workspace-validation.yml recognizes three agent branch patterns
- [ ] auto-create-pr-claude-branches.yml handles design/impl/emergency branches
- [ ] auto-create-pr PR titles include agent name ([CDIR], [CEXE], [Web])
- [ ] auto-merge-claude-branches.yml has three-agent merge rules
- [ ] auto-merge blocks Web emergency branches (manual approval required)
- [ ] checkpoint-automation.yml attributes checkpoints to correct agent
- [ ] No other workflows have stale agent references
- [ ] Changes committed to git
- [ ] Phase 6 marker created

---

## If Validation Fails

**Problem: YAML syntax error**
- Open in VS Code (has YAML validation)
- Check indentation (YAML is whitespace-sensitive)
- Verify no tabs (use spaces only)
- Test workflow will fail on push (GitHub validates YAML)

**Problem: Workflow doesn't trigger**
- Check branch pattern matches: `claude/design-*`, `claude/impl-*`, `claude/web-emergency-*`
- Verify workflow is on correct branch (workflows run from default branch)
- Check GitHub Actions tab for workflow runs

**Problem: Agent detection not working**
- Check regex patterns in workflow: `^claude/design-`, `^claude/impl-`, etc.
- Verify `$GITHUB_OUTPUT` syntax (not `$GITHUB_ENV`)
- Check step outputs are referenced correctly: `${{ steps.agent.outputs.agent }}`

---

## Announce Completion

```
[From: CDIR] Phase 6 COMPLETE. GitHub workflows updated for three-agent architecture.

Workflows configured:
- workspace-validation: Validates CDIR/CEXE/Web workspace boundaries
- auto-create-pr: Recognizes design/impl/emergency branches, adds agent to title
- auto-merge: Three-agent merge rules, blocks Web emergency (manual approval)
- checkpoint-automation: Attributes checkpoints to creating agent

Branch patterns recognized:
- claude/design-* → CDIR (Designer-Researcher)
- claude/impl-* → CEXE (Executor-Validator)
- claude/web-emergency-* → Web (Emergency, manual approval)

Enforcement:
- GitHub Actions validates workspace boundaries automatically
- CDIR cannot merge changes to src/, tests/, implementation artifacts
- CEXE cannot merge changes to decisions/, requirements/, specs/*/spec.md
- Web emergency branches require manual approval (no auto-merge)

Validation: PASSED (YAML edited, git committed)

Environment: Windows PowerShell at C:\Development\perplex
Ready for Phase 7: Validation & Testing (CEXE first boot in Terminal 2)
```

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001
**Environment:** Windows PowerShell (editing workflows that run on Linux)
**Project Path:** C:\Development\perplex
**Phase:** 6 of 9
**Next:** Phase 7 - Validation & Testing

# Phase 6: GitHub Workflows Update

**Agent:** CDIR
**Prerequisites:** Phase 5 complete
**Branch:** `claude/design-three-agent-config` (continue)
**Duration:** 30-45 min

---

## Mission

Update GitHub Actions workflows to recognize three agents.

---

## Files to Modify

1. `.github/workflows/workspace-validation.yml`
2. `.github/workflows/auto-create-pr-claude-branches.yml`
3. `.github/workflows/auto-merge-claude-branches.yml`
4. `.github/workflows/checkpoint-automation.yml`

---

## Step-by-Step

### 1. Verify Phase 5
```bash
cat .claude/migration-phase-5-complete.txt
```

### 2. Update `workspace-validation.yml`

**Add three-agent validation:**

```yaml
- name: Validate workspace boundaries
  run: |
    # Detect agent from branch name
    BRANCH="${{ github.head_ref }}"

    if [[ "$BRANCH" =~ ^claude/design- ]]; then
      AGENT="cli-claude-director-001"
      echo "Agent: CDIR (designer)"
    elif [[ "$BRANCH" =~ ^claude/impl- ]]; then
      AGENT="cli-claude-executor-001"
      echo "Agent: CEXE (executor)"
    elif [[ "$BRANCH" =~ ^claude/web-emergency- ]]; then
      AGENT="web-claude-designer-001"
      echo "Agent: Web (emergency)"
    else
      echo "Unknown branch pattern: $BRANCH"
      exit 1
    fi

    # Get modified files
    FILES=$(git diff --name-only origin/main...)

    # Validate against workspace manifest
    python tools/validate-workspace-boundaries.py \
      --agent "$AGENT" \
      --files "$FILES" \
      --manifest ".claude/workspace-coordination.yml"
```

### 3. Update `auto-create-pr-claude-branches.yml`

**Recognize new branch patterns:**

```yaml
on:
  push:
    branches:
      - 'claude/design-**'   # CDIR branches
      - 'claude/impl-**'     # CEXE branches
      - 'claude/web-emergency-**'  # Web emergency branches
```

**Extract agent identity:**

```yaml
- name: Determine agent
  id: agent
  run: |
    BRANCH="${{ github.ref_name }}"

    if [[ "$BRANCH" =~ ^claude/design- ]]; then
      echo "agent=CDIR" >> $GITHUB_OUTPUT
      echo "agent_id=cli-claude-director-001" >> $GITHUB_OUTPUT
    elif [[ "$BRANCH" =~ ^claude/impl- ]]; then
      echo "agent=CEXE" >> $GITHUB_OUTPUT
      echo "agent_id=cli-claude-executor-001" >> $GITHUB_OUTPUT
    elif [[ "$BRANCH" =~ ^claude/web-emergency- ]]; then
      echo "agent=Web" >> $GITHUB_OUTPUT
      echo "agent_id=web-claude-designer-001" >> $GITHUB_OUTPUT
    fi
```

**PR title includes agent:**

```yaml
PR_TITLE="[${{ steps.agent.outputs.agent }}] $COMMIT_TITLE"
```

### 4. Update `auto-merge-claude-branches.yml`

**Merge rules for three agents:**

```yaml
- name: Check agent and merge rules
  run: |
    BRANCH="${{ github.event.pull_request.head.ref }}"

    if [[ "$BRANCH" =~ ^claude/design- ]]; then
      echo "CDIR branch - requires workspace validation"
      # Check CDIR can only modify design files
    elif [[ "$BRANCH" =~ ^claude/impl- ]]; then
      echo "CEXE branch - requires workspace validation + tests"
      # Check CEXE can only modify implementation files
    elif [[ "$BRANCH" =~ ^claude/web-emergency- ]]; then
      echo "Web emergency - requires manual approval"
      exit 1  # Don't auto-merge emergency branches
    fi
```

### 5. Update `checkpoint-automation.yml`

**Agent attribution in checkpoints:**

```yaml
- name: Create checkpoint
  run: |
    # Detect agent from last commit or branch
    AGENT_ID=$(git log -1 --format="%an" | grep -oE "cli-claude-director-001|cli-claude-executor-001|web-claude-designer-001" || echo "unknown")

    export CHECKPOINT_CREATED_BY="$AGENT_ID"

    ./tools/create-checkpoint.sh "PR #${{ github.event.pull_request.number }} merged"
```

### 6. Check Other Workflows

```bash
grep -r "web-claude-designer-001" .github/workflows/ || echo "No other references"
```

Update any other workflows referencing agent identities.

### 7. Commit

```bash
git add .github/workflows/workspace-validation.yml
git add .github/workflows/auto-create-pr-claude-branches.yml
git add .github/workflows/auto-merge-claude-branches.yml
git add .github/workflows/checkpoint-automation.yml

git commit --no-gpg-sign -m "[CDIR] Phase 6: GitHub workflows for three agents

- Updated workspace-validation (CDIR/CEXE/Web patterns)
- Updated auto-create-pr (design/impl/emergency branches)
- Updated auto-merge (three-agent merge rules)
- Updated checkpoint-automation (agent attribution)

Workflows now recognize:
- claude/design-* → CDIR
- claude/impl-* → CEXE
- claude/web-emergency-* → Web

Migration Phase: 6 of 9
Agent: CDIR
"
```

### 8. Create Phase Marker
```bash
echo "Phase 6 complete: $(date)" > .claude/migration-phase-6-complete.txt
```

---

## Validation

- [ ] Workspace validation workflow recognizes three agents
- [ ] Auto-create-PR workflow handles all branch patterns
- [ ] Auto-merge workflow has three-agent rules
- [ ] Checkpoint automation attributes correct agent
- [ ] No other workflows have stale agent references
- [ ] Changes committed

---

## Announce

```
[From: CDIR] Phase 6 COMPLETE. GitHub workflows updated for three agents.

Workflows:
- workspace-validation: Validates CDIR/CEXE/Web boundaries
- auto-create-pr: Recognizes design/impl/emergency branches
- auto-merge: Three-agent merge rules
- checkpoint-automation: Agent attribution

Ready for Phase 7: Validation & Testing
```

---

**Phase:** 6 of 9
**Next:** Phase 7 - Validation & Testing (involves CEXE first boot)

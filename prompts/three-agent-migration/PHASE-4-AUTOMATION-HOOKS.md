# Phase 4: Automation & Hooks Update

**Agent:** CDIR
**Prerequisites:** Phase 3 complete
**Branch:** `claude/design-three-agent-config` (continue)
**Duration:** 45-60 min

---

## Mission

Update all automation scripts and git hooks to recognize CDIR/CEXE/Web.

---

## Files to Modify

1. `tools/agent-start-work.sh`
2. `tools/agent-handoff.sh`
3. `tools/agent-check-registry.sh`
4. `tools/ensure-claude-branch.sh`
5. `.githooks/pre-commit`
6. `.githooks/pre-push`
7. `.githooks/README.md`

---

## Step-by-Step

### 1. Verify Phase 3
```bash
cat .claude/migration-phase-3-complete.txt
```

### 2. Update `tools/agent-start-work.sh`

**Add CDIR/CEXE recognition:**
```bash
# Detect agent identity
if [ -f ".claude/identity-cli-director.json" ]; then
    AGENT_ID="cli-claude-director-001"
    AGENT_NAME="CDIR"
    BRANCH_PREFIX="claude/design"
elif [ -f ".claude/identity-cli-executor.json" ]; then
    AGENT_ID="cli-claude-executor-001"
    AGENT_NAME="CEXE"
    BRANCH_PREFIX="claude/impl"
elif [ -f ".claude/identity-web.json" ]; then
    AGENT_ID="web-claude-designer-001"
    AGENT_NAME="Web"
    BRANCH_PREFIX="claude/web-emergency"
fi
```

Test:
```bash
bash tools/agent-start-work.sh --dry-run
```

### 3. Update `tools/agent-handoff.sh`

**Add three-agent handoff logic:**
```bash
# Valid handoffs:
# CDIR → CEXE (spec complete)
# CEXE → CDIR (plan validation or implementation complete)
# CDIR → CDIR (refinement)
# CEXE → CEXE (continued implementation)

VALID_HANDOFFS="CDIR->CEXE CEXE->CDIR CDIR->CDIR CEXE->CEXE"
```

### 4. Update `tools/agent-check-registry.sh`

**Display three agents:**
```bash
# Show CDIR status
echo "CDIR (Designer):"
jq -r '.agents[] | select(.agent_id=="cli-claude-director-001") | ...'

# Show CEXE status
echo "CEXE (Executor):"
jq -r '.agents[] | select(.agent_id=="cli-claude-executor-001") | ...'

# Show Web status
echo "Web (Standby):"
jq -r '.agents[] | select(.agent_id=="web-claude-designer-001") | ...'
```

Test:
```bash
bash tools/agent-check-registry.sh
```

### 5. Update `tools/ensure-claude-branch.sh`

**Add CDIR/CEXE branch suggestions:**
```bash
if [ "$AGENT_ID" = "cli-claude-director-001" ]; then
    SUGGESTED_BRANCH="claude/design-$(date +%s)"
    echo "CDIR detected. Suggest branch: $SUGGESTED_BRANCH"
elif [ "$AGENT_ID" = "cli-claude-executor-001" ]; then
    SUGGESTED_BRANCH="claude/impl-$(date +%s)"
    echo "CEXE detected. Suggest branch: $SUGGESTED_BRANCH"
fi
```

### 6. Update `.githooks/pre-commit`

**Add three-agent workspace validation:**

```bash
# Detect which agent is committing
AGENT_ID="unknown"
if [ -f ".claude/identity-cli-director.json" ]; then
    AGENT_ID="cli-claude-director-001"
elif [ -f ".claude/identity-cli-executor.json" ]; then
    AGENT_ID="cli-claude-executor-001"
elif [ -f ".claude/identity-web.json" ]; then
    AGENT_ID="web-claude-designer-001"
fi

# Get modified files
MODIFIED_FILES=$(git diff --cached --name-only)

# Validate against workspace manifest
for FILE in $MODIFIED_FILES; do
    # Check if CDIR can modify this file
    # Check if CEXE can modify this file
    # Check if Web emergency override
    # BLOCK if violation
done
```

**Run validation script:**
```bash
bash tools/validate-workspace-boundaries.sh --agent $AGENT_ID --files "$MODIFIED_FILES"
```

### 7. Update `.githooks/pre-push`

**Add three-agent branch validation:**

```bash
# Part 1: Branch enforcement (EXISTING - update)
CURRENT_BRANCH=$(git branch --show-current)

if [ "$AGENT_ID" = "cli-claude-director-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/design- ]]; then
        echo "ERROR: CDIR must use claude/design-* branches"
        exit 1
    fi
elif [ "$AGENT_ID" = "cli-claude-executor-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/impl- ]]; then
        echo "ERROR: CEXE must use claude/impl-* branches"
        exit 1
    fi
elif [ "$AGENT_ID" = "web-claude-designer-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/web-emergency- ]]; then
        echo "WARNING: Web should only push to claude/web-emergency-*"
    fi
fi

# Part 2: Completeness review (EXISTING - keep)
```

### 8. Update `.githooks/README.md`

Add three-agent documentation:
- Pre-commit: CDIR/CEXE/Web validation
- Pre-push: Branch patterns for each agent
- Examples for CDIR and CEXE workflows

### 9. Test Hooks Locally

```bash
# Simulate CDIR commit
echo "test" > .test-file
git add .test-file
git commit --no-gpg-sign -m "Test CDIR hook"
# Should pass workspace validation

# Clean up
git reset HEAD~1
rm .test-file
```

### 10. Commit

```bash
git add tools/agent-start-work.sh
git add tools/agent-handoff.sh
git add tools/agent-check-registry.sh
git add tools/ensure-claude-branch.sh
git add .githooks/pre-commit
git add .githooks/pre-push
git add .githooks/README.md

git commit --no-gpg-sign -m "[CDIR] Phase 4: Automation and hooks for three agents

- Updated agent-start-work.sh (recognize CDIR/CEXE)
- Updated agent-handoff.sh (three-agent patterns)
- Updated agent-check-registry.sh (display three agents)
- Updated ensure-claude-branch.sh (design/impl patterns)
- Enhanced pre-commit hook (three-agent workspace validation)
- Enhanced pre-push hook (design/impl/emergency branch patterns)
- Updated hooks documentation

Migration Phase: 4 of 9
Agent: CDIR
"
```

### 11. Create Phase Marker
```bash
echo "Phase 4 complete: $(date)" > .claude/migration-phase-4-complete.txt
```

---

## Validation

- [ ] All scripts recognize CDIR/CEXE/Web
- [ ] agent-check-registry.sh displays three agents
- [ ] ensure-claude-branch.sh suggests correct patterns
- [ ] Pre-commit hook validates workspace boundaries
- [ ] Pre-push hook enforces branch patterns
- [ ] Test commits/pushes work correctly
- [ ] Hooks documentation updated
- [ ] Changes committed

---

## Announce

```
[From: CDIR] Phase 4 COMPLETE. Automation and hooks updated for three agents.

Enforcement:
- Pre-commit: Workspace boundary validation (BLOCKS violations)
- Pre-push: Branch pattern enforcement (design/impl/emergency)
- Tools: Recognize CDIR/CEXE/Web identities
- Handoffs: Three-agent coordination patterns

Ready for Phase 5: Documentation Update
```

---

**Phase:** 4 of 9
**Next:** Phase 5 - Documentation Update

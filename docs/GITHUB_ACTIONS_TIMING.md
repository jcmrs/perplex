# GitHub Actions Timing Observation

**Date:** 2025-11-12
**Context:** Autonomous PR workflow execution time

---

## The Observation

**User's insight:** "github-actions (bot) took its sweet time to actually run. It only did anything after 15 minutes. That is a long time."

**User's systems thinking:** "When we work, we tend to work faster than that, as in 'we create updates often within such time span'."

---

## What This Means

### Autonomous Workflow Timeline

From **push** to **merge on main**:
- **~15 minutes total**

**Breakdown:**
1. Push to `claude/*` branch → Auto-create PR workflow triggers
2. PR created (~1-2 minutes)
3. Tests workflow runs (shellcheck, yamllint, bats) (~3-5 minutes)
4. Foundation validation runs (~1-2 minutes)
5. Auto-merge workflow triggers after checks pass (~1-2 minutes)
6. PR merged, branch deleted (~1 minute)

**Total:** ~15 minutes from push to seeing changes on main

---

## Why This Matters

### Our Work Cadence vs. Workflow Speed

**Typical work pattern:**
- Make changes
- Commit
- Push
- Continue working
- Make more changes (often within 15 minutes)
- Commit
- Push again

**Result:** Multiple PRs can be "in flight" simultaneously

**Example from actual session:**
- 23:21 UTC: First PR merged (documentation updates)
- 00:00 UTC: Second PR merged (gap analysis + README fix)
- ~40 minutes between pushes, but both PRs overlapped in processing

---

## Implications

### Don't Assume "Not Done Yet" = "Broken"

**The Mistake We Made:**
- User looked at GitHub: "I see a PR but nothing on main"
- We assumed: "Workflow must be broken"
- Reality: Workflow was still running (takes 15 minutes)

**Lesson:** Wait at least 15-20 minutes before assuming workflow failure

### Multiple PRs in Flight

**Scenario:** Push → Continue working → Push again within 15 minutes

**What happens:**
- First PR: Still running tests
- Second PR: Just created
- Both PRs processing simultaneously
- Both will merge in sequence (not conflicting)

**This is fine.** The workflow handles it correctly.

### When to Check GitHub

**Don't check immediately after push** - you'll just see "PR created, checks running"

**Check after 15-20 minutes** - you'll see "PR merged, changes on main"

**Or don't check at all** - trust the workflow, pull main when needed

---

## What to Document

### For AI Agents

**When pushing to `claude/*` branches:**
1. Push commits
2. Auto-create PR workflow will trigger (~15 min total time)
3. Don't check GitHub immediately
4. Don't assume failure if not merged within 5 minutes
5. Wait 15-20 minutes or simply continue working
6. Pull main later to get merged changes

**If user asks "why isn't PR merged yet?":**
1. Ask: How long ago did you push?
2. If < 15 minutes: "Workflow is running, takes ~15 min"
3. If > 20 minutes: Check git log for bot merges
4. Check GitHub Actions tab for workflow status
5. Don't immediately assume workflow is broken

### For Users

**After pushing:**
- Workflow takes ~15 minutes to complete
- You won't see changes on main immediately
- This is normal, not a problem
- You can continue working on next task
- Pull main later to see merged changes

**Multiple pushes in quick succession:**
- Totally fine
- Each push creates its own PR
- PRs merge in sequence
- No manual intervention needed

---

## Comparison to Local Development

### Traditional Local Development
- Make change
- Test locally (~seconds)
- Commit (~seconds)
- See results immediately

### Autonomous PR Workflow
- Make change
- Test locally (~seconds)
- Commit (~seconds)
- Push (~seconds)
- **GitHub Actions workflow (~15 minutes)**
- Results appear on main

**The 15-minute lag is significant** compared to instant local feedback.

---

## Future Optimizations (Potential)

**Possible ways to reduce lag:**
1. Optimize test suite (currently takes 3-5 min)
2. Run tests in parallel (if not already)
3. Cache dependencies in GitHub Actions
4. Skip redundant checks

**However:** 15 minutes is acceptable for autonomous workflow
- We're not waiting (continue working)
- Safety checks are running
- Human doesn't have to click "merge"
- Trade-off: Wait time vs. autonomy

**Don't optimize prematurely.** Current timing is fine.

---

## The Real Gap That Was Identified

**Not a workflow gap** - workflow works perfectly

**The real gap:** Understanding that workflow takes time

**Solution:** This document + WHY_THIS_WAS_WRONG.md in archive

**Key insight:** Trust the system, wait for completion, don't assume failure too quickly

---

## For Future Sessions

When you see "PR created but not merged":
1. Check time since push
2. If < 15 min: Normal, workflow running
3. If > 20 min: Check git log for bot merges
4. Pull main: `git fetch origin main && git log origin/main`
5. Look for commits by `github-actions[bot]`
6. Those are autonomous merges - workflow is working

**The workflow works. It just takes 15 minutes.**

---

**Last Updated:** 2025-11-12
**Status:** Documented real observation from session
**Related:** `archive/mistakes/2025-11-11-phantom-workflow-gap/WHY_THIS_WAS_WRONG.md`

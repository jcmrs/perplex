# Perplexity AI Research: GitHub Cache and Workflow Duplication Issues

**Date:** 2025-11-13
**Purpose:** Investigate GitHub caching behavior and workflow duplication patterns
**Context:** Multi-agent AI project with automated PR workflows
**Priority:** HIGH - Impacts user visibility and automation reliability

---

## Executive Summary

**Verified Facts:**
- ✅ All committed work IS present on GitHub's `main` branch (verified via `git show origin/main`)
- ✅ README.md shows "Last Updated: 2025-11-13" on main
- ✅ Multi-agent coordination sections present on main
- ✅ Bug fixes present on main
- ✅ Specifications present on main
- ✅ PRs are being created and merged successfully (#44, #41, #39, #38, #37, #34)

**User-Reported Issues:**
1. **Cache Issue:** User viewing GitHub.com directly sees OLD content (pre-update README.md)
2. **Workflow Duplication:** GitHub Actions showing repeated runs: "one red, next white, then two green, all with the same name"
3. **Commit Duplication:** Git history shows duplicate commits (same message, one with PR#, one without)

**Need Research On:**
1. GitHub browser/CDN caching behavior and how to force refresh
2. GitHub Actions workflow duplication causes in automated PR workflows
3. Duplicate commit patterns in git history with auto-merge workflows
4. Non-technical user guidance for verifying content is actually updated

---

## Problem 1: GitHub Content Caching

### Situation

**Repository:** https://github.com/jcmrs/perplex
**File affected:** README.md (and other master documents)
**User observation:** "I am looking at Github. [...] Take a look at main branch. the README.md. This is an example of how things somehow don't end up on main."

**Technical verification:**
```bash
# Verified via git CLI:
$ git show origin/main:README.md | grep "Last Updated"
**Last Updated:** 2025-11-13

$ git show origin/main:README.md | grep -A 5 "Multi-Agent"
## 🤝 Multi-Agent Coordination (2025-11-13)
[...complete updated section...]
```

**Conclusion:** Content IS on main branch. User seeing stale cached version.

### Questions for Perplexity AI

1. **GitHub Browser Caching:**
   - What caching layers does GitHub.com use for repository content?
   - How long do GitHub file views typically cache?
   - What's the cache invalidation strategy when files are updated?
   - Can users experience stale content for hours after commits?

2. **GitHub CDN/Edge Caching:**
   - Does GitHub use CDN/edge caching for repository files?
   - How does this affect file content delivery?
   - What's the propagation delay for content updates?
   - Are there geographic differences in cache invalidation?

3. **Hard Refresh Methods:**
   - What browser operations force GitHub cache refresh?
   - Does Ctrl+F5 / Cmd+Shift+R work on GitHub?
   - Do URL parameters force cache bypass?
   - Does switching branches and back clear cache?

4. **Verification Without CLI:**
   - How can non-technical user verify content is actually updated?
   - Alternative GitHub UI locations that might show fresh content?
   - GitHub API endpoints that bypass cache?
   - Mobile app vs web - different cache behavior?

5. **Known Issues:**
   - Are there documented GitHub caching bugs?
   - Have other users reported similar issues?
   - GitHub status page mentions of cache problems?
   - Community reports of stale content visibility?

---

## Problem 2: GitHub Actions Workflow Duplication

### Situation

**User observation:** "AGAIN I see those weird repeating github actions duplicates, one red, next white, then two green, all with the same name"

**LIVE EXAMPLE (2025-11-13):**
When PR #45 was manually merged, 4 workflows triggered simultaneously:

1. ⚪ **Cleanup Checkpoint Branches** - https://github.com/jcmrs/perplex/actions/runs/19331050479
   - Status: Success (white icon)
   - Trigger: `pull_request` closed event
   - Duration: 1s

2. ✅ **Foundation Validation** - https://github.com/jcmrs/perplex/actions/runs/19331050467
   - Status: Success (green icon)
   - Trigger: `push` to main (commit 657ed22)
   - Duration: 9s

3. ✅ **Tests** - https://github.com/jcmrs/perplex/actions/runs/19331050458
   - Status: Success (green icon)
   - Trigger: `push` to main (commit 657ed22)
   - Duration: 32s

4. ❌ **Workspace Validation** - https://github.com/jcmrs/perplex/actions/runs/19331050144
   - Status: Failed (red icon)
   - Trigger: `push` to main (commit 657ed22)
   - Duration: Unknown (failure)

**All workflows:**
- Triggered within same minute
- All show same commit message: "Create comprehensive Perplexity research prompt: GitHub cache and workflow duplication"
- Pattern: white, green, green, red
- User sees duplicate workflow runs with different statuses

**Workflow architecture:**
- `.github/workflows/auto-create-pr-claude-branches.yml` - Creates PR on push to `claude/*`
- `.github/workflows/auto-merge-claude-branches.yml` - Validates and merges PR
- `.github/workflows/checkpoint-automation.yml` - Creates checkpoint after merge
- `.github/workflows/cleanup-checkpoint-branches.yml` - Deletes merged branches
- Multiple validation workflows (foundation, completeness, tests, workspace)

**Trigger pattern:**
```yaml
on:
  push:
    branches:
      - 'claude/*'
  pull_request:
    types: [opened, synchronize]
```

**Single merge event triggered 4 workflows** - This is the duplication pattern.

**Observed git history pattern:**
```
657ed22 Create comprehensive Perplexity research prompt [...] (#45)  ← Just merged
ddc7653 Create revised Perplexity research prompt [...] (#44)        ← Previous PR
e589ce7 Merge Add repository sync step to CLI prompt                ← Merge commit
db8a93e Create Perplexity research prompt [...]                     ← Direct commit
cdc6746 Add repository sync step to CLI prompt                      ← Original commit
```

### Questions for Perplexity AI

1. **Workflow Cascade Triggers:**
   - Can GitHub Actions workflows trigger each other in cascade?
   - When PR merges to main, which events fire?
   - Can `pull_request` and `push` triggers both fire for same merge?
   - Does auto-merge create different event sequence than manual merge?

2. **Duplicate Workflow Runs:**
   - What causes same workflow to run multiple times for one event?
   - Can workflow run on PR branch and main simultaneously?
   - Race conditions with rapid pushes to same branch?
   - Idempotency patterns to prevent duplicate runs?

3. **Status Indicators:**
   - What do "red, white, green" status indicators mean?
   - Why would workflow appear multiple times in UI?
   - Does re-run create separate workflow entry?
   - Workflow vs job vs step - what's shown in UI?

4. **Auto-Create + Auto-Merge Interaction:**
   - When auto-create-pr creates PR, what events fire?
   - When auto-merge merges PR, what events fire?
   - Can these trigger each other recursively?
   - Best practices for preventing workflow loops?

5. **Commit Duplication in History:**
   - Why do some commits appear twice (with and without PR#)?
   - Is this normal with auto-merge workflows?
   - How does GitHub handle PR merge vs direct push?
   - Does this indicate automation malfunction?

---

## Problem 3: Multi-Workflow Coordination

### Current Workflow Ecosystem

**Automation workflows (10 total):**
1. `auto-create-pr-claude-branches.yml` - Creates PR on push to `claude/*`
2. `auto-merge-claude-branches.yml` - Validates and merges PR automatically
3. `checkpoint-automation.yml` - Creates checkpoint after merge
4. `workspace-validation.yml` - Validates workspace boundaries
5. `tests.yml` - Runs shellcheck, yamllint, bats
6. `foundation-validation.yml` - Validates foundation structure
7. `completeness-review.yml` - Checks completeness on PR
8. `checkpoint-info-on-pr.yml` - Posts checkpoint context on PR
9. `cleanup-checkpoint-branches.yml` - Deletes merged checkpoint branches
10. `scheduled-completeness.yml` - Weekly health checks

**Trigger complexity:**
- Some trigger on `push` to `claude/*`
- Some trigger on `pull_request` events
- Some trigger on PR merge (push to main)
- Some trigger on PR close
- Cascading effects across multiple workflows

### Questions for Perplexity AI

1. **Workflow Orchestration:**
   - Best practices for orchestrating multiple GitHub Actions workflows?
   - How to prevent trigger storms (one action triggering many others)?
   - Should workflows be consolidated or remain separate?
   - Dependency management between workflows?

2. **Event Filtering:**
   - How to filter events to prevent unnecessary workflow runs?
   - Can workflows detect "already handled" situations?
   - Using workflow run IDs to prevent duplicates?
   - Conditional execution based on other workflow status?

3. **State Management:**
   - How to share state between workflows?
   - Using artifacts for workflow coordination?
   - GitHub environment variables across workflows?
   - Detecting if another workflow is already running?

4. **Debugging Tools:**
   - How to trace workflow trigger chains?
   - Visualizing workflow dependencies?
   - GitHub Actions logs for duplicate detection?
   - Tools for workflow performance analysis?

5. **AI-First Automation Patterns:**
   - Examples of AI-agent-driven repositories with heavy automation?
   - How do projects like AutoGPT handle workflow automation?
   - Best practices for autonomous AI agent git workflows?
   - Common pitfalls in automated PR workflows?

---

## Problem 4: Non-Technical User Perspective

### User Experience Challenge

**User profile:** Non-technical, relies on GitHub UI (not git CLI)
**User workflow:**
1. AI agent reports "X is done"
2. User checks GitHub.com to verify
3. User sees OLD content (cache issue)
4. User concludes work didn't happen
5. User loses trust in automation

**User quote:** "when you told me X is done. It never materialised on main branch."

### Questions for Perplexity AI

1. **Verification Without Technical Knowledge:**
   - How can non-technical user confirm git commit actually happened?
   - GitHub UI features for verifying recent changes?
   - GitHub commit history vs file view - which is more reliable?
   - Using GitHub's "History" button to verify updates?

2. **Communication Patterns:**
   - How should AI agent communicate completion to non-technical user?
   - Should AI provide GitHub URLs to specific commits?
   - Should AI include screenshots or verification steps?
   - Best practices for AI-human handoff validation?

3. **GitHub UI Literacy:**
   - Essential GitHub UI concepts for non-technical users?
   - Understanding commits, branches, PRs without git knowledge?
   - Interpreting GitHub Actions status icons?
   - Finding recent changes in repository?

4. **Trust Restoration:**
   - How to rebuild trust when automation works but appears broken?
   - Demonstrating "it's a cache issue, not a real issue"?
   - Educational resources for GitHub caching behavior?
   - Setting expectations for content propagation delays?

---

## Technical Context

### Repository Setup

**Branch strategy:**
- `main` - Protected, requires PRs
- `claude/*` - AI agent feature branches (automated PR creation)
- No direct pushes to main (enforced)

**Automation philosophy:**
- AI-First: AI agents are primary contributors
- Autonomous: Minimal human intervention
- Enforced: Pre-commit hooks, GitHub Actions validation
- "Enforce, don't document" - Automation prevents mistakes

**Multi-agent coordination:**
- **Web (Designer-Researcher):** Browser-based Claude Code, creates specs/docs
- **CLI (Executor-Validator):** Local Claude Code, implements code
- Both use same git repository, different branches
- Workspace boundaries enforced via pre-commit hooks and GitHub Actions

### Auto-Create PR Workflow Logic

```yaml
# Simplified from .github/workflows/auto-create-pr-claude-branches.yml
on:
  push:
    branches: ['claude/*']

jobs:
  create-pr:
    steps:
      - name: Check if PR already exists (idempotency)
        # Query GitHub API for existing PR

      - name: Create PR via GitHub REST API
        if: no existing PR
        # POST to /repos/:owner/:repo/pulls

      - name: Skip if PR exists
        # Idempotency check passed
```

**Idempotency:** Workflow checks if PR exists before creating. Should prevent duplicates.

### Auto-Merge Workflow Logic

```yaml
# Simplified from .github/workflows/auto-merge-claude-branches.yml
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  validate:
    steps:
      - Run foundation validation
      - Run tests
      - Run completeness review

  auto-merge:
    needs: validate
    if: validation passed
    steps:
      - Merge PR using GitHub REST API
      - Delete branch
```

**Safety:** Multiple validation steps before merge. Should only merge if all checks pass.

---

## Research Priorities

### Priority 1: Cache Issue Resolution (HIGH)

**Need:**
- Clear explanation of GitHub caching behavior
- Specific steps for non-technical user to force refresh
- Expected timeline for cache invalidation
- Alternative verification methods

**Why critical:** Breaks user trust in automation when work appears invisible.

### Priority 2: Workflow Duplication Diagnosis (HIGH)

**Need:**
- Root cause of "red, white, two green" pattern
- Whether this indicates real problem or cosmetic UI issue
- Specific configuration changes to prevent duplicates
- Whether duplicate runs waste resources or cause conflicts

**Why critical:** Indicates potential automation malfunction, resource waste, or UI confusion.

### Priority 3: Commit Duplication Pattern (MEDIUM)

**Need:**
- Explanation of why commits appear twice in history
- Whether this is normal with auto-merge workflows
- Impact on git history cleanliness
- Whether this should be fixed or accepted

**Why important:** Affects repository maintainability and understanding of history.

### Priority 4: AI-First Automation Best Practices (MEDIUM)

**Need:**
- Industry examples of AI-agent-driven repositories
- Proven patterns for autonomous git workflows
- Common pitfalls and how to avoid them
- Workflow orchestration strategies

**Why important:** Learning from established patterns prevents reinventing wheel.

---

## Desired Outcomes

### For User (Non-Technical)

1. **Understand cache issue:**
   - Why they saw old content when new content exists
   - How to force refresh and verify updates
   - What to expect for propagation delays
   - How to trust automation despite cache

2. **Verification workflow:**
   - Simple steps to confirm work is complete
   - GitHub UI features to check recent changes
   - Understanding GitHub Actions status
   - When to worry vs when to wait

### For AI Agent (Technical)

1. **Fix workflow duplication:**
   - Identify root cause of repeated runs
   - Implement fix (configuration or code changes)
   - Verify fix resolves issue
   - Prevent future occurrences

2. **Improve automation:**
   - Consolidate workflows if needed
   - Better event filtering
   - Idempotency at all levels
   - State management between workflows

3. **Communication:**
   - How to report completion to non-technical user
   - Include verification steps in completion message
   - Set expectations for visibility delays
   - Provide direct GitHub URLs to changes

---

## Research Output Format

Please structure research as:

### 1. GitHub Caching Behavior
- Technical explanation
- Cache layers (browser, CDN, GitHub)
- Invalidation timelines
- Geographic variations
- Known issues

### 2. Cache Refresh Methods
- Browser hard refresh (does it work?)
- GitHub-specific refresh techniques
- URL parameters or API endpoints
- Verification without refresh

### 3. Non-Technical User Guide
- Step-by-step: "How to verify content is updated"
- Using GitHub UI features
- Interpreting status indicators
- When to escalate vs wait

### 4. Workflow Duplication Causes
- GitHub Actions trigger cascade
- Auto-create + auto-merge interaction
- Event sequences on PR merge
- Idempotency gaps

### 5. Workflow Duplication Solutions
- Configuration changes
- Event filtering improvements
- State management patterns
- Consolidation opportunities

### 6. Commit Duplication Explanation
- Why commits appear twice
- Normal behavior vs bug
- Impact on repository
- Accept or fix

### 7. AI-First Automation Examples
- Real-world repositories
- Proven workflow patterns
- Common pitfalls
- Best practices

### 8. Specific Recommendations
- For cache issue (user-facing)
- For workflow duplication (technical)
- For commit duplication (technical)
- For communication improvement (both)

---

## Success Criteria

Research is successful if it provides:

1. ✅ **Actionable solution for cache issue** - User can verify content immediately
2. ✅ **Root cause of workflow duplication** - Can diagnose and fix
3. ✅ **Non-technical user guidance** - Clear steps without CLI
4. ✅ **Automation improvements** - Specific changes to prevent issues
5. ✅ **Industry validation** - Confirm patterns align with best practices

---

## Additional Context

### Similar Issues Reported?

Search for:
- "GitHub shows old file content after update"
- "GitHub Actions workflow runs multiple times"
- "Duplicate commits with automated PR merge"
- "AI agent automated git workflows"
- "GitHub cache invalidation delay"

### Relevant GitHub Documentation

Research should reference:
- GitHub Actions workflow triggers documentation
- GitHub caching behavior (if documented)
- GitHub REST API rate limits and behavior
- Branch protection rules interaction with Actions

### Community Resources

Check:
- GitHub Community discussions
- Stack Overflow questions
- GitHub Actions marketplace examples
- AI-first project repositories (AutoGPT, etc.)

---

**Prepared by:** Claude Code Web (Designer-Researcher)
**For Research by:** Perplexity AI
**Date:** 2025-11-13
**Status:** Ready for submission
**Priority:** HIGH - Blocks user trust and automation reliability

---

## Meta-Note: Learning from Mistakes

**Previous attempts:**
1. First Perplexity prompt (544 lines) - Wrong diagnosis (assumed branch strategy issue)
2. Second Perplexity prompt (692 lines) - Wrong diagnosis (assumed local/remote sync issue)
3. **This prompt (3rd attempt)** - Correct diagnosis after verification

**Root cause of previous errors:**
- Assumed user problem without verifying technical reality
- Didn't check GitHub main branch state directly
- Jumped to conclusions based on symptoms
- Missed "user looking at GitHub.com" clarification

**This time:**
- ✅ Verified all content exists on GitHub main (git show origin/main)
- ✅ Confirmed PRs merged successfully
- ✅ Identified actual problems: cache + workflow duplication
- ✅ Focused on user experience (non-technical perspective)
- ✅ Separated confirmed facts from hypotheses

**Lesson:** Verify first, diagnose second, research third.

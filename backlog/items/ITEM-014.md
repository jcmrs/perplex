# ITEM-014: Add GitHub Actions Status Check to Completeness Review

**ID:** ITEM-014
**Priority:** Medium
**Status:** Backlog
**Date Created:** 2025-11-11
**Target Phase:** Post-Foundation Enhancement

---

## Description

The completeness review system checks local repository state (git, documentation, artifacts) but does **not** check whether GitHub Actions workflows are passing.

This gap was discovered when:
1. Completeness review passed locally ✅
2. All backlog work appeared complete ✅
3. GitHub Actions tests were failing ❌

The system should verify that CI/CD checks are passing as part of "completeness."

---

## Context

**Why was this identified?**
- User ran completeness review: passed with no issues
- User checked GitHub Actions: workflows failing
- Gap: Completeness review doesn't validate remote CI/CD state

**Discovered during:** Backlog cleanup session (2025-11-11)
- After completing ITEM-001 (Testing Infrastructure)
- Testing infrastructure complete but tests failing in CI
- Multiple commits required to fix configuration issues
- Completeness review never flagged that tests were failing

**Related to:**
- docs/COMPLETENESS_REVIEW.md - System documentation
- tools/review-completeness.sh - Implementation
- ITEM-012: Completeness Review Enhancements (completed)

---

## Acceptance Criteria

How do we know this is complete?

- [ ] Completeness review can check GitHub Actions workflow status via REST API
- [ ] Warns if latest workflow run failed
- [ ] Provides link to failing workflow run
- [ ] Works in both interactive and non-interactive mode
- [ ] Handles case where GITHUB_TOKEN not available gracefully
- [ ] Handles in_progress workflows appropriately
- [ ] Uses `jq` for JSON parsing (consistent with project patterns)
- [ ] Documented in docs/COMPLETENESS_REVIEW.md
- [ ] Added to config/completeness.yml as configurable check

---

## Priority Rationale

**Medium priority** because:
- ✅ Not blocking: Can manually check GitHub Actions
- ✅ Valuable: Catches real gaps (proven by discovery)
- ⚠️ Requires gh CLI: Not all environments have it
- ⚠️ Network dependency: Requires GitHub API access

**Not High** because:
- Manual checking is straightforward
- Only matters when pushing to GitHub
- Many developers work locally without pushing frequently

**Not Low** because:
- Proven gap that caught real issues
- CI/CD status is critical for "completeness"
- Relatively simple to implement

---

## Effort Estimate

**Estimated effort:** Small (< 1hr)

**Complexity:** Low
- Use GitHub REST API via `curl` to get latest run status
- Check conclusion field for "success" vs "failure"
- Add to review-completeness.sh as new section

**Dependencies:**
- Requires `GITHUB_TOKEN` environment variable (optional)
- Requires network access to GitHub API
- Should gracefully skip if GITHUB_TOKEN not available

**Note (2025-11-11):** Original approach using `gh CLI` is **not viable** in Claude Code environment (gh CLI blocked by security restrictions). Updated to use GitHub REST API pattern discovered during PR automation breakthrough.

---

## Proposed Approach

**UPDATED (2025-11-11):** Use GitHub REST API instead of `gh CLI` (blocked in Claude Code environment).

Add new section to `tools/review-completeness.sh`:

```bash
section "6. GitHub Actions Status"

# Check if GITHUB_TOKEN available
if [ -n "$GITHUB_TOKEN" ]; then
    # Check if we're in a git repository with remote
    REPO_URL=$(git remote get-url origin 2>/dev/null)
    if [ -n "$REPO_URL" ]; then
        # Extract owner/repo from GitHub URL
        REPO=$(echo "$REPO_URL" | sed -n 's#.*github.com[:/]\([^/]*\/[^/]*\).*#\1#p' | sed 's/\.git$//')

        if [ -n "$REPO" ]; then
            # Get latest workflow run via REST API
            RESPONSE=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
                -H "Accept: application/vnd.github+json" \
                "https://api.github.com/repos/$REPO/actions/runs?per_page=1" 2>/dev/null)

            RUN_STATUS=$(echo "$RESPONSE" | jq -r '.workflow_runs[0].conclusion // "unknown"' 2>/dev/null || echo "unknown")

            if [ "$RUN_STATUS" = "success" ]; then
                ok "Latest GitHub Actions run: SUCCESS"
            elif [ "$RUN_STATUS" = "failure" ]; then
                issue "Latest GitHub Actions run: FAILED"
                RUN_URL=$(echo "$RESPONSE" | jq -r '.workflow_runs[0].html_url // ""' 2>/dev/null)
                if [ -n "$RUN_URL" ]; then
                    info "Check: $RUN_URL"
                fi
            elif [ "$RUN_STATUS" = "in_progress" ]; then
                warning "GitHub Actions workflows currently running"
            else
                warning "Could not determine GitHub Actions status"
            fi
        else
            info "Could not parse GitHub repository from remote URL"
        fi
    else
        info "No GitHub remote configured"
    fi
else
    info "GITHUB_TOKEN not set (GitHub Actions check skipped)"
fi
```

Make configurable in `config/completeness.yml`:
```yaml
quality:
  check_github_actions: true  # Set to false to skip
```

Document in `docs/COMPLETENESS_REVIEW.md`.

**Key changes from original:**
- Uses `curl` + GitHub REST API instead of `gh CLI`
- Requires `GITHUB_TOKEN` environment variable (optional)
- Uses `jq` for JSON parsing (consistent with PR automation pattern)
- Handles in_progress status explicitly

---

## Risks & Considerations

**Risks:**
- **Dependency on GITHUB_TOKEN**: Not all environments have it set
  - Mitigation: Gracefully skip if not available
  - Note: GitHub Actions workflows have GITHUB_TOKEN by default
- **Network dependency**: Requires GitHub API access
  - Mitigation: Treat errors as "unknown" not failure
- **Rate limiting**: GitHub API rate limits
  - Mitigation: Only check latest run (1 API call), minimal impact

**Considerations:**
- Should this check current branch or main branch?
  - Latest run regardless of branch (simplest, most useful)
- Should it check ALL workflows or just latest?
  - Latest is sufficient (if any fail, latest will fail)
- What if workflows are still running?
  - Status will be "in_progress" - treat as warning (implemented in updated approach)

---

## Status Log

**2025-11-11:** Backlog - Created from gap discovered during backlog cleanup session

**2025-11-11:** Updated - Approach revised to use GitHub REST API instead of `gh CLI` (discovered during PR automation breakthrough that gh CLI is blocked in Claude Code environment)

---

## For AI Agents

When activating this backlog item:
1. Read tools/review-completeness.sh to understand structure
2. Add new section after "Quality & Validation"
3. Test with GITHUB_TOKEN set and not set
4. Test when workflows passing, failing, and in_progress
5. Update config/completeness.yml with new setting
6. Update docs/COMPLETENESS_REVIEW.md
7. Test in both interactive and non-interactive mode
8. Use GitHub REST API pattern (curl + jq) consistent with auto-create PR workflow

## For Humans

This enhancement makes the completeness review system more robust by checking remote CI/CD state, not just local repository state. It's optional (requires GITHUB_TOKEN) but valuable when available. Uses GitHub REST API pattern consistent with project's autonomous PR workflow.

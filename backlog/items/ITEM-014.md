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

- [ ] Completeness review can check GitHub Actions workflow status
- [ ] Warns if latest workflow run failed
- [ ] Provides link to failing workflow run
- [ ] Works in both interactive and non-interactive mode
- [ ] Handles case where gh CLI not available gracefully
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
- Use `gh run list --limit 1` to get latest run status
- Check conclusion field for "success" vs "failure"
- Add to review-completeness.sh as new section

**Dependencies:**
- Requires gh CLI installed (optional dependency)
- Requires network access to GitHub API
- Should gracefully skip if gh CLI not available

---

## Proposed Approach

Add new section to `tools/review-completeness.sh`:

```bash
section "6. GitHub Actions Status"

if command -v gh >/dev/null 2>&1; then
    # Check if we're in a git repository with remote
    if git remote get-url origin >/dev/null 2>&1; then
        # Get latest workflow run status
        RUN_STATUS=$(gh run list --limit 1 --json conclusion --jq '.[0].conclusion' 2>/dev/null || echo "unknown")

        if [ "$RUN_STATUS" = "success" ]; then
            ok "Latest GitHub Actions run: SUCCESS"
        elif [ "$RUN_STATUS" = "failure" ]; then
            issue "Latest GitHub Actions run: FAILED"
            RUN_URL=$(gh run list --limit 1 --json url --jq '.[0].url' 2>/dev/null)
            info "Check: $RUN_URL"
        else
            warning "Could not determine GitHub Actions status"
        fi
    else
        info "No GitHub remote configured"
    fi
else
    info "gh CLI not installed (GitHub Actions check skipped)"
fi
```

Make configurable in `config/completeness.yml`:
```yaml
quality:
  check_github_actions: true  # Set to false to skip
```

Document in `docs/COMPLETENESS_REVIEW.md`.

---

## Risks & Considerations

**Risks:**
- **Dependency on gh CLI**: Not all environments have it
  - Mitigation: Gracefully skip if not available
- **Network dependency**: Requires GitHub API access
  - Mitigation: Treat errors as "unknown" not failure
- **Rate limiting**: GitHub API rate limits
  - Mitigation: Only check latest run (1 API call)

**Considerations:**
- Should this check current branch or main branch?
  - Probably current branch (what you're working on)
- Should it check ALL workflows or just latest?
  - Latest is sufficient (if any fail, latest will fail)
- What if workflows are still running?
  - Status will be "in_progress" - treat as warning

---

## Status Log

**2025-11-11:** Backlog - Created from gap discovered during backlog cleanup session

---

## For AI Agents

When activating this backlog item:
1. Read tools/review-completeness.sh to understand structure
2. Add new section after "Quality & Validation"
3. Test with gh CLI installed and not installed
4. Test when workflows passing and failing
5. Update config/completeness.yml with new setting
6. Update docs/COMPLETENESS_REVIEW.md
7. Test in both interactive and non-interactive mode

## For Humans

This enhancement makes the completeness review system more robust by checking remote CI/CD state, not just local repository state. It's optional (requires gh CLI) but valuable when available.

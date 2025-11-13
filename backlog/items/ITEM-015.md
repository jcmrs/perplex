# ITEM-015: Simplify GitHub Actions Workflow Template Literals

**ID:** ITEM-015
**Priority:** Low
**Status:** Backlog
**Date Created:** 2025-11-13
**Target Phase:** Maintenance

---

## Description

Simplify nested JavaScript template literals in `.github/workflows/workspace-validation.yml` to improve robustness against GitHub Actions YAML parser intermittent failures.

**Current Issue:** Line 127 contains nested backticks in JavaScript template literals within YAML (`**Agent:** ${agentName} (\`${agentId}\`)`), causing intermittent YAML parsing errors on GitHub Actions platform. Lines 155-165 also have markdown code blocks with triple backticks that may contribute to parsing complexity.

**Impact:** Workflow succeeds majority of time but occasionally fails with YAML syntax errors, creating noise in Actions logs and potential confusion.

---

## Context

**Why was this identified?**
- Discovered during morning check-in (2025-11-13) after Stage 2 enforcement implementation
- GitHub Actions runs showed intermittent failures on workspace-validation.yml line 127
- Multiple runs with mixed success/failure pattern (not 100% failure = not true syntax error)
- Links:
  - Failed: https://github.com/jcmrs/perplex/actions/runs/19319114746
  - Succeeded: https://github.com/jcmrs/perplex/actions/runs/19319114957
- User requested: "Leave as is, but make a note on the backlog, low priority"

**Why intermittent?**
- If true syntax error, would fail 100% of time
- Success/failure pattern indicates GitHub Actions platform flakiness with complex nested template literals
- YAML itself is valid (proven by successful runs)

**Related to:**
- Decision: ADR-011 (Agent Workspace Coordination) - created the workflow
- File: .github/workflows/workspace-validation.yml (workspace boundary enforcement)
- Session: session-20251113-workspace-coordination-enforcement (Stage 2 implementation)

---

## Acceptance Criteria

How do we know this is complete?

- [ ] Template literals simplified in workspace-validation.yml (remove nested backticks)
- [ ] PR comment formatting still renders correctly on GitHub
- [ ] Workflow runs consistently without YAML parsing errors
- [ ] No functional regression (comments still informative)
- [ ] Similar pattern identified and fixed in other workflows (if exists)

---

## Priority Rationale

**Why Low?**
- Workflow is functional and succeeds majority of time
- PRs merge successfully despite intermittent workflow failures
- No impact on enforcement (workspace validation still works)
- No blocking issues or stalled PRs
- Cosmetic/robustness enhancement, not critical fix
- Can be addressed during routine maintenance

**User's explicit request:** "Leave as is, but make a note on the backlog, low priority"

---

## Effort Estimate

**Estimated effort:** Small (< 1hr)

**Complexity:** Low

**Dependencies:**
- None - can be done independently
- Should test in PR to verify GitHub Actions rendering

---

## Proposed Approach

1. **Simplify template literals:**
   - Replace: `**Agent:** ${agentName} (\`${agentId}\`)`
   - With: `**Agent:** ${agentName} (${agentId})` (remove backticks from inside template)
   - Or: Use concatenation instead of template literals for complex strings

2. **Alternative approach (more robust):**
   - Extract complex strings to heredoc or separate variable
   - Use `printf` or `cat <<EOF` for multi-line markdown with backticks
   - Pass to GitHub Actions as environment variable instead of inline YAML

3. **Test thoroughly:**
   - Create test PR with simplified version
   - Trigger multiple workflow runs
   - Verify comment rendering on GitHub

---

## Risks & Considerations

- **Rendering change:** Simplified formatting might look different on GitHub (verify aesthetics)
- **Over-simplification:** Don't remove intentional code formatting (bash examples need backticks)
- **Similar issues:** Check other workflows for same pattern (checkpoint-automation.yml, auto-create-pr.yml, etc.)
- **GitHub Actions quirks:** Platform may have undocumented YAML parsing behavior

---

## Status Log

**2025-11-13:** Backlog - Created from morning check-in after Stage 2 workspace coordination implementation. User requested low-priority backlog item for intermittent workflow YAML parsing issue.

---

## For AI Agents

When activating this backlog item:
1. Read `.github/workflows/workspace-validation.yml` line 127 and surrounding context
2. Examine similar workflows for nested template literal patterns
3. Test simplified version in PR first (don't push directly to main)
4. Verify GitHub PR comment rendering looks correct
5. Run workflow multiple times to confirm consistency
6. Update this item with completion information

**Key insight:** GitHub Actions YAML parser can be finicky with nested JavaScript template literals. When in doubt, simplify or use heredoc patterns.

## For Humans

This is a robustness enhancement, not a critical bug fix. The workflow is functional and enforcement is operational. Can be addressed during routine maintenance or when touching related workflows.

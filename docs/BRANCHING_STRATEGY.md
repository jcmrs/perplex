# Git Branching Strategy

**Last Updated:** 2025-11-10
**Status:** Active

---

## Philosophy

Our branching strategy reflects the project's AI-First principle:

**"Work autonomously, but make everything examinable."**

Like a trusted employee filing status reports - work continues, but the trail exists for examination if needed. **No approval gates, but full transparency.**

---

## Branch Structure

### Main Branch: `main`
**Purpose:** Stable, reviewed work
**Protection:** Yes (see protection rules below)
**Who commits:** No one directly - only via PR merge
**Represents:** Production-ready state

### Feature Branches: `claude/feature-name-SESSION_ID`
**Purpose:** Active development work
**Naming:** `claude/[description]-[SESSION_ID]`
**Who commits:** AI agent (Claude)
**Lifecycle:** Created → Worked → PR → Merged → Deleted

**Example:** `claude/perplex-initial-setup-011CUzxDPZiWB31A6DM5T2Mc`

### Other Branch Patterns (Future)
- `gemini/[description]-[SESSION_ID]` - For Gemini CLI work
- `hotfix/[description]` - Emergency fixes
- `experiment/[description]` - Throwaway experiments

---

## Workflow

### 1. Start New Work
```bash
# AI agent creates feature branch
git checkout -b claude/feature-description-SESSION_ID
```

### 2. Development
- AI works autonomously on feature branch
- Commits frequently with clear messages
- Session logs document progress
- Decisions logged as ADRs

### 3. Completion
```bash
# Finalize work
./tools/session-end.sh

# Validation runs automatically
# Commit and push
git push -u origin claude/feature-description-SESSION_ID
```

### 4. Pull Request Creation
```bash
# AI creates PR with comprehensive description
gh pr create --title "Clear, descriptive title" \
  --body "Detailed summary with:
  - What was done
  - Why it was done
  - Links to ADRs
  - Testing/validation performed
  - Traceability to requirements (if applicable)"
```

### 5. Review & Merge
- **Human reviews:** PR description, decisions, approach
- **Not reviewing:** Line-by-line code (trusts AI execution)
- **Checks must pass:** Automated validation, tests
- **Merge when:** Human approves direction

### 6. Cleanup
```bash
# After merge, delete feature branch
git branch -d claude/feature-description-SESSION_ID
git push origin --delete claude/feature-description-SESSION_ID
```

---

## Branch Protection Rules

### Main Branch Protection

**Settings:**
- ❌ **No direct commits** - Must use PR
- ✅ **Require PR review** - Human approval on direction/approach
- ✅ **Require status checks** - Automated validation must pass
- ✅ **Require linear history** - No messy merge commits
- ✅ **Require signed commits** - Verify authenticity (future)

**Rationale:**
Main branch represents stable, reviewed work. Protection ensures quality without blocking AI autonomy on feature branches.

---

## Pull Request Standards

### PR Title Format
```
[Type]: Brief description

Examples:
Foundation: Complete AI-first development infrastructure
Feature: Add Perplexity conversation capture
Fix: Resolve session continuity edge case
Docs: Update branching strategy
```

### PR Description Template
```markdown
## Summary
Brief overview of what this PR accomplishes

## Changes
- Bullet point list of significant changes
- Grouped by type (added/changed/fixed/removed)

## Decisions
- Link to relevant ADRs
- Key architectural decisions made

## Traceability
- Requirements addressed: REQ-XXX, REQ-YYY
- Vision alignment: [section of PRODUCT_VISION.md]

## Testing/Validation
- How was this validated?
- What checks were performed?
- Any manual testing needed?

## Breaking Changes
- None | List any breaking changes

## Notes
- Additional context
- Future considerations
- Known limitations
```

---

## What Gets Reviewed?

### Human Reviews (Non-Technical Focus)
- ✅ **Approach:** Does the solution make sense?
- ✅ **Decisions:** Are architectural choices sound?
- ✅ **Vision alignment:** Does this serve product goals?
- ✅ **Completeness:** Are all aspects addressed?
- ✅ **Communication:** Is PR description clear?

### Automated Reviews (Technical Focus)
- ✅ **Validation:** Foundation checks pass
- ✅ **Tests:** All tests pass (when we have them)
- ✅ **Linting:** Code follows standards
- ✅ **Build:** Project builds successfully

### What's NOT Reviewed
- ❌ **Line-by-line code** - Trusts AI implementation
- ❌ **Syntax details** - Automated tools handle this
- ❌ **Minor refactoring** - AI judgment trusted

---

## Commit Message Standards

Enforced by commit-msg git hook.

**Format:**
```
Brief summary (imperative mood, max 72 chars)

Optional detailed explanation of:
- What changed
- Why it changed
- Any relevant context

References: REQ-XXX, ADR-YYY, Issue #ZZZ
```

**Good Examples:**
```
Add ideas logging system with status workflow

Implement automated git hooks for validation enforcement

Document branching strategy for AI-autonomous development
```

**Bad Examples:**
```
updates
Fixed stuff
Added some files and changed things
```

---

## Branching Best Practices

### For AI Agents

**DO:**
- ✅ Create feature branches for all work
- ✅ Commit frequently with clear messages
- ✅ Push regularly (don't wait until "perfect")
- ✅ Create thorough PR descriptions
- ✅ Link decisions, requirements, and context
- ✅ Update session logs throughout

**DON'T:**
- ❌ Commit directly to main
- ❌ Use vague commit messages
- ❌ Create PRs without context
- ❌ Skip validation checks
- ❌ Force push to shared branches

### For Humans

**Your Role:**
- Review PR descriptions for approach alignment
- Approve when direction is sound
- Trust AI execution on implementation
- Provide strategic feedback, not syntax notes

**Not Your Role:**
- Line-by-line code review
- Syntax checking (automated)
- Micromanaging implementation details

---

## GitHub Features Integration

### Projects (Kanban)
**Future consideration:** May be overkill for AI-first development
**Current:** Milestones document provides lightweight tracking

### Actions/Workflows
**Future:** CI/CD pipeline for:
- Automated testing
- Validation runs
- Deployment (when applicable)

**Current:** Git hooks provide pre-commit validation

### Issues
**Usage:** Bug reports, feature requests from humans
**AI Integration:** AI can reference issues in commits/PRs

### Discussions
**Usage:** Design discussions, questions, RFC
**AI Integration:** AI can participate in technical discussions

---

## Branch Protection (Technical Details)

```bash
# These settings would be applied on GitHub:

Repository Settings → Branches → Branch Protection Rules → main

✅ Require a pull request before merging
  ✅ Require approvals: 1
  ✅ Dismiss stale PR approvals when new commits pushed

✅ Require status checks to pass before merging
  ✅ Require branches to be up to date before merging
  Status checks: (when CI/CD added)
    - foundation-validation
    - tests-pass

✅ Require linear history

✅ Do not allow bypassing the above settings
  (Even admins must follow rules)

⬜ Require signed commits (future consideration)
```

**Note:** Branch protection is configured on GitHub, not in local git.

---

## Special Cases

### Hotfixes (Emergency)
- Branch from main: `hotfix/description`
- Fix, test, PR to main
- After merge, cherry-pick to feature branches if needed

### Experiments
- Branch: `experiment/description`
- No PR required if experiment fails
- If successful, extract learnings to proper feature branch

### Concurrent AI Work
- Multiple AI agents can work on separate feature branches
- Coordinate through issues/discussions
- Merge conflicts resolved by most recent session

---

## Rationale & Foundation Alignment

### AI-First
- ✅ AI works autonomously on feature branches
- ✅ No approval gates in development flow
- ✅ Automation handles validation

### Holistic System Thinking
- ✅ PRs show system-wide impact
- ✅ Traceability shows relationships
- ✅ Protection prevents accidental main corruption

### Modularity
- ✅ Feature branches isolate changes
- ✅ PRs are atomic units of change

### Extensibility
- ✅ Strategy supports multiple AI agents
- ✅ Can add more branch types as needed

### Integration
- ✅ GitHub features integrated thoughtfully
- ✅ Automation through hooks and future CI/CD

### Automation
- ✅ Git hooks enforce standards
- ✅ Validation runs automatically
- ✅ Status checks will automate quality gates

---

## Questions & Clarifications

**Q: Why not trunk-based development?**
A: Feature branches provide isolation and clear PR-based review without blocking AI autonomy.

**Q: Why require PRs if human isn't reviewing code?**
A: PRs provide:
- Examinable trail of changes
- Automated validation checkpoint
- Clear merge points
- Rollback capability

**Q: Can AI merge own PRs?**
A: No. Human reviews approach/direction, then merges. This maintains strategic oversight without micromanaging.

**Q: What if something urgent needs to go to main?**
A: Use hotfix branch. Still requires PR, but human can expedite review.

---

**Philosophy Reminder:**
"Work autonomously, but make everything examinable."

PRs aren't approval gates - they're transparency mechanisms.

---

**Last Updated:** 2025-11-10
**Next Review:** After first few PRs created (validate strategy works in practice)

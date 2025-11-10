# GitHub Integration Files

This directory contains GitHub-specific configuration and automation.

## Structure

```
.github/
├── workflows/              # GitHub Actions workflows
│   └── foundation-validation.yml  # PR validation
├── ISSUE_TEMPLATE/        # Issue templates
├── pull_request_template.md  # PR template
├── CODEOWNERS             # Code ownership rules
└── README.md              # This file
```

## GitHub Actions Workflows

### foundation-validation.yml
**Triggers:** Pull requests to main, pushes to main
**Purpose:** Validates foundation alignment on every PR
**Checks:**
- Runs `tools/validate-foundation.sh`
- Ensures no uncommitted changes
- Blocks PR merge if validation fails

**Why:** Replicates local pre-commit hooks on GitHub's side. Local hooks only run on individual machines - GitHub Actions ensures validation happens on all PRs regardless of local setup.

## Templates

### Pull Request Template
Provides structured format for PR descriptions including:
- Summary of changes
- Links to ADRs
- Traceability to requirements/vision
- Validation performed

### Issue Templates
Structured formats for:
- Bug reports
- Feature requests
- Questions
- Other issue types

## Code Ownership

`CODEOWNERS` file defines who reviews changes to specific files/directories.

## For AI Agents

GitHub Actions workflows run automatically - you don't trigger them manually. When you create a PR, GitHub runs these checks.

If validation fails:
1. Review the GitHub Actions log
2. Fix the issues locally
3. Commit fixes
4. Push to PR branch
5. GitHub re-runs validation automatically

## For Humans

GitHub Actions provide automated quality gates. PRs can't merge until checks pass, ensuring foundation standards are maintained automatically.

---

**Note:** GitHub Actions workflows are configured here but execute on GitHub's infrastructure, not locally.

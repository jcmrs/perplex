# GitHub Checkpoint Automation

This document explains how checkpoint automation works on GitHub and how to use it effectively.

## Overview

Project Perplex uses automated checkpoints to maintain continuity across sessions and PRs. Checkpoints are created both automatically and manually through GitHub Actions workflows.

## How It Works

### 1. Automatic Checkpoints (PR Merge)

When a PR is merged to `main`, a checkpoint is **automatically created** with:
- **Description:** "PR #123 merged"
- **Summary:** The PR title and number
- **Phase:** Current phase from `config/project.yml`
- **Focus:** "Continue with next PR or task in backlog"
- **Critical files:** Default set (FOUNDATION.md, PRODUCT_VISION.md)

**Workflow:** `.github/workflows/checkpoint-automation.yml`

**What happens:**
1. PR merges to main
2. GitHub Actions triggers checkpoint creation
3. Checkpoint files are created and committed
4. A comment is posted on the PR with checkpoint info

### 2. Manual Checkpoints (Workflow Dispatch)

For **major milestones** (phase transitions, releases, significant completion), create a checkpoint manually:

**Steps:**
1. Go to **Actions** tab in GitHub
2. Select **"Checkpoint Automation"** workflow
3. Click **"Run workflow"**
4. Fill in the inputs:
   - **Description:** e.g., "Discovery Phase Complete"
   - **Phase:** Current phase (foundation, discovery, implementation, etc.)
   - **Next Phase:** Where you're heading
   - **Summary:** 30-second summary of what was accomplished
   - **Focus:** What the next session should prioritize
   - **Critical Files:** (optional) Custom critical files in format: `path:reason,path:reason`
   - **Skip Patterns:** (optional) What to skip when loading
   - **Create Release:** Check if you want a GitHub release created

5. Click **"Run workflow"**

**What happens:**
1. GitHub Actions runs the checkpoint script in non-interactive mode
2. Checkpoint files are created with your custom inputs
3. Files are committed and pushed to main
4. (Optional) GitHub Release is created with checkpoint details

### 3. Checkpoint Info on New PRs

When a PR is **opened or reopened**, a bot comment is automatically posted with:
- Latest checkpoint description and phase
- Quick summary from the checkpoint
- Critical files to review
- Instructions on how to resume from checkpoint

**Workflow:** `.github/workflows/checkpoint-info-on-pr.yml`

**Purpose:** Help contributors (AI agents or humans) quickly get context before starting work.

## When to Create Manual Checkpoints

Use manual checkpoint creation for:

- ✅ **Phase transitions** (foundation → discovery, discovery → implementation)
- ✅ **Major milestones** (MVP complete, v1.0 release, feature X shipped)
- ✅ **Significant architectural changes** (new system added, major refactor)
- ✅ **Before long breaks** (team going on leave, project pause)
- ✅ **After complex work** (multi-PR feature completion)

Don't create manual checkpoints for:

- ❌ **Small incremental changes** (automatic PR merge checkpoints are sufficient)
- ❌ **Every PR** (would create too many checkpoints)
- ❌ **Work in progress** (wait until completion)

## Checkpoint Files

All checkpoints are stored in the `checkpoints/` directory:

```
checkpoints/
├── README.md                                              # System documentation
├── TEMPLATE.md                                            # Template for new checkpoints
├── SCHEMA.json                                            # Memory graph JSON schema
├── GITHUB_AUTOMATION.md                                   # This file
├── checkpoint-YYYYMMDD-HHMMSS-description.md             # Checkpoint markdown
├── checkpoint-YYYYMMDD-HHMMSS-description-graph.json     # Memory graph JSON
├── LATEST.md -> checkpoint-YYYYMMDD-HHMMSS-description.md             # Symlink to latest
└── LATEST-graph.json -> checkpoint-YYYYMMDD-HHMMSS-description-graph.json
```

The `LATEST.md` and `LATEST-graph.json` symlinks always point to the most recent checkpoint.

## Environment Variables (for CI/CD)

The checkpoint creation script supports non-interactive mode via environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `CHECKPOINT_NON_INTERACTIVE` | Set to `true` to enable non-interactive mode | Yes (for CI) |
| `CHECKPOINT_DESCRIPTION` | Checkpoint description | Yes |
| `CHECKPOINT_PHASE` | Current project phase | No (defaults to config) |
| `CHECKPOINT_NEXT_PHASE` | Next project phase | No (defaults to "discovery") |
| `CHECKPOINT_SUMMARY` | 30-second summary | Yes |
| `CHECKPOINT_FOCUS` | Primary focus for next session | Yes |
| `CHECKPOINT_CRITICAL_FILES` | Format: `path:reason,path:reason` | No (uses defaults) |
| `CHECKPOINT_SKIP_PATTERNS` | Comma-separated patterns | No (uses defaults) |
| `CHECKPOINT_TRIGGER` | What triggered creation | No (defaults to "Manual") |
| `CHECKPOINT_CREATED_BY` | Who/what created it | No (defaults to current user) |

## Integration with PR Template

The PR template includes a **Checkpoint Context** section where contributors should:

1. Review the latest checkpoint (from bot comment)
2. Indicate whether a checkpoint is needed after merge:
   - **No checkpoint:** Incremental change, automatic PR checkpoint is fine
   - **Minor checkpoint:** Automatic PR checkpoint is sufficient
   - **Major checkpoint:** Needs manual workflow run with custom inputs

3. If major checkpoint needed, provide guidance:
   - Phase transition details
   - Milestone information
   - Summary for checkpoint creation

## Resuming from Checkpoints

**Local development:**
```bash
./tools/resume-from-checkpoint.sh
```

**GitHub context:**
- Check the bot comment on your PR
- Read `checkpoints/LATEST.md` directly
- Review the memory graph: `checkpoints/LATEST-graph.json`

## Token Efficiency

Checkpoints are designed for token efficiency:

- **Skip patterns** help avoid reading templates, old logs, examples
- **Memory graph** provides relationship mapping without re-reading everything
- **Just-in-time loading** - read critical files first, expand only if needed
- **Typical savings:** 6,000-8,000 tokens by skipping non-critical files

## Best Practices

### For AI Agents

1. **Always check for latest checkpoint** when starting a new PR or session
2. **Read checkpoint FIRST** before exploring codebase
3. **Follow the critical files list** - read in priority order
4. **Consult memory graph** to understand relationships before reading related files
5. **Skip what checkpoint says to skip** - trust the token efficiency guidance

### For Human Contributors

1. **Review checkpoint on PR open** to understand current project state
2. **Recommend checkpoint type** in PR template (none/minor/major)
3. **Provide checkpoint inputs** if major checkpoint is needed
4. **Update checkpoints after milestones** - don't forget to run the workflow

### For Project Maintainers

1. **Review automatic checkpoints** periodically - are they useful?
2. **Create manual checkpoints** at phase transitions
3. **Update critical files** in checkpoints when project structure changes
4. **Prune old checkpoints** if repository gets too large (keep major milestones)

## Troubleshooting

### Checkpoint workflow failed

Check the Actions tab for error logs. Common issues:
- Missing required environment variables
- Git push conflicts (rare, but possible)
- Script execution errors

### Checkpoint not created after PR merge

Verify:
- PR was merged to `main` (not closed without merge)
- Workflow has write permissions to repository
- No workflow failures in Actions tab

### Bot comment not appearing on PR

Check:
- Workflow has `pull-requests: write` permission
- `checkpoints/LATEST.md` exists in the repository
- No workflow failures in Actions tab

## Advanced Usage

### Custom Critical Files

When creating manual checkpoint, specify custom critical files:

```
FOUNDATION.md:Core principles,docs/API_DESIGN.md:API contract,src/core/engine.ts:Main engine implementation
```

### Custom Skip Patterns

Optimize token usage by skipping specific paths:

```
*/TEMPLATE.md,sessions/session-*.md,examples/*,tests/fixtures/*,docs/archive/*
```

### Creating Releases

Check "Create GitHub release" when running manual workflow for:
- Major version releases (v1.0, v2.0)
- Public milestones (beta release, launch)
- Archival checkpoints (end of phase, project completion)

Releases make checkpoints discoverable in GitHub's Releases tab and provide a permanent URL.

---

## Related Documentation

- [Checkpoint System README](README.md) - Core checkpoint concepts
- [Checkpoint Template](TEMPLATE.md) - Manual checkpoint template
- [Memory Graph Schema](SCHEMA.json) - JSON schema for memory graphs
- [Foundation Validation](.github/workflows/foundation-validation.yml) - Other GitHub automation

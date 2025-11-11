# Completeness Review System

**Purpose:** Systematic check for gaps, missing artifacts, and incomplete work before considering a task "done".

## The Problem

During foundation development, we encountered a pattern: **gaps found at every corner**.

1. Initial foundation → looked complete
2. User review → enforcement, traceability, continuity gaps found
3. Checkpoint system → looked complete
4. User review → GitHub automation gap found
5. Pattern recognition → completeness checking itself was missing

**Solution:** Automated completeness review that asks "did you forget anything?" and checks systematically.

## Inspiration

This system is inspired by the [Serena MCP Server](https://github.com/oraios/serena)'s "did you forget anything" feature - a structured reflection prompt that triggers systematic review against project artifacts and protocols.

## What It Checks

The completeness review examines six critical areas:

### 1. Git State
- ✅ Working directory clean (no uncommitted changes)
- ✅ No untracked files (or intentionally gitignored)
- ✅ All commits pushed to remote
- ✅ Branch tracking correctly

### 2. Documentation & Traceability
- ✅ Session logs updated
- ✅ CURRENT_STATUS.md reflects reality
- ✅ ADRs created for significant decisions
- ✅ Traceability links complete (Vision → Requirements → Decisions → Implementation)

### 3. Foundation Artifacts
- ✅ Ideas logged for future exploration
- ✅ Backlog updated (items added, removed, or status changed)
- ✅ Checkpoint created if phase transition or milestone
- ✅ Templates remain unused (work products created from them)

### 4. Quality & Validation
- ✅ Foundation validation passing
- ✅ Tests added/updated (when infrastructure exists)
- ✅ Breaking changes documented with migration path
- ✅ Manual validation performed

### 5. Session Completeness
- ✅ All todos completed or explicitly deferred
- ✅ Questions answered or filed to backlog
- ✅ Next actions clear for resuming work
- ✅ No open blockers without mitigation plan

### 6. Master Document Currency **(NEW - 2025-11-11)**
- ✅ README.md updated recently (warns if >7 days old with significant commits)
- ✅ Other entry-point documents current (CONTRIBUTING.md, etc.)
- ✅ "Last Updated" dates present and accurate
- ✅ Master documents reflect recent achievements and current state

**Why this matters:** Master documents (README, CONTRIBUTING) are entry points for ALL users—AI agents, humans, new contributors. Outdated entry points create false first impressions and undermine trust in documentation. This check ensures the universal entry point stays current.

## When to Use

### Always Use When:
- ✅ Ending a session (via `./tools/session-end.sh`)
- ✅ Before creating a PR
- ✅ After completing a major task
- ✅ Before marking a milestone complete
- ✅ When you think you're "done" with something

### Optionally Use When:
- During work to catch gaps early
- When feeling uncertain about completeness
- After interruptions/context switches

### Don't Use When:
- Work is genuinely incomplete (WIP)
- In the middle of active development
- Just starting a task

## How to Use

### Manual Run

```bash
# Interactive mode (prompts questions)
./tools/review-completeness.sh

# Non-interactive mode (just reports)
COMPLETENESS_NON_INTERACTIVE=true ./tools/review-completeness.sh
```

### Integrated with Session End

```bash
./tools/session-end.sh
# Prompts: "Run completeness review? (y/n)"
```

### Exit Codes

- `0` - No issues found (or only warnings)
- `1` - Critical issues found

## Configuration

The completeness review system is now configurable via `config/completeness.yml`.

### Configurable Options

**Thresholds:**
- Session log age before warning (default: 120 minutes)
- CURRENT_STATUS.md age before warning (default: 120 minutes)
- Checkpoint age before suggesting new one (default: 240 minutes)
- Maximum uncommitted files (default: 0)
- Maximum untracked files (default: 3)

**Enabled Checks:**
- Enable/disable entire check categories
- Toggle specific checks within categories
- Add custom project-specific checks

**Interactive Mode:**
- Configure which prompts to show
- Customize prompt questions and help text
- Enable hybrid mode (auto-check basics, prompt for subjective)

**Scheduled Runs:**
- Weekly health checks via GitHub Actions
- Automatic issue creation for recurring problems
- Customizable schedule and labels

**Reporting:**
- Generate reports in text/JSON/HTML format
- Include/exclude passing checks
- Save reports to configurable directory

See `config/completeness.yml` for all options and documentation.

### Customizing Thresholds

Edit `config/completeness.yml`:

```yaml
thresholds:
  session_log_max_age: 240  # 4 hours instead of 2
  checkpoint_max_age: 480   # 8 hours instead of 4
```

### Disabling Specific Checks

```yaml
enabled_checks:
  git_state: true
  documentation: true
  foundation_artifacts: false  # Disable this category
  quality: true
  session_completeness: true
```

## Scheduled Health Checks

The system runs automated weekly health checks via GitHub Actions.

**Schedule:** Every Monday at 9am UTC (configurable in `config/completeness.yml`)

**What it does:**
1. Runs completeness review in non-interactive mode
2. Analyzes repository state across all checks
3. Creates GitHub issue if problems found
4. Uploads report as workflow artifact

**Issue Creation:**
- Automatic when exit code != 0
- Includes full completeness output
- Tagged with `automated`, `completeness-check`, `health`
- Contains actionable next steps

**Workflow:** `.github/workflows/scheduled-completeness.yml`

### Manual Trigger

You can manually trigger the scheduled check:

```bash
# Via GitHub UI: Actions → Scheduled Completeness Check → Run workflow

# Or via gh CLI:
gh workflow run scheduled-completeness.yml
```

## Reporting

Generate completeness reports for record-keeping or analysis.

### Enable Reporting

Edit `config/completeness.yml`:

```yaml
reporting:
  generate_report: true
  report_dir: "reports/completeness"
  report_format: "text"  # or "json", "html"
  include_passing: false  # Only show issues/warnings
```

### Report Formats

**Text:** Human-readable, plain text
```
=== Completeness Review Report ===
Date: 2025-11-11
Status: PASSED (2 warnings)

Warnings:
- Session log updated 90 minutes ago
- No checkpoint in last 5 hours
```

**JSON:** Machine-readable for automation
```json
{
  "date": "2025-11-11",
  "status": "passed",
  "warnings": 2,
  "issues": 0,
  "checks": [...]
}
```

**HTML:** Web-viewable dashboard (future enhancement)

## Hybrid Mode

Hybrid mode balances automation with human insight.

**How it works:**
1. Automated checks run first (git state, file existence, etc.)
2. Only prompt for subjective questions (decisions, ideas, etc.)
3. Configurable which prompts to enable

**Enable/Configure:**

```yaml
interactive:
  enable_prompts: true  # Enable hybrid mode

  prompts:
    - id: "significant_decisions"
      question: "Were significant technical decisions made?"
      help: "ADRs should be created for architectural decisions"
      # Add enabled: false to skip this prompt
```

**Benefits:**
- Faster completion (skip obvious automated checks)
- Focus human attention on judgment calls
- Maintain thoroughness without tedium

## Understanding Results

### ✅ OK - No action needed
Everything is complete and correct.

### ⚠️ Warning - Review recommended
Not a blocker, but worth considering. Examples:
- Uncommitted changes (might be intentional during WIP)
- Checkpoint is a few hours old (might not need new one)
- Session log updated 30 minutes ago (probably fine)

### ❌ Issue - Action required
Something important is missing. Examples:
- CURRENT_STATUS.md doesn't exist
- Foundation validation failing
- Breaking changes undocumented

### ℹ️ Info - Contextual information
Non-judgmental data for your awareness.

## What "Complete" Means

Completeness criteria vary by work type:

### Bug Fix
- [ ] Root cause identified and documented
- [ ] Fix implemented and tested
- [ ] No breaking changes (or documented with migration)
- [ ] Session log updated with debugging process
- [ ] Related tests added/updated (when infrastructure exists)
- [ ] Git clean, changes committed and pushed

### New Feature
- [ ] ADR created documenting design decisions
- [ ] Implementation matches ADR
- [ ] Documentation updated (README, guides)
- [ ] Traceability: links to vision, requirements
- [ ] Ideas logged for future enhancements
- [ ] Session log documents implementation journey
- [ ] Checkpoint created (if milestone)
- [ ] Git clean, changes committed and pushed

### Refactoring
- [ ] ADR explains why and what changed
- [ ] No behavior changes (or documented if intentional)
- [ ] Tests still passing
- [ ] Documentation updated if public API changed
- [ ] Breaking changes documented (if any)
- [ ] Session log captures refactoring rationale
- [ ] Git clean, changes committed and pushed

### Documentation Work
- [ ] All sections complete (no TODOs or placeholders)
- [ ] Links validated (no 404s)
- [ ] Examples tested and working
- [ ] Spelling/grammar checked
- [ ] Traceability: linked from relevant places
- [ ] Git clean, changes committed and pushed

### Exploration/Research
- [ ] Findings documented in session log
- [ ] Ideas logged for promising directions
- [ ] Backlog updated with identified work
- [ ] ADR created if decisions made
- [ ] Next steps clear (continue exploration or move to implementation)
- [ ] Git clean (research notes committed)

### Foundation/Infrastructure
- [ ] System validated and working
- [ ] Documentation complete with examples
- [ ] Integration points tested
- [ ] ADR documents architectural decisions
- [ ] Automation tested (if applicable)
- [ ] Checkpoint created (infrastructure is milestone-worthy)
- [ ] Git clean, changes committed and pushed

## Interpreting Interactive Prompts

The completeness review asks questions when it can't determine answers automatically:

### "Were significant technical decisions made?"
- **Yes** → Create ADR documenting rationale, alternatives, consequences
- **No** → Proceed (implementation details don't need ADR)

### "Did you encounter ideas for future exploration?"
- **Yes** → Log in `ideas/` so they're not forgotten
- **No** → Proceed

### "Did you identify work for later (backlog items)?"
- **Yes** → Add to `backlog/BACKLOG.md` or create item
- **No** → Proceed

### "Is this a phase transition or major milestone?"
- **Yes** → Create checkpoint to preserve state
- **No** → Incremental work doesn't need checkpoint

### "Are breaking changes documented with migration path?"
- **Yes** → Proceed (documentation exists)
- **No** → Document: what breaks, how to migrate, why necessary

### "Are there unanswered questions or blockers?"
- **Yes** → Document in session log or create backlog item
- **No** → Proceed

### "Are next actions clear for resuming work?"
- **Yes** → Future sessions will know where to start
- **No** → Update CURRENT_STATUS.md or create checkpoint with next steps

### "Are all todos completed or explicitly deferred?"
- **Yes** → Work is truly complete
- **No** → Complete todos or document why deferred

## Integration Points

The completeness review integrates with:

1. **Session End Protocol** (`tools/session-end.sh`)
   - Prompted automatically when ending session
   - Can block session end if critical issues found

2. **Git Hooks** (future)
   - Pre-push hook could warn about completeness
   - Doesn't block (unlike pre-commit validation)

3. **GitHub Actions** (future)
   - PR comment with completeness checklist
   - Auto-detect missing artifacts from PR diff

4. **Checkpoints**
   - Completeness check before creating checkpoint
   - Ensures checkpoint captures complete state

## Best Practices

### For AI Agents

1. **Run at natural stopping points** - End of task, before context switch
2. **Treat warnings seriously** - They often reveal genuine gaps
3. **Answer prompts honestly** - Don't skip to green checkmarks
4. **Use non-interactive mode in CI** - Set `COMPLETENESS_NON_INTERACTIVE=true`
5. **Integrate with checkpoint workflow** - Check completeness before checkpoint creation

### For Human Contributors

1. **Run before opening PR** - Catch gaps before review
2. **Don't ignore warnings** - At minimum, understand why they appear
3. **Update the script** - Add checks for project-specific completeness criteria
4. **Share patterns** - If you find gaps repeatedly, automate the check

### For Project Maintainers

1. **Enforce on milestones** - Require completeness check passing before phase transitions
2. **Review false positives** - Tune checks to reduce noise
3. **Customize for project** - Add domain-specific completeness criteria
4. **Document "done" definitions** - Clarify what complete means for your project

## Common Gaps Found

Based on foundation development, common gaps include:

1. **GitHub automation missing** - Local scripts without CI/CD equivalent
2. **Documentation outdated** - Code changed but docs didn't
3. **ADRs missing** - Decisions made but not documented
4. **Traceability broken** - Implementation doesn't link back to vision/requirements
5. **Ideas lost** - Good ideas during work but never logged
6. **Checkpoints forgotten** - Milestone reached but state not preserved
7. **Next actions unclear** - Work done but resuming will be difficult
8. **Todos abandoned** - Started tasks never completed or explicitly deferred

## Customization

To add project-specific checks, edit `tools/review-completeness.sh`:

```bash
# Add custom section
section "6. Custom Checks"

# Example: Check for database migrations
if [ -d "migrations" ]; then
    PENDING_MIGRATIONS=$(./manage.py migrate --check 2>&1 | grep -c "pending" || echo "0")
    if [ "$PENDING_MIGRATIONS" -eq 0 ]; then
        ok "No pending database migrations"
    else
        warning "$PENDING_MIGRATIONS pending database migration(s)"
        info "Run: ./manage.py migrate"
    fi
fi
```

## Troubleshooting

### "Too many false positives"
- **Solution:** Adjust warning thresholds in script
- **Example:** Change checkpoint age from 2 hours to 24 hours

### "Interactive prompts annoying in CI"
- **Solution:** Use non-interactive mode: `COMPLETENESS_NON_INTERACTIVE=true`

### "Missing project-specific checks"
- **Solution:** Add custom sections to script (see Customization)

### "Takes too long to run"
- **Solution:** Optimize expensive checks or make them optional

## Related Documentation

- [Session Protocols](../FOUNDATION.md#session-protocols) - When to end sessions
- [Foundation Validation](../tools/validate-foundation.sh) - Structural validation
- [Checkpoint System](../checkpoints/README.md) - State preservation
- [ADR Process](../decisions/README.md) - Decision documentation

---

**Remember:** The goal isn't perfect completeness on every commit. It's systematic gap detection so you **choose** what to defer, not **forget** what to do.

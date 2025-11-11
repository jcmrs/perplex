# ADR-006: Checkpoint Automation Strategy

**Date:** 2025-11-11
**Status:** Proposed
**Deciders:** AI Agent + Human Partner

## Context

### The Problem We Face

On 2025-11-11, the checkpoint automation workflow created a cascading PR crisis:
- Trigger: `pull_request: [closed]` on every PR merge
- Behavior: Closing PR #1 → Creates checkpoint PR #2 → Closing PR #2 → Creates checkpoint PR #3 → Infinite loop
- Impact: Repository chaos, user frustration, loss of control

**Emergency fix:** Disabled the automatic `pull_request` trigger entirely.

### The Deeper Issue

Disabling automatic checkpoint creation **violates our foundation imperatives:**

**Automation Imperative:** "Manual processes are temporary. Repetitive tasks are scripted."
- ❌ Current state: Checkpoints require manual workflow dispatch
- ❌ Reality: Humans (and AI) forget to create checkpoints at milestones

**AI-First Imperative:** "Primary user is the AI agent. Human is strategic partner, not human-in-loop."
- ❌ Current state: Requires human to remember and trigger checkpoints
- ❌ Reality: AI sessions cannot autonomously preserve continuity

**The Conflict:**
- We need automated checkpoints (foundation imperative)
- We cannot have checkpoint-on-every-PR (cascading chaos)
- We need automation that respects discrete milestones, not continuous noise

### What Checkpoints Are For

From `checkpoints/README.md` and product vision:
- **Purpose:** Preserve project state at key moments for session continuity
- **Target:** Milestones (phase transitions, major features, session boundaries)
- **NOT for:** Every commit, every PR, continuous state tracking

**The question:** How do we automate checkpoint creation at milestones without creating cascades?

## Research: Best Practices for AI Session Continuity

### Industry Patterns

1. **State Machine Transitions (Not Every Operation)**
   - Checkpoints on state changes, not every action
   - Example: Database checkpoints on transaction commits, not every query

2. **CI/CD Deployment Patterns**
   - Deploy on tagged releases, not every commit
   - Discriminate between continuous integration and discrete deployments

3. **Git Hook Patterns**
   - Hooks for specific events (pre-commit, post-merge), not all events
   - Granular triggers prevent unwanted automation

### Anti-Cascade Patterns

1. **Idempotency Checks:** Don't create checkpoint if one exists recently
2. **Cooldown Periods:** Rate limiting (minimum time between checkpoints)
3. **Discriminating Triggers:** Only trigger on specific conditions
4. **Explicit Intent Markers:** Tags, labels, commit message patterns

### AI Project Continuity Patterns

Research suggests successful AI agent workflows use:
- **Session boundaries** as natural checkpoint triggers
- **Phase transitions** as milestone markers
- **Explicit checkpoint requests** with automated execution
- **Time-based reminders** (but not enforcement) to prevent forgetting

## Decision

**We will implement a multi-trigger checkpoint automation strategy:**

### Primary Trigger: Session-End Automation
- Checkpoint automatically when `./tools/session-end.sh` runs successfully
- Rationale: Session end is a natural boundary, already part of AI workflow
- Implementation: Add checkpoint creation to session-end script (optional step with confirmation)

### Secondary Trigger: Phase-Change Detection
- Checkpoint automatically when `config/project.yml` phase field changes
- Rationale: Phase transitions (foundation → discovery) are major milestones
- Implementation: GitHub Actions workflow monitors phase changes

### Tertiary Trigger: Manual Workflow Dispatch
- Keep existing manual workflow for ad-hoc checkpoints (releases, critical milestones)
- Rationale: Flexibility for unexpected milestone moments

### Safeguard: Idempotency Check
- Don't create checkpoint if one exists within configurable threshold (default: 2 hours)
- Rationale: Prevents accidental duplicate checkpoints, provides safety margin
- Implementation: Check `checkpoints/LATEST.md` timestamp before creating new checkpoint

### Explicitly NOT Implementing
- ❌ Checkpoint on every PR merge (causes cascade)
- ❌ Checkpoint on every commit (too noisy)
- ❌ Time-based automatic checkpoints (arbitrary timing, not milestone-driven)

## Rationale

### Why This Approach?

**Respects Foundation Imperatives:**
- ✅ **Automation:** Most checkpoints created automatically (session-end, phase-change)
- ✅ **AI-First:** Tied to AI session workflow, no human-in-loop required
- ✅ **Modularity:** Multiple independent trigger mechanisms
- ✅ **Configurability:** Thresholds configurable via config/project.yml

**Prevents Cascades:**
- Session-end is discrete event (not triggered by its own output)
- Phase changes are infrequent and deliberate
- Idempotency check prevents duplicates
- No PR-triggered automation (the cascade source)

**Balances Automation with Intent:**
- Automated at natural boundaries (sessions, phases)
- Manual override for unexpected milestones
- Not automated at arbitrary points (every PR, every N minutes)

### Why Not Pure Manual?

Manual-only checkpoints violate:
- Automation imperative (manual processes are temporary)
- AI-First imperative (AI can't preserve own continuity)
- Reality (humans and AI forget)

### Why Not Time-Based?

Time-based checkpoints (every 4 hours, every day) are:
- Arbitrary (not tied to actual milestones)
- Noisy (create checkpoints during mid-work)
- Missing context (checkpoint might be mid-feature)

Time-based works for backups (recover from corruption), not milestones (restore context).

## Consequences

### Positive
- ✅ Automated checkpoint creation at meaningful milestones
- ✅ AI sessions can preserve continuity without human intervention
- ✅ No cascading PR creation (discrete triggers)
- ✅ Foundation imperatives respected (Automation + AI-First)
- ✅ Flexibility via multiple trigger mechanisms
- ✅ Safety via idempotency checks

### Negative
- ⚠️ Session-end checkpoints depend on `./tools/session-end.sh` being run (not always reliable)
- ⚠️ Phase changes are infrequent (might miss mid-phase milestones)
- ⚠️ Additional complexity (multiple trigger mechanisms to maintain)
- ⚠️ Idempotency logic adds state checking overhead

### Neutral
- Session-end script gains checkpoint responsibility (adds step to workflow)
- Phase-change workflow adds new GitHub Actions trigger
- Checkpoint creation becomes multi-path (session-end OR phase-change OR manual)

## Alternatives Considered

### Alternative 1: Commit Pattern Recognition
**What:** Checkpoint when commit message contains "Checkpoint:" or "Milestone:"
**Pros:** Explicit intent, flexible, works for direct commits
**Cons:** Requires AI/human to know convention, easy to forget, not truly automated
**Why not chosen:** Still relies on remembering to mark commits (human-in-loop)

### Alternative 2: Cooldown Period on PR Merge
**What:** Allow automatic PR merge checkpoints but with minimum 4-hour gap
**Pros:** Simple, prevents cascade, allows PR automation
**Cons:** First checkpoint might be premature, timing arbitrary, PR-based triggers still risky
**Why not chosen:** Doesn't tie to milestones, arbitrary timing, cascade risk remains

### Alternative 3: Label-Based PR Trigger
**What:** Checkpoint when PR merged with "checkpoint" label
**Pros:** Explicit intent, works in PR workflow
**Cons:** Requires PR workflow (doesn't work for direct commits), human must remember label
**Why not chosen:** Not fully automated, requires human-in-loop to add label

### Alternative 4: Workflow Completion Trigger
**What:** Checkpoint when all tests/validation workflows pass
**Pros:** Tied to quality gates, meaningful state
**Cons:** Too frequent (tests run on every push), not milestone-specific
**Why not chosen:** Creates noise, not tied to actual milestones

### Alternative 5: Manual Only + Reminder Notifications
**What:** Keep manual workflow, add notifications if no checkpoint in X hours
**Pros:** Prevents cascade, simple, low risk
**Cons:** Reminder is not enforcement, violates automation imperative, human-in-loop
**Why not chosen:** Doesn't solve the automation problem, just reminds about manual process

## Foundation Alignment

### Holistic System Thinking
- [x] Considered ripple effects: Session-end script modified, new phase-change workflow added
- [x] Understood interactions: Checkpoints interact with session logs, status updates, PR workflows
- [x] Thought through long-term: Multiple triggers provide flexibility as project evolves

### AI-First
- [x] Enables AI agent autonomy: AI can trigger checkpoints via session-end script
- [x] Preserves context for future sessions: Automated checkpoints at natural boundaries
- [x] Supports non-human-in-loop operation: No manual intervention required for most checkpoints

### Configurability
- [x] Uses external configuration: Idempotency threshold configurable in config/project.yml
- [x] Avoids hardcoded values: Time thresholds, triggers externally configurable
- [x] Allows for different environments: Can disable triggers in test environments

### Modularity
- [x] Maintains clear component boundaries: Session-end, phase-change, manual triggers are independent
- [x] Enables independent evolution: Each trigger mechanism can be modified independently
- [x] Single responsibility preserved: Each trigger has one job (detect milestone, create checkpoint)

### Extensibility
- [x] Allows for future additions: New trigger mechanisms can be added (commit patterns, labels, etc.)
- [x] Doesn't close off options: Hybrid approach allows evolution
- [x] Provides extension points: Idempotency check, trigger configuration, checkpoint content

### Integration
- [x] Considers how components connect: Session-end → checkpoint, phase-change → checkpoint, manual → checkpoint
- [x] Uses standard interfaces: All triggers use same `./tools/create-checkpoint.sh` script
- [x] Enables communication: Checkpoints preserve state for future sessions

### Automation
- [x] Automates repetitive aspects: Checkpoint creation at predictable milestones
- [x] Enables scripting and tooling: Multiple triggers, all scriptable
- [x] Reduces manual intervention: Most checkpoints automatic (session-end, phase-change)

## Related Decisions

- **ADR-002:** Foundation Enhancements (established checkpoint system)
- **ADR-003:** CLAUDE.md Orchestration Layer (session protocols)
- **Related:** `checkpoints/GITHUB_AUTOMATION.md` (implementation details)
- **Supersedes:** Implicit assumption that PR-merge checkpoints were correct approach

## Implementation Notes

### Phase 1: Session-End Checkpoint (Immediate)
1. Update `./tools/session-end.sh` to offer checkpoint creation
2. Add idempotency check (don't create if one exists in last N hours)
3. Make checkpoint creation optional (confirm before creating)
4. Test that session-end checkpoint doesn't trigger cascade

### Phase 2: Phase-Change Detection (Follow-up)
1. Create `.github/workflows/phase-change-checkpoint.yml`
2. Trigger: Monitor `config/project.yml` for phase field changes
3. Action: Create checkpoint automatically (with idempotency check)
4. Test phase change detection (foundation → discovery)

### Phase 3: Configuration (Enhancement)
1. Add `checkpoints:` section to `config/project.yml`
2. Configure idempotency threshold, enabled triggers, checkpoint defaults
3. Document configuration options in `checkpoints/README.md`

### Idempotency Check Implementation
```bash
# In tools/create-checkpoint.sh
LATEST_CHECKPOINT_TIME=$(stat -c %Y checkpoints/LATEST.md 2>/dev/null || echo 0)
CURRENT_TIME=$(date +%s)
TIME_DIFF=$((CURRENT_TIME - LATEST_CHECKPOINT_TIME))
THRESHOLD_SECONDS=$((CHECKPOINT_IDEMPOTENCY_HOURS * 3600))

if [ $TIME_DIFF -lt $THRESHOLD_SECONDS ]; then
  echo "Checkpoint created $((TIME_DIFF / 60)) minutes ago. Skipping (within $CHECKPOINT_IDEMPOTENCY_HOURS hour threshold)."
  exit 0
fi
```

### Session-End Integration
```bash
# In tools/session-end.sh (after validation and completeness review)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checkpoint Creation (Optional)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Create checkpoint for this session? (y/n): " CREATE_CHECKPOINT
if [ "$CREATE_CHECKPOINT" = "y" ]; then
  ./tools/create-checkpoint.sh "session-end-$(date +%Y%m%d)"
fi
```

## Follow-up Actions

- [ ] Implement Phase 1: Session-end checkpoint integration
- [ ] Test session-end checkpoint (verify no cascade)
- [ ] Implement Phase 2: Phase-change detection workflow
- [ ] Test phase-change checkpoint (foundation → discovery)
- [ ] Implement Phase 3: Checkpoint configuration in project.yml
- [ ] Update `checkpoints/README.md` with new trigger documentation
- [ ] Update `checkpoints/GITHUB_AUTOMATION.md` with phase-change workflow
- [ ] Create ADR to document actual implementation results (lessons learned)

## Review Date

**Review after Discovery Phase completion** (approximately 2-4 weeks)

Questions to answer:
- Are session-end checkpoints being created reliably?
- Has phase-change detection worked correctly?
- Have we forgotten any milestones (gaps in checkpoint coverage)?
- Do we need additional trigger mechanisms?
- Should idempotency threshold be adjusted?

## Notes

### Key Insights

1. **Automation ≠ Always-On:** Automation should target discrete events, not continuous triggers
2. **Milestones Matter:** Checkpoints are for meaningful boundaries, not arbitrary intervals
3. **Foundation Imperatives Can Conflict:** Automation + Stability both matter, balance is key
4. **Cascade Prevention:** Idempotency + Discrete Triggers prevent infinite loops

### Future Considerations

- **Checkpoint Pruning:** Eventually we'll have many checkpoints. Need retention policy?
- **Checkpoint Quality:** Are automated checkpoints as useful as manual ones? Monitor and iterate.
- **Trigger Expansion:** Might need additional triggers (commit patterns, labels) as project evolves
- **Cross-Session Checkpoints:** What if multiple AI sessions are active? (Claude Code web + local)

### References

- Industry patterns: Git hooks (discrete events), CI/CD (tagged deployments)
- Anti-patterns: GitHub Actions infinite loops, CI/CD pipeline cascades
- Foundation documents: FOUNDATION.md (imperatives), checkpoints/README.md (purpose)

---

**For Future AI Agents:**

This decision resolved a critical conflict between automation (foundation imperative) and stability (operational requirement). The solution: automate at discrete milestones (session-end, phase-change), not continuous events (every PR).

If you encounter checkpoint gaps (milestones without checkpoints), consider whether:
1. Session-end script wasn't run (reliability issue)
2. Milestone wasn't detected (new trigger needed)
3. Idempotency threshold too aggressive (configuration issue)

The goal is **automated milestone preservation, not continuous state tracking.**

**For Human Partner:**

This ADR documents our thinking on how to automate checkpoints without creating chaos. We're proposing a hybrid approach: session-end + phase-change + manual, with safeguards.

Please review:
- Does this balance automation with stability correctly?
- Are session-end and phase-change the right milestone triggers?
- Should we add/remove any trigger mechanisms?
- Is the idempotency threshold (2 hours default) appropriate?

Your feedback will shape the final implementation.

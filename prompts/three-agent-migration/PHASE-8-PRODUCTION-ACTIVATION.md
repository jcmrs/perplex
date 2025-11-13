# Phase 8: Production Activation

**Agent:** CLI-Director (CDIR)
**Prerequisites:** Phase 7 complete (validation passed)
**Execution Environment:** PowerShell Terminal Window 1
**OS:** Windows
**Project Path:** `C:\Development\perplex`
**Branch:** Merge `claude/design-three-agent-config` to main
**Duration Estimate:** 30-45 minutes

---

## IMPORTANT: Environment Setup

**You are running on Windows with PowerShell.**

**Terminal:** PowerShell Terminal Window 1 (same window used throughout Phases 1-7)

**PowerShell Commands:** All commands are PowerShell unless noted otherwise.

---

## Mission

Activate three-agent architecture in production.

---

## Step-by-Step

### 1. Verify Phase 7 Complete

```powershell
cat .claude\migration-phase-7-complete.txt
```

Ensure all validation tests passed. Should show timestamp and confirmation.

---

### 2. Merge Configuration PR

**Switch to config branch:**
```powershell
git checkout claude/design-three-agent-config
```

**Ensure all changes committed:**
```powershell
git status
```

Should show clean working tree.

**Push final changes (if any uncommitted):**
```powershell
git push
```

**On GitHub:**
- PR should auto-create (from auto-create-pr workflow)
- Validation workflows should run
- Once passing, PR will auto-merge (auto-merge workflow)

**Or merge manually:**
```powershell
git checkout main
git merge claude/design-three-agent-config
git push origin main
```

---

### 3. Clean Up Test Spec

**Switch to main and pull:**
```powershell
git checkout main
git pull origin main
```

**Remove test spec (was for validation only):**
```powershell
# Remove test spec directory
Remove-Item -Path specs\000-migration-test -Recurse -Force -ErrorAction SilentlyContinue

# Remove test implementation files
Remove-Item -Path src\hello.py -Force -ErrorAction SilentlyContinue
Remove-Item -Path tests\test_hello.py -Force -ErrorAction SilentlyContinue
```

**Check what was removed:**
```powershell
git status
```

**Commit cleanup:**
```powershell
git add -A
git commit --no-gpg-sign -m "[CDIR] Clean up migration test artifacts

Removed 000-migration-test spec (validation complete).
Removed test implementation (src/hello.py, tests/test_hello.py).

Migration Phase: 8A of 9
Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: main
Environment: Windows PowerShell at C:\Development\perplex
"
```

**Push to remote:**
```powershell
git push
```

---

### 4. Create ADR-012

Create `decisions\2025-11-13-three-agent-architecture-migration.md` (if not already created).

**Open your text editor and create the file with this content:**

```markdown
# ADR-012: Three-Agent Architecture Migration

**Date:** 2025-11-13
**Status:** Accepted and Implemented
**Deciders:** User (strategic), Web (design), CDIR (execution)
**Decision Scope:** architecture

## Context

Project Perplex migrated from two-agent to three-agent architecture:
- **Before:** Web (primary designer, browser) + CLI (primary executor, local)
- **After:** CDIR (primary designer, local) + CEXE (primary executor, local) + Web (standby)

**Rationale:**
- Web environment limitations (sandboxed, limited git, no MCP, no Spec Kit)
- Coordination friction (human mediation between browser and local)
- Designer needs full tooling access (git, MCP, Spec Kit, system integration)

## Decision

Replace Web as primary designer with local CLI-Director (CDIR).

**New Architecture:**
- **CDIR (Terminal-1):** Primary designer-researcher
- **CEXE (Terminal-2):** Primary executor-validator
- **Web (Browser):** Standby emergency backup

**Benefits:**
- Full tooling access for designer
- Reduced coordination friction (both local)
- Persistent context (MCP memory, session state)
- Can execute Spec Kit commands
- Shared filesystem visibility

## Implementation

**Migration:** 9-phase chained prompts (docs/THREE_AGENT_MIGRATION_ARCHITECTURE.md)

**Phases:**
1. CDIR identity setup
2. Configuration migration
3. Workspace coordination update
4. Automation & hooks update
5. Documentation update
6. GitHub workflows update
7. Validation & testing
8. Production activation (this phase)
9. Web handoff & standby

**Systems Updated:**
- 40+ files across 10 subsystems
- Identity files, agent registry, workspace manifest
- All automation tools and git hooks
- All documentation
- GitHub workflows
- Validation with test specification

## Consequences

**Positive:**
✅ Designer has full local environment access
✅ CDIR can run Spec Kit commands directly
✅ Coordination simplified (shared filesystem)
✅ Persistent context across sessions
✅ Web remains available for emergency

**Neutral:**
- User coordinates two local terminals instead of browser + local
- Web transitions to standby (not retired, just backup)

**Negative:**
- Requires two terminal windows (increased mental load)
- Web's browser-based access less convenient for quick checks

**Mitigation:**
- Clear terminal identification (Terminal-1 vs Terminal-2)
- Agent registry provides coordination visibility
- Web available if needed

## Foundation Alignment

All 7 Foundation Imperatives validated: [✓]
- Holistic System Thinking
- AI-First
- Configurability
- Modularity
- Extensibility
- Integration
- Automation

## Status

**Implemented:** 2025-11-13
**Migration:** Complete
**Production:** Active
**Validation:** Passed (test spec 000-migration-test)
```

**Save the file.**

**Commit ADR:**
```powershell
git add decisions\2025-11-13-three-agent-architecture-migration.md
git commit --no-gpg-sign -m "[CDIR] ADR-012: Three-agent architecture migration

Documents decision rationale, implementation, and consequences.

Migration Phase: 8B of 9
Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: main
Environment: Windows PowerShell at C:\Development\perplex
"
```

**Push to remote:**
```powershell
git push
```

---

### 5. Create Production Checkpoint

**Option A: Use Automation Script (Recommended)**
```powershell
.\tools\create-checkpoint.sh "Three-agent architecture migration complete"
```

**Note:** The script is bash, so Git Bash will handle it automatically when you run it.

**Option B: Manual PowerShell Creation**

```powershell
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$checkpointFile = "checkpoints\checkpoint-$timestamp-three-agent-migration-complete.md"

@"
# Checkpoint: Three-Agent Migration Complete

**Date:** $(Get-Date -Format "yyyy-MM-dd")
**Phase:** Foundation → Production (Three-Agent)

## Summary

Project Perplex successfully migrated from two-agent to three-agent architecture.

**Before:**
- Web (browser): Primary designer
- CLI (local): Primary executor

**After:**
- CDIR (Terminal-1): Primary designer
- CEXE (Terminal-2): Primary executor
- Web (browser): Standby emergency

## What Changed

- 40+ files updated across 10 subsystems
- All identity and coordination files migrated
- Automation tools updated
- Documentation complete
- GitHub workflows updated
- Validation passed

## Critical Files

1. .claude\identity-cli-director.json
2. .claude\identity-cli-executor.json
3. .claude\identity-web.json (standby)
4. .claude\agent-registry.json (v3.0)
5. .claude\workspace-coordination.yml (v2.0)
6. CLAUDE.md (three-agent protocols)
7. docs\THREE_AGENT_MIGRATION_ARCHITECTURE.md

## Active Agents

- CDIR: Active (Terminal-1)
- CEXE: Active (Terminal-2)
- Web: Standby

## Next Actions

1. Web handoff (Phase 9)
2. Begin production work with three-agent coordination
3. Create first real specification with CDIR
4. Implement with CEXE
5. Validate coordination in practice
"@ | Set-Content -Path $checkpointFile -Encoding UTF8

Write-Host "Checkpoint created: $checkpointFile"
```

**Commit checkpoint:**
```powershell
git add checkpoints\*
git commit --no-gpg-sign -m "[CDIR] Checkpoint: Three-agent migration complete

Production checkpoint documenting successful migration.

Migration Phase: 8C of 9
Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: main
Environment: Windows PowerShell at C:\Development\perplex
"
git push
```

---

### 6. Update CURRENT_STATUS.md

**Run status generation script:**
```powershell
.\tools\generate-status.sh
```

**Note:** Git Bash will handle the script automatically.

**Verify CURRENT_STATUS reflects three-agent architecture:**
```powershell
cat sessions\CURRENT_STATUS.md
```

Should mention three-agent architecture and updated status.

---

### 7. Create Session Log

**Open your text editor and create `sessions\session-20251113-three-agent-migration.md`:**

Document the entire migration:
- All 9 phases
- What changed
- Validation results
- ADR reference
- Lessons learned

**Example structure:**

```markdown
# Session Log: Three-Agent Architecture Migration

**Date:** 2025-11-13
**Agent:** CDIR (cli-claude-director-001) + CEXE (cli-claude-executor-001)
**Environment:** Windows PowerShell (two terminals)
**Duration:** [calculated from phase start to Phase 8 completion]

## Overview

Successfully migrated Project Perplex from two-agent to three-agent architecture.

## Migration Phases Completed

### Phase 1: CDIR Identity Setup
- Created identity-cli-director.json
- Configured Terminal-1 environment
- [details...]

### Phase 2: Configuration Migration
- Updated all configuration files
- Migrated identity files
- [details...]

[Continue for all 9 phases...]

## Changes Summary

- **Files Modified:** 40+
- **Subsystems Updated:** 10
- **ADRs Created:** 1 (ADR-012)
- **Validation:** Test spec 000-migration-test passed

## Validation Results

[Include Part F validation results from Phase 7...]

## Lessons Learned

[Document any insights, challenges, solutions...]

## Next Steps

- Phase 9: Web handoff
- Begin production work with three-agent coordination
- Create first real specification with CDIR
```

**Save the file.**

**Commit session log and status:**
```powershell
git add sessions\session-20251113-three-agent-migration.md
git add sessions\CURRENT_STATUS.md

git commit --no-gpg-sign -m "[CDIR] Document three-agent migration session

Complete migration log: 9 phases, 40+ files, validation passed.

Migration Phase: 8D of 9
Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: main
Environment: Windows PowerShell at C:\Development\perplex
"
```

**Push to remote:**
```powershell
git push
```

---

### 8. Update Agent Registry - Production Status

**Open `.claude\agent-registry.json` in your text editor.**

**Update CDIR entry:**
```json
{
  "agent_id": "cli-claude-director-001",
  "display_name": "Claude Code CLI Director",
  "short_name": "CDIR",
  "status": "active",
  "workspace": {
    "workspace_state": "operational",
    "current_work": "Three-agent architecture active in production"
  }
}
```

**Update CEXE entry:**
```json
{
  "agent_id": "cli-claude-executor-001",
  "display_name": "Claude Code CLI Executor",
  "short_name": "CEXE",
  "status": "active",
  "workspace": {
    "workspace_state": "idle",
    "current_work": "Awaiting specifications from CDIR"
  }
}
```

**Update Web entry:**
```json
{
  "agent_id": "web-claude-designer-001",
  "display_name": "Claude Code Web",
  "short_name": "Web",
  "status": "standby",
  "workspace": {
    "workspace_state": "standby",
    "current_work": "Standby for emergency activation"
  }
}
```

**Save the file.**

**Commit agent registry:**
```powershell
git add .claude\agent-registry.json
git commit --no-gpg-sign -m "[CDIR] Agent registry: Production status

All agents operational:
- CDIR: Active (production)
- CEXE: Active (awaiting specs)
- Web: Standby

Migration Phase: 8E of 9
Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: main
Environment: Windows PowerShell at C:\Development\perplex
"
```

**Push to remote:**
```powershell
git push
```

---

### 9. Create Phase Marker

```powershell
"Phase 8 complete: $(Get-Date)" | Set-Content -Path .claude\migration-phase-8-complete.txt
cat .claude\migration-phase-8-complete.txt
```

Should show timestamp confirmation.

---

### 10. Announce Production

```
[From: CDIR] Phase 8 COMPLETE. Three-agent architecture ACTIVE IN PRODUCTION.

Migration Status: SUCCESS
- 9 phases complete (8/9 execution phases done)
- 40+ files migrated
- Validation passed
- ADR-012 created
- Checkpoint created
- Documentation complete

Architecture:
- CDIR (Terminal-1): Primary designer - OPERATIONAL
- CEXE (Terminal-2): Primary executor - OPERATIONAL
- Web (Browser): Standby - READY

Next: Phase 9 - Web handoff (final ceremonial transition)

🎉 Three-agent architecture is LIVE 🎉

Environment: Windows PowerShell at C:\Development\perplex
Terminal: PowerShell-Terminal-1
Agent: CDIR (cli-claude-director-001)
Ready for production work.
```

---

## Validation Checklist

- [ ] Configuration PR merged to main
- [ ] Test artifacts cleaned up (specs\000-migration-test, src\hello.py, tests\test_hello.py)
- [ ] ADR-012 created and committed (decisions\2025-11-13-three-agent-architecture-migration.md)
- [ ] Production checkpoint created (checkpoints\checkpoint-YYYYMMDD-HHMMSS-three-agent-migration-complete.md)
- [ ] CURRENT_STATUS.md updated (sessions\CURRENT_STATUS.md)
- [ ] Session log documented (sessions\session-20251113-three-agent-migration.md)
- [ ] Agent registry shows production status (.claude\agent-registry.json)
- [ ] All changes pushed to main
- [ ] Phase 8 marker created (.claude\migration-phase-8-complete.txt)

---

## If Validation Fails

**Problem: Merge conflicts**
- Use git to resolve conflicts manually
- Prioritize three-agent configuration over old two-agent config
- Ask for help if uncertain

**Problem: Checkpoint script fails**
- Use manual PowerShell creation (Option B in Step 5)
- Ensure UTF8 encoding
- Verify file paths with `\`

**Problem: Status generation script fails**
- Manually edit sessions\CURRENT_STATUS.md
- Update date, phase, recent commits
- Commit manually

**Problem: Missing test artifacts (can't delete)**
- Check if they exist: `Test-Path specs\000-migration-test`
- If missing, skip deletion (already clean)
- Continue to next step

---

## Notes

**About PowerShell:**
- All commands use `\` for paths
- Use `Set-Content` instead of `>` for UTF8 encoding
- `cat` is an alias that works in PowerShell
- Git commands are identical to bash

**About Git Bash Scripts:**
- When you run `.\tools\create-checkpoint.sh`, Git Bash handles it
- Don't convert .sh files to PowerShell
- Just run them and they work

**About Automation:**
- GitHub workflows handle PR creation and merge
- Checkpoint script automates most of checkpoint creation
- Status script regenerates CURRENT_STATUS.md
- All tools designed for automation

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001
**Environment:** Windows PowerShell (Terminal Window 1)
**Project Path:** C:\Development\perplex
**Phase:** 8 of 9
**Next:** Phase 9 - Web Handoff & Standby

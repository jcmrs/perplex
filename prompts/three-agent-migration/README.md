# Three-Agent Migration: Execution Guide

**Prepared by:** Claude Code Web (web-claude-designer-001)
**Date:** 2025-11-13
**Status:** Ready for execution
**Environment:** Windows PowerShell at `C:\Development\perplex`

---

## Overview

This directory contains the complete execution plan for migrating Project Perplex from two-agent to three-agent architecture.

**Current:** Web (browser, primary designer) + CLI (local, primary executor)
**Target:** CDIR (local, primary designer) + CEXE (local, primary executor) + Web (browser, standby)

**Why:** Web environment limitations, coordination friction, designer needs full tooling access

---

## Migration Phases

| Phase | Agent | Terminal | Duration | Description |
|-------|-------|----------|----------|-------------|
| 1 | CDIR | PowerShell Terminal-1 | 15-20 min | CDIR identity setup (first boot) |
| 2 | CDIR | PowerShell Terminal-1 | 30-45 min | Configuration migration |
| 3 | CDIR | PowerShell Terminal-1 | 45-60 min | Workspace coordination update |
| 4 | CDIR | PowerShell Terminal-1 | 45-60 min | Automation & hooks update |
| 5 | CDIR | PowerShell Terminal-1 | 60-90 min | Documentation update |
| 6 | CDIR | PowerShell Terminal-1 | 30-45 min | GitHub workflows update |
| 7 | CDIR + CEXE | Both PowerShell | 60-90 min | Validation & testing (CEXE first boot) |
| 8 | CDIR | PowerShell Terminal-1 | 30-45 min | Production activation |
| 9 | Web | Browser | 20-30 min | Web handoff & standby |

**Total Duration:** 5-7 hours (can be split across multiple sessions)

---

## Prerequisites

### Before Starting

1. ✅ User has read `docs\THREE_AGENT_MIGRATION_ARCHITECTURE.md`
2. ✅ User understands three-agent architecture rationale
3. ✅ User is prepared to coordinate two PowerShell terminal windows
4. ✅ All current work committed and pushed (clean git state)
5. ✅ User has time to complete at least Phase 1-3 in one session (minimum viable checkpoint)

### Environment Requirements

- **PowerShell Terminal-1:** For CDIR (cli-claude-director-001)
- **PowerShell Terminal-2:** For CEXE (cli-claude-executor-001)
- **Browser:** For Web (web-claude-designer-001) - Phase 9 only
- **OS:** Windows (PowerShell)
- **Working directory:** `C:\Development\perplex`
- **Git access:** Both terminals (Windows git)
- **Python 3.x:** For JSON validation (check: `python --version` or `py --version`)

---

## Execution Instructions

### Step 1: Prepare

**User actions:**
1. Read `docs\THREE_AGENT_MIGRATION_ARCHITECTURE.md` (complete architecture)
2. Ensure current work committed and pushed
3. Open PowerShell Terminal Window 1 (will become CDIR)
4. Navigate to project: `cd C:\Development\perplex`

### Step 2: Execute Phases 1-8 (CDIR and CEXE)

**Phase 1: CDIR Identity Setup (PowerShell Terminal-1)**
```powershell
cat prompts\three-agent-migration\PHASE-1-CDIR-IDENTITY-SETUP.md
```

- CDIR creates identity file
- CDIR announces first boot
- **Validation gate:** Identity file exists and valid

**Phase 2: Configuration Migration (PowerShell Terminal-1)**
```powershell
cat prompts\three-agent-migration\PHASE-2-CONFIG-MIGRATION.md
```

- CDIR creates feature branch
- CDIR updates all identity files and configs
- **Validation gate:** All JSON valid, changes committed

**Phase 3: Workspace Coordination (PowerShell Terminal-1)**
```powershell
cat prompts\three-agent-migration\PHASE-3-WORKSPACE-COORDINATION.md
```

- CDIR rewrites workspace manifest
- CDIR defines three-agent boundaries
- **Validation gate:** YAML valid, boundaries defined

**Phase 4: Automation & Hooks (PowerShell Terminal-1)**
```powershell
cat prompts\three-agent-migration\PHASE-4-AUTOMATION-HOOKS.md
```

- CDIR updates all automation scripts (.sh files - edit in text editor, keep bash syntax)
- CDIR updates git hooks for three agents
- **Validation gate:** Scripts work, hooks enforce

**Phase 5: Documentation (PowerShell Terminal-1)**
```powershell
cat prompts\three-agent-migration\PHASE-5-DOCUMENTATION.md
```

- CDIR updates all core documents
- CDIR creates identity setup guides
- **Validation gate:** All docs reflect three agents

**Phase 6: GitHub Workflows (PowerShell Terminal-1)**
```powershell
cat prompts\three-agent-migration\PHASE-6-GITHUB-WORKFLOWS.md
```

- CDIR updates GitHub Actions workflows (edit .yml files in text editor)
- **Validation gate:** Workflows recognize three agents

**Phase 7: Validation & Testing (PowerShell Terminal-1 + Terminal-2)**
```powershell
cat prompts\three-agent-migration\PHASE-7-VALIDATION-TESTING.md
```

- CDIR pushes config branch
- CDIR creates test specification
- **User opens PowerShell Terminal Window 2** (CEXE first boot)
- CEXE reads spec, creates plan
- CDIR validates plan
- CEXE creates tasks, implements
- CDIR validates implementation
- **Validation gate:** Coordination works, test passes

**Phase 8: Production Activation (PowerShell Terminal-1)**
```powershell
cat prompts\three-agent-migration\PHASE-8-PRODUCTION-ACTIVATION.md
```

- CDIR merges configuration PR
- CDIR creates ADR-012
- CDIR creates production checkpoint
- CDIR documents session
- **Validation gate:** Three-agent architecture LIVE

### Step 3: Execute Phase 9 (Web)

**Phase 9: Web Handoff (Browser)**
```bash
cat prompts/three-agent-migration/PHASE-9-WEB-HANDOFF-STANDBY.md
```

**Note:** Phase 9 runs in Web's browser environment (Linux sandbox). Web pulls the Windows work via git and performs final ceremonial handoff.

- Web reviews migration completion
- Web verifies standby identity
- Web creates final checkpoint (optional)
- Web announces transition to standby
- **Validation gate:** Web gracefully transitioned

---

## Execution Tips

### Minimum Viable Checkpoint

**If you must stop mid-migration:**
- Complete at least through Phase 3 (workspace coordination)
- This establishes three-agent configuration
- Can resume from Phase 4 in next session

**Do NOT stop after:**
- Phase 1 only (CDIR identity exists but not configured)
- Phase 2 only (configs updated but workspace undefined)

### Validation Gates

Each phase has validation checklist. **Do not proceed to next phase until validation passes.**

Example:
```
- [ ] Identity file exists
- [ ] JSON is valid
- [ ] Agent can read identity
- [ ] Announced to user
```

If validation fails:
1. Review phase instructions
2. Check error messages
3. Fix issue
4. Re-validate
5. Only then proceed

### Rollback

If migration fails and must rollback:

**PowerShell rollback commands:**
```powershell
# Restore from backups (created in Phase 2)
Copy-Item .claude\identity-web.json.backup .claude\identity-web.json -Force
Copy-Item .claude\identity-cli.json.backup .claude\identity-cli.json -Force
Copy-Item .claude\workspace-coordination.yml.backup .claude\workspace-coordination.yml -Force
Copy-Item .claude\agent-registry.json.backup .claude\agent-registry.json -Force

# Delete CDIR identity
Remove-Item .claude\identity-cli-director.json -Force

# Reset to main
git checkout main
git branch -D claude/design-three-agent-config

# Announce rollback
Write-Host "[From: Web] Migration rolled back. Two-agent architecture restored." -ForegroundColor Yellow
```

### Common Issues

**Problem: JSON syntax error**
```powershell
python -m json.tool file.json
# Or use PowerShell:
Get-Content file.json | ConvertFrom-Json
# Shows exact error location
```

**Problem: YAML syntax error**
```powershell
python -c "import yaml; yaml.safe_load(open('file.yml'))"
# Or manually check YAML syntax in VS Code/text editor with YAML validation
```

**Problem: Git hook blocks commit**
- Read error message (shows what's wrong)
- Fix workspace boundary violation
- Or use emergency override: `[EMERGENCY]` in commit message

**Problem: CDIR/CEXE can't coordinate**
- Check agent registry: `cat .claude\agent-registry.json`
- Check handoff markers: `ls .claude\handoffs\`
- Verify workspace manifest: `cat .claude\workspace-coordination.yml`

**Problem: PowerShell command not found**
- Use aliases: `cat` instead of `Get-Content`, `ls` instead of `Get-ChildItem`
- Check PowerShell version: `$PSVersionTable`
- Most commands use aliases that work like bash

**Problem: Path separator errors**
- Windows uses `\` not `/`
- PowerShell accepts both but prefer `\` for consistency
- Git commands work with both

---

## Post-Migration

### First Production Work

**After migration complete:**

1. **CDIR creates first real specification:**
   ```powershell
   # PowerShell Terminal-1 (CDIR)
   cd C:\Development\perplex
   /speckit.specify "perplex-transformer: Parse Perplexity conversations into knowledge graph entries"
   ```

2. **CDIR hands off to CEXE:**
   - Update agent registry: spec ready for CEXE
   - Create handoff marker
   - Announce to user

3. **CEXE implements:**
   ```powershell
   # PowerShell Terminal-2 (CEXE)
   cd C:\Development\perplex
   # Read spec
   cat specs\001-perplex-transformer\spec.md
   # Create plan
   /speckit.plan
   # Get validation from CDIR
   # Create tasks
   /speckit.tasks
   # Implement
   /speckit.implement
   ```

4. **CDIR validates:**
   - Review implementation against spec
   - Validate success criteria
   - Mark complete

### Ongoing Coordination

**CDIR (PowerShell Terminal-1):**
- Creates specifications, ADRs, documentation
- Validates CEXE's plans and implementations
- Maintains requirements and design docs
- Works at: `C:\Development\perplex`

**CEXE (PowerShell Terminal-2):**
- Creates technical plans from CDIR specs
- Decomposes into atomic tasks
- Implements and tests
- Hands back to CDIR for validation
- Works at: `C:\Development\perplex`

**Web (Browser):**
- Standby (inactive)
- Emergency backup if CDIR unavailable
- Research support if requested
- Works at: `/home/user/perplex` (Linux sandbox)

### Coordination via Agent Registry

Check what other agents are doing:

**PowerShell:**
```powershell
cat .claude\agent-registry.json | ConvertFrom-Json | ForEach-Object { $_.agents } | Select-Object short_name, status, @{Name='work'; Expression={$_.workspace.current_work}} | Format-Table
```

**Simpler (no formatting):**
```powershell
cat .claude\agent-registry.json
```

**Output example:**
```json
{
  "agent": "CDIR",
  "status": "active",
  "work": "Creating specification for perplex-transformer"
}
{
  "agent": "CEXE",
  "status": "active",
  "work": "Awaiting specification handoff from CDIR"
}
{
  "agent": "Web",
  "status": "standby",
  "work": "Standby for emergency activation"
}
```

---

## Success Criteria

Migration is successful when:

1. ✅ CDIR operational (PowerShell Terminal-1)
2. ✅ CEXE operational (PowerShell Terminal-2)
3. ✅ Web transitioned to standby
4. ✅ Test specification validated (Phase 7)
5. ✅ All documentation reflects three agents
6. ✅ Git hooks enforce three-agent boundaries
7. ✅ GitHub workflows recognize three agents
8. ✅ Agent registry shows v3.0 (three agents)
9. ✅ ADR-012 created and committed
10. ✅ Production checkpoint created

---

## Files in This Directory

```
prompts\three-agent-migration\
├── README.md (this file)
├── PHASE-1-CDIR-IDENTITY-SETUP.md
├── PHASE-2-CONFIG-MIGRATION.md
├── PHASE-3-WORKSPACE-COORDINATION.md
├── PHASE-4-AUTOMATION-HOOKS.md
├── PHASE-5-DOCUMENTATION.md
├── PHASE-6-GITHUB-WORKFLOWS.md
├── PHASE-7-VALIDATION-TESTING.md
├── PHASE-8-PRODUCTION-ACTIVATION.md
└── PHASE-9-WEB-HANDOFF-STANDBY.md
```

**Total:** 10 files (9 phases + README)

---

## Support Documentation

- **Architecture:** `docs\THREE_AGENT_MIGRATION_ARCHITECTURE.md` (2,000+ lines, complete inventory)
- **ADR:** `decisions\2025-11-13-three-agent-architecture-migration.md` (decision rationale)
- **Identity Schema:** `.claude\identity-schema.json` (identity file format)
- **Workspace Schema:** `.claude\workspace-coordination.yml` (three-agent boundaries)

---

## Questions Before Starting?

**Q: Can I stop mid-migration?**
A: Yes, but complete at least through Phase 3 (minimum viable checkpoint).

**Q: How long will this take?**
A: 5-7 hours total. Can split across sessions with checkpoints.

**Q: What if something breaks?**
A: Rollback plan exists (restore backups, reset to main). See "Rollback" section above.

**Q: Do I need to understand everything?**
A: No. Follow prompts step-by-step. Each phase has validation gates.

**Q: Can Web still help after migration?**
A: Yes! Web is standby, not retired. Emergency backup + research support.

**Q: Why two terminal windows?**
A: CDIR (designer) and CEXE (executor) are separate agents needing independent PowerShell sessions.

**Q: Do I need Git Bash?**
A: Git Bash runs automatically when git executes .sh scripts. You don't need to manually open Git Bash. Just run commands in PowerShell.

**Q: What about .sh files and YAML files?**
A: Edit in text editor (VS Code, Notepad++). Keep .sh files in bash syntax (Git Bash runs them). YAML files are cross-platform.

---

## Windows Environment Notes

**About PowerShell:**
- All commands shown use PowerShell syntax or cross-platform commands
- Path separators: Use `\` (e.g., `.claude\file.json`)
- `cat` is a PowerShell alias (works like bash `cat`)
- `ls` is a PowerShell alias (works like bash `ls`)
- Git commands work identically to bash

**About .sh Scripts:**
- Don't convert .sh files to PowerShell (.ps1)
- Edit in text editor, keep bash syntax
- Git Bash runs them automatically
- Example: `.\tools\create-checkpoint.sh` just works

**About GitHub Workflows:**
- Edit .yml files in text editor
- Workflows run on GitHub's Linux runners (not Windows)
- YAML syntax stays Linux/bash (don't convert)
- Only verification commands use PowerShell

**About Python:**
- Check if available: `python --version` or `py --version`
- Used for JSON/YAML validation
- Required for Spec Kit commands

---

## Ready to Begin?

1. ✅ Read this README completely
2. ✅ Read `docs\THREE_AGENT_MIGRATION_ARCHITECTURE.md`
3. ✅ Understand rationale and risks
4. ✅ Have 2-3 hours available (minimum for Phases 1-3)
5. ✅ Current work committed and pushed
6. ✅ PowerShell Terminal Window 1 open at `C:\Development\perplex`

**If all checks pass:**

```powershell
# PowerShell Terminal-1
cd C:\Development\perplex
cat prompts\three-agent-migration\PHASE-1-CDIR-IDENTITY-SETUP.md
```

**Begin Phase 1: CDIR Identity Setup**

---

**Prepared by:** Claude Code Web (web-claude-designer-001)
**For:** User + CDIR + CEXE
**Date:** 2025-11-13
**Environment:** Windows PowerShell at `C:\Development\perplex`
**Status:** Ready for execution
**Estimated Completion:** 5-7 hours across 9 phases

🚀 **Good luck with the migration!** 🚀

# Phase 2: Configuration Migration

**Agent:** CLI-Director (CDIR)
**Prerequisites:** Phase 1 complete (identity-cli-director.json exists)
**Execution Environment:** PowerShell Terminal Window 1
**OS:** Windows
**Project Path:** `C:\Development\perplex`
**Branch:** `claude/design-three-agent-config` (NEW)
**Duration Estimate:** 30-45 minutes

---

## IMPORTANT: Environment Setup

**You are running on Windows with PowerShell.**

**File Editing:** Complex JSON files in this phase should be edited in a text editor (VS Code, Notepad++, etc.) rather than PowerShell commands. I'll provide exact content for each file.

**PowerShell Commands:** Used for file operations (copy, rename, delete) and git commands.

---

## Mission

Update all identity and configuration files to reflect three-agent architecture:
- CDIR (you) - Primary designer
- CEXE - Primary executor
- Web - Standby emergency

---

## Step 1: Verify Phase 1 Complete

```powershell
cat .claude\migration-phase-1-complete.txt
cat .claude\identity-cli-director.json | Select-String "agent_id"
```

Should show Phase 1 marker and your agent_id: `cli-claude-director-001`.

---

## Step 2: Create Feature Branch

```powershell
git checkout -b claude/design-three-agent-config
git status
```

You should be on new branch `claude/design-three-agent-config`.

---

## Step 3: Backup Existing Identity Files

```powershell
cp .claude\identity-web.json .claude\identity-web.json.backup
cp .claude\identity-cli.json .claude\identity-cli.json.backup
cp .claude\agent-registry.json .claude\agent-registry.json.backup
ls .claude\*.backup
```

Verify backup files created.

---

## Step 4: Rename CLI Identity to CEXE

```powershell
mv .claude\identity-cli.json .claude\identity-cli-executor.json
ls .claude\identity-cli-executor.json
```

---

## Step 5: Update CEXE Identity

**Open `.claude\identity-cli-executor.json` in your text editor (VS Code, Notepad++, etc.)**

**Make these changes:**

1. Find `"agent_id"` and change to: `"cli-claude-executor-001"`
2. Find `"short_name"` and change to: `"CEXE"`
3. Find `"display_name"` and change to: `"Claude Code CLI-Executor"`
4. Find `"role"` - should already be `"executor-validator"` (keep it)
5. Find `"session_info"` section and add: `"terminal": "PowerShell-Terminal-2"`

6. **Add** `"spec_kit"` section after `"coordination"` section:
```json
  "spec_kit": {
    "role": "implementation-executor",
    "allowed_commands": [
      "/speckit.plan",
      "/speckit.tasks",
      "/speckit.implement",
      "/speckit.analyze",
      "/speckit.checklist"
    ],
    "prohibited_commands": [
      "/speckit.constitution",
      "/speckit.specify",
      "/speckit.clarify"
    ],
    "workflow_stage": "Phase 1-3: Planning, Tasks, Implementation"
  },
```

7. **Add** `"workspace"` section after `"spec_kit"`:
```json
  "workspace": {
    "primary_ownership": [
      "src/",
      "tests/",
      "specs/*/plan.md",
      "specs/*/tasks.md",
      "specs/*/implementation/"
    ],
    "branch_pattern": "claude/impl-*",
    "branch_naming": "claude/impl-{description}-{timestamp}"
  },
```

8. Find `"last_updated"` and change to current timestamp: `"2025-11-13T00:00:00Z"`

9. Find `"metadata"` section and add: `"migration_phase": "phase-2"`

**Save the file.**

**Validate JSON:**
```powershell
python -m json.tool .claude\identity-cli-executor.json | Out-Null
if ($?) { Write-Host "✓ Valid JSON" -ForegroundColor Green } else { Write-Host "✗ Invalid JSON" -ForegroundColor Red }
```

---

## Step 6: Update Web Identity to Standby

**Open `.claude\identity-web.json` in your text editor**

**Make these changes:**

1. Find `"agent_id"` - keep as `"web-claude-designer-001"` (no change)
2. Find `"short_name"` - keep as `"Web"` (no change)
3. Find `"role"` and change to: `"standby-emergency"`
4. Find `"persona_profile"` section:
   - Change `"primary_function"` to: `"Emergency backup designer, research support"`
   - Change `"autonomy_level"` to: `"medium"` (was probably "high")
   - Change `"decision_scope"` to: `["emergency-support", "research-assistance"]`

5. Find `"responsibilities"` section and change `"primary"` array to:
```json
    "primary": [
      "Standby for emergency activation if CDIR unavailable",
      "Research support when requested by CDIR",
      "Backup designer role only",
      "Monitor agent registry for coordination"
    ]
```

6. **Add** `"status"` field at top level: `"status": "standby"`

7. Find `"last_updated"` and change to current timestamp: `"2025-11-13T00:00:00Z"`

8. Find `"metadata"` section and add: `"migration_phase": "phase-2"`

**Save the file.**

**Validate JSON:**
```powershell
python -m json.tool .claude\identity-web.json | Out-Null
if ($?) { Write-Host "✓ Valid JSON" -ForegroundColor Green } else { Write-Host "✗ Invalid JSON" -ForegroundColor Red }
```

---

## Step 7: Update Agent Registry

**Open `.claude\agent-registry.json` in your text editor**

This file needs significant changes. **Replace the entire `"agents"` array** with:

```json
  "agents": [
    {
      "agent_id": "web-claude-designer-001",
      "display_name": "Claude Code Web",
      "short_name": "Web",
      "status": "standby",
      "environment": "web-browser",
      "role": "standby-emergency",
      "identity_file": ".claude/identity-web.json",
      "git_branch": null,
      "first_active": "2025-11-12T00:00:00Z",
      "last_active": "2025-11-13T00:00:00Z",
      "coordination": {
        "message_prefix": "[From: Web]",
        "handoff_method": "emergency-only"
      },
      "workspace": {
        "current_work_branch": null,
        "active_specifications": [],
        "workspace_state": "standby",
        "current_work": "Standby for emergency activation",
        "next_handoff": null,
        "pending_handoffs": []
      }
    },
    {
      "agent_id": "cli-claude-director-001",
      "display_name": "Claude Code CLI-Director",
      "short_name": "CDIR",
      "status": "active",
      "environment": "local-windows",
      "role": "designer-researcher",
      "identity_file": ".claude/identity-cli-director.json",
      "git_branch": "claude/design-three-agent-config",
      "first_active": "2025-11-13T00:00:00Z",
      "last_active": "2025-11-13T00:00:00Z",
      "coordination": {
        "message_prefix": "[From: CDIR]",
        "handoff_method": "specification-to-implementation"
      },
      "workspace": {
        "current_work_branch": "claude/design-three-agent-config",
        "active_specifications": [],
        "workspace_state": "designing",
        "current_work": "Three-agent migration configuration",
        "next_handoff": null,
        "pending_handoffs": []
      },
      "terminal": "PowerShell-Terminal-1"
    },
    {
      "agent_id": "cli-claude-executor-001",
      "display_name": "Claude Code CLI-Executor",
      "short_name": "CEXE",
      "status": "active",
      "environment": "local-windows",
      "role": "executor-validator",
      "identity_file": ".claude/identity-cli-executor.json",
      "git_branch": "main",
      "first_active": "2025-11-12T18:44:00Z",
      "last_active": "2025-11-12T21:45:00Z",
      "coordination": {
        "message_prefix": "[From: CEXE]",
        "handoff_method": "implementation-to-validation"
      },
      "workspace": {
        "current_work_branch": null,
        "active_specifications": [],
        "workspace_state": "idle",
        "current_work": "Awaiting specification handoff from CDIR",
        "next_handoff": null,
        "pending_handoffs": []
      },
      "terminal": "PowerShell-Terminal-2",
      "notes": "Identity configuration complete. Stage 1 operational. Git hooks configured. Three-environment coordination understood. Workspace coordination ready."
    }
  ],
```

**Also update:**
- `"registry_version"` to: `"3.0"`
- `"last_updated"` to current timestamp: `"2025-11-13T00:00:00Z"`

**Add to `"metadata"."changelog"`:**
```json
    "3.0": {
      "date": "2025-11-13",
      "changes": [
        "Added CDIR (cli-claude-director-001) as primary designer",
        "Updated Web to standby-emergency role",
        "Renamed CLI to CEXE (cli-claude-executor-001)",
        "Added terminal tracking for local agents",
        "Three-agent architecture operational"
      ],
      "related": "ADR-012 (Three-Agent Architecture Migration)"
    }
```

**Save the file.**

**Validate JSON:**
```powershell
python -m json.tool .claude\agent-registry.json | Out-Null
if ($?) { Write-Host "✓ Valid JSON" -ForegroundColor Green } else { Write-Host "✗ Invalid JSON" -ForegroundColor Red }
```

---

## Step 8: Update Project Configuration

**Open `config\project.yml` in your text editor**

**Find the `team:` section and replace with:**

```yaml
team:
  human_partner:
    role: "Strategic Partner"
    responsibilities:
      - "Set strategic direction"
      - "Validate alignment with vision"
      - "Approve major architectural decisions"
      - "Provide domain context AI cannot infer"
      - "Coordinate between CDIR and CEXE agents"
    technical_level: "non-technical"

  ai_agents:
    primary_designer:
      agent_id: "cli-claude-director-001"
      display_name: "Claude Code CLI-Director (CDIR)"
      role: "designer-researcher"
      terminal: "PowerShell-Terminal-1"
      environment: "Windows PowerShell"
      responsibilities:
        - "Create specifications and requirements"
        - "Design architecture and make ADRs"
        - "Maintain documentation"
        - "Conduct research and validation"
        - "Hand off specs to CEXE for implementation"

    primary_executor:
      agent_id: "cli-claude-executor-001"
      display_name: "Claude Code CLI-Executor (CEXE)"
      role: "executor-validator"
      terminal: "PowerShell-Terminal-2"
      environment: "Windows PowerShell"
      responsibilities:
        - "Implement features from CDIR specifications"
        - "Create technical plans and task decomposition"
        - "Write and execute tests"
        - "Validate implementations"
        - "Hand off results to CDIR for validation"

    standby_support:
      agent_id: "web-claude-designer-001"
      display_name: "Claude Code Web"
      role: "standby-emergency"
      status: "standby"
      environment: "Browser-based"
      responsibilities:
        - "Emergency backup if CDIR unavailable"
        - "Research support when requested"
```

**Save the file.**

**Validate YAML (optional):**
```powershell
python -c "import yaml; yaml.safe_load(open('config\\project.yml'))"
if ($?) { Write-Host "✓ Valid YAML" -ForegroundColor Green } else { Write-Host "✗ Invalid YAML" -ForegroundColor Red }
```

---

## Step 9: Commit Configuration Changes

```powershell
git add .claude\identity-cli-director.json
git add .claude\identity-cli-executor.json
git add .claude\identity-web.json
git add .claude\agent-registry.json
git add config\project.yml
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CDIR] Phase 2: Three-agent configuration migration

- Created CDIR identity (cli-claude-director-001)
- Renamed CLI to CEXE identity (cli-claude-executor-001)
- Updated Web to standby-emergency role
- Updated agent registry to v3.0 (three agents)
- Updated project.yml team structure

Migration Phase: 2 of 9
Next: Phase 3 - Workspace Coordination Update

Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/design-three-agent-config
Environment: Windows PowerShell at C:\Development\perplex
"
```

---

## Step 10: Create Phase 2 Marker

```powershell
"Phase 2 complete: $(Get-Date)" | Set-Content -Path .claude\migration-phase-2-complete.txt
cat .claude\migration-phase-2-complete.txt
```

---

## Validation Checklist

- [ ] `.claude\identity-cli-executor.json` exists (renamed from identity-cli.json)
- [ ] CEXE identity has agent_id: `cli-claude-executor-001`
- [ ] CEXE identity has short_name: `CEXE`
- [ ] CEXE identity has terminal: `PowerShell-Terminal-2`
- [ ] CEXE identity has spec_kit section
- [ ] CEXE identity has workspace section
- [ ] Web identity has role: `standby-emergency`
- [ ] Web identity has status: `standby`
- [ ] Web identity has autonomy_level: `medium`
- [ ] Agent registry has 3 agents (Web, CDIR, CEXE)
- [ ] Agent registry version: `3.0`
- [ ] CDIR entry in registry shows current branch
- [ ] CEXE entry in registry shows terminal: `PowerShell-Terminal-2`
- [ ] Project.yml has three-agent team structure
- [ ] Project.yml shows Windows PowerShell environment
- [ ] All JSON files validate correctly
- [ ] YAML file validates correctly
- [ ] Changes committed to git
- [ ] Phase 2 marker created

---

## If Validation Fails

**Problem: JSON syntax error**
- Open file in VS Code (has JSON validation)
- Look for: missing commas, extra commas, unclosed braces
- Use `python -m json.tool file.json` to find exact line
- Fix and re-validate

**Problem: Can't find file**
- Use `pwd` to verify you're in `C:\Development\perplex`
- Use `ls .claude\` to see what files exist
- Check file name spelling (Windows is case-insensitive but be consistent)

**Problem: Git commit fails**
- Check `git status` to see what's staged
- Ensure all required files are added
- Check commit message format (use quotes around message)

---

## Announce Completion

```
[From: CDIR] Phase 2 COMPLETE. Configuration migrated to three-agent architecture.

Changes:
- CDIR identity established (you, PowerShell-Terminal-1)
- CEXE identity updated (executor, PowerShell-Terminal-2)
- Web identity transitioned to standby
- Agent registry updated to v3.0 (three agents)
- Project configuration reflects new team structure

Validation: PASSED (all JSON/YAML valid, git committed)

Environment: Windows PowerShell at C:\Development\perplex
Ready for Phase 3: Workspace Coordination Update
```

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001
**Environment:** Windows PowerShell
**Project Path:** C:\Development\perplex
**Phase:** 2 of 9
**Next:** Phase 3 - Workspace Coordination Update

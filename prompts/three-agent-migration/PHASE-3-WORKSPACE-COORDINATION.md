# Phase 3: Workspace Coordination Update

**Agent:** CLI-Director (CDIR)
**Prerequisites:** Phase 2 complete (three-agent configuration updated)
**Execution Environment:** PowerShell Terminal Window 1
**OS:** Windows
**Project Path:** `C:\Development\perplex`
**Branch:** `claude/design-three-agent-config` (continue)
**Duration Estimate:** 45-60 minutes

---

## IMPORTANT: Environment Setup

**You are running on Windows with PowerShell.**

**File Editing:** The workspace coordination YAML file is complex and should be edited in a text editor (VS Code, Notepad++, etc.) rather than PowerShell commands. I'll provide the complete YAML structure.

**PowerShell Commands:** Used for file operations (copy, validation) and git commands.

---

## Mission

Rewrite `.claude\workspace-coordination.yml` to define three-agent workspace boundaries, handoff triggers, and emergency procedures.

---

## Step 1: Verify Phase 2 Complete

```powershell
cat .claude\migration-phase-2-complete.txt
git log --oneline -1 | Select-String "Phase 2"
```

Should show Phase 2 marker and recent Phase 2 commit.

---

## Step 2: Backup Existing Workspace Manifest

```powershell
cp .claude\workspace-coordination.yml .claude\workspace-coordination.yml.backup
ls .claude\workspace-coordination.yml.backup
```

Verify backup created.

---

## Step 3: Read Migration Architecture Reference

```powershell
cat docs\THREE_AGENT_MIGRATION_ARCHITECTURE.md | Select-String -Context 0,200 "Subsystem 2: Workspace Coordination"
```

Review the architecture document's guidance on workspace coordination for three agents.

---

## Step 4: Rewrite Workspace Coordination YAML

**Open `.claude\workspace-coordination.yml` in your text editor (VS Code, Notepad++, etc.)**

**Replace the entire file with:**

```yaml
# Workspace Coordination - Three-Agent Architecture
# Defines ownership boundaries, handoff triggers, and emergency procedures
# Schema Version: 2.0 (Three agents: CDIR, CEXE, Web)

schema_version: "2.0"
last_updated: "2025-11-13T00:00:00Z"
migration_version: "three-agent-v1"

# ========================================
# Agent Workspace Boundaries
# ========================================

agents:
  cli-claude-director-001:
    display_name: "Claude Code CLI-Director (CDIR)"
    short_name: "CDIR"
    role: "designer-researcher"
    status: "active"
    terminal: "PowerShell-Terminal-1"

    primary_ownership:
      # Design and specification artifacts
      - "decisions/"
      - "requirements/"
      - "docs/"
      - "ideas/"
      - "specs/*/spec.md"
      - ".specify/memory/constitution.md"

    read_access:
      # Can read everything for research and validation
      - "**/*"

    write_restrictions:
      # Should NOT directly write to implementation artifacts
      - "src/"
      - "tests/"
      - "specs/*/plan.md"
      - "specs/*/tasks.md"
      - "specs/*/implementation/"

    branch_pattern: "claude/design-*"
    branch_naming: "claude/design-{description}-{timestamp}"

    decision_scope:
      - "architecture"
      - "research"
      - "documentation"
      - "design"
      - "strategic-planning"
      - "requirements"
      - "specifications"

    spec_kit_commands:
      allowed:
        - "/speckit.constitution"
        - "/speckit.specify"
        - "/speckit.clarify"
        - "/speckit.analyze"
        - "/speckit.checklist"
      prohibited:
        - "/speckit.plan"
        - "/speckit.tasks"
        - "/speckit.implement"

      workflow_stage: "Phase 0: Specification"

    handoff_responsibilities:
      gives_to_cexe:
        - "Completed specifications (spec.md)"
        - "Validated requirements"
        - "Success criteria defined"
        - "Architecture decisions (ADRs)"
      receives_from_cexe:
        - "Technical plans for validation"
        - "Implementation results for review"
        - "Questions about specifications"

  cli-claude-executor-001:
    display_name: "Claude Code CLI-Executor (CEXE)"
    short_name: "CEXE"
    role: "executor-validator"
    status: "active"
    terminal: "PowerShell-Terminal-2"

    primary_ownership:
      # Implementation artifacts
      - "src/"
      - "tests/"
      - "specs/*/plan.md"
      - "specs/*/tasks.md"
      - "specs/*/implementation/"

    read_access:
      # Can read everything (needs specs, ADRs, docs for context)
      - "**/*"

    write_restrictions:
      # Should NOT directly write to design artifacts
      - "decisions/"
      - "requirements/"
      - "specs/*/spec.md"
      - ".specify/memory/constitution.md"
      - "docs/" # Can update implementation-related docs only after CDIR approval

    branch_pattern: "claude/impl-*"
    branch_naming: "claude/impl-{description}-{timestamp}"

    decision_scope:
      - "implementation"
      - "testing"
      - "validation"
      - "troubleshooting"
      - "local-execution"
      - "technical-decomposition"

    spec_kit_commands:
      allowed:
        - "/speckit.plan"
        - "/speckit.tasks"
        - "/speckit.implement"
        - "/speckit.analyze"
        - "/speckit.checklist"
      prohibited:
        - "/speckit.constitution"
        - "/speckit.specify"
        - "/speckit.clarify"

      workflow_stage: "Phase 1-3: Planning, Tasks, Implementation"

    handoff_responsibilities:
      receives_from_cdir:
        - "Completed specifications"
        - "Validated requirements"
        - "Success criteria"
      gives_to_cdir:
        - "Technical plans (for validation)"
        - "Implementation results"
        - "Test results"
        - "Questions about specifications"

  web-claude-designer-001:
    display_name: "Claude Code Web"
    short_name: "Web"
    role: "standby-emergency"
    status: "standby"
    environment: "browser"

    primary_ownership: []
    # Standby agent has no primary ownership
    # Only activates in emergency when CDIR unavailable

    read_access:
      # Can read everything when activated
      - "**/*"

    emergency_write_access:
      # When activated as emergency backup for CDIR
      - "decisions/"
      - "requirements/"
      - "docs/"
      - "ideas/"
      - "specs/*/spec.md"

    branch_pattern: "claude/web-emergency-*"
    branch_naming: "claude/web-emergency-{description}-{timestamp}"

    emergency_only: true

    activation_trigger:
      condition: "CDIR unavailable for >24 hours"
      procedure:
        - "User manually activates Web"
        - "Web updates agent registry status to 'active'"
        - "Web creates emergency branch"
        - "Web assumes CDIR responsibilities temporarily"

    handback_procedure:
      - "CDIR announces return"
      - "CDIR reviews Web's emergency work"
      - "CDIR integrates or reverts as needed"
      - "Web updates registry status to 'standby'"
      - "Web returns to inactive state"

# ========================================
# Coordination Protocols
# ========================================

coordination:
  handoff_triggers:
    spec_complete:
      from: "cli-claude-director-001"
      to: "cli-claude-executor-001"
      artifact: "specs/NNN-feature-name/spec.md"
      signal: "Update agent registry: spec ready for CEXE"
      next_action: "CEXE: Read spec, create plan"

    plan_complete:
      from: "cli-claude-executor-001"
      to: "cli-claude-director-001"
      artifact: "specs/NNN-feature-name/plan.md"
      signal: "Update agent registry: plan ready for CDIR validation"
      next_action: "CDIR: Review plan against spec"

    plan_validated:
      from: "cli-claude-director-001"
      to: "cli-claude-executor-001"
      artifact: "Plan validation note in agent registry"
      signal: "CDIR approves plan"
      next_action: "CEXE: Create tasks, begin implementation"

    implementation_complete:
      from: "cli-claude-executor-001"
      to: "cli-claude-director-001"
      artifact: "specs/NNN-feature-name/implementation/"
      signal: "Update agent registry: implementation ready for validation"
      next_action: "CDIR: Validate against spec success criteria"

  handoff_markers:
    location: ".claude/handoffs/"
    format: "handoff-{timestamp}-{from}-{to}.json"
    content:
      - "from_agent"
      - "to_agent"
      - "artifact_path"
      - "message"
      - "timestamp"
      - "next_action"

  communication_pattern: "envelope"
  message_prefixes:
    cdir: "[From: CDIR]"
    cexe: "[From: CEXE]"
    web: "[From: Web]"

# ========================================
# Spec Kit Integration
# ========================================

spec_kit:
  artifact_ownership:
    constitution:
      owner: "cli-claude-director-001"
      file: ".specify/memory/constitution.md"
      command: "/speckit.constitution"

    specification:
      owner: "cli-claude-director-001"
      file: "specs/*/spec.md"
      command: "/speckit.specify"

    plan:
      owner: "cli-claude-executor-001"
      file: "specs/*/plan.md"
      command: "/speckit.plan"

    tasks:
      owner: "cli-claude-executor-001"
      file: "specs/*/tasks.md"
      command: "/speckit.tasks"

    implementation:
      owner: "cli-claude-executor-001"
      directory: "specs/*/implementation/"
      command: "/speckit.implement"

  command_access:
    cli-claude-director-001:
      allowed:
        - "/speckit.constitution"
        - "/speckit.specify"
        - "/speckit.clarify"
        - "/speckit.analyze"
        - "/speckit.checklist"
      workflow: "Create specifications, clarify requirements, analyze consistency"

    cli-claude-executor-001:
      allowed:
        - "/speckit.plan"
        - "/speckit.tasks"
        - "/speckit.implement"
        - "/speckit.analyze"
        - "/speckit.checklist"
      workflow: "Create plans, decompose tasks, execute implementation"

    web-claude-designer-001:
      allowed: []
      emergency_allowed:
        - "/speckit.constitution"
        - "/speckit.specify"
        - "/speckit.clarify"
        - "/speckit.analyze"
      workflow: "Emergency backup only when CDIR unavailable"

# ========================================
# Enforcement
# ========================================

enforcement:
  local:
    mechanism: "git pre-commit hooks"
    checks:
      - "Verify agent identity exists"
      - "Check branch pattern matches agent role"
      - "Validate workspace boundaries (warn only)"
      - "Enforce primary ownership (block violations)"

    branch_patterns:
      cli-claude-director-001: "claude/design-*"
      cli-claude-executor-001: "claude/impl-*"
      web-claude-designer-001: "claude/web-emergency-*"

    violations:
      action: "warn"
      message: "Check workspace coordination: agent may be outside boundaries"
      block: false  # Initially warn-only, can change to block later

  github:
    mechanism: "GitHub Actions workflow"
    checks:
      - "Verify PR from correct agent branch pattern"
      - "Check files changed align with agent ownership"
      - "Validate Spec Kit artifact ownership"

    violations:
      action: "comment"
      message: "Workspace boundary check: review recommended"

# ========================================
# Emergency Procedures
# ========================================

emergency_procedures:
  web_activation:
    trigger: "CDIR unavailable for >24 hours"

    activation:
      - step: "User manually activates Web"
      - step: "Web reads agent registry and latest checkpoint"
      - step: "Web updates registry status to 'active'"
      - step: "Web creates branch: claude/web-emergency-{description}"
      - step: "Web assumes CDIR responsibilities"
      - step: "Web documents all actions clearly"

    during_emergency:
      - "Web operates as designer-researcher"
      - "Web coordinates with CEXE via agent registry"
      - "Web maintains envelope communication format"
      - "Web documents reason for emergency activation"

    handback:
      - step: "CDIR announces return"
      - step: "CDIR reads agent registry and Web's emergency work"
      - step: "CDIR reviews Web's branch and commits"
      - step: "CDIR integrates work or requests changes"
      - step: "CDIR updates agent registry"
      - step: "Web updates status to 'standby'"
      - step: "Web returns to inactive state"

    notes:
      - "Emergency activation is manual (user-initiated)"
      - "Web should preserve CDIR's patterns and conventions"
      - "Handback should be smooth, not disruptive"

# ========================================
# Metadata
# ========================================

metadata:
  schema_history:
    "1.0":
      date: "2025-11-12"
      description: "Initial workspace coordination (two agents)"
    "2.0":
      date: "2025-11-13"
      description: "Three-agent architecture (CDIR + CEXE + Web standby)"

  related_documents:
    - "docs/THREE_AGENT_MIGRATION_ARCHITECTURE.md"
    - "decisions/2025-11-13-three-agent-architecture-migration.md"
    - ".claude/identity-cli-director.json"
    - ".claude/identity-cli-executor.json"
    - ".claude/identity-web.json"
    - ".claude/agent-registry.json"

notes: >
  This workspace coordination system defines clear boundaries for three agents.
  CDIR owns design, CEXE owns implementation, Web is standby.
  Handoffs happen via agent registry and optional handoff markers.
  Emergency procedures ensure continuity if CDIR unavailable.
```

**Save the file.**

---

## Step 5: Validate YAML Syntax

```powershell
python -c "import yaml; yaml.safe_load(open('.claude\\workspace-coordination.yml'))"
if ($?) { Write-Host "✓ Valid YAML" -ForegroundColor Green } else { Write-Host "✗ Invalid YAML" -ForegroundColor Red }
```

If `python` not found, try:
```powershell
py -c "import yaml; yaml.safe_load(open('.claude\\workspace-coordination.yml'))"
```

**Note:** If Python not available, skip validation. YAML will be validated by git hooks later.

---

## Step 6: Update Agent Registry Workspace States

**Open `.claude\agent-registry.json` in your text editor**

**Find CDIR entry** (agent_id: "cli-claude-director-001") and update `workspace` section:

```json
"workspace": {
  "current_work_branch": "claude/design-three-agent-config",
  "active_specifications": [],
  "workspace_state": "designing",
  "current_work": "Workspace coordination update",
  "next_handoff": null,
  "pending_handoffs": []
}
```

**Find CEXE entry** (agent_id: "cli-claude-executor-001") and update `workspace` section:

```json
"workspace": {
  "current_work_branch": null,
  "active_specifications": [],
  "workspace_state": "idle",
  "current_work": "Awaiting specification handoff from CDIR",
  "next_handoff": null,
  "pending_handoffs": []
}
```

**Save the file.**

**Validate JSON:**
```powershell
python -m json.tool .claude\agent-registry.json | Out-Null
if ($?) { Write-Host "✓ Valid JSON" -ForegroundColor Green } else { Write-Host "✗ Invalid JSON" -ForegroundColor Red }
```

---

## Step 7: Commit Workspace Coordination Changes

```powershell
git add .claude\workspace-coordination.yml
git add .claude\agent-registry.json
git status
```

**Commit:**
```powershell
git commit --no-gpg-sign -m "[CDIR] Phase 3: Workspace coordination for three agents

- Rewrote workspace manifest for CDIR/CEXE/Web architecture
- CDIR owns: decisions/, docs/, requirements/, specs/*/spec.md
- CEXE owns: src/, tests/, specs/*/plan.md, specs/*/tasks.md
- Web: standby, emergency-only access
- Updated handoff triggers for three-agent workflow
- Defined Spec Kit command access matrix
- Added emergency Web activation procedures
- Updated agent registry workspace states

Migration Phase: 3 of 9
Next: Phase 4 - Automation & Hooks Update

Agent: CDIR (cli-claude-director-001)
Terminal: PowerShell-Terminal-1
Branch: claude/design-three-agent-config
Environment: Windows PowerShell at C:\Development\perplex
"
```

---

## Step 8: Create Phase 3 Marker

```powershell
"Phase 3 complete: $(Get-Date)" | Set-Content -Path .claude\migration-phase-3-complete.txt
cat .claude\migration-phase-3-complete.txt
```

---

## Validation Checklist

- [ ] Workspace YAML validates (no syntax errors)
- [ ] CDIR section exists with correct ownership (decisions/, docs/, requirements/, specs/*/spec.md)
- [ ] CEXE section exists with correct ownership (src/, tests/, specs/*/plan.md, tasks.md)
- [ ] Web section shows standby/emergency-only status
- [ ] Handoff triggers defined (spec_complete, plan_complete, plan_validated, implementation_complete)
- [ ] Spec Kit commands mapped correctly (CDIR: specify/clarify, CEXE: plan/tasks/implement)
- [ ] Emergency procedures documented
- [ ] Agent registry workspace states updated
- [ ] Changes committed to git
- [ ] Phase 3 marker created

---

## If Validation Fails

**Problem: YAML syntax error**
- Open in VS Code (has YAML validation)
- Look for: wrong indentation, missing colons, wrong list format
- Use `python -c "import yaml; yaml.safe_load(open('file.yml'))"` to find exact error
- Fix and re-validate

**Problem: JSON syntax error in agent registry**
- Use `python -m json.tool file.json` to find error
- Or open in VS Code (has JSON validation)
- Fix and re-validate

**Problem: Git commit fails**
- Check `git status` to see what's staged
- Ensure both workspace YAML and agent registry JSON are added
- Check commit message format

---

## Announce Completion

```
[From: CDIR] Phase 3 COMPLETE. Workspace coordination updated for three-agent architecture.

Workspace boundaries established:
- CDIR: decisions/, docs/, requirements/, specs/*/spec.md
- CEXE: src/, tests/, specs/*/plan.md, tasks.md, implementation/
- Web: standby (emergency-only)

Handoff workflow:
1. CDIR creates spec → hands off to CEXE
2. CEXE creates plan → hands back to CDIR for validation
3. CDIR validates plan → hands off to CEXE
4. CEXE implements → hands back to CDIR for final validation

Spec Kit integration:
- CDIR: /speckit.constitution, /speckit.specify, /speckit.clarify
- CEXE: /speckit.plan, /speckit.tasks, /speckit.implement

Emergency procedures documented for Web activation if CDIR unavailable.

Validation: PASSED (YAML and JSON valid, git committed)

Environment: Windows PowerShell at C:\Development\perplex
Ready for Phase 4: Automation & Hooks Update
```

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001
**Environment:** Windows PowerShell
**Project Path:** C:\Development\perplex
**Phase:** 3 of 9
**Next:** Phase 4 - Automation & Hooks Update

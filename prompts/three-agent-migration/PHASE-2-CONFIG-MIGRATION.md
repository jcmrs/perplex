# Phase 2: Configuration Migration

**Agent:** CLI-Director (CDIR)
**Prerequisites:** Phase 1 complete (identity-cli-director.json exists)
**Branch:** `claude/design-three-agent-config` (NEW)
**Duration Estimate:** 30-45 minutes

---

## Mission

Update all identity and configuration files to reflect three-agent architecture:
- CDIR (you) - Primary designer
- CEXE - Primary executor
- Web - Standby emergency

---

## Step 1: Verify Phase 1 Complete

```bash
cat .claude/migration-phase-1-complete.txt
cat .claude/identity-cli-director.json | grep "agent_id"
```

Should show Phase 1 marker and your agent_id: `cli-claude-director-001`.

---

## Step 2: Create Feature Branch

```bash
git checkout -b claude/design-three-agent-config
git status
```

You should be on new branch `claude/design-three-agent-config`.

---

## Step 3: Backup Existing Identity Files

```bash
cp .claude/identity-web.json .claude/identity-web.json.backup
cp .claude/identity-cli.json .claude/identity-cli.json.backup
cp .claude/agent-registry.json .claude/agent-registry.json.backup
ls -la .claude/*.backup
```

---

## Step 4: Rename CLI Identity to CEXE

```bash
mv .claude/identity-cli.json .claude/identity-cli-executor.json
ls -la .claude/identity-cli-executor.json
```

---

## Step 5: Update CEXE Identity

Edit `.claude/identity-cli-executor.json`:

**Changes needed:**
1. `agent_id`: `"cli-claude-executor-001"` (was probably generic)
2. `short_name`: `"CEXE"`
3. `display_name`: `"Claude Code CLI-Executor"`
4. `role`: `"executor-validator"` (should already be this)
5. Add `terminal: "Terminal-2"` to session_info
6. Add spec_kit section:
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
}
```
7. Add workspace section:
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
}
```
8. Update last_updated timestamp
9. Add `migration_phase: "phase-2"` to metadata

**Validate JSON:**
```bash
python -m json.tool .claude/identity-cli-executor.json > /dev/null && echo "✓ Valid" || echo "✗ Invalid"
```

---

## Step 6: Update Web Identity to Standby

Edit `.claude/identity-web.json`:

**Changes needed:**
1. `agent_id`: Keep as `"web-claude-designer-001"`
2. `short_name`: Keep as `"Web"`
3. `role`: Change to `"standby-emergency"`
4. `persona_profile.primary_function`: Change to `"Emergency backup designer, research support"`
5. `persona_profile.autonomy_level`: Change to `"medium"` (was "high")
6. `persona_profile.decision_scope`: Add only: `["emergency-support", "research-assistance"]`
7. Add to responsibilities.primary:
```json
"primary": [
  "Standby for emergency activation if CDIR unavailable",
  "Research support when requested by CDIR",
  "Backup designer role only",
  "Monitor agent registry for coordination"
]
```
8. Update `status` field (add if not present): `"standby"`
9. Update last_updated timestamp
10. Add `migration_phase: "phase-2"` to metadata

**Validate JSON:**
```bash
python -m json.tool .claude/identity-web.json > /dev/null && echo "✓ Valid" || echo "✗ Invalid"
```

---

## Step 7: Update Agent Registry

Edit `.claude/agent-registry.json`:

**Add CDIR entry** (insert between Web and CEXE):
```json
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
  "terminal": "Terminal-1"
}
```

**Update Web entry:**
```json
{
  "agent_id": "web-claude-designer-001",
  ...
  "status": "standby",
  "role": "standby-emergency",
  "workspace": {
    ...
    "workspace_state": "standby",
    "current_work": "Standby for emergency activation"
  }
}
```

**Update CEXE entry:**
```json
{
  "agent_id": "cli-claude-executor-001",
  ...
  "identity_file": ".claude/identity-cli-executor.json",
  ...
  "terminal": "Terminal-2"
}
```

**Update registry_version:** `"3.0"`

**Update last_updated:** Current timestamp

**Add to metadata.changelog:**
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

**Validate JSON:**
```bash
python -m json.tool .claude/agent-registry.json > /dev/null && echo "✓ Valid" || echo "✗ Invalid"
```

---

## Step 8: Update Project Configuration

Edit `config/project.yml`:

**Update `project.team` section:**
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
      terminal: "Terminal-1"
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
      terminal: "Terminal-2"
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
      responsibilities:
        - "Emergency backup if CDIR unavailable"
        - "Research support when requested"
```

---

## Step 9: Commit Configuration Changes

```bash
git add .claude/identity-cli-director.json
git add .claude/identity-cli-executor.json
git add .claude/identity-web.json
git add .claude/agent-registry.json
git add config/project.yml
git status
```

**Commit:**
```bash
git commit --no-gpg-sign -m "[CDIR] Phase 2: Three-agent configuration migration

- Created CDIR identity (cli-claude-director-001)
- Renamed CLI to CEXE identity (cli-claude-executor-001)
- Updated Web to standby-emergency role
- Updated agent registry to v3.0 (three agents)
- Updated project.yml team structure

Migration Phase: 2 of 9
Next: Phase 3 - Workspace Coordination Update

Agent: CDIR (cli-claude-director-001)
Terminal: Terminal-1
Branch: claude/design-three-agent-config
"
```

---

## Step 10: Create Phase 2 Marker

```bash
echo "Phase 2 complete: $(date)" > .claude/migration-phase-2-complete.txt
cat .claude/migration-phase-2-complete.txt
```

---

## Validation Checklist

- [ ] `.claude/identity-cli-executor.json` exists (renamed from identity-cli.json)
- [ ] CEXE identity has agent_id: `cli-claude-executor-001`
- [ ] CEXE identity has short_name: `CEXE`
- [ ] Web identity has role: `standby-emergency`
- [ ] Web identity has status: `standby`
- [ ] Agent registry has 3 agents (Web, CDIR, CEXE)
- [ ] Agent registry version: `3.0`
- [ ] CDIR entry in registry shows current branch
- [ ] Project.yml has three-agent team structure
- [ ] All JSON files validate correctly
- [ ] Changes committed to git
- [ ] Phase 2 marker created

---

## Announce Completion

```
[From: CDIR] Phase 2 COMPLETE. Configuration migrated to three-agent architecture.

Changes:
- CDIR identity established (you)
- CEXE identity updated (executor remains)
- Web identity transitioned to standby
- Agent registry updated to v3.0 (three agents)
- Project configuration reflects new team structure

Validation: PASSED (all JSON valid, git committed)

Ready for Phase 3: Workspace Coordination Update
```

---

**Prepared by:** web-claude-designer-001
**For:** cli-claude-director-001
**Phase:** 2 of 9
**Next:** Phase 3 - Workspace Coordination Update

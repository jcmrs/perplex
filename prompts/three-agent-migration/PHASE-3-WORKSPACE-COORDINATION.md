# Phase 3: Workspace Coordination Update

**Agent:** CDIR
**Prerequisites:** Phase 2 complete
**Branch:** `claude/design-three-agent-config` (continue)
**Duration:** 45-60 min

---

## Mission

Rewrite `.claude/workspace-coordination.yml` for three agents.

---

## Steps

### 1. Verify Phase 2 Complete
```bash
cat .claude/migration-phase-2-complete.txt
git log --oneline -1 | grep "Phase 2"
```

### 2. Backup Workspace Manifest
```bash
cp .claude/workspace-coordination.yml .claude/workspace-coordination.yml.backup
```

### 3. Read Migration Architecture Reference
```bash
cat docs/THREE_AGENT_MIGRATION_ARCHITECTURE.md | grep -A 200 "Subsystem 2: Workspace Coordination"
```

### 4. Rewrite Workspace Coordination YAML

Edit `.claude/workspace-coordination.yml`:

**Key changes:**
1. **Update schema version** to "2.0"
2. **Rename `web-claude-designer-001`** section to show standby role
3. **Add `cdir-claude-director-001`** section (NEW) with:
   - Primary ownership: `decisions/`, `docs/`, `requirements/`, `ideas/`, `specs/*/spec.md`
   - Branch pattern: `claude/design-*`
   - Decision scope: architecture, research, documentation, design, strategic-planning
   - Spec Kit allowed: constitution, specify, clarify, analyze, checklist

4. **Rename `cli-claude-executor-001`** section:
   - Keep all existing ownership (src/, tests/, specs/*/plan.md, etc.)
   - Update branch pattern: `claude/impl-*`
   - Spec Kit allowed: plan, tasks, implement, analyze, checklist

5. **Move Web to standby**:
   - Change primary_ownership → read_only (move everything to CDIR)
   - Update branch pattern: `claude/web-emergency-*`
   - Add emergency_only: true flag

6. **Update coordination.handoff_triggers**:
   - spec_complete: CDIR → CEXE
   - plan_complete: CEXE → CDIR (validation)
   - plan_validated: CDIR → CEXE
   - implementation_complete: CEXE → CDIR

7. **Update spec_kit.artifact_ownership**:
   - constitution: CDIR
   - specification: CDIR
   - plan: CEXE
   - tasks: CEXE
   - implementation: CEXE

8. **Update spec_kit.command_access**:
   - Add CDIR section (allowed: constitution, specify, clarify, analyze, checklist)
   - Update CEXE section (keep existing)
   - Remove or minimize Web section

9. **Update enforcement.local**:
   - Add CDIR validation logic
   - Update branch pattern enforcement

10. **Add emergency_procedures** section:
```yaml
emergency_procedures:
  web_activation:
    trigger: "CDIR unavailable for >24 hours"
    process:
      - "User manually activates Web"
      - "Web updates agent registry status to 'active'"
      - "Web creates branch: claude/web-emergency-*"
      - "Web assumes CDIR responsibilities temporarily"
    handback:
      - "CDIR announces return"
      - "CDIR reviews Web's emergency work"
      - "Web returns to standby status"
```

**Full YAML structure** (refer to docs/THREE_AGENT_MIGRATION_ARCHITECTURE.md Subsystem 2 for complete template).

### 5. Validate YAML Syntax
```bash
python -c "import yaml; yaml.safe_load(open('.claude/workspace-coordination.yml'))" && echo "✓ Valid YAML" || echo "✗ Invalid YAML"
```

### 6. Update Agent Registry Workspace States

Edit `.claude/agent-registry.json`:

**For CDIR (you):**
```json
"workspace": {
  "current_work_branch": "claude/design-three-agent-config",
  "active_specifications": [],
  "workspace_state": "designing",
  "current_work": "Workspace coordination update",
  ...
}
```

**For CEXE:**
```json
"workspace": {
  "current_work_branch": null,
  "active_specifications": [],
  "workspace_state": "idle",
  "current_work": "Awaiting CDIR specification handoff",
  ...
}
```

### 7. Commit
```bash
git add .claude/workspace-coordination.yml
git add .claude/agent-registry.json
git commit --no-gpg-sign -m "[CDIR] Phase 3: Workspace coordination for three agents

- Rewrote workspace manifest for CDIR/CEXE/Web
- CDIR owns: decisions/, docs/, requirements/, specs/*/spec.md
- CEXE owns: src/, tests/, specs/*/plan.md, specs/*/tasks.md
- Web: standby, emergency-only access
- Updated handoff triggers for three-agent workflow
- Updated Spec Kit command access matrix
- Added emergency Web activation procedures

Migration Phase: 3 of 9
Agent: CDIR
"
```

### 8. Create Phase Marker
```bash
echo "Phase 3 complete: $(date)" > .claude/migration-phase-3-complete.txt
```

---

## Validation

- [ ] Workspace YAML validates (no syntax errors)
- [ ] CDIR section exists with correct ownership
- [ ] CEXE section updated with impl branch pattern
- [ ] Web section shows standby/emergency-only
- [ ] Handoff triggers defined for CDIR ↔ CEXE
- [ ] Spec Kit commands mapped correctly
- [ ] Emergency procedures documented
- [ ] Agent registry workspace states updated
- [ ] Changes committed

---

## Announce
```
[From: CDIR] Phase 3 COMPLETE. Workspace coordination updated for three agents.

Workspace boundaries:
- CDIR: decisions/, docs/, requirements/, specs/*/spec.md
- CEXE: src/, tests/, specs/*/plan.md, tasks.md
- Web: standby (emergency-only)

Handoffs: CDIR → CEXE → CDIR validation loop established
Ready for Phase 4: Automation & Hooks Update
```

---

**Phase:** 3 of 9
**Next:** Phase 4 - Automation & Hooks

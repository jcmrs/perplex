# Phase 5: Documentation Update

**Agent:** CDIR
**Prerequisites:** Phase 4 complete
**Branch:** `claude/design-three-agent-config` (continue)
**Duration:** 60-90 min

---

## Mission

Update all documentation to reflect three-agent architecture.

---

## Files to Update

### Core Documents
1. `CLAUDE.md` - Session protocols
2. `FOUNDATION.md` - Team structure
3. `README.md` - Project overview
4. `CONTRIBUTING.md` - Collaboration guide

### Identity Documentation
5. `docs/IDENTITY_SETUP_PROMPT_CDIR.md` - NEW
6. `docs/IDENTITY_SETUP_PROMPT_CEXE.md` - Rename from CLI
7. `docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md`
8. `docs/THREE_ENVIRONMENT_COORDINATION.md` - Now two environments
9. `docs/AGENT_WORKSPACE_COORDINATION.md`

---

## Step-by-Step

### 1. Verify Phase 4
```bash
cat .claude/migration-phase-4-complete.txt
```

### 2. Update `CLAUDE.md`

**Critical sections:**

**A. Session Start Protocol (Step 0):**
```markdown
0. **Anchor your identity:**
   ```bash
   # If you're CDIR (Terminal 1)
   cat .claude/identity-cli-director.json

   # If you're CEXE (Terminal 2)
   cat .claude/identity-cli-executor.json

   # If you're Web (emergency only)
   cat .claude/identity-web.json

   # Check all active agents
   cat .claude/agent-registry.json
   ```

   **Quick self-check:**
   - What's your agent_id? (CDIR: cli-claude-director-001, CEXE: cli-claude-executor-001)
   - What's your short_name? (CDIR, CEXE, or Web)
   - What's your terminal? (Terminal-1, Terminal-2, or browser)
   - Who else is active? (check agent registry)
```

**B. Spec-Driven Development Commands:**
```markdown
**Spec-Driven Development (CDIR and CEXE only):**

**CDIR commands (Terminal-1):**
```bash
/speckit.constitution     # Establish project principles (one-time)
/speckit.specify "Feature" # Create feature specification
/speckit.clarify          # Optional: max 3 clarifying questions
/speckit.analyze          # Validate cross-artifact consistency
/speckit.checklist        # Quality validation
```

**CEXE commands (Terminal-2):**
```bash
/speckit.plan            # Generate technical plan from spec
/speckit.tasks           # Break down into atomic tasks
/speckit.implement       # Execute implementation
/speckit.analyze         # Validate cross-artifact consistency
/speckit.checklist       # Quality validation
```

**Workflow:**
1. CDIR creates spec.md → handoff to CEXE
2. CEXE creates plan.md → handoff to CDIR for validation
3. CDIR validates → handoff back to CEXE
4. CEXE creates tasks.md → implements
5. CEXE completes → handoff to CDIR for validation
```

**C. Multi-Agent Coordination:**
```markdown
**Active Agents:**
- **CDIR (Terminal-1):** Primary designer, creates specifications
- **CEXE (Terminal-2):** Primary executor, implements specifications
- **Web (Standby):** Emergency backup, research support

**Communication:** Use envelope format
- `[From: CDIR]` - Designer messages
- `[From: CEXE]` - Executor messages
- `[From: Web]` - Web messages (rare, emergency only)

**Coordination:** Via agent registry (`.claude/agent-registry.json`) and handoff markers (`.claude/handoffs/*.json`)
```

### 3. Update `FOUNDATION.md`

**Section 4: Methodologies** - Add agent responsibilities:
```markdown
**Implementation Level - Spec-Driven Development:**
- **CDIR executes:** `/speckit.constitution`, `/speckit.specify`, `/speckit.clarify`
- **CEXE executes:** `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`
- **Coordination:** CDIR → CEXE (spec complete), CEXE → CDIR (validation)
```

### 4. Update `README.md`

**Team section:**
```markdown
## AI-First Development Team

**Primary Designer:** Claude Code CLI-Director (CDIR)
- Terminal-1, Local Windows Environment
- Creates specifications, ADRs, documentation
- Defines what to build and success criteria

**Primary Executor:** Claude Code CLI-Executor (CEXE)
- Terminal-2, Local Windows Environment
- Implements features, writes tests, validates
- Executes specifications from CDIR

**Standby Support:** Claude Code Web
- Browser-based, limited access
- Emergency backup if CDIR unavailable
- Research support when requested
```

### 5. Update `CONTRIBUTING.md`

Add section: "Working with Multiple AI Agents"
- How to coordinate between CDIR and CEXE
- When to use which agent
- Handoff procedures
- Emergency Web activation

### 6. Create `docs/IDENTITY_SETUP_PROMPT_CDIR.md`

**Copy template from Phase 1 prompt** (already created for CDIR identity).
Add complete setup guide for CDIR including:
- Identity configuration
- Workspace coordination
- Session protocols
- Spec Kit integration
- Coordination with CEXE

### 7. Rename and Update CEXE Identity Doc

```bash
mv docs/IDENTITY_SETUP_PROMPT_CLI.md docs/IDENTITY_SETUP_PROMPT_CEXE.md
```

Edit `docs/IDENTITY_SETUP_PROMPT_CEXE.md`:
- Update for CEXE (executor) identity
- Clarify role: implementation, not design
- Update Spec Kit commands (plan, tasks, implement)
- Add coordination with CDIR

### 8. Update Multi-Agent Coordination Docs

**`docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md`:**
- Add CDIR as primary designer
- Update coordination patterns (CDIR ↔ CEXE)
- Document Web transition to standby

**`docs/THREE_ENVIRONMENT_COORDINATION.md`:**
- Rename to TWO_ENVIRONMENT_COORDINATION.md (Web standby = not active environment)
- Document CDIR + CEXE (both local, different terminals)
- Remove Web from primary coordination (move to emergency section)

**`docs/AGENT_WORKSPACE_COORDINATION.md`:**
- Update ownership tables (CDIR owns design, CEXE owns implementation)
- Update handoff procedures (three-agent workflow)
- Add emergency Web activation procedures

### 9. Commit

```bash
git add CLAUDE.md
git add FOUNDATION.md
git add README.md
git add CONTRIBUTING.md
git add docs/IDENTITY_SETUP_PROMPT_CDIR.md
git add docs/IDENTITY_SETUP_PROMPT_CEXE.md
git add docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md
git add docs/THREE_ENVIRONMENT_COORDINATION.md
git add docs/AGENT_WORKSPACE_COORDINATION.md

git commit --no-gpg-sign -m "[CDIR] Phase 5: Documentation for three-agent architecture

- Updated CLAUDE.md (session protocols, three agents)
- Updated FOUNDATION.md (team structure, Spec Kit roles)
- Updated README.md (agent roster)
- Updated CONTRIBUTING.md (multi-agent coordination)
- Created IDENTITY_SETUP_PROMPT_CDIR.md
- Renamed/updated IDENTITY_SETUP_PROMPT_CEXE.md
- Updated multi-agent coordination documentation
- Updated workspace coordination documentation

All documentation now reflects CDIR/CEXE/Web architecture.

Migration Phase: 5 of 9
Agent: CDIR
"
```

### 10. Create Phase Marker
```bash
echo "Phase 5 complete: $(date)" > .claude/migration-phase-5-complete.txt
```

---

## Validation

- [ ] CLAUDE.md reflects three agents in session protocol
- [ ] FOUNDATION.md shows Spec Kit command distribution
- [ ] README.md lists three agents with roles
- [ ] CONTRIBUTING.md explains multi-agent coordination
- [ ] CDIR identity setup prompt exists
- [ ] CEXE identity setup prompt updated
- [ ] Multi-agent coordination docs updated
- [ ] All documentation consistent
- [ ] Changes committed

---

## Announce

```
[From: CDIR] Phase 5 COMPLETE. Documentation updated for three-agent architecture.

Core documents:
- CLAUDE.md: Session protocols for CDIR/CEXE/Web
- FOUNDATION.md: Team structure and Spec Kit workflow
- README.md: Agent roster
- CONTRIBUTING.md: Multi-agent collaboration guide

Identity documentation:
- CDIR setup guide created
- CEXE setup guide updated
- Coordination patterns documented

Ready for Phase 6: GitHub Workflows Update
```

---

**Phase:** 5 of 9
**Next:** Phase 6 - GitHub Workflows

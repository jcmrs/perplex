# Windows Conversion Audit - Three-Agent Migration

**Date:** 2025-11-13
**Auditor:** web-claude-designer-001
**Issue:** All prompts created with Linux/bash assumptions, user is on Windows PowerShell
**User Environment:** Windows PowerShell at `C:\Development\perplex`

---

## Critical Errors Found

### 1. Path Assumptions (ALL FILES)

**Error:** Used Linux path `/home/user/perplex`
**Reality:** Windows path `C:\Development\perplex`

**Affected Files:**
- ✅ PHASE-1-CDIR-IDENTITY-SETUP.md (FIXED)
- ❌ PHASE-2-CONFIG-MIGRATION.md
- ❌ PHASE-3-WORKSPACE-COORDINATION.md
- ❌ PHASE-4-AUTOMATION-HOOKS.md
- ❌ PHASE-5-DOCUMENTATION.md
- ❌ PHASE-6-GITHUB-WORKFLOWS.md
- ❌ PHASE-7-VALIDATION-TESTING.md
- ❌ PHASE-8-PRODUCTION-ACTIVATION.md
- ❌ PHASE-9-WEB-HANDOFF-STANDBY.md
- ❌ README.md
- ❌ docs/THREE_AGENT_MIGRATION_ARCHITECTURE.md

**Fix Required:** Replace ALL instances of `/home/user/perplex` with `C:\Development\perplex`

### 2. Shell Assumptions (ALL FILES)

**Error:** Used bash/Linux shell commands
**Reality:** PowerShell terminal

**Bash Commands Used (Need PowerShell Equivalents):**
- `cd /path` → `cd C:\path` (works but use Windows style)
- `ls dir/` → `ls dir\` or `Get-ChildItem dir\`
- `cat file` → `cat file` or `Get-Content file` (cat is alias, works)
- `mkdir -p dir` → `mkdir dir` or `New-Item -ItemType Directory -Force`
- `rm file` → `rm file` or `Remove-Item`
- `cp file dest` → `cp file dest` or `Copy-Item`
- `mv file dest` → `mv file dest` or `Move-Item`
- `cat <<EOF` → DOES NOT WORK - need `@"..."@ | Set-Content`
- `&&` chaining → Use `;` or separate commands
- `||` → Use PowerShell conditionals
- `$VARIABLE` → `$env:VARIABLE` for env vars
- `export VAR=value` → `$env:VAR = "value"`
- `echo "text" > file` → `"text" | Set-Content file`
- `grep pattern` → `Select-String pattern`
- `head -n 20` → `Select-Object -First 20`
- `tail -n 20` → `Select-Object -Last 20`
- `jq` → May not be available, need alternatives
- `python -m json.tool` → Works if Python installed
- `$?` → `$?` (works in PowerShell too)
- `$(command)` → `$(command)` (works but PowerShell syntax)
- `/dev/null` → `Out-Null` or `> $null`

**Affected Files:** ALL phases + README

### 3. Path Separator Assumptions

**Error:** Used `/` for paths
**Reality:** Windows uses `\` (though PowerShell accepts both)

**Examples:**
- `.claude/file` → `.claude\file` (preferred Windows style)
- `docs/file.md` → `docs\file.md`
- `specs/*/spec.md` → `specs\*\spec.md`

**Best Practice:** Use `\` for consistency with Windows, though `/` works in PowerShell

### 4. Terminal References

**Error:** Referenced "Terminal 1" or "bash terminal"
**Reality:** "PowerShell Terminal Window 1"

**Fix:** All terminal references should say "PowerShell Terminal Window"

### 5. Environment Detection Assumptions

**Error:** Assumed tools available (jq, grep, sed, etc.)
**Reality:** Windows may not have these

**Tools That May Not Be Available:**
- `jq` - JSON query tool (not default on Windows)
- `grep` - Text search (use `Select-String`)
- `sed` - Stream editor (use PowerShell string manipulation)
- `awk` - Text processing (use PowerShell)
- `find` - File finding (use `Get-ChildItem -Recurse`)

**Fix:** Provide PowerShell alternatives or check for availability

### 6. Heredoc Usage (CRITICAL)

**Error:** Used bash heredocs extensively for creating files
**Example:**
```bash
cat > file.json <<EOF
{
  "key": "value"
}
EOF
```

**PowerShell Equivalent:**
```powershell
@"
{
  "key": "value"
}
"@ | Set-Content -Path file.json -Encoding UTF8
```

**CRITICAL:** The `$` character needs escaping in PowerShell heredocs: `` `$ ``

**Affected Files:**
- PHASE-1: Identity file creation (FIXED)
- PHASE-2: Multiple identity file edits
- PHASE-3: Workspace manifest edits
- PHASE-5: Creating markdown files
- PHASE-7: Creating spec files, handoff markers
- PHASE-8: Creating ADR, checkpoint files

### 7. Git Assumptions

**Error:** None - Git commands are identical
**Reality:** Git works the same on Windows

**Git Commands That Work:**
- `git status`, `git add`, `git commit`, `git push` - All work identically
- `git checkout`, `git branch`, `git merge` - All work
- `--no-gpg-sign` - Works

**No changes needed for git commands.**

### 8. Python Assumptions

**Error:** Assumed `python` command available
**Reality:** May be `python`, `python3`, or `py` on Windows

**Fix:**
```powershell
# Try python, fallback gracefully
if (Get-Command python -ErrorAction SilentlyContinue) {
    python -m json.tool file.json
} else {
    Write-Host "Python not found, skipping JSON validation"
}
```

### 9. File Creation Methods

**Error:** Mixed approaches (echo, cat, heredocs)
**Reality:** Need consistent PowerShell approach

**Best Practices for PowerShell:**
- Small text: `"content" | Set-Content file.txt`
- Multi-line: `@"..."@ | Set-Content file.txt`
- Complex JSON: Use text editor + manual save
- Prefer: `-Encoding UTF8` for all text files

### 10. Directory Separator in Identity/Config Files

**Error:** JSON/YAML files contain `/` path separators
**Reality:** These should probably use `/` (portable) OR `\\` (Windows escaped)

**Example in identity file:**
```json
"workspace": {
  "primary_ownership": [
    "decisions/",      # This is OK (portable)
    "docs/"            # This is OK
  ]
}
```

**Decision:** Keep `/` in JSON/YAML files (portable), use `\` in PowerShell commands

### 11. Web Environment References

**Error:** Some places reference "local" vs "web" but don't clarify Windows
**Reality:** Should always specify "Windows PowerShell" for local agents

**Fix:** Clarify agent environment consistently:
- CDIR: "Windows PowerShell Terminal 1 at C:\Development\perplex"
- CEXE: "Windows PowerShell Terminal 2 at C:\Development\perplex"
- Web: "Browser (standby)"

---

## Files Requiring Complete Regeneration

### High Priority (Execution Critical)

1. ✅ **PHASE-1-CDIR-IDENTITY-SETUP.md** - FIXED
2. ❌ **PHASE-2-CONFIG-MIGRATION.md** - Needs complete rewrite
3. ❌ **PHASE-3-WORKSPACE-COORDINATION.md** - Needs complete rewrite
4. ❌ **PHASE-4-AUTOMATION-HOOKS.md** - Needs complete rewrite (shell scripts!)
5. ❌ **PHASE-5-DOCUMENTATION.md** - Needs complete rewrite
6. ❌ **PHASE-6-GITHUB-WORKFLOWS.md** - Minimal changes (GitHub Actions)
7. ❌ **PHASE-7-VALIDATION-TESTING.md** - Needs complete rewrite (two terminals)
8. ❌ **PHASE-8-PRODUCTION-ACTIVATION.md** - Needs complete rewrite
9. ❌ **PHASE-9-WEB-HANDOFF-STANDBY.md** - My environment, minimal changes

### Medium Priority (Reference Documentation)

10. ❌ **README.md** - Needs update for Windows instructions
11. ❌ **docs/THREE_AGENT_MIGRATION_ARCHITECTURE.md** - Needs environment clarification

---

## Additional Issues Found

### Issue: Shell Script Modifications (Phase 4)

**Problem:** Phase 4 instructs CDIR to modify `.sh` bash scripts
**Reality:** These scripts run in Git Bash/WSL context, NOT PowerShell

**Files affected:**
- `tools/agent-start-work.sh`
- `tools/agent-handoff.sh`
- `tools/agent-check-registry.sh`
- `tools/ensure-claude-branch.sh`
- `.githooks/pre-commit`
- `.githooks/pre-push`

**Critical Question:** How do Git hooks work on Windows?
- Git Bash executes `.sh` hooks (uses its own bash interpreter)
- PowerShell doesn't execute these directly
- User modifies `.sh` files but they run in Git Bash environment

**Fix Required:**
- Phase 4 instructions should clarify: editing .sh files in text editor
- Scripts themselves remain bash (for Git Bash execution)
- Testing hooks: requires committing (hooks run via Git Bash automatically)

### Issue: Two Terminal Windows Coordination

**Problem:** Phase 7 requires opening "Terminal 2"
**Reality:** User opens second PowerShell window

**Instructions needed:**
- How to open second PowerShell window (Windows-specific)
- How to navigate to same project in both windows
- How CDIR (Terminal 1) and CEXE (Terminal 2) coordinate

### Issue: MCP and Spec Kit Installation

**Problem:** Migration assumes MCP and Spec Kit already installed
**Reality:** Need to verify these work on Windows

**From previous session logs:** CLI already has MCP (basic-memory) and Spec Kit installed

**Assumption:** These are operational, but should be noted in prerequisites

---

## Systematic Fix Plan

### Step 1: Regenerate All Phase Prompts (Phases 1-9)

**For each phase:**
1. Completely rewrite from scratch
2. Use PowerShell syntax throughout
3. Use Windows path: `C:\Development\perplex`
4. Use `\` for path separators in commands
5. Use `@"..."@ | Set-Content` for file creation
6. Provide PowerShell conditionals where needed
7. Note when editing .sh files (Phase 4)
8. Clarify Git Bash vs PowerShell context

### Step 2: Update README

**Changes needed:**
- Prerequisites section: clarify PowerShell requirement
- Environment setup: Windows-specific instructions
- Path references: all use `C:\Development\perplex`
- Command examples: all use PowerShell syntax
- Troubleshooting: Windows-specific issues

### Step 3: Update Architecture Document

**Changes needed:**
- Environment clarification throughout
- Path corrections
- Note about .sh scripts vs PowerShell
- Windows-specific considerations section

### Step 4: Create Windows PowerShell Quick Reference

**New file:** `prompts/three-agent-migration/POWERSHELL-REFERENCE.md`

**Content:**
- Common bash → PowerShell conversions
- Heredoc examples
- Path handling
- File creation patterns
- Troubleshooting Windows issues

### Step 5: Testing Checklist

**Before considering complete:**
- [ ] All paths use `C:\Development\perplex`
- [ ] All commands use PowerShell syntax
- [ ] All file creation uses PowerShell heredocs
- [ ] All terminal references say "PowerShell"
- [ ] Shell script modifications clarified (edit .sh files)
- [ ] Two-terminal coordination explained for Windows
- [ ] No bash-isms remain
- [ ] No Linux assumptions remain

---

## Regeneration Order

1. ✅ Phase 1 (DONE)
2. Phase 2 (Configuration migration) - NEXT
3. Phase 3 (Workspace coordination)
4. Phase 4 (Automation & hooks) - CRITICAL (shell script editing)
5. Phase 5 (Documentation)
6. Phase 6 (GitHub workflows) - Less critical (runs on GitHub)
7. Phase 7 (Validation & testing) - CRITICAL (two terminals)
8. Phase 8 (Production activation)
9. Phase 9 (Web handoff)
10. README
11. Architecture document
12. PowerShell reference (new)

---

## Commit Strategy

**After each phase regenerated:**
- Commit individually
- Push to remote
- Allows user to review progress
- Enables rollback if needed

**Commit message format:**
```
[Web] Regenerate Phase N: Windows PowerShell complete rewrite

- Converted all bash → PowerShell syntax
- Fixed path: /home/user/perplex → C:\Development\perplex
- Fixed heredocs: cat <<EOF → @"..."@ | Set-Content
- Fixed path separators: / → \
- Added Windows-specific notes
- [Phase-specific changes]

Branch: claude/project-recovery-repair-011CV63kQMKXwLP45v5RDfXT
Agent: web-claude-designer-001
```

---

**Audit Complete:** All issues identified
**Next Action:** Begin systematic regeneration Phase 2 → Phase 9 → README → Architecture
**Estimated Time:** 2-3 hours to regenerate all files properly
**User Approval:** Required before proceeding with complete regeneration

---

**Prepared by:** web-claude-designer-001
**Date:** 2025-11-13
**Status:** Audit complete, awaiting approval to proceed

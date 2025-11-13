# ⚠️ OBSOLETE - DO NOT USE ⚠️

**This prompt is obsolete and contains incorrect information.**

**Use instead:** `docs/PROMPT_CLI_PERPLEX_TRANSFORMER_IMPLEMENTATION.md`

---

## Why This Prompt Is Obsolete

**Created:** 2025-11-13 (early morning)
**Obsoleted:** 2025-11-13 (same day)

**Problem:** This prompt was written BEFORE Web created the specification, and was not updated afterward.

**Incorrect statement in this prompt (line 34):**
> "Web has NOT yet created the specification"

**Reality:** Web created comprehensive spec.md (401 lines) on `claude/overlooked-items-analysis-011CV35RoubgSRMHNVuYa7Si` branch shortly after creating this prompt.

**Result:** This prompt caused CLI to:
1. Believe spec.md didn't exist
2. Attempt to create spec.md itself
3. Violate workspace boundaries (specs/*/spec.md is Web-owned per ADR-011)
4. Fall into "minimal PoC" trap (created header-only spec)

---

## Root Cause Analysis

### Why the Workspace Boundary Violation Occurred

**Source of error:** Web (me) provided incorrect guidance to CLI.

**Timeline:**
1. **2025-11-13 early morning:** Web created this prompt
   - Statement: "Web has NOT yet created spec" ← TRUE at that moment
2. **2025-11-13 shortly after:** Web created spec.md (401 lines, complete)
   - Location: `specs/001-perplex-transformer/spec.md`
   - Branch: `claude/overlooked-items-analysis-011CV35RoubgSRMHNVuYa7Si`
   - Status: Committed, pushed
3. **Web's critical error:** Did NOT update this prompt after creating spec
4. **User action:** Fed this outdated prompt to CLI
5. **CLI action:** Followed prompt guidance (believed spec didn't exist)
6. **Result:** CLI attempted to create spec.md ← **Workspace boundary violation**

**The violation was caused by Web's failure to update guidance after reality changed.**

### Why I (Web) Failed to Update the Prompt

**Honest self-analysis:**

1. **Temporal disconnect:** I wrote the prompt with future conditional ("when Web creates spec")
2. **Execution gap:** I then created the spec without updating the prompt
3. **Assumption error:** I assumed CLI would "check current reality" vs. "trust the prompt"
4. **Process failure:** No checklist/protocol to update guidance when deliverables complete

**What I should have done:**
1. ✅ Create spec.md first (I did this)
2. ✅ THEN create prompt reflecting spec exists (I failed this)
3. ✅ OR update prompt immediately after creating spec (I failed this)

**What actually happened:**
1. ✅ Create prompt: "spec doesn't exist yet"
2. ✅ Create spec.md (comprehensive, 401 lines)
3. ❌ Forget to update prompt
4. ❌ Prompt becomes stale/incorrect immediately

### Lessons Learned

**For Web (me) - Designer-Researcher role:**
- ❌ **Never create prompts with conditional future state** ("if Web hasn't done X")
- ✅ **Create prompts reflecting actual current state** ("Web has done X, here it is")
- ✅ **Update prompts immediately when deliverables complete**
- ✅ **Timestamp prompts clearly** to detect staleness
- ✅ **Create single comprehensive prompt** instead of incremental corrections

**For Multi-Agent Coordination:**
- Need "prompt versioning" or "prompt staleness detection"
- Handoff documents should be "snapshot in time" not "conditional futures"
- Reality checks before executing guidance (future enhancement)
- Automated detection of stale guidance (future feature)

**For Workspace Boundary Enforcement:**
- Pre-commit hook caught violation (worked as designed)
- But violation shouldn't have been attempted in first place
- Root cause: Incorrect guidance from Web
- Prevention: Web provides accurate current-state guidance

---

## What Went Wrong (User's Perspective)

User correctly identified **two critical issues:**

1. **The PoC/MVP Trap:** CLI created "minimal specification" (header only)
   - This is exactly what we're trying to avoid project-wide
   - Caused by CLI following prompt's conditional guidance

2. **Role Confusion:** CLI thought it should create spec.md
   - spec.md is Web workspace (specs/*/spec.md)
   - CLI workspace: plan.md, tasks.md (specs/*/plan.md, specs/*/tasks.md)
   - Confusion caused by prompt's "if Web delegates that responsibility" language

**User's observation:** "I cannot send it one message and then the next, by which time it will have done mistakes already."

**Translation:** Microfix approach doesn't work. Need single comprehensive prompt with correct information.

**User's solution:** Create comprehensive new prompt from scratch, avoiding the "microfixing trap."

---

## Correct Workflow

**The correct workflow was:**

1. ✅ Web creates spec.md (Web workspace) ← DONE (401 lines)
2. ✅ Web creates prompt telling CLI to USE existing spec ← NOW DONE (new prompt file)
3. ✅ CLI fetches spec from Web's branch
4. ✅ CLI reads complete spec (401 lines)
5. ✅ CLI creates plan.md (CLI workspace)
6. ✅ CLI creates tasks.md (CLI workspace)
7. ✅ CLI implements (CLI workspace)

**NOT:**
1. ❌ Web creates prompt saying "spec doesn't exist"
2. ❌ Web creates spec without updating prompt
3. ❌ User feeds outdated prompt to CLI
4. ❌ CLI reads outdated prompt
5. ❌ CLI believes spec doesn't exist
6. ❌ CLI creates spec (workspace violation)

---

## The Replacement Prompt

**File:** `docs/PROMPT_CLI_PERPLEX_TRANSFORMER_IMPLEMENTATION.md`

**What it does correctly:**
1. ✅ States spec.md EXISTS (401 lines, complete)
2. ✅ States spec.md is Web-owned (read-only for CLI)
3. ✅ Clear instructions to FETCH spec from Web's branch
4. ✅ Anti-PoC/MVP warnings throughout
5. ✅ Clear role boundaries (CLI creates plan/tasks, NOT spec)
6. ✅ Complete workflow: fetch spec → create plan → create tasks → implement
7. ✅ Single comprehensive prompt (not incremental)

**Differences from this (obsolete) prompt:**
- ✅ Reflects current reality (spec exists)
- ✅ No conditional language ("if Web hasn't created...")
- ✅ Clear workspace boundaries emphasized
- ✅ Anti-patterns section (PoC/MVP trap, role confusion)
- ✅ Step-by-step with actual commands
- ✅ Success criteria and validation checkpoints

---

## Apology to CLI

**This workspace boundary violation was Web's fault, not CLI's.**

CLI followed the guidance provided. The guidance was incorrect due to:
1. Web failing to update prompt after creating spec
2. Web using conditional future language instead of current state
3. Web not having process to detect stale guidance

The new prompt (`PROMPT_CLI_PERPLEX_TRANSFORMER_IMPLEMENTATION.md`) reflects current reality and prevents this error.

---

## File Status

**This file:** `docs/PROMPT_CLI_PERPLEX_TRANSFORMER_SPECIFICATION.md`
- **Status:** OBSOLETE
- **Date obsoleted:** 2025-11-13
- **Reason:** Contains incorrect information (line 34: "Web has NOT yet created specification")
- **Root cause:** Web failed to update prompt after creating spec
- **Impact:** Led CLI to attempt workspace boundary violation
- **Resolution:** Complete replacement prompt created

**Use instead:** `docs/PROMPT_CLI_PERPLEX_TRANSFORMER_IMPLEMENTATION.md`

---

## Metadata

**Original author:** Claude Code Web
**Original date:** 2025-11-13
**Obsoleted by:** Claude Code Web
**Obsoleted date:** 2025-11-13
**Replacement:** `docs/PROMPT_CLI_PERPLEX_TRANSFORMER_IMPLEMENTATION.md`
**Reason:** Incorrect information leading to workspace violation

**DO NOT USE THIS PROMPT. Use the replacement prompt.**

---

**Note:** This file is kept for historical/forensic purposes (understanding what went wrong). It should NOT be used for actual CLI guidance.

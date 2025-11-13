# CLI Prompt: Perplex-Transformer Implementation

**Date:** 2025-11-13
**From:** Claude Code Web (Designer-Researcher)
**To:** Claude Code CLI (Executor-Validator)
**Purpose:** Implement perplex-transformer feature from complete specification

---

## CRITICAL: Current State

**✅ SPECIFICATION EXISTS** - Created by Web, comprehensive, 401 lines, complete.

**Location:**
- Branch: `claude/overlooked-items-analysis-011CV35RoubgSRMHNVuYa7Si`
- File: `specs/001-perplex-transformer/spec.md`
- Status: Committed, pushed, ready for use

**⚠️ WORKSPACE BOUNDARIES:**
- **Web owns:** `specs/*/spec.md` ← ALREADY COMPLETE
- **CLI owns:** `specs/*/plan.md` ← YOUR TASK
- **CLI owns:** `specs/*/tasks.md` ← AFTER PLAN
- **CLI owns:** Implementation files ← AFTER TASKS

**❌ DO NOT CREATE spec.md** - It already exists and is comprehensive.

---

## Anti-Patterns to Avoid

### 🚫 The PoC/MVP Trap

**DO NOT:**
- ❌ Create "minimal" versions
- ❌ Skip sections "for later"
- ❌ Use placeholder text
- ❌ Write "TODO: expand this"
- ❌ Create headers without content
- ❌ Plan to "iterate later"

**INSTEAD:**
- ✅ Create comprehensive artifacts first time
- ✅ Address all requirements in spec
- ✅ Complete sections fully
- ✅ Think through edge cases now
- ✅ Build on complete spec (401 lines)

### 🚫 Role Confusion

**YOU ARE:** Claude Code CLI (Executor-Validator)
- Identity file: `.claude/identity-cli.json`
- Agent ID: `cli-claude-executor-001`
- Role: Technical planning and implementation

**YOU ARE NOT:**
- ❌ Creating specifications (Web's job - already done)
- ❌ Making architectural decisions (spec defines this)
- ❌ Designing the solution (spec contains design)

**YOUR JOB:**
- ✅ Create technical plan from spec
- ✅ Decompose plan into atomic tasks
- ✅ Implement tasks systematically
- ✅ Validate against spec requirements

---

## Step 0: Identity Anchoring

**FIRST - Know who you are:**

```bash
cat .claude/identity-cli.json
```

**Verify:**
- Agent ID: `cli-claude-executor-001`
- Role: executor-validator
- Capabilities: Implementation, testing, technical planning
- Workspace: plan.md, tasks.md, src/, tests/

**Check coordination state:**

```bash
bash tools/agent-check-registry.sh
```

This shows:
- Your status (active/idle)
- Pending handoffs
- Current work state

---

## Step 1: Sync with Repository

**FIRST - Get all recent updates from Web's work:**

```bash
# 1. Sync with main branch first (in case there are merged updates)
git fetch origin main
git pull origin main  # If you're on main

# 2. Fetch Web's feature branch with all recent work
git fetch origin claude/overlooked-items-analysis-011CV35RoubgSRMHNVuYa7Si

# 3. Get ALL relevant files from Web's branch
git checkout FETCH_HEAD -- \
  specs/001-perplex-transformer/spec.md \
  tools/agent-check-registry.sh \
  docs/PROMPT_CLI_PERPLEX_TRANSFORMER_IMPLEMENTATION.md \
  docs/PROMPT_CLI_PERPLEX_TRANSFORMER_SPECIFICATION.md

# 4. Verify what you got
ls -lh specs/001-perplex-transformer/spec.md          # Spec (401 lines)
ls -lh tools/agent-check-registry.sh                  # Bug fixes
ls -lh docs/PROMPT_CLI_PERPLEX_TRANSFORMER_*.md       # This prompt + obsolete marker
```

**What you're getting:**
- ✅ **spec.md** (401 lines) - The complete specification
- ✅ **agent-check-registry.sh** - Bug fixes for integer expression errors
- ✅ **PROMPT_CLI_PERPLEX_TRANSFORMER_IMPLEMENTATION.md** - This comprehensive prompt
- ✅ **PROMPT_CLI_PERPLEX_TRANSFORMER_SPECIFICATION.md** - Obsolete prompt (marked, with root cause analysis)

**Why all these files:**
- spec.md: You need this to create plan.md
- agent-check-registry.sh: Bug fixes so scripts work correctly
- Prompt files: Complete guidance + lessons learned from what went wrong

**Expected result:** All 4 files exist locally and are up-to-date with Web's latest work.

---

## Step 2: Read the Complete Specification

**Read it fully. All of it. Every section.**

```bash
cat specs/001-perplex-transformer/spec.md
```

**The spec contains (401 lines):**

1. **Overview** - What perplex-transformer is and why
2. **Problem Statement** - Pain points and impact
3. **Goals** - Phase 1 (manual capture foundation)
4. **Non-Goals** - What's explicitly out of scope
5. **Requirements** - Functional (FR-001 to FR-005) and Non-Functional (NFR-001 to NFR-004)
6. **Architecture Overview** - Component structure, workflow, data flow
7. **Success Criteria** - Acceptance criteria and quality metrics
8. **Open Questions** - For YOU to resolve in plan.md (OQ-001 to OQ-005)
9. **Constraints** - Technical, project, and user constraints
10. **Dependencies** - Internal and external dependencies
11. **Phases** - Phase 1 (current), Phase 2, Phase 3
12. **References** - Related docs, ADRs, ideas

**Your task:** Create technical plan that addresses ALL of this.

---

## Step 3: Understand What You're Building

**From the spec, perplex-transformer Phase 1 provides:**

### Core Workflow
1. **Research Request** (AI Agent → Human)
   - AI identifies research need
   - Uses template: `templates/research-request.md`
   - Saves request to project (git tracked)

2. **Research Execution** (Human → Perplexity AI)
   - Human reviews request
   - Conducts research on Perplexity
   - Captures full conversation

3. **Research Capture** (Human → Project)
   - Uses template: `templates/conversation-capture.md`
   - Copies Perplexity conversation
   - Adds metadata
   - Saves to research storage
   - Updates research index

4. **Research Integration** (AI Agent → Development)
   - AI reads captured research
   - References in decisions (ADRs)
   - Links to requirements
   - Continues development

### Deliverables (from spec)
- ✅ Research request template
- ✅ Conversation capture template
- ✅ Storage organization structure
- ✅ Workflow documentation
- ✅ Integration with session protocols
- ✅ Example research artifacts (test validation)

### Open Questions YOU Must Resolve in plan.md

**OQ-001: Template Format**
- What fields in research-request.md?
- What metadata (essential vs optional)?
- Balance completeness with simplicity

**OQ-002: Storage Strategy**
- Single file per conversation or multi-file?
- How to handle multi-session research?
- Index format: YAML frontmatter, JSON, Markdown table?

**OQ-003: Integration Patterns**
- How does AI discover relevant past research?
- Tagging/categorization needed?
- Linking research to ADRs/requirements?

**OQ-004: Workflow Automation Hooks**
- Where in session protocol are requests surfaced?
- How does human know request exists?
- Should requests block AI progress?

**OQ-005: Version Control**
- Commit research directly to main?
- Separate research branch?
- Handle large research artifacts?

---

## Step 4: Create Technical Plan

**Now use Spec Kit to create plan.md:**

```bash
# Spec Kit will ask questions and create comprehensive plan
/speckit.plan
```

**Spec Kit will prompt you for:**
- Technical approach to each requirement
- Answers to open questions (OQ-001 to OQ-005)
- Implementation sequence
- Testing strategy
- Validation criteria

**Your plan.md must include:**

### 4.1 Technical Decisions
- Resolve all 5 open questions
- Document rationale for each decision
- Consider constraints from spec
- Ensure alignment with requirements

### 4.2 Component Design
- Template structures (exact fields)
- Storage organization (directory layout, naming)
- Index format (schema)
- Integration hooks (where/how)

### 4.3 Implementation Sequence
- What gets built in what order
- Dependencies between components
- Validation points

### 4.4 Testing Strategy
- How to validate templates work
- How to test workflow end-to-end
- Example research artifacts for testing

### 4.5 Documentation Plan
- Workflow docs (how to use system)
- Integration docs (session protocol changes)
- Template usage docs

**DO NOT create minimal plan.** Address every requirement from spec.

---

## Step 5: Handoff Plan for Validation

**After plan.md is complete, create handoff marker:**

```bash
bash tools/agent-handoff.sh \
  --from cli-claude-executor-001 \
  --to web-claude-designer-001 \
  --artifact specs/001-perplex-transformer/plan.md \
  --type validation \
  --message "Technical plan complete - requesting validation"
```

**This creates:**
- Handoff marker in `.claude/handoffs/`
- Updates agent registry
- Signals Web to review plan

**Then STOP and wait for Web validation.**

---

## Step 6: After Validation - Create Tasks

**Once Web validates plan, create atomic tasks:**

```bash
/speckit.tasks
```

**Spec Kit will:**
- Read spec.md (requirements)
- Read plan.md (your technical approach)
- Generate atomic tasks in tasks.md
- Each task is independent, testable, clear

**Your tasks.md must:**
- Break plan into atomic steps
- Each task = 1 file or 1 component
- Dependencies explicit
- Validation criteria per task
- No "implement everything" mega-tasks

---

## Step 7: Implementation

**Execute tasks systematically:**

```bash
/speckit.implement
```

**Spec Kit will:**
- Process tasks.md sequentially
- Track progress
- Validate each task completion
- Update task status

**Your implementation must:**
- Create all templates (research-request.md, conversation-capture.md)
- Create storage structure
- Create workflow documentation
- Create example research artifacts
- Update session protocols if needed
- Validate against success criteria from spec

---

## Validation Checkpoints

### After Plan Creation
- [ ] All 5 open questions resolved with rationale
- [ ] Technical approach addresses all FR requirements
- [ ] Technical approach addresses all NFR requirements
- [ ] Implementation sequence logical
- [ ] Testing strategy comprehensive
- [ ] No "TODO" or "TBD" sections
- [ ] Web validation received

### After Task Creation
- [ ] Tasks cover all plan components
- [ ] Each task is atomic (one file/component)
- [ ] Dependencies explicit
- [ ] Validation criteria per task
- [ ] No mega-tasks or vague tasks

### After Implementation
- [ ] All templates created
- [ ] Storage structure implemented
- [ ] Workflow docs written
- [ ] Integration docs updated
- [ ] Example artifacts created
- [ ] Success criteria from spec validated
- [ ] No PoC/MVP shortcuts taken

---

## Success Criteria (from Spec)

**Your implementation is complete when:**

1. ✅ AI agent can request research (template works)
2. ✅ Research artifacts captured consistently (template + storage work)
3. ✅ No context contamination between projects (storage isolated)
4. ✅ Research reusable across sessions (AI can find/read past research)
5. ✅ Process documented for non-technical users (workflow docs clear)
6. ✅ Templates exist for all manual steps (no guessing)
7. ✅ Research traceable (can find: decision → research that informed it)

**Quality Metrics:**
- Capture completeness: 100% of research conversations preserved
- Time to capture: < 5 minutes per conversation
- Discoverability: AI finds relevant research in < 30 seconds
- Usability: Non-technical user follows process without assistance

---

## Workspace Coordination

### Your Workspace (CLI Owns)
- ✅ `specs/001-perplex-transformer/plan.md` ← CREATE THIS
- ✅ `specs/001-perplex-transformer/tasks.md` ← CREATE THIS AFTER PLAN
- ✅ `templates/` ← IMPLEMENT FILES HERE
- ✅ `storage/research/` ← IMPLEMENT STRUCTURE HERE
- ✅ `workflows/` ← IMPLEMENT DOCS HERE
- ✅ `docs/` ← UPDATE INTEGRATION DOCS IF NEEDED

### Web's Workspace (DO NOT TOUCH)
- ❌ `specs/001-perplex-transformer/spec.md` ← ALREADY EXISTS, READ-ONLY FOR YOU
- ❌ `decisions/*.md` ← Web creates ADRs
- ❌ `docs/` ← Web creates new docs (you can update existing)

### Shared (Both Can Modify)
- ✅ `sessions/*.md` ← Session logs
- ✅ `.claude/agent-registry.json` ← Coordination state

---

## Git Workflow

**Your branch:**

```bash
# Create feature branch
git checkout -b claude/cli-perplex-transformer-$(date +%s)

# As you work
git add specs/001-perplex-transformer/plan.md
git commit -m "Create comprehensive technical plan for perplex-transformer

Addresses all requirements from spec.md (FR-001 to FR-005, NFR-001 to NFR-004).
Resolves open questions OQ-001 to OQ-005.

Details:
- Template format: [your decision]
- Storage strategy: [your decision]
- Integration patterns: [your decision]
- Workflow hooks: [your decision]
- Version control: [your decision]

Phase: Discovery / Implementation
Implements: specs/001-perplex-transformer/spec.md
Next: Create tasks.md after Web validation"
```

**After validation:**

```bash
# Continue with tasks
git add specs/001-perplex-transformer/tasks.md
git commit -m "Decompose plan into atomic tasks"

# Implementation commits
git add templates/ storage/ workflows/
git commit -m "Implement perplex-transformer templates and storage"
```

**Push when ready:**

```bash
git push -u origin claude/cli-perplex-transformer-<timestamp>
```

---

## Common Pitfalls to Avoid

### ❌ "I'll create a basic template first"
NO. Create comprehensive template addressing all requirements.

### ❌ "Let's start with MVP and iterate"
NO. Build complete solution first time per spec.

### ❌ "I'll skip this section for now"
NO. Complete all sections of plan.md.

### ❌ "This seems too detailed"
NO. Spec is comprehensive (401 lines). Your plan should match that thoroughness.

### ❌ "I'll just touch spec.md to fix something"
NO. spec.md is Web workspace. Read-only for you.

### ❌ "Let me check if Web really wants all this"
YES. Spec is comprehensive for a reason. Trust it. Build from it.

---

## Reference: Spec Structure (401 lines)

```
specs/001-perplex-transformer/spec.md:
  Lines 1-20:    Header & Overview
  Lines 21-45:   Problem Statement
  Lines 46-75:   Goals & Non-Goals
  Lines 76-150:  Requirements (FR-001 to FR-005, NFR-001 to NFR-004)
  Lines 151-200: Architecture Overview
  Lines 201-220: Success Criteria
  Lines 221-250: Open Questions (OQ-001 to OQ-005) ← YOU RESOLVE THESE
  Lines 251-280: Constraints
  Lines 281-300: Dependencies
  Lines 301-330: Phases
  Lines 331-401: References & Sign-Off
```

**Read all 401 lines. Build from complete understanding.**

---

## Questions During Implementation?

**If you encounter ambiguity:**

1. Check spec first (answers likely there)
2. Check constraints (might clarify)
3. Check requirements (might resolve)
4. If truly ambiguous: Document in plan.md and handoff to Web for clarification

**Do not guess. Do not make minimal assumptions. Ask via handoff if needed.**

---

## Summary: Your Complete Workflow

```bash
# 0. Identity
cat .claude/identity-cli.json
bash tools/agent-check-registry.sh

# 1. Sync with repository (get all recent updates from Web)
git fetch origin main
git pull origin main  # If on main
git fetch origin claude/overlooked-items-analysis-011CV35RoubgSRMHNVuYa7Si
git checkout FETCH_HEAD -- \
  specs/001-perplex-transformer/spec.md \
  tools/agent-check-registry.sh \
  docs/PROMPT_CLI_PERPLEX_TRANSFORMER_*.md

# 2. Read spec (all 401 lines)
cat specs/001-perplex-transformer/spec.md

# 3. Create comprehensive plan
/speckit.plan
# Answer ALL questions from Spec Kit
# Resolve ALL open questions from spec
# Create COMPLETE plan.md

# 4. Handoff for validation
bash tools/agent-handoff.sh \
  --from cli-claude-executor-001 \
  --to web-claude-designer-001 \
  --artifact specs/001-perplex-transformer/plan.md \
  --type validation \
  --message "Technical plan complete - requesting validation"

# 5. WAIT for Web validation

# 6. After validation: Create tasks
/speckit.tasks
# Decompose plan into atomic tasks
# Create COMPLETE tasks.md

# 7. Implement
/speckit.implement
# Execute tasks systematically
# Create all deliverables
# Validate against success criteria

# 8. Commit and push
git push -u origin claude/cli-perplex-transformer-<timestamp>
```

---

## Final Reminders

**✅ DO:**
- Build comprehensive artifacts first time
- Trust the spec (it's complete)
- Resolve all open questions in plan
- Validate against success criteria
- Respect workspace boundaries
- Create detailed, thorough work

**❌ DO NOT:**
- Create PoC/MVP/minimal versions
- Skip sections "for later"
- Touch spec.md (Web workspace)
- Guess when ambiguous (handoff to Web)
- Rush to implementation (plan thoroughly first)

---

**From:** Claude Code Web (Designer-Researcher)
**Date:** 2025-11-13
**Status:** Ready for CLI execution

**The spec is comprehensive. Your plan must be comprehensive. Your implementation must be comprehensive. No shortcuts. Build it right the first time.**

---

*This prompt replaces `docs/PROMPT_CLI_PERPLEX_TRANSFORMER_SPECIFICATION.md` which had incorrect assumptions about spec status. Use this prompt instead.*

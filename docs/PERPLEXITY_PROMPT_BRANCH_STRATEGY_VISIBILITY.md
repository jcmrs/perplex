# Perplexity AI Research Prompt: Branch Strategy for Multi-Stakeholder AI Development

**Date:** 2025-11-13
**Purpose:** Get expert guidance on git branch strategies for projects with multiple stakeholders (AI agents + humans) and artifacts with different visibility requirements
**Context:** Project Perplex - Multi-agent AI development with workspace coordination
**Prepared by:** Claude Code Web (Designer-Researcher)

---

## Executive Summary

**The Core Problem:**

We have a multi-agent AI development project with effective workspace coordination (WHO can modify WHICH files) but are missing a critical piece: **visibility-driven branch strategy** (WHICH BRANCH for WHICH artifacts based on WHO needs them WHEN and WHERE they look).

**What We Need:**

Expert guidance on git branch strategies that handle artifacts with different visibility requirements (universal/immediate vs. feature-specific/validated) in multi-agent AI development contexts.

---

## Project Context

### Project: Perplex

**Purpose:** Bridge local AI development tools (Claude Code CLI, Gemini CLI) with Perplexity AI research capabilities

**Architecture:** Multi-agent collaborative development
- **Claude Code Web (Web):** Designer-Researcher role, browser-based environment
- **Claude Code CLI (CLI):** Executor-Validator role, local Windows environment
- **Human Partner:** Strategic direction, non-technical user

**Development Approach:**
- AI-first development (AI agents are primary users)
- Discovery-Driven Development with Lean Principles (project level)
- Spec-Driven Development with GitHub Spec Kit (implementation level)
- Foundation imperatives: Holistic System Thinking, AI-First, 5 Cornerstones

---

## What We Have: Workspace Coordination

**Successfully Implemented (ADR-011):**

**1. File Ownership Boundaries**
- Web owns: `decisions/`, `docs/`, `specs/*/spec.md`
- CLI owns: `src/`, `tests/`, `specs/*/plan.md`, `specs/*/tasks.md`
- Shared: `sessions/`, `checkpoints/`, `.claude/agent-registry.json`

**2. Enforcement Mechanisms**
- Pre-commit hook: BLOCKS commits violating workspace boundaries
- GitHub Actions workflow: Validates PRs respect boundaries
- Agent scripts: Validate artifact ownership before work starts

**3. Agent Detection**
- Branch naming patterns: `claude/*` = Web, `claude/cli-*` = CLI
- Automatic agent detection from branch name
- Workspace validation per agent

**Status:** Workspace coordination works effectively - we know WHO can touch WHAT.

---

## What We're Missing: Visibility-Driven Branch Strategy

**The Gap:**

Workspace coordination addresses **ownership** but not **visibility requirements**.

**The Problem Pattern:**

During a recent session, I (Web agent) created multiple artifacts on a feature branch:
1. Master document updates (README, CONTRIBUTING, CHANGELOG, MILESTONES, BRANCHING_STRATEGY)
2. Bug fixes to shared scripts (agent-check-registry.sh)
3. CLI guidance prompts (docs/PROMPT_CLI_*.md)
4. Feature specification (specs/001-perplex-transformer/spec.md)

**What went wrong:**
- All artifacts went to feature branch: `claude/overlooked-items-analysis-011CV35RoubgSRMHNVuYa7Si`
- Human partner checked main branch for master docs → **not visible** (still on feature branch)
- CLI agent told to sync with feature branch for everything → workaround, not solution
- Master docs are **universal entry points** but invisible where everyone looks (main branch)

**Root cause:** No strategy for deciding WHICH BRANCH based on artifact visibility requirements.

---

## Artifact Types & Their Visibility Requirements

| Artifact Type | Primary Stakeholders | Urgency | Where They Look | Current Strategy | Problem |
|---------------|---------------------|---------|-----------------|------------------|---------|
| **Master documents** (README, CONTRIBUTING, etc.) | Everyone (AI agents, humans, new contributors) | Immediate | Main branch | Feature branch | ❌ Invisible to everyone |
| **Bug fixes** (shared scripts/tools) | Everyone using tools | Immediate | Main branch | Feature branch | ❌ Broken tools for everyone |
| **Agent guidance** (prompts, docs) | Specific agent (CLI) | Before implementation | Documented location | Feature branch | ⚠️ Requires fetch instructions |
| **Feature specs** | Next agent in workflow (CLI) | After validation | Can be feature branch | Feature branch | ✅ OK with documented access |
| **Implementation code** | Reviewers, CI/CD | After completion | Feature branch | Feature branch | ✅ Standard feature branch workflow |

**The visibility spectrum:**
- **Universal + Immediate:** Main branch required
- **Agent-specific + Urgent:** Main or documented access path
- **Feature-specific + Validated:** Feature branch acceptable

---

## Current Branch Strategy (Insufficient)

**What we do:**
1. Agent creates feature branch (e.g., `claude/feature-description-sessionid`)
2. All work for that session goes on that feature branch
3. Push to remote, automated PR creation
4. Tests pass → auto-merge to main
5. Branch deleted after merge

**Problems with this approach:**

**Problem 1: Session-scope assumption**
- Assumption: "One session = one feature = one branch"
- Reality: Sessions often involve multiple work types (feature work + bug fixes + documentation updates)
- Result: Universal/immediate artifacts stuck on feature branch

**Problem 2: Delayed visibility**
- Assumption: "Everything merges eventually"
- Reality: Master docs need immediate visibility (universal entry points)
- Result: Outdated master docs on main while updates wait in feature branch

**Problem 3: Fetch workarounds**
- Current solution: Tell CLI to fetch from Web's feature branch
- Problem: Adds complexity, not scalable, fragile coordination
- Better solution: Right artifacts on right branches from the start

---

## The Visibility-Driven Branch Decision Matrix

**What we think we need (but want expert validation):**

### Decision Protocol

**Before starting work, classify the artifact:**

```
IF artifact is:
    - Master document (README, CONTRIBUTING, CHANGELOG, etc.)
    - Shared tool/script bug fix
    - Universal documentation
THEN:
    visibility = "universal"
    urgency = "immediate"
    target_branch = "main" OR "urgent-updates" separate PR

ELIF artifact is:
    - Feature specification
    - Feature implementation
    - Feature-specific documentation
THEN:
    visibility = "feature-specific"
    urgency = "after-validation"
    target_branch = "feature-branch"

ELIF artifact is:
    - Agent-specific guidance (prompts, handoff docs)
THEN:
    visibility = "agent-specific"
    urgency = depends on context
    target_branch = "main" (if urgent) OR "feature-branch" (if documented access path)
```

### Workflow Patterns

**Pattern A: Universal/Immediate Updates (Hotfix-style)**
1. Identify universal/immediate artifact
2. Create separate branch: `hotfix/description` or work directly on main
3. Commit, push, create PR
4. Fast-track merge (no waiting for feature completion)
5. Visible immediately on main

**Pattern B: Feature-Specific Work (Current approach)**
1. Create feature branch: `claude/feature-name-sessionid`
2. All feature work on this branch
3. PR → validation → merge when feature complete
4. Branch deleted after merge

**Pattern C: Mixed Session (Separate branches)**
1. Identify work types in session
2. Universal/immediate → hotfix branch OR main
3. Feature-specific → feature branch
4. Keep separate, merge independently

---

## Concrete Example: What Happened

**Session: 2025-11-13 - Overlooked Items Analysis + Perplex-Transformer Spec**

**Work done:**
1. Analyzed overlooked items (identified master docs outdated)
2. Updated all 5 master documents comprehensively
3. Fixed bug in agent-check-registry.sh (integer expression errors)
4. Created perplex-transformer specification (specs/001-perplex-transformer/spec.md)
5. Created CLI guidance prompts (comprehensive + obsolete marker)

**All work committed to:** `claude/overlooked-items-analysis-011CV35RoubgSRMHNVuYa7Si`

**Result:**
- Human partner checks main branch for README → still shows old version
- Master docs invisible (86 commits behind, now updated but on feature branch)
- Bug fixes invisible (tools still have bugs on main)
- CLI prompts require complex fetch instructions

**What should have happened (hypothetically):**
- Master docs + bug fixes → Separate PR (`hotfix/master-docs-currency`) → fast merge
- Spec + CLI prompts → Feature branch (current approach OK)
- Result: Universal artifacts visible immediately, feature work isolated

---

## Questions for Perplexity AI

### Primary Question

**"In multi-agent AI development projects with git workflows, what are industry best practices for branch strategies that handle artifacts with different visibility requirements (universal/immediate vs. feature-specific/validated)?"**

### Specific Sub-Questions

#### 1. Branch Strategy Patterns

**Question:** What branch strategy patterns exist for projects where a single work session produces multiple artifact types with different visibility/urgency requirements?

**Context:**
- Some artifacts need immediate universal visibility (master docs, bug fixes)
- Other artifacts are feature-specific and can wait for validation (specs, implementation)
- Traditional "one feature = one branch" doesn't fit this reality

**What we need:**
- Patterns for separating universal vs. feature-specific work
- Workflows for "hotfix" or "urgent update" during feature development
- How to decide which branch for which artifact type

#### 2. Multi-Stakeholder Visibility Requirements

**Question:** How do development teams handle git branching when different stakeholders look in different places for different artifacts?

**Our stakeholders:**
- **Everyone (universal):** Looks at main branch for master docs, shared tools
- **AI agents (specific):** Told where to look (can fetch from branches)
- **Human partner:** Checks main branch (canonical state)
- **CI/CD:** Watches feature branches and main

**What we need:**
- Best practices for ensuring artifacts are visible where stakeholders expect them
- How to avoid "it's committed but no one can see it" problem
- Branch naming conventions or strategies that signal visibility requirements

#### 3. Definition of "Done" Based on Visibility

**Question:** How should teams define "done" for different artifact types considering visibility requirements?

**Our current problem:**
- I (AI agent) say "I updated the README" meaning "committed to my branch"
- Human partner hears "README is updated" expecting "visible on main branch"
- Mismatch causes confusion and false sense of completion

**What we need:**
- How to define "done" for universal vs. feature-specific artifacts
- Communication patterns to avoid "committed but not visible" confusion
- Checklists or protocols for ensuring artifact visibility matches requirements

#### 4. AI Agent Coordination and Branch Strategy

**Question:** Are there specific branch strategy patterns recommended for AI agent collaboration where agents have different roles (designer vs. executor) and work asynchronously through a human intermediary?

**Our architecture:**
- Web agent (designer): Creates specs, docs, decisions
- CLI agent (executor): Creates plans, tasks, implementation
- Human: Mediates, checks main branch for status
- Agents don't directly communicate (async via git + human)

**What we need:**
- Branch strategies optimized for async multi-agent collaboration
- How to handle handoffs between agents with branch-based coordination
- Patterns for ensuring next agent can access previous agent's work

#### 5. Urgent Updates During Feature Development

**Question:** What are best practices for handling urgent cross-cutting updates (bug fixes, documentation) discovered during feature branch work without blocking or complicating the feature branch workflow?

**Our scenario:**
- Working on feature branch for perplex-transformer
- Discover master docs 86 commits behind (urgent fix needed)
- Discover bug in shared script (immediate fix needed)
- Feature work not yet complete (can't merge whole branch)

**What we need:**
- Workflows for "breaking out" urgent fixes from feature branches
- How to handle separate merge timelines (urgent now, feature later)
- Tools or practices to detect mixed work types before they become problems

#### 6. Branch Strategy Enforcement and Automation

**Question:** Are there tools, scripts, or automation patterns that help enforce visibility-driven branch strategies?

**What we already have:**
- Workspace boundary enforcement (WHO can modify WHAT)
- Automated PR creation and merging
- Pre-commit hooks for validation

**What we need:**
- Automation to detect artifact types and suggest correct branch
- Validation to warn if universal/immediate artifact on feature branch
- Guidance systems to help developers choose right branch strategy

---

## Current Documentation and Context

### Relevant Project Documents

**Branch Management:**
- `docs/BRANCHING_STRATEGY.md` - Current branching strategy (feature branch paradigm)
- `.github/workflows/auto-create-pr-claude-branches.yml` - Automated PR creation
- `.github/workflows/auto-merge-claude-branches.yml` - Automated merging

**Workspace Coordination:**
- `decisions/2025-11-13-agent-workspace-coordination.md` (ADR-011) - Workspace boundaries
- `.claude/workspace-coordination.yml` - Manifest defining file ownership
- `.github/workflows/workspace-validation.yml` - Enforcement via GitHub Actions

**Multi-Agent Coordination:**
- `docs/AGENT_WORKSPACE_COORDINATION.md` - Complete coordination documentation
- `.claude/agent-registry.json` - Agent status and coordination state
- `docs/SESSION_ANALYSIS_MULTI_AGENT_COORDINATION.md` - Three-environment architecture

### What Works Well

**Strengths of current approach:**
1. ✅ Clear workspace boundaries (WHO modifies WHAT)
2. ✅ Automated enforcement (pre-commit hooks, GitHub Actions)
3. ✅ Agent detection from branch names
4. ✅ Automated PR creation and merging
5. ✅ Branch protection and validation

### What's Missing

**Gaps:**
1. ❌ No protocol for deciding WHICH BRANCH based on artifact visibility
2. ❌ No guidance on handling mixed work types in single session
3. ❌ No "done" definition considering visibility requirements
4. ❌ No automation to detect universal/immediate artifacts
5. ❌ No fast-track workflow for urgent cross-cutting updates

---

## Constraints and Considerations

### Technical Constraints

1. **GitHub Actions automation:** Current workflows assume feature branch → PR → merge
2. **Branch protection:** Main branch requires PRs (can't push directly without elevated permissions)
3. **AI agent capabilities:** Web agent browser-based (limited), CLI agent local (full system access)
4. **Human partner:** Non-technical user, relies on main branch as canonical state

### Workflow Constraints

1. **Stateless AI sessions:** Each agent session starts fresh (no conversation history)
2. **Async coordination:** Agents coordinate via git and human intermediary (no direct communication)
3. **Autonomous operation:** AI agents should work independently without constant human intervention
4. **Validation gates:** Feature work requires validation before merge (can't rush everything to main)

### Project Principles

1. **AI-First:** Primary users are AI agents, not humans
2. **Holistic System Thinking:** Consider ripple effects across all systems
3. **Automation over Manual:** Repetitive processes should be scripted
4. **Configuration over Code:** Behavior driven by config, not hardcoded

---

## Desired Research Outcomes

### What We Need from Perplexity AI

**1. Branch Strategy Pattern Recommendations**
- Industry-standard patterns for multi-stakeholder visibility requirements
- Specific recommendations for our architecture (multi-agent AI development)
- Examples from real-world projects with similar challenges

**2. Implementation Guidance**
- Concrete workflows for each pattern
- Decision trees or checklists for choosing right branch
- Automation scripts or tools to enforce strategies

**3. Definition of "Done" Framework**
- How to define completion based on visibility requirements
- Communication patterns to avoid "committed but not visible" confusion
- Checklists per artifact type

**4. Validation and Detection**
- How to detect mixed work types before committing
- Automated checks for artifact visibility mismatches
- Warning systems for universal artifacts on feature branches

**5. Integration with Current System**
- How to add visibility-driven strategy without breaking current workspace coordination
- Migration path from current approach to improved approach
- Minimal changes for maximum impact

### Success Criteria for Research

Research is successful if it provides:

1. ✅ Clear branch strategy pattern addressing our visibility requirements
2. ✅ Decision protocol for choosing branch based on artifact type
3. ✅ Workflow examples for mixed work types
4. ✅ Communication patterns for defining "done"
5. ✅ Automation recommendations for enforcement
6. ✅ Real-world examples or case studies
7. ✅ Integration guidance with our current workspace coordination

---

## Output Format Request

**Please structure research findings as:**

### 1. Pattern Recommendations

**For each pattern:**
- Pattern name
- When to use (artifact types, visibility requirements)
- Workflow steps (concrete commands)
- Pros and cons
- Real-world examples

### 2. Decision Framework

**Provide:**
- Decision tree or flowchart (textual description)
- Classification criteria for artifacts
- Branch choice protocol
- Example decisions for our artifact types

### 3. Implementation Guidance

**Provide:**
- Step-by-step integration with current system
- Required changes to workflows/automation
- Scripts or validation rules (conceptual, not code)
- Rollout strategy

### 4. Best Practices

**Provide:**
- Communication patterns for visibility-aware "done" definitions
- Automation patterns for detecting mixed work types
- Enforcement mechanisms for visibility requirements
- Error patterns to avoid

### 5. Case Studies

**If available:**
- Similar projects (multi-agent, AI development, complex workflows)
- How they solved visibility/branch strategy challenges
- Lessons learned
- Tools or frameworks they used

### 6. Resources and Further Reading

**Provide:**
- Industry documentation on branch strategies
- Tools for branch strategy enforcement
- Research papers on multi-stakeholder development workflows
- Community discussions or forum threads on this topic

---

## Additional Context

### Why This Matters (The Human Partner's Perspective)

From the human partner's observation:

> "I am looking at the repository, you said you had updated the README.md and other things. I see none of that on main branch. I still see the old README.md"

**The disconnect:**
- AI agent (me): "I updated README" = "committed to my feature branch"
- Human partner: "README updated" = "visible on main branch where I look"
- Result: Confusion, false sense of completion, invisible work

**This isn't just a technical issue - it's a coordination and communication breakdown caused by missing branch strategy aligned with visibility requirements.**

### Why Traditional Branching Doesn't Fit

**Traditional feature branch workflow:**
- One feature = one branch
- All work for that feature on that branch
- Merge when feature complete
- Works well when: single feature, single team, all artifacts have same visibility requirements

**Our reality:**
- Sessions involve multiple work types (feature + fixes + docs)
- Multiple stakeholders (agents + human) with different visibility expectations
- Artifacts have different urgency (immediate vs. validated)
- "Feature complete" doesn't apply to universal artifacts (they're needed NOW)

---

## Questions for Clarification

If Perplexity AI needs additional context to provide accurate research:

**About our setup:**
- We can provide: Actual workflow files, ADR documents, coordination manifests
- We can clarify: Specific technical constraints, automation capabilities

**About our requirements:**
- We can specify: Exact artifact types, stakeholder needs, urgency timelines
- We can prioritize: Which patterns matter most, acceptable trade-offs

**About our constraints:**
- We can detail: GitHub Actions limitations, agent capabilities, human partner needs
- We can explain: Why certain approaches won't work

---

## Summary

**Core Research Request:**

"How should multi-agent AI development projects structure git branch strategies when different artifacts have different visibility requirements (universal/immediate vs. feature-specific/validated), and how can we automate the decision of which branch for which artifact?"

**Current State:** Workspace coordination works (WHO touches WHAT), but branch strategy doesn't account for visibility requirements (WHERE artifacts need to be for WHOM).

**Desired State:** Branch strategy that ensures artifacts are visible where and when stakeholders need them, with automation to enforce and guidance to prevent mistakes.

**Urgency:** High - Currently causing confusion, invisible work, and coordination failures between AI agents and human partner.

---

**Prepared by:** Claude Code Web (Designer-Researcher)
**Date:** 2025-11-13
**Project:** Perplex - Multi-Agent AI Development
**Purpose:** Get expert guidance on visibility-driven branch strategies

**Thank you for your research assistance!**

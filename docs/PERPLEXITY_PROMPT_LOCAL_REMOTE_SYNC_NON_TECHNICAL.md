# Perplexity AI Research Prompt: Local/Remote Synchronization in Multi-Agent Development with Non-Technical Users

**Date:** 2025-11-13 (Revised)
**Purpose:** Get expert guidance on synchronization protocols and communication patterns for multi-agent AI development where the human partner is non-technical and doesn't understand git local/remote concepts
**Context:** Project Perplex - Multi-agent AI development with automated workflows and non-technical human partner
**Prepared by:** Claude Code Web (Designer-Researcher)

---

## Executive Summary

**The Core Problem:**

We have a multi-agent AI development project with fully functional automation (PR creation, validation, merging). **The automation works perfectly.** However, there's a critical communication and synchronization gap:

- **AI agents (technical):** Work on remote repository (origin/main on GitHub), automated PRs merge changes, consider work "done" when on origin/main
- **Human partner (non-technical):** Checks local repository (local main branch), doesn't understand local/remote distinction, doesn't know when to sync, expects to see changes immediately

**Result:** AI says "I updated the README," human checks local main and says "I don't see it," leading to confusion, false sense of incomplete work, and communication breakdowns.

**What We Need:**

Expert guidance on synchronization protocols, communication patterns, and user experience design for multi-agent development where automated remote workflows need to be visible to non-technical local users.

---

## Project Context

### Project: Perplex

**Purpose:** Bridge local AI development tools (Claude Code CLI, Gemini CLI) with Perplexity AI research capabilities

**Architecture:**
- **Claude Code Web (Web):** Designer-Researcher, browser-based, creates specs/docs/decisions
- **Claude Code CLI (CLI):** Executor-Validator, local Windows, creates plans/tasks/implementation
- **Human Partner:** Strategic direction, non-technical user, checks local main branch for status

**Key Constraint:** Human partner is explicitly non-technical - cannot be expected to understand git internals, local/remote distinction, or manual sync procedures.

---

## What We Have: Fully Functional Automation

**The automation works perfectly:**

### 1. Feature Branch Workflow
- AI agents work on feature branches (`claude/*` pattern)
- Push to remote triggers automation
- Workspace boundaries enforced (WHO can modify WHAT)

### 2. Automated PR Creation
- GitHub Actions workflow: `auto-create-pr-claude-branches.yml`
- Detects push to `claude/*` branches
- Creates PR automatically via GitHub REST API
- Idempotency: Won't create duplicate PRs

### 3. Automated Validation
- Tests run automatically
- Foundation validation checks
- Completeness review
- Workspace boundary validation

### 4. Automated Merging
- GitHub Actions workflow: `auto-merge-claude-branches.yml`
- Merges to main when all checks pass
- Branch deleted after merge
- No human intervention required

**Status:** All of this works. PRs are created, validated, merged automatically. Changes ARE on origin/main (GitHub).

---

## What We're Missing: Local/Remote Sync for Non-Technical User

**The Problem Pattern:**

### Scenario 1: README Update

**AI agent (me) says:**
> "I updated the README and 4 other master documents to reflect recent work."

**What I mean:**
1. Updated files on my feature branch
2. Committed and pushed
3. Automated PR created
4. Validation passed
5. Auto-merged to main
6. Files are now on **origin/main** (GitHub)
7. ✅ Done

**Human partner checks:**
1. Opens local repository
2. Looks at local main branch
3. README still shows old content
4. ❌ "I don't see it"

**Why:** Local main branch not synced with origin/main. The files ARE on GitHub (remote), just not in their local copy.

### Scenario 2: Bug Fixes

**AI agent (me) says:**
> "I fixed the integer expression errors in agent-check-registry.sh"

**What I mean:**
- Bug fix committed, merged to origin/main via automation

**Human partner:**
- Runs script locally → still has bugs
- Local copy not updated → old version

**Why:** Same sync issue.

### Scenario 3: Perplexity Research Prompt

**AI agent (me) says:**
> "Created comprehensive Perplexity prompt at docs/PERPLEXITY_PROMPT_BRANCH_STRATEGY_VISIBILITY.md"

**Human partner:**
> "I do not see the prompt anywhere. I am on main."

**Why:** They're on **local** main, file is on **origin/main** (remote). Not synced.

---

## The Core Disconnect

### Technical Reality (AI Agent Perspective)

```
Local Work → Push → Remote (origin/main) → Automation → Merge to origin/main
                                                            ↑
                                                         "Done!"
```

**For AI agent:** Once on origin/main (GitHub), work is complete and visible (on GitHub).

### User Reality (Non-Technical Perspective)

```
Open local repository → Check local main → Look at files → Don't see changes
                                                              ↓
                                                           "Not there"
```

**For user:** If not visible locally, work is not done.

### The Missing Link

```
origin/main (remote, GitHub) ←→ local main (user's computer)
                         ↑
                  No automatic sync
                  No notification
                  No user awareness
```

**The gap:** User doesn't know:
- Changes are on remote but not local
- They need to sync
- How to sync (git pull)
- When to sync

---

## What We've Tried (Didn't Work)

### Attempt 1: Assuming User Knowledge

**Assumption:** User understands git, knows to pull updates

**Reality:** User is explicitly non-technical, doesn't know git local/remote distinction

**Result:** Confusion when changes "aren't there"

### Attempt 2: Complex Fetch Instructions

**Approach:** Tell CLI agent to fetch from Web's feature branch with detailed commands

**Problem:** This is a workaround for the symptom, not addressing root cause

**Issue:** Still assumes technical knowledge, adds complexity

### Attempt 3: Telling User to Run Commands

**Approach:** "Run `git pull origin main`"

**Problem:** Violates non-technical user constraint, asks user to "microfix technical things"

**User feedback:** "You cannot ask me to start microfixing technical things - you are forgetting our roles there."

---

## Current Communication Gap

### What I (AI Agent) Say

**Typical statements:**
- "I updated the README"
- "I fixed the bug in script X"
- "I created file Y"
- "All master documents are now current"

**What I actually mean:**
- "Changes are on origin/main (GitHub remote)"

**What user hears:**
- "I can see this now"

### What User Expects

**Non-technical user mental model:**
- "Updated" = I can see it when I look
- "Created" = It exists where I'm looking
- "Fixed" = Problem resolved for me

**User doesn't think about:**
- Local vs. remote
- Sync requirements
- Git workflows

---

## The Systemic Questions

### 1. Communication Patterns

**Question:** How should AI agents communicate completion status to non-technical users in git-based workflows where automation handles remote repository but user checks local repository?

**Our need:**
- Communication pattern that bridges local/remote gap
- Language that's clear for non-technical users
- Avoids assumptions about git knowledge

**Options to evaluate:**
- Say "Updated on GitHub (you'll need to sync)" - but user doesn't know how to sync
- Say "Updated remotely - check GitHub web interface" - but user wants to see it locally
- Say "Updated - run this command to see it" - violates non-technical constraint

**What works for multi-agent + non-technical user context?**

### 2. Synchronization Protocols

**Question:** What are industry best practices for ensuring non-technical users in git-based development workflows stay synchronized with remote repository without requiring git knowledge?

**Our constraints:**
- User is non-technical (no git knowledge expected)
- Automation handles remote work (can't require manual git commands)
- User needs to see changes locally (for their workflow)
- Solution must be simple, preferably automatic

**Options to evaluate:**
- Automatic local sync (possible? safe? how?)
- Desktop notifications when remote changes (tools? patterns?)
- Web-based interface instead of local (defeats purpose?)
- Automated scripts that hide git complexity (how?)

**What patterns exist for this scenario?**

### 3. Definition of "Done"

**Question:** In multi-agent AI development with non-technical users, how should "done" be defined when work involves remote repository that user doesn't directly interact with?

**Current mismatch:**
- **AI agent:** Done = on origin/main (remote)
- **Non-technical user:** Done = visible locally

**Need:** Definition that works for both, or protocol to bridge the gap

**Options to evaluate:**
- Redefine "done" = user confirms visibility locally
- Add automation step: notify + sync user's local
- Change user workflow: check GitHub web, not local
- Split definition: "done remotely" vs. "done for you"

**What's the right approach for non-technical users?**

### 4. User Experience Design

**Question:** What UX patterns exist for multi-stakeholder development where some stakeholders (AI agents) work with git automation but other stakeholders (non-technical users) need simple access without git knowledge?

**Our scenario:**
- AI agents: Technical, use git, automation handles complexity
- Human user: Non-technical, strategic role, needs visibility
- Gap: User can't see AI agents' work without manual sync

**UX needs:**
- User can see current project state easily
- User doesn't need to understand git
- User knows when new work is available
- User can access new work without commands

**Options to evaluate:**
- Dashboard showing remote state (web interface)
- Sync button hiding git complexity (desktop app)
- Email notifications with links to changes (GitHub)
- Automatic background sync (safety concerns?)

**What patterns work for non-technical users in this context?**

### 5. Automation Enhancements

**Question:** Can git workflows be enhanced to automatically handle local/remote sync for non-technical users while maintaining safety and correctness?

**Safety concerns:**
- Automatic pull could conflict with local changes
- User might be in middle of work
- Sync at wrong time could be disruptive

**Ideal solution:**
- Detect when safe to sync (no local changes)
- Automatically sync user's local with remote
- Notify user when sync happens
- Prevent conflicts

**Options to evaluate:**
- Git hooks that auto-pull when safe (pre-command hooks)
- Desktop app that syncs in background (GitHub Desktop, etc.)
- Scheduled sync with conflict detection (cron + safety checks)
- "Smart sync" that knows when user is active (monitoring)

**What exists? What's safe? What's recommended?**

### 6. Role-Appropriate Workflows

**Question:** How should workflows be structured when some participants (AI agents) have technical capabilities but other participants (non-technical users) need simple, non-technical access to the same artifacts?

**Our role division:**
- **AI agents:** Technical work, git fluent, automation users
- **Human user:** Strategic work, non-technical, needs visibility

**Current problem:**
- AI agent workflow optimized for automation (works great)
- Human user workflow assumes git knowledge (doesn't work)
- No bridge between the two

**Need:**
- AI agents continue using technical workflows
- Human user gets non-technical access to results
- Both see same state without manual coordination

**Options to evaluate:**
- Dual interface: Git for AI, web for user (separate views)
- Abstraction layer: Hide git behind simple UI (wrapper)
- Notification + assistance: Tell user sync needed, provide simple button (guided)
- Repository dashboard: Show state without local copy (cloud-based)

**What patterns exist for mixed technical/non-technical teams?**

---

## Constraints and Considerations

### User Constraints

**Non-Technical User:**
- Explicitly no git knowledge expected
- Cannot be asked to run git commands
- Cannot be expected to understand local/remote distinction
- Strategic role, not technical execution role

**User Feedback (Direct Quote):**
> "You cannot ask me to start microfixing technical things - you are forgetting our roles there."

**Implication:** Solution must not require user to run commands, understand git, or troubleshoot technical issues.

### Technical Constraints

**Current System:**
- Git-based version control (fundamental architecture)
- Automated workflows on remote (GitHub Actions)
- Multiple AI agents working on remote
- User has local clone of repository

**Can't Change:**
- Git as underlying system (too foundational)
- Automated workflows (they work well)
- Remote-first approach (required for AI agent collaboration)

**Can Change:**
- How user interacts with system
- What automation does after merging
- Communication patterns
- Definition of "done"

### Project Principles

**AI-First:**
- Primary users are AI agents (must stay optimized for them)
- Human is strategic partner, not in execution loop
- Automation preferred over manual processes

**Holistic System Thinking:**
- Consider ripple effects of any solution
- Don't break what works (automation)
- Bridge gaps rather than replace working parts

**Non-Technical Friendly (from Product Vision):**
- Must work for non-technical users
- Configuration over implementation
- Clear, visible processes

---

## Desired Research Outcomes

### What We Need from Perplexity AI

**1. Communication Pattern Recommendations**

For AI agents communicating completion to non-technical users:
- Language that accounts for local/remote distinction
- Patterns that set correct expectations
- Terminology that's clear without git knowledge

**2. Synchronization Solution Patterns**

For keeping non-technical user's local repository synced:
- Automatic sync options (if safe/feasible)
- Notification systems (when updates available)
- GUI tools that hide git complexity
- Workflow patterns that bridge the gap

**3. Definition of "Done" Framework**

For multi-agent development with non-technical users:
- When should AI agent consider work complete?
- How to communicate completion meaningfully?
- Protocols for ensuring user visibility

**4. UX Patterns for Mixed Teams**

For teams where some stakeholders are technical (AI agents) and others are non-technical (human):
- Dashboard or interface options
- Notification and update mechanisms
- Simplified access patterns
- Real-world examples

**5. Automation Enhancement Recommendations**

For automatic local/remote sync:
- Safety considerations
- Conflict detection
- When to sync vs. when to notify
- Tools that exist for this purpose

**6. Best Practices and Case Studies**

From other projects with similar challenges:
- How others solved this problem
- Tools they used
- Patterns that worked
- Pitfalls to avoid

### Success Criteria for Research

Research is successful if it provides:

1. ✅ Clear understanding of how other projects handle non-technical users in git workflows
2. ✅ Concrete solution options we can implement (not just theory)
3. ✅ Communication patterns that bridge technical/non-technical gap
4. ✅ Automation options that maintain safety
5. ✅ Real-world examples or case studies
6. ✅ Consideration of our specific constraints (AI-first, non-technical user, automated workflows)
7. ✅ Actionable recommendations we can implement immediately

---

## What We're NOT Looking For

**Not about:**
- Teaching user git (violates non-technical constraint)
- Changing automation that works (it's fine)
- Branch strategy (not the problem - automation handles it)
- Technical workflows for AI agents (already optimized)

**We're looking for:**
- Bridge between working automation and non-technical user visibility
- Communication patterns that work for both audiences
- User experience solutions that hide complexity
- Protocols that ensure everyone sees same state

---

## Output Format Request

**Please structure research findings as:**

### 1. Problem Validation

**Is this a common problem?**
- Do other teams face this?
- What do they call it?
- How significant is it?

### 2. Communication Patterns

**For AI → Non-Technical User:**
- Language patterns that work
- How to communicate "done" meaningfully
- Terminology that's clear without git knowledge
- Examples from other projects

### 3. Synchronization Solutions

**For keeping user's local current:**

**Pattern A:** Automatic sync approaches
- How it works
- Safety considerations
- Tools that provide this
- Pros/cons

**Pattern B:** Notification-based approaches
- How it works
- User experience
- Tools/patterns that exist
- Pros/cons

**Pattern C:** Alternative access patterns
- Web-based access instead of local
- Dashboard showing remote state
- GUI tools that abstract git
- Pros/cons

**Recommendation:** Which pattern best fits our constraints?

### 4. UX Design Patterns

**For mixed technical/non-technical teams:**
- Interface patterns that work
- Role-appropriate access methods
- Real-world implementations
- Tools/platforms that provide this

### 5. "Done" Definition Framework

**For our context:**
- When should AI consider work complete?
- How to communicate status meaningfully?
- Protocol for user confirmation or auto-sync
- Examples from other projects

### 6. Implementation Guidance

**For our specific situation:**
- Step-by-step approach to implement recommended solution
- Tools or services we need
- Changes to automation or workflows
- Changes to communication patterns
- Validation that solution meets constraints

### 7. Case Studies

**If available:**
- Projects with similar challenges
- How they solved it
- Tools/patterns they used
- Lessons learned
- Results/outcomes

### 8. Resources and Further Reading

**Provide:**
- Documentation on solutions recommended
- Tools mentioned (GitHub Desktop, alternatives)
- Research on non-technical users in technical workflows
- Community discussions
- Best practices guides

---

## Concrete Example: What Happened

**Session:** 2025-11-13, Late morning

**Work completed by AI agent (me):**
1. Updated 5 master documents (README, CONTRIBUTING, CHANGELOG, MILESTONES, BRANCHING_STRATEGY)
2. Fixed bug in agent-check-registry.sh (integer expression errors)
3. Created perplex-transformer specification (specs/001-perplex-transformer/spec.md)
4. Created CLI guidance prompts (comprehensive implementation guide)
5. Created Perplexity research prompt (first version, about branch strategy)

**All work:**
- Committed to feature branch
- Pushed to remote
- Automated PR creation triggered
- Validation passed
- Auto-merged to main
- **Currently on origin/main (GitHub)**

**AI agent (me) said:**
> "I updated the README and 4 other master documents comprehensively."
> "I fixed the bug in agent-check-registry.sh."
> "I created comprehensive Perplexity prompt."

**User checked:**
- Local main branch
- Files showed old content
- Bug still present in local copy
- Prompt not visible

**User response:**
> "I am looking at the repository, you said you had updated the README.md and other things. I see none of that on main branch. I still see the old README.md"

**Later:**
> "I do not see the prompt anywhere. I am on main."

**Root cause:**
- User's local main not synced with origin/main
- Simple `git pull origin main` would fix it
- But user doesn't know this (non-technical)
- And shouldn't need to know (role constraint)

**What we need:**
- Either automatic sync (user doesn't need to do anything)
- Or clear notification + simple action (one button, not commands)
- Or alternative access (web interface showing current state)

---

## Additional Context

### Why This Matters

**From product vision:**
> "For the Human User (Non-Technical): Seamless, trustworthy, clear, visible, effortless"

**Current reality:** Not meeting this vision. User can't see work, has to ask AI where things are, doesn't understand why "updated" files aren't visible.

### Why Traditional Git Workflows Don't Fit

**Traditional git workflow assumes:**
- All participants understand git
- Everyone knows to pull before checking state
- Technical knowledge is baseline requirement

**Our reality:**
- AI agents: Full git knowledge, automation users
- Human user: No git knowledge, strategic partner
- Mismatch creates visibility gap

### Previous Misdiagnosis

**What I initially thought:**
- Branch strategy problem
- Visibility-driven branching needed
- Artifacts on wrong branches

**What's actually true:**
- Branch strategy works fine (automation handles it)
- Everything IS on main (origin/main)
- User just can't see it (local not synced)

**This research request:** Based on correct diagnosis, not the first (incorrect) one.

---

## Summary

**Core Research Request:**

"In multi-agent AI development with git-based automation where AI agents work on remote repository but non-technical human partner checks local repository, how can we ensure the user sees completed work without requiring them to understand or manually execute git commands?"

**Sub-questions:**
1. Communication: How to say "done" meaningfully?
2. Sync: How to keep user's local current automatically or simply?
3. UX: What interface patterns work for mixed teams?
4. Definition: How to define "done" that works for both AI and non-technical user?
5. Automation: Can we auto-sync safely?
6. Patterns: What do other projects do?

**Constraints:**
- User is non-technical (no git knowledge)
- Automation works perfectly (don't break it)
- AI agents need technical workflows (keep optimized)
- Solution must be simple, preferably automatic
- Must respect role boundaries (user is strategic, not technical)

**Goal:**
- Bridge between working automation and non-technical user visibility
- Everyone sees same state without manual coordination
- Communication that works for both audiences
- Definition of "done" that's meaningful to all stakeholders

---

**Prepared by:** Claude Code Web (Designer-Researcher)
**Date:** 2025-11-13 (Revised after correct diagnosis)
**Project:** Perplex - Multi-Agent AI Development
**Purpose:** Get expert guidance on local/remote sync for non-technical users

**Thank you for your research assistance!**

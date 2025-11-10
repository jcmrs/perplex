# Product Vision: Project Perplex

**Last Updated:** 2025-11-10
**Status:** Foundation Phase - Initial Definition

## The Problem We're Solving

Local AI development tools (Claude Code CLI, Gemini CLI) frequently need to collaborate with Perplexity AI for research tasks. Perplexity AI excels at structured research, providing clear outputs, full references, examples, and sources.

**Current Reality:**
- Manual context-switching between AI tools and browser
- Cumbersome back-and-forth copy-paste workflows
- Risk of context contamination between projects
- Loss of research artifacts and conversation history
- No integration path (no API, no CLI)

**The Pain:**
For non-technical users working with AI development tools, the collaboration with Perplexity AI requires constant manual intervention, breaking flow and creating friction in the development process.

## What Success Feels Like

### For the Human User (Non-Technical)
- **Seamless:** AI agents handle Perplexity collaboration transparently
- **Trustworthy:** Research artifacts are preserved and organized automatically
- **Clean:** No context pollution between projects
- **Visible:** Can see what research is happening without being in the loop
- **Effortless:** Sets direction, AI agents handle mechanics

### For the AI Agent (Claude/Gemini)
- **Autonomous:** Can leverage Perplexity research without human intervention (where possible)
- **Organized:** Clear systems for capturing and retrieving research
- **Contextual:** Access to relevant Perplexity conversations per project
- **Integrated:** Research flows naturally into development workflow

## Core Principles (What This Product IS)

1. **A Bridge, Not a Replacement**
   - Connects existing tools, doesn't replace them
   - Respects strengths of each AI system

2. **Context-Aware**
   - Project-specific Perplexity conversations
   - No cross-contamination
   - Proper isolation and organization

3. **Non-Technical Friendly**
   - Works for users who don't write code
   - Configuration over implementation
   - Clear, visible processes

4. **AI-Autonomous**
   - Primary user is the AI agent
   - Minimal human intervention required
   - Self-documenting and self-maintaining

## What This Product IS NOT

- Not a Perplexity API wrapper (none exists)
- Not trying to replicate Perplexity's research capabilities
- Not a general-purpose AI orchestration platform
- Not requiring technical expertise to use

## How It Works (Aspirational)

### Phase 1: Manual Capture (Foundation)
- Structured way to capture Perplexity conversations
- Organized storage per project
- Clear process for AI agents to request research
- Templates for consistent capture

### Phase 2: Integration Exploration
- Investigate browser automation possibilities
- Explore conversation extraction methods
- Research technical feasibility of deeper integration

### Phase 3: Seamless Collaboration
- AI agents can trigger Perplexity research
- Automated capture and organization
- Integrated into natural development workflow

## Success Metrics

**Foundation Phase:**
- ✅ Clear, documented process for Perplexity collaboration exists
- ⬜ Non-technical user can follow process without confusion
- ⬜ Research artifacts are captured and organized
- ⬜ No context contamination between projects

**Integration Phase:**
- ⬜ Reduced manual steps for collaboration
- ⬜ Automated capture of research findings
- ⬜ AI agents can autonomously leverage Perplexity

**Mature Product:**
- ⬜ Near-zero manual intervention for research collaboration
- ⬜ Research seamlessly integrated into development flow
- ⬜ Reusable patterns for multi-AI collaboration

## The Experience We're Creating

Imagine working on a project with Claude Code. Claude identifies a need for deep research on browser automation techniques. Instead of:

1. Claude asking you to research
2. You opening Perplexity
3. You conducting research
4. You copying results back
5. Claude processing the information

The experience becomes:

1. Claude identifies research need
2. System captures request with full context
3. Research happens (manually at first, automated eventually)
4. Results automatically flow back to project
5. Claude continues with research integrated

The human's role: Strategic direction, not mechanical execution.

## What Makes This Special

This isn't about building yet another AI tool. It's about recognizing that:

1. Different AI systems have different strengths
2. Collaboration between them creates synergy
3. The human should set strategy, not execute mechanics
4. Context management is a first-class problem
5. AI-first means infrastructure for AI agents

## Non-Negotiables

- Must work for non-technical users
- Must prevent context contamination
- Must preserve all research artifacts
- Must be maintainable by AI agents across sessions
- Must align with foundation imperatives

## Open Questions

(To be answered during discovery phase)

- What technical integration paths actually exist?
- How can we capture Perplexity conversations programmatically?
- What browser automation approaches are viable?
- How do we handle authentication and sessions?
- What's the right level of automation vs. manual process?

---

**Living Document Notice:**
This vision will evolve as we learn. Changes must be intentional and documented. The core problem and principles remain constant; the solution approach adapts.

## For AI Agents

Read this document before any significant work. If your proposed changes conflict with this vision, raise it for discussion. If you discover the vision is incomplete or incorrect, propose updates.

## For Human Partner

This document should always reflect your strategic intent. If it doesn't, let's update it together.

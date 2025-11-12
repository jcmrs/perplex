# ADR-008: Perplexity AI Integration Architecture

**Date:** 2025-11-12
**Status:** Proposed
**Decision Makers:** AI Agent (Claude), pending Human Partner validation
**Phase:** Discovery

---

## Context

Project Perplex aims to bridge local AI development tools (Claude Code, Gemini CLI) with Perplexity AI's research capabilities. The discovery phase question was: **"What technical integration paths exist for Perplexity AI?"**

External AI research (Perplexity AI, GitHub Copilot) identified multiple viable paths:
- Perplexity API (official, documented)
- Python wrappers with browser automation
- Semantic memory systems (Basic Memory, Graphiti, KGGen)
- No-code platforms (n8n, Pabbly, Make.com)
- AI orchestration frameworks (CrewAI, AutoGPT)

**Key Discovery:** Perplexity AI HAS an official API, contradicting initial assumption of "no API, no CLI."

---

## Decision

**Adopt a modular, layered architecture with:**

1. **Primary Integration:** Perplexity API (official cookbook recipes)
2. **Core Memory System:** Basic Memory (local-first, Markdown-based semantic memory)
3. **Fallback Capture:** Python wrapper (if API proves insufficient)
4. **Optional GUI Layer:** n8n (for non-technical user customization)
5. **Storage:** GitHub repository (Markdown files, version-controlled)

**Deferred to Phase 2/Future:**
- CrewAI (multi-agent orchestration) - overkill for MVP
- Graphiti/Zep (advanced knowledge graphs) - Basic Memory sufficient
- KGGen (advanced graph extraction) - nice-to-have, not critical
- Browser automation - last resort fallback only

---

## Architecture

```
Human User (Non-Technical)
    ↓
AI Agent (Claude/Gemini CLI) ← autonomous, CLI-driven
    ↓
Integration Layer:
    • Perplexity API (primary) ← official, stable
    • Python Wrapper (fallback) ← if API insufficient
    ↓
Semantic Memory Layer:
    • Basic Memory (CORE) ← local, Markdown, knowledge graphs
    • Optional: KGGen (future) ← advanced analysis
    ↓
GitHub Repository ← persistent, version-controlled storage
    • Markdown research notes
    • Knowledge graph files
    • Session logs
```

---

## Rationale

### Why Basic Memory as Core?

**Perfect alignment with all foundation imperatives:**

1. **AI-First** ✅✅
   - Explicitly designed for AI agent memory
   - CLI-driven, scriptable
   - No manual GUI dependency

2. **Configurability** ✅✅
   - Markdown files = ultimate human-readable configuration
   - Local files, no external services required
   - Version-controlled settings

3. **Modularity** ✅
   - Standalone Python package
   - Clear interfaces
   - Replaceable without disrupting other components

4. **Extensibility** ✅
   - Open source (MIT license)
   - Forkable, customizable
   - Plugin-friendly architecture

5. **Integration** ✅✅
   - GitHub-native (Markdown in repo)
   - Already integrates with Claude Desktop
   - Compatible with Obsidian, other tools

6. **Automation** ✅
   - CLI-driven
   - Scriptable workflows
   - No manual intervention needed

7. **Holistic System Thinking** ✅
   - Local-first (no cloud lock-in)
   - Human-readable (non-technical friendly)
   - Persistent (survives across sessions)

**Additional benefits:**
- NO API keys required (privacy, simplicity)
- Bidirectional sync (AI and human can edit)
- Knowledge graph built automatically from conversations
- Markdown format = readable by humans AND AI agents

### Why Perplexity API as Primary Integration?

1. **Official support** - stable, documented, long-term viable
2. **Direct access** - no fragile UI scraping
3. **Structured data** - predictable format
4. **Cookbook exists** - integration recipes already documented
5. **Automation-friendly** - scriptable, no browser required

### Why Defer CrewAI?

- MVP needs simple capture/memory, not complex orchestration
- Can add later when multi-agent collaboration needed
- Avoids premature complexity
- Basic scripts sufficient for Phase 1

### Why Defer Graphiti/Zep?

- Basic Memory provides semantic memory and knowledge graphs
- Graphiti is more complex, higher learning curve
- Can evaluate later if Basic Memory proves insufficient
- YAGNI principle - don't add until needed

### Why Optional n8n?

- **For non-technical users:** Visual workflow builder
- **For AI agents:** CLI/script path remains primary
- **Self-hosted:** Open source, no vendor lock-in
- **Not required:** Core system works without it

---

## Consequences

### Positive

1. **Local-first, no vendor lock-in**
   - All data in GitHub repo (Markdown)
   - No cloud dependencies
   - Privacy-preserving

2. **AI-agent friendly**
   - Basic Memory designed for AI memory
   - CLI-driven workflows
   - Autonomous operation possible

3. **Non-technical accessible**
   - Markdown files readable by humans
   - Optional n8n GUI for visual customization
   - No coding required for basic usage

4. **Modular, replaceable components**
   - Can swap Perplexity API for wrapper
   - Can swap Basic Memory for Graphiti later
   - Can add CrewAI without disrupting existing system

5. **Version-controlled memory**
   - GitHub tracks all research artifacts
   - Full history, rollback capability
   - Traceability to decisions/sessions

6. **Extensible foundation**
   - Can add KGGen for advanced analysis
   - Can add CrewAI for multi-agent orchestration
   - Can add custom tools without breaking existing

### Negative

1. **Python dependency**
   - Requires Python runtime
   - May complicate deployment for some users
   - Mitigation: Provide Docker container or clear setup guide

2. **Basic Memory learning curve**
   - New tool to learn
   - Documentation needed
   - Mitigation: Create Perplex-specific guides

3. **Perplexity API limitations unknown**
   - May not capture all features of web UI
   - May have rate limits or costs
   - Mitigation: Python wrapper as fallback

4. **No immediate multi-agent orchestration**
   - Deferred CrewAI = limited cross-AI collaboration initially
   - Mitigation: Simple scripts sufficient for MVP; add CrewAI in Phase 2

### Risks

1. **Perplexity API access**
   - Risk: May require paid tier
   - Impact: Medium
   - Mitigation: Fallback to Python wrapper with browser automation

2. **Basic Memory compatibility**
   - Risk: May not integrate smoothly with our workflow
   - Impact: Medium
   - Mitigation: Open source, can fork and customize

3. **Scope creep**
   - Risk: Too many optional tools (n8n, KGGen, etc.) complicates system
   - Impact: Medium
   - Mitigation: Keep core simple (API + Basic Memory), make rest truly optional

---

## Alternatives Considered

### Alternative 1: Browser Automation Only (Puppeteer/Selenium)

**Rejected because:**
- Fragile (UI changes break automation)
- Complex setup (browser runtime required)
- Not AI-first (requires visual rendering)
- Maintenance burden high

### Alternative 2: No-Code Platform Primary (Pabbly, Make.com)

**Rejected because:**
- Vendor lock-in (paid, cloud)
- Not AI-first (GUI-oriented)
- Less flexible than code-based solutions
- Monthly costs for continued operation

### Alternative 3: Graphiti/Zep as Primary Memory

**Rejected because:**
- More complex than needed for MVP
- Basic Memory simpler, sufficient for initial needs
- Can add Graphiti later if needed
- YAGNI - don't build what we don't need yet

### Alternative 4: Custom Solution (Build Everything)

**Rejected because:**
- Reinventing wheel (Basic Memory exists)
- Higher development cost
- Lower quality (less tested than existing solutions)
- Violates "use existing tools" principle

---

## Validation Criteria

This architecture is successful if:

1. ✅ **AI agent can autonomously capture Perplexity conversations**
   - No manual copy-paste required
   - Scriptable, automated workflow

2. ✅ **Research artifacts persist in GitHub repo**
   - Markdown files committed
   - Version-controlled
   - Human-readable

3. ✅ **Semantic memory works across sessions**
   - Basic Memory builds knowledge graph
   - AI agent can query past research
   - Context survives session boundaries

4. ✅ **Non-technical user can understand and use**
   - Markdown files readable
   - Clear documentation
   - Optional GUI (n8n) available if wanted

5. ✅ **System remains modular and extensible**
   - Can replace components independently
   - Can add features (CrewAI, KGGen) without breaking existing
   - No tight coupling

---

## Implementation Plan

### Phase 1: MVP (Current Phase)

**Goal:** Prove integration works end-to-end

1. **Experiment with Perplexity API**
   - Obtain API access
   - Test conversation capture
   - Document capabilities and limits
   - Create test scripts

2. **Integrate Basic Memory**
   - Install locally
   - Configure for Perplex
   - Test Markdown output
   - Validate GitHub workflow

3. **Create Automation Scripts**
   - Script: Query Perplexity API
   - Script: Feed response to Basic Memory
   - Script: Commit to GitHub repo
   - End-to-end test

4. **Document Workflow**
   - User guide (non-technical)
   - AI agent guide (operational)
   - Configuration examples
   - Troubleshooting

**Success Criteria:**
- Can capture Perplexity conversation automatically
- Memory stored as Markdown in repo
- AI agent can query semantic memory
- Non-technical user can read research artifacts

---

### Phase 2: Enhancement (Post-MVP)

**Goal:** Robustness and optional features

1. **Evaluate Python Wrapper**
   - Test wallaceokeke/perplexity-ai-wrapper
   - Compare with API
   - Decide if needed as fallback

2. **Optional: n8n GUI**
   - Install self-hosted
   - Create visual workflows
   - User testing

3. **Enhance Memory System**
   - Test KGGen integration
   - Evaluate Graphiti for advanced cases
   - Optimize knowledge graph quality

**Success Criteria:**
- Fallback capture method validated
- Optional GUI available if desired
- Knowledge graph quality high

---

### Phase 3: Multi-Agent (Future)

**Goal:** AI-to-AI collaboration at scale

1. **CrewAI Integration**
   - Prototype multi-agent workflows
   - Test Claude ↔ Perplexity ↔ Gemini
   - Document orchestration patterns

2. **Cross-Project Memory**
   - Shared knowledge base
   - Memory federation
   - Privacy isolation

**Success Criteria:**
- Multiple AI agents collaborate autonomously
- Memory shared intelligently across projects
- No context pollution

---

## Open Questions (User Validation Needed)

1. **Perplexity API Access**
   - Do we have or can we obtain API access?
   - Free tier sufficient or paid tier needed?
   - Rate limits acceptable?

2. **User Preference: CLI vs. GUI**
   - Is CLI/script-only acceptable?
   - Should we invest in n8n GUI layer?
   - How important is visual workflow builder?

3. **Scope: Memory Depth**
   - MVP: Simple capture and storage?
   - Or include semantic analysis from day one?
   - How sophisticated should knowledge graph be initially?

4. **GitHub Integration Depth**
   - Files only?
   - Also create GitHub issues from research?
   - Integrate with project boards?

5. **Privacy**
   - Concerns about storing Perplexity conversations in repo?
   - Public vs. private repository?
   - Any sensitive data handling needed?

---

## Related Decisions

- **ADR-001:** Foundation Methodology (discovery-driven)
- **ADR-002:** Foundation Enhancements (enforcement, traceability)
- **ADR-006:** Checkpoint System (continuity across sessions)

---

## References

- Discovery Findings: `/docs/DISCOVERY_FINDINGS.md`
- Product Vision: `/docs/PRODUCT_VISION.md`
- Foundation Imperatives: `/FOUNDATION.md`
- Basic Memory: https://github.com/basicmachines-co/basic-memory
- Perplexity API Cookbook: https://docs.perplexity.ai/cookbook
- Perplexity AI Wrapper: https://github.com/wallaceokeke/perplexity-ai-wrapper

---

## Notes for Next Session

**If this ADR is accepted:**
1. Begin hands-on experimentation with Perplexity API
2. Install and configure Basic Memory
3. Create proof-of-concept integration script
4. Document findings in session log

**If this ADR needs revision:**
1. Incorporate feedback
2. Re-evaluate alternatives
3. Update architecture diagram
4. Seek re-approval

---

**Last Updated:** 2025-11-12
**Status:** Proposed (awaiting human partner validation)
**Next Review:** After user feedback on open questions

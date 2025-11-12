# Discovery Phase: Technical Integration Paths for Perplexity AI

**Date:** 2025-11-12
**Phase:** Discovery
**Status:** Initial Findings
**Research Sources:** External AI analysis (Perplexity AI, GitHub Copilot, Claude)

---

## Executive Summary

**Key Discovery:** Perplexity AI DOES have an official API (contradicting initial assumption). Multiple viable integration paths exist, ranging from direct API usage to browser automation, semantic memory systems, and no-code platforms.

**Critical Finding:** A robust ecosystem of open-source solutions already exists for:
- Perplexity AI conversation capture and export
- Semantic memory and knowledge graph generation
- AI-to-AI collaboration and orchestration
- GitHub integration and automation

**Strategic Recommendation:** Adopt a **modular, layered architecture** combining:
1. **Basic Memory** (local-first semantic memory)
2. **Perplexity API** (official integration path)
3. **Browser automation** (fallback/enhancement)
4. **n8n or similar** (optional no-code layer for non-technical users)

---

## Integration Paths Discovered

### 1. Official API Integration

**Solution:** Perplexity API + Cookbook
**Source:** https://docs.perplexity.ai/cookbook

**Capabilities:**
- Direct API access to Perplexity AI
- Structured query/response patterns
- Conversation logging recipes
- Integration patterns for external systems

**Alignment with Foundation Imperatives:**
- ✅ **Configurability:** API-driven, credentials in config
- ✅ **Integration:** Official, stable integration point
- ✅ **Automation:** Scriptable, no manual intervention
- ⚠️ **AI-First:** Requires API key management (complexity for non-technical)

**Pros:**
- Official, stable, documented
- Direct programmatic access
- Most reliable long-term path

**Cons:**
- May require paid API access
- API may not expose all web features
- Rate limits possible

**Recommendation:** **PRIMARY PATH** - Use as foundation for automated integration.

---

### 2. Python Wrappers & Automation

**Solution:** wallaceokeke/perplexity-ai-wrapper
**Source:** https://github.com/wallaceokeke/perplexity-ai-wrapper

**Capabilities:**
- Browser automation for Perplexity web interface
- Async interaction and session management
- Export to JSON/Markdown
- CLI tools for scripting

**Alignment with Foundation Imperatives:**
- ✅ **Modularity:** Wrapper abstracts Perplexity complexity
- ✅ **Extensibility:** Open source, forkable, customizable
- ✅ **Automation:** CLI-driven, scriptable
- ✅ **Integration:** Export formats compatible with knowledge systems

**Pros:**
- Works if API is insufficient
- Captures web-only features
- Already has export to Markdown (repo-friendly)

**Cons:**
- Browser automation fragile (UI changes break it)
- More complex setup than API
- Requires browser runtime

**Recommendation:** **FALLBACK PATH** - Use if API proves insufficient for conversation capture.

---

### 3. Semantic Memory & Knowledge Graphs

#### 3a. Basic Memory (RECOMMENDED)

**Solution:** Basic Memory
**Source:** https://github.com/basicmachines-co/basic-memory

**Capabilities:**
- Local-first, Markdown-based semantic memory
- NO API keys required
- Builds knowledge graphs from conversation logs
- Syncs with Obsidian, Claude Desktop
- Bidirectional, version-controlled memory

**Alignment with Foundation Imperatives:**
- ✅✅ **AI-First:** Designed explicitly for AI agent memory
- ✅✅ **Configurability:** Markdown files = ultimate configuration
- ✅✅ **Modularity:** Standalone, composable with other tools
- ✅✅ **Integration:** GitHub-native (Markdown in repo)
- ✅ **Automation:** CLI-driven, scriptable

**Pros:**
- Perfect fit for Perplex philosophy (local-first, repo-based, AI-first)
- No external dependencies or API keys
- Human-readable, version-controlled memory
- Already integrates with Claude Desktop
- Non-technical friendly (Markdown files)

**Cons:**
- Requires local Python setup
- May need customization for Perplexity-specific workflows

**Recommendation:** **CORE MEMORY LAYER** - Adopt as primary semantic memory system for Perplex.

---

#### 3b. KGGen (Stanford)

**Solution:** KGGen - Knowledge Graph Generator
**Source:** https://github.com/stanford-stairlab/kg-gen

**Capabilities:**
- Converts unstructured text to semantic triples
- Extracts entities and relationships
- Multi-format export (JSON, CSV, graph DBs)

**Alignment with Foundation Imperatives:**
- ✅ **Extensibility:** Pluggable graph extraction
- ✅ **Modularity:** Can work alongside Basic Memory
- ✅ **Automation:** CLI-driven

**Recommendation:** **OPTIONAL ENHANCEMENT** - Use for advanced graph analysis if needed.

---

#### 3c. Graphiti & Zep

**Solution:** Temporal knowledge graphs for AI agents
**Source:** https://github.com/getzep/graphiti

**Capabilities:**
- Real-time, temporally-aware knowledge graphs
- Semantic + keyword + graph-based search
- Agent memory across sessions
- State-of-the-art agent memory architecture

**Alignment with Foundation Imperatives:**
- ✅ **AI-First:** Explicitly designed for AI agent memory
- ✅ **Extensibility:** Modular memory architecture
- ⚠️ **Configurability:** More complex setup

**Recommendation:** **FUTURE EXPLORATION** - Defer to post-MVP; Basic Memory sufficient for initial needs.

---

### 4. AI-to-AI Collaboration Orchestration

**Solution:** CrewAI
**Source:** https://github.com/joaomdmoura/crewAI

**Capabilities:**
- Multi-agent orchestration framework
- Agent-to-agent messaging via "crews" and "flows"
- Autonomous delegation and role-based design
- Built-in memory systems

**Alignment with Foundation Imperatives:**
- ✅ **AI-First:** Designed for autonomous AI collaboration
- ✅ **Modularity:** Agent-based architecture
- ✅ **Extensibility:** Plugin ecosystem
- ✅ **Integration:** Can connect Claude Code CLI, Gemini CLI, Perplexity

**Pros:**
- Solves exact problem: AI-to-AI collaboration
- Widely adopted, mature ecosystem
- Local execution possible (no cloud required)

**Cons:**
- Adds orchestration layer complexity
- May be overkill for initial use case

**Recommendation:** **PHASE 2 EXPLORATION** - Evaluate once basic Perplexity integration works. May be ideal for scaling beyond simple capture/retrieval.

---

### 5. No-Code/Low-Code Platforms

**Solutions:**
- n8n (open source, self-hosted)
- Pabbly Connect, BuildShip, Make.com (cloud, paid)
- Bardeen.ai (browser automation)

**Capabilities:**
- Visual workflow builders
- Pre-built integrations for Perplexity + GitHub
- Trigger-based automation
- Non-technical user friendly

**Alignment with Foundation Imperatives:**
- ✅✅ **Non-Technical Friendly:** Visual, no coding required
- ✅ **Configurability:** Workflow-driven configuration
- ✅ **Integration:** Pre-built connectors
- ⚠️ **AI-First:** GUI-oriented, not ideal for AI agent autonomy
- ⚠️ **Modularity:** Platform lock-in risk (except n8n)

**Pros:**
- Fast prototyping
- Non-technical user can configure
- Pre-built Perplexity + GitHub integrations exist

**Cons:**
- Most are paid/cloud (except n8n)
- Less flexible than code-based solutions
- Not ideal for AI agent-driven workflows

**Recommendation:** **OPTIONAL LAYER** - Consider n8n (open source) as an OPTIONAL interface for non-technical users. Core system should remain CLI/script-based for AI autonomy.

---

### 6. Browser Automation (Fallback)

**Solutions:**
- Puppeteer, Selenium, Playwright
- Perplexity Lens (browser extension)

**Capabilities:**
- Capture Perplexity conversations from web UI
- Extract HTML/Markdown
- Automate interactions programmatically

**Alignment with Foundation Imperatives:**
- ✅ **Automation:** Can be scripted
- ⚠️ **Integration:** Fragile (UI changes break automation)
- ❌ **Modularity:** Tightly coupled to web UI

**Recommendation:** **LAST RESORT FALLBACK** - Only use if API + wrapper prove insufficient. Prioritize stable API/wrapper paths.

---

## Recommended Architecture

### Layered, Modular Approach

```
┌─────────────────────────────────────────────────────┐
│  Human User (Non-Technical)                         │
│  - Sets strategic direction                         │
│  - Reviews research artifacts in repo               │
│  - Optional: Uses n8n GUI for custom workflows      │
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│  AI Agent (Claude Code, Gemini CLI)                 │
│  - Autonomous operation                             │
│  - CLI/script-driven                                │
│  - Reads/writes Markdown in repo                    │
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│  Integration Layer (Modular Components)             │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │ Perplexity API (Primary)                     │   │
│  │ - Official cookbook recipes                  │   │
│  │ - Structured queries                         │   │
│  │ - Conversation export                        │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │ Python Wrapper (Fallback)                    │   │
│  │ - wallaceokeke/perplexity-ai-wrapper         │   │
│  │ - Browser automation if needed               │   │
│  │ - Export to JSON/Markdown                    │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│  Semantic Memory Layer                              │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │ Basic Memory (CORE)                          │   │
│  │ - Local Markdown files                       │   │
│  │ - Semantic knowledge graph                   │   │
│  │ - Version-controlled in repo                 │   │
│  │ - AI-readable and human-readable             │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │ Optional: KGGen (Enhancement)                │   │
│  │ - Advanced graph extraction                  │   │
│  │ - Entity/relationship analysis               │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│  GitHub Repository (Persistent Storage)             │
│  - Markdown research notes                          │
│  - Knowledge graph files                            │
│  - Session logs                                     │
│  - All version-controlled                           │
└─────────────────────────────────────────────────────┘
```

### Component Responsibilities

1. **Perplexity API/Wrapper** → Capture conversations
2. **Basic Memory** → Semantic memory, knowledge graph, persistent storage
3. **GitHub Repo** → Version control, artifact storage, traceability
4. **AI Agent** → Autonomous operation, script execution, research orchestration
5. **Optional: n8n** → GUI layer for non-technical customization

---

## Decision Matrix: Which Solutions to Adopt?

| Solution | Adopt Now | Defer | Rationale |
|----------|-----------|-------|-----------|
| **Perplexity API** | ✅ YES | - | Official, stable, primary integration path |
| **Basic Memory** | ✅ YES | - | Perfect fit: local-first, Markdown, AI-first, repo-native |
| **wallaceokeke wrapper** | ⚠️ MAYBE | - | Adopt if API insufficient for conversation capture |
| **n8n (open source)** | ⚠️ MAYBE | - | Optional GUI layer; evaluate based on user preference |
| **CrewAI** | ❌ NO | Phase 2 | Powerful but overkill for MVP; revisit for multi-agent orchestration |
| **Graphiti/Zep** | ❌ NO | Phase 2 | Advanced; Basic Memory sufficient for now |
| **KGGen** | ❌ NO | Optional | Nice-to-have; Basic Memory has graph capabilities |
| **Browser automation** | ❌ NO | Fallback | Last resort; prefer API/wrapper |
| **Paid platforms** | ❌ NO | - | Avoid vendor lock-in; use open source equivalents |

---

## Alignment with Foundation Imperatives

### 1. Holistic System Thinking ✅
- Modular layers allow independent evolution
- Each component has clear boundaries
- Ripple effects considered (API changes → wrapper fallback)

### 2. AI-First ✅✅
- Basic Memory explicitly designed for AI agents
- CLI/script-driven (no manual GUI dependency)
- Markdown = machine-readable + human-readable

### 3. Configurability ✅
- API credentials in config files
- Basic Memory uses Markdown (ultimate config)
- n8n workflows are configuration

### 4. Modularity ✅
- Clear component boundaries (capture, memory, storage)
- Components replaceable independently
- No tight coupling

### 5. Extensibility ✅
- Open source solutions (forkable, customizable)
- Plugin points (Basic Memory, n8n, CrewAI)
- Can add KGGen, Graphiti later without disruption

### 6. Integration ✅
- GitHub-native storage (Markdown files)
- Standard interfaces (API, CLI, Markdown)
- Pre-built integrations available (n8n, Pabbly)

### 7. Automation ✅
- API/wrapper = scriptable
- Basic Memory = CLI-driven
- No manual copy-paste required

---

## Alignment with Product Vision

### Problem: Manual context-switching, copy-paste friction
**Solution:** Perplexity API + Basic Memory = automated capture, semantic memory, repo storage

### Goal: AI-autonomous collaboration with Perplexity
**Solution:** API/wrapper + CLI-driven memory system = zero manual intervention

### Non-Technical User Friendly
**Solution:** Markdown files (human-readable), optional n8n GUI

### Context-Aware, No Pollution
**Solution:** Basic Memory supports project-specific memory graphs

### Preserve Research Artifacts
**Solution:** GitHub repo + Markdown = version-controlled, permanent

---

## Next Steps (Proposed)

### Phase 1: Foundation (MVP)
1. **Experiment with Perplexity API**
   - Review cookbook recipes
   - Test conversation capture
   - Document API capabilities and limitations

2. **Integrate Basic Memory**
   - Install and configure locally
   - Test Markdown output
   - Validate GitHub integration
   - Confirm Claude Desktop compatibility

3. **Create Integration Scripts**
   - Script: Perplexity API → Basic Memory → GitHub
   - Automation: Trigger on research request
   - Template: Research artifact format

4. **Document Workflow**
   - User guide for non-technical users
   - AI agent operational guide
   - Configuration examples

### Phase 2: Enhancement (Post-MVP)
1. **Evaluate Python Wrapper**
   - Test wallaceokeke/perplexity-ai-wrapper
   - Compare with API for conversation capture
   - Determine if needed as fallback

2. **Optional: n8n GUI**
   - Install self-hosted n8n
   - Create visual workflows for common operations
   - User testing with non-technical partner

3. **Explore Multi-Agent Orchestration**
   - Prototype with CrewAI
   - Test Claude ↔ Perplexity ↔ Gemini collaboration
   - Document orchestration patterns

### Phase 3: Advanced (Future)
1. **Advanced Knowledge Graphs**
   - Integrate KGGen or Graphiti
   - Enhanced semantic analysis
   - Temporal relationship tracking

2. **Cross-Project Memory**
   - Shared knowledge base
   - Memory federation
   - Privacy-preserving isolation

---

## Open Questions for User Validation

1. **API Access:** Do we have/can we obtain Perplexity API access? (Paid vs. free tier?)
2. **User Preference:** Would a visual GUI (n8n) be valuable, or is CLI/script-only acceptable?
3. **Scope:** Should MVP focus solely on conversation capture, or include semantic analysis from day one?
4. **Integration Depth:** How deep should GitHub integration go? (Files only? Issues? Project boards?)
5. **Privacy:** Any concerns about storing Perplexity conversations in GitHub repo? (Public vs. private repo?)

---

## References

### Official Documentation
- Perplexity API Cookbook: https://docs.perplexity.ai/cookbook

### GitHub Projects
- Basic Memory: https://github.com/basicmachines-co/basic-memory
- Perplexity AI Wrapper: https://github.com/wallaceokeke/perplexity-ai-wrapper
- CrewAI: https://github.com/joaomdmoura/crewAI
- KGGen: https://github.com/stanford-stairlab/kg-gen
- Graphiti: https://github.com/getzep/graphiti
- LouminAI Labs: https://github.com/LouminAILabs/perplexity-projects

### No-Code Platforms
- n8n (open source): https://n8n.io
- Pabbly Connect: https://www.pabbly.com/connect/integrations/github/perplexity-ai/
- BuildShip: https://buildship.com/integrations/apps/github-and-perplexity

### Additional Tools
- mcp-brain-tools: https://github.com/j3k0/mcp-brain-tools
- Perplexity Lens: https://github.com/iamaayushijain/perplexity-lens

---

## Conclusion

**We have multiple viable paths.** The discovery phase reveals a rich ecosystem of solutions that align remarkably well with Perplex's foundation imperatives.

**Recommended MVP Stack:**
1. **Perplexity API** (capture)
2. **Basic Memory** (semantic memory + knowledge graph)
3. **GitHub** (persistent storage)
4. **Python scripts** (automation glue)

**This stack is:**
- ✅ Local-first (no cloud lock-in)
- ✅ AI-first (designed for agents)
- ✅ Open source (forkable, extensible)
- ✅ Non-technical friendly (Markdown files)
- ✅ Modular (components replaceable)
- ✅ Automated (scriptable, no manual steps)

**Next milestone:** Validate this architecture with hands-on experimentation.

---

**Last Updated:** 2025-11-12
**Status:** Initial discovery complete; awaiting validation and experimentation phase
**For Questions:** See "Open Questions for User Validation" section above

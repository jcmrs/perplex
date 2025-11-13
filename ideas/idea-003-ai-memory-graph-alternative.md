# Idea 003: AI Memory Graph Alternative

**Date:** 2025-11-12
**Status:** Logged for Future Evaluation
**Source:** User suggestion during Spec Kit integration discussion
**Priority:** Research

---

## Overview

**Repository:** https://github.com/ErdemYavuz55/ai-memory-graph

**Description:** Alternative or complementary approach to memory graph management for AI agents.

**Context:** Discovered while planning Spec Kit integration for Project Perplex. Currently using basic-memory (MCP server) for knowledge graph storage with project isolation.

---

## Why This Might Be Relevant

**Current Stack:**
- basic-memory (0.16.1) - MCP server for knowledge graphs
- PROJECT=perplex environment variable for isolation
- Storage: ~/basic-memory/perplex/
- Tools: write_note, read_note, build_context, search

**Potential Considerations:**
1. Does ai-memory-graph offer capabilities basic-memory doesn't?
2. Better multi-project isolation?
3. More sophisticated graph relationships?
4. Different query/retrieval patterns?
5. Integration with our MCP architecture?

---

## Research Questions

**Before evaluating:**
1. What problem does ai-memory-graph solve?
2. How does it differ from basic-memory?
3. Is it MCP-compatible?
4. Does it support project isolation?
5. What's the maintenance/activity status?
6. Examples of usage in AI agent workflows?

**Integration considerations:**
1. Can it replace basic-memory, or complement it?
2. Would switching align with Foundation imperatives (stability, modularity)?
3. Migration path if we wanted to switch?
4. Does it offer advantages for Perplexity conversation transformation?

---

## Foundation Alignment Check

**Before adoption, verify:**

**Holistic System Thinking:**
- How does switching impact existing Stage 1 work?
- Ripple effects on perplex-transformer and perplex-reader designs?
- Compatibility with multi-agent coordination?

**AI-First:**
- Does it improve AI agent autonomy?
- Better documentation/understanding than basic-memory?
- More AI-friendly API?

**Five Cornerstones:**
- **Configurability:** Configuration-driven behavior?
- **Modularity:** Can be swapped without rewriting everything?
- **Extensibility:** Plugin/extension support?
- **Integration:** MCP-compatible? Works with existing tools?
- **Automation:** Scriptable operations?

---

## Action Items

**Phase: Research (Not Immediate)**

1. ⬜ Read repository README and documentation
2. ⬜ Compare feature set with basic-memory
3. ⬜ Check MCP compatibility
4. ⬜ Evaluate project isolation support
5. ⬜ Review maintenance status (last commit, issues, PRs)
6. ⬜ Look for usage examples in AI workflows
7. ⬜ Assess migration complexity (if considering switch)

**Decision Criteria:**
- ✅ Offers significant advantages over basic-memory
- ✅ MCP-compatible or has migration path
- ✅ Actively maintained
- ✅ Aligns with Foundation imperatives
- ✅ Migration justifies disruption to current work

**If fails criteria:** Stay with basic-memory (proven, working, integrated)

---

## Notes

**Timing:** Logged during foundation phase, but evaluation should wait until:
1. Spec Kit integrated and working
2. Phase 1 specifications complete
3. perplex-transformer architecture stable
4. Clear gap identified that ai-memory-graph fills

**Principle:** "Don't fix what isn't broken" - basic-memory is working. Only switch if compelling advantages identified.

---

## Related

- **Current Memory Solution:** basic-memory MCP server
- **Stage 1 Deliverables:** STAGE1_DELIVERABLES.md
- **MCP Memory Schema:** MCP_MEMORY_GRAPH_SCHEMA.md
- **Foundation Imperatives:** FOUNDATION.md

---

**Status:** Idea logged, research deferred until foundation stable.
**Next Step:** Continue with Spec Kit integration (current priority).
**Revisit:** After Phase 1 specifications complete, if memory limitations identified.

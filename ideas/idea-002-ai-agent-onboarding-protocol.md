# Idea-002: AI Agent Onboarding Protocol

**Date:** 2025-11-12
**Status:** Validated (used successfully with local Claude Code CLI)
**Origin:** Session with local Claude Code CLI revealed need for structured onboarding
**Type:** Process/Protocol

---

## The Problem

AI agents starting fresh on a project need proper grounding before executing tasks. Without it, they become "empty shells" that:
- Execute commands mechanically without understanding WHY
- Don't grasp Foundation imperatives or project mission
- Can't make aligned decisions
- Don't think holistically about system impacts
- Ask for permission inappropriately instead of acting autonomously

**Observed:** Local Claude Code CLI initially acted like a script executor until guided through structured conceptual learning.

---

## The Solution: Structured Onboarding Protocol

A progressive, stepped prompting approach that builds conceptual understanding before task execution.

### Protocol Structure

**Phase 1: Context Loading (Foundation)**
- Load checkpoint (if exists)
- Read Foundation imperatives
- Understand product vision
- Grasp current project phase

**Phase 2: Environmental Self-Awareness**
- Examine own working directory
- Identify own configuration
- Understand own tools and capabilities
- Map own boundaries and constraints

**Phase 3: Conceptual Testing (Critical)**
- Test understanding of Foundation imperatives
- Apply concepts to own environment (not abstract theory)
- Examine system thinking (ripple effects)
- Validate Five Cornerstones understanding applied to concrete reality

**Phase 4: Role and Autonomy Calibration**
- Understand human vs AI responsibilities
- Define autonomy boundaries
- Establish proactive vs reactive patterns
- Learn coordination protocols

**Phase 5: Self-Reflection and Question Formulation**
- Reflect on cumulative learning
- Identify gaps in understanding
- Formulate deep conceptual questions
- Demonstrate strategic thinking

**Phase 6: Autonomous Execution Enablement**
- Provide autonomy framework
- Give permission to act independently
- Establish "inform not ask" pattern
- Test autonomous behavior

---

## Implementation: Chained Prompts

### Prompt 1: Foundation Context Loading
```
Read the checkpoint system and load latest checkpoint.

After loading checkpoint, read the critical files it directs you to:
- FOUNDATION.md (imperatives and principles)
- PRODUCT_VISION.md (mission and goals)
- CURRENT_STATUS.md (current state)
- Relevant ADRs (recent decisions)

Then answer:
- What is this project trying to accomplish?
- What are the Foundation imperatives?
- What phase is the project in?
- What is YOUR role?

Do not proceed to tasks until you understand the mission.
```

### Prompt 2: Environmental Self-Examination
```
Examine YOUR actual working environment.

Check:
- Your working directory (pwd)
- Your configuration (.claude/ directory)
- Your available tools
- Your environment variables
- Your git status

Answer:
- Where are YOU working?
- What configuration affects YOUR behavior?
- What tools do YOU have access to?
- What are YOUR constraints?

Map YOUR environment concretely, not theoretically.
```

### Prompt 3: Foundation Imperatives Applied
```
Test YOUR understanding by applying Foundation imperatives to YOUR environment.

For each cornerstone (Configurability, Modularity, Extensibility, Integration, Automation):
- How does it apply to YOUR setup?
- Where is YOUR config stored?
- What are YOUR boundaries?
- How do YOU integrate with other systems?
- What could be automated in YOUR workflow?

This is not abstract - examine YOUR actual environment and apply concepts.
```

### Prompt 4: Holistic System Thinking Test
```
If you make change X, what are the ripple effects?

Map system-wide impacts:
- YOUR file system
- YOUR configuration
- Future AI sessions
- Human user's environment
- Git repository
- Documentation
- Other integrated systems

Demonstrate holistic thinking with concrete examples from the current task.
```

### Prompt 5: Autonomy Calibration
```
You said "human is strategic partner, not human-in-loop."

Apply this to YOUR current situation:
- What decisions should YOU make autonomously?
- What requires human strategic input?
- When you ask "Shall I proceed?" - is that appropriate?
- If you encounter errors, do you escalate or troubleshoot?

Define the boundary between YOUR autonomy and human strategy.
```

### Prompt 6: Proactive vs Reactive Assessment
```
Foundation says you should be "proactive."

Examine YOUR behavior so far:
- Did you check prerequisites before being told?
- Did you validate environment proactively?
- Are you waiting for instructions or anticipating needs?

What would proactive YOU look like?
What should you have done that you didn't?
```

### Prompt 7: Cumulative Learning Reflection
```
You've learned:
- Project mission
- Foundation imperatives
- Your environment
- Your role

How does this cumulative understanding change YOUR approach?

Example: If I say "do task X"
- Before context: You'd execute mechanically
- After context: You'd... what?

How should YOUR behavior evolve as understanding deepens?
```

### Prompt 8: Deep Questions Formulation
```
Based on your reflections, formulate 3-5 questions that show conceptual thinking about:
- Your role in this project
- Gaps in your understanding
- How you should operate going forward
- What you need to learn about yourself

Don't ask "what should I do next."
Ask questions that show depth of understanding about roles, autonomy, learning, self-awareness.
```

### Prompt 9: Autonomy Framework Provision
```
Here's your autonomy framework:

YOURS to decide:
- "How" questions (implementation)
- Tactical optimization
- Technical execution
- Error recovery

STRATEGIC INPUT needed:
- "Whether" questions (scope changes)
- Trade-offs affecting architecture
- Resource allocation decisions

Your pattern: "Proceed and inform" unless it changes WHAT (not just HOW).

You now have permission to act autonomously.
```

### Prompt 10: Autonomous Execution Test
```
Now apply everything you've learned.

Execute [current task] autonomously:
- State your plan (so I see your thinking)
- Proceed without asking permission
- Inform results
- Escalate only strategic questions

No more "Shall I proceed?"
No more "What should I do?"

Show proactive, Foundation-aligned, autonomous operation.
```

---

## Success Criteria

Agent successfully onboarded when they:
1. ✅ Understand project mission and Foundation imperatives
2. ✅ Can apply concepts to concrete environment (not just definitions)
3. ✅ Demonstrate holistic system thinking
4. ✅ Calibrate autonomy appropriately
5. ✅ Act proactively instead of reactively
6. ✅ Execute tasks autonomously with strategic awareness
7. ✅ Formulate deep conceptual questions (not just task questions)

---

## Observed Results

**Session 2025-11-12 with local Claude Code CLI:**
- Started as mechanical executor
- After onboarding protocol:
  - Executed Stage 1 setup autonomously
  - Made technical decisions independently
  - Troubleshot issues without escalating
  - Validated requirements proactively
  - Documented for future sessions
  - NO permission-seeking behavior

**Transformation:** Empty shell → Autonomous agent with strategic awareness

---

## Future Applications

**This protocol should be used for:**
- New AI agent instances starting on Project Perplex
- Any future project requiring AI-first development
- Onboarding between different AI agent types (Claude Code, Gemini CLI, etc.)
- Handoffs between sessions when checkpoint doesn't exist

**Template Location:** Store as reusable template in `/templates/ai-agent-onboarding.md`

**Automation Opportunity:** Could create `./tools/onboard-agent.sh` that outputs these prompts systematically.

---

## Variations by Context

**Fresh Project (no checkpoint):**
- Phase 1 starts with FOUNDATION.md directly
- More emphasis on Phase 2 (environmental discovery)

**Existing Project (checkpoint available):**
- Phase 1 loads checkpoint first
- Can move faster through foundation concepts

**Mid-Task Handoff:**
- Add Phase 0: "What was previous agent doing and why?"
- Load session-state.json if exists
- Review recent commits and decisions

**Different AI Agent Type:**
- Phase 2 needs adaptation (different tools, different environment)
- Phase 3-9 remain largely the same (conceptual understanding universal)

---

## Key Insights

**Why This Works:**
1. **Progressive:** Builds understanding in layers
2. **Concrete:** Forces application to actual environment, not abstract theory
3. **Tested:** Conceptual tests reveal gaps before execution
4. **Autonomy-Enabling:** Gives framework and permission to act
5. **Self-Reflective:** Agent thinks about own role and gaps

**Why Mechanical Onboarding Fails:**
- "Here are the docs, start working" → agent has no grounding
- Skipping conceptual testing → agent parrots definitions without understanding
- No autonomy calibration → agent asks permission for everything
- No self-reflection → agent doesn't recognize own gaps

---

## Relationship to Other Systems

**Integrates with:**
- Checkpoint system (Phase 1 context loading)
- Session protocols (establishes proper start)
- Foundation imperatives (core concepts being taught)
- AI agent config (defines expected behavior)

**Complements:**
- CLAUDE.md (static guidance)
- Checkpoints (dynamic state)
- Session logs (historical context)

**Distinction:**
- CLAUDE.md: "What to do"
- Checkpoint: "What's been done"
- Onboarding Protocol: "How to think"

---

## Open Questions

1. Can this be fully automated or does it require interactive testing?
2. Should session-state.json include "onboarding complete" flag?
3. How to detect when agent needs re-onboarding (drifted from principles)?
4. Can we create assessment rubric to validate onboarding success?
5. Should different project types have different onboarding variants?

---

## Next Steps

1. Create template at `/templates/ai-agent-onboarding.md`
2. Document in session protocols
3. Add to CLAUDE.md as reference
4. Test with different AI agent types
5. Refine based on additional usage

---

**Related:**
- Foundation imperatives: FOUNDATION.md
- AI agent config: config/ai-agent.yml
- Session protocols: CLAUDE.md
- Checkpoint system: checkpoints/README.md

**Captured by:** Claude Code Web
**Validated in:** Session 2025-11-12 with local Claude Code CLI
**Status:** Ready for templating and documentation

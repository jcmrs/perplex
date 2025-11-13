# Agent Handoff Markers

**Purpose:** Track work transitions between agents across sessions

## What Are Handoff Markers?

Handoff markers are JSON files that persist handoff state when one agent completes work and transitions to another agent. They ensure handoffs survive session restarts and provide clear coordination signals.

## Structure

Each handoff marker is a timestamped JSON file:

```
.claude/handoffs/
├── 20251113120000-spec-to-plan.json
├── 20251113140000-plan-to-validation.json
└── README.md (this file)
```

## Marker Schema

```json
{
  "timestamp": "2025-11-13T12:00:00Z",
  "from_agent": "web-claude-designer-001",
  "to_agent": "cli-claude-executor-001",
  "artifact": "specs/001-perplex-transformer/spec.md",
  "trigger": "spec_complete",
  "validation_criteria": [
    "spec.md exists and is complete",
    "Success criteria defined"
  ],
  "status": "pending",
  "acknowledged_at": null,
  "completed_at": null
}
```

## Lifecycle

1. **Created:** Agent runs `tools/agent-handoff.sh`
2. **Pending:** Next agent hasn't acknowledged yet
3. **Acknowledged:** Next agent runs `tools/agent-start-work.sh`
4. **Completed:** Work artifact finished, next handoff created or stage complete

## Status Values

- `pending` - Waiting for target agent to acknowledge
- `acknowledged` - Target agent started work
- `completed` - Work finished, marker archived

## Cleanup

Completed markers should be archived or deleted after:
- Successful merge of work
- Checkpoint creation
- Stage completion

Markers older than 7 days can be cleaned up automatically.

## Git Tracking

This directory is git-tracked to persist handoffs across:
- Session restarts
- Environment switches (Web → CLI)
- Collaboration handoffs

Empty directory tracked via this README.

---

**Created:** 2025-11-13
**Part of:** Agent Workspace Coordination (ADR-011)

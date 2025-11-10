# Session Continuity System

**Purpose:** Maintain state and context across AI agent sessions.

## Critical Files

- `CURRENT_STATUS.md` - Always-current project state snapshot
- `session-YYYYMMDD-HHMMSS.md` - Individual session logs

## Session Protocol

### Session Start
1. Read `/FOUNDATION.md`
2. Read `CURRENT_STATUS.md`
3. Review recent decisions and docs
4. Create new session log

### During Session
- Document significant actions
- Note discoveries and blockers
- Track decisions made

### Session End
1. Update `CURRENT_STATUS.md`
2. Finalize session log
3. Commit all changes
4. Push to repository

## For AI Agents

**CRITICAL:** This is your institutional memory across sessions. Maintain it religiously.

## For Humans

Session logs provide full transparency into AI agent activities and decision-making.

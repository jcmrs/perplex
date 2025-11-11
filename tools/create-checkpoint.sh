#!/bin/bash
# Create Checkpoint Script
# Captures project state for session continuity

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=========================================="
echo "Create Checkpoint"
echo "=========================================="
echo ""

# Get checkpoint description
DESCRIPTION="$1"
if [ -z "$DESCRIPTION" ]; then
    read -p "Checkpoint description: " DESCRIPTION
    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="checkpoint"
    fi
fi

# Generate checkpoint ID and timestamp
TIMESTAMP=$(date -u +"%Y%m%d-%H%M%S")
CHECKPOINT_ID=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
CHECKPOINT_FILE="checkpoints/checkpoint-${TIMESTAMP}-${CHECKPOINT_ID}.md"
GRAPH_FILE="checkpoints/checkpoint-${TIMESTAMP}-${CHECKPOINT_ID}-graph.json"

echo "📝 Creating checkpoint: $CHECKPOINT_ID"
echo "   Timestamp: $TIMESTAMP"
echo ""

# Gather git information
CURRENT_BRANCH=$(git branch --show-current)
LAST_COMMIT=$(git log -1 --format="%h" 2>/dev/null || echo "none")
LAST_COMMIT_MSG=$(git log -1 --format="%s" 2>/dev/null || echo "")

# Count items in systems
DECISION_COUNT=$(find decisions -name "*.md" -type f 2>/dev/null | grep -v README | grep -v TEMPLATE | wc -l || echo "0")
IDEA_COUNT=$(find ideas -name "*.md" -type f 2>/dev/null | grep -v README | grep -v TEMPLATE | grep -v INDEX | wc -l || echo "0")
BACKLOG_COUNT=$(find backlog/items -name "*.md" -type f 2>/dev/null | grep -v TEMPLATE | wc -l || echo "0")

# Get phase from config
PHASE=$(grep "phase:" config/project.yml | awk '{print $2}' | tr -d '"' || echo "unknown")

echo "📊 Project State:"
echo "   Phase: $PHASE"
echo "   Branch: $CURRENT_BRANCH"
echo "   Decisions: $DECISION_COUNT"
echo "   Ideas: $IDEA_COUNT"
echo "   Backlog items: $BACKLOG_COUNT"
echo ""

# Interactive mode: ask for key information
echo "Please provide checkpoint details:"
echo ""

read -p "Current phase [default: $PHASE]: " PHASE_INPUT
PHASE=${PHASE_INPUT:-$PHASE}

read -p "Next phase [default: discovery]: " NEXT_PHASE
NEXT_PHASE=${NEXT_PHASE:-discovery}

read -p "30-second summary: " SUMMARY

read -p "Primary focus for next session: " FOCUS

echo ""
echo "Critical files to read (one per line, empty line when done):"
CRITICAL_FILES=()
while true; do
    read -p "  File path: " FILE
    if [ -z "$FILE" ]; then
        break
    fi
    read -p "    Reason: " REASON
    CRITICAL_FILES+=("$FILE|$REASON")
done

echo ""
read -p "What to skip (comma-separated patterns): " SKIP_PATTERNS

# Create checkpoint markdown file
cat > "$CHECKPOINT_FILE" <<EOF
# Checkpoint: $DESCRIPTION

**Checkpoint ID:** checkpoint-${TIMESTAMP}-${CHECKPOINT_ID}
**Date:** $(date -u +"%Y-%m-%d %H:%M UTC")
**Phase:** $PHASE
**Next Phase:** $NEXT_PHASE

---

## 30-Second Summary

$SUMMARY

Current phase: $PHASE
Last commit: $LAST_COMMIT - $LAST_COMMIT_MSG
Branch: $CURRENT_BRANCH

---

## Read First (Priority Order)

**Critical (Read immediately):**
1. This checkpoint (you're doing it)
EOF

# Add critical files
INDEX=2
for item in "${CRITICAL_FILES[@]}"; do
    FILE=$(echo "$item" | cut -d'|' -f1)
    REASON=$(echo "$item" | cut -d'|' -f2)
    echo "$INDEX. $FILE - $REASON" >> "$CHECKPOINT_FILE"
    ((INDEX++))
done

cat >> "$CHECKPOINT_FILE" <<EOF

**Important (Read soon):**
- sessions/CURRENT_STATUS.md - Current project state
- FOUNDATION.md - Core principles

**Skip for Now (Save tokens):**
EOF

IFS=',' read -ra SKIP_ARRAY <<< "$SKIP_PATTERNS"
for pattern in "${SKIP_ARRAY[@]}"; do
    echo "- $pattern" >> "$CHECKPOINT_FILE"
done

cat >> "$CHECKPOINT_FILE" <<EOF

---

## Current State

### Phase Status
- Current phase: $PHASE
- Next phase: $NEXT_PHASE
- Branch: $CURRENT_BRANCH
- Last commit: $LAST_COMMIT

### Active Work
- Primary focus: $FOCUS

---

## Recent Decisions (ADRs)

$(ls -t decisions/*.md 2>/dev/null | grep -v README | grep -v TEMPLATE | head -3 | while read adr; do
    TITLE=$(grep "^# " "$adr" | head -1 | sed 's/^# //')
    echo "- $(basename "$adr"): $TITLE"
done)

---

## Active Systems Status

### Ideas
- Total: $IDEA_COUNT

### Backlog
- Total items: $BACKLOG_COUNT

### Requirements
- Total: 0 (none created yet)

---

## Key Relationships

See memory graph: \`$(basename "$GRAPH_FILE")\`

---

## Next Actions

**Immediate next session should:**
- $FOCUS

---

## Context-Critical Information

**Git State:**
- Branch: $CURRENT_BRANCH
- Last commit: $LAST_COMMIT - $LAST_COMMIT_MSG

**Memory graph:** \`$(basename "$GRAPH_FILE")\`

---

## Recovery Instructions

**If resuming after crash:**
1. Read this checkpoint
2. Load memory graph: \`$(basename "$GRAPH_FILE")\`
3. Read files marked "Critical" above
4. Check commits since this checkpoint
5. Continue from "Next Actions"

---

## Checkpoint Metadata

**Created by:** $(whoami) (AI Agent)
**Trigger:** Manual
**Memory graph:** \`$(basename "$GRAPH_FILE")\`

---

**Status:** Active
EOF

echo "✅ Checkpoint file created: $CHECKPOINT_FILE"

# Create memory graph JSON
cat > "$GRAPH_FILE" <<EOF
{
  "checkpoint_id": "checkpoint-${TIMESTAMP}-${CHECKPOINT_ID}",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "phase": "$PHASE",
  "next_phase": "$NEXT_PHASE",

  "critical_files": [
EOF

# Add critical files to JSON
FIRST=true
for item in "${CRITICAL_FILES[@]}"; do
    FILE=$(echo "$item" | cut -d'|' -f1)
    REASON=$(echo "$item" | cut -d'|' -f2)
    if [ "$FIRST" = false ]; then
        echo "," >> "$GRAPH_FILE"
    fi
    echo -n "    {\"path\": \"$FILE\", \"reason\": \"$REASON\", \"priority\": \"critical\"}" >> "$GRAPH_FILE"
    FIRST=false
done

cat >> "$GRAPH_FILE" <<EOF

  ],

  "active_work": {
    "focus": "$FOCUS",
    "blockers": [],
    "next_steps": []
  },

  "relationships": {
EOF

# Add relationships for existing ADRs
FIRST=true
for adr in $(ls decisions/*.md 2>/dev/null | grep -v README | grep -v TEMPLATE); do
    ADR_ID=$(basename "$adr" .md)
    if [ "$FIRST" = false ]; then
        echo "," >> "$GRAPH_FILE"
    fi
    echo -n "    \"$ADR_ID\": {\"type\": \"decision\", \"status\": \"active\"}" >> "$GRAPH_FILE"
    FIRST=false
done

cat >> "$GRAPH_FILE" <<EOF

  },

  "skip_for_now": [
EOF

# Add skip patterns to JSON
FIRST=true
for pattern in "${SKIP_ARRAY[@]}"; do
    if [ "$FIRST" = false ]; then
        echo "," >> "$GRAPH_FILE"
    fi
    echo -n "    \"$pattern\"" >> "$GRAPH_FILE"
    FIRST=false
done

cat >> "$GRAPH_FILE" <<EOF

  ],

  "git_state": {
    "branch": "$CURRENT_BRANCH",
    "last_commit": "$LAST_COMMIT",
    "last_commit_message": "$LAST_COMMIT_MSG"
  }
}
EOF

echo "✅ Memory graph created: $GRAPH_FILE"

# Create symlink to latest
ln -sf "$(basename "$CHECKPOINT_FILE")" checkpoints/LATEST.md 2>/dev/null || true
ln -sf "$(basename "$GRAPH_FILE")" checkpoints/LATEST-graph.json 2>/dev/null || true

echo ""
echo "=========================================="
echo "✅ Checkpoint created successfully!"
echo "=========================================="
echo ""
echo "Files created:"
echo "  - $CHECKPOINT_FILE"
echo "  - $GRAPH_FILE"
echo ""
echo "To resume from this checkpoint:"
echo "  ./tools/resume-from-checkpoint.sh"
echo ""

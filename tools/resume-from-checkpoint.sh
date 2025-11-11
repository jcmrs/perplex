#!/bin/bash
# Resume from Checkpoint Script
# Loads project state for session continuation

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Get checkpoint file
CHECKPOINT_FILE="$1"
DRY_RUN=false

if [ "$1" = "--dry-run" ] || [ "$2" = "--dry-run" ]; then
    DRY_RUN=true
fi

if [ -z "$CHECKPOINT_FILE" ] || [ "$1" = "--dry-run" ]; then
    # Use latest checkpoint
    if [ -L "checkpoints/LATEST.md" ]; then
        CHECKPOINT_FILE="checkpoints/$(readlink checkpoints/LATEST.md)"
    else
        echo "❌ No checkpoint found. Use --list to see available checkpoints."
        exit 1
    fi
fi

if [ ! -f "$CHECKPOINT_FILE" ]; then
    echo "❌ Checkpoint file not found: $CHECKPOINT_FILE"
    exit 1
fi

# Extract checkpoint ID and find graph
CHECKPOINT_ID=$(grep "^\*\*Checkpoint ID:\*\*" "$CHECKPOINT_FILE" | sed 's/.*: //')
GRAPH_FILE=$(echo "$CHECKPOINT_FILE" | sed 's/\.md$/-graph.json/')

echo "=========================================="
echo "Resuming from Checkpoint"
echo "=========================================="
echo ""

# Display checkpoint summary
echo "📋 Checkpoint: $(grep "^# Checkpoint:" "$CHECKPOINT_FILE" | sed 's/# Checkpoint: //')"
echo "   Date: $(grep "^\*\*Date:\*\*" "$CHECKPOINT_FILE" | sed 's/.*: //')"
echo "   Phase: $(grep "^\*\*Phase:\*\*" "$CHECKPOINT_FILE" | sed 's/.*: //')"
echo ""

# Extract and display 30-second summary
echo "📖 Summary:"
echo "──────────────────────────────────────────"
sed -n '/^## 30-Second Summary/,/^---/p' "$CHECKPOINT_FILE" | grep -v "^##" | grep -v "^---" | grep -v "^$"
echo "──────────────────────────────────────────"
echo ""

# Extract critical files
echo "📚 Critical Files to Read:"
sed -n '/^\*\*Critical (Read immediately):\*\*/,/^\*\*Important/p' "$CHECKPOINT_FILE" | \
    grep -E "^[0-9]" | while read line; do
    echo "  $line"
done
echo ""

# Check if memory graph exists
if [ -f "$GRAPH_FILE" ]; then
    echo "🔗 Memory Graph: $(basename "$GRAPH_FILE")"

    # Extract key relationships from graph
    if command -v jq &> /dev/null; then
        echo ""
        echo "Key Relationships:"
        jq -r '.relationships | to_entries[] | "  - \(.key): \(.value.type) (\(.value.status // "active"))"' "$GRAPH_FILE" 2>/dev/null || echo "  (Use jq to parse graph)"
    fi
else
    echo "⚠️  Memory graph not found: $GRAPH_FILE"
fi

echo ""

# Display next actions
echo "🎯 Next Actions:"
sed -n '/^## Next Actions/,/^---/p' "$CHECKPOINT_FILE" | \
    grep -E "^-|^[0-9]" | while read line; do
    echo "  $line"
done

echo ""
echo "──────────────────────────────────────────"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "ℹ️  Dry run complete. No files loaded."
    echo ""
    echo "To actually resume, run:"
    echo "  ./tools/resume-from-checkpoint.sh $CHECKPOINT_FILE"
else
    echo ""
    echo "✅ Context restored from checkpoint."
    echo ""
    echo "Recommended reading order:"
    echo "  1. This output (already read)"
    echo "  2. Files listed in 'Critical Files' above"
    echo "  3. Memory graph for relationships: $GRAPH_FILE"
    echo ""
    echo "Ready to continue work!"
fi

echo "=========================================="

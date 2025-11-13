#!/bin/bash
# Display three-agent registry status

REGISTRY_FILE=".claude/agent-registry.json"

if [ ! -f "$REGISTRY_FILE" ]; then
    echo "ERROR: Agent registry not found: $REGISTRY_FILE"
    exit 1
fi

echo "========================================="
echo "  Agent Registry Status (Three-Agent)"
echo "========================================="
echo

# CDIR (Designer-Researcher)
echo "CDIR (Designer-Researcher):"
if command -v jq &> /dev/null; then
    jq -r '.agents[] | select(.agent_id=="cli-claude-director-001") |
        "  Status: \(.status)\n  Branch: \(.workspace.current_work_branch // "none")\n  Work: \(.workspace.current_work)\n  Last Active: \(.last_active)"' \
        "$REGISTRY_FILE"
else
    grep -A 20 '"agent_id": "cli-claude-director-001"' "$REGISTRY_FILE" | head -15
fi
echo

# CEXE (Executor-Validator)
echo "CEXE (Executor-Validator):"
if command -v jq &> /dev/null; then
    jq -r '.agents[] | select(.agent_id=="cli-claude-executor-001") |
        "  Status: \(.status)\n  Branch: \(.workspace.current_work_branch // "none")\n  Work: \(.workspace.current_work)\n  Last Active: \(.last_active)"' \
        "$REGISTRY_FILE"
else
    grep -A 20 '"agent_id": "cli-claude-executor-001"' "$REGISTRY_FILE" | head -15
fi
echo

# Web (Standby-Emergency)
echo "Web (Standby-Emergency):"
if command -v jq &> /dev/null; then
    jq -r '.agents[] | select(.agent_id=="web-claude-designer-001") |
        "  Status: \(.status)\n  Branch: \(.workspace.current_work_branch // "none")\n  Work: \(.workspace.current_work)\n  Last Active: \(.last_active)"' \
        "$REGISTRY_FILE"
else
    grep -A 20 '"agent_id": "web-claude-designer-001"' "$REGISTRY_FILE" | head -15
fi
echo

echo "========================================="

#!/bin/bash
# Agent Check Registry Script
# Displays current agent activity and pending handoffs

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
AGENT_REGISTRY="$PROJECT_ROOT/.claude/agent-registry.json"
HANDOFFS_DIR="$PROJECT_ROOT/.claude/handoffs"

# Check if registry exists
if [ ! -f "$AGENT_REGISTRY" ]; then
    echo "Error: Agent registry not found at $AGENT_REGISTRY"
    exit 1
fi

# Detect current agent
CURRENT_AGENT=""
if [ -f "$PROJECT_ROOT/.claude/identity-web.json" ]; then
    # Could be Web, check environment indicators
    CURRENT_AGENT="web-claude-designer-001"
fi
if [ -f "$PROJECT_ROOT/.claude/identity-cli.json" ]; then
    # If CLI identity exists, it might be CLI
    CURRENT_AGENT="cli-claude-executor-001"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Agent Registry Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Parse JSON using grep/sed (simple extraction for our known structure)
# Note: This is a basic parser for our specific JSON structure

# Count agents
AGENT_COUNT=$(grep -c '"agent_id"' "$AGENT_REGISTRY" || echo "0")
echo "Active agents: $AGENT_COUNT"
echo ""

# Extract and display Web agent info
echo -e "${BLUE}═══ Claude Code Web (Designer-Researcher) ═══${NC}"
WEB_STATUS=$(grep -A 50 '"agent_id": "web-claude-designer-001"' "$AGENT_REGISTRY" | grep '"status"' | head -1 | sed 's/.*": "//;s/".*//')
WEB_LAST_ACTIVE=$(grep -A 50 '"agent_id": "web-claude-designer-001"' "$AGENT_REGISTRY" | grep '"last_active"' | head -1 | sed 's/.*": "//;s/".*//')
WEB_BRANCH=$(grep -A 50 '"agent_id": "web-claude-designer-001"' "$AGENT_REGISTRY" | grep '"current_work_branch"' | head -1 | sed 's/.*": "//;s/".*//')
WEB_STATE=$(grep -A 50 '"agent_id": "web-claude-designer-001"' "$AGENT_REGISTRY" | grep '"workspace_state"' | head -1 | sed 's/.*": "//;s/".*//')
WEB_WORK=$(grep -A 50 '"agent_id": "web-claude-designer-001"' "$AGENT_REGISTRY" | grep '"current_work"' | head -1 | sed 's/.*": "//;s/".*//')

if [ "$WEB_STATUS" = "active" ]; then
    echo -e "  Status: ${GREEN}✅ Active${NC}"
else
    echo -e "  Status: ⏸️  Idle"
fi

echo "  Last active: $WEB_LAST_ACTIVE"

if [ "$WEB_BRANCH" != "null" ] && [ -n "$WEB_BRANCH" ]; then
    echo "  Branch: $WEB_BRANCH"
fi

if [ "$WEB_STATE" != "null" ] && [ -n "$WEB_STATE" ]; then
    echo "  Workspace state: $WEB_STATE"
fi

if [ "$WEB_WORK" != "null" ] && [ -n "$WEB_WORK" ]; then
    echo "  Current work: $WEB_WORK"
fi

# Check for pending handoffs for Web
WEB_PENDING=$(grep -A 20 '"agent_id": "web-claude-designer-001"' "$AGENT_REGISTRY" | grep -A 5 '"pending_handoffs"' | grep -c '"from"' || echo "0")
if [ "$WEB_PENDING" -gt 0 ]; then
    echo -e "  ${YELLOW}📬 Pending handoffs: $WEB_PENDING${NC}"
fi

echo ""

# Extract and display CLI agent info
echo -e "${CYAN}═══ Claude Code CLI (Executor-Validator) ═══${NC}"
CLI_STATUS=$(grep -A 50 '"agent_id": "cli-claude-executor-001"' "$AGENT_REGISTRY" | grep '"status"' | head -1 | sed 's/.*": "//;s/".*//')
CLI_LAST_ACTIVE=$(grep -A 50 '"agent_id": "cli-claude-executor-001"' "$AGENT_REGISTRY" | grep '"last_active"' | head -1 | sed 's/.*": "//;s/".*//')
CLI_BRANCH=$(grep -A 50 '"agent_id": "cli-claude-executor-001"' "$AGENT_REGISTRY" | grep '"current_work_branch"' | head -1 | sed 's/.*": "//;s/".*//')
CLI_STATE=$(grep -A 50 '"agent_id": "cli-claude-executor-001"' "$AGENT_REGISTRY" | grep '"workspace_state"' | head -1 | sed 's/.*": "//;s/".*//')
CLI_WORK=$(grep -A 50 '"agent_id": "cli-claude-executor-001"' "$AGENT_REGISTRY" | grep '"current_work"' | head -1 | sed 's/.*": "//;s/".*//')

if [ "$CLI_STATUS" = "active" ]; then
    echo -e "  Status: ${GREEN}✅ Active${NC}"
else
    echo -e "  Status: ⏸️  Idle"
fi

echo "  Last active: $CLI_LAST_ACTIVE"

if [ "$CLI_BRANCH" != "null" ] && [ -n "$CLI_BRANCH" ]; then
    echo "  Branch: $CLI_BRANCH"
fi

if [ "$CLI_STATE" != "null" ] && [ -n "$CLI_STATE" ]; then
    echo "  Workspace state: $CLI_STATE"
fi

if [ "$CLI_WORK" != "null" ] && [ -n "$CLI_WORK" ]; then
    echo "  Current work: $CLI_WORK"
fi

# Check for pending handoffs for CLI
CLI_PENDING=$(grep -A 20 '"agent_id": "cli-claude-executor-001"' "$AGENT_REGISTRY" | grep -A 5 '"pending_handoffs"' | grep -c '"from"' || echo "0")
if [ "$CLI_PENDING" -gt 0 ]; then
    echo -e "  ${YELLOW}📬 Pending handoffs: $CLI_PENDING${NC}"
fi

echo ""

# Check for handoff markers in directory
if [ -d "$HANDOFFS_DIR" ]; then
    HANDOFF_COUNT=$(find "$HANDOFFS_DIR" -name "*.json" 2>/dev/null | wc -l)
    if [ "$HANDOFF_COUNT" -gt 0 ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📨 Active Handoff Markers"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        find "$HANDOFFS_DIR" -name "*.json" -type f 2>/dev/null | while read -r handoff_file; do
            echo "  📄 $(basename "$handoff_file")"
        done
        echo ""
    fi
fi

# Provide suggestions based on current agent
if [ -n "$CURRENT_AGENT" ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Suggestions"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [ "$CURRENT_AGENT" = "web-claude-designer-001" ] && [ "$WEB_PENDING" -gt 0 ]; then
        echo "  You have $WEB_PENDING pending handoff(s)"
        echo "  Run: tools/agent-start-work.sh to acknowledge and begin work"
        echo ""
    elif [ "$CURRENT_AGENT" = "cli-claude-executor-001" ] && [ "$CLI_PENDING" -gt 0 ]; then
        echo "  You have $CLI_PENDING pending handoff(s)"
        echo "  Run: tools/agent-start-work.sh to acknowledge and begin work"
        echo ""
    elif [ "$CURRENT_AGENT" = "web-claude-designer-001" ] && [ "$WEB_STATUS" = "idle" ]; then
        echo "  You are currently idle"
        echo "  Check pending work or start new specification"
        echo ""
    elif [ "$CURRENT_AGENT" = "cli-claude-executor-001" ] && [ "$CLI_STATUS" = "idle" ]; then
        echo "  You are currently idle"
        echo "  Wait for handoff from Web or check pending work"
        echo ""
    fi
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "For more details: cat .claude/agent-registry.json"
echo "For workspace boundaries: cat .claude/workspace-coordination.yml"
echo ""

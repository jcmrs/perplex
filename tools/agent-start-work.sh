#!/bin/bash
# Agent Start Work Script
# Initializes work on new artifact, updates registry, validates boundaries

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
AGENT_REGISTRY="$PROJECT_ROOT/.claude/agent-registry.json"
WORKSPACE_MANIFEST="$PROJECT_ROOT/.claude/workspace-coordination.yml"
HANDOFFS_DIR="$PROJECT_ROOT/.claude/handoffs"

# Usage
usage() {
    echo "Usage: $0 --artifact PATH --type TYPE [--agent AGENT_ID]"
    echo ""
    echo "Initializes work on an artifact and updates agent registry."
    echo ""
    echo "Options:"
    echo "  --artifact PATH    Path to artifact (required)"
    echo "  --type TYPE        Artifact type: specification, plan, tasks, implementation"
    echo "  --agent AGENT_ID   Agent ID (auto-detected if not provided)"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --artifact specs/001-feature/spec.md --type specification"
    echo "  $0 --artifact specs/001-feature/plan.md --type plan"
    exit 1
}

# Parse arguments
ARTIFACT_PATH=""
ARTIFACT_TYPE=""
AGENT_ID=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --artifact)
            ARTIFACT_PATH="$2"
            shift 2
            ;;
        --type)
            ARTIFACT_TYPE="$2"
            shift 2
            ;;
        --agent)
            AGENT_ID="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [ -z "$ARTIFACT_PATH" ] || [ -z "$ARTIFACT_TYPE" ]; then
    echo "Error: --artifact and --type are required"
    usage
fi

# Detect agent if not provided
if [ -z "$AGENT_ID" ]; then
    if [ -f "$PROJECT_ROOT/.claude/identity-web.json" ]; then
        AGENT_ID="web-claude-designer-001"
    elif [ -f "$PROJECT_ROOT/.claude/identity-cli.json" ]; then
        AGENT_ID="cli-claude-executor-001"
    else
        echo "Error: Cannot detect agent. No identity files found."
        exit 1
    fi
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Starting Work on Artifact"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Identify agent
AGENT_NAME=""
AGENT_ROLE=""
if [ "$AGENT_ID" = "web-claude-designer-001" ]; then
    AGENT_NAME="Claude Code Web"
    AGENT_ROLE="designer-researcher"
elif [ "$AGENT_ID" = "cli-claude-executor-001" ]; then
    AGENT_NAME="Claude Code CLI"
    AGENT_ROLE="executor-validator"
fi

echo -e "${GREEN}✅ Agent identified:${NC} $AGENT_NAME ($AGENT_ID)"
echo ""

# Validate artifact type matches agent role
VALID_TYPE=false
case "$ARTIFACT_TYPE" in
    specification)
        if [ "$AGENT_ID" = "web-claude-designer-001" ]; then
            VALID_TYPE=true
        fi
        ;;
    plan|tasks|implementation)
        if [ "$AGENT_ID" = "cli-claude-executor-001" ]; then
            VALID_TYPE=true
        fi
        ;;
esac

if [ "$VALID_TYPE" = false ]; then
    echo -e "${RED}❌ Invalid artifact type for agent${NC}"
    echo ""
    echo "Agent: $AGENT_NAME ($AGENT_ROLE)"
    echo "Artifact type: $ARTIFACT_TYPE"
    echo ""
    if [ "$AGENT_ID" = "web-claude-designer-001" ]; then
        echo "Web can work on:"
        echo "  - specification (specs/*/spec.md)"
    else
        echo "CLI can work on:"
        echo "  - plan (specs/*/plan.md)"
        echo "  - tasks (specs/*/tasks.md)"
        echo "  - implementation (src/)"
    fi
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Artifact type valid:${NC} $ARTIFACT_TYPE ($AGENT_ROLE responsibility)"
echo ""

# Check for pending handoffs
if [ -d "$HANDOFFS_DIR" ]; then
    PENDING_HANDOFFS=$(find "$HANDOFFS_DIR" -name "*.json" -type f 2>/dev/null || true)
    if [ -n "$PENDING_HANDOFFS" ]; then
        echo -e "${YELLOW}📬 Pending handoffs found:${NC}"
        echo "$PENDING_HANDOFFS" | while read -r handoff; do
            echo "  - $(basename "$handoff")"
        done
        echo ""
        echo "💡 Starting work will acknowledge these handoffs"
        echo ""
    fi
fi

# Suggest branch name if not on correct pattern
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
SUGGESTED_BRANCH=""

if [ "$AGENT_ID" = "web-claude-designer-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/ ]]; then
        SUGGESTED_BRANCH="claude/$(basename "$(dirname "$ARTIFACT_PATH")")-$(date +%s)"
        echo -e "${YELLOW}⚠️  Not on claude/* branch${NC}"
        echo "Current branch: $CURRENT_BRANCH"
        echo "Suggested: $SUGGESTED_BRANCH"
        echo ""
        echo "Create branch:"
        echo "  git checkout -b $SUGGESTED_BRANCH"
        echo ""
    fi
elif [ "$AGENT_ID" = "cli-claude-executor-001" ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^claude/cli- ]]; then
        SUGGESTED_BRANCH="claude/cli-$(basename "$(dirname "$ARTIFACT_PATH")")-$(date +%s)"
        echo -e "${YELLOW}⚠️  Not on claude/cli-* branch${NC}"
        echo "Current branch: $CURRENT_BRANCH"
        echo "Suggested: $SUGGESTED_BRANCH"
        echo ""
        echo "Create branch:"
        echo "  git checkout -b $SUGGESTED_BRANCH"
        echo ""
    fi
fi

# Determine workspace state
WORKSPACE_STATE=""
case "$ARTIFACT_TYPE" in
    specification)
        WORKSPACE_STATE="designing"
        ;;
    plan)
        WORKSPACE_STATE="planning"
        ;;
    tasks)
        WORKSPACE_STATE="planning"
        ;;
    implementation)
        WORKSPACE_STATE="implementing"
        ;;
esac

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Work Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Agent: $AGENT_NAME"
echo "Artifact: $ARTIFACT_PATH"
echo "Type: $ARTIFACT_TYPE"
echo "Branch: $CURRENT_BRANCH"
if [ -n "$SUGGESTED_BRANCH" ]; then
    echo "Suggested branch: $SUGGESTED_BRANCH"
fi
echo "Workspace state: $WORKSPACE_STATE"
echo ""

# Note: Actual registry update would happen here
# For now, just display what would be updated
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Registry Update (Manual)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "The following would be updated in .claude/agent-registry.json:"
echo ""
echo "  agent_id: $AGENT_ID"
echo "  status: active"
echo "  current_work_branch: $CURRENT_BRANCH"
echo "  workspace_state: $WORKSPACE_STATE"
echo "  current_work: $ARTIFACT_PATH"
echo "  active_specifications: [\"$ARTIFACT_PATH\"]"
echo ""
echo "⚠️  Note: Auto-update not yet implemented"
echo "   Manually update .claude/agent-registry.json for now"
echo ""

# Provide next steps
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$ARTIFACT_TYPE" = "specification" ]; then
    echo "1. Create specification using:"
    echo "   /speckit.specify \"feature-name\""
    echo ""
    echo "2. Optional clarification:"
    echo "   /speckit.clarify"
    echo ""
    echo "3. When complete, handoff to CLI:"
    echo "   tools/agent-handoff.sh --to cli --artifact $ARTIFACT_PATH"
elif [ "$ARTIFACT_TYPE" = "plan" ]; then
    echo "1. Read specification first:"
    echo "   cat $(dirname "$ARTIFACT_PATH")/spec.md"
    echo ""
    echo "2. Create technical plan using:"
    echo "   /speckit.plan"
    echo ""
    echo "3. When complete, handoff to Web for validation:"
    echo "   tools/agent-handoff.sh --to web --artifact $ARTIFACT_PATH"
elif [ "$ARTIFACT_TYPE" = "tasks" ]; then
    echo "1. Create atomic tasks using:"
    echo "   /speckit.tasks"
    echo ""
    echo "2. Proceed directly to implementation"
elif [ "$ARTIFACT_TYPE" = "implementation" ]; then
    echo "1. Execute implementation using:"
    echo "   /speckit.implement"
    echo ""
    echo "2. When complete, handoff to Web for validation:"
    echo "   tools/agent-handoff.sh --to web --artifact src/"
fi

echo ""
echo "✅ Ready to begin work"
echo ""

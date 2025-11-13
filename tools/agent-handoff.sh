#!/bin/bash
# Agent Handoff Script
# Completes work phase, creates handoff marker, triggers next agent

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
AGENT_REGISTRY="$PROJECT_ROOT/.claude/agent-registry.json"
HANDOFFS_DIR="$PROJECT_ROOT/.claude/handoffs"
WORKSPACE_MANIFEST="$PROJECT_ROOT/.claude/workspace-coordination.yml"

# Usage
usage() {
    echo "Usage: $0 --to AGENT --artifact PATH [--validated] [--agent FROM_AGENT]"
    echo ""
    echo "Creates handoff from current agent to target agent."
    echo ""
    echo "Options:"
    echo "  --to AGENT         Target agent: web | cli"
    echo "  --artifact PATH    Path to completed artifact"
    echo "  --validated        Mark as validated (for Web → CLI plan validation)"
    echo "  --agent FROM       Source agent ID (auto-detected if not provided)"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --to cli --artifact specs/001-feature/spec.md"
    echo "  $0 --to web --artifact specs/001-feature/plan.md"
    echo "  $0 --to cli --artifact specs/001-feature/plan.md --validated"
    exit 1
}

# Parse arguments
TO_AGENT=""
ARTIFACT_PATH=""
VALIDATED=false
FROM_AGENT_ID=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --to)
            TO_AGENT="$2"
            shift 2
            ;;
        --artifact)
            ARTIFACT_PATH="$2"
            shift 2
            ;;
        --validated)
            VALIDATED=true
            shift
            ;;
        --agent)
            FROM_AGENT_ID="$2"
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
if [ -z "$TO_AGENT" ] || [ -z "$ARTIFACT_PATH" ]; then
    echo "Error: --to and --artifact are required"
    usage
fi

# Normalize to_agent (three-agent architecture)
case "$TO_AGENT" in
    cdir|CDIR|Cdir)
        TO_AGENT_ID="cli-claude-director-001"
        TO_AGENT_NAME="CDIR"
        ;;
    cexe|CEXE|Cexe)
        TO_AGENT_ID="cli-claude-executor-001"
        TO_AGENT_NAME="CEXE"
        ;;
    web|Web|WEB)
        TO_AGENT_ID="web-claude-designer-001"
        TO_AGENT_NAME="Web"
        ;;
    # Legacy support
    cli|CLI|Cli)
        TO_AGENT_ID="cli-claude-executor-001"
        TO_AGENT_NAME="CEXE"
        echo "⚠️  Note: 'cli' is now 'cexe' in three-agent architecture"
        ;;
    *)
        echo "Error: Invalid target agent. Use 'cdir', 'cexe', or 'web'"
        exit 1
        ;;
esac

# Detect source agent if not provided (three-agent architecture)
if [ -z "$FROM_AGENT_ID" ]; then
    if [ -f "$PROJECT_ROOT/.claude/identity-cli-director.json" ]; then
        FROM_AGENT_ID="cli-claude-director-001"
        FROM_AGENT_NAME="CDIR"
    elif [ -f "$PROJECT_ROOT/.claude/identity-cli-executor.json" ]; then
        FROM_AGENT_ID="cli-claude-executor-001"
        FROM_AGENT_NAME="CEXE"
    elif [ -f "$PROJECT_ROOT/.claude/identity-web.json" ]; then
        FROM_AGENT_ID="web-claude-designer-001"
        FROM_AGENT_NAME="Web"
    else
        echo "Error: Cannot detect source agent"
        exit 1
    fi
else
    if [ "$FROM_AGENT_ID" = "cli-claude-director-001" ]; then
        FROM_AGENT_NAME="CDIR"
    elif [ "$FROM_AGENT_ID" = "cli-claude-executor-001" ]; then
        FROM_AGENT_NAME="CEXE"
    else
        FROM_AGENT_NAME="Web"
    fi
fi

# Valid handoff patterns for three-agent architecture:
# CDIR → CEXE (specification complete, ready for planning)
# CEXE → CDIR (plan complete, needs validation)
# CDIR → CEXE (plan validated, ready for implementation)
# CEXE → CDIR (implementation complete, needs validation)
# CDIR → CDIR (specification refinement)
# CEXE → CEXE (continued implementation)

VALID_HANDOFFS="CDIR->CEXE CEXE->CDIR CDIR->CDIR CEXE->CEXE"

HANDOFF_TYPE="$FROM_AGENT_NAME->$TO_AGENT_NAME"

if [[ ! " $VALID_HANDOFFS " =~ " $HANDOFF_TYPE " ]]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ Invalid Handoff"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "ERROR: Invalid handoff: $HANDOFF_TYPE"
    echo ""
    echo "Valid handoff patterns:"
    echo "  - CDIR → CEXE (specification to planning/implementation)"
    echo "  - CEXE → CDIR (plan/implementation to validation)"
    echo "  - CDIR → CDIR (specification refinement)"
    echo "  - CEXE → CEXE (continued implementation)"
    echo ""
    echo "Note: Web only participates in emergency scenarios"
    echo ""
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤝 Creating Agent Handoff"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${GREEN}Valid handoff:${NC} $HANDOFF_TYPE"
echo ""
echo -e "${BLUE}From:${NC} $FROM_AGENT_NAME ($FROM_AGENT_ID)"
echo -e "${MAGENTA}To:${NC} $TO_AGENT_NAME ($TO_AGENT_ID)"
echo -e "${GREEN}Artifact:${NC} $ARTIFACT_PATH"
if [ "$VALIDATED" = true ]; then
    echo -e "${GREEN}Status:${NC} Validated"
fi
echo ""

# Determine handoff trigger and validation criteria
TRIGGER=""
VALIDATION_CRITERIA=()
NEXT_ACTION=""

# Detect handoff type from artifact path
if [[ "$ARTIFACT_PATH" =~ spec\.md$ ]]; then
    TRIGGER="spec_complete"
    VALIDATION_CRITERIA=("spec.md exists and is complete" "Success criteria defined")
    NEXT_ACTION="CLI creates plan.md (technical implementation approach)"
elif [[ "$ARTIFACT_PATH" =~ plan\.md$ ]]; then
    if [ "$VALIDATED" = true ]; then
        TRIGGER="plan_validated"
        VALIDATION_CRITERIA=("Web reviewed plan.md" "Alignment confirmed")
        NEXT_ACTION="CLI creates tasks.md (atomic task decomposition)"
    else
        TRIGGER="plan_complete"
        VALIDATION_CRITERIA=("plan.md exists and is complete" "Architecture decisions documented")
        NEXT_ACTION="Web validates plan.md aligns with spec.md"
    fi
elif [[ "$ARTIFACT_PATH" =~ tasks\.md$ ]]; then
    TRIGGER="tasks_complete"
    VALIDATION_CRITERIA=("tasks.md exists with atomic tasks" "Dependencies mapped")
    NEXT_ACTION="CLI begins implementation"
elif [[ "$ARTIFACT_PATH" =~ ^src/ ]] || [ "$ARTIFACT_PATH" = "src/" ]; then
    TRIGGER="implementation_complete"
    VALIDATION_CRITERIA=("All tasks completed" "Tests passing")
    NEXT_ACTION="Web validates against spec.md success criteria"
else
    echo -e "${YELLOW}⚠️  Unknown artifact type, using generic handoff${NC}"
    TRIGGER="work_complete"
    VALIDATION_CRITERIA=("Artifact complete")
    NEXT_ACTION="Next agent continues workflow"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Handoff Validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Trigger: $TRIGGER"
echo ""
echo "Validation criteria:"
for criterion in "${VALIDATION_CRITERIA[@]}"; do
    echo "  ✓ $criterion"
done
echo ""
echo "Next action: $NEXT_ACTION"
echo ""

# Create handoff marker
TIMESTAMP=$(date +%Y%m%d%H%M%S)
MARKER_FILE="$HANDOFFS_DIR/${TIMESTAMP}-${TRIGGER}.json"

mkdir -p "$HANDOFFS_DIR"

cat > "$MARKER_FILE" <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "from_agent": "$FROM_AGENT_ID",
  "to_agent": "$TO_AGENT_ID",
  "artifact": "$ARTIFACT_PATH",
  "trigger": "$TRIGGER",
  "handoff_type": "$HANDOFF_TYPE",
  "validation_criteria": [
$(printf '    "%s"' "${VALIDATION_CRITERIA[0]}")
$(for criterion in "${VALIDATION_CRITERIA[@]:1}"; do printf ',\n    "%s"' "$criterion"; done)
  ],
  "next_action": "$NEXT_ACTION",
  "status": "pending",
  "acknowledged_at": null,
  "completed_at": null
}
EOF

echo -e "${GREEN}✅ Handoff marker created:${NC}"
echo "   File: $(basename "$MARKER_FILE")"
echo ""

# Suggest commit message
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 Suggested Commit Message"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Determine subject based on artifact
if [[ "$ARTIFACT_PATH" =~ spec\.md$ ]]; then
    FEATURE_NAME=$(basename "$(dirname "$ARTIFACT_PATH")" | sed 's/^[0-9]*-//')
    echo "[$FROM_AGENT_NAME] [HANDOFF] Complete $FEATURE_NAME specification → $TO_AGENT_NAME for planning"
    echo ""
    echo "Specification complete with success criteria:"
    echo "- What: [Brief description]"
    echo "- Why: [Purpose/motivation]"
    echo "- Success: [Success criteria]"
    echo ""
    echo "Next: $NEXT_ACTION"
elif [[ "$ARTIFACT_PATH" =~ plan\.md$ ]]; then
    FEATURE_NAME=$(basename "$(dirname "$ARTIFACT_PATH")" | sed 's/^[0-9]*-//')
    if [ "$VALIDATED" = true ]; then
        echo "[$FROM_AGENT_NAME] [HANDOFF] Validate $FEATURE_NAME plan → $TO_AGENT_NAME for implementation"
        echo ""
        echo "Plan reviewed and validated:"
        echo "- Architecture aligns with specification"
        echo "- Technical approach sound"
        echo "- Ready for task decomposition"
        echo ""
        echo "Next: $NEXT_ACTION"
    else
        echo "[$FROM_AGENT_NAME] [HANDOFF] Complete $FEATURE_NAME technical plan → $TO_AGENT_NAME for validation"
        echo ""
        echo "Technical plan complete:"
        echo "- Architecture: [Brief description]"
        echo "- Dependencies: [Key dependencies]"
        echo "- Approach: [Technical approach]"
        echo ""
        echo "Next: $NEXT_ACTION"
    fi
else
    echo "[$FROM_AGENT_NAME] [HANDOFF] Complete $ARTIFACT_PATH → $TO_AGENT_NAME"
    echo ""
    echo "Work complete:"
    echo "- [Summary of what was done]"
    echo ""
    echo "Next: $NEXT_ACTION"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Note about registry update
echo "⚠️  Manual Registry Update Required"
echo ""
echo "Update .claude/agent-registry.json:"
echo "  - Mark $FROM_AGENT_ID work as complete"
echo "  - Add pending_handoff for $TO_AGENT_ID"
echo ""

echo "✅ Handoff complete"
echo ""
echo "Next steps:"
echo "  1. Stage handoff marker: git add $MARKER_FILE"
echo "  2. Commit with suggested message above"
echo "  3. Push to your branch"
echo "  4. $TO_AGENT_NAME will see handoff on next session"
echo ""

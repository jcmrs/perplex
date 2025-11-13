#!/bin/bash
# Workspace Boundary Validation Script
# Validates if an agent can modify a given file based on workspace manifest

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
WORKSPACE_MANIFEST="$PROJECT_ROOT/.claude/workspace-coordination.yml"
WEB_IDENTITY="$PROJECT_ROOT/.claude/identity-web.json"
CLI_IDENTITY="$PROJECT_ROOT/.claude/identity-cli.json"

# Usage
usage() {
    echo "Usage: $0 --file PATH [--agent AGENT_ID] [--quiet]"
    echo ""
    echo "Validates if an agent can modify a file based on workspace boundaries."
    echo ""
    echo "Options:"
    echo "  --file PATH        File path to validate (required)"
    echo "  --agent AGENT_ID   Agent ID (auto-detected if not provided)"
    echo "  --quiet            Only output result, no explanation"
    echo "  --help             Show this help message"
    echo ""
    echo "Exit codes:"
    echo "  0 - Agent can modify file (primary or shared ownership)"
    echo "  1 - Agent cannot modify file (read-only or not owned)"
    echo "  2 - Emergency override detected"
    echo "  3 - Error (missing file, invalid agent, etc.)"
    exit 1
}

# Parse arguments
FILE_PATH=""
AGENT_ID=""
QUIET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            FILE_PATH="$2"
            shift 2
            ;;
        --agent)
            AGENT_ID="$2"
            shift 2
            ;;
        --quiet)
            QUIET=true
            shift
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
if [ -z "$FILE_PATH" ]; then
    echo "Error: --file is required"
    usage
fi

# Detect agent if not provided
if [ -z "$AGENT_ID" ]; then
    # Try to detect from environment or identity files
    if [ -f "$WEB_IDENTITY" ] && [ -f "$CLI_IDENTITY" ]; then
        # In web environment, check for typical web indicators
        if [ -n "$BROWSER" ] || [ "$TERM_PROGRAM" = "vscode" ]; then
            AGENT_ID="web-claude-designer-001"
        else
            # Assume CLI if not web
            AGENT_ID="cli-claude-executor-001"
        fi
    elif [ -f "$WEB_IDENTITY" ]; then
        AGENT_ID="web-claude-designer-001"
    elif [ -f "$CLI_IDENTITY" ]; then
        AGENT_ID="cli-claude-executor-001"
    else
        echo "Error: Cannot detect agent. No identity files found."
        exit 3
    fi
fi

# Normalize file path (remove leading ./)
FILE_PATH="${FILE_PATH#./}"

# Check for emergency override in git commit message (if called during pre-commit)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Check if there's a commit message being prepared
    GIT_DIR=$(git rev-parse --git-dir)
    COMMIT_MSG_FILE="$GIT_DIR/COMMIT_EDITMSG"
    if [ -f "$COMMIT_MSG_FILE" ]; then
        if grep -qE '^\[EMERGENCY\]|^\[OVERRIDE\]' "$COMMIT_MSG_FILE"; then
            if [ "$QUIET" = false ]; then
                echo -e "${YELLOW}⚠️  Emergency override detected in commit message${NC}"
                echo -e "${YELLOW}Override allows boundary violation but must be documented${NC}"
            fi
            exit 2
        fi
    fi
fi

# Simple YAML parser for our specific manifest structure
# This is not a full YAML parser, but handles our specific format
check_ownership() {
    local agent="$1"
    local file="$2"
    local manifest="$3"

    # Extract agent short name
    local agent_short=""
    if [ "$agent" = "web-claude-designer-001" ]; then
        agent_short="web-claude-designer-001"
    elif [ "$agent" = "cli-claude-executor-001" ]; then
        agent_short="cli-claude-executor-001"
    fi

    # Check primary ownership patterns
    # Web primary ownership
    if [ "$agent" = "web-claude-designer-001" ]; then
        # Primary directories
        if [[ "$file" =~ ^decisions/ ]] || \
           [[ "$file" =~ ^requirements/ ]] || \
           [[ "$file" =~ ^docs/ ]] || \
           [[ "$file" =~ ^ideas/ ]] || \
           [[ "$file" =~ ^specs/[^/]+/spec\.md$ ]] || \
           [[ "$file" == "FOUNDATION.md" ]] || \
           [[ "$file" == "README.md" ]] || \
           [[ "$file" == "CONTRIBUTING.md" ]] || \
           [[ "$file" == "docs/PRODUCT_VISION.md" ]] || \
           [[ "$file" == "requirements/TRACEABILITY.md" ]]; then
            echo "primary"
            return 0
        fi
    fi

    # CLI primary ownership
    if [ "$agent" = "cli-claude-executor-001" ]; then
        # Primary directories
        if [[ "$file" =~ ^src/ ]] || \
           [[ "$file" =~ ^tests/ ]] || \
           [[ "$file" =~ ^specs/[^/]+/plan\.md$ ]] || \
           [[ "$file" =~ ^specs/[^/]+/tasks\.md$ ]] || \
           [[ "$file" =~ ^specs/[^/]+/implementation/ ]] || \
           [[ "$file" =~ ^tools/.*\.sh$ ]] || \
           [[ "$file" == ".claude/mcp-config.json" ]] || \
           [[ "$file" == ".claude/session-state.json" ]]; then
            echo "primary"
            return 0
        fi
    fi

    # Shared ownership (both agents can modify)
    if [[ "$file" =~ ^sessions/ ]] || \
       [[ "$file" =~ ^checkpoints/ ]] || \
       [[ "$file" =~ ^backlog/ ]] || \
       [[ "$file" =~ ^\.claude/ ]] || \
       [[ "$file" == "sessions/CURRENT_STATUS.md" ]] || \
       [[ "$file" == ".claude/agent-registry.json" ]] || \
       [[ "$file" == ".claude/workspace-coordination.yml" ]]; then
        echo "shared"
        return 0
    fi

    # If not primary or shared, it's read-only
    echo "read-only"
    return 0
}

# Check ownership
OWNERSHIP=$(check_ownership "$AGENT_ID" "$FILE_PATH" "$WORKSPACE_MANIFEST")

# Determine result
if [ "$OWNERSHIP" = "primary" ] || [ "$OWNERSHIP" = "shared" ]; then
    # Agent can modify
    if [ "$QUIET" = false ]; then
        echo -e "${GREEN}✅ Agent can modify file${NC}"
        echo "Agent: $AGENT_ID"
        echo "File: $FILE_PATH"
        echo "Ownership: $OWNERSHIP"
    fi
    exit 0
elif [ "$OWNERSHIP" = "read-only" ]; then
    # Agent cannot modify
    if [ "$QUIET" = false ]; then
        echo -e "${RED}❌ Workspace boundary violation${NC}"
        echo ""
        echo "Agent: $AGENT_ID"
        echo "File: $FILE_PATH"
        echo "Status: Read-only (not owned by this agent)"
        echo ""

        # Provide guidance
        if [ "$AGENT_ID" = "web-claude-designer-001" ]; then
            echo "Web owns:"
            echo "  - decisions/ (ADRs)"
            echo "  - docs/ (documentation)"
            echo "  - specs/*/spec.md (specifications)"
            echo ""
            echo "CLI owns:"
            echo "  - src/ (implementation)"
            echo "  - tests/ (test code)"
            echo "  - specs/*/plan.md, specs/*/tasks.md"
        else
            echo "CLI owns:"
            echo "  - src/ (implementation)"
            echo "  - tests/ (test code)"
            echo "  - specs/*/plan.md, specs/*/tasks.md"
            echo ""
            echo "Web owns:"
            echo "  - decisions/ (ADRs)"
            echo "  - docs/ (documentation)"
            echo "  - specs/*/spec.md (specifications)"
        fi
        echo ""
        echo "Correct workflow:"
        echo "  1. Identify issue in file outside your ownership"
        echo "  2. Create backlog item or note in your owned files"
        echo "  3. Handoff to agent who owns that file"
        echo "  4. Wait for handoff back with updates"
        echo ""
        echo "Emergency override:"
        echo "  git commit -m \"[EMERGENCY] Reason for override\""
        echo ""
        echo "See: docs/AGENT_WORKSPACE_COORDINATION.md"
    fi
    exit 1
else
    # Unknown ownership
    if [ "$QUIET" = false ]; then
        echo -e "${YELLOW}⚠️  Unknown ownership status${NC}"
        echo "Agent: $AGENT_ID"
        echo "File: $FILE_PATH"
        echo "Status: $OWNERSHIP"
    fi
    exit 3
fi

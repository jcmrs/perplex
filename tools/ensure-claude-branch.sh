#!/bin/bash
# Ensure AI Agent is on Proper Claude Branch
# Prevents accidental work on main branch

set -e

CURRENT_BRANCH=$(git branch --show-current)

# Check if on main/master
if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
    echo ""
    echo "⚠️  WARNING: You are on $CURRENT_BRANCH branch!"
    echo ""
    echo "AI agents should work on claude/* branches."
    echo ""

    # Detect agent type from identity file (three-agent architecture)
    AGENT_ID="unknown"
    AGENT_NAME="Unknown"
    BRANCH_PREFIX="claude"

    if [ -f ".claude/identity-cli-director.json" ]; then
        AGENT_ID="cli-claude-director-001"
        AGENT_NAME="CDIR"
        BRANCH_PREFIX="claude/design"
        TIMESTAMP=$(date +%s)
        SUGGESTED_BRANCH="claude/design-work-$TIMESTAMP"

        echo "Agent: CLI-Director (CDIR)"
        echo "CDIR should use claude/design-* branches"
        echo ""
        echo "Suggested branch: $SUGGESTED_BRANCH"
        echo ""
        read -p "Create this branch? (y/n): " CREATE_BRANCH

        if [[ "$CREATE_BRANCH" == "y" || "$CREATE_BRANCH" == "Y" ]]; then
            git checkout -b "$SUGGESTED_BRANCH"
            echo "✅ Created and switched to: $SUGGESTED_BRANCH"
            exit 0
        else
            echo "Please create a claude/design-* branch manually"
            exit 1
        fi

    elif [ -f ".claude/identity-cli-executor.json" ]; then
        AGENT_ID="cli-claude-executor-001"
        AGENT_NAME="CEXE"
        BRANCH_PREFIX="claude/impl"
        TIMESTAMP=$(date +%s)
        SUGGESTED_BRANCH="claude/impl-work-$TIMESTAMP"

        echo "Agent: CLI-Executor (CEXE)"
        echo "CEXE should use claude/impl-* branches"
        echo ""
        echo "Suggested branch: $SUGGESTED_BRANCH"
        echo ""
        read -p "Create this branch? (y/n): " CREATE_BRANCH

        if [[ "$CREATE_BRANCH" == "y" || "$CREATE_BRANCH" == "Y" ]]; then
            git checkout -b "$SUGGESTED_BRANCH"
            echo "✅ Created and switched to: $SUGGESTED_BRANCH"
            exit 0
        else
            echo "Please create a claude/impl-* branch manually"
            exit 1
        fi

    elif [ -f ".claude/identity-web.json" ]; then
        AGENT_ID="web-claude-designer-001"
        AGENT_NAME="Web"
        BRANCH_PREFIX="claude/web-emergency"

        echo "Agent: Claude Code Web (standby)"
        echo "Web should use claude/web-emergency-* branches (emergency only)"
        echo ""
        echo "Example:"
        echo "  git checkout -b claude/web-emergency-reason-sessionid"

    else
        echo "Create a claude/* branch:"
        echo "  git checkout -b claude/description-$(date +%s)"
    fi

    echo ""
    exit 1
fi

# Check if on a claude/* branch
if [[ "$CURRENT_BRANCH" == claude/* ]]; then
    echo "✅ On proper claude branch: $CURRENT_BRANCH"
    exit 0
else
    # On some other feature branch - warn but allow
    echo "⚠️  On branch: $CURRENT_BRANCH (not a claude/* branch)"
    echo "This may bypass automation. Consider using claude/* branch convention."
    exit 0
fi

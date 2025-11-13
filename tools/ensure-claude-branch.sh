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

    # Detect agent type from identity file
    AGENT_TYPE="unknown"
    if [ -f ".claude/identity-web.json" ]; then
        AGENT_TYPE="web"
    elif [ -f ".claude/identity-cli.json" ]; then
        AGENT_TYPE="cli"
    fi

    # Suggest appropriate branch name
    if [ "$AGENT_TYPE" == "web" ]; then
        # Web uses session ID (from user context)
        echo "For Claude Code Web, create branch like:"
        echo "  git checkout -b claude/description-sessionid"
        echo ""
        echo "Example:"
        echo "  git checkout -b claude/spec-kit-integration-011CV35RoubgSRMHNVuYa7Si"
    elif [ "$AGENT_TYPE" == "cli" ]; then
        # CLI uses timestamp
        TIMESTAMP=$(date +%s)
        SUGGESTED_BRANCH="claude/cli-spec-kit-work-$TIMESTAMP"
        echo "For Claude Code CLI, I can create a branch for you:"
        echo ""
        echo "Suggested branch: $SUGGESTED_BRANCH"
        echo ""
        read -p "Create this branch? (y/n): " CREATE_BRANCH

        if [[ "$CREATE_BRANCH" == "y" || "$CREATE_BRANCH" == "Y" ]]; then
            git checkout -b "$SUGGESTED_BRANCH"
            echo "✅ Created and switched to: $SUGGESTED_BRANCH"
            echo ""
            echo "When ready to push:"
            echo "  git push -u origin $SUGGESTED_BRANCH"
            echo ""
            echo "GitHub automation will handle the rest (PR creation, validation, merge)."
            exit 0
        else
            echo ""
            echo "Please create a claude/* branch manually:"
            echo "  git checkout -b claude/cli-description-\$(date +%s)"
            exit 1
        fi
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

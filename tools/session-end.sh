#!/bin/bash
# Session End Script
# Finalizes session work and prepares for next session

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Project Perplex - Session End ==="
echo ""

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "⚠️  Uncommitted changes detected"
    echo ""
    echo "📝 Changed files:"
    git status --short
    echo ""
    read -p "Do you want to review the session checklist before committing? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "📋 Session End Checklist:"
        echo "  [ ] Session log finalized in /sessions/"
        echo "  [ ] CURRENT_STATUS.md updated"
        echo "  [ ] New ADRs created if needed"
        echo "  [ ] Documentation updated to match reality"
        echo "  [ ] Foundation alignment validated"
        echo ""
        read -p "Checklist complete? (y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ Session end cancelled. Complete checklist first."
            exit 1
        fi
    fi
else
    echo "✓ No uncommitted changes"
fi

echo ""
echo "🔍 Running validation..."
if [ -f "tools/validate-foundation.sh" ]; then
    bash tools/validate-foundation.sh
else
    echo "⚠️  Validation script not found (tools/validate-foundation.sh)"
fi

echo ""
read -p "🔍 Run completeness review? (Checks for forgotten items) (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    if [ -f "tools/review-completeness.sh" ]; then
        bash tools/review-completeness.sh
        COMPLETENESS_RESULT=$?
        echo ""
        if [ $COMPLETENESS_RESULT -ne 0 ]; then
            read -p "Completeness check found issues. Continue anyway? (y/n) " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "❌ Session end cancelled. Address completeness issues first."
                exit 1
            fi
        fi
    else
        echo "⚠️  Completeness review script not found (tools/review-completeness.sh)"
    fi
fi

echo ""
echo "📊 Session Summary:"
echo "─────────────────────────────────────────"

# Count files changed
if ! git diff --quiet || ! git diff --staged --quiet; then
    FILES_CHANGED=$(git status --short | wc -l)
    echo "  Files changed: $FILES_CHANGED"
fi

# Show recent commits in this session (last 5)
echo ""
echo "  Recent commits:"
git log --oneline -5 | sed 's/^/    /'

echo "─────────────────────────────────────────"
echo ""

echo "✅ Session end protocol complete"
echo ""
echo "Next steps:"
echo "  1. Commit any remaining changes"
echo "  2. Push to repository: git push -u origin $(git branch --show-current)"
echo "  3. Take a break! 🎉"

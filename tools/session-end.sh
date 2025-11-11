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
echo "🔍 Running completeness review (mandatory)..."
echo ""
if [ -f "tools/review-completeness.sh" ]; then
    bash tools/review-completeness.sh
    COMPLETENESS_RESULT=$?
    echo ""

    if [ $COMPLETENESS_RESULT -ne 0 ]; then
        echo "❌ Completeness check found issues"
        echo ""
        read -p "Address issues before continuing? (y=fix now, n=skip and continue) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Please address completeness issues, then run this script again."
            exit 1
        else
            echo "⚠️  Continuing with completeness issues (not recommended)"
            echo ""
        fi
    else
        echo "✅ Completeness check passed"
    fi
else
    echo "⚠️  Completeness review script not found (tools/review-completeness.sh)"
    echo "   Session will continue, but completeness checking is recommended"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checkpoint Creation (Optional)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Checkpoints preserve project state for session continuity."
echo "Create checkpoint if this is a milestone (phase transition, major feature, etc.)"
echo ""
read -p "Create checkpoint for this session? (y/n): " CREATE_CHECKPOINT
echo ""

if [[ $CREATE_CHECKPOINT =~ ^[Yy]$ ]]; then
    CHECKPOINT_DESC="session-end-$(date +%Y%m%d)"
    echo "Creating checkpoint: $CHECKPOINT_DESC"
    echo ""

    if [ -f "tools/create-checkpoint.sh" ]; then
        # Run create-checkpoint.sh with session-end specific values
        CHECKPOINT_SUMMARY="Session ended on $(date +%Y-%m-%d). See session log for details."

        export CHECKPOINT_NON_INTERACTIVE=true
        export CHECKPOINT_DESCRIPTION="$CHECKPOINT_DESC"
        export CHECKPOINT_SUMMARY
        export CHECKPOINT_FOCUS="Review session log and continue work"

        bash tools/create-checkpoint.sh
        CHECKPOINT_RESULT=$?

        if [ $CHECKPOINT_RESULT -eq 0 ]; then
            echo ""
            echo "✅ Checkpoint created successfully"
            echo ""
            echo "📝 Don't forget to commit the checkpoint files:"
            echo "   git add checkpoints/"
            echo "   git commit -m \"Add checkpoint: $CHECKPOINT_DESC\""
        else
            echo ""
            echo "⚠️  Checkpoint creation skipped or failed"
        fi
    else
        echo "❌ Checkpoint script not found (tools/create-checkpoint.sh)"
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

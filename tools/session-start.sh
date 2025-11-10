#!/bin/bash
# Session Start Script
# Prepares AI agent for new session with full context

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Project Perplex - Session Start ==="
echo ""

# Check we're in correct directory
if [ ! -f "FOUNDATION.md" ]; then
    echo "❌ Error: Not in project root (FOUNDATION.md not found)"
    exit 1
fi

echo "📍 Project Root: $PROJECT_ROOT"
echo ""

# Display current branch
echo "🔀 Git Branch:"
git branch --show-current
echo ""

# Display current status
if [ -f "sessions/CURRENT_STATUS.md" ]; then
    echo "📊 Current Status:"
    echo "─────────────────────────────────────────"
    head -n 20 sessions/CURRENT_STATUS.md
    echo "─────────────────────────────────────────"
    echo "(See sessions/CURRENT_STATUS.md for full status)"
else
    echo "⚠️  No CURRENT_STATUS.md found"
fi
echo ""

# Show recent decisions
echo "📋 Recent Decisions:"
if [ -d "decisions" ] && [ "$(ls -A decisions/*.md 2>/dev/null)" ]; then
    ls -t decisions/*.md | head -3 | while read decision; do
        echo "  - $(basename "$decision")"
    done
else
    echo "  (No decisions logged yet)"
fi
echo ""

# Show active TODOs if we have them tracked in sessions
if [ -f "sessions/ACTIVE_TODOS.md" ]; then
    echo "✅ Active TODOs:"
    cat sessions/ACTIVE_TODOS.md
    echo ""
fi

# Quick validation
echo "🔍 Quick Validation:"
if [ -f "FOUNDATION.md" ]; then echo "  ✓ Foundation document exists"; fi
if [ -f "docs/PRODUCT_VISION.md" ]; then echo "  ✓ Product vision exists"; fi
if [ -f "config/project.yml" ]; then echo "  ✓ Project config exists"; fi
if [ -d ".git" ]; then echo "  ✓ Git repository initialized"; fi
echo ""

echo "🎯 Session Checklist:"
echo "  1. [ ] Reviewed FOUNDATION.md"
echo "  2. [ ] Reviewed CURRENT_STATUS.md"
echo "  3. [ ] Reviewed recent decisions"
echo "  4. [ ] Reviewed PRODUCT_VISION.md"
echo "  5. [ ] Ready to work"
echo ""

echo "✨ Session initialized. Ready to work!"
echo ""
echo "💡 Remember: Read /FOUNDATION.md, /config/project.yml, and /sessions/CURRENT_STATUS.md"
echo "   for full context before starting work."

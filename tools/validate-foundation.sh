#!/bin/bash
# Foundation Validation Script
# Checks alignment with foundation imperatives

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Foundation Validation ==="
echo ""

ERRORS=0
WARNINGS=0

# Core documents check
echo "📄 Core Documents:"
if [ -f "FOUNDATION.md" ]; then
    echo "  ✓ FOUNDATION.md exists"
else
    echo "  ✗ FOUNDATION.md missing"
    ((ERRORS++))
fi

if [ -f "docs/PRODUCT_VISION.md" ]; then
    echo "  ✓ PRODUCT_VISION.md exists"
else
    echo "  ✗ PRODUCT_VISION.md missing"
    ((ERRORS++))
fi

if [ -f "sessions/CURRENT_STATUS.md" ]; then
    echo "  ✓ CURRENT_STATUS.md exists"
else
    echo "  ⚠ CURRENT_STATUS.md missing"
    ((WARNINGS++))
fi

# Directory structure check
echo ""
echo "📁 Directory Structure:"
REQUIRED_DIRS=("config" "decisions" "docs" "knowledge" "sessions" "src" "tools" "examples")
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✓ /$dir exists"
    else
        echo "  ✗ /$dir missing"
        ((ERRORS++))
    fi
done

# Configuration check
echo ""
echo "⚙️  Configuration:"
if [ -f "config/project.yml" ]; then
    echo "  ✓ project.yml exists"
else
    echo "  ✗ project.yml missing"
    ((ERRORS++))
fi

if [ -f "config/ai-agent.yml" ]; then
    echo "  ✓ ai-agent.yml exists"
else
    echo "  ✗ ai-agent.yml missing"
    ((ERRORS++))
fi

# Git check
echo ""
echo "🔀 Git Repository:"
if [ -d ".git" ]; then
    echo "  ✓ Git repository initialized"

    CURRENT_BRANCH=$(git branch --show-current)
    echo "  ✓ Current branch: $CURRENT_BRANCH"

    if git diff --quiet && git diff --staged --quiet; then
        echo "  ✓ Working directory clean"
    else
        echo "  ⚠ Uncommitted changes present"
        ((WARNINGS++))
    fi
else
    echo "  ✗ Not a git repository"
    ((ERRORS++))
fi

# Foundation imperatives check
echo ""
echo "🎯 Foundation Imperatives Enforcement:"
echo "  (Manual review required - see FOUNDATION.md)"
echo "  [ ] Holistic System Thinking applied"
echo "  [ ] AI-First principle followed"
echo "  [ ] Configurability maintained"
echo "  [ ] Modularity preserved"
echo "  [ ] Extensibility considered"
echo "  [ ] Integration points defined"
echo "  [ ] Automation implemented"

# Summary
echo ""
echo "─────────────────────────────────────────"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ Validation passed with no issues"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Validation passed with $WARNINGS warning(s)"
    exit 0
else
    echo "❌ Validation failed with $ERRORS error(s) and $WARNINGS warning(s)"
    exit 1
fi

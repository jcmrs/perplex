#!/bin/bash
# Local Environment Setup Script
# Configures local development environment for Project Perplex

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=========================================="
echo "Project Perplex - Local Setup"
echo "=========================================="
echo ""

# Check we're in the right directory
if [ ! -f "FOUNDATION.md" ]; then
    echo "❌ Error: Not in project root (FOUNDATION.md not found)"
    echo "   Please run this script from the project root directory"
    exit 1
fi

echo "📍 Project root: $PROJECT_ROOT"
echo ""

# Configure git hooks
echo "🔧 Configuring Git Hooks..."
if git config core.hooksPath .githooks; then
    echo "   ✓ Git hooks path set to .githooks/"
else
    echo "   ❌ Failed to configure git hooks"
    exit 1
fi

# Make hooks executable
echo ""
echo "🔧 Making hooks executable..."
chmod +x .githooks/* 2>/dev/null || true
echo "   ✓ Hooks are executable"

# Make tools executable
echo ""
echo "🔧 Making tools executable..."
chmod +x tools/*.sh 2>/dev/null || true
echo "   ✓ Tools are executable"

# Validate setup
echo ""
echo "✅ Running validation..."
if [ -f "tools/validate-foundation.sh" ]; then
    bash tools/validate-foundation.sh
else
    echo "   ⚠️  Validation script not found"
fi

echo ""
echo "=========================================="
echo "✅ Local setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Read FOUNDATION.md for project principles"
echo "  2. Read docs/PRODUCT_VISION.md for project goals"
echo "  3. Check sessions/CURRENT_STATUS.md for current state"
echo "  4. Review config/ai-agent.yml for AI agent settings"
echo ""
echo "For AI agents:"
echo "  - Run ./tools/session-start.sh when beginning work"
echo "  - Run ./tools/session-end.sh when finishing work"
echo ""
echo "Git hooks are now active:"
echo "  - Pre-commit: Foundation validation"
echo "  - Commit-msg: Message quality check"
echo ""
echo "Happy coding! 🚀"

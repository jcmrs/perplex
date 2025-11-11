#!/bin/bash
# Install Git Hooks
# Copies hooks from .githooks/ to .git/hooks/

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "Installing git hooks..."
echo ""

# Check if .githooks directory exists
if [ ! -d ".githooks" ]; then
    echo "❌ .githooks directory not found"
    exit 1
fi

# Copy hooks to .git/hooks
for hook in .githooks/*; do
    if [ -f "$hook" ]; then
        hook_name=$(basename "$hook")
        target=".git/hooks/$hook_name"

        cp "$hook" "$target"
        chmod +x "$target"

        echo "✅ Installed: $hook_name"
    fi
done

echo ""
echo "✅ Git hooks installed successfully"
echo ""
echo "Installed hooks:"
ls -1 .git/hooks/ | grep -v ".sample" || echo "  (none)"

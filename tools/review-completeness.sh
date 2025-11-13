#!/bin/bash
# Completeness Review Script
# Systematic check for gaps, missing artifacts, and incomplete work
# Inspired by Serena MCP Server's "did you forget anything" feature

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Detect non-interactive mode
NON_INTERACTIVE=${COMPLETENESS_NON_INTERACTIVE:-false}
if [ ! -t 0 ] || [ "$NON_INTERACTIVE" = "true" ]; then
    NON_INTERACTIVE=true
else
    NON_INTERACTIVE=false
fi

echo "=========================================="
echo "Completeness Review"
echo "=========================================="
echo ""
echo "Checking for gaps, missing artifacts, and incomplete work..."
echo ""

# Track issues found
ISSUES_FOUND=0
WARNINGS_FOUND=0

# Helper functions
issue() {
    echo "  ❌ $1"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
}

warning() {
    echo "  ⚠️  $1"
    WARNINGS_FOUND=$((WARNINGS_FOUND + 1))
}

ok() {
    echo "  ✅ $1"
}

info() {
    echo "  ℹ️  $1"
}

section() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ============================================
# 1. GIT STATE CHECKS
# ============================================
section "1. Git State"

# Check for uncommitted changes
set +e
git diff --quiet 2>/dev/null
UNSTAGED=$?
git diff --staged --quiet 2>/dev/null
STAGED=$?
set -e

if [ $UNSTAGED -eq 0 ] && [ $STAGED -eq 0 ]; then
    ok "Working directory clean (no uncommitted changes)"
else
    warning "Uncommitted changes present"
    info "Run 'git status' to review changes"
    info "Consider committing before ending session"
fi

# Check for untracked files
UNTRACKED_COUNT=$(git ls-files --others --exclude-standard | wc -l)
if [ "$UNTRACKED_COUNT" -eq 0 ]; then
    ok "No untracked files"
else
    warning "$UNTRACKED_COUNT untracked file(s) present"
    info "Run 'git status' to review untracked files"
    info "Add to .gitignore if intentional, or stage for commit"
fi

# Check if changes are pushed
CURRENT_BRANCH=$(git branch --show-current)
if git rev-parse "@{u}" >/dev/null 2>&1; then
    UNPUSHED=$(git log @{u}.. --oneline | wc -l)
    if [ "$UNPUSHED" -eq 0 ]; then
        ok "All commits pushed to remote"
    else
        warning "$UNPUSHED commit(s) not pushed to remote"
        info "Run 'git push' to sync with remote"
    fi
else
    info "Branch '$CURRENT_BRANCH' has no upstream (local only)"
fi

# ============================================
# 2. DOCUMENTATION & TRACEABILITY
# ============================================
section "2. Documentation & Traceability"

# Check session logs
LATEST_SESSION=$(ls -t sessions/session-*.md 2>/dev/null | head -1 || echo "")
if [ -n "$LATEST_SESSION" ]; then
    # Check if session was updated recently (within last hour)
    # Use portable file age check
    if [ -n "$(find "$LATEST_SESSION" -mmin -60 2>/dev/null)" ]; then
        ok "Session log updated recently"
    else
        warning "Session log might be outdated"
        info "Consider updating: $LATEST_SESSION"
    fi
else
    warning "No session logs found"
    info "Create session log to document work"
fi

# Check CURRENT_STATUS.md
if [ -f "sessions/CURRENT_STATUS.md" ]; then
    # Use portable file age check
    if [ -n "$(find sessions/CURRENT_STATUS.md -mmin -60 2>/dev/null)" ]; then
        ok "CURRENT_STATUS.md updated recently"
    else
        warning "CURRENT_STATUS.md might be outdated"
        info "Update sessions/CURRENT_STATUS.md to reflect current state"
    fi
else
    issue "CURRENT_STATUS.md missing"
fi

# Check for ADRs in recent commits
RECENT_COMMITS=$(git log --oneline -5 2>/dev/null || echo "")
if echo "$RECENT_COMMITS" | grep -qi "decision\|ADR"; then
    ok "Recent commits mention decisions/ADRs"
elif [ -n "$(git diff --name-only HEAD~5..HEAD 2>/dev/null | grep decisions/ || echo '')" ]; then
    ok "Decision files modified in recent commits"
else
    if [ "$NON_INTERACTIVE" = "false" ]; then
        echo ""
        read -p "  Were significant technical decisions made? (y/n): " DECISIONS_MADE
        if [ "$DECISIONS_MADE" = "y" ]; then
            warning "Significant decisions made but no ADR found"
            info "Create ADR: cp decisions/TEMPLATE.md decisions/YYYY-MM-DD-description.md"
        else
            ok "No significant decisions requiring ADR"
        fi
    else
        info "ADR check: verify if decisions need documentation"
    fi
fi

# ============================================
# 3. FOUNDATION ARTIFACTS
# ============================================
section "3. Foundation Artifacts"

# Check if ideas were logged
IDEAS_COUNT=$(find ideas -name "*.md" -type f 2>/dev/null | grep -v README | grep -v TEMPLATE | grep -v INDEX | wc -l || echo "0")
RECENT_IDEAS=$(git diff --name-only HEAD~5..HEAD 2>/dev/null | grep "ideas/" | grep -v README | grep -v TEMPLATE || echo "")

if [ -n "$RECENT_IDEAS" ]; then
    ok "Ideas logged recently"
elif [ "$NON_INTERACTIVE" = "false" ]; then
    echo ""
    read -p "  Did you encounter ideas for future exploration? (y/n): " IDEAS_ENCOUNTERED
    if [ "$IDEAS_ENCOUNTERED" = "y" ]; then
        warning "Ideas encountered but not logged"
        info "Log idea: cp ideas/TEMPLATE.md ideas/YYYY-MM-DD-description.md"
    else
        ok "No new ideas to log"
    fi
else
    info "Ideas: $IDEAS_COUNT total in repository"
fi

# Check if backlog was updated
RECENT_BACKLOG=$(git diff --name-only HEAD~5..HEAD 2>/dev/null | grep "backlog/" || echo "")
if [ -n "$RECENT_BACKLOG" ]; then
    ok "Backlog updated recently"
elif [ "$NON_INTERACTIVE" = "false" ]; then
    echo ""
    read -p "  Did you identify work for later (backlog items)? (y/n): " BACKLOG_ITEMS
    if [ "$BACKLOG_ITEMS" = "y" ]; then
        warning "Backlog items identified but not logged"
        info "Update backlog/BACKLOG.md or create item in backlog/items/"
    else
        ok "No backlog updates needed"
    fi
else
    info "Backlog check: verify if updates needed"
fi

# Check if checkpoint is needed
PHASE=$(grep "phase:" config/project.yml | awk '{print $2}' | tr -d '"' || echo "unknown")
LATEST_CHECKPOINT=$(ls -t checkpoints/checkpoint-*.md 2>/dev/null | head -1 || echo "")

if [ -n "$LATEST_CHECKPOINT" ]; then
    # Check checkpoint age (within last 2 hours)
    if [ -n "$(find "$LATEST_CHECKPOINT" -mmin -120 2>/dev/null)" ]; then
        ok "Checkpoint created recently"
    elif [ "$NON_INTERACTIVE" = "false" ]; then
        echo ""
        read -p "  Is this a phase transition or major milestone? (y/n): " MILESTONE
        if [ "$MILESTONE" = "y" ]; then
            warning "Milestone reached but no recent checkpoint"
            info "Create checkpoint: ./tools/create-checkpoint.sh"
        else
            ok "No checkpoint needed (incremental work)"
        fi
    else
        info "Checkpoint check: verify if new checkpoint needed"
    fi
else
    warning "No checkpoints found in repository"
    info "Consider creating initial checkpoint: ./tools/create-checkpoint.sh"
fi

# ============================================
# 4. QUALITY & VALIDATION
# ============================================
section "4. Quality & Validation"

# Run foundation validation
if [ -f "tools/validate-foundation.sh" ]; then
    set +e
    bash tools/validate-foundation.sh >/dev/null 2>&1
    VALIDATION_RESULT=$?
    set -e

    if [ $VALIDATION_RESULT -eq 0 ]; then
        ok "Foundation validation passing"
    else
        issue "Foundation validation failing"
        info "Run: ./tools/validate-foundation.sh"
    fi
else
    warning "Foundation validation script not found"
fi

# Check for breaking changes documentation
RECENT_COMMITS_TEXT=$(git log --oneline -10 2>/dev/null || echo "")
if echo "$RECENT_COMMITS_TEXT" | grep -qi "breaking"; then
    if [ "$NON_INTERACTIVE" = "false" ]; then
        echo ""
        read -p "  Are breaking changes documented with migration path? (y/n): " BREAKING_DOCS
        if [ "$BREAKING_DOCS" = "y" ]; then
            ok "Breaking changes documented"
        else
            warning "Breaking changes mentioned but documentation unclear"
            info "Document in PR template or commit message: what breaks, migration path, why necessary"
        fi
    else
        info "Breaking changes detected - verify documentation"
    fi
else
    ok "No breaking changes detected"
fi

# ============================================
# 5. SESSION COMPLETENESS
# ============================================
section "5. Session Completeness"

# Check for open questions
if [ "$NON_INTERACTIVE" = "false" ]; then
    echo ""
    read -p "  Are there unanswered questions or blockers? (y/n): " OPEN_QUESTIONS
    if [ "$OPEN_QUESTIONS" = "y" ]; then
        warning "Open questions or blockers present"
        info "Document in session log or backlog"
        info "Consider creating issue or backlog item"
    else
        ok "No open questions or blockers"
    fi
else
    info "Question/blocker check: verify all addressed"
fi

# Check for next actions
if [ "$NON_INTERACTIVE" = "false" ]; then
    echo ""
    read -p "  Are next actions clear for resuming work? (y/n): " NEXT_ACTIONS
    if [ "$NEXT_ACTIONS" = "y" ]; then
        ok "Next actions clear"
    else
        warning "Next actions unclear"
        info "Document next steps in session log or checkpoint"
        info "Update CURRENT_STATUS.md with what should happen next"
    fi
else
    info "Next actions check: verify clarity for next session"
fi

# Check for deferred todos
if [ "$NON_INTERACTIVE" = "false" ]; then
    echo ""
    read -p "  Are all todos completed or explicitly deferred? (y/n): " TODOS_COMPLETE
    if [ "$TODOS_COMPLETE" = "y" ]; then
        ok "All todos addressed"
    else
        warning "Incomplete todos present"
        info "Complete remaining todos or explicitly defer with reason"
        info "Document deferred todos in backlog"
    fi
else
    info "Todo check: verify all completed or deferred"
fi

# ============================================
# 6. MASTER DOCUMENT CURRENCY
# ============================================
section "6. Master Document Currency"

# Check README.md freshness
if [ -f "README.md" ]; then
    # Extract last updated date from README
    README_DATE=$(grep -E "^\*\*Last Updated:\*\*" README.md | sed 's/\*\*Last Updated:\*\* //' || echo "")

    if [ -n "$README_DATE" ]; then
        # Calculate age in days (cross-platform)
        if [ "$(uname)" = "Darwin" ]; then
            README_TIMESTAMP=$(date -j -f "%Y-%m-%d" "$README_DATE" +%s 2>/dev/null || echo "0")
        else
            README_TIMESTAMP=$(date -d "$README_DATE" +%s 2>/dev/null || echo "0")
        fi
        CURRENT_TIMESTAMP=$(date +%s)

        if [ "$README_TIMESTAMP" -gt 0 ]; then
            README_AGE_DAYS=$(( (CURRENT_TIMESTAMP - README_TIMESTAMP) / 86400 ))

            if [ "$README_AGE_DAYS" -gt 7 ]; then
                warning "README.md last updated $README_AGE_DAYS days ago"

                # Check if significant commits since last README update
                RECENT_COMMITS=$(git log --since="$README_DATE" --oneline 2>/dev/null | wc -l | tr -d ' ')
                if [ "$RECENT_COMMITS" -gt 5 ]; then
                    warning "$RECENT_COMMITS commits since README update - likely needs updating"
                    info "Consider updating: Project Status, Progress Metrics, Current Milestones"
                fi
            else
                ok "README.md updated recently ($README_AGE_DAYS days ago)"
            fi
        else
            warning "Could not parse README.md 'Last Updated' date"
            info "Ensure format is: **Last Updated:** YYYY-MM-DD"
        fi
    else
        warning "README.md missing 'Last Updated' date"
        info "Add at bottom: **Last Updated:** YYYY-MM-DD"
    fi
else
    issue "README.md not found!"
fi

# Function to check master document currency
check_master_doc() {
    local doc_path="$1"
    local doc_name="$2"

    if [ ! -f "$doc_path" ]; then
        return  # Skip if doesn't exist
    fi

    # Extract last updated date
    DOC_DATE=$(grep -E "^\*\*Last Updated:\*\*" "$doc_path" | sed 's/\*\*Last Updated:\*\* //' || echo "")

    if [ -z "$DOC_DATE" ]; then
        warning "$doc_name missing 'Last Updated' date"
        info "Add at bottom: **Last Updated:** YYYY-MM-DD"
        return
    fi

    # Calculate age in days
    if [ "$(uname)" = "Darwin" ]; then
        DOC_TIMESTAMP=$(date -j -f "%Y-%m-%d" "$DOC_DATE" +%s 2>/dev/null || echo "0")
    else
        DOC_TIMESTAMP=$(date -d "$DOC_DATE" +%s 2>/dev/null || echo "0")
    fi
    CURRENT_TIMESTAMP=$(date +%s)

    if [ "$DOC_TIMESTAMP" -eq 0 ]; then
        warning "Could not parse $doc_name 'Last Updated' date"
        return
    fi

    DOC_AGE_DAYS=$(( (CURRENT_TIMESTAMP - DOC_TIMESTAMP) / 86400 ))

    if [ "$DOC_AGE_DAYS" -gt 7 ]; then
        warning "$doc_name last updated $DOC_AGE_DAYS days ago"

        # Check commits since last update
        RECENT_COMMITS=$(git log --since="$DOC_DATE" --oneline 2>/dev/null | wc -l | tr -d ' ')
        if [ "$RECENT_COMMITS" -gt 5 ]; then
            warning "$RECENT_COMMITS commits since $doc_name update"
            info "Likely needs updating - consider reviewing for currency"
        fi
    else
        ok "$doc_name updated recently ($DOC_AGE_DAYS days ago)"
    fi
}

# Check all master documents
check_master_doc "CONTRIBUTING.md" "CONTRIBUTING.md"
check_master_doc "CHANGELOG.md" "CHANGELOG.md"
check_master_doc "docs/MILESTONES.md" "docs/MILESTONES.md"
check_master_doc "docs/BRANCHING_STRATEGY.md" "docs/BRANCHING_STRATEGY.md"

# ============================================
# SUMMARY
# ============================================
section "Summary"

echo ""
if [ $ISSUES_FOUND -eq 0 ] && [ $WARNINGS_FOUND -eq 0 ]; then
    echo "🎉 Completeness check passed with no issues!"
    echo ""
    echo "All checks completed successfully. Work appears complete."
    exit 0
elif [ $ISSUES_FOUND -eq 0 ]; then
    echo "⚠️  Completeness check passed with $WARNINGS_FOUND warning(s)"
    echo ""
    echo "Review warnings above. These are suggestions, not blockers."
    exit 0
else
    echo "❌ Completeness check found $ISSUES_FOUND issue(s) and $WARNINGS_FOUND warning(s)"
    echo ""
    echo "Review and address issues above before considering work complete."
    exit 1
fi

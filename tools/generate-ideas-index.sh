#!/bin/bash
# Generate Ideas Index
# Scans ideas/ directory and generates INDEX.md by status

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

INDEX_FILE="ideas/INDEX.md"
TIMESTAMP=$(date -u +"%Y-%m-%d")

echo "Generating ideas index..."

# Initialize counters
NEW_COUNT=0
RESEARCHING_COUNT=0
DECIDED_COUNT=0
DEFERRED_COUNT=0
DISCARDED_COUNT=0
IMPLEMENTED_COUNT=0

# Function to extract status from idea file
get_status() {
    local file=$1
    grep "^\*\*Status:\*\*" "$file" | sed 's/.*Status:\*\* //' | sed 's/ |.*//' || echo "Unknown"
}

# Start building index
cat > "$INDEX_FILE" << 'EOF'
# Ideas Index

**Last Updated:** TIMESTAMP_PLACEHOLDER (Auto-generated)

## Active Ideas

### New
EOF

# Find and categorize ideas
NEW_IDEAS=$(find ideas -name "*.md" -type f ! -name "README.md" ! -name "TEMPLATE.md" ! -name "INDEX.md" 2>/dev/null || true)

if [ -z "$NEW_IDEAS" ]; then
    echo "*(No ideas captured yet)*" >> "$INDEX_FILE"
else
    # Process each idea file
    for idea_file in $NEW_IDEAS; do
        STATUS=$(get_status "$idea_file")
        BASENAME=$(basename "$idea_file")

        case "$STATUS" in
            "New")
                ((NEW_COUNT++))
                ;;
            "Researching")
                ((RESEARCHING_COUNT++))
                ;;
            "Decided")
                ((DECIDED_COUNT++))
                ;;
            "Deferred")
                ((DEFERRED_COUNT++))
                ;;
            "Discarded")
                ((DISCARDED_COUNT++))
                ;;
            "Implemented")
                ((IMPLEMENTED_COUNT++))
                ;;
        esac
    done

    # Build sections
    if [ $NEW_COUNT -eq 0 ]; then
        echo "*(No new ideas)*" >> "$INDEX_FILE"
    else
        for idea_file in $NEW_IDEAS; do
            STATUS=$(get_status "$idea_file")
            if [ "$STATUS" = "New" ]; then
                BASENAME=$(basename "$idea_file")
                echo "- [$BASENAME]($BASENAME)" >> "$INDEX_FILE"
            fi
        done
    fi
fi

cat >> "$INDEX_FILE" << 'EOF'

### Researching
EOF

if [ $RESEARCHING_COUNT -eq 0 ]; then
    echo "*(No ideas being researched)*" >> "$INDEX_FILE"
else
    for idea_file in $NEW_IDEAS; do
        STATUS=$(get_status "$idea_file")
        if [ "$STATUS" = "Researching" ]; then
            BASENAME=$(basename "$idea_file")
            echo "- [$BASENAME]($BASENAME)" >> "$INDEX_FILE"
        fi
    done
fi

cat >> "$INDEX_FILE" << 'EOF'

## Decided Ideas
EOF

if [ $DECIDED_COUNT -eq 0 ]; then
    echo "*(No ideas have become decisions yet)*" >> "$INDEX_FILE"
else
    for idea_file in $NEW_IDEAS; do
        STATUS=$(get_status "$idea_file")
        if [ "$STATUS" = "Decided" ]; then
            BASENAME=$(basename "$idea_file")
            echo "- [$BASENAME]($BASENAME)" >> "$INDEX_FILE"
        fi
    done
fi

cat >> "$INDEX_FILE" << 'EOF'

## Deferred Ideas (Backlog)
EOF

if [ $DEFERRED_COUNT -eq 0 ]; then
    echo "*(No deferred ideas)*" >> "$INDEX_FILE"
else
    for idea_file in $NEW_IDEAS; do
        STATUS=$(get_status "$idea_file")
        if [ "$STATUS" = "Deferred" ]; then
            BASENAME=$(basename "$idea_file")
            echo "- [$BASENAME]($BASENAME)" >> "$INDEX_FILE"
        fi
    done
fi

cat >> "$INDEX_FILE" << 'EOF'

## Discarded Ideas
EOF

if [ $DISCARDED_COUNT -eq 0 ]; then
    echo "*(No discarded ideas)*" >> "$INDEX_FILE"
else
    for idea_file in $NEW_IDEAS; do
        STATUS=$(get_status "$idea_file")
        if [ "$STATUS" = "Discarded" ]; then
            BASENAME=$(basename "$idea_file")
            echo "- [$BASENAME]($BASENAME)" >> "$INDEX_FILE"
        fi
    done
fi

cat >> "$INDEX_FILE" << 'EOF'

## Implemented Ideas
EOF

if [ $IMPLEMENTED_COUNT -eq 0 ]; then
    echo "*(No implemented ideas)*" >> "$INDEX_FILE"
else
    for idea_file in $NEW_IDEAS; do
        STATUS=$(get_status "$idea_file")
        if [ "$STATUS" = "Implemented" ]; then
            BASENAME=$(basename "$idea_file")
            echo "- [$BASENAME]($BASENAME)" >> "$INDEX_FILE"
        fi
    done
fi

# Add stats
TOTAL=$((NEW_COUNT + RESEARCHING_COUNT + DECIDED_COUNT + DEFERRED_COUNT + DISCARDED_COUNT + IMPLEMENTED_COUNT))
ACTIVE=$((NEW_COUNT + RESEARCHING_COUNT))

cat >> "$INDEX_FILE" << EOF

---

## Quick Stats
- **Total Ideas:** $TOTAL
- **Active (New + Researching):** $ACTIVE
- **Decided:** $DECIDED_COUNT
- **Deferred:** $DEFERRED_COUNT
- **Discarded:** $DISCARDED_COUNT
- **Implemented:** $IMPLEMENTED_COUNT

---

**Update Protocol:**
Run \`tools/generate-ideas-index.sh\` to regenerate this index.

**For AI Agents:**
Check this index when:
- Stuck on a problem
- Looking for next steps
- Planning a phase
- Seeking alternatives

**For Humans:**
This gives you visibility into what possibilities we're tracking without wading through individual files.
EOF

# Update timestamp
sed -i "s/TIMESTAMP_PLACEHOLDER/$TIMESTAMP/" "$INDEX_FILE"

echo "✓ Ideas index updated: $INDEX_FILE"

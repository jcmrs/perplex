#!/usr/bin/env bash
# Shared test helpers for Project Perplex tests
# Load this in bats tests with: load '../helpers/test-helpers'

# Setup a temporary test directory
setup_test_temp_dir() {
    export TEST_TEMP_DIR
    TEST_TEMP_DIR="$(mktemp -d)"
}

# Cleanup temporary test directory
teardown_test_temp_dir() {
    if [ -n "$TEST_TEMP_DIR" ] && [ -d "$TEST_TEMP_DIR" ]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

# Create a minimal mock git repository
setup_mock_git_repo() {
    local repo_dir="${1:-$TEST_TEMP_DIR}"

    cd "$repo_dir" || return 1

    git init
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Create initial commit
    echo "# Test Repository" > README.md
    git add README.md
    git commit -m "Initial commit" --no-gpg-sign
}

# Create mock foundation structure
setup_mock_foundation() {
    local base_dir="${1:-$TEST_TEMP_DIR}"

    mkdir -p "$base_dir"/{config,decisions,docs,knowledge,sessions,tools,checkpoints}

    # Create minimal required files
    cat > "$base_dir/FOUNDATION.md" <<'EOF'
# Foundation Mock
Test foundation file
EOF

    cat > "$base_dir/README.md" <<'EOF'
# Test Project
Test readme
EOF

    cat > "$base_dir/config/project.yml" <<'EOF'
project:
  name: "Test Project"
  version: "0.1.0"
EOF
}

# Assert file exists
assert_file_exists() {
    local file="$1"
    local message="${2:-File should exist: $file}"

    [ -f "$file" ] || {
        echo "$message"
        return 1
    }
}

# Assert directory exists
assert_dir_exists() {
    local dir="$1"
    local message="${2:-Directory should exist: $dir}"

    [ -d "$dir" ] || {
        echo "$message"
        return 1
    }
}

# Assert file contains string
assert_file_contains() {
    local file="$1"
    local search="$2"
    local message="${3:-File should contain: $search}"

    grep -q "$search" "$file" || {
        echo "$message"
        echo "File contents:"
        cat "$file"
        return 1
    }
}

# Assert output contains string
assert_output_contains() {
    local search="$1"
    local message="${2:-Output should contain: $search}"

    echo "$output" | grep -q "$search" || {
        echo "$message"
        echo "Actual output:"
        echo "$output"
        return 1
    }
}

# Assert exit code
assert_exit_code() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Expected exit code $expected, got $actual}"

    [ "$expected" -eq "$actual" ] || {
        echo "$message"
        return 1
    }
}

# Skip test if command not available
require_command() {
    local cmd="$1"
    local message="${2:-Test requires $cmd to be installed}"

    if ! command -v "$cmd" >/dev/null 2>&1; then
        skip "$message"
    fi
}

# Create a minimal checkpoint file
create_mock_checkpoint() {
    local checkpoint_dir="${1:-$TEST_TEMP_DIR/checkpoints}"
    local timestamp="${2:-20250101-120000}"
    local description="${3:-test-checkpoint}"

    mkdir -p "$checkpoint_dir"

    cat > "$checkpoint_dir/checkpoint-$timestamp-$description.md" <<EOF
# Checkpoint: Test Checkpoint

**Checkpoint ID:** checkpoint-$timestamp-$description
**Date:** 2025-01-01 12:00 UTC
**Phase:** test

---

## 30-Second Summary

This is a test checkpoint for testing purposes.

---

## Read First (Priority Order)

**Critical (Read immediately):**
1. FOUNDATION.md

---

## Next Actions

**Immediate next session should:**
- Continue testing
EOF

    # Create symlink to LATEST
    ln -sf "checkpoint-$timestamp-$description.md" "$checkpoint_dir/LATEST.md"

    echo "$checkpoint_dir/checkpoint-$timestamp-$description.md"
}

# Print debug information (useful for troubleshooting tests)
debug_print() {
    echo "# DEBUG: $*" >&3
}

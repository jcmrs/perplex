#!/usr/bin/env bats
# Tests for tools/validate-foundation.sh

# Load test helpers
load '../helpers/test-helpers'

setup() {
    # Create temporary test directory
    setup_test_temp_dir

    # Store original directory
    ORIGINAL_DIR="$PWD"
}

teardown() {
    # Return to original directory
    cd "$ORIGINAL_DIR" || true

    # Cleanup temp directory
    teardown_test_temp_dir
}

@test "validate-foundation: runs successfully in valid project" {
    # This test runs against the actual project structure
    run ./tools/validate-foundation.sh

    # Should succeed (exit 0)
    [ "$status" -eq 0 ]

    # Should produce success output
    [[ "$output" =~ "Foundation validation complete" ]] || \
    [[ "$output" =~ "✓" ]] || \
    [[ "$output" =~ "PASSED" ]]
}

@test "validate-foundation: detects missing FOUNDATION.md" {
    # Setup minimal mock structure without FOUNDATION.md
    cd "$TEST_TEMP_DIR" || return 1
    setup_mock_git_repo

    mkdir -p config decisions docs sessions tools
    echo "project:" > config/project.yml

    # Run validation (should fail)
    run "$ORIGINAL_DIR/tools/validate-foundation.sh"

    # Should fail (exit non-zero)
    [ "$status" -ne 0 ]

    # Should mention missing FOUNDATION.md
    [[ "$output" =~ "FOUNDATION.md" ]]
}

@test "validate-foundation: detects missing required directories" {
    # Setup incomplete structure
    cd "$TEST_TEMP_DIR" || return 1
    setup_mock_git_repo

    # Only create FOUNDATION.md, missing other dirs
    echo "# Foundation" > FOUNDATION.md

    # Run validation (should fail)
    run "$ORIGINAL_DIR/tools/validate-foundation.sh"

    # Should fail
    [ "$status" -ne 0 ]
}

@test "validate-foundation: passes with complete mock structure" {
    # Setup complete mock foundation
    cd "$TEST_TEMP_DIR" || return 1
    setup_mock_git_repo
    setup_mock_foundation .

    # Run validation
    run "$ORIGINAL_DIR/tools/validate-foundation.sh"

    # Should succeed
    [ "$status" -eq 0 ]
}

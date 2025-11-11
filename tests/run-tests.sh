#!/usr/bin/env bash
# Main test runner for Project Perplex
# Runs shellcheck, bats, and yamllint tests

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results
SHELLCHECK_PASSED=false
BATS_PASSED=false
YAML_PASSED=false
OVERALL_PASSED=true

# Parse arguments
RUN_SHELLCHECK=true
RUN_BATS=true
RUN_YAML=true
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --shellcheck)
            RUN_BATS=false
            RUN_YAML=false
            shift
            ;;
        --bats)
            RUN_SHELLCHECK=false
            RUN_YAML=false
            shift
            ;;
        --yaml)
            RUN_SHELLCHECK=false
            RUN_BATS=false
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --shellcheck    Run only shellcheck tests"
            echo "  --bats          Run only bats integration tests"
            echo "  --yaml          Run only YAML validation"
            echo "  --verbose, -v   Verbose output"
            echo "  --help, -h      Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                    # Run all tests"
            echo "  $0 --shellcheck       # Run only shellcheck"
            echo "  $0 --verbose          # Run all tests with verbose output"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Change to project root
cd "$(dirname "$0")/.."

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Project Perplex - Test Suite${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print section header
section() {
    echo ""
    echo -e "${BLUE}--- $1 ---${NC}"
}

# Function to print success
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print failure
failure() {
    echo -e "${RED}✗ $1${NC}"
    OVERALL_PASSED=false
}

# Function to print warning
warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to print info
info() {
    echo -e "  $1"
}

# 1. Shellcheck - Static analysis for shell scripts
if [ "$RUN_SHELLCHECK" = true ]; then
    section "Shellcheck - Static Analysis"

    if ! command_exists shellcheck; then
        warning "shellcheck not installed, skipping"
        warning "Install: brew install shellcheck (macOS) or apt-get install shellcheck (Linux)"
    else
        SHELL_FILES=$(find tools .github/hooks -name "*.sh" 2>/dev/null || true)

        if [ -z "$SHELL_FILES" ]; then
            warning "No shell files found"
        else
            SHELLCHECK_FAILED=false

            for file in $SHELL_FILES; do
                if [ "$VERBOSE" = true ]; then
                    info "Checking $file..."
                fi

                if shellcheck "$file"; then
                    if [ "$VERBOSE" = true ]; then
                        success "$file passed"
                    fi
                else
                    failure "$file failed shellcheck"
                    SHELLCHECK_FAILED=true
                fi
            done

            if [ "$SHELLCHECK_FAILED" = false ]; then
                success "All shell scripts passed shellcheck"
                SHELLCHECK_PASSED=true
            else
                failure "Some shell scripts failed shellcheck"
            fi
        fi
    fi
fi

# 2. Bats - Integration tests
if [ "$RUN_BATS" = true ]; then
    section "Bats - Integration Tests"

    if ! command_exists bats; then
        warning "bats not installed, skipping"
        warning "Install: brew install bats-core (macOS) or see tests/README.md"
    else
        BATS_FILES=$(find tests -name "*.bats" 2>/dev/null || true)

        if [ -z "$BATS_FILES" ]; then
            warning "No bats test files found (tests/**/*.bats)"
            info "Tests will be added as functionality is implemented"
            BATS_PASSED=true  # Not a failure if no tests yet
        else
            if [ "$VERBOSE" = true ]; then
                BATS_OPTS="--verbose-run --print-output-on-failure"
            else
                BATS_OPTS="--print-output-on-failure"
            fi

            # shellcheck disable=SC2086
            if bats $BATS_OPTS tests; then
                success "All bats tests passed"
                BATS_PASSED=true
            else
                failure "Some bats tests failed"
            fi
        fi
    fi
fi

# 3. YAML validation
if [ "$RUN_YAML" = true ]; then
    section "YAML Validation"

    if ! command_exists yamllint; then
        warning "yamllint not installed, skipping"
        warning "Install: pip install yamllint"
    else
        YAML_FILES=$(find .github config -name "*.yml" -o -name "*.yaml" 2>/dev/null || true)

        if [ -z "$YAML_FILES" ]; then
            warning "No YAML files found"
        else
            if [ "$VERBOSE" = true ]; then
                YAMLLINT_OPTS="-f colored"
            else
                YAMLLINT_OPTS="-f parsable"
            fi

            # shellcheck disable=SC2086
            if echo "$YAML_FILES" | xargs yamllint $YAMLLINT_OPTS; then
                success "All YAML files are valid"
                YAML_PASSED=true
            else
                failure "Some YAML files failed validation"
            fi
        fi
    fi
fi

# Summary
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Test Results${NC}"
echo -e "${BLUE}========================================${NC}"

if [ "$RUN_SHELLCHECK" = true ]; then
    if [ "$SHELLCHECK_PASSED" = true ]; then
        success "Shellcheck: PASSED"
    else
        failure "Shellcheck: FAILED"
    fi
fi

if [ "$RUN_BATS" = true ]; then
    if [ "$BATS_PASSED" = true ]; then
        success "Bats: PASSED"
    else
        failure "Bats: FAILED"
    fi
fi

if [ "$RUN_YAML" = true ]; then
    if [ "$YAML_PASSED" = true ]; then
        success "YAML: PASSED"
    else
        failure "YAML: FAILED"
    fi
fi

echo ""

if [ "$OVERALL_PASSED" = true ]; then
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}ALL TESTS PASSED ✓${NC}"
    echo -e "${GREEN}========================================${NC}"
    exit 0
else
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}SOME TESTS FAILED ✗${NC}"
    echo -e "${RED}========================================${NC}"
    exit 1
fi

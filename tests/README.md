# Testing Infrastructure

**Status:** Active
**Last Updated:** 2025-11-11

## Overview

Project Perplex uses a multi-layered testing approach to ensure quality across shell scripts, YAML files, and documentation.

## Testing Stack

### 1. Shell Script Testing

**Static Analysis: shellcheck**
- Lints shell scripts for bugs, portability issues, and best practices
- Runs on all `*.sh` files in `tools/` and `.github/hooks/`
- Configuration: `.shellcheckrc`

**Integration Testing: bats**
- Bash Automated Testing System for functional tests
- Tests scripts end-to-end with real inputs/outputs
- Test files: `tests/tools/*.bats`

### 2. YAML Validation

**yamllint**
- Validates YAML syntax and style
- Runs on config files and GitHub workflows
- Configuration: `.yamllint.yml`

### 3. Markdown Linting (Optional)

**markdownlint**
- Ensures consistent documentation style
- Can be added in future if needed

## Directory Structure

```
tests/
├── README.md (this file)
├── tools/              # Tests for scripts in tools/
│   ├── validate-foundation.bats
│   ├── generate-status.bats
│   ├── create-checkpoint.bats
│   └── ...
├── fixtures/           # Test data and fixtures
│   ├── mock-repo/
│   └── sample-data/
├── helpers/            # Shared test helpers
│   └── test-helpers.bash
└── run-tests.sh        # Main test runner script
```

## Running Tests

### All Tests
```bash
./tests/run-tests.sh
```

### Specific Test Types
```bash
# Shell script static analysis only
./tests/run-tests.sh --shellcheck

# Integration tests only
./tests/run-tests.sh --bats

# YAML validation only
./tests/run-tests.sh --yaml
```

### Individual Test File
```bash
bats tests/tools/validate-foundation.bats
```

### CI/CD
Tests run automatically via GitHub Actions on:
- Pull requests
- Pushes to main
- Manual workflow dispatch

See: `.github/workflows/tests.yml`

## Writing Tests

### Shell Script Tests (bats)

Create a `.bats` file in `tests/tools/` for each script:

```bash
#!/usr/bin/env bats

# Load test helpers
load '../helpers/test-helpers'

setup() {
    # Run before each test
    export TEST_TEMP_DIR="$(mktemp -d)"
}

teardown() {
    # Run after each test
    rm -rf "$TEST_TEMP_DIR"
}

@test "script-name: validates input correctly" {
    run ./tools/script-name.sh --valid-option
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Expected output" ]]
}

@test "script-name: fails on invalid input" {
    run ./tools/script-name.sh --invalid
    [ "$status" -eq 1 ]
}
```

### Test Helpers

Common functions for tests go in `tests/helpers/test-helpers.bash`:

```bash
# Create a mock git repository
setup_mock_repo() {
    local repo_dir="$1"
    git init "$repo_dir"
    cd "$repo_dir"
    git config user.name "Test User"
    git config user.email "test@example.com"
}

# Assert file exists
assert_file_exists() {
    [ -f "$1" ] || {
        echo "File does not exist: $1"
        return 1
    }
}
```

## Testing Philosophy

### AI-First Testing
- Tests should be readable by AI agents
- Clear naming: `@test "feature: what it does"`
- Self-documenting assertions
- Minimal test setup complexity

### What to Test

**DO test:**
- ✅ Script exit codes (success/failure)
- ✅ Error handling and validation
- ✅ File creation and modification
- ✅ Output format and content
- ✅ Integration between scripts

**DON'T test:**
- ❌ External services (GitHub API, web fetches)
- ❌ User interactions (prompts, confirmations)
- ❌ Timing-dependent behavior

### Test Coverage Goals

We're not aiming for 100% coverage. Focus on:
- **High-value paths**: Common use cases, critical functionality
- **Error conditions**: Input validation, failure modes
- **Regressions**: Tests for bugs found and fixed

## Installation

### Local Development

Install testing tools:

```bash
# Install shellcheck
# macOS
brew install shellcheck

# Ubuntu/Debian
apt-get install shellcheck

# Install bats
# macOS
brew install bats-core

# Ubuntu/Debian
git clone https://github.com/bats-core/bats-core.git
cd bats-core
./install.sh /usr/local

# Install yamllint
pip install yamllint
```

Or use the setup script:
```bash
./tools/setup-testing.sh
```

### CI/CD

GitHub Actions automatically installs all dependencies.

## Configuration Files

### .shellcheckrc
Shellcheck configuration for project-specific rules:
```bash
# Disable specific checks if needed
disable=SC2034  # Unused variables (common in config files)

# Enable optional checks
enable=all
```

### .yamllint.yml
YAML linting configuration:
```yaml
extends: default
rules:
  line-length:
    max: 120
    level: warning
  indentation:
    spaces: 2
```

## Integration with Other Systems

### Pre-commit Hooks
- Shellcheck runs on modified `.sh` files
- YAML validation runs on modified `.yml` files
- See: `.github/hooks/pre-commit`

### GitHub Actions
- Full test suite on PR
- Required status check before merge
- See: `.github/workflows/tests.yml`

### Completeness Review
- Checks if tests added for new scripts
- Prompts if tests updated after script changes
- See: `tools/review-completeness.sh`

## Troubleshooting

### bats not found
```bash
# Install bats-core (not the older bats)
brew install bats-core
# or
git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh /usr/local
```

### shellcheck false positives
Add to `.shellcheckrc` or use inline directive:
```bash
# shellcheck disable=SC2016
echo 'Variables like $FOO are not expanded in single quotes'
```

### Tests fail in CI but pass locally
- Check for absolute vs. relative paths
- Verify environment variables
- Check for macOS vs. Linux differences

## Future Enhancements

Tracked in backlog:
- [ ] Code coverage reporting
- [ ] Performance benchmarking
- [ ] Mutation testing
- [ ] Visual regression testing (for future UI components)

## Related Documentation

- [Foundation Validation](../tools/validate-foundation.sh) - Structural validation
- [Completeness Review](../docs/COMPLETENESS_REVIEW.md) - Quality gates
- [GitHub Actions](.github/workflows/) - CI/CD pipelines

---

**For AI Agents:**
- Run tests before committing changes to scripts
- Add tests when creating new scripts
- Update tests when fixing bugs
- Run `./tests/run-tests.sh` to verify everything works

**For Human Contributors:**
- Tests are documentation - they show how scripts should work
- When in doubt, look at existing tests as examples
- It's okay to skip tests for trivial scripts
- Focus on high-value test coverage, not 100%

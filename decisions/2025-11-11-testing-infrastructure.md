# ADR-004: Testing Infrastructure

**Date:** 2025-11-11
**Status:** Accepted
**Scope:** Foundation / Infrastructure

## Context

Project Perplex needs a testing infrastructure to ensure quality before implementation phase begins. The project currently consists of:
- Shell scripts (10 files in `tools/`)
- YAML files (GitHub workflows, config)
- Markdown documentation
- No implementation code yet (foundation/discovery phase)

Need to establish testing patterns and tools before writing implementation code.

## Decision Drivers

1. **AI-First**: Tests must be readable and maintainable by AI agents across sessions
2. **Modularity**: Testing infrastructure should support different test types independently
3. **Automation**: Tests must run in CI/CD without manual intervention
4. **Extensibility**: Should easily accommodate future test types (when implementation code exists)
5. **Portability**: Must work on macOS, Linux, and CI environments

## Considered Options

### Option 1: Manual Testing Only
**Pros:**
- Simple, no infrastructure needed
- Fast to start

**Cons:**
- Not sustainable
- No automation
- Inconsistent results
- Violates AI-First and Automation imperatives

**Decision:** ❌ Rejected

### Option 2: Shell Script Testing Only (shellcheck + bats)
**Pros:**
- Lightweight
- Directly addresses current needs (shell scripts)
- Battle-tested tools

**Cons:**
- Incomplete (doesn't cover YAML, Markdown)
- Would need extension later

**Decision:** ⚠️ Partial - included but not sufficient alone

### Option 3: Comprehensive Multi-Layer Testing ✅ **SELECTED**
**Pros:**
- ✅ Covers all current file types (shell, YAML, Markdown)
- ✅ Modular - each test type can run independently
- ✅ Extensible - easy to add new test types
- ✅ CI/CD ready
- ✅ Aligns with all five cornerstones

**Cons:**
- More upfront setup (one-time cost)
- Multiple dependencies to install

**Decision:** ✅ **Accepted**

## Implementation Details

### Testing Stack

**1. Shell Script Testing**
- **shellcheck**: Static analysis (catches bugs, portability issues)
- **bats-core**: Integration testing (functional tests)
- Rationale: Industry standard, well-documented, AI-readable test syntax

**2. YAML Validation**
- **yamllint**: Syntax and style validation
- Rationale: Catches GitHub workflow errors before push

**3. Markdown Linting** (Optional/Future)
- **markdownlint**: Documentation consistency
- Rationale: Deferred - low priority, can add if needed

### Directory Structure

```
tests/
├── README.md           # Complete testing documentation
├── run-tests.sh        # Main test runner (supports --shellcheck, --bats, --yaml)
├── helpers/            # Shared test utilities
│   └── test-helpers.bash
├── tools/              # Tests for scripts in tools/
│   └── validate-foundation.bats
└── fixtures/           # Test data
```

### Configuration Files

- `.shellcheckrc`: Shellcheck rules and exceptions
- `.yamllint.yml`: YAML linting configuration

### Test Runner Features

- **Modular execution**: Run specific test types (`--shellcheck`, `--bats`, `--yaml`)
- **Verbose mode**: `--verbose` for detailed output
- **Graceful degradation**: Missing tools show warnings with install instructions
- **Clear output**: Color-coded results (✓ success, ✗ failure, ⚠ warning)
- **Exit codes**: 0 for pass, 1 for fail (CI/CD compatible)

### CI/CD Integration

- **GitHub Actions**: `.github/workflows/tests.yml`
- Runs on: PR, push to main, claude/**, manual dispatch
- Installs all dependencies automatically
- Separate jobs per test type for parallel execution

### Developer Experience

- **Setup script**: `tools/setup-testing.sh` installs dependencies
- **Documentation**: Comprehensive `tests/README.md`
- **Examples**: Sample test file demonstrates patterns
- **Helpers**: Reusable test utilities in `test-helpers.bash`

## Consequences

### Positive

✅ **Quality gates before implementation**: Catch errors early
✅ **AI-First**: Tests are self-documenting, readable by future AI sessions
✅ **Modularity**: Each test type independent, can evolve separately
✅ **Extensibility**: Easy to add new test types (e.g., Python, JavaScript later)
✅ **Automation**: Full CI/CD integration, no manual testing needed
✅ **Configurability**: `.shellcheckrc` and `.yamllint.yml` allow customization

### Negative

⚠️ **Setup complexity**: Developers must install tools (mitigated by setup script)
⚠️ **CI time**: Tests add time to PR validation (currently minimal, may grow)

### Neutral

ℹ️ **No tests for implementation code yet**: Will add when code exists
ℹ️ **Markdown linting deferred**: Can add if documentation quality becomes issue

## Alignment with Foundation Imperatives

| Imperative | Alignment | Evidence |
|------------|-----------|----------|
| **Configurability** | ✅ Strong | `.shellcheckrc`, `.yamllint.yml` - behavior driven by config |
| **Modularity** | ✅ Strong | Independent test types, separate execution, clear boundaries |
| **Extensibility** | ✅ Strong | Easy to add new test types, plugin architecture via test runner |
| **Integration** | ✅ Strong | GitHub Actions, pre-commit hooks, completeness review |
| **Automation** | ✅ Strong | Full CI/CD, automated dependency install, test runner script |
| **AI-First** | ✅ Strong | Readable test syntax, comprehensive docs, helper functions |
| **Holistic System Thinking** | ✅ Strong | Considers current and future needs, CI integration |

## Open Questions

**Q:** Should we require tests for all new scripts?
**A:** Deferred. Start with high-value tests (validate-foundation, create-checkpoint). Add requirement when pattern established.

**Q:** What about code coverage metrics?
**A:** Deferred. Focus on high-value tests first, add coverage reporting in implementation phase if needed.

**Q:** Should tests be a required status check for PRs?
**A:** Yes, after validation period. Will add to branch protection after confirming tests are stable.

## Future Enhancements

Tracked in backlog or can be added as needed:
- [ ] Code coverage reporting
- [ ] Performance benchmarking for scripts
- [ ] Mutation testing
- [ ] Add tests to completeness review checklist
- [ ] Pre-commit hook integration (shellcheck on modified .sh files)

## References

- **shellcheck**: https://www.shellcheck.net/
- **bats-core**: https://github.com/bats-core/bats-core
- **yamllint**: https://yamllint.readthedocs.io/
- **Testing Philosophy**: tests/README.md

## Related Decisions

- ADR-001: Discovery-Driven Development (testing supports rapid validation)
- ADR-002: Foundation Enhancements (testing is enforcement mechanism)

## Tags

`#testing` `#infrastructure` `#quality` `#ci-cd` `#shellcheck` `#bats` `#yamllint`

---

**Approved by:** AI Agent (autonomous technical decision)
**Rationale:** Foundational infrastructure decision within autonomous scope, aligns with all imperatives, enables quality gates for implementation phase

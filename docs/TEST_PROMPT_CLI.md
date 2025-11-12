# Stage 1 Verification Test Prompt

**Purpose:** Verify Stage 1 architecture is fully operational after setup.

**When to use:** After completing setup from `SETUP_PROMPT_CLI.md`

**Target:** Claude Code CLI (local)

---

## Test Mission

Verify all Stage 1 components are working correctly:
1. ✅ MCP connection operational
2. ✅ basic-memory responding
3. ✅ Knowledge graph functional
4. ✅ Project isolation working
5. ✅ Search operational
6. ✅ Wiki-link navigation working

---

## Test Sequence

### Test 1: MCP Connection Check

**Objective:** Verify MCP server responds

**Action:**
Use basic-memory MCP tools to check connection status.

**Expected Result:**
- MCP server responds
- No connection errors
- basic-memory version displayed

**Pass Criteria:** ✅ Connection successful

---

### Test 2: Note Creation

**Objective:** Verify can write to knowledge graph

**Action:**
Create test note:
```markdown
---
title: Test Note Creation
created: 2025-11-12
tags: [test, verification]
---

# Test Note Creation

## Observations

[fact] This is a test note to verify basic-memory is operational.
[method] Created via MCP write_note tool.

## Test Data

- Timestamp: [CURRENT_TIMESTAMP]
- Test ID: TEST-001
- Status: Testing note creation

## Relations

- Verifies: [[Stage 1 Architecture]]
```

**Expected Result:**
- Note created successfully
- File exists at: `~\basic-memory\perplex\notes\test-note-creation.md`
- SQLite index updated
- No errors

**Pass Criteria:** ✅ Note created and retrievable

---

### Test 3: Note Retrieval

**Objective:** Verify can read from knowledge graph

**Action:**
Read the note just created:
- Tool: `read_note`
- Parameter: `title="Test Note Creation"`

**Expected Result:**
- Full note content returned
- YAML frontmatter intact
- All sections present
- Content matches what was written

**Pass Criteria:** ✅ Note retrieved successfully

---

### Test 4: Search Functionality

**Objective:** Verify search works

**Action:**
Search for: "test note creation"

**Expected Result:**
- Search returns results
- "Test Note Creation" note appears in results
- Relevance score reasonable
- No errors

**Pass Criteria:** ✅ Search returns correct note

---

### Test 5: Wiki-Link Creation

**Objective:** Verify wiki-links work

**Action:**
Create related note:
```markdown
---
title: Stage 1 Architecture
created: 2025-11-12
tags: [architecture, stage-1]
---

# Stage 1 Architecture

## Components

- basic-memory MCP server
- Claude Code CLI
- Project-level configuration

## Verification

- Test: [[Test Note Creation]]
```

**Expected Result:**
- Note created successfully
- Wiki-link syntax preserved
- File created: `~\basic-memory\perplex\notes\stage-1-architecture.md`

**Pass Criteria:** ✅ Note with wiki-link created

---

### Test 6: Wiki-Link Navigation

**Objective:** Verify can navigate via wiki-links

**Action:**
Navigate from "Stage 1 Architecture" to "Test Note Creation" via wiki-link:
- Tool: `build_context`
- Parameter: `[[Test Note Creation]]`

**Expected Result:**
- Returns "Test Note Creation" note content
- Follows the wiki-link successfully
- No errors

**Pass Criteria:** ✅ Wiki-link navigation works

---

### Test 7: Project Isolation Validation

**Objective:** Verify project isolation is working

**Action:**
1. Check current project notes:
   - List all notes in perplex project
   - Count should match created notes

2. Verify storage location:
   - Check: `~\basic-memory\perplex\notes\`
   - Should contain only perplex notes
   - Separate from any other projects

3. Verify PROJECT env var:
   - Confirm PROJECT=perplex in config

**Expected Result:**
- Only perplex notes visible
- Storage isolated to perplex directory
- No contamination from other projects
- PROJECT env var correctly set

**Pass Criteria:** ✅ Complete isolation confirmed

---

### Test 8: Recent Activity

**Objective:** Verify recent activity tracking

**Action:**
Check recent activity:
- Tool: `recent_activity`
- Limit: 10

**Expected Result:**
- Returns list of recently created/updated notes
- Test notes appear (just created)
- Timestamps correct
- Ordered by recency

**Pass Criteria:** ✅ Recent activity shows test notes

---

### Test 9: Note Update

**Objective:** Verify can update existing notes

**Action:**
Update "Test Note Creation" note:
- Add new observation: `[fact] Note update test successful.`
- Add new test data line

**Expected Result:**
- Note updated successfully
- `updated` timestamp changed in frontmatter
- `created` timestamp preserved
- New content appears
- Old content retained

**Pass Criteria:** ✅ Note updated correctly

---

### Test 10: End-to-End Workflow

**Objective:** Verify complete workflow

**Action:**
1. Create new note: "Stage 1 Verification Complete"
2. Link to "Test Note Creation" and "Stage 1 Architecture"
3. Add observation: [fact] All Stage 1 tests passed
4. Search for "verification"
5. Navigate via wiki-links
6. Check recent activity shows new note

**Note Content:**
```markdown
---
title: Stage 1 Verification Complete
created: 2025-11-12
tags: [verification, complete, stage-1]
---

# Stage 1 Verification Complete

## Test Results

[fact] All Stage 1 verification tests passed successfully.
[fact] basic-memory MCP server operational.
[fact] Project isolation confirmed.
[fact] Knowledge graph functional.

## Test Notes

- Created: [[Test Note Creation]]
- Architecture: [[Stage 1 Architecture]]

## Verification Checklist

- ✅ MCP connection
- ✅ Note creation
- ✅ Note retrieval
- ✅ Search functionality
- ✅ Wiki-link creation
- ✅ Wiki-link navigation
- ✅ Project isolation
- ✅ Recent activity
- ✅ Note updates
- ✅ End-to-end workflow

## Relations

- Foundation: [[Project Perplex Foundation]]
- Setup: [[Stage 1 Setup Complete]]
- Tests: [[Test Note Creation]]
- Architecture: [[Stage 1 Architecture]]
```

**Expected Result:**
- Note created successfully
- Search finds it
- Wiki-links work bidirectionally
- Recent activity includes it
- All connections intact

**Pass Criteria:** ✅ Complete workflow successful

---

## Final Verification Checklist

Mark each test as passed:

- [ ] Test 1: MCP Connection ✅
- [ ] Test 2: Note Creation ✅
- [ ] Test 3: Note Retrieval ✅
- [ ] Test 4: Search Functionality ✅
- [ ] Test 5: Wiki-Link Creation ✅
- [ ] Test 6: Wiki-Link Navigation ✅
- [ ] Test 7: Project Isolation ✅
- [ ] Test 8: Recent Activity ✅
- [ ] Test 9: Note Update ✅
- [ ] Test 10: End-to-End Workflow ✅

**If all tests pass:** ✅ Stage 1 architecture is fully operational!

---

## Test Report Template

**File:** `docs/STAGE1_TEST_REPORT.md`

```markdown
# Stage 1 Verification Test Report

**Date:** [DATE]
**Tested by:** Claude Code CLI
**Status:** [PASSED / FAILED / PARTIAL]

## Test Summary

- Total Tests: 10
- Passed: [COUNT]
- Failed: [COUNT]
- Skipped: [COUNT]

## Test Results

### Test 1: MCP Connection
- **Status:** [PASSED/FAILED]
- **Notes:** [Details]

### Test 2: Note Creation
- **Status:** [PASSED/FAILED]
- **Notes:** [Details]

[... continue for all tests ...]

## Issues Encountered

[Document any issues and resolutions]

## Performance Observations

- Note creation time: [TIME]
- Search response time: [TIME]
- Wiki-link navigation time: [TIME]

## Storage Verification

- Location: ~/basic-memory/perplex/
- Notes created: [COUNT]
- Database size: [SIZE]
- All files present: [YES/NO]

## Isolation Verification

- PROJECT env var: perplex
- Storage path: ~/basic-memory/perplex/
- No cross-contamination: [CONFIRMED/ISSUE]

## Recommendations

[Any observations or suggestions for improvement]

## Conclusion

[Summary of verification results and readiness for Stage 2]

---

**Verification Complete:** [YES/NO]
**Ready for Stage 2:** [YES/NO/WITH_CAVEATS]
```

---

## If Tests Fail

### Troubleshooting Steps

**MCP Connection Failure:**
1. Check Python version: `python --version` (need 3.12+)
2. Verify basic-memory installed: `uvx basic-memory --version`
3. Check MCP config file exists and valid JSON
4. Verify PROJECT env var set in config
5. Restart Claude Code CLI

**Note Creation Failure:**
1. Check storage directory exists: `~\basic-memory\perplex\`
2. Verify write permissions
3. Check disk space
4. Look for error messages in MCP server logs

**Search Not Working:**
1. Verify SQLite database exists: `.basic-memory.db`
2. Check database not corrupted
3. Try recreating index (restart MCP server)
4. Verify note content indexed

**Wiki-Link Issues:**
1. Verify note titles match exactly (case-sensitive)
2. Check target notes exist
3. Verify wiki-link syntax: `[[Exact Title]]`
4. Test with simple title first

**Isolation Problems:**
1. Verify PROJECT env var different per project
2. Check storage paths are separate
3. List files in each project's directory
4. Confirm separate SQLite databases

---

## Success Criteria Summary

**Stage 1 is operational when:**

1. ✅ All 10 tests pass
2. ✅ No errors or warnings
3. ✅ Project isolation confirmed
4. ✅ Knowledge graph functional
5. ✅ Performance acceptable
6. ✅ Storage correctly located
7. ✅ Test report documented
8. ✅ User validates everything works

---

## After Successful Verification

**Next steps:**

1. **Clean up test notes** (optional):
   - Keep "Stage 1 Verification Complete"
   - Delete other test notes if desired
   - Or keep as examples

2. **Document results:**
   - Create test report
   - Update CURRENT_STATUS.md
   - Commit to git

3. **Ready for production use:**
   - Stage 1 architecture operational
   - Can begin capturing research findings
   - Foundation for Stage 2 work

4. **Create initial knowledge base:**
   - Add "Project Perplex Foundation" note
   - Document current architecture
   - Capture open questions
   - Link to ADRs and documentation

---

## For User

**After Claude Code CLI completes tests:**

1. Review test report
2. Validate key features work from your perspective
3. Check storage location: `C:\Users\<you>\basic-memory\perplex\`
4. Optionally browse notes in Obsidian/VS Code
5. Confirm comfort with workflow

**If everything looks good:** ✅ Stage 1 ready!

**If concerns:** Discuss with Claude Code CLI for troubleshooting

---

**Prepared by:** Claude Code Web (AI Agent)
**For Execution by:** Claude Code CLI (Local AI Agent)
**Date:** 2025-11-12
**Status:** Ready for verification testing

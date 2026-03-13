# Defect Tracking & Bug Report Template

**SafeDriver Passenger App - Bug Reporting System**

---

## 📋 Bug House - All Defects

### **CRITICAL (P0) - Blocks Core Functionality**

| Bug ID | Title | Test Case | Status | Found Date | Fixed Date |
|--------|-------|-----------|--------|------------|------------|
| BUG-001 | [Issue Title] | TC-XXX | [ ] Open [ ] Fixed [ ] Closed | | |
| BUG-002 | [Issue Title] | TC-XXX | [ ] Open [ ] Fixed [ ] Closed | | |

### **HIGH (P1) - Major Feature Broken**

| Bug ID | Title | Test Case | Status | Found Date | Fixed Date |
|--------|-------|-----------|--------|------------|------------|
| BUG-010 | [Issue Title] | TC-XXX | [ ] Open [ ] Fixed [ ] Closed | | |
| BUG-011 | [Issue Title] | TC-XXX | [ ] Open [ ] Fixed [ ] Closed | | |

### **MEDIUM (P2) - Minor Feature Issue**

| Bug ID | Title | Test Case | Status | Found Date | Fixed Date |
|--------|-------|-----------|--------|------------|------------|
| BUG-020 | [Issue Title] | TC-XXX | [ ] Open [ ] Fixed [ ] Closed | | |

### **LOW (P3) - Polish/Nice to Have**

| Bug ID | Title | Test Case | Status | Found Date | Fixed Date |
|--------|-------|-----------|--------|------------|------------|
| BUG-030 | [Issue Title] | TC-XXX | [ ] Open [ ] Fixed [ ] Closed | | |

---

## 📝 Individual Bug Report Template

**Use this template for each bug found during testing**

---

### **BUG-XXX: [Bug Title]**

#### **Basic Information**

**Bug ID:** BUG-XXX  
**Title:** [Clear, concise title of the issue]  
**Date Found:** March 12, 2026  
**Reported By:** [Your Name]  
**Status:** ☐ NEW ☐ ASSIGNED ☐ IN PROGRESS ☐ FIXED ☐ VERIFIED ☐ CLOSED  

---

#### **Classification**

**Severity (Impact):**
- ☐ **CRITICAL (P0)** - Blocks entire app or core functionality
- ☐ **HIGH (P1)** - Major feature completely broken
- ☐ **MEDIUM (P2)** - Feature partially works or minor issue
- ☐ **LOW (P3)** - Polish, cosmetic, or edge case

**Priority (Urgency):**
- ☐ **URGENT** - Fix immediately before next build
- ☐ **HIGH** - Fix before release
- ☐ **MEDIUM** - Fix in next sprint
- ☐ **LOW** - Fix when resources available

**Category:**
- ☐ Functional
- ☐ Performance
- ☐ UI/UX
- ☐ Security
- ☐ Usability
- ☐ Integration
- ☐ Other: _____________

**Component:**
- ☐ Authentication
- ☐ Onboarding
- ☐ Feedback System
- ☐ Dashboard
- ☐ Location/Maps
- ☐ Notifications
- ☐ Settings
- ☐ Safety/Emergency
- ☐ Backend/Firebase
- ☐ Other: _____________

---

#### **Environment**

**Device:**
- **Model:** [e.g., Samsung Galaxy S21]
- **OS:** [e.g., Android 12]
- **OS Version:** [e.g., 12.0.1]

**App Information:**
- **App Version:** [e.g., 1.0.0]
- **Build Number:** [e.g., Build #123]
- **Build Type:** ☐ Debug ☐ Release

**Network:**
- **Type:** ☐ WiFi ☐ 4G ☐ 5G ☐ 3G
- **Speed:** ☐ Fast ☐ Normal ☐ Slow
- **Stability:** ☐ Stable ☐ Intermittent

**Firebase:**
- **Project:** [Project name]
- **Environment:** ☐ Development ☐ Staging ☐ Production

---

#### **Related Test Case**

**Test Case ID:** TC-XXX-XXX  
**Test Case Title:** [Title from test case]  
**Test Step That Failed:** [Step number and description]  

---

#### **Description**

**What is the issue?**

[Detailed description of the problem. What is broken? What should happen?]

**How often does it occur?**

- ☐ Always (100% of the time)
- ☐ Usually (75% of the time)
- ☐ Sometimes (50% of the time)
- ☐ Rarely (25% of the time)
- ☐ Intermittent (unpredictable)

**First Occurrence:**

[When did you first see this issue? After which test?]

---

#### **Steps to Reproduce**

**Preconditions:**

[What needs to be true before this bug happens?]

1. [Precondition 1]
2. [Precondition 2]
3. [Precondition 3]

**Exact Steps to Reproduce:**

1. [Step 1 - What you do]
2. [Step 2 - What you do]
3. [Step 3 - What you do]
4. [Step 4 - What you do]
5. [Step 5 - Result: The bug occurs]

**Test Data Used:**

[What data values did you use?]

- Phone: +94701234567
- Email: test@example.com
- Password: Test@123456
- [Other relevant data]

---

#### **Expected vs Actual Result**

**Expected Result:**

[What SHOULD happen according to the test case]

- User should see: [visible element]
- User should be able to: [action]
- System should: [backend action]
- Data should: [data change]

**Actual Result:**

[What ACTUALLY happens instead]

- User sees: [wrong element or no element]
- User cannot: [missing action]
- System does: [unexpected action]
- Data shows: [wrong data or no data]

---

#### **Screenshots**

**Screenshot 1: Before the Issue**

[Attach screenshot showing the state before the bug occurs]

**Screenshot 2: During the Issue**

[Attach screenshot showing the bug happening]

**Screenshot 3: Error Message (if any)**

[Attach screenshot of error message or console]

---

#### **Logs & Traces**

**Console Output:**

```
[Paste any error messages from console]
```

**Stack Trace:**

```
[Paste any stack trace or error details]
```

**Network Logs:**

```
[If applicable, network error details]
```

**Firebase Logs:**

```
[If applicable, Firebase-related error details]
```

---

#### **Workaround (if exists)**

**Temporary Workaround:**

[Is there a way for users to work around this issue?]

- [ ] No workaround available
- [ ] Yes, users can:
  1. [Workaround step 1]
  2. [Workaround step 2]
  3. [Workaround step 3]

---

#### **Related Bugs**

**Similar Issues:**

[Are there other bugs that seem related?]

- BUG-XXX: [Title]
- BUG-YYY: [Title]

**Blocking Issues:**

[Does this bug prevent other tests from running?]

- Blocks: TC-XXX, TC-YYY

**Blocked By:**

[Is this bug blocked by another issue?]

- Blocked By: BUG-ZZZ

---

#### **Video Recording**

**Video Link:**

[If available, link to video showing the bug in action]

**Duration:** [ ] minutes

---

#### **Root Cause Analysis** (To be filled by Developer)

**Suspected Cause:**

[Developer to identify likely cause]

**Component/File:**

[Which code file or module has the issue?]

**Line/Function:**

[If known, specific line number or function name]

---

#### **Fix Details** (To be filled by Developer)

**Fix Description:**

[What changes were made to fix this?]

**Commit/PR:**

[Link to code commit or pull request]

**Files Modified:**

- [file1.dart]
- [file2.dart]

**Testing for Fix:**

[How should QA verify the fix works?]

---

#### **Regression Testing**

**After Fix - Retest Status:**

- [ ] PASS - Issue is fixed
- [ ] FAIL - Issue still exists
- [ ] PARTIAL - Partially fixed
- [ ] NEW ISSUE - Different bug found

**Retest Notes:**

[Notes from retesting after fix]

**Related Tests to Run:**

[Other test cases that should be executed to ensure no side effects]

- TC-XXX
- TC-YYY

---

#### **Sign-Off**

**Reported By:**

**Name:** ________________________  
**Date:** ________________________  
**Signature:** ________________________  

**Assigned To Developer:**

**Name:** ________________________  
**Date:** ________________________  

**Fixed By Developer:**

**Name:** ________________________  
**Date:** ________________________  
**Status:** [ ] Complete

**Verified By QA:**

**Name:** ________________________  
**Date:** ________________________  
**Status:** [ ] PASS [ ] FAIL

**Approved for Closure:**

**Name:** ________________________  
**Date:** ________________________  
**Status:** [ ] CLOSED

---

---

## 📊 Defect Summary Report

**Reporting Period:** [Start Date] to [End Date]

### **Defect Statistics**

| Metric | Count | Percentage |
|--------|-------|-----------|
| Total Defects Found | [ ] | 100% |
| Critical (P0) | [ ] | [ ]% |
| High (P1) | [ ] | [ ]% |
| Medium (P2) | [ ] | [ ]% |
| Low (P3) | [ ] | [ ]% |
| Defects Fixed | [ ] | [ ]% |
| Defects Pending | [ ] | [ ]% |
| Defects Closed | [ ] | [ ]% |

### **Defects by Component**

| Component | Found | Fixed | Pending |
|-----------|-------|-------|---------|
| Authentication | [ ] | [ ] | [ ] |
| Onboarding | [ ] | [ ] | [ ] |
| Feedback System | [ ] | [ ] | [ ] |
| Dashboard | [ ] | [ ] | [ ] |
| Location/Maps | [ ] | [ ] | [ ] |
| Notifications | [ ] | [ ] | [ ] |
| Settings | [ ] | [ ] | [ ] |
| Safety/Emergency | [ ] | [ ] | [ ] |
| Firebase/Backend | [ ] | [ ] | [ ] |
| **TOTAL** | **[ ]** | **[ ]** | **[ ]** |

### **Defects by severity Over Time**

| Week | Critical | High | Medium | Low | Total |
|------|----------|------|--------|-----|-------|
| Week 1 | [ ] | [ ] | [ ] | [ ] | [ ] |
| Week 2 | [ ] | [ ] | [ ] | [ ] | [ ] |
| Week 3 | [ ] | [ ] | [ ] | [ ] | [ ] |
| **Total** | **[ ]** | **[ ]** | **[ ]** | **[ ]** | **[ ]** |

### **Average Resolution Time**

| Severity | Avg Days to Fix |
|----------|-----------------|
| Critical | [ ] days |
| High | [ ] days |
| Medium | [ ] days |
| Low | [ ] days |

### **Key Findings**

**Most Problematic Areas:**

1. [Component/Feature with most bugs]
2. [Component/Feature with second most bugs]
3. [Component/Feature with third most bugs]

**Common Issue Patterns:**

- [Pattern 1]
- [Pattern 2]
- [Pattern 3]

**Recommendations:**

1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

---

## 🔄 Defect Lifecycle

```
┌─────────────────────────────────────────────────────┐
│                    DEFECT LIFECYCLE                 │
└─────────────────────────────────────────────────────┘

1. NEW
   └─→ QA creates bug report during testing

2. ASSIGNED
   └─→ QA lead assigns to developer

3. IN PROGRESS
   └─→ Developer starts working on fix

4. FIXED
   └─→ Developer commits fix in new build

5. RETEST
   └─→ QA retests with fixed build

6. VERIFIED
   └─→ QA confirms fix is working

7. CLOSED
   └─→ Bug is resolved and closed

   [If not verified after retest]
   └─→ Back to IN PROGRESS (not fixed)
```

---

## 📬 Bug Report Checklist

**Before Submitting a Bug Report, Ensure:**

- [ ] You've read the test case completely
- [ ] You've followed all steps exactly
- [ ] You've reproduced the issue at least 2 times
- [ ] You've cleared app cache before reporting
- [ ] You've tried on different device if possible
- [ ] You've documented exact steps to reproduce
- [ ] You've taken screenshots of the issue
- [ ] You've noted your device and OS version
- [ ] You've included any error messages
- [ ] You've attached logs if applicable
- [ ] You've assigned appropriate severity level
- [ ] You've linked to related test case
- [ ] You've filled all required fields
- [ ] You've double-checked for typos
- [ ] You've saved the bug report file

---

## 📞 Who to Contact

**For Questions About:**

- **Test Case:** Contact QA Team
- **Bug Assignment:** Contact QA Lead
- **Development Fix:** Contact Development Team Lead
- **Release Date:** Contact Product Manager
- **Firebase Issues:** Contact Backend Team
- **Urgent Issues:** Contact QA Manager

---

**Document Version:** 1.0  
**Created:** March 12, 2026  
**Last Updated:** March 12, 2026

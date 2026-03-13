# Test Execution Quick Reference Guide

**SafeDriver Passenger App QA Testing**

---

## 🚀 Quick Start

### **Step 1: Preparation**
1. ✅ Install app on test device (Android/iOS)
2. ✅ Create test user accounts (phone number + email)
3. ✅ Set up Firebase test credentials
4. ✅ Enable WiFi and set stable network
5. ✅ Print/Open TEST_PLAN_MASTER.md

### **Step 2: Environment Setup**
1. ✅ Clear app cache and data first
2. ✅ Reset device location to test area
3. ✅ Enable all device permissions (location, camera, microphone, contacts)
4. ✅ Note device model and OS version
5. ✅ Verify Firebase connectivity

### **Step 3: Start Testing**
1. ✅ Open test case document (TC_001_Authentication.md)
2. ✅ Follow test steps sequentially
3. ✅ Record results in TEST_EXECUTION_REPORT_TEMPLATE.md
4. ✅ Note any issues found
5. ✅ Move to next test case

---

## 📋 Test Execution Order

**RECOMMENDED SEQUENCE** (Dependencies Matter):

### **Phase 1: Foundation (Must Pass)**
```
1. TC-001-001 → Phone OTP Registration (Creates user account)
   ↓
2. TC-001-008 → Login Valid Credentials (Verifies authentication)
   ↓
3. TC-002-001 → Language Selection (Completes onboarding)
```

### **Phase 2: Core Features**
```
4. TC-002-002 → Finish Onboarding
5. TC-002-003 → Profile Display
6. TC-004-001 → Dashboard Load
7. TC-006-001 → Push Notifications
```

### **Phase 3: Main Functionality**
```
8. TC-003-001 → Feedback System
9. TC-005-001 → Location Services
10. TC-007-001 → Safety Features
```

### **Phase 4: Edge Cases & Advanced**
```
11. TC-001-005 → OTP Resend
12. TC-001-006 → OTP Expiration
13. TC-001-011 → Session Timeout
14. [Continue with remaining TCs]
```

---

## 📝 Standard Test Case Format

**Read Each Test Case Like This:**

```
✅ TC-001-001: Phone OTP Registration

📖 Description:
   Verify that user can register using phone number with OTP

🔧 Preconditions:
   - App installed and running
   - Device has internet connection
   - Phone number not previously registered

📌 Test Steps:
   1. Tap "Register" button on login screen
   2. Select "Phone Number" option
   3. Enter valid phone number (e.g., +94701234567)
   4. Tap "Send OTP" button
   5. [Continue through all steps]

✅ Expected Result:
   User successfully created in Firebase Auth
   Account accessible for login

📊 Test Data:
   Phone: +94701234567
   Password: Test@123456

☑️ Result: [PASS / FAIL / BLOCKED]
```

---

## ✍️ How to Record Results

### **Option 1: In TEST_EXECUTION_REPORT_TEMPLATE.md**

```markdown
#### ✅ TC-001-001: Phone OTP Registration
- **Status:** [✅ Pass] [ ] Fail [ ] Blocked
- **Duration:** 2 minutes
- **Notes:** User received OTP in 15 seconds, registration completed successfully
- **Issues Found:** None
```

### **Option 2: In Original Test Case File**

At bottom of each test case, add:

```markdown
### Execution Results

**Tester:** John Doe  
**Date:** March 12, 2026  
**Status:** ✅ PASS

**Actual Result:**
User successfully registered, can login with phone OTP

**Execution Time:** 2 minutes

**Environment:** Samsung Galaxy S21, Android 12, WiFi

**Issues:** None
```

---

## 🐛 How to Report Issues

### **When a Test Fails:**

1. **Note the Failure Details:**
   - Which step failed?
   - What was expected?
   - What actually happened?
   - Can you reproduce it?

2. **Record in Report Template:**
   ```
   #### ✅ TC-001-001: Phone OTP Registration
   - **Status:** [✅ Pass] [❌ FAIL] [ ] Blocked
   - **Duration:** 3 minutes
   - **Notes:** OTP received but not displayed in UI
   - **Issues Found:** 
     - BUG-001: OTP text field not visible after receiving code
   ```

3. **Create Bug Report:**
   ```
   **BUG ID:** BUG-001
   **Title:** OTP text field hidden after OTP delivery
   **Test Case:** TC-001-001
   **Severity:** CRITICAL (blocks registration)
   **Steps to Reproduce:**
     1. Tap Register
     2. Select Phone Number
     3. Enter valid phone
     4. Tap Send OTP
     5. OTP is sent and received, but field is not visible
   **Expected:** OTP text input field should be displayed
   **Actual:** Field is missing from screen
   ```

---

## 📊 Test Status Indicators

| Symbol | Meaning | Action |
|--------|---------|--------|
| ✅ PASS | Test completed successfully | Move to next test |
| ❌ FAIL | Test did not meet expected result | Log bug, mark re-test needed |
| ⏸️ BLOCKED | Cannot execute test (missing dependency) | Note blocker, retry later |
| ⚠️ WARNING | Test passed but with warnings | Document warning, note for follow-up |
| ⏳ N/A | Not applicable this iteration | Skip, mark N/A |

---

## 🔄 Regression Testing Workflow

**When Developer Fixes a Bug:**

1. **Dev provides:** Build with fix applied
2. **QA retests:** Execute original failing test case
3. **Document result:** 
   - Add "Regression Test: [Date]" section to bug report
   - Mark PASS if issue is fixed
   - Mark FAIL if issue persists
4. **Check for side effects:** Run related test cases
   - If TC-001-001 was fixed, also run TC-001-002, TC-001-003
5. **Close or reopen:** 
   - If PASS: Mark bug as "Fixed & Verified"
   - If FAIL: Reopen bug with new details

---

## ⚠️ Common Issues & Solutions

### **Issue: OTP Not Arriving**
**Solution:**
- Check SMS gateway status (Text.lk)
- Try different phone number
- Check network connectivity
- Wait 30 seconds, may be delayed
- Reset app and retry

### **Issue: Location Permission Denied**
**Solution:**
- Go to Settings → Apps → SafeDriver → Permissions
- Enable "Location" permission
- Try test again
- May need to restart app

### **Issue: Firebase Connection Failed**
**Solution:**
- Verify internet connection (WiFi or mobile)
- Check in Firebase Console that project is active
- Verify API keys are correct in app
- Try closing and reopening app

### **Issue: App Crashing on Test**
**Solution:**
1. Check Android/iOS logs
2. Note exact steps that cause crash
3. Report with crash logs
4. Clear app cache
5. Reinstall app fresh

### **Issue: Test Randomly Fails**
**Solution:**
- Network issue: Try on stable WiFi
- Timing issue: Wait longer between steps
- Data issue: Check if test data exists in Firebase
- Device issue: Restart device
- Mark as "Intermittent" if random

---

## 📱 Test Device Setup Checklist

**Before Starting Tests:**

### **Android Device**
- [ ] Latest Android OS installed
- [ ] Location services enabled
- [ ] Camera permission enabled
- [ ] Microphone permission enabled
- [ ] Contacts permission enabled
- [ ] Storage permission enabled
- [ ] Bluetooth enabled (if testing Bluetooth)
- [ ] WiFi connected to stable network
- [ ] Airplane mode OFF
- [ ] Flight mode OFF
- [ ] Date/time set correctly

### **iOS Device**
- [ ] Latest iOS installed
- [ ] Location services enabled
- [ ] Camera permission enabled
- [ ] Microphone permission enabled
- [ ] Contacts permission enabled
- [ ] Calendar permission enabled
- [ ] WiFi connected
- [ ] iCloud signed in
- [ ] Developer mode enabled (if needed)
- [ ] Date/time set correctly

---

## 🎯 Daily Testing Schedule

### **Optimal Schedule for 83 Test Cases**

**Day 1: Authentication & Onboarding (Takes ~3 hours)**
- TC_001 (15 tests) → 2 hours
- TC_002 (10 tests) → 1 hour

**Day 2: Feedback & Dashboard (Takes ~2.5 hours)**
- TC_003 (12 tests) → 1.5 hours
- TC_004 (12 tests) → 1 hour

**Day 3: Location & Notifications (Takes ~2.5 hours)**
- TC_005 (11 tests) → 1.5 hours
- TC_006 (13 tests) → 1 hour

**Day 4: Safety & Regression (Takes ~2 hours)**
- TC_007 (10 tests) → 1.5 hours
- Regression testing for any failures → 0.5 hours

**Day 5: Final Verification & Reporting**
- Retry blocked tests
- Run smoke tests on critical paths
- Generate final report
- Prepare summary for stakeholders

### **Total Time Estimate: 5 days** (assuming 8 hours/day)

---

## 📞 Support & Escalation

**If You Get Stuck:**

1. **For Technical Issues:**
   - Check TEST_PLAN_MASTER.md for prerequisites
   - Review preconditions in test case
   - Check device setup checklist
   - Verify network connectivity

2. **For App Crashes:**
   - Collect crash logs
   - Note exact steps
   - Try on different device
   - Contact development team

3. **For Firebase Issues:**
   - Verify Firebase project is accessible
   - Check Google Cloud Console
   - Verify API keys
   - Contact backend team

4. **For Unclear Test Steps:**
   - Refer to TEST_PLAN_MASTER.md for glossary
   - Check related test cases for context
   - Contact QA lead

---

## 📊 Tracking Your Progress

### **How to Stay On Track**

**Create a Progress File:**

```markdown
# Weekly Testing Progress

**Week of March 12, 2026**

**Monday (Mar 12):**
- ✅ TC_001: Completed 15/15 tests
  - Passed: 14
  - Failed: 1 (BUG-001: OTP display issue)
- Status: ON TRACK

**Tuesday (Mar 13):**
- ✅ TC_002: Completed 10/10 tests
  - Passed: 10
  - Failed: 0
- Status: ON TRACK

**Current Metrics:**
- Total Executed: 25/83 (30%)
- Total Passed: 24
- Total Failed: 1
- Pass Rate: 96%
- Defects Found: 1
```

---

## 🎓 Tips for Effective Testing

### **Do's** ✅
- ✅ Follow test steps exactly as written
- ✅ Read preconditions carefully
- ✅ Take screenshots of failures
- ✅ Document observations
- ✅ Report issues with reproduction steps
- ✅ Test on multiple devices if possible
- ✅ Clear app cache between test modules

### **Don'ts** ❌
- ❌ Skip preconditions
- ❌ Improvise test steps
- ❌ Assume results without checking
- ❌ Skip failed tests
- ❌ Leave incomplete test records
- ❌ Report without reproduction steps
- ❌ Change test steps without documenting

---

## 🔗 Related Documents

- **TEST_PLAN_MASTER.md** - Master test coordination
- **TC_001_Authentication.md** - Auth test cases
- **TC_002_Onboarding_Profile.md** - Onboarding tests
- **TC_003_Feedback_System.md** - Feedback tests
- **TC_004_Dashboard_Navigation.md** - Dashboard tests
- **TC_005_Location_Maps.md** - Location tests
- **TC_006_Notifications_Settings.md** - Notification tests
- **TC_007_Safety_Emergency.md** - Safety tests
- **TEST_EXECUTION_REPORT_TEMPLATE.md** - Execution report

---

**Created:** March 12, 2026  
**Version:** 1.0  
**For:** SafeDriver Passenger App QA Team

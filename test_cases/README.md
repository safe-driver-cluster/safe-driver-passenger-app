# SafeDriver Passenger App - Test Cases Directory

## 📦 Complete QA Testing Package

Welcome! You now have everything needed to thoroughly test the SafeDriver Passenger App.

---

## 🎯 Quick Navigation

### **👉 START HERE**
1. **New to testing this app?** → Read `TEST_EXECUTION_QUICK_REFERENCE.md` (15 min)
2. **Need big picture view?** → Read `TEST_SUITE_DOCUMENTATION_INDEX.md` (10 min)
3. **Ready to begin testing?** → Open `TC_001_Authentication.md`

---

## 📂 What's Inside

```
test_cases/ (This Directory)
│
├─ 📖 DOCUMENTATION & GUIDES
│  ├─ README.md                              ← You are here
│  ├─ TEST_SUITE_DOCUMENTATION_INDEX.md      ← Complete overview of all materials
│  ├─ TEST_PLAN_MASTER.md                    ← Master test coordination
│  ├─ TEST_EXECUTION_QUICK_REFERENCE.md      ← Fast reference for testers
│  ├─ TEST_EXECUTION_REPORT_TEMPLATE.md      ← Record test results here
│  └─ DEFECT_TRACKING_TEMPLATE.md            ← Report bugs here
│
└─ ✅ TEST CASE MODULES (83 Total Tests)
   ├─ TC_001_Authentication.md               ← 15 Auth test cases
   ├─ TC_002_Onboarding_Profile.md           ← 10 Onboarding test cases
   ├─ TC_003_Feedback_System.md              ← 12 Feedback test cases
   ├─ TC_004_Dashboard_Navigation.md         ← 12 Dashboard test cases
   ├─ TC_005_Location_Maps.md                ← 11 Location test cases
   ├─ TC_006_Notifications_Settings.md       ← 13 Notification test cases
   └─ TC_007_Safety_Emergency.md             ← 10 Safety test cases
```

---

## 🚀 Quick Start Guide

### **For QA Testers (New to this app)**

**Time: 1 hour to get started**

```
Step 1: Read README (This file) ........................... 5 min
Step 2: Read TEST_EXECUTION_QUICK_REFERENCE.md ........... 15 min
Step 3: Prepare test device (checklist provided) ......... 30 min
Step 4: Start with TC_001_Authentication.md ............. 10 min
```

### **For QA Leads**

**Time: 2 hours to understand full scope**

```
Step 1: Read TEST_PLAN_MASTER.md ......................... 30 min
Step 2: Read TEST_SUITE_DOCUMENTATION_INDEX.md .......... 20 min
Step 3: Review all 7 test case modules (skim) ........... 30 min
Step 4: Setup execution schedule ......................... 30 min
Step 5: Assign testers to test modules .................. 10 min
```

### **For Project Managers**

**Time: 30 minutes**

```
Step 1: Read TEST_SUITE_DOCUMENTATION_INDEX.md (Executive Summary)
Step 2: Review Expected Outcomes section
Step 3: Check Estimated Execution Time (40-50 hours)
```

---

## 📊 Key Statistics

| Metric | Value |
|--------|-------|
| **Total Test Cases** | 83 |
| **Test Modules** | 7 |
| **Documentation Files** | 11 |
| **Estimated Execution Time** | 40-50 hours (5 days) |
| **Test Format** | Industry-standard (10-12 steps each) |
| **Coverage** | All major app features |

---

## 🎯 What Each Document Does

| Document | Purpose | Read First? | Time |
|----------|---------|------------|------|
| **README.md** | This file - Getting started | ✅ YES | 5 min |
| **TEST_SUITE_DOCUMENTATION_INDEX.md** | Complete overview | ✅ YES (after this) | 10 min |
| **TEST_EXECUTION_QUICK_REFERENCE.md** | Quick tips for testers | ✅ YES (before testing) | 15 min |
| **TEST_PLAN_MASTER.md** | Master test planning | ✅ For QA Lead | 30 min |
| **TEST_EXECUTION_REPORT_TEMPLATE.md** | Record test results | ⏪ Use DURING testing | Ongoing |
| **DEFECT_TRACKING_TEMPLATE.md** | Report bugs found | ⏪ Use when bugs found | Ongoing |
| **TC_001 through TC_007** | 83 actual test cases | ✅ YES (execute these) | 40-50 hours |

---

## 📝 Understanding a Test Case

Each test case follows this simple format:

```markdown
✅ TC-001-001: Phone OTP Registration

📖 Description:
   Verify that user can register using phone number with OTP

🔧 Preconditions:
   - App installed and running
   - Device has internet connection

📌 Test Steps:
   1. Tap "Register" button on login screen
   2. Select "Phone Number" option
   3. Enter valid phone number (e.g., +94701234567)
   4. Tap "Send OTP" button
   5. [Continue through all steps...]

✅ Expected Result:
   User successfully created in Firebase Auth
   Account accessible for login

☑️ Result: [✅ PASS or ❌ FAIL or ⏸️ BLOCKED]
```

**That's it!** Each test is written to be easy to follow with clear steps.

---

## 💡 Testing Tips

### **Before You Start**
- ✅ Clear app cache and data
- ✅ Enable device location
- ✅ Enable all permissions
- ✅ Verify internet connection
- ✅ Have test accounts ready

### **While Testing**
- ✅ Follow steps exactly as written
- ✅ Don't skip steps
- ✅ Take screenshots if something goes wrong
- ✅ Note exact error messages
- ✅ Record results immediately after each test

### **If a Test Fails**
- ✅ Reproduce the issue 2-3 times to confirm
- ✅ Take screenshots
- ✅ Note exact steps that cause the failure
- ✅ Report using DEFECT_TRACKING_TEMPLATE.md
- ✅ Mark test as BLOCKED if other tests depend on it

---

## 🔍 Module Guide - What to Test

### **Module 1: Authentication (15 tests)**
**File:** `TC_001_Authentication.md`
- Phone OTP registration
- Email registration
- Login/Logout
- Password reset
- Biometric login (Fingerprint/Face ID)
- Google Sign-In
- Two-Factor Authentication

### **Module 2: Onboarding & Profile (10 tests)**
**File:** `TC_002_Onboarding_Profile.md`
- Language selection
- First-time user onboarding
- User profile management
- Profile picture upload
- Emergency contacts
- Privacy settings

### **Module 3: Feedback System (12 tests)**
**File:** `TC_003_Feedback_System.md`
- Submit feedback for buses
- QR code scanning
- Star ratings
- Photo/video uploads
- View feedback history
- Feedback analytics

### **Module 4: Dashboard & Navigation (12 tests)**
**File:** `TC_004_Dashboard_Navigation.md`
- Dashboard load time
- Navigation menu
- Quick action buttons
- Status updates
- Responsive design
- Page transitions

### **Module 5: Location & Maps (11 tests)**
**File:** `TC_005_Location_Maps.md`
- Location permissions
- GPS accuracy
- Map display
- Bus live tracking
- Route planning
- Offline maps

### **Module 6: Notifications & Settings (13 tests)**
**File:** `TC_006_Notifications_Settings.md`
- Push notifications
- In-app alerts
- Notification sounds
- Settings management
- Theme switching
- Language change

### **Module 7: Safety & Emergency (10 tests)**
**File:** `TC_007_Safety_Emergency.md`
- Emergency SOS button
- Emergency contacts alert
- Safety tips
- Hazard reporting
- Data encryption
- Crash recovery

---

## 📋 Recommended Test Execution Order

**Follow this sequence** (tests build on each other):

```
Day 1: Authentication Foundation (3 hours)
  1. TC-001-001: Phone OTP Registration
  2. TC-001-008: Login Valid Credentials
  3. [Complete all 15 TC-001 tests]
  
Day 2: Setup Complete (1.5 hours)
  4. TC-002-001: Language Selection
  5. [Complete all 10 TC-002 tests]

Day 2: Main Features (2 hours)
  6. [Complete all 12 TC-003 tests] - Feedback
  7. [Complete all 12 TC-004 tests] - Dashboard

Day 3: Advanced Features (2 hours)
  8. [Complete all 11 TC-005 tests] - Location
  9. [Complete all 13 TC-006 tests] - Notifications

Day 4: Safety & Regression (2 hours)
  10. [Complete all 10 TC-007 tests] - Safety
  11. Retry any failed tests

Day 5: Reporting (2 hours)
  12. Compile final report
  13. Summarize findings
```

---

## 🐛 What to Do If You Find Issues

### **Step 1: Confirm the Issue**
- Reproduce the problem 2-3 times
- Take screenshots/videos
- Note exact steps that cause it

### **Step 2: Document in Test Report**
- Mark test as **FAIL** in TEST_EXECUTION_REPORT_TEMPLATE.md
- Note what went wrong

### **Step 3: Create Bug Report**
- Use DEFECT_TRACKING_TEMPLATE.md
- Give it a unique BUG-### ID
- Describe the problem clearly
- Include reproduction steps
- Attach screenshots

### **Step 4: Assign to Developer**
- Developers will be notified of bugs
- They'll fix the issue
- You'll retest after fix

### **Example:**
```
BUG-001: OTP text field not visible after receiving code
Severity: CRITICAL (prevents registration)
Steps to reproduce:
  1. Tap Register
  2. Select Phone Number
  3. Enter phone: +94701234567
  4. Tap Send OTP
  5. Result: OTP received but input field not shown
```

---

## ✅ Pre-Testing Checklist

**Complete this BEFORE starting tests:**

**Device Setup:**
- [ ] App installed successfully
- [ ] App runs without crashing
- [ ] Device location enabled
- [ ] WiFi connected and stable
- [ ] All permissions granted (see checklist in TEST_EXECUTION_QUICK_REFERENCE.md)

**Test Accounts:**
- [ ] Test phone number available
- [ ] Test email account ready
- [ ] Firebase test project configured
- [ ] SMS gateway (Text.lk) working

**Documentation:**
- [ ] TEST_EXECUTION_REPORT_TEMPLATE.md printed/open
- [ ] DEFECT_TRACKING_TEMPLATE.md accessible
- [ ] TEST_EXECUTION_QUICK_REFERENCE.md bookmarked
- [ ] Device setup checklist reviewed

**Environment:**
- [ ] Quiet workspace for focus
- [ ] Note-taking materials ready
- [ ] Screenshot tools available
- [ ] Time blocked out for testing

---

## 📞 Getting Help

### **Common Questions**

**Q: Where do I record test results?**  
A: In `TEST_EXECUTION_REPORT_TEMPLATE.md`

**Q: How do I report a bug?**  
A: Use `DEFECT_TRACKING_TEMPLATE.md`

**Q: Which test should I start with?**  
A: Start with `TC_001_Authentication.md` (foundation tests)

**Q: What if a test is blocked?**  
A: Mark it as BLOCKED and move to next test. Retry later after dependencies fixed.

**Q: How long should each test take?**  
A: 2-5 minutes per test on average. See time estimates in each test case.

**Q: What does "Preconditions" mean?**  
A: It's what must be true before you start. Usually: app installed, logged in, correct screen.

---

## 📈 Success Criteria

**Your testing is successful when:**
- ✅ All 83 test cases executed
- ✅ Pass rate ≥ 95% (80 or more tests pass)
- ✅ All critical bugs identified and reported
- ✅ Final report completed
- ✅ Team approves results

---

## 🎓 Key Concepts

**Test Case:** A specific scenario to verify the app works correctly

**Preconditions:** Setup required before test starts

**Test Steps:** Actions you take (numbered 1-12)

**Expected Result:** What SHOULD happen if test passes

**Pass/Fail/Blocked:** Test outcome
- ✅ PASS = works correctly
- ❌ FAIL = doesn't work (bug found)
- ⏸️ BLOCKED = can't run (waiting for other test)

**Bug/Defect:** Something that doesn't work as expected

**Regression Testing:** Re-running tests after bugs are fixed

---

## 🚀 Getting Started Right Now

### **The Next 5 Minutes:**

1. **Read this README:** 5 minutes ✓
2. **Then read:** TEST_EXECUTION_QUICK_REFERENCE.md (15 min)
3. **Then prepare:** Your test device (30 min)
4. **Then begin:** TC_001_Authentication.md

### **That's It!** You're ready to start testing.

---

## 📝 Important Files Quick Reference

| Need | File | Time |
|------|------|------|
| Big picture understanding | TEST_SUITE_DOCUMENTATION_INDEX.md | 10 min |
| Preparation checklist | TEST_EXECUTION_QUICK_REFERENCE.md | 15 min |
| Device setup | TEST_EXECUTION_QUICK_REFERENCE.md → Checklist | 30 min |
| Test execution | TC_001 through TC_007 | 40-50 hours |
| Recording results | TEST_EXECUTION_REPORT_TEMPLATE.md | Ongoing |
| Reporting bugs | DEFECT_TRACKING_TEMPLATE.md | As needed |
| Final report | TEST_EXECUTION_REPORT_TEMPLATE.md | 2 hours |

---

## ✨ What You Now Have

✅ **83 Professional Test Cases** - Ready to execute  
✅ **7 Organized Modules** - Logical grouping by feature  
✅ **Complete Templates** - For results and bug reporting  
✅ **Quick Reference Guide** - For testers  
✅ **Master Test Plan** - Strategic overview  
✅ **Everything Needed** - To thoroughly test the app  

---

## 🎯 Your Path Forward

```
1. Spend 30 min reading this directory
   ↓
2. Spend 1 hour preparing test environment
   ↓
3. Spend 40-50 hours executing tests
   ↓
4. Spend 2 hours documenting results
   ↓
5. Present findings to team
```

---

## 🎓 Final Words

This is a **complete, professional test suite** created in industry-standard format. Each test case has been carefully written with:

- Clear objectives
- Detailed steps
- Expected results
- Ready-to-use templates

**You have everything you need. Let's test!** 🚀

---

**Status:** ✅ **READY FOR EXECUTION**

**Start here:** `TEST_EXECUTION_QUICK_REFERENCE.md`  
**Then execute:** `TC_001_Authentication.md`  
**Record results:** `TEST_EXECUTION_REPORT_TEMPLATE.md`

---

**Version:** 1.0  
**Created:** March 12, 2026  
**For:** SafeDriver Passenger App QA Team

*Questions? Check TEST_EXECUTION_QUICK_REFERENCE.md or contact QA Lead*

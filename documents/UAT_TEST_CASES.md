# SafeDriver Passenger App - UAT Test Cases

## 📋 Introduction

The SafeDriver Passenger App is a Flutter-based mobile application designed for passengers to access bus information, provide feedback, track their trips, and access emergency features. This UAT test suite validates the core user journeys and critical functionalities including authentication, QR code scanning, feedback submission, trip history access, and emergency alert system. The tests are based on the actual app implementation and ensure all core features work as designed.

**Scope:** End-to-end user workflows covering authentication, QR code scanning, feedback submission, trip history, bus search, emergency features, and profile management.

**Test Environment:** Android device/emulator (API 21+) with internet connectivity, Firebase backend configured, device permissions enabled.

---

## 🧪 UAT Test Cases

### Test Case 1: User Registration & Authentication

**Test Case ID:** UAT-TC-001

**Test Title:** Verify User Account Creation and Login Flow

**Pre-conditions:**
- Mobile app is installed and launched
- User has a valid email address or phone number
- Internet connectivity is available
- Firebase Authentication service is active

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Open SafeDriver app | Splash screen loads and redirects to login/signup page |
| 2 | Tap on "Create New Account" or "Sign Up" button | Sign-up form is displayed with email/phone and password fields |
| 3 | Enter valid email address and strong password | Input is accepted without validation errors |
| 4 | Tap "Sign Up" / "Register" button | User account is created successfully |
| 5 | Verify email/phone if prompted | Verification code is received and user can verify |
| 6 | Complete profile setup (name, profile picture optional) | Profile is saved successfully |
| 7 | Log out from the application | User is redirected to login page |
| 8 | Enter registered email and password | Credentials are verified |
| 9 | Tap "Login" button | User is logged in and dashboard is displayed |

**Expected Result:** User successfully creates account, verifies credentials, and logs into the application. Dashboard displays personalized welcome message and main features.

**Acceptance Criteria:**
- ✅ Account creation completes without errors
- ✅ OTP/Verification email is received
- ✅ Login with correct credentials works
- ✅ Session persists after app restart
- ✅ User data is securely stored

---

### Test Case 2: Scan Bus QR Code & View Real-time Driver Monitoring

**Test Case ID:** UAT-TC-002

**Test Title:** Verify QR Code Scanning and Real-time Driver Monitoring Dashboard

**Pre-conditions:**
- User is logged into the application
- Device camera permission is granted
- GPS is enabled
- Internet connectivity is active
- Bus/Vehicle has active QR code displayed
- Driver monitoring system is transmitting real-time data

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | From dashboard, tap "Scan QR Code" or camera icon | Camera view opens with QR code scanner overlay |
| 2 | Point camera at bus QR code | QR code is detected and highlighted |
| 3 | Hold steady for 2-3 seconds | QR code is successfully scanned |
| 4 | Allow automatic redirect or tap confirmation | Bus details page loads with driver information |
| 5 | Observe driver monitoring dashboard | Real-time metrics display: alertness level, speed, safety score |
| 6 | Monitor live updates every 5 seconds | Dashboard updates in real-time without manual refresh |
| 7 | Check driver status indicator (Green/Yellow/Red) | Status reflects current driver alertness and safety state |
| 8 | Scroll down to view additional metrics | Historical data, trip duration, and risk assessments are visible |

**Expected Result:** QR code scans successfully, bus information loads instantly, and real-time driver monitoring dashboard displays live updates of driver alertness, speed, and safety metrics.

**Acceptance Criteria:**
- ✅ QR code scanning is accurate and fast (<2 seconds)
- ✅ Driver information loads within 3 seconds
- ✅ Real-time data updates every 5 seconds
- ✅ Safety status indicators are color-coded and intuitive
- ✅ No data lag or disconnection during 5-minute observation period

---

### Test Case 3: View Driver & Bus History and Safety Analytics

**Test Case ID:** UAT-TC-003

**Test Title:** Verify Access to Historical Driver/Bus Data and Safety Analytics

**Pre-conditions:**
- User is logged in to the application
- User has completed at least one previous bus trip
- Historical trip data is available in Firebase Firestore
- Internet connectivity is active
- Driver and bus have historical safety records

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | From dashboard, tap "History" or "Driver & Bus Records" section | History page loads displaying list of previous trips |
| 2 | Observe trip list with dates, bus numbers, and driver names | Trip history is displayed in chronological order (newest first) |
| 3 | Tap on a specific trip from the history list | Trip details page opens showing comprehensive trip information |
| 4 | View trip details: duration, distance, date, time, driver rating | All trip information is clearly displayed and readable |
| 5 | Scroll down to view safety metrics for that trip | Safety score, incident reports, and performance metrics are shown |
| 6 | Observe driver average rating and historical performance | Driver's cumulative rating and safety record are visible |
| 7 | Check bus maintenance history and safety inspection status | Bus condition reports and inspection dates are displayed |
| 8 | View safety incidents or alerts recorded during the trip (if any) | Incidents are timestamped and detailed with descriptions |

**Expected Result:** User can successfully access historical data for past trips, view detailed driver and bus performance records, and review safety analytics for informed decision-making on future trips.

**Acceptance Criteria:**
- ✅ History list loads within 3 seconds
- ✅ Trip details display completely with all relevant data
- ✅ Safety metrics are accurate and match backend records
- ✅ Driver ratings are calculated correctly (average of all feedback)
- ✅ Historical data persists and is retrievable after app restart
- ✅ No data corruption or missing information
- ✅ Trip records are searchable/filterable by date or driver

---

### Test Case 4: Submit Passenger Feedback and Safety Report

**Test Case ID:** UAT-TC-004

**Test Title:** Verify Feedback Submission and Safety Issue Reporting

**Pre-conditions:**
- User is logged in
- User is currently on or has recently completed a bus trip
- Driver feedback form/reporting interface is accessible
- Internet connectivity is available
- User has camera/gallery access for optional photo attachment

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "Submit Feedback" or "Report Issue" button | Feedback form modal/page opens |
| 2 | Select feedback category (Safety, Comfort, Driver Performance, etc.) | Category dropdown expands and options are displayed |
| 3 | Choose a specific issue (e.g., "Rash Driving", "Vehicle Condition", "Courteous Service") | Issue is selected and highlighted |
| 4 | Rate experience on 1-5 star scale | Stars are selectable and visual feedback is shown |
| 5 | Write detailed feedback in text field (min 10 characters) | Text input accepts user feedback |
| 6 | Optionally attach photo by tapping camera icon | Image picker opens; photo can be selected or new photo taken |
| 7 | Select photo and confirm attachment | Photo preview is shown; file size is validated |
| 8 | Tap "Submit Feedback" button | Confirmation toast/message appears: "Feedback submitted successfully" |
| 9 | Verify in user profile under "My Feedback" section | Submitted feedback is listed with timestamp |

**Expected Result:** Passenger can successfully submit categorized feedback with ratings, descriptions, and optional photo attachments. Feedback is stored and retrievable in user's feedback history.

**Acceptance Criteria:**
- ✅ Feedback form submits without errors
- ✅ All required fields are validated before submission
- ✅ Photo attachment works (JPG, PNG up to 5MB)
- ✅ Submission confirmation is displayed
- ✅ Feedback appears in history within 30 seconds
- ✅ Data persists after app restart

---

### Test Case 5: Emergency Alert Activation and Response

**Test Case ID:** UAT-TC-005

**Test Title:** Verify Emergency Alert Trigger and Notification System

**Pre-conditions:**
- User is logged in and actively on a bus trip
- Network connectivity is available
- Push notifications are enabled in app settings
- Emergency service backend is configured
- Device has sufficient battery and connectivity

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Identify emergency/SOS button on dashboard (usually red button) | SOS button is prominent and easily accessible |
| 2 | Tap and hold SOS button for 2-3 seconds | Visual confirmation (animation/color change) appears |
| 3 | After hold period, tap "Confirm Emergency" if confirmation prompt appears | Alert activation is confirmed |
| 4 | Observe loading indicator during transmission | Data is being transmitted to backend |
| 5 | Verify success notification appears | "Emergency alert sent successfully" message displays |
| 6 | Check that emergency details are transmitted (location, timestamp, user ID) | Backend receives: GPS location, exact time, passenger details |
| 7 | Monitor receiving end (admin/emergency service dashboard) | Alert appears on emergency response dashboard in real-time |
| 8 | Verify notification badges on app (if emergency response system sends back confirmation) | Push notification or in-app notification confirms emergency team dispatch |
| 9 | Check that emergency can be cancelled within 30 seconds if accidental | Cancel button is available; alert is revoked if tapped in time |

**Expected Result:** Emergency alert system activates reliably, transmits location and user data to emergency services in real-time, and provides confirmation to passenger. Emergency response team receives alert and can respond.

**Acceptance Criteria:**
- ✅ Emergency button is easily accessible and responsive
- ✅ Alert transmits location within 3 seconds
- ✅ Emergency services receive alert within 5 seconds of activation
- ✅ Confirmation message is displayed to user
- ✅ Alert can be cancelled within 30-second window
- ✅ No false positives from accidental touches (requires 2-3 second hold)
- ✅ Works reliably in poor network conditions (4G/3G)

---

## 📊 Test Execution Summary Template

| Test Case ID | Title | Status | Date Executed | Pass/Fail | Issues Found | Notes |
|---|---|---|---|---|---|---|
| UAT-TC-001 | User Authentication | ⏳ Pending | - | - | - | - |
| UAT-TC-002 | QR Code & Real-time Monitoring | ⏳ Pending | - | - | - | - |
| UAT-TC-003 | Live Bus Tracking | ⏳ Pending | - | - | - | - |
| UAT-TC-004 | Feedback Submission | ⏳ Pending | - | - | - | - |
| UAT-TC-005 | Emergency Alert | ⏳ Pending | - | - | - | - |

---

## 🎯 Success Criteria for UAT Sign-off

- ✅ All 5 test cases executed successfully
- ✅ Zero critical defects found
- ✅ Maximum 2 minor defects (cosmetic/UX improvements)
- ✅ All acceptance criteria met for each test case
- ✅ Performance metrics within acceptable range
- ✅ No data loss or corruption observed
- ✅ User feedback is positive on usability and functionality

---

## 📝 Notes for Test Execution

1. **Test Data:** Ensure test buses, drivers, and routes are configured in staging Firebase environment
2. **Device Requirements:** Test on both Android versions (API 21+) and real devices when possible
3. **Network Conditions:** Test with varying network speeds (4G, 3G, WiFi) to simulate real-world scenarios
4. **Data Privacy:** Ensure personal data is handled securely and complies with local regulations
5. **Performance Baseline:** Measure response times and set performance thresholds before UAT
6. **Rollback Plan:** Have a plan to revert changes if critical issues are found during UAT

---

**Document Version:** 1.0  
**Last Updated:** 2026-06-13  
**Prepared For:** SafeDriver Passenger App UAT Phase

# SafeDriver Passenger App - UAT Test Cases (Based on Actual Implementation)

## 📋 Introduction

The SafeDriver Passenger App is a Flutter-based mobile application designed for passengers to access bus information, provide feedback about their travel experience, track their trip history, and access emergency features. This UAT test suite validates the core user journeys and actual functionalities implemented in the application including authentication, QR code scanning, feedback submission, trip history access, emergency alerts, and profile management. All test cases are based on features verified in the actual codebase implementation.

**Scope:** End-to-end user workflows covering authentication, QR code scanning, feedback submission, trip history, bus list access, emergency features, profile management, and reward points system.

**Test Environment:** Android device/emulator (API 21+) with internet connectivity, Firebase backend configured, device permissions enabled (camera, location, notifications).

---

## 🧪 UAT Test Cases

### Test Case 1: User Registration & Phone Authentication

**Test Case ID:** UAT-TC-001

**Test Title:** Verify User Account Creation and Phone-based Login Flow

**Pre-conditions:**
- Mobile app is installed and launched
- User has a valid phone number (Sri Lanka: +94 format)
- Internet connectivity is available
- Firebase Authentication service is active
- SMS gateway service is operational

**Test Path:** Splash Screen → Language Selection → Login/Register Page → Phone Number Entry → OTP Verification → Profile Completion → Dashboard

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Launch SafeDriver app | Splash screen displays, then redirects to login page |
| 2 | Tap "Create New Account" or "Register" button | Registration form displays with phone number and password fields |
| 3 | Select country code (+94 for Sri Lanka) | Country code dropdown appears and selection is saved |
| 4 | Enter valid phone number (10 digits) | Phone number is validated and accepted |
| 5 | Enter strong password (min 8 characters) | Password field accepts input with strength indicator |
| 6 | Tap "Register" button | OTP is sent to entered phone number; verification page loads |
| 7 | Enter received OTP in verification field | OTP is validated against backend |
| 8 | Complete profile setup (first name, last name) | Profile information is saved to Firestore |
| 9 | User is logged in and dashboard displays | Personalized welcome and main features visible |
| 10 | Log out from profile menu | User is redirected to login page; session ends |
| 11 | Enter registered phone and password on login | Credentials verified against Firebase Auth |
| 12 | Tap "Login" button | User is logged in; session persists using Firebase persistence |

**Expected Result:** User successfully creates account with phone authentication, verifies via OTP, completes profile, logs in, and can log out cleanly. Session persists after app restart if "Remember Me" is enabled.

**Acceptance Criteria:**
- ✅ Phone number validation works correctly
- ✅ OTP sent and received without errors
- ✅ OTP verification completes within 30 seconds
- ✅ Account creation stores data in Firebase Firestore
- ✅ Login with correct credentials succeeds
- ✅ Session persists after app close (if enabled)
- ✅ User can log out properly
- ✅ Error messages are clear and actionable
- ✅ Biometric authentication option appears if device supports it

---

### Test Case 2: QR Code Scanning for Bus/Feedback Access

**Test Case ID:** UAT-TC-002

**Test Title:** Verify QR Code Scanner Functionality and Bus Information Display

**Pre-conditions:**
- User is logged into the application
- Device camera permission is granted
- Internet connectivity is active
- Valid QR code (bus or feedback) is available to scan
- Mobile Scanner library is properly initialized

**Test Path:** Dashboard → QR Scanner Feature → Camera Permission → QR Code Detection → Bus/Feedback Data Load → Navigation to Relevant Page

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | From dashboard, locate and tap "QR Code Scanner" feature card | QR Scanner page loads showing camera preview |
| 2 | Allow camera permission if system prompt appears | Camera access is granted; live preview displays |
| 3 | Point device camera at a valid bus/feedback QR code | QR code area is highlighted by scanner; visual feedback shown |
| 4 | Hold camera steady for 1-2 seconds | Scanner automatically recognizes and captures QR code data |
| 5 | App processes QR code data | No manual action needed; automatic processing |
| 6 | User is navigated to corresponding page (bus details/feedback) | Correct page loads with associated data |
| 7 | Verify data is retrieved and displayed | Bus information or feedback context properly populated from Firestore |
| 8 | Option to manually enter QR code (if available) | Text input field allows manual entry as fallback method |
| 9 | Navigate back to dashboard or scanner | Previous scanner state is maintained; ready for new scan |

**Expected Result:** QR code scanning works reliably, detects valid codes within 2-3 seconds, processes data accurately, retrieves information from Firebase, and navigates user to appropriate page.

**Acceptance Criteria:**
- ✅ Camera initializes within 1 second
- ✅ QR code detection is accurate (100% detection rate on valid codes)
- ✅ Scanning completes within 3 seconds for valid codes
- ✅ Data loads correctly from Firestore within 2 seconds
- ✅ Manual entry works as fallback option
- ✅ Camera permission requests handled properly
- ✅ Scanner handles consecutive scans without freezing or crashing
- ✅ Torch/flashlight toggle works (if supported)
- ✅ Error messages display for invalid or unrecognized codes

---

### Test Case 3: Submit Passenger Feedback with Categories and Ratings

**Test Case ID:** UAT-TC-003

**Test Title:** Verify Feedback Submission with Categories, Ratings, and Attachment Support

**Pre-conditions:**
- User is logged in
- User has completed at least one trip or is viewing bus information
- Feedback form/interface is accessible
- Internet connectivity is available
- Camera/gallery permissions granted (for photo attachment)

**Test Path:** Bus Details/Trip History → Submit Feedback → Select Category → Rate Experience → Add Comments → Optional Photo → Submit → Confirmation

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | From bus details or dashboard, locate and tap "Submit Feedback" button | Feedback form modal/page opens with title and subtitle |
| 2 | Observe feedback form layout with all input fields | Form displays: category selector, rating stars, text field, attachment option |
| 3 | Tap category dropdown (Safety, Comfort, Driver Performance, etc.) | Dropdown expands showing 6+ predefined feedback categories |
| 4 | Select a specific category | Category selection is highlighted; confirms selection |
| 5 | Rate the experience by tapping star rating (1-5 stars) | Stars are selectable; visual feedback shows selected rating |
| 6 | Enter feedback text in text area (minimum 10 characters) | Text input accepts user feedback without character limit issues |
| 7 | Tap camera icon to attach optional photo | Image picker opens; user can select from gallery or take new photo |
| 8 | Select and confirm photo attachment | Photo preview displays; file size validated (max 5MB) |
| 9 | Tap "Submit Feedback" button | Loading indicator appears; form validates all required fields |
| 10 | Verify success confirmation message | Toast/dialog displays: "Feedback submitted successfully" or similar |
| 11 | Access user profile → "My Feedback" section | Submitted feedback appears in history with timestamp and category |
| 12 | Verify feedback persistence | Feedback remains visible after app restart |

**Expected Result:** Passenger successfully submits categorized feedback with star ratings, text descriptions, and optional photo attachments. Feedback is stored in Firestore, retrievable in user history, and reward points are credited.

**Acceptance Criteria:**
- ✅ Feedback form submits without errors
- ✅ All required fields are validated before submission
- ✅ Category dropdown works with 6+ options
- ✅ Star rating is interactive and saves selection
- ✅ Photo attachment works (JPG, PNG up to 5MB)
- ✅ Submission confirmation displays immediately
- ✅ Feedback appears in history within 30 seconds
- ✅ Reward points (+1 for submission, +2 if approved) are added
- ✅ Data persists after app restart
- ✅ Reward points visible in user profile/stats

---

### Test Case 4: View Trip History and User Profile Management

**Test Case ID:** UAT-TC-004

**Test Title:** Verify Trip History Access and User Profile Information Display

**Pre-conditions:**
- User is logged in
- User has at least one completed trip record in Firestore
- Internet connectivity is active
- User profile data exists in database
- Trip history data is properly synced with backend

**Test Path:** Dashboard → Profile Menu → View Profile → Trip History → Trip Details → Back to Profile

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | From dashboard, tap user profile icon or menu | Profile page loads with user information section at top |
| 2 | Verify user profile displays correctly | Name, email, phone number, profile image visible |
| 3 | Locate and tap "Trip History" section | Trip History page loads showing list of previous trips |
| 4 | Observe trip list sorted chronologically (newest first) | Each trip entry shows: date, time, bus number/name |
| 5 | Use search/filter functionality (if available) | Can search by date range or bus number; results update |
| 6 | Tap on a specific trip from the list | Trip details expand/navigate showing complete information |
| 7 | Verify trip details are populated | Trip info displays: start time, end time, duration, bus details |
| 8 | Check for trip-related feedback or ratings | User can view their feedback/rating for that trip |
| 9 | Navigate back to trip history list | Page returns without data loss; list maintained |
| 10 | Access profile editing features (if available) | Can update name, phone, email, or other profile fields |
| 11 | Check reward points display | User can view earned reward points and statistics |
| 12 | Verify all data persists across sessions | Information remains consistent after app close/restart |

**Expected Result:** User can successfully view complete profile information, access trip history with filtering options, view detailed trip information, and manage profile settings. All data accurately reflects backend records.

**Acceptance Criteria:**
- ✅ Profile page loads within 2 seconds
- ✅ User information displays correctly and completely
- ✅ Trip history shows all previous trips
- ✅ Trips sorted chronologically (newest first)
- ✅ Search/filter functionality works accurately
- ✅ Trip details load when tapped
- ✅ Trip information is complete and accurate
- ✅ Reward points calculated and displayed correctly
- ✅ Profile editing works without data loss
- ✅ All data persists after app restart
- ✅ No missing or corrupted records

---

### Test Case 5: Emergency Alert (SOS) Activation and Response

**Test Case ID:** UAT-TC-005

**Test Title:** Verify Emergency Alert System and Response Notification

**Pre-conditions:**
- User is logged in
- User is currently on or simulating a bus trip
- Network connectivity is available
- Push notifications enabled in app settings
- Emergency service backend is configured
- Device has sufficient battery

**Test Path:** Dashboard → Emergency Feature → Hold SOS Button → Confirmation → Alert Transmission → Response Notification → Cancel Option

**Test Steps:**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | From dashboard or trip screen, locate Emergency/SOS button (usually red) | SOS button is prominent, highly visible, and accessible |
| 2 | Verify SOS button location and design | Button is large enough to tap but requires intentional action (prevents accidents) |
| 3 | Tap and hold SOS button for 2-3 seconds | Visual feedback appears (color change, animation, or countdown) |
| 4 | After hold period, confirmation prompt appears | Dialog or toast asks user to confirm emergency alert |
| 5 | Tap "Confirm Emergency" to finalize alert | Loading indicator displays; data transmission begins |
| 6 | Alert with location, timestamp, user ID is transmitted | Backend receives: GPS coordinates, exact timestamp, passenger info |
| 7 | Success notification appears on screen | Message displays: "Emergency alert sent successfully" or similar |
| 8 | Admin/emergency dashboard receives alert | Backend system records alert and creates entry for responder |
| 9 | Optional: Push notification sent back to user | Notification confirms emergency team dispatch (if configured) |
| 10 | User can cancel alert within 30 seconds if accidental | "Cancel Alert" button available and functional within 30s window |
| 11 | If cancelled, emergency is revoked | Alert status updated; emergency teams notified of cancellation |
| 12 | Verify alert history is recorded | Alert entry visible in app logs/notification history |

**Expected Result:** Emergency alert system activates reliably, transmits location and user data to emergency services in real-time, provides user confirmation, and allows cancellation within safety window.

**Acceptance Criteria:**
- ✅ SOS button is easily accessible and responsive
- ✅ 2-3 second hold prevents accidental activation
- ✅ Alert transmits location within 5 seconds of confirmation
- ✅ Emergency services receive alert within 5 seconds
- ✅ Confirmation message displays to user
- ✅ Alert can be cancelled within 30-second window
- ✅ Cancellation is transmitted to backend immediately
- ✅ Works reliably with 4G/3G/WiFi connectivity
- ✅ Alert history recorded in user's notification history
- ✅ No false positives from accidental touches (requires hold)
- ✅ GPS coordinates are accurate (within 50m)

---

## 📊 Test Execution Summary Template

| Test Case ID | Title | Status | Date Executed | Pass/Fail | Issues Found | Notes |
|---|---|---|---|---|---|---|
| UAT-TC-001 | User Authentication | ⏳ Pending | - | - | - | - |
| UAT-TC-002 | QR Code Scanning | ⏳ Pending | - | - | - | - |
| UAT-TC-003 | Feedback Submission | ⏳ Pending | - | - | - | - |
| UAT-TC-004 | Trip History & Profile | ⏳ Pending | - | - | - | - |
| UAT-TC-005 | Emergency Alert (SOS) | ⏳ Pending | - | - | - | - |

---

## 🎯 Success Criteria for UAT Sign-off

- ✅ All 5 test cases executed successfully
- ✅ Zero critical defects found
- ✅ Maximum 2 minor defects (cosmetic/UX improvements only)
- ✅ All acceptance criteria met for each test case
- ✅ App performance acceptable (no crashes or freezes)
- ✅ Data integrity maintained throughout testing
- ✅ No data loss or corruption observed
- ✅ User feedback positive on usability and functionality
- ✅ Firebase integration working reliably
- ✅ Authentication and data persistence working as designed

---

## 📝 Testing Notes and Important Information

### Test Data Requirements:
1. **Authentication:** Test accounts with valid phone numbers (Sri Lanka +94 format)
2. **QR Codes:** Test QR codes for buses and feedback forms deployed in staging environment
3. **Firestore:** Test database populated with sample trips, buses, and driver data
4. **Firebase Auth:** Phone authentication enabled with SMS verification
5. **Cloud Functions:** Optional Cloud Functions for backend processing configured

### Device & Platform Requirements:
- Android API 21 or higher (minimum requirements)
- Test on both emulator and real devices when possible
- Minimum 2GB RAM, 100MB free storage for app installation
- Camera and location permissions must be grantable

### Network Testing:
- Test with varying network speeds: 4G, 3G, WiFi, and low-bandwidth scenarios
- Verify app behavior with temporary network disconnection
- Test data syncing when connection is restored

### Firebase Configuration:
- Ensure Firebase project is correctly configured
- Verify Firestore security rules allow test user access
- Confirm Firebase Cloud Messaging (FCM) is active for notifications
- Test both debug and release builds

### Known Limitations & Features Not in Scope:
- **Not Implemented:** Real-time driver monitoring dashboard (mentioned in README but not in actual code)
- **Not Implemented:** Live GPS tracking with continuous location updates
- **Not Implemented:** Advanced AI driver alertness analytics
- **Actual Features:** QR scanning, feedback system, trip history, emergency alerts, reward points

### Post-Test Cleanup:
1. Clear test data from Firestore to avoid cluttering
2. Document any issues with screenshot evidence
3. Capture performance metrics (response times, data load times)
4. Note any differences between actual behavior and documentation

---

**Document Version:** 2.0 (Actual Implementation)  
**Last Updated:** 2026-06-13  
**Prepared For:** SafeDriver Passenger App UAT Phase  
**Based On:** Actual codebase analysis of Flutter app implementation

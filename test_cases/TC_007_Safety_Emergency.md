# Safety & Emergency Features Test Cases - SafeDriver Passenger App

**Module:** Safety Features, Emergency Alerts & SOS  
**Test Plan ID:** TP-SAFEDRIVER-001  
**Test Case Category:** TC-007  
**Created:** March 12, 2026  

---

## 📋 Test Case 074: Emergency Button Accessibility

**Test Case ID:** TC-007-001  
**Test Type:** Functional Testing  
**Priority:** P0 - Critical  
**Status:** Ready

### **Title**
Verify emergency/SOS button is easily accessible

### **Description**
This test verifies the emergency button is prominently placed and activates quickly.

### **Preconditions**
- User is logged in
- App running (foreground or background)
- Emergency button configured

### **Test Steps**

• **Step 1:** On dashboard
• **Expected:** Emergency button visible and prominent
• **Step 2:** Button color
• **Expected:** Red or distinctive color (stands out)
• **Step 3:** Button icon
• **Expected:** Emergency/SOS icon clearly visible
• **Step 4:** Button position
• **Expected:** Consistent and findable on every screen
• **Step 5:** Quick access
• **Expected:** Easy to reach without multiple taps
• **Step 6:** Response time
• **Expected:** Tap response immediate (< 200ms)
• **Step 7:** Confirmation dialog
• **Expected:** "Activate Emergency Mode?" appears
• **Step 8:** User can cancel
• **Expected:** "Cancel" button available before full activation
• **Step 9:** Large touch target
• **Expected:** Button at least 48x48 dp (recommended 60x60)
• **Step 10:** Accessible even locked
• **Expected:** Emergency accessible without full unlock
• **Step 11:** Physical access
• **Expected:** Widget or notification for quick access
• **Step 12:** Settings override
• **Expected:** Cannot accidentally disable in normal settings

### **Expected Result**
- Emergency button prominently displayed
- Easy to locate and tap
- Responsive to touch
- Confirmation before full activation
- Large touch target for emergency situations
- Accessible from any state

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Button visible  
✅ Easily accessible  
✅ Responsive  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 075: SOS Activation

**Test Case ID:** TC-007-002  
**Test Type:** Functional Testing  
**Priority:** P0 - Critical  
**Status:** Ready

### **Title**
Verify SOS activation sends emergency alert with location

### **Description**
This test verifies complete SOS functionality and alert sending.

### **Preconditions**
- Emergency button visible
- Location services enabled
- Emergency contacts added
- Internet connectivity

### **Test Steps**

• **Step 1:** Tap emergency button
• **Expected:** Confirmation dialog appears
• **Step 2:** Confirm activation
• **Expected:** "Are you sure?" confirmation shown
• **Step 3:** Tap "Activate SOS"
• **Expected:** SOS activation begins
• **Step 4:** Location acquired
• **Expected:** App captures GPS location
• **Step 5:** Loading state
• **Expected:** "Sending emergency alert..." displays
• **Step 6:** Contacts notified
• **Expected:** Emergency contacts receive alert SMS
• **Step 7:** Alert content
• **Expected:** Includes: Name, Location, Time, App confirmation
• **Step 8:** Siren/alarm
• **Expected:** Visual alarm/siren indicator (if enabled)
• **Step 9:** Contact list
• **Expected:** Shows which contacts were notified
• **Step 10:** Status display
• **Expected:** "SOS Activated" indicator shown
• **Step 11:** Counter
• **Expected:** Shows time since activation
• **Step 12:** Deactivate option
• **Expected:** "Cancel SOS" button available

### **Expected Result**
- SOS activates with confirmation
- Emergency contacts notified immediately
- Location included in alert
- Alerts reach multiple emergency contacts
- Status clearly shown to user
- Deactivation option available

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ SOS activates  
✅ Alerts sent  
✅ Location included  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 076: Emergency Contacts for SOS

**Test Case ID:** TC-007-003  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify emergency contacts receive SOS alerts

### **Description**
This test verifies SOS messages reach configured emergency contacts.

### **Preconditions**
- Emergency contacts configured (3-5 contacts minimum)
- Contacts have valid phone numbers
- SMS delivery functional

### **Test Steps**

• **Step 1:** Configure emergency contacts
• **Expected:** Add 3 emergency contacts with phone numbers
• **Step 2:** Activate SOS
• **Expected:** Send emergency alert
• **Step 3:** Contact 1 alert
• **Expected:** First contact receives SMS within 5 seconds
• **Step 4:** Contact 2 alert
• **Expected:** Second contact receives SMS
• **Step 5:** Contact 3 alert
• **Expected:** Third contact receives SMS
• **Step 6:** Alert message format
• **Expected:** Message includes: Your name, Location, Emergency activated
• **Step 7:** Alert response link
• **Expected:** Message includes link to view location (if available)
• **Step 8:** Offline handling
• **Expected:** If offline, queues alert for sending when online
• **Step 9:** Network timeout
• **Expected:** Retries sending if initially failed
• **Step 10:** Duplicate prevention
• **Expected:** Each contact receives only one alert
• **Step 11:** Update contacts
• **Expected:** Can modify contacts list after activation
• **Step 12:** All contacts notified
• **Expected:** Even if one fails, others still receive alert

### **Expected Result**
- Emergency contacts receive alerts immediately
- Message includes user info and location
- Handles network issues gracefully
- No duplicate messages
- All contacts receive alert even if one fails
- Works with multiple contact numbers

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Alerts delivered  
✅ Message format correct  
✅ Multiple contacts reached  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 077: Safety Tips and Alerts

**Test Case ID:** TC-007-004  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify safety tips and alerts are displayed to user

### **Description**
This test verifies in-app safety information and warnings.

### **Preconditions**
- Safety features section accessible
- User on safety tips page

### **Test Steps**

• **Step 1:** Navigate to Safety section
• **Expected:** Safety tips page displays
• **Step 2:** Safety tips listed
• **Expected:** Categories: General, Bus, Driver, Route, Night Travel
• **Step 3:** Read tip
• **Expected:** Tap a tip to expand and read full advice
• **Step 4:** Tips content
• **Expected:** Clear, actionable safety advice provided
• **Step 5:** Share tip
• **Expected:** Option to share tip with others
• **Step 6:** Bookmark favorite
• **Expected:** Can save favorite tips
• **Step 7:** Search tips
• **Expected:** Can search for specific safety topics
• **Step 8:** Ratings
• **Expected:** Can rate usefulness of each tip
• **Step 9:** Personalized alerts
• **Expected:** App sends periodic safety reminders
• **Step 10:** Alert timing
• **Expected:** Alerts at appropriate times (e.g., late night)
• **Step 11:** Dismiss alert
• **Expected:** Can dismiss or snooze alerts
• **Step 12:** Emergency numbers
• **Expected:** Emergency contact numbers displayed

### **Expected Result**
- Safety tips well-organized and searchable
- Content clear and actionable
- Users can save/share tips
- Personalized alerts work
- Emergency numbers accessible
- Rating system functional

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Tips display  
✅ Search works  
✅ Alerts sent  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 078: Hazard Reporting

**Test Case ID:** TC-007-005  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify users can report hazards in real-time

### **Description**
This test verifies hazard reporting feature for user safety.

### **Preconditions**
- User on maps/route page
- Report hazard button visible
- Location services enabled

### **Test Steps**

• **Step 1:** Tap "Report Hazard" button
• **Expected:** Hazard reporting form opens
• **Step 2:** View hazard types
• **Expected:** Categories: Accident, Bad road, Unsafe driver, Traffic jam, etc.
• **Step 3:** Select hazard type
• **Expected:** Choose from dropdown list
• **Step 4:** Describe hazard
• **Expected:** Optional description field
• **Step 5:** Attach photo
• **Expected:** Can add photo evidence (optional)
• **Step 6:** Location auto-filled
• **Expected:** Current location automatically added
• **Step 7:** Severity level
• **Expected:** Option to select: Low, Medium, High
• **Step 8:** Tap "Report"
• **Expected:** Report submitted to server
• **Step 9:** Confirmation
• **Expected:** "Thank you for reporting" message shows
• **Step 10:** Alert other users
• **Expected:** Other users on route warned about hazard
• **Step 11:** Report verification
• **Expected:** False reports tracked and users warned
• **Step 12:** Reward system
• **Expected:** Users earn points for valid hazard reports

### **Expected Result**
- Hazard reporting interface intuitive
- Location auto-populated
- Photo upload optional
- Report submitted successfully
- Other users notified
- False reports handled
- Users rewarded for valid reports

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Report form works  
✅ Submission successful  
✅ Users notified  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 079: Travel with Trusted Contact

**Test Case ID:** TC-007-006  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can share live location with trusted contact

### **Description**
This test verifies location sharing during travel.

### **Preconditions**
- User starting journey
- Emergency contacts configured
- Location services enabled

### **Test Steps**

• **Step 1:** Before starting trip
• **Expected:** Option to "Share journey with contact"
• **Step 2:** Select contact
• **Expected:** Choose from emergency contacts list
• **Step 3:** Set duration
• **Expected:** Select sharing duration: Until destination, 1 hour, etc.
• **Step 4:** Confirmation
• **Expected:** "Sharing location with [Name]" message
• **Step 5:** Contact notification
• **Expected:** Trusted contact receives link to track journey
• **Step 6:** Real-time tracking
• **Expected:** Contact sees live location on map
• **Step 7:** ETA shared
• **Expected:** Estimated arrival time sent to contact
• **Step 8:** Journey complete
• **Expected:** Automatic stop sharing when destination reached
• **Step 9:** Manual stop
• **Expected:** User can stop sharing before destination
• **Step 10:** Contact still tracking
• **Expected:** Contact notified when sharing stopped
• **Step 11:** Safety alert
• **Expected:** If journey takes unusually long, alert sent
• **Step 12:** Unshare location
• **Expected:** Can revoke access anytime

### **Expected Result**
- Location sharing set up easily
- Contact receives live tracking link
- Sharing duration configurable
- Automatic stop at destination
- Can stop sharing manually
- Contacts notified of status changes

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Sharing works  
✅ Contact receives link  
✅ Real-time tracking  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 080: Safety Score Display

**Test Case ID:** TC-007-007  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify user safety score is calculated and displayed

### **Description**
This test verifies personal safety score based on behaviors and history.

### **Preconditions**
- User has completed trips
- Safety data available
- Profile page open

### **Test Steps**

• **Step 1:** View profile
• **Expected:** Safety score visible (e.g., "94/100")
• **Step 2:** Score display
• **Expected:** Shows as percentage or number out of 100
• **Step 3:** Safety level indicator
• **Expected:** "Excellent", "Good", "Fair", "Poor" label
• **Step 4:** Score color
• **Expected:** Green (high), Yellow (medium), Red (low)
• **Step 5:** Factors explained
• **Expected:** Tap score to see what affects it
• **Step 6:** Trip count
• **Expected:** Number and frequency of trips
• **Step 7:** Rating history
• **Expected:** Average rating from other users
• **Step 8:** Safety alerts
• **Expected:** Number of safety incidents
• **Step 9:** Profile completion
• **Expected:** Fully completed profile increases score
• **Step 10:** Feedback received
• **Expected:** Positive feedback improves score
• **Step 11:** Hazard reports
• **Expected:** Reports filed improve community safety rating
• **Step 12:** Tips compliance
• **Expected:** Following safety tips improves score

### **Expected Result**
- Safety score calculated from multiple factors
- Score clearly displayed
- Level indicator helps user understand position
- Contributing factors transparent
- Score updates over time
- User motivated to improve safety

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Score displays  
✅ Factors explained  
✅ Updates correctly  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 081: Suspicious Activity Detection

**Test Case ID:** TC-007-008  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify app detects and alerts on suspicious activity

### **Description**
This test verifies anomaly detection for fraudulent activity.

### **Preconditions**
- App has monitoring enabled
- Multiple logins/sessions tracked

### **Test Steps**

• **Step 1:** Normal login
• **Expected:** User logs in from regular location
• **Step 2:** New device login
• **Expected:** User logs in from different device
• **Step 3:** Alert received
• **Expected:** "New device login from [Location]" notification
• **Step 4:** Confirm login
• **Expected:** User confirms this was them
• **Step 5:** Device remembered
• **Expected:** Device whitelisted for future logins
• **Step 6:** Unusual location
• **Expected:** Login attempt from very different location
• **Step 7:** Suspicious alert
• **Expected:** "Suspicious login from [Location]" alert
• **Step 8:** Require confirmation
• **Expected:** User must verify with OTP
• **Step 9:** Rapid consecutive requests
• **Expected:** Multiple attempts in short time detected
• **Step 10:** Account locked
• **Expected:** Account temporarily locked if suspicious activity
• **Step 11:** Unlock process
• **Expected:** User unlocks via email/phone verification
• **Step 12:** Brute force protection
• **Expected:** Protection against repeated login attempts

### **Expected Result**
- Suspicious activity detected automatically
- Unusual logins flagged and verified
- User receives alerts
- Account protected from unauthorized access
- Brute force attacks prevented
- Verification process smooth

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Detection works  
✅ Alerts sent  
✅ Account protected  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 082: Data Encryption and Security

**Test Case ID:** TC-007-009  
**Test Type:** Security Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user data is encrypted in transit and at rest

### **Description**
This test verifies data security and encryption.

### **Preconditions**
- Network traffic can be monitored
- Firebase security rules configured

### **Test Steps**

• **Step 1:** API calls
• **Expected:** All communication uses HTTPS/TLS 1.2+
• **Step 2:** Data in transit
• **Expected:** Network traffic encrypted
• **Step 3:** Sensitive data
• **Expected:** Passwords, location never logged plaintext
• **Step 4:** Database encryption
• **Expected:** Firestore data encrypted at rest
• **Step 5:** Local storage
• **Expected:** Sensitive data encrypted on device
• **Step 6:** Shared preferences
• **Expected:** Any stored tokens encrypted
• **Step 7:** API authentication
• **Expected:** Authorization tokens properly managed
• **Step 8:** No hardcoded secrets
• **Expected:** API keys not exposed in code
• **Step 9:** SSL certificate
• **Expected:** Valid SSL certificate for all domains
• **Step 10:** Certificate validation
• **Expected:** App validates server certificate
• **Step 11:** Token expiration
• **Expected:** Auth tokens expire and refresh properly
• **Step 12:** Logout cleanup
• **Expected:** Sensitive data cleared on logout

### **Expected Result**
- All data communication encrypted
- HTTPS used for all API calls
- Sensitive data never logged plaintext
- Local encryption implemented
- Authorization tokens properly managed
- Security best practices followed

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Encryption implemented  
✅ HTTPS used  
✅ Data protected  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 083: Crash and Error Recovery

**Test Case ID:** TC-007-010  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify app recovers gracefully from crashes

### **Description**
This test verifies error handling and crash recovery.

### **Preconditions**
- App running
- Firebase Crashlytics configured

### **Test Steps**

• **Step 1:** Trigger error
• **Expected:** Perform action that causes error (if possible in controlled test)
• **Step 2:** Error caught
• **Expected:** App doesn't force close
• **Step 3:** Error message
• **Expected:** User-friendly error message displayed
• **Step 4:** Crash not reported
• **Expected:** Benign errors don't trigger crash report
• **Step 5:** Critical error
• **Expected:** App crashes catastrophically (tests recovery)
• **Step 6:** Restart enabled
• **Expected:** User can restart app
• **Step 7:** State recovery
• **Expected:** App returns to last stable state (or login)
• **Step 8:** Data preserved
• **Expected:** User data not lost
• **Step 9:** Crash report
• **Expected:** Critical crash reported to developers via Crashlytics
• **Step 10:** Diagnostic info
• **Expected:** Crash logs include device info, stack trace
• **Step 11:** No PII in logs
• **Expected:** Personal information not included in crash reports
• **Step 12:** Recovery notification
• **Expected:** "App experienced an issue" notification with recovery option

### **Expected Result**
- App handles errors gracefully
- Doesn't force close on normal errors
- Data preserved across crashes
- Crash reports generated for debugging
- No personal data in crash logs
- User can recover and continue using app

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Error handling works  
✅ Crash recovery works  
✅ Data preserved  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📊 Test Execution Summary - Safety & Emergency

| TC ID | Title | Status | Pass | Fail | Blocked | Notes |
|-------|-------|--------|------|------|---------|-------|
| TC-007-001 | Emergency Button | | [ ] | [ ] | [ ] | |
| TC-007-002 | SOS Activation | | [ ] | [ ] | [ ] | |
| TC-007-003 | Emergency Contacts | | [ ] | [ ] | [ ] | |
| TC-007-004 | Safety Tips | | [ ] | [ ] | [ ] | |
| TC-007-005 | Hazard Reporting | | [ ] | [ ] | [ ] | |
| TC-007-006 | Trusted Contact Sharing | | [ ] | [ ] | [ ] | |
| TC-007-007 | Safety Score | | [ ] | [ ] | [ ] | |
| TC-007-008 | Suspicious Activity | | [ ] | [ ] | [ ] | |
| TC-007-009 | Data Encryption | | [ ] | [ ] | [ ] | |
| TC-007-010 | Crash Recovery | | [ ] | [ ] | [ ] | |

**Total:** 10 Test Cases | **Passed:** [ ] | **Failed:** [ ] | **Blocked:** [ ]  
**Pass Rate:** ____%

---

## 📝 Overall Test Summary

### **Complete Test Suite Statistics**

| Category | Module ID | Test Cases | Status |
|----------|-----------|-----------|---------|
| Authentication | TC-001 | 15 | Ready |
| Onboarding & Profile | TC-002 | 10 | Ready |
| Feedback System | TC-003 | 12 | Ready |
| Dashboard & Navigation | TC-004 | 12 | Ready |
| Location & Maps | TC-005 | 11 | Ready |
| Notifications & Settings | TC-006 | 13 | Ready |
| Safety & Emergency | TC-007 | 10 | Ready |

**TOTAL TEST CASES: 83**

---

**Test Module Created:** March 12, 2026  
**Last Updated:** March 12, 2026  
**Prepared By:** QA Team

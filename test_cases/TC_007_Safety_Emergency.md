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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | On dashboard | Emergency button visible and prominent |
| 2 | Button color | Red or distinctive color (stands out) |
| 3 | Button icon | Emergency/SOS icon clearly visible |
| 4 | Button position | Consistent and findable on every screen |
| 5 | Quick access | Easy to reach without multiple taps |
| 6 | Response time | Tap response immediate (< 200ms) |
| 7 | Confirmation dialog | "Activate Emergency Mode?" appears |
| 8 | User can cancel | "Cancel" button available before full activation |
| 9 | Large touch target | Button at least 48x48 dp (recommended 60x60) |
| 10 | Accessible even locked | Emergency accessible without full unlock |
| 11 | Physical access | Widget or notification for quick access |
| 12 | Settings override | Cannot accidentally disable in normal settings |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap emergency button | Confirmation dialog appears |
| 2 | Confirm activation | "Are you sure?" confirmation shown |
| 3 | Tap "Activate SOS" | SOS activation begins |
| 4 | Location acquired | App captures GPS location |
| 5 | Loading state | "Sending emergency alert..." displays |
| 6 | Contacts notified | Emergency contacts receive alert SMS |
| 7 | Alert content | Includes: Name, Location, Time, App confirmation |
| 8 | Siren/alarm | Visual alarm/siren indicator (if enabled) |
| 9 | Contact list | Shows which contacts were notified |
| 10 | Status display | "SOS Activated" indicator shown |
| 11 | Counter | Shows time since activation |
| 12 | Deactivate option | "Cancel SOS" button available |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Configure emergency contacts | Add 3 emergency contacts with phone numbers |
| 2 | Activate SOS | Send emergency alert |
| 3 | Contact 1 alert | First contact receives SMS within 5 seconds |
| 4 | Contact 2 alert | Second contact receives SMS |
| 5 | Contact 3 alert | Third contact receives SMS |
| 6 | Alert message format | Message includes: Your name, Location, Emergency activated |
| 7 | Alert response link | Message includes link to view location (if available) |
| 8 | Offline handling | If offline, queues alert for sending when online |
| 9 | Network timeout | Retries sending if initially failed |
| 10 | Duplicate prevention | Each contact receives only one alert |
| 11 | Update contacts | Can modify contacts list after activation |
| 12 | All contacts notified | Even if one fails, others still receive alert |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Safety section | Safety tips page displays |
| 2 | Safety tips listed | Categories: General, Bus, Driver, Route, Night Travel |
| 3 | Read tip | Tap a tip to expand and read full advice |
| 4 | Tips content | Clear, actionable safety advice provided |
| 5 | Share tip | Option to share tip with others |
| 6 | Bookmark favorite | Can save favorite tips |
| 7 | Search tips | Can search for specific safety topics |
| 8 | Ratings | Can rate usefulness of each tip |
| 9 | Personalized alerts | App sends periodic safety reminders |
| 10 | Alert timing | Alerts at appropriate times (e.g., late night) |
| 11 | Dismiss alert | Can dismiss or snooze alerts |
| 12 | Emergency numbers | Emergency contact numbers displayed |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "Report Hazard" button | Hazard reporting form opens |
| 2 | View hazard types | Categories: Accident, Bad road, Unsafe driver, Traffic jam, etc. |
| 3 | Select hazard type | Choose from dropdown list |
| 4 | Describe hazard | Optional description field |
| 5 | Attach photo | Can add photo evidence (optional) |
| 6 | Location auto-filled | Current location automatically added |
| 7 | Severity level | Option to select: Low, Medium, High |
| 8 | Tap "Report" | Report submitted to server |
| 9 | Confirmation | "Thank you for reporting" message shows |
| 10 | Alert other users | Other users on route warned about hazard |
| 11 | Report verification | False reports tracked and users warned |
| 12 | Reward system | Users earn points for valid hazard reports |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Before starting trip | Option to "Share journey with contact" |
| 2 | Select contact | Choose from emergency contacts list |
| 3 | Set duration | Select sharing duration: Until destination, 1 hour, etc. |
| 4 | Confirmation | "Sharing location with [Name]" message |
| 5 | Contact notification | Trusted contact receives link to track journey |
| 6 | Real-time tracking | Contact sees live location on map |
| 7 | ETA shared | Estimated arrival time sent to contact |
| 8 | Journey complete | Automatic stop sharing when destination reached |
| 9 | Manual stop | User can stop sharing before destination |
| 10 | Contact still tracking | Contact notified when sharing stopped |
| 11 | Safety alert | If journey takes unusually long, alert sent |
| 12 | Unshare location | Can revoke access anytime |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View profile | Safety score visible (e.g., "94/100") |
| 2 | Score display | Shows as percentage or number out of 100 |
| 3 | Safety level indicator | "Excellent", "Good", "Fair", "Poor" label |
| 4 | Score color | Green (high), Yellow (medium), Red (low) |
| 5 | Factors explained | Tap score to see what affects it |
| 6 | Trip count | Number and frequency of trips |
| 7 | Rating history | Average rating from other users |
| 8 | Safety alerts | Number of safety incidents |
| 9 | Profile completion | Fully completed profile increases score |
| 10 | Feedback received | Positive feedback improves score |
| 11 | Hazard reports | Reports filed improve community safety rating |
| 12 | Tips compliance | Following safety tips improves score |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Normal login | User logs in from regular location |
| 2 | New device login | User logs in from different device |
| 3 | Alert received | "New device login from [Location]" notification |
| 4 | Confirm login | User confirms this was them |
| 5 | Device remembered | Device whitelisted for future logins |
| 6 | Unusual location | Login attempt from very different location |
| 7 | Suspicious alert | "Suspicious login from [Location]" alert |
| 8 | Require confirmation | User must verify with OTP |
| 9 | Rapid consecutive requests | Multiple attempts in short time detected |
| 10 | Account locked | Account temporarily locked if suspicious activity |
| 11 | Unlock process | User unlocks via email/phone verification |
| 12 | Brute force protection | Protection against repeated login attempts |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | API calls | All communication uses HTTPS/TLS 1.2+ |
| 2 | Data in transit | Network traffic encrypted |
| 3 | Sensitive data | Passwords, location never logged plaintext |
| 4 | Database encryption | Firestore data encrypted at rest |
| 5 | Local storage | Sensitive data encrypted on device |
| 6 | Shared preferences | Any stored tokens encrypted |
| 7 | API authentication | Authorization tokens properly managed |
| 8 | No hardcoded secrets | API keys not exposed in code |
| 9 | SSL certificate | Valid SSL certificate for all domains |
| 10 | Certificate validation | App validates server certificate |
| 11 | Token expiration | Auth tokens expire and refresh properly |
| 12 | Logout cleanup | Sensitive data cleared on logout |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Trigger error | Perform action that causes error (if possible in controlled test) |
| 2 | Error caught | App doesn't force close |
| 3 | Error message | User-friendly error message displayed |
| 4 | Crash not reported | Benign errors don't trigger crash report |
| 5 | Critical error | App crashes catastrophically (tests recovery) |
| 6 | Restart enabled | User can restart app |
| 7 | State recovery | App returns to last stable state (or login) |
| 8 | Data preserved | User data not lost |
| 9 | Crash report | Critical crash reported to developers via Crashlytics |
| 10 | Diagnostic info | Crash logs include device info, stack trace |
| 11 | No PII in logs | Personal information not included in crash reports |
| 12 | Recovery notification | "App experienced an issue" notification with recovery option |

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

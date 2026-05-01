# SafeDriver Passenger App - Test Cases

## 1. Test Case Format

Each test case includes: ID, Title, Preconditions, Steps, Expected Results, Priority, Type, Platforms.

---

## 2. General and Installation

### GEN-001 - Install App
- Preconditions: Test device available.
- Steps:
  1. Install the app from test build.
  2. Launch the app.
- Expected Results:
  - App installs without errors and launches to splash screen.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### GEN-002 - First Launch Permissions Prompt
- Preconditions: Fresh install, no permissions granted.
- Steps:
  1. Launch the app.
  2. Navigate to a screen requiring location (live tracking).
  3. Navigate to a screen requiring camera (QR scan).
  4. Navigate to a screen requiring notifications.
- Expected Results:
  - Permission prompts appear when features are accessed.
  - Denying permissions shows a clear error or fallback.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### GEN-003 - App Resume from Background
- Preconditions: User logged in.
- Steps:
  1. Put the app in background.
  2. Resume the app after 2 minutes.
- Expected Results:
  - App resumes without crash and shows last state.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

---

## 3. Language Selection and Localization

### LANG-001 - Language Selection on First Launch
- Preconditions: Fresh install, no language selected.
- Steps:
  1. Launch the app.
  2. Select Sinhala.
  3. Continue to onboarding.
- Expected Results:
  - Language selection screen appears.
  - Selected language is applied to subsequent screens.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### LANG-002 - Language Selection Persistence
- Preconditions: Language selected in previous run.
- Steps:
  1. Force close the app.
  2. Relaunch the app.
- Expected Results:
  - App skips language selection and uses saved language.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### LANG-003 - Language Switching from Settings
- Preconditions: User logged in and on Settings screen.
- Steps:
  1. Change language to Tamil.
  2. Observe UI text on dashboard and profile.
- Expected Results:
  - Entire app reloads and displays Tamil text.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### LOC-001 - Localization Coverage
- Preconditions: App supports English, Sinhala, Tamil.
- Steps:
  1. Switch to each language.
  2. Navigate through major screens (dashboard, profile, feedback, settings).
- Expected Results:
  - All visible strings are localized with no fallback to the wrong language.
- Priority: High
- Type: Localization
- Platforms: Android, iOS

---

## 4. Onboarding

### ONB-001 - First-Time Onboarding Flow
- Preconditions: Fresh install, no onboarding completed.
- Steps:
  1. Launch the app.
  2. Swipe through all onboarding screens.
  3. Tap Get Started.
- Expected Results:
  - Onboarding screens display and end at login screen.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### ONB-002 - Skip Onboarding
- Preconditions: Fresh install.
- Steps:
  1. Launch the app.
  2. Tap Skip.
- Expected Results:
  - App navigates to login screen.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### ONB-003 - Onboarding Persistence
- Preconditions: Onboarding completed previously.
- Steps:
  1. Relaunch the app.
- Expected Results:
  - App does not show onboarding again.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

---

## 5. Authentication - Email/Password

### AUTH-001 - Register with Email and Password
- Preconditions: Valid email not in use.
- Steps:
  1. Open Register screen.
  2. Enter valid details.
  3. Submit registration.
- Expected Results:
  - Account is created and OTP flow starts.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### AUTH-002 - Login with Valid Credentials
- Preconditions: Registered account exists.
- Steps:
  1. Enter valid email and password.
  2. Tap Login.
- Expected Results:
  - User is authenticated and navigated to dashboard.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### AUTH-003 - Login with Invalid Password
- Preconditions: Registered account exists.
- Steps:
  1. Enter valid email and invalid password.
  2. Tap Login.
- Expected Results:
  - Login fails with clear error message.
- Priority: High
- Type: Negative
- Platforms: Android, iOS

### AUTH-004 - Forgot Password
- Preconditions: Valid email exists.
- Steps:
  1. Tap Forgot Password.
  2. Enter registered email.
  3. Submit.
- Expected Results:
  - Password reset instruction is sent.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

---

## 6. OTP Registration and SMS Gateway

### OTP-001 - OTP Send on Registration
- Preconditions: Registration initiated with valid phone number.
- Steps:
  1. Submit registration.
  2. Observe OTP screen.
- Expected Results:
  - OTP is sent and timer starts.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### OTP-002 - OTP Verification Success
- Preconditions: OTP sent.
- Steps:
  1. Enter correct OTP.
  2. Submit.
- Expected Results:
  - Account verification succeeds and user is routed to login.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### OTP-003 - OTP Verification Failure
- Preconditions: OTP sent.
- Steps:
  1. Enter incorrect OTP.
  2. Submit.
- Expected Results:
  - Verification fails with error message and retry allowed.
- Priority: High
- Type: Negative
- Platforms: Android, iOS

### OTP-004 - OTP Resend Timer
- Preconditions: OTP sent.
- Steps:
  1. Attempt resend before timer ends.
  2. After timer, tap Resend.
- Expected Results:
  - Resend blocked during timer; allowed after timer ends.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### OTP-005 - OTP Expiration
- Preconditions: OTP sent.
- Steps:
  1. Wait for OTP expiration time.
  2. Enter the expired OTP.
- Expected Results:
  - Verification fails and user is prompted to resend.
- Priority: Medium
- Type: Negative
- Platforms: Android, iOS

### OTP-006 - OTP Rate Limiting
- Preconditions: Valid phone number.
- Steps:
  1. Request OTP repeatedly beyond allowed limit.
- Expected Results:
  - Rate limiting is enforced and user sees a limit message.
- Priority: Medium
- Type: Security
- Platforms: Android, iOS

---

## 7. Persistent Login and Biometric

### BIO-001 - Persistent Login Enabled by Default
- Preconditions: Successful login.
- Steps:
  1. Close the app.
  2. Relaunch the app.
- Expected Results:
  - User remains logged in and goes to dashboard.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### BIO-002 - Enable Biometric Lock
- Preconditions: Logged in user and device supports biometric.
- Steps:
  1. Open Settings.
  2. Enable Biometric Lock and Fingerprint/Face ID.
- Expected Results:
  - Settings are saved and toggles persist after relaunch.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### BIO-003 - Require Biometric on App Open
- Preconditions: Biometric lock enabled.
- Steps:
  1. Enable Require on App Open.
  2. Close and reopen the app.
- Expected Results:
  - Biometric prompt is shown before entering dashboard.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### BIO-004 - Biometric Failure Fallback
- Preconditions: Require on App Open enabled.
- Steps:
  1. Fail biometric authentication.
- Expected Results:
  - User can retry or use manual login.
- Priority: Medium
- Type: Negative
- Platforms: Android, iOS

### BIO-005 - Biometric Not Supported
- Preconditions: Device without biometric support.
- Steps:
  1. Open Settings.
- Expected Results:
  - Biometric options are hidden or show unsupported message.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

---

## 8. Passenger Profile and Data

### PROF-001 - Profile Created on Registration
- Preconditions: New user registered and verified.
- Steps:
  1. Login and open Profile.
- Expected Results:
  - Profile data displays from passenger_details collection.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### PROF-002 - Update Profile Fields
- Preconditions: Logged in user.
- Steps:
  1. Edit name, phone, address.
  2. Save changes.
- Expected Results:
  - Data updates in UI and Firestore.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### PROF-003 - Update Preferences
- Preconditions: Logged in user.
- Steps:
  1. Change notification or privacy preference.
  2. Save changes.
- Expected Results:
  - Preferences persist after relaunch.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### PROF-004 - Favorites Management
- Preconditions: Logged in user.
- Steps:
  1. Add a favorite route.
  2. Remove the favorite route.
- Expected Results:
  - Favorites are updated in Firestore and UI.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### PROF-005 - Emergency Contact Update
- Preconditions: Logged in user.
- Steps:
  1. Update emergency contact details.
  2. Save changes.
- Expected Results:
  - Emergency contact is saved and visible on profile reload.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

---

## 9. Dashboard

### DASH-001 - Dashboard Loads with Data
- Preconditions: Logged in user and backend accessible.
- Steps:
  1. Open dashboard.
- Expected Results:
  - Dashboard loads without errors and shows key panels.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### DASH-002 - Time-Based Greeting
- Preconditions: Logged in user.
- Steps:
  1. Set device time to morning, afternoon, evening, night.
  2. Open dashboard each time.
- Expected Results:
  - Greeting changes according to time.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

---

## 10. QR Scanning and Bus Selection

### QR-001 - QR Scan Success
- Preconditions: Camera permission granted.
- Steps:
  1. Open QR scanner screen.
  2. Scan a valid QR code.
- Expected Results:
  - Bus is identified and details screen opens.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### QR-002 - QR Scan Invalid Data
- Preconditions: Camera permission granted.
- Steps:
  1. Scan an invalid QR code.
- Expected Results:
  - Error message shown and no crash.
- Priority: Medium
- Type: Negative
- Platforms: Android, iOS

### QR-003 - Camera Permission Denied
- Preconditions: Camera permission denied.
- Steps:
  1. Open QR scanner screen.
- Expected Results:
  - Permission error shown and guidance provided.
- Priority: Medium
- Type: Negative
- Platforms: Android, iOS

---

## 11. Live Tracking and Maps

### TRK-001 - Live Map Load
- Preconditions: Location permission granted, maps key valid.
- Steps:
  1. Open live tracking screen.
- Expected Results:
  - Map loads with bus markers.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### TRK-002 - Bus Location Updates
- Preconditions: Live tracking active.
- Steps:
  1. Observe bus marker position for updates.
- Expected Results:
  - Marker updates reflect backend changes.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### TRK-003 - Route Visualization
- Preconditions: Route data available.
- Steps:
  1. Open route tracking screen.
- Expected Results:
  - Route polyline and stops are visible.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### TRK-004 - Location Permission Denied
- Preconditions: Location permission denied.
- Steps:
  1. Open live tracking screen.
- Expected Results:
  - Permission message shown and feature blocked gracefully.
- Priority: Medium
- Type: Negative
- Platforms: Android, iOS

---

## 12. Bus and Driver Information

### BUS-001 - Bus Details Display
- Preconditions: Bus data exists.
- Steps:
  1. Open bus details screen.
- Expected Results:
  - Bus details show number, route, status, and metrics.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### BUS-002 - Bus History
- Preconditions: Bus history data exists.
- Steps:
  1. Open bus history screen.
- Expected Results:
  - History list loads and is scrollable.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### DRV-001 - Driver Profile Display
- Preconditions: Driver data exists.
- Steps:
  1. Open driver profile screen.
- Expected Results:
  - Driver details and safety metrics are shown.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### DRV-002 - Driver History
- Preconditions: Driver history data exists.
- Steps:
  1. Open driver history screen.
- Expected Results:
  - History list loads and is scrollable.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

---

## 13. Safety and Emergency

### SAF-001 - Hazard Zones Display
- Preconditions: Hazard zone data exists.
- Steps:
  1. Open hazard zones screen.
- Expected Results:
  - Hazard zones display on map/list with severity indicators.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### SAF-002 - Emergency Alert Trigger
- Preconditions: Logged in user and network available.
- Steps:
  1. Open emergency screen.
  2. Trigger emergency alert.
- Expected Results:
  - Alert request is sent and confirmation displayed.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### SAF-003 - Safety Tips Screen
- Preconditions: Logged in user.
- Steps:
  1. Open safety tips screen.
- Expected Results:
  - Tips content loads and is readable.
- Priority: Low
- Type: Functional
- Platforms: Android, iOS

---

## 14. Feedback System

### FEED-001 - Open Feedback System
- Preconditions: Logged in user.
- Steps:
  1. Tap Feedback from dashboard.
- Expected Results:
  - Feedback system page opens.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### FEED-002 - Select Bus Manually
- Preconditions: Bus list available.
- Steps:
  1. Choose a bus from list.
- Expected Results:
  - Selected bus is shown in header.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### FEED-003 - Select Bus via QR
- Preconditions: Camera permission granted.
- Steps:
  1. Scan a bus QR code.
- Expected Results:
  - Bus selection is applied to feedback form.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### FEED-004 - Submit Feedback with Rating
- Preconditions: Bus selected.
- Steps:
  1. Select feedback type.
  2. Choose star rating.
  3. Enter comment.
  4. Submit feedback.
- Expected Results:
  - Feedback is saved to Firestore and success message shown.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### FEED-005 - Quick Action Multi-Select
- Preconditions: Feedback form open.
- Steps:
  1. Select multiple quick action tags.
- Expected Results:
  - Multiple tags are selected and saved in feedback.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### FEED-006 - Feedback with Media Upload
- Preconditions: Storage configured and camera/gallery permission granted.
- Steps:
  1. Add photo or video.
  2. Submit feedback.
- Expected Results:
  - Media uploads successfully and links are stored.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### FEED-007 - Feedback with Location
- Preconditions: Location permission granted.
- Steps:
  1. Open feedback form.
  2. Confirm location is captured.
- Expected Results:
  - Location coordinates are attached to feedback data.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### FEED-008 - Feedback Validation
- Preconditions: Feedback form open.
- Steps:
  1. Submit without rating or with empty required fields.
- Expected Results:
  - Validation errors are shown and submission blocked.
- Priority: Medium
- Type: Negative
- Platforms: Android, iOS

### FEED-009 - Feedback Status Update Notification
- Preconditions: Feedback exists and backend updates status.
- Steps:
  1. Change feedback status in backend.
- Expected Results:
  - User receives a notification about status update.
- Priority: Medium
- Type: Integration
- Platforms: Android, iOS

### FEED-010 - WhatsApp Share
- Preconditions: WhatsApp installed.
- Steps:
  1. Open feedback submission screen.
  2. Tap WhatsApp share.
- Expected Results:
  - WhatsApp opens with prefilled message content.
- Priority: Low
- Type: Functional
- Platforms: Android, iOS

### FEED-011 - Email Share
- Preconditions: Email client configured on device.
- Steps:
  1. Open feedback submission screen.
  2. Tap Email share.
- Expected Results:
  - Email client opens with prefilled subject and message body.
- Priority: Low
- Type: Functional
- Platforms: Android, iOS

### FEED-012 - Media Size Limit
- Preconditions: Media selection available.
- Steps:
  1. Attach a media file larger than the allowed size.
  2. Attempt submission.
- Expected Results:
  - User sees a size validation error and upload is blocked.
- Priority: Low
- Type: Negative
- Platforms: Android, iOS

### FEED-013 - Location Permission Denied
- Preconditions: Location permission denied.
- Steps:
  1. Open feedback submission screen.
- Expected Results:
  - App shows location unavailable status and continues without crash.
- Priority: Low
- Type: Negative
- Platforms: Android, iOS

---

## 15. Reward Points

### RWD-001 - Points Added on Feedback Submission
- Preconditions: Logged in user with points tracking enabled.
- Steps:
  1. Submit valid feedback.
  2. Open profile or rewards widget.
- Expected Results:
  - Points increase by 1 and transaction is logged.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

### RWD-002 - Anti-Fraud Detection
- Preconditions: Logged in user.
- Steps:
  1. Submit feedback with very short or numeric-only comment.
- Expected Results:
  - Feedback is rejected or flagged; points are not awarded.
- Priority: High
- Type: Negative
- Platforms: Android, iOS

### RWD-003 - Points Deducted for Fake Feedback
- Preconditions: Feedback marked fake by admin.
- Steps:
  1. Update feedback status to fake in backend.
- Expected Results:
  - Points are reduced by 1 and transaction is logged.
- Priority: Medium
- Type: Integration
- Platforms: Android, iOS

---

## 16. Notifications

### NOTIF-001 - Registration Notification
- Preconditions: FCM token stored.
- Steps:
  1. Complete registration.
- Expected Results:
  - User receives registration notification and entry in Firestore notifications.
- Priority: High
- Type: Integration
- Platforms: Android, iOS

### NOTIF-002 - Feedback Submission Notification
- Preconditions: FCM token stored.
- Steps:
  1. Submit feedback.
- Expected Results:
  - User receives feedback submission notification.
- Priority: Medium
- Type: Integration
- Platforms: Android, iOS

### NOTIF-003 - Profile Update Notification
- Preconditions: FCM token stored.
- Steps:
  1. Update profile fields.
- Expected Results:
  - Profile update notification received.
- Priority: Medium
- Type: Integration
- Platforms: Android, iOS

### NOTIF-004 - Journey Started/Completed Notifications
- Preconditions: Backend callable functions available.
- Steps:
  1. Trigger journey start notification.
  2. Trigger journey completion notification.
- Expected Results:
  - Notifications received with correct details.
- Priority: Medium
- Type: Integration
- Platforms: Android, iOS

### NOTIF-005 - Unread Count Updates
- Preconditions: Notifications exist.
- Steps:
  1. Mark one notification as read.
- Expected Results:
  - Unread count updates correctly.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### NOTIF-006 - Device Token Stored on Login
- Preconditions: Logged in user, notifications initialized.
- Steps:
  1. Login to the app.
  2. Check passenger record in backend.
- Expected Results:
  - Device token is stored in passenger profile data.
- Priority: Medium
- Type: Integration
- Platforms: Android, iOS

---

## 17. Settings

### SET-001 - Notification Preferences
- Preconditions: Logged in user.
- Steps:
  1. Toggle notification settings.
  2. Relaunch app.
- Expected Results:
  - Preferences persist and control notification behavior.
- Priority: Medium
- Type: Functional
- Platforms: Android, iOS

### SET-002 - Logout
- Preconditions: Logged in user.
- Steps:
  1. Tap Logout.
  2. Relaunch app.
- Expected Results:
  - User is logged out and sees login screen.
- Priority: High
- Type: Functional
- Platforms: Android, iOS

---

## 18. Security and Firestore Rules

### SEC-001 - User Data Isolation
- Preconditions: Two users A and B.
- Steps:
  1. Login as user A.
  2. Attempt to read or write user B profile data.
- Expected Results:
  - Access is denied by Firestore rules.
- Priority: High
- Type: Security
- Platforms: Android, iOS

### SEC-002 - Read-Only Bus and Driver Data
- Preconditions: Logged in user.
- Steps:
  1. Attempt to write to bus or driver documents.
- Expected Results:
  - Write is denied; read is allowed.
- Priority: High
- Type: Security
- Platforms: Android, iOS

### SEC-003 - Feedback Write and Update Rules
- Preconditions: Logged in user.
- Steps:
  1. Create feedback.
  2. Attempt to update another user feedback.
- Expected Results:
  - User can create own feedback; cannot update others.
- Priority: High
- Type: Security
- Platforms: Android, iOS

---

## 19. Offline and Resilience

### OFF-001 - App Launch Offline
- Preconditions: Device offline.
- Steps:
  1. Launch the app.
- Expected Results:
  - App shows offline handling message and does not crash.
- Priority: Medium
- Type: Resilience
- Platforms: Android, iOS

### OFF-002 - Firestore Cached Data
- Preconditions: User logged in and data previously loaded.
- Steps:
  1. Go offline.
  2. Open dashboard.
- Expected Results:
  - Cached data is shown where available.
- Priority: Medium
- Type: Resilience
- Platforms: Android, iOS

---

## 20. Performance and Accessibility

### PERF-001 - App Launch Time
- Preconditions: Normal network.
- Steps:
  1. Launch app and measure time to dashboard.
- Expected Results:
  - App reaches dashboard within acceptable target time.
- Priority: Low
- Type: Performance
- Platforms: Android, iOS

### PERF-002 - QR Scan Response Time
- Preconditions: Camera permission granted.
- Steps:
  1. Open QR scanner and scan a valid code.
- Expected Results:
  - QR recognition occurs within 2 seconds.
- Priority: Low
- Type: Performance
- Platforms: Android, iOS

### ACC-001 - Font Scaling
- Preconditions: System font size set to large.
- Steps:
  1. Open dashboard, profile, feedback.
- Expected Results:
  - Text remains readable and layout does not break.
- Priority: Low
- Type: Accessibility
- Platforms: Android, iOS

### ACC-002 - Color Contrast and Focus
- Preconditions: Default theme.
- Steps:
  1. Check form fields and buttons for contrast and focus states.
- Expected Results:
  - Fields and buttons remain readable and accessible.
- Priority: Low
- Type: Accessibility
- Platforms: Android, iOS


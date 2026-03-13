# Authentication Test Cases - SafeDriver Passenger App

**Module:** Authentication & Registration  
**Test Plan ID:** TP-SAFEDRIVER-001  
**Test Case Category:** TC-001  
**Created:** March 12, 2026  
**Framework:** Flutter Testing / Mockito  

---

## 📋 Test Case 001: Phone Number Registration via OTP

**Test Case ID:** TC-001-001  
**Test Type:** Functional Testing  
**Priority:** P0 - Critical  
**Status:** Ready  

### **Title**
Verify user can register using phone number with OTP verification

### **Description**
This test verifies the complete phone registration flow including phone input validation, OTP sending, OTP verification, and profile creation.

### **Preconditions**
- App is installed and running
- User is on the splash/login screen
- Internet connectivity is available
- SMS Text.lk gateway is configured in Firebase
- Firebase Authentication is functional

### **Test Steps**

• **Step 1:** Launch the SafeDriver app  
  Expected: Splash screen displays for 2-3 seconds, then navigates to login screen

• **Step 2:** Tap "Sign Up" button  
  Expected: Register page opens with phone number input field

• **Step 3:** Enter valid Sri Lankan phone number (e.g., +94701234567)  
  Expected: Phone number is displayed without formatting errors

• **Step 4:** Verify phone format validation shows no error  
  Expected: No error message displayed

• **Step 5:** Tap "Send OTP" button  
  Expected: Loading spinner appears, then success message "OTP sent successfully"

• **Step 6:** Wait for SMS  
  Expected: User receives SMS with 6-digit OTP within 60 seconds

• **Step 7:** Enter OTP in verification screen  
  Expected: OTP fields fill correctly with numeric input only

• **Step 8:** Tap "Verify OTP" button  
  Expected: OTP verification processes and profile creation screen appears

• **Step 9:** Enter personal details (name, email, etc.)  
  Expected: All fields accept input without errors

• **Step 10:** Tap "Complete Registration"  
  Expected: Account is created, user is logged in, dashboard displays

### **Expected Result**
- User account is successfully created in Firebase Authentication
- User profile is created in Firestore with all entered information
- User is redirected to dashboard
- "Welcome" notification is displayed
- User data is properly stored (verified in Firebase Console)

### **Actual Result**
[To be filled during execution]

### **Test Data**
- **Phone Number:** +94701234567  
- **Full Name:** John Doe  
- **Email:** john.doe@example.com  
- **Password:** SecurePass123!

### **Pass Criteria**
✅ Account created successfully  
✅ OTP verified  
✅ User logged in  
✅ Dashboard accessible  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

### **Defect (if any)**
[To be filled]

### **Notes & Observations**
[To be filled]

---

## 📋 Test Case 002: Email/Password Registration

**Test Case ID:** TC-001-002  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can register using email and password

### **Description**
This test verifies email-based registration with password creation, email validation, and account setup.

### **Preconditions**
- App is installed and running
- Firebase Authentication is configured for email/password
- User is on the login screen
- Internet connectivity available

### **Test Steps**

• **Step 1:** Tap "Sign Up" button  
  Expected: Register page with email option opens

• **Step 2:** Select "Email" registration option  
  Expected: Email and password fields display

• **Step 3:** Enter valid email (test@example.com)  
  Expected: Email field accepts input, no validation error

• **Step 4:** Enter weak password (123456)  
  Expected: Password displays masking, warning about weak password appears

• **Step 5:** Enter strong password (SecurePass123!)  
  Expected: Strength indicator shows "Strong"

• **Step 6:** Re-enter password confirmation  
  Expected: Both passwords match, no error

• **Step 7:** Tap "Register" button  
  Expected: Loading state appears, Account verification email is sent

• **Step 8:** Check email inbox  
  Expected: Verification email received with verification link

• **Step 9:** Tap verification link  
  Expected: Email is verified, success message shows

• **Step 10:** Return to app  
  Expected: User can now login with email and password

### **Expected Result**
- Email validation working correctly
- Password strength requirements enforced
- Account created in Firebase Authentication
- Verification email sent within 5 seconds
- Email verification link works and confirms account

### **Actual Result**
[To be filled]

### **Test Data**
- **Email:** testuser@safedriver.com
- **Password:** SecurePass@123456
- **Confirm Password:** SecurePass@123456

### **Pass Criteria**
✅ Account created  
✅ Email verified  
✅ User can login  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 003: Invalid Phone Number Validation

**Test Case ID:** TC-001-003  
**Test Type:** Negative Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify system rejects invalid phone number formats

### **Description**
This test verifies proper validation of phone number input to prevent registration with invalid numbers.

### **Preconditions**
- App is installed
- Register screen is open
- Phone number field is displayed

### **Test Steps**

• **Step 1:** Enter empty phone number  
  Expected: "Phone number is required" error displays

• **Step 2:** Enter less than 10 digits (94701)  
  Expected: "Phone number must be at least 10 digits" error shows

• **Step 3:** Enter alphabetic characters (9470ABC1234)  
  Expected: Only numeric characters accepted, letters ignored

• **Step 4:** Enter non-Sri Lankan format (14155552671)  
  Expected: Format validation error: "Please use Sri Lankan format (+94...)"

• **Step 5:** Tap "Send OTP" without valid number  
  Expected: Button remains disabled, error message persists

### **Expected Result**
- All invalid formats are properly rejected
- Appropriate error messages displayed for each scenario
- "Send OTP" button remains disabled until valid number entered
- No API calls made with invalid numbers

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Validation working correctly  
✅ User prevented from proceeding with invalid input  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 004: Forgot Password - Email Recovery

**Test Case ID:** TC-001-004  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can recover password via email reset link

### **Description**
This test verifies the forgot password functionality using email-based password reset.

### **Preconditions**
- User has an existing email-based account
- User is on the login screen
- Internet connectivity available
- Email service is functional

### **Test Steps**

• **Step 1:** Tap "Forgot Password?" on login screen  
  Expected: Forgot password page opens

• **Step 2:** Enter registered email  
  Expected: Email field accepts input

• **Step 3:** Tap "Send Reset Link" button  
  Expected: Loading spinner displays, then success message shown

• **Step 4:** Check email inbox  
  Expected: Password reset email received within 2 minutes

• **Step 5:** Tap reset link in email  
  Expected: Browser opens with password reset form

• **Step 6:** Enter new strong password  
  Expected: New password field accepts input

• **Step 7:** Confirm new password  
  Expected: Confirmation field matches new password

• **Step 8:** Tap "Reset Password"  
  Expected: Success message displays

• **Step 9:** Return to app login screen  
  Expected: Login with new password credentials

• **Step 10:** Attempt login with old password  
  Expected: Login fails with "Invalid credentials"

### **Expected Result**
- Password reset email sent successfully
- Reset link works and is valid for 24 hours
- New password is set in Firebase Authentication
- User can login with new password
- Old password no longer works

### **Actual Result**
[To be filled]

### **Test Data**
- **Email:** testuser@safedriver.com
- **New Password:** NewSecurePass@2026

### **Pass Criteria**
✅ Reset email sent  
✅ Link functional  
✅ Password changed  
✅ Login with new password works  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 005: OTP Resend Functionality

**Test Case ID:** TC-001-005  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can request to resend OTP if not received

### **Description**
This test verifies that users can request a new OTP if they don't receive it or it expires.

### **Preconditions**
- User is on OTP verification screen
- Initial OTP was sent
- User hasn't received SMS or OTP expired

### **Test Steps**

• **Step 1:** After 30 seconds on OTP screen  
  Expected: "Resend OTP" button becomes enabled

• **Step 2:** Tap "Resend OTP" button  
  Expected: Loading spinner displays

• **Step 3:** Wait for confirmation  
  Expected: Success message "New OTP sent to +94701234567" displays

• **Step 4:** Check SMS  
  Expected: New 6-digit OTP received

• **Step 5:** Enter new OTP  
  Expected: OTP verification processes successfully

• **Step 6:** Tap "Verify" button  
  Expected: User proceeds to next screen

• **Step 7:** Resend OTP 3 times (test rate limiting)  
  Expected: After 3 attempts, resend button shows "Wait 15 minutes"

### **Expected Result**
- New OTP sent successfully after 30 seconds
- Different OTP generated each time
- Previous OTP becomes invalid
- Rate limiting prevents abuse (max 3 resends per 15 minutes)
- User receives new OTP via SMS

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Resend functionality works  
✅ Rate limiting implemented  
✅ New OTP received  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 006: OTP Expiration

**Test Case ID:** TC-001-006  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify OTP expires after 10 minutes

### **Description**
This test verifies that OTP codes expire after a specified time period and user must request a new one.

### **Preconditions**
- OTP has been sent to user
- User is on OTP verification screen
- System can simulate time passage (or wait)

### **Test Steps**

• **Step 1:** OTP sent and received  
  Expected: User on OTP verification screen

• **Step 2:** Wait 9 minutes  
  Expected: Timer on screen counts down, "Resend OTP" remains disabled

• **Step 3:** After 10 minutes  
  Expected: "This OTP has expired. Request a new one" error displays

• **Step 4:** Try entering original OTP  
  Expected: "Invalid or expired OTP" error shows

• **Step 5:** Tap "Resend OTP"  
  Expected: New OTP is sent

• **Step 6:** Enter new OTP  
  Expected: Verification succeeds

### **Expected Result**
- OTP is valid for exactly 10 minutes
- After expiration, OTP cannot be used
- User is notified of expiration
- User can request new OTP after expiration
- New OTP works correctly

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ OTP expires correctly  
✅ User notified  
✅ New OTP works  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 007: Invalid OTP Input

**Test Case ID:** TC-001-007  
**Test Type:** Negative Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify system rejects invalid OTP codes

### **Description**
This test verifies OTP validation and prevents login with incorrect codes.

### **Preconditions**
- OTP has been sent
- User is on OTP verification screen
- Internet connectivity available

### **Test Steps**

• **Step 1:** Enter 5 digits (12345)  
  Expected: "Please enter all 6 digits" error displays

• **Step 2:** Enter 6 incorrect digits (000000)  
  Expected: "Invalid OTP" error displays after verification attempt

• **Step 3:** Attempt 5 incorrect OTPs  
  Expected: "Too many failed attempts. Please try again after 15 minutes"

• **Step 4:** Try entering letters (ABCDEF)  
  Expected: Only numeric input accepted, letters rejected

• **Step 5:** Enter correct OTP after being locked  
  Expected: "Please wait before trying again" message shows

### **Expected Result**
- Incorrect OTPs are rejected
- After 5 failed attempts, account is locked for 15 minutes
- Only numeric input accepted (6 digits)
- Error messages are clear and actionable
- No account is compromised

### **Actual Result**
[To be filled]

### **Test Data**
- **Valid OTP:** 123456 (example)
- **Invalid OTP 1:** 000000
- **Invalid OTP 2:** 111111
- **Invalid OTP 3:** 222222

### **Pass Criteria**
✅ Invalid OTPs rejected  
✅ Account locked after 5 attempts  
✅ Rate limiting working  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 008: Login with Valid Credentials

**Test Case ID:** TC-001-008  
**Test Type:** Functional Testing  
**Priority:** P0 - Critical  
**Status:** Ready

### **Title**
Verify user can successfully login with correct phone credentials

### **Description**
This test verifies the basic login flow with valid phone number and OTP.

### **Preconditions**
- User has registered account
- User is on login screen
- Internet connectivity available
- SMS gateway functional

### **Test Steps**

• **Step 1:** Enter registered phone number (+94701234567)  
  Expected: Phone number field accepts input

• **Step 2:** Tap "Send OTP"  
  Expected: Loading displays, "OTP sent successfully" message

• **Step 3:** Receive OTP  
  Expected: SMS received with 6-digit code

• **Step 4:** Enter OTP  
  Expected: OTP fields fill correctly

• **Step 5:** Tap "Login"  
  Expected: Loading displays for 2-3 seconds

• **Step 6:** Verify login  
  Expected: Dashboard displays, user logged in

• **Step 7:** Check session  
  Expected: User remains logged in after app restart

### **Expected Result**
- OTP sent and received correctly
- User logged in successfully
- Dashboard displays immediately
- User session persists
- User profile loads correctly

### **Actual Result**
[To be filled]

### **Test Data**
- **Phone:** +94701234567
- **OTP:** [Received via SMS]

### **Pass Criteria**
✅ Login successful  
✅ Dashboard accessible  
✅ Session persists  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 009: Login with Invalid Credentials

**Test Case ID:** TC-001-009  
**Test Type:** Negative Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify login is rejected with incorrect phone number

### **Description**
This test verifies that login fails when user enters wrong phone number.

### **Preconditions**
- User has registered account
- User is on login screen
- Internet connectivity available

### **Test Steps**

• **Step 1:** Enter non-registered phone number (+94702222222)  
  Expected: Phone field accepts input

• **Step 2:** Tap "Send OTP"  
  Expected: "Phone number not registered" error displays

• **Step 3:** Tap "Sign Up Instead"  
  Expected: Redirect to registration page

• **Step 4:** Return to login  
  Expected: Login screen displays again

• **Step 5:** Enter registered number  
  Expected: OTP sending works normally

### **Expected Result**
- System recognizes unregistered phone numbers
- Clear error message displayed
- User redirected to signup option
- No security information leaked

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Invalid credentials rejected  
✅ Error handling proper  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 010: Logout Functionality

**Test Case ID:** TC-001-010  
**Test Type:** Functional Testing  
**Priority:** P0 - Critical  
**Status:** Ready

### **Title**
Verify user can successfully logout from app

### **Description**
This test verifies the logout functionality and proper session cleanup.

### **Preconditions**
- User is logged in
- User is on dashboard or any authenticated screen
- Internet connectivity available

### **Test Steps**

• **Step 1:** Open user profile menu  
  Expected: Menu displays with logout option

• **Step 2:** Tap "Logout" button  
  Expected: Confirmation dialog appears: "Are you sure you want to sign out?"

• **Step 3:** Tap "Cancel"  
  Expected: Dialog closes, user remains logged in on dashboard

• **Step 4:** Open profile menu again  
  Expected: Tap logout again

• **Step 5:** Tap "Yes, Sign Out"  
  Expected: Loading spinner displays

• **Step 6:** Wait for logout  
  Expected: User redirected to login screen

• **Step 7:** Try accessing dashboard URL  
  Expected: User redirected to login screen

• **Step 8:** Restart app  
  Expected: App starts at login screen (session cleared)

### **Expected Result**
- Logout confirmation dialog displayed
- Session is cleared from device
- User redirected to login screen
- No cached authentication data remains
- User must re-login to access app

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Logout successful  
✅ Session cleared  
✅ Redirect to login  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 011: Session Timeout

**Test Case ID:** TC-001-011  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user is logged out after 30 minutes of inactivity

### **Description**
This test verifies that inactive sessions automatically expire for security.

### **Preconditions**
- User is logged in
- User session timeout is set to 30 minutes
- System time can be manipulated (or wait 30+ minutes)

### **Test Steps**

• **Step 1:** User logs in  
  Expected: Dashboard displays

• **Step 2:** Leave app inactive for 30 minutes  
  Expected: No user interaction

• **Step 3:** After 30 minutes  
  Expected: User session expires silently

• **Step 4:** Try to navigate or use app  
  Expected: "Your session has expired. Please login again" message

• **Step 5:** Tap "Login Again"  
  Expected: User redirected to login screen

• **Step 6:** App restart after timeout  
  Expected: Login screen displayed (not dashboard)

### **Expected Result**
- Session automatically expires after 30 minutes of inactivity
- User is logged out
- User receives notification of expiration
- All sensitive data is cleared
- User must re-authenticate

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Session timeout working  
✅ User logged out  
✅ User notified  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 012: Biometric Authentication (Fingerprint)

**Test Case ID:** TC-001-012  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify user can login using fingerprint authentication

### **Description**
This test verifies fingerprint authentication on supported devices.

### **Preconditions**
- Device has fingerprint sensor
- Fingerprint is enrolled on device (Settings)
- User has registered account
- Biometric login is enabled in app settings

### **Test Steps**

• **Step 1:** Enable biometric login in settings  
  Expected: Toggle switch turns on

• **Step 2:** Exit and return to login screen  
  Expected: "Use Fingerprint" button appears

• **Step 3:** Tap "Use Fingerprint"  
  Expected: Device fingerprint dialog appears requesting fingerprint

• **Step 4:** Scan fingerprint (matching enrolled)  
  Expected: Fingerprint recognized, user logged in

• **Step 5:** Dashboard displays  
  Expected: User authenticated successfully

• **Step 6:** Logout and return to login  
  Expected: "Use Fingerprint" button available again

• **Step 7:** Attempt with wrong fingerprint  
  Expected: "Fingerprint not recognized" message, dialog remains

• **Step 8:** Try again with correct fingerprint  
  Expected: Authentication succeeds

### **Expected Result**
- Biometric login enabled in settings
- Fingerprint authentication works on compatible devices
- Successful fingerprint login bypasses OTP
- Wrong fingerprint is rejected
- User can still use OTP as fallback
- Biometric data is secure (handled by OS)

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Biometric login working  
✅ Security maintained  
✅ Fallback available  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 013: Face ID Authentication (iOS)

**Test Case ID:** TC-001-013  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify user can login using Face ID on iOS devices

### **Description**
This test verifies Face ID authentication on iOS devices with face recognition.

### **Preconditions**
- Device is iOS with Face ID capability
- Face ID is enrolled (Settings → Face ID & Passcode)
- User has registered account
- Face ID login enabled in app settings

### **Test Steps**

• **Step 1:** Open app on iOS Face ID device  
  Expected: Login screen displays

• **Step 2:** Enable Face ID login in settings  
  Expected: Face ID authentication option enabled

• **Step 3:** Return to login screen  
  Expected: "Use Face ID" button visible

• **Step 4:** Tap "Use Face ID"  
  Expected: Face ID dialog appears with prompt

• **Step 5:** Look at device (Face ID scan)  
  Expected: Face recognized, user logged in automatically

• **Step 6:** Dashboard displays  
  Expected: User authenticated successfully

• **Step 7:** Try with attention not required  
  Expected: Face ID recognizes with camera pointed at face

• **Step 8:** Try with sunglasses  
  Expected: Face ID may still work depending on sensor quality

### **Expected Result**
- Face ID authentication available on compatible iOS devices
- Face ID dialog appears when requested
- Recognized face logs user in
- Unrecognized faces rejected
- Fallback to OTP available
- Face ID handled securely by iOS

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Face ID working  
✅ Secure authentication  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 014: Social Login - Google Sign-In

**Test Case ID:** TC-001-014  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify user can register and login using Google account

### **Description**
This test verifies Google Sign-In integration for social authentication.

### **Preconditions**
- Google login is configured in Firebase
- User has Google account
- Device has Google Play Services installed
- Internet connectivity available

### **Test Steps**

• **Step 1:** On login screen, tap "Sign in with Google"  
  Expected: Google account picker dialog appears

• **Step 2:** Select Google account  
  Expected: Account selected and dialog closes

• **Step 3:** Grant app permissions  
  Expected: "Google Sign-In" permissions requested if first time

• **Step 4:** Accept permissions  
  Expected: User logged in, redirected to profile setup (if first time)

• **Step 5:** Enter passenger details  
  Expected: Profile form displays for additional information

• **Step 6:** Complete profile setup  
  Expected: Dashboard displays

• **Step 7:** Logout and login again  
  Expected: "Sign in with Google" available

• **Step 8:** Tap Google sign-in again  
  Expected: Automatically logs in with same account (no account picker)

### **Expected Result**
- Google Sign-In works seamlessly
- User account created/linked with Google account
- Profile setup completed
- User data stored in Firestore
- Future logins are quick (using cached credentials)
- Social login securely handled

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Google Sign-In working  
✅ Account created  
✅ Profile setup complete  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 015: Two-Factor Authentication (2FA)

**Test Case ID:** TC-001-015  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify Two-Factor Authentication can be enabled for account security

### **Description**
This test verifies that users can enable 2FA for additional account security.

### **Preconditions**
- User is logged in
- User has access to settings
- 2FA feature is available in app
- User has authenticator app installed (Google Authenticator, Microsoft Authenticator)

### **Test Steps**

• **Step 1:** Go to Settings → Security  
  Expected: Security options displayed

• **Step 2:** Tap "Enable Two-Factor Authentication"  
  Expected: 2FA setup wizard starts

• **Step 3:** Select authentication method  
  Expected: Options: Authenticator App or SMS

• **Step 4:** Choose "Authenticator App"  
  Expected: QR code displays for scanning

• **Step 5:** Scan QR code with authenticator app  
  Expected: Authenticator app shows 6-digit code

• **Step 6:** Enter 6-digit code from authenticator  
  Expected: Code accepted, 2FA enabled

• **Step 7:** Logout and login again  
  Expected: After OTP verification, 2FA code requested

• **Step 8:** Enter 2FA code from authenticator  
  Expected: User logged in successfully

### **Expected Result**
- 2FA setup completed successfully
- QR code scans into authenticator app
- Time-based OTP codes work correctly
- 2FA required on login
- Backup codes provided
- User account is more secure

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ 2FA enabled  
✅ Authenticator code works  
✅ Login requires 2FA  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

**Total Test Cases in Module:** 15  
**All steps formatted as bullet points for easy GitHub copy-paste**  
**Last Updated:** March 12, 2026

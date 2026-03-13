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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Launch the SafeDriver app | Splash screen displays for 2-3 seconds, then navigates to login screen |
| 2 | Tap "Sign Up" button | Register page opens with phone number input field |
| 3 | Enter valid Sri Lankan phone number (e.g., +94701234567) | Phone number is displayed without formatting errors |
| 4 | Verify phone format validation shows no error | No error message displayed |
| 5 | Tap "Send OTP" button | Loading spinner appears, then success message "OTP sent successfully" |
| 6 | Wait for SMS | User receives SMS with 6-digit OTP within 60 seconds |
| 7 | Enter OTP in verification screen | OTP fields fill correctly with numeric input only |
| 8 | Tap "Verify OTP" button | OTP verification processes and profile creation screen appears |
| 9 | Enter personal details (name, email, etc.) | All fields accept input without errors |
| 10 | Tap "Complete Registration" | Account is created, user is logged in, dashboard displays |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "Sign Up" button | Register page with email option opens |
| 2 | Select "Email" registration option | Email and password fields display |
| 3 | Enter valid email (test@example.com) | Email field accepts input, no validation error |
| 4 | Enter weak password (123456) | Password displays masking, warning about weak password appears |
| 5 | Enter strong password (SecurePass123!) | Strength indicator shows "Strong" |
| 6 | Re-enter password confirmation | Both passwords match, no error |
| 7 | Tap "Register" button | Loading state appears, Account verification email is sent |
| 8 | Check email inbox | Verification email received with verification link |
| 9 | Tap verification link | Email is verified, success message shows |
| 10 | Return to app | User can now login with email and password |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter empty phone number | "Phone number is required" error displays |
| 2 | Enter less than 10 digits (94701) | "Phone number must be at least 10 digits" error shows |
| 3 | Enter alphabetic characters (9470ABC1234) | Only numeric characters accepted, letters ignored |
| 4 | Enter non-Sri Lankan format (14155552671) | Format validation error: "Please use Sri Lankan format (+94...)" |
| 5 | Tap "Send OTP" without valid number | Button remains disabled, error message persists |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "Forgot Password?" on login screen | Forgot password page opens |
| 2 | Enter registered email | Email field accepts input |
| 3 | Tap "Send Reset Link" button | Loading spinner displays, then success message shown |
| 4 | Check email inbox | Password reset email received within 2 minutes |
| 5 | Tap reset link in email | Browser opens with password reset form |
| 6 | Enter new strong password | New password field accepts input |
| 7 | Confirm new password | Confirmation field matches new password |
| 8 | Tap "Reset Password" | Success message displays |
| 9 | Return to app login screen | Login with new password credentials |
| 10 | Attempt login with old password | Login fails with "Invalid credentials" |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | After 30 seconds on OTP screen | "Resend OTP" button becomes enabled |
| 2 | Tap "Resend OTP" button | Loading spinner displays |
| 3 | Wait for confirmation | Success message "New OTP sent to +94701234567" displays |
| 4 | Check SMS | New 6-digit OTP received |
| 5 | Enter new OTP | OTP verification processes successfully |
| 6 | Tap "Verify" button | User proceeds to next screen |
| 7 | Resend OTP 3 times (test rate limiting) | After 3 attempts, resend button shows "Wait 15 minutes" |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | OTP sent and received | User on OTP verification screen |
| 2 | Wait 9 minutes | Timer on screen counts down, "Resend OTP" remains disabled |
| 3 | After 10 minutes | "This OTP has expired. Request a new one" error displays |
| 4 | Try entering original OTP | "Invalid or expired OTP" error shows |
| 5 | Tap "Resend OTP" | New OTP is sent |
| 6 | Enter new OTP | Verification succeeds |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter 5 digits (12345) | "Please enter all 6 digits" error displays |
| 2 | Enter 6 incorrect digits (000000) | "Invalid OTP" error displays after verification attempt |
| 3 | Attempt 5 incorrect OTPs | "Too many failed attempts. Please try again after 15 minutes" |
| 4 | Try entering letters (ABCDEF) | Only numeric input accepted, letters rejected |
| 5 | Enter correct OTP after being locked | "Please wait before trying again" message shows |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter registered phone number (+94701234567) | Phone number field accepts input |
| 2 | Tap "Send OTP" | Loading displays, "OTP sent successfully" message |
| 3 | Receive OTP | SMS received with 6-digit code |
| 4 | Enter OTP | OTP fields fill correctly |
| 5 | Tap "Login" | Loading displays for 2-3 seconds |
| 6 | Verify login | Dashboard displays, user logged in |
| 7 | Check session | User remains logged in after app restart |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter non-registered phone number (+94702222222) | Phone field accepts input |
| 2 | Tap "Send OTP" | "Phone number not registered" error displays |
| 3 | Tap "Sign Up Instead" | Redirect to registration page |
| 4 | Return to login | Login screen displays again |
| 5 | Enter registered number | OTP sending works normally |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Open user profile menu | Menu displays with logout option |
| 2 | Tap "Logout" button | Confirmation dialog appears: "Are you sure you want to sign out?" |
| 3 | Tap "Cancel" | Dialog closes, user remains logged in on dashboard |
| 4 | Open profile menu again | Tap logout again |
| 5 | Tap "Yes, Sign Out" | Loading spinner displays |
| 6 | Wait for logout | User redirected to login screen |
| 7 | Try accessing dashboard URL | User redirected to login screen |
| 8 | Restart app | App starts at login screen (session cleared) |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | User logs in | Dashboard displays |
| 2 | Leave app inactive for 30 minutes | No user interaction |
| 3 | After 30 minutes | User session expires silently |
| 4 | Try to navigate or use app | "Your session has expired. Please login again" message |
| 5 | Tap "Login Again" | User redirected to login screen |
| 6 | App restart after timeout | Login screen displayed (not dashboard) |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enable biometric login in settings | Toggle switch turns on |
| 2 | Exit and return to login screen | "Use Fingerprint" button appears |
| 3 | Tap "Use Fingerprint" | Device fingerprint dialog appears requesting fingerprint |
| 4 | Scan fingerprint (matching enrolled) | Fingerprint recognized, user logged in |
| 5 | Dashboard displays | User authenticated successfully |
| 6 | Logout and return to login | "Use Fingerprint" button available again |
| 7 | Attempt with wrong fingerprint | "Fingerprint not recognized" message, dialog remains |
| 8 | Try again with correct fingerprint | Authentication succeeds |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Open app on iOS Face ID device | Login screen displays |
| 2 | Enable Face ID login in settings | Face ID authentication option enabled |
| 3 | Return to login screen | "Use Face ID" button visible |
| 4 | Tap "Use Face ID" | Face ID dialog appears with prompt |
| 5 | Look at device (Face ID scan) | Face recognized, user logged in automatically |
| 6 | Dashboard displays | User authenticated successfully |
| 7 | Try with attention not required | Face ID recognizes with camera pointed at face |
| 8 | Try with sunglasses | Face ID may still work depending on sensor quality |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | On login screen, tap "Sign in with Google" | Google account picker dialog appears |
| 2 | Select Google account | Account selected and dialog closes |
| 3 | Grant app permissions | "Google Sign-In" permissions requested if first time |
| 4 | Accept permissions | User logged in, redirected to profile setup (if first time) |
| 5 | Enter passenger details | Profile form displays for additional information |
| 6 | Complete profile setup | Dashboard displays |
| 7 | Logout and login again | "Sign in with Google" available |
| 8 | Tap Google sign-in again | Automatically logs in with same account (no account picker) |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Go to Settings → Security | Security options displayed |
| 2 | Tap "Enable Two-Factor Authentication" | 2FA setup wizard starts |
| 3 | Select authentication method | Options: Authenticator App or SMS |
| 4 | Choose "Authenticator App" | QR code displays for scanning |
| 5 | Scan QR code with authenticator app | Code appears in authenticator app |
| 6 | Enter 6-digit code from app | Code validated, 2FA enabled |
| 7 | Save backup codes | User can save emergency recovery codes |
| 8 | Next login attempt | After password entry, 2FA code requested |
| 9 | Enter code from authenticator | Login proceeds to dashboard |
| 10 | Disable 2FA | Option available with account verification |

### **Expected Result**
- 2FA can be enabled in settings
- QR code scans correctly in authenticator app
- 6-digit code required for login after enabling 2FA
- Backup codes provided for account recovery
- 2FA can be disabled by user
- 2FA adds security layer to account

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ 2FA enabled  
✅ Login verification works  
✅ Backup codes provided  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📊 Test Execution Summary - Authentication

| TC ID | Title | Status | Pass | Fail | Blocked | Notes |
|-------|-------|--------|------|------|---------|-------|
| TC-001-001 | Phone OTP Registration | | [ ] | [ ] | [ ] | |
| TC-001-002 | Email/Password Registration | | [ ] | [ ] | [ ] | |
| TC-001-003 | Invalid Phone Validation | | [ ] | [ ] | [ ] | |
| TC-001-004 | Forgot Password Email | | [ ] | [ ] | [ ] | |
| TC-001-005 | OTP Resend | | [ ] | [ ] | [ ] | |
| TC-001-006 | OTP Expiration | | [ ] | [ ] | [ ] | |
| TC-001-007 | Invalid OTP Input | | [ ] | [ ] | [ ] | |
| TC-001-008 | Login Valid Credentials | | [ ] | [ ] | [ ] | |
| TC-001-009 | Login Invalid Credentials | | [ ] | [ ] | [ ] | |
| TC-001-010 | Logout Functionality | | [ ] | [ ] | [ ] | |
| TC-001-011 | Session Timeout | | [ ] | [ ] | [ ] | |
| TC-001-012 | Fingerprint Auth | | [ ] | [ ] | [ ] | |
| TC-001-013 | Face ID Auth | | [ ] | [ ] | [ ] | |
| TC-001-014 | Google Sign-In | | [ ] | [ ] | [ ] | |
| TC-001-015 | Two-Factor Auth | | [ ] | [ ] | [ ] | |

**Total:** 15 Test Cases | **Passed:** [ ] | **Failed:** [ ] | **Blocked:** [ ]  
**Pass Rate:** ____%

---

## 📝 Notes

### Known Issues
- (To be filled during testing)

### Observations
- (To be filled during testing)

### Recommendations
- (To be filled after testing)

---

**Test Module Created:** March 12, 2026  
**Last Updated:** March 12, 2026  
**Test Engineer:** QA Team

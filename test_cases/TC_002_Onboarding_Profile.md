# Onboarding & Profile Test Cases - SafeDriver Passenger App

**Module:** Onboarding, Language Selection & User Profile  
**Test Plan ID:** TP-SAFEDRIVER-001  
**Test Case Category:** TC-002  
**Created:** March 12, 2026  

---

## 📋 Test Case 016: Language Selection on First Launch

**Test Case ID:** TC-002-001  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can select language on first app launch

### **Description**
This test verifies the language selection interface appears for first-time users and language preference is saved.

### **Preconditions**
- App is freshly installed (or app data cleared)
- Device language may be any supported language
- App support languages: English, Sinhala, Tamil

### **Test Steps**

• **Step 1:** Launch app for first time
  Expected: Splash screen displays briefly
• **Step 2:** Wait for splash
  Expected: Language selection screen appears automatically
• **Step 3:** Screen displays
  Expected: 3 language options visible: English, Sinhala (සිංහල), Tamil (தமிழ்)
• **Step 4:** Tap "English"
  Expected: Language is selected (visual indicator shows selection)
• **Step 5:** Tap "Continue"
  Expected: Onboarding screen loads with English content
• **Step 6:** Verify text
  Expected: All text is in English (buttons, labels, descriptions)
• **Step 7:** Close app completely
  Expected: Remove from recent apps
• **Step 8:** Reopen app
  Expected: Onboarding/Dashboard displays in English (language preference saved)
• **Step 9:** Switch language to Sinhala
  Expected: Settings → Language: select Sinhala
• **Step 10:** Verify all text
  Expected: App UI updates to Sinhala immediately

### **Expected Result**
- Language selection screen displays on first launch
- All three languages available for selection
- Language preference is saved to device storage
- Entire app UI translates to selected language
- Language persists across app restarts
- Language can be changed in settings

### **Actual Result**
[To be filled]

### **Test Data**
- **Languages:** English, Sinhala, Tamil
- **Device Locale:** Can be any

### **Pass Criteria**
✅ Language selection works  
✅ Preference saved  
✅ UI translates correctly  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 017: Onboarding Screen Navigation

**Test Case ID:** TC-002-002  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can navigate through onboarding screens

### **Description**
This test verifies the onboarding flow with multiple screens showing app features.

### **Preconditions**
- User has selected language
- First-time user or onboarding not skipped before
- App is running

### **Test Steps**

• **Step 1:** Language selected
  Expected: Onboarding Screen 1 appears with app introduction
• **Step 2:** View Screen 1 content
  Expected: Title, description, and "Next" button displayed
• **Step 3:** Tap "Next" button
  Expected: Smooth transition to Screen 2
• **Step 4:** Verify Screen 2
  Expected: New content displays (different feature explanation)
• **Step 5:** Tap "Next" again
  Expected: Transitions to Screen 3
• **Step 6:** Verify Screen 3
  Expected: Final onboarding screen with "Get Started" button
• **Step 7:** Swipe left on Screen 2
  Expected: Transitions to Screen 3 (gesture navigation)
• **Step 8:** Swipe right on Screen 2
  Expected: Transitions back to Screen 1
• **Step 9:** Tap "Skip" (if available)
  Expected: Bypasses remaining screens and goes to login
• **Step 10:** Tap "Get Started" on Screen 3
  Expected: Navigates to login screen

### **Expected Result**
- Onboarding contains 3 screens with engaging content
- Navigation works with buttons and swipe gestures
- All screens display correctly without layout issues
- Text and images are clear and properly sized
- Skip option available on earlier screens
- Last screen has "Get Started" button
- Transitions are smooth

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Navigation smooth  
✅ All screens display  
✅ Gestures work  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 018: Profile Information Display

**Test Case ID:** TC-002-003  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user profile information displays correctly

### **Description**
This test verifies the user profile page shows all personal information accurately.

### **Preconditions**
- User is logged in
- User has completed profile during registration
- Internet connectivity available

### **Test Steps**

• **Step 1:** Tap profile icon on dashboard
  Expected: Navigation to profile page
• **Step 2:** Profile page loads
  Expected: User's profile information displays
• **Step 3:** View personal information
  Expected: Shows: Name, Email, Phone, Date of Birth, Gender
• **Step 4:** Check profile picture
  Expected: User's profile image (if uploaded) displays
• **Step 5:** View membership info
  Expected: Shows membership level, join date
• **Step 6:** View achievements
  Expected: Displays badges/awards earned
• **Step 7:** View statistics
  Expected: Shows trips taken, average rating, feedback count
• **Step 8:** Scroll down
  Expected: Additional information sections visible
• **Step 9:** Verify data accuracy
  Expected: All information matches registered data
• **Step 10:** Check last updated time
  Expected: "Last updated: [date/time]" displayed

### **Expected Result**
- Profile page loads within 2 seconds
- All user information displays accurately
- Profile picture is clear and properly sized
- Statistics calculate correctly
- Layout is organized and readable
- No missing or corrupted data

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Profile displays  
✅ Data accurate  
✅ Layout proper  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 019: Edit Personal Information

**Test Case ID:** TC-002-004  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can edit personal information in profile

### **Description**
This test verifies that users can update their profile information.

### **Preconditions**
- User is logged in and on profile page
- User has access to edit profile feature
- Internet connectivity available

### **Test Steps**

• **Step 1:** Tap "Edit Profile" button
  Expected: Edit form opens with current information prefilled
• **Step 2:** Clear first name field
  Expected: Field becomes empty
• **Step 3:** Enter new first name
  Expected: New name displays in field
• **Step 4:** Edit email address
  Expected: Email field editable only if not email-based login
• **Step 5:** Change phone number
  Expected: Phone field shows current number
• **Step 6:** Update date of birth
  Expected: Calendar picker opens for selection
• **Step 7:** Select new date
  Expected: Date updates in field
• **Step 8:** Change profile picture
  Expected: Image picker opens to select new photo
• **Step 9:** Select photo from gallery
  Expected: Image preview displays
• **Step 10:** Tap "Save Changes"
  Expected: Loading displays, update completes
• **Step 11:** Confirmation message
  Expected: "Profile updated successfully" notification
• **Step 12:** Return to profile
  Expected: Updated information displays
• **Step 13:** Refresh page
  Expected: Data persists (saved to database)

### **Expected Result**
- Edit form accessible from profile page
- All editable fields are functional
- Image upload works with preview
- Changes saved to Firestore
- User receives confirmation notification
- Updated data displays correctly
- Changes persist after refresh/logout

### **Actual Result**
[To be filled]

### **Test Data**
- **New First Name:** John
- **New Email:** john.updated@safedriver.com
- **New DOB:** 1995-05-15
- **New Picture:** [test_image.jpg]

### **Pass Criteria**
✅ Edit functionality works  
✅ Changes saved  
✅ Confirmation shown  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 020: Profile Picture Upload

**Test Case ID:** TC-002-005  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can upload a profile picture

### **Description**
This test verifies profile picture upload from gallery and camera.

### **Preconditions**
- User on edit profile page
- User has gallery access
- User device has camera
- File upload permissions granted

### **Test Steps**

• **Step 1:** Tap on profile picture area
  Expected: Image picker options appear
• **Step 2:** Tap "Choose from Gallery"
  Expected: Gallery app opens
• **Step 3:** Select image
  Expected: Selected image displays in preview
• **Step 4:** Tap "Use this image"
  Expected: Returns to edit form with image preview
• **Step 5:** Verify image size
  Expected: Image resized appropriately (not larger than 5MB)
• **Step 6:** Tap "Save"
  Expected: Loading displays while uploading to Firebase Storage
• **Step 7:** Wait for upload
  Expected: Upload completes within 30 seconds
• **Step 8:** Success message
  Expected: "Profile picture updated" notification
• **Step 9:** Check profile page
  Expected: New picture displays on profile (next time opened)
• **Step 10:** Try uploading very large file > 5MB
  Expected: "File too large" error displays, upload prevented
• **Step 11:** Take photo option
  Expected: Option to take new photo with camera
• **Step 12:** Tap "Take Photo"
  Expected: Camera opens in capture mode

### **Expected Result**
- Image picker opens with gallery/camera options
- Selected image uploads successfully
- File size limits enforced (max 5MB)
- Upload progress indicator shows
- Image displays on profile after upload
- Camera capture option available
- Upload handles network interruptions gracefully

### **Actual Result**
[To be filled]

### **Test Data**
- **Small Image:** test_profile_small.jpg (2MB)
- **Large Image:** test_profile_large.jpg (8MB - should fail)
- **Unsupported Format:** test_file.txt

### **Pass Criteria**
✅ Upload works  
✅ File limits enforced  
✅ Image displays on profile  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 021: Change Password

**Test Case ID:** TC-002-006  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can change their password securely

### **Description**
This test verifies the change password functionality with validation.

### **Preconditions**
- User has email-based account (not phone-only)
- User is logged in
- User is in settings or profile area

### **Test Steps**

• **Step 1:** Navigate to Settings
  Expected: Settings page displays
• **Step 2:** Tap "Change Password"
  Expected: Change password form appears
• **Step 3:** Enter current password (wrong)
  Expected: Current password field accepts input
• **Step 4:** Tap "Verify"
  Expected: "Incorrect password" error displays
• **Step 5:** Enter correct current password
  Expected: Verification succeeds
• **Step 6:** Enter new weak password (123456)
  Expected: "Password too weak" warning displays
• **Step 7:** Enter strong new password
  Expected: Password strength meter shows "Strong"
• **Step 8:** Confirm password field mismatch
  Expected: "Passwords don't match" error shows
• **Step 9:** Enter matching confirmation
  Expected: Confirmation matches new password
• **Step 10:** Tap "Change Password"
  Expected: Loading displays, update processes
• **Step 11:** Success notification
  Expected: "Password changed successfully"
• **Step 12:** Logout and login with old password
  Expected: Login fails with "Invalid credentials"
• **Step 13:** Login with new password
  Expected: Login succeeds, dashboard displays

### **Expected Result**
- Current password required for security
- Password strength requirements enforced
- New password must be strong (min 8 chars, mixed case, numbers, special chars)
- Confirmation matching required
- Old password no longer works after change
- New password works immediately
- User notified of change

### **Actual Result**
[To be filled]

### **Test Data**
- **Current Password:** OldPass@2024
- **New Password:** NewSecurePass@2026
- **Weak Password:** 123456

### **Pass Criteria**
✅ Password changed  
✅ Validation working  
✅ Old password invalid  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 022: Emergency Contact Management

**Test Case ID:** TC-002-007  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can add and manage emergency contacts

### **Description**
This test verifies adding, editing, and removing emergency contacts for safety features.

### **Preconditions**
- User is logged in
- User is in profile or settings
- User has contacts on device

### **Test Steps**

• **Step 1:** Go to Settings → Emergency Contacts
  Expected: Emergency contacts list displays
• **Step 2:** Tap "Add Emergency Contact"
  Expected: Contact form opens
• **Step 3:** Enter contact name (Mother)
  Expected: Name field accepts text input
• **Step 4:** Enter phone number
  Expected: Phone field accepts valid format
• **Step 5:** Select relationship (Mother/Father/Friend/Other)
  Expected: Dropdown list displays relation options
• **Step 6:** Tap "Save"
  Expected: Contact added to list, success message shown
• **Step 7:** Add second contact
  Expected: "Add another contact" option available
• **Step 8:** Add up to 5 contacts
  Expected: Maximum 5 emergency contacts
• **Step 9:** Try adding 6th contact
  Expected: "Maximum contacts reached" message displays
• **Step 10:** Edit existing contact
  Expected: Edit button available, form prefilled with current data
• **Step 11:** Change contact phone number
  Expected: Updates successfully
• **Step 12:** Delete contact
  Expected: "Delete" button available, confirmation dialog appears
• **Step 13:** Confirm deletion
  Expected: Contact removed from list

### **Expected Result**
- Users can add up to 5 emergency contacts
- Contact information includes name, phone, relationship
- Contacts are editable
- Contacts can be deleted with confirmation
- Contact list persists after logout/login
- Contacts are used in emergency features

### **Actual Result**
[To be filled]

### **Test Data**
- **Contact 1:** Name: Mother, Phone: +94771234567, Relation: Mother
- **Contact 2:** Name: Best Friend, Phone: +94701234567, Relation: Friend
- **Contact 3:** Name: Doctor, Phone: +94112334455, Relation: Other

### **Pass Criteria**
✅ Contacts added  
✅ Edited successfully  
✅ Deleted confirmed  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 023: Privacy Preferences Management

**Test Case ID:** TC-002-008  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can manage privacy preferences

### **Description**
This test verifies users can control what data is shared and how.

### **Preconditions**
- User is logged in
- User in Settings → Privacy
- User has accepted initial privacy policy

### **Test Steps**

• **Step 1:** Navigate to Settings → Privacy
  Expected: Privacy preferences page displays
• **Step 2:** View privacy options
  Expected: Options displayed: Location Sharing, Analytics, Marketing
• **Step 3:** Toggle "Share Location"
  Expected: Toggle switches on/off with visual feedback
• **Step 4:** Check current state
  Expected: Toggle shows current preference (ON/OFF)
• **Step 5:** Disable location sharing
  Expected: "Location Sharing Disabled" message
• **Step 6:** Toggle "Personalized Analytics"
  Expected: Affects data collection settings
• **Step 7:** Toggle "Marketing Emails"
  Expected: Controls email marketing opt-in
• **Step 8:** View "Data Collection" details
  Expected: Shows what data is collected
• **Step 9:** Tap "Download My Data"
  Expected: ZIP file begins downloading with personal data
• **Step 10:** Tap "Request Data Deletion"
  Expected: Confirmation dialog appears warning of permanent deletion
• **Step 11:** Cancel deletion
  Expected: User returns to privacy settings
• **Step 12:** Preferences saved
  Expected: Settings persist on app restart

### **Expected Result**
- All privacy preferences are toggleable
- Changes save immediately
- User can download personal data
- Data deletion option available with warnings
- Privacy settings respected app-wide
- Settings persist across sessions

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Privacy controls work  
✅ Preferences saved  
✅ Data options available  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 024: Notification Preferences

**Test Case ID:** TC-002-009  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can configure notification preferences

### **Description**
This test verifies notification settings and delivery options.

### **Preconditions**
- User is logged in
- User in Settings → Notifications
- Push notifications enabled on device

### **Test Steps**

• **Step 1:** Navigate to Settings → Notifications
  Expected: Notification preferences page
• **Step 2:** View notification types
  Expected: Options: Safety Alerts, Feedback Replies, Promotions, Updates
• **Step 3:** Toggle "Safety Alerts"
  Expected: Can enable/disable critical safety notifications
• **Step 4:** Toggle "Feedback Replies"
  Expected: Notifications when feedback receives response
• **Step 5:** Toggle "Promotional Offers"
  Expected: Controls marketing notifications
• **Step 6:** Toggle "App Updates"
  Expected: Notifications for app version updates
• **Step 7:** Set notification quiet hours
  Expected: Option to set "Do Not Disturb" time range (e.g., 10 PM - 8 AM)
• **Step 8:** Configure sound
  Expected: Option to enable/disable notification sound
• **Step 9:** Configure vibration
  Expected: Option to enable/disable vibration
• **Step 10:** Test notification (if available)
  Expected: Send test notification to verify settings
• **Step 11:** Verify quiet hours work
  Expected: Notifications muted during quiet hours
• **Step 12:** Preferences saved automatically
  Expected: Settings persist without explicit save

### **Expected Result**
- Users can manage each notification type independently
- Quiet hours can be set
- Sound and vibration toggles work
- Settings respected by notification system
- Test notification feature available
- Settings persist across sessions

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Preferences configured  
✅ Settings respected  
✅ Quiet hours work  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 025: Account Information Verification

**Test Case ID:** TC-002-010  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify account information is correct and complete

### **Description**
This test verifies that all account details match what user registered with.

### **Preconditions**
- User is logged in
- User on profile/account information page
- User has completed registration

### **Test Steps**

• **Step 1:** View account information
  Expected: Account details section displays
• **Step 2:** Check account creation date
  Expected: Shows date when account was created
• **Step 3:** Check registered email
  Expected: Displays correct email address
• **Step 4:** Check registered phone
  Expected: Shows phone number used for registration
• **Step 5:** Check membership status
  Expected: Shows active/inactive status
• **Step 6:** Check account type
  Expected: Shows if phone-based or email-based
• **Step 7:** Check last login
  Expected: Shows last successful login date and time
• **Step 8:** Verify all fields mandatory
  Expected: All required fields have values
• **Step 9:** Check account verification status
  Expected: Shows verified/unverified status
• **Step 10:** View activity log
  Expected: Shows recent account activities

### **Expected Result**
- All account information displays accurately
- Shows account creation date
- Shows all registration details
- Membership status clear
- Last login tracked
- Activity log shows recent logins
- No missing required information

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ All info displays  
✅ Data accurate  
✅ Status clear  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📊 Test Execution Summary - Onboarding & Profile

| TC ID | Title | Status | Pass | Fail | Blocked | Notes |
|-------|-------|--------|------|------|---------|-------|
| TC-002-001 | Language Selection | | [ ] | [ ] | [ ] | |
| TC-002-002 | Onboarding Navigation | | [ ] | [ ] | [ ] | |
| TC-002-003 | Profile Display | | [ ] | [ ] | [ ] | |
| TC-002-004 | Edit Profile | | [ ] | [ ] | [ ] | |
| TC-002-005 | Profile Picture Upload | | [ ] | [ ] | [ ] | |
| TC-002-006 | Change Password | | [ ] | [ ] | [ ] | |
| TC-002-007 | Emergency Contacts | | [ ] | [ ] | [ ] | |
| TC-002-008 | Privacy Preferences | | [ ] | [ ] | [ ] | |
| TC-002-009 | Notification Preferences | | [ ] | [ ] | [ ] | |
| TC-002-010 | Account Information | | [ ] | [ ] | [ ] | |

**Total:** 10 Test Cases | **Passed:** [ ] | **Failed:** [ ] | **Blocked:** [ ]  
**Pass Rate:** ____%

---

**Test Module Created:** March 12, 2026  
**Last Updated:** March 12, 2026

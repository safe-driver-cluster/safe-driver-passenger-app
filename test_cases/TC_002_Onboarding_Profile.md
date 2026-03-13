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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Launch app for first time | Splash screen displays briefly |
| 2 | Wait for splash | Language selection screen appears automatically |
| 3 | Screen displays | 3 language options visible: English, Sinhala (සිංහල), Tamil (தமிழ்) |
| 4 | Tap "English" | Language is selected (visual indicator shows selection) |
| 5 | Tap "Continue" | Onboarding screen loads with English content |
| 6 | Verify text | All text is in English (buttons, labels, descriptions) |
| 7 | Close app completely | Remove from recent apps |
| 8 | Reopen app | Onboarding/Dashboard displays in English (language preference saved) |
| 9 | Switch language to Sinhala | Settings → Language: select Sinhala |
| 10 | Verify all text | App UI updates to Sinhala immediately |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Language selected | Onboarding Screen 1 appears with app introduction |
| 2 | View Screen 1 content | Title, description, and "Next" button displayed |
| 3 | Tap "Next" button | Smooth transition to Screen 2 |
| 4 | Verify Screen 2 | New content displays (different feature explanation) |
| 5 | Tap "Next" again | Transitions to Screen 3 |
| 6 | Verify Screen 3 | Final onboarding screen with "Get Started" button |
| 7 | Swipe left on Screen 2 | Transitions to Screen 3 (gesture navigation) |
| 8 | Swipe right on Screen 2 | Transitions back to Screen 1 |
| 9 | Tap "Skip" (if available) | Bypasses remaining screens and goes to login |
| 10 | Tap "Get Started" on Screen 3 | Navigates to login screen |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap profile icon on dashboard | Navigation to profile page |
| 2 | Profile page loads | User's profile information displays |
| 3 | View personal information | Shows: Name, Email, Phone, Date of Birth, Gender |
| 4 | Check profile picture | User's profile image (if uploaded) displays |
| 5 | View membership info | Shows membership level, join date |
| 6 | View achievements | Displays badges/awards earned |
| 7 | View statistics | Shows trips taken, average rating, feedback count |
| 8 | Scroll down | Additional information sections visible |
| 9 | Verify data accuracy | All information matches registered data |
| 10 | Check last updated time | "Last updated: [date/time]" displayed |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "Edit Profile" button | Edit form opens with current information prefilled |
| 2 | Clear first name field | Field becomes empty |
| 3 | Enter new first name | New name displays in field |
| 4 | Edit email address | Email field editable only if not email-based login |
| 5 | Change phone number | Phone field shows current number |
| 6 | Update date of birth | Calendar picker opens for selection |
| 7 | Select new date | Date updates in field |
| 8 | Change profile picture | Image picker opens to select new photo |
| 9 | Select photo from gallery | Image preview displays |
| 10 | Tap "Save Changes" | Loading displays, update completes |
| 11 | Confirmation message | "Profile updated successfully" notification |
| 12 | Return to profile | Updated information displays |
| 13 | Refresh page | Data persists (saved to database) |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap on profile picture area | Image picker options appear |
| 2 | Tap "Choose from Gallery" | Gallery app opens |
| 3 | Select image | Selected image displays in preview |
| 4 | Tap "Use this image" | Returns to edit form with image preview |
| 5 | Verify image size | Image resized appropriately (not larger than 5MB) |
| 6 | Tap "Save" | Loading displays while uploading to Firebase Storage |
| 7 | Wait for upload | Upload completes within 30 seconds |
| 8 | Success message | "Profile picture updated" notification |
| 9 | Check profile page | New picture displays on profile (next time opened) |
| 10 | Try uploading very large file > 5MB | "File too large" error displays, upload prevented |
| 11 | Take photo option | Option to take new photo with camera |
| 12 | Tap "Take Photo" | Camera opens in capture mode |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Settings | Settings page displays |
| 2 | Tap "Change Password" | Change password form appears |
| 3 | Enter current password (wrong) | Current password field accepts input |
| 4 | Tap "Verify" | "Incorrect password" error displays |
| 5 | Enter correct current password | Verification succeeds |
| 6 | Enter new weak password (123456) | "Password too weak" warning displays |
| 7 | Enter strong new password | Password strength meter shows "Strong" |
| 8 | Confirm password field mismatch | "Passwords don't match" error shows |
| 9 | Enter matching confirmation | Confirmation matches new password |
| 10 | Tap "Change Password" | Loading displays, update processes |
| 11 | Success notification | "Password changed successfully" |
| 12 | Logout and login with old password | Login fails with "Invalid credentials" |
| 13 | Login with new password | Login succeeds, dashboard displays |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Go to Settings → Emergency Contacts | Emergency contacts list displays |
| 2 | Tap "Add Emergency Contact" | Contact form opens |
| 3 | Enter contact name (Mother) | Name field accepts text input |
| 4 | Enter phone number | Phone field accepts valid format |
| 5 | Select relationship (Mother/Father/Friend/Other) | Dropdown list displays relation options |
| 6 | Tap "Save" | Contact added to list, success message shown |
| 7 | Add second contact | "Add another contact" option available |
| 8 | Add up to 5 contacts | Maximum 5 emergency contacts |
| 9 | Try adding 6th contact | "Maximum contacts reached" message displays |
| 10 | Edit existing contact | Edit button available, form prefilled with current data |
| 11 | Change contact phone number | Updates successfully |
| 12 | Delete contact | "Delete" button available, confirmation dialog appears |
| 13 | Confirm deletion | Contact removed from list |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Settings → Privacy | Privacy preferences page displays |
| 2 | View privacy options | Options displayed: Location Sharing, Analytics, Marketing |
| 3 | Toggle "Share Location" | Toggle switches on/off with visual feedback |
| 4 | Check current state | Toggle shows current preference (ON/OFF) |
| 5 | Disable location sharing | "Location Sharing Disabled" message |
| 6 | Toggle "Personalized Analytics" | Affects data collection settings |
| 7 | Toggle "Marketing Emails" | Controls email marketing opt-in |
| 8 | View "Data Collection" details | Shows what data is collected |
| 9 | Tap "Download My Data" | ZIP file begins downloading with personal data |
| 10 | Tap "Request Data Deletion" | Confirmation dialog appears warning of permanent deletion |
| 11 | Cancel deletion | User returns to privacy settings |
| 12 | Preferences saved | Settings persist on app restart |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Settings → Notifications | Notification preferences page |
| 2 | View notification types | Options: Safety Alerts, Feedback Replies, Promotions, Updates |
| 3 | Toggle "Safety Alerts" | Can enable/disable critical safety notifications |
| 4 | Toggle "Feedback Replies" | Notifications when feedback receives response |
| 5 | Toggle "Promotional Offers" | Controls marketing notifications |
| 6 | Toggle "App Updates" | Notifications for app version updates |
| 7 | Set notification quiet hours | Option to set "Do Not Disturb" time range (e.g., 10 PM - 8 AM) |
| 8 | Configure sound | Option to enable/disable notification sound |
| 9 | Configure vibration | Option to enable/disable vibration |
| 10 | Test notification (if available) | Send test notification to verify settings |
| 11 | Verify quiet hours work | Notifications muted during quiet hours |
| 12 | Preferences saved automatically | Settings persist without explicit save |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View account information | Account details section displays |
| 2 | Check account creation date | Shows date when account was created |
| 3 | Check registered email | Displays correct email address |
| 4 | Check registered phone | Shows phone number used for registration |
| 5 | Check membership status | Shows active/inactive status |
| 6 | Check account type | Shows if phone-based or email-based |
| 7 | Check last login | Shows last successful login date and time |
| 8 | Verify all fields mandatory | All required fields have values |
| 9 | Check account verification status | Shows verified/unverified status |
| 10 | View activity log | Shows recent account activities |

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

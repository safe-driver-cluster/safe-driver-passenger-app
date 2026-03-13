# Notifications & Settings Test Cases - SafeDriver Passenger App

**Module:** Push Notifications, App Settings & Preferences  
**Test Plan ID:** TP-SAFEDRIVER-001  
**Test Case Category:** TC-006  
**Created:** March 12, 2026  

---

## 📋 Test Case 061: Push Notification Reception

**Test Case ID:** TC-006-001  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify app receives and displays push notifications

### **Description**
This test verifies FCM push notifications work correctly.

### **Preconditions**
- App installed on test device
- Firebase Cloud Messaging configured
- Push notifications enabled in app settings
- Device connected to internet

### **Test Steps**

• **Step 1:** App in foreground
• **Expected:** User in app, not in background
• **Step 2:** Send test notification
• **Expected:** Via Firebase Cloud Messaging console
• **Step 3:** Notification received
• **Expected:** App receives notification message
• **Step 4:** Display notification
• **Expected:** Notification displays in-app or as banner
• **Step 5:** Notification content
• **Expected:** Shows title, message, and icon correctly
• **Step 6:** App in background
• **Expected:** Close app or minimize
• **Step 7:** Send notification
• **Expected:** Firebase sends notification while app is background
• **Step 8:** System notification
• **Expected:** Android notification tray / iOS notification center
• **Step 9:** Notification alert
• **Expected:** Sound and/or vibration alert (if enabled)
• **Step 10:** Tap notification
• **Expected:** Tapping leads to relevant page in app
• **Step 11:** Test with URL
• **Expected:** Notification with deep link works
• **Step 12:** Test with data
• **Expected:** Notification with custom data payload processes correctly

### **Expected Result**
- Notifications received by app
- Display correctly when app foreground
- Show in system tray when background
- Contain correct content
- Tapping navigates to relevant screen
- Deep links and data handled
- Sound/vibration respects settings

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Notifications received  
✅ Display correctly  
✅ Tap navigates  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 062: In-App Notification Display

**Test Case ID:** TC-006-002  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify in-app notifications display correctly

### **Description**
This test verifies in-app notification display (toasts, banners, snackbars).

### **Preconditions**
- User in app
- Various in-app events trigger notifications
- App running

### **Test Steps**

• **Step 1:** Feedback submitted
• **Expected:** "Thank you for your feedback" snackbar appears
• **Step 2:** Profile updated
• **Expected:** Success notification shows "Profile updated"
• **Step 3:** Error occurred
• **Expected:** Error notification displays (red color)
• **Step 4:** Warning event
• **Expected:** Yellow/orange warning notification appears
• **Step 5:** Long duration toast
• **Expected:** Message shows for 3-5 seconds before fading
• **Step 6:** Short duration toast
• **Expected:** Quick notification shows for 1-2 seconds
• **Step 7:** Action button
• **Expected:** Some notifications have "Undo" or "Retry" button
• **Step 8:** Tap action button
• **Expected:** Performs the action (undo, retry, etc.)
• **Step 9:** Multiple notifications
• **Expected:** Queue shows if multiple come quickly
• **Step 10:** Notification stacking
• **Expected:** Older notifications disappear, new ones show
• **Step 11:** Dismissible
• **Expected:** User can swipe to dismiss notification
• **Step 12:** Position
• **Expected:** Notifications appear consistently (top or bottom)

### **Expected Result**
- In-app notifications display appropriately
- Content readable and clear
- Duration reasonable
- Dismiss-able if needed
- Action buttons functional
- Queue managed well
- Colors match severity level

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Notifications display  
✅ Content clear  
✅ Dismiss works  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 063: Notification Sound and Vibration

**Test Case ID:** TC-006-003  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify notification sound and vibration work correctly

### **Description**
This test verifies sound and vibration alerts for notifications.

### **Preconditions**
- Device can make sounds and vibrate
- Notifications enabled
- Volume and vibration settings accessible

### **Test Steps**

• **Step 1:** Sound enabled
• **Expected:** Settings → Notifications → Sound: ON
• **Step 2:** Send notification
• **Expected:** Notification received with sound alert
• **Step 3:** Sound plays
• **Expected:** Device makes notification sound
• **Step 4:** Vibration enabled
• **Expected:** Settings → Notifications → Vibration: ON
• **Step 5:** Vibration pulses
• **Expected:** Device vibrates on notification (1-2 pulses)
• **Step 6:** Sound disabled
• **Expected:** Turn off sound in settings
• **Step 7:** Notification received
• **Expected:** No sound plays
• **Step 8:** Vibration still active
• **Expected:** Vibration still occurs if enabled separately
• **Step 9:** Vibration disabled
• **Expected:** Turn off vibration in settings
• **Step 10:** Silent notification
• **Expected:** No vibration or sound
• **Step 11:** Custom sound
• **Expected:** If available, select different notification sound
• **Step 12:** Quiet hours
• **Expected:** During quiet hours, mute notifications

### **Expected Result**
- Sound plays when enabled (respects settings)
- Vibration triggers when enabled
- No sound/vibration when disabled
- User can customize sounds
- Quiet hours respected
- Settings persistence across sessions

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Sound works  
✅ Vibration works  
✅ Settings respected  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 064: Notification Clearing and Management

**Test Case ID:** TC-006-004  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify notification management and clearing

### **Description**
This test verifies notification list management and clearing.

### **Preconditions**
- Multiple notifications in system tray or app
- Notification center accessible

### **Test Steps**

• **Step 1:** View notifications page
• **Expected:** Notification list displays
• **Step 2:** Multiple notifications
• **Expected:** Shows all recent notifications
• **Step 3:** Each shows
• **Expected:** Timestamp, source, message preview
• **Step 4:** Tap notification
• **Expected:** Opens relevant feature/page
• **Step 5:** Swipe to dismiss
• **Expected:** Swiping removes notification from list
• **Step 6:** "Clear All" button
• **Expected:** Clears all notifications at once
• **Step 7:** Confirmation
• **Expected:** "Clear all notifications?" asks before clearing
• **Step 8:** Empty state
• **Expected:** "No notifications" message when cleared
• **Step 9:** Mark as read
• **Expected:** Visual change when notification read
• **Step 10:** Unread badge
• **Expected:** Badge shows count of unread notifications
• **Step 11:** Sort by date
• **Expected:** Notifications ordered (newest first)
• **Step 12:** Archive old
• **Expected:** Notifications older than 30 days archived

### **Expected Result**
- Notification list displays all notifications
- Can dismiss individual notifications
- Can clear all at once
- Mark as read functionality works
- Unread count accurate
- Sorted chronologically
- Empty state handled

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Management works  
✅ Clearing works  
✅ Sorting correct  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 065: Settings Page Navigation

**Test Case ID:** TC-006-005  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify settings page displays and navigates correctly

### **Description**
This test verifies the settings page layout and section navigation.

### **Preconditions**
- User is logged in
- User navigated to Settings page

### **Test Steps**

• **Step 1:** Tap Settings
• **Expected:** Settings page loads
• **Step 2:** Settings layout
• **Expected:** Organized in clear sections
• **Step 3:** Sections visible
• **Expected:** Account, Notifications, Privacy, About sections
• **Step 4:** Scroll sections
• **Expected:** Can scroll vertically to see all settings
• **Step 5:** Tap section heading
• **Expected:** May collapse/expand section (if accordion)
• **Step 6:** Subsection links
• **Expected:** Can tap to navigate to detailed settings
• **Step 7:** "Change Password"
• **Expected:** Opens password change form
• **Step 8:** "Privacy Settings"
• **Expected:** Opens privacy configuration page
• **Step 9:** "Notification Settings"
• **Expected:** Opens notification preferences
• **Step 10:** "App Info"
• **Expected:** Shows app version and build number
• **Step 11:** "About"
• **Expected:** Shows app description and company info
• **Step 12:** Back button
• **Expected:** Returns to settings or previous page

### **Expected Result**
- Settings page displays organized sections
- All main settings categories present
- Navigation between sections works
- Each section accessible
- Back navigation works
- No missing critical settings

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Settings layout organized  
✅ Navigation works  
✅ All sections accessible  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 066: Theme and Display Settings

**Test Case ID:** TC-006-006  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify theme and display settings work correctly

### **Description**
This test verifies dark mode, light mode, and font size settings.

### **Preconditions**
- User on settings page
- Display settings available

### **Test Steps**

• **Step 1:** View theme options
• **Expected:** Light, Dark, System options visible
• **Step 2:** Select "Light"
• **Expected:** App switches to light theme
• **Step 3:** Light theme colors
• **Expected:** White backgrounds, dark text
• **Step 4:** Select "Dark"
• **Expected:** App switches to dark theme
• **Step 5:** Dark theme colors
• **Expected:** Dark backgrounds, light text
• **Step 6:** Select "System"
• **Expected:** Theme follows device settings
• **Step 7:** Change device theme
• **Expected:** App theme changes automatically
• **Step 8:** Font size setting
• **Expected:** Slider or buttons to adjust text size
• **Step 9:** Increase font size
• **Expected:** All text becomes larger
• **Step 10:** Decrease font size
• **Expected:** All text becomes smaller
• **Step 11:** Accessibility fonts
• **Expected:** Support for system font sizes
• **Step 12:** Persistence
• **Expected:** Settings saved and persist on restart

### **Expected Result**
- Theme selection options available
- Theme toggles immediately
- Colors consistent with theme
- Font size adjustable
- System theme follows device setting
- Settings persist across sessions
- Supports accessibility font sizes

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Theme toggle works  
✅ Font size adjustable  
✅ Settings persist  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 067: Language Change in Settings

**Test Case ID:** TC-006-007  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify app language can be changed in settings

### **Description**
This test verifies language switching functionality.

### **Preconditions**
- User on settings page
- Language settings available
- Currently in one language (English)

### **Test Steps**

• **Step 1:** Navigate to Language settings
• **Expected:** Language option visible
• **Step 2:** Current language shown
• **Expected:** "English" currently selected
• **Step 3:** View language options
• **Expected:** English, Sinhala, Tamil shown
• **Step 4:** Tap "Sinhala"
• **Expected:** Language changes to Sinhala immediately
• **Step 5:** All text updates
• **Expected:** All UI text shows in Sinhala
• **Step 6:** Settings page updates
• **Expected:** Setting options text in Sinhala
• **Step 7:** Switch to Tamil
• **Expected:** Language changes to Tamil
• **Step 8:** Tamil content
• **Expected:** All content shows in Tamil
• **Step 9:** Return to English
• **Expected:** Switch back to English
• **Step 10:** Confirmation message
• **Expected:** Optional "Language changed" notification
• **Step 11:** App restart
• **Expected:** Language persists after restarting app
• **Step 12:** Partial translations
• **Expected:** If any text untranslated, shows in English fallback

### **Expected Result**
- Language selection dropdown available
- Switching language updates all UI immediately
- All screens translated to new language
- Language persists across sessions
- Fallback to English if translation missing
- No crashes on language switch

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Language switch works  
✅ All UI updates  
✅ Persists on restart  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 068: Data and Privacy Settings

**Test Case ID:** TC-006-008  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify data collection and privacy settings

### **Description**
This test verifies user control over data collection and analytics.

### **Preconditions**
- User on privacy settings page
- Privacy options available

### **Test Steps**

• **Step 1:** View privacy options
• **Expected:** Analytics, Crash reporting options
• **Step 2:** Analytics toggle
• **Expected:** Can enable/disable analytics collection
• **Step 3:** Disable analytics
• **Expected:** "Analytics disabled" confirmation
• **Step 4:** Crash reporting toggle
• **Expected:** Can enable/disable crash reporting
• **Step 5:** Location sharing toggle
• **Expected:** Control location data sharing
• **Step 6:** Marketing emails toggle
• **Expected:** Opt out of promotional emails
• **Step 7:** Third-party sharing toggle
• **Expected:** Control data sharing with partners
• **Step 8:** View privacy policy
• **Expected:** "Privacy Policy" link available
• **Step 9:** View terms
• **Expected:** "Terms of Service" link available
• **Step 10:** Download my data
• **Expected:** Option to export personal data
• **Step 11:** Delete account
• **Expected:** Option to delete account (with warning)
• **Step 12:** Settings saved
• **Expected:** Changes persist immediately

### **Expected Result**
- All privacy settings controllable
- User can opt out of data collection
- Settings respected by app
- Privacy policy accessible
- Data export available
- Account deletion option present
- Changes take effect immediately

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Privacy controls work  
✅ Options respected  
✅ Data available  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 069: About and App Information

**Test Case ID:** TC-006-009  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify app information and about section

### **Description**
This test verifies app version, build info, and company information.

### **Preconditions**
- User on settings page
- About section available

### **Test Steps**

• **Step 1:** Navigate to About
• **Expected:** About page displays
• **Step 2:** App name
• **Expected:** SafeDriver logo/name displayed
• **Step 3:** Version number
• **Expected:** Shows current app version (e.g., 1.0.0)
• **Step 4:** Build number
• **Expected:** Shows build number
• **Step 5:** Check for updates
• **Expected:** "Check for Updates" button available
• **Step 6:** Updated app available
• **Expected:** If update available, notification shown
• **Step 7:** Take to app store
• **Expected:** "Update" button opens app store
• **Step 8:** Company information
• **Expected:** Contact info for SafeDriver
• **Step 9:** Website link
• **Expected:** Link to company website
• **Step 10:** Social media links
• **Expected:** Links to Facebook, Instagram, Twitter (if any)
• **Step 11:** Contact email
• **Expected:** Support email address shown
• **Step 12:** Phone number
• **Expected:** Support phone number (if available)

### **Expected Result**
- App information displays correctly
- Version and build info accurate
- Update check works
- Links navigate correctly
- Contact information provided
- Website/social media links functional

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Version info displays  
✅ Update check works  
✅ Links functional  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 070: Cache Clearing

**Test Case ID:** TC-006-010  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify cache clearing functionality

### **Description**
This test verifies ability to clear app cache to free storage.

### **Preconditions**
- App has cached data
- Settings page open
- User in storage settings

### **Test Steps**

• **Step 1:** View storage settings
• **Expected:** "Storage Usage" or "Cache" section
• **Step 2:** Cache size shown
• **Expected:** Shows size of cached data (e.g., "124 MB")
• **Step 3:** Tap "Clear Cache"
• **Expected:** Confirmation dialog appears
• **Step 4:** Confirmation message
• **Expected:** "Are you sure you want to delete cache?"
• **Step 5:** Tap "Cancel"
• **Expected:** Dialog closes, cache remains
• **Step 6:** Tap "Clear Cache"
• **Expected:** Cache clears, success message shows
• **Step 7:** Storage updated
• **Expected:** Storage usage decreases
• **Step 8:** App functionality
• **Expected:** App still works after cache clear
• **Step 9:** Data reloads
• **Expected:** Data reloads from server on next use
• **Step 10:** Clear specific cache
• **Expected:** Option to clear specific types: images, videos
• **Step 11:** Offline maps cache
• **Expected:** Can clear cached offline map data
• **Step 12:** Confirmation message
• **Expected:** "Cache cleared successfully!" notification

### **Expected Result**
- Cache clearing option available
- Confirmation dialog before clearing
- Cache successfully cleared
- Storage usage decreases  
- App continues working
- Data reloads on next use
- Success message shown

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Cache clears  
✅ Storage reduces  
✅ App works  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 071: Device Permissions Management

**Test Case ID:** TC-006-011  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify app permissions can be managed in settings

### **Description**
This test verifies users can enable/disable app permissions.

### **Preconditions**
- User on device settings or app permissions page
- Multiple permissions requested by app

### **Test Steps**

• **Step 1:** App permissions section
• **Expected:** List of all permissions shown
• **Step 2:** Permissions listed
• **Expected:** Camera, Microphone, Location, Contacts, etc.
• **Step 3:** Individual permissions
• **Expected:** Each with toggle or on/off status
• **Step 4:** Disable permission
• **Expected:** Toggle camera permission OFF
• **Step 5:** Feature disabled
• **Expected:** Camera feature shows "Permission required" on use
• **Step 6:** Re-enable permission
• **Expected:** Toggle camera permission ON
• **Step 7:** Feature works
• **Expected:** Camera feature functional again
• **Step 8:** Permission status
• **Expected:** Shows "Always", "While using app", "Never" options (if available)
• **Step 9:** Grant/Deny history
• **Expected:** May show which permissions changed recently
• **Step 10:** Reset all
• **Expected:** Option to reset all permissions to defaults
• **Step 11:** System settings link
• **Expected:** "Open settings" link takes to device settings
• **Step 12:** In-app request
• **Expected:** In-app request respects device permission state

### **Expected Result**
- All app permissions visible
- Users can enable/disable each
- App respects permission state
- Feature gracefully handles denied permissions
- In-app requests respect device settings
- Settings link to system settings works

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Permissions visible  
✅ Toggle works  
✅ App respects settings  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 072: Help and Support

**Test Case ID:** TC-006-012  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify help and support section is accessible

### **Description**
This test verifies help documentation and support access.

### **Preconditions**
- User navigated to Help/Support page
- Support resources available

### **Test Steps**

• **Step 1:** Open Help page
• **Expected:** Help page displays
• **Step 2:** Browse FAQ
• **Expected:** "Frequently Asked Questions" section with categories
• **Step 3:** Search FAQ
• **Expected:** Can search for answers by keyword
• **Step 4:** FAQ results
• **Expected:** Relevant answers appear quickly
• **Step 5:** Tap FAQ item
• **Expected:** Article expands with full answer
• **Step 6:** Contact support
• **Expected:** "Contact Us" button available
• **Step 7:** Support form
• **Expected:** Form to submit support ticket
• **Step 8:** Ticket tracking
• **Expected:** Email confirmation with ticket number
• **Step 9:** Live chat (if available)
• **Expected:** Live chat option may appear
• **Step 10:** Feedback option
• **Expected:** Can submit feedback from help page
• **Step 11:** Video tutorials
• **Expected:** Links to help videos (if available)
• **Step 12:** Email support
• **Expected:** Support email address provided

### **Expected Result**
- Help page well-organized
- FAQ section searchable
- Support contact methods available
- Support tickets tracked
- Video tutorials accessible
- All support options functional

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Help accessible  
✅ FAQ works  
✅ Support options available  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 073: Settings Persistence

**Test Case ID:** TC-006-013  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify settings are saved and persist across sessions

### **Description**
This test verifies all settings changes are permanently saved.

### **Preconditions**
- User changes multiple settings
- Settings should persist

### **Test Steps**

• **Step 1:** Change language to Sinhala
• **Expected:** Language changes in app
• **Step 2:** Enable dark mode
• **Expected:** App switches to dark theme
• **Step 3:** Disable notifications
• **Expected:** Notification toggle turns OFF
• **Step 4:** Increase font size
• **Expected:** Text becomes larger
• **Step 5:** Close app
• **Expected:** App closes completely
• **Step 6:** Reopen app
• **Expected:** App launches
• **Step 7:** Check language
• **Expected:** Still in Sinhala
• **Step 8:** Check theme
• **Expected:** Still in dark mode
• **Step 9:** Check notifications
• **Expected:** Still disabled
• **Step 10:** Check font size
• **Expected:** Text still larger
• **Step 11:** Restart device
• **Expected:** Restart entire device
• **Step 12:** After restart
• **Expected:** All settings still persist

### **Expected Result**
- All settings changes saved to device
- Settings persist after app close/restart
- Settings survive device restart
- No settings reverted to defaults
- Consistent across all sessions

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Settings saved  
✅ Persist on exit  
✅ Persist on restart  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📊 Test Execution Summary - Notifications & Settings

| TC ID | Title | Status | Pass | Fail | Blocked | Notes |
|-------|-------|--------|------|------|---------|-------|
| TC-006-001 | Push Notifications | | [ ] | [ ] | [ ] | |
| TC-006-002 | In-App Notifications | | [ ] | [ ] | [ ] | |
| TC-006-003 | Sound & Vibration | | [ ] | [ ] | [ ] | |
| TC-006-004 | Notification Management | | [ ] | [ ] | [ ] | |
| TC-006-005 | Settings Navigation | | [ ] | [ ] | [ ] | |
| TC-006-006 | Theme & Display | | [ ] | [ ] | [ ] | |
| TC-006-007 | Language Change | | [ ] | [ ] | [ ] | |
| TC-006-008 | Privacy Settings | | [ ] | [ ] | [ ] | |
| TC-006-009 | App Information | | [ ] | [ ] | [ ] | |
| TC-006-010 | Cache Clearing | | [ ] | [ ] | [ ] | |
| TC-006-011 | Permissions | | [ ] | [ ] | [ ] | |
| TC-006-012 | Help & Support | | [ ] | [ ] | [ ] | |
| TC-006-013 | Settings Persistence | | [ ] | [ ] | [ ] | |

**Total:** 13 Test Cases | **Passed:** [ ] | **Failed:** [ ] | **Blocked:** [ ]  
**Pass Rate:** ____%

---

**Test Module Created:** March 12, 2026  
**Last Updated:** March 12, 2026

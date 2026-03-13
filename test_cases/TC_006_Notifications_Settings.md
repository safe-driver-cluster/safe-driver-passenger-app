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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | App in foreground | User in app, not in background |
| 2 | Send test notification | Via Firebase Cloud Messaging console |
| 3 | Notification received | App receives notification message |
| 4 | Display notification | Notification displays in-app or as banner |
| 5 | Notification content | Shows title, message, and icon correctly |
| 6 | App in background | Close app or minimize |
| 7 | Send notification | Firebase sends notification while app is background |
| 8 | System notification | Android notification tray / iOS notification center |
| 9 | Notification alert | Sound and/or vibration alert (if enabled) |
| 10 | Tap notification | Tapping leads to relevant page in app |
| 11 | Test with URL | Notification with deep link works |
| 12 | Test with data | Notification with custom data payload processes correctly |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Feedback submitted | "Thank you for your feedback" snackbar appears |
| 2 | Profile updated | Success notification shows "Profile updated" |
| 3 | Error occurred | Error notification displays (red color) |
| 4 | Warning event | Yellow/orange warning notification appears |
| 5 | Long duration toast | Message shows for 3-5 seconds before fading |
| 6 | Short duration toast | Quick notification shows for 1-2 seconds |
| 7 | Action button | Some notifications have "Undo" or "Retry" button |
| 8 | Tap action button | Performs the action (undo, retry, etc.) |
| 9 | Multiple notifications | Queue shows if multiple come quickly |
| 10 | Notification stacking | Older notifications disappear, new ones show |
| 11 | Dismissible | User can swipe to dismiss notification |
| 12 | Position | Notifications appear consistently (top or bottom) |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Sound enabled | Settings → Notifications → Sound: ON |
| 2 | Send notification | Notification received with sound alert |
| 3 | Sound plays | Device makes notification sound |
| 4 | Vibration enabled | Settings → Notifications → Vibration: ON |
| 5 | Vibration pulses | Device vibrates on notification (1-2 pulses) |
| 6 | Sound disabled | Turn off sound in settings |
| 7 | Notification received | No sound plays |
| 8 | Vibration still active | Vibration still occurs if enabled separately |
| 9 | Vibration disabled | Turn off vibration in settings |
| 10 | Silent notification | No vibration or sound |
| 11 | Custom sound | If available, select different notification sound |
| 12 | Quiet hours | During quiet hours, mute notifications |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View notifications page | Notification list displays |
| 2 | Multiple notifications | Shows all recent notifications |
| 3 | Each shows | Timestamp, source, message preview |
| 4 | Tap notification | Opens relevant feature/page |
| 5 | Swipe to dismiss | Swiping removes notification from list |
| 6 | "Clear All" button | Clears all notifications at once |
| 7 | Confirmation | "Clear all notifications?" asks before clearing |
| 8 | Empty state | "No notifications" message when cleared |
| 9 | Mark as read | Visual change when notification read |
| 10 | Unread badge | Badge shows count of unread notifications |
| 11 | Sort by date | Notifications ordered (newest first) |
| 12 | Archive old | Notifications older than 30 days archived |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap Settings | Settings page loads |
| 2 | Settings layout | Organized in clear sections |
| 3 | Sections visible | Account, Notifications, Privacy, About sections |
| 4 | Scroll sections | Can scroll vertically to see all settings |
| 5 | Tap section heading | May collapse/expand section (if accordion) |
| 6 | Subsection links | Can tap to navigate to detailed settings |
| 7 | "Change Password" | Opens password change form |
| 8 | "Privacy Settings" | Opens privacy configuration page |
| 9 | "Notification Settings" | Opens notification preferences |
| 10 | "App Info" | Shows app version and build number |
| 11 | "About" | Shows app description and company info |
| 12 | Back button | Returns to settings or previous page |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View theme options | Light, Dark, System options visible |
| 2 | Select "Light" | App switches to light theme |
| 3 | Light theme colors | White backgrounds, dark text |
| 4 | Select "Dark" | App switches to dark theme  |
| 5 | Dark theme colors | Dark backgrounds, light text |
| 6 | Select "System" | Theme follows device settings |
| 7 | Change device theme | App theme changes automatically |
| 8 | Font size setting | Slider or buttons to adjust text size |
| 9 | Increase font size | All text becomes larger |
| 10 | Decrease font size | All text becomes smaller |
| 11 | Accessibility fonts | Support for system font sizes |
| 12 | Persistence | Settings saved and persist on restart |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Language settings | Language option visible |
| 2 | Current language shown | "English" currently selected |
| 3 | View language options | English, Sinhala, Tamil shown |
| 4 | Tap "Sinhala" | Language changes to Sinhala immediately |
| 5 | All text updates | All UI text shows in Sinhala |
| 6 | Settings page updates | Setting options text in Sinhala |
| 7 | Switch to Tamil | Language changes to Tamil |
| 8 | Tamil content | All content shows in Tamil |
| 9 | Return to English | Switch back to English |
| 10 | Confirmation message | Optional "Language changed" notification |
| 11 | App restart | Language persists after restarting app |
| 12 | Partial translations | If any text untranslated, shows in English fallback |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View privacy options | Analytics, Crash reporting options |
| 2 | Analytics toggle | Can enable/disable analytics collection |
| 3 | Disable analytics | "Analytics disabled" confirmation |
| 4 | Crash reporting toggle | Can enable/disable crash reporting |
| 5 | Location sharing toggle | Control location data sharing |
| 6 | Marketing emails toggle | Opt out of promotional emails |
| 7 | Third-party sharing toggle | Control data sharing with partners |
| 8 | View privacy policy | "Privacy Policy" link available |
| 9 | View terms | "Terms of Service" link available |
| 10 | Download my data | Option to export personal data |
| 11 | Delete account | Option to delete account (with warning) |
| 12 | Settings saved | Changes persist immediately |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to About | About page displays |
| 2 | App name | SafeDriver logo/name displayed |
| 3 | Version number | Shows current app version (e.g., 1.0.0) |
| 4 | Build number | Shows build number |
| 5 | Check for updates | "Check for Updates" button available |
| 6 | Updated app available | If update available, notification shown |
| 7 | Take to app store | "Update" button opens app store |
| 8 | Company information | Contact info for SafeDriver |
| 9 | Website link | Link to company website |
| 10 | Social media links | Links to Facebook, Instagram, Twitter (if any) |
| 11 | Contact email | Support email address shown |
| 12 | Phone number | Support phone number (if available) |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View storage settings | "Storage Usage" or "Cache" section |
| 2 | Cache size shown | Shows size of cached data (e.g., "124 MB") |
| 3 | Tap "Clear Cache" | Confirmation dialog appears |
| 4 | Confirmation message | "Are you sure you want to delete cache?" |
| 5 | Tap "Cancel" | Dialog closes, cache remains |
| 6 | Tap "Clear Cache" | Cache clears, success message shows |
| 7 | Storage updated | Storage usage decreases |
| 8 | App functionality | App still works after cache clear |
| 9 | Data reloads | Data reloads from server on next use |
| 10 | Clear specific cache | Option to clear specific types: images, videos |
| 11 | Offline maps cache | Can clear cached offline map data |
| 12 | Confirmation message | "Cache cleared successfully!" notification |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | App permissions section | List of all permissions shown |
| 2 | Permissions listed | Camera, Microphone, Location, Contacts, etc. |
| 3 | Individual permissions | Each with toggle or on/off status |
| 4 | Disable permission | Toggle camera permission OFF |
| 5 | Feature disabled | Camera feature shows "Permission required" on use |
| 6 | Re-enable permission | Toggle camera permission ON |
| 7 | Feature works | Camera feature functional again |
| 8 | Permission status | Shows "Always", "While using app", "Never" options (if available) |
| 9 | Grant/Deny history | May show which permissions changed recently |
| 10 | Reset all | Option to reset all permissions to defaults |
| 11 | System settings link | "Open settings" link takes to device settings |
| 12 | In-app request | In-app request respects device permission state |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Open Help page | Help page displays |
| 2 | Browse FAQ | "Frequently Asked Questions" section with categories |
| 3 | Search FAQ | Can search for answers by keyword |
| 4 | FAQ results | Relevant answers appear quickly |
| 5 | Tap FAQ item | Article expands with full answer |
| 6 | Contact support | "Contact Us" button available |
| 7 | Support form | Form to submit support ticket |
| 8 | Ticket tracking | Email confirmation with ticket number |
| 9 | Live chat (if available) | Live chat option may appear |
| 10 | Feedback option | Can submit feedback from help page |
| 11 | Video tutorials | Links to help videos (if available) |
| 12 | Email support | Support email address provided |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Change language to Sinhala | Language changes in app |
| 2 | Enable dark mode | App switches to dark theme |
| 3 | Disable notifications | Notification toggle turns OFF |
| 4 | Increase font size | Text becomes larger |
| 5 | Close app | App closes completely |
| 6 | Reopen app | App launches |
| 7 | Check language | Still in Sinhala |
| 8 | Check theme | Still in dark mode |
| 9 | Check notifications | Still disabled |
| 10 | Check font size | Text still larger |
| 11 | Restart device | Restart entire device |
| 12 | After restart | All settings still persist |

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

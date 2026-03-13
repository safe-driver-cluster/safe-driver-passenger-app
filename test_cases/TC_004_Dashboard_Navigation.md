# Dashboard & Navigation Test Cases - SafeDriver Passenger App

**Module:** Dashboard, Navigation & Main Interface  
**Test Plan ID:** TP-SAFEDRIVER-001  
**Test Case Category:** TC-004  
**Created:** March 12, 2026  

---

## 📋 Test Case 038: Dashboard Page Load

**Test Case ID:** TC-004-001  
**Test Type:** Functional Testing  
**Priority:** P0 - Critical  
**Status:** Ready

### **Title**
Verify dashboard loads correctly with all main elements

### **Description**
This test verifies the dashboard homepage displays all required UI components.

### **Preconditions**
- User is logged in
- User navigated to dashboard
- Internet connectivity available
- Firebase configured

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | User logs in | Dashboard loads automatically after auth |
| 2 | Wait for page | Dashboard displays within 3 seconds |
| 3 | Verify header | App title or logo displays at top |
| 4 | Check notification icon | Notification bell with badge (if unread) |
| 5 | View welcome section | "Welcome, [User Name]" greeting displays |
| 6 | Check quick stats | Quick info cards shown (trips, rating, points) |
| 7 | Verify action buttons | 4 main action buttons visible: Scan, Routes, Emergency, Feedback |
| 8 | Recent activity section | Shows recent trips or activities |
| 9 | Promotional banner | If configured, banner displays (no crash) |
| 10 | Navigation bar | Bottom or side navigation visible |
| 11 | No loading errors | No error messages displayed |
| 12 | Responsive layout | All elements visible on different screen sizes |

### **Expected Result**
- Dashboard loads completely within 3 seconds
- All main UI elements present and positioned correctly
- No console errors
- Responsive layout adapts to screen size
- Data loads asynchronously without blocking UI

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Dashboard loads  
✅ All elements visible  
✅ No errors  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 039: Navigation Menu Functionality

**Test Case ID:** TC-004-002  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify navigation menu opens and allows page navigation

### **Description**
This test verifies the navigation menu/drawer for accessing different app sections.

### **Preconditions**
- User is on dashboard
- Navigation menu accessible (hamburger menu or bottom navigation)

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | On dashboard | Navigation menu visible (visible or hidden) |
| 2 | Tap hamburger menu icon (if hidden) | Navigation drawer/menu slides in |
| 3 | View menu items | Menu sections visible: Home, Profile, Feedback, History, Settings, Help |
| 4 | Tap "Home" | Navigate back to dashboard |
| 5 | Tap "Profile" | Navigate to user profile page |
| 6 | Tap "Feedback" | Navigate to feedback system |
| 7 | Tap "Trip History" | Navigate to trip history page |
| 8 | Tap "Settings" | Navigate to settings page |
| 9 | Tap "Help & Support" | Navigate to help page |
| 10 | Tap outside menu | Menu closes (if drawer) |
| 11 | Each navigation item | Works correctly, navigates to right page |
| 12 | Menu persists | Available on all pages |

### **Expected Result**
- Navigation menu opens/closes smoothly
- All menu items link to correct pages
- Current page indicator shown
- Menu accessible from any page
- Smooth transitions between pages
- No broken links

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Menu opens  
✅ Navigation works  
✅ All links functional  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 040: Quick Action Buttons

**Test Case ID:** TC-004-003  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify quick action buttons on dashboard are functional

### **Description**
This test verifies the 4 main action buttons on dashboard homepage.

### **Preconditions**
- User on dashboard
- Dashboard fully loaded

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View action buttons | 4 buttons visible: Scan QR, Find Routes, Emergency, Give Feedback |
| 2 | Button styling | All buttons have consistent styling and clear icons |
| 3 | Tap "Scan QR Code" | QR scanner page/camera opens |
| 4 | Go back | Return to dashboard |
| 5 | Tap "Find Routes" | Routes/buses page opens |
| 6 | Back button works | Return to dashboard |
| 7 | Tap "Emergency" | Emergency/SOS page opens |
| 8 | Back navigation | Return to dashboard |
| 9 | Tap "Give Feedback" | Feedback system page opens |
| 10 | Each button responsive | Tap detected immediately without lag |
| 11 | Position stable | Buttons don't move or resize |
| 12 | Touch target size | Buttons large enough to easily tap |

### **Expected Result**
- All 4 buttons present and clearly labeled
- Tapping each button navigates correctly
- Touch targets are adequate size (minimum 48x48 dp)
- Buttons don't move between taps
- Transitions are smooth
- Icons clearly represent their functions

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Buttons all functional  
✅ Navigation correct  
✅ Touch targets adequate  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 041: Dashboard Statistics Updates

**Test Case ID:** TC-004-004  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify dashboard statistics cards display and update correctly

### **Description**
This test verifies the stats cards show user's journey and feedback data.

### **Preconditions**
- User is on dashboard
- User has completed trips and/or feedback
- Data is in Firestore

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View stats section | Stats cards visible below welcome message |
| 2 | Check trip count | Shows total trips completed (e.g., "12 Trips") |
| 3 | Check rating | Shows current user rating (e.g., "4.5 ⭐") |
| 4 | Check reward points | Shows accumulated points (e.g., "250 Points") |
| 5 | Submit new feedback | Add feedback and navigate back to dashboard |
| 6 | Stats updated | Trip/Feedback count increases |
| 7 | Tap on stat card | Opens detailed view/history |
| 8 | Visual change | Stat cards animate on update |
| 9 | Correct calculations | Stats match actual data in Firestore |
| 10 | Refresh dashboard | Pull down to refresh stats |
| 11 | Pull-to-refresh works | Loads latest data |
| 12 | Loading state | Shows loading during refresh |

### **Expected Result**
- Stats cards display correct values
- Calculations are accurate
- Cards update when new data available
- Tapping shows detailed breakdown
- Pull-to-refresh works
- Smooth animations on update

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Stats display  
✅ Updates correct  
✅ Calculations accurate  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 042: Recent Activity Section

**Test Case ID:** TC-004-005  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify recent activity/trips section displays latest journeys

### **Description**
This test verifies the recent activity section shows user's recent trips.

### **Preconditions**
- User has taken trips
- Trip data is in Firestore
- User on dashboard

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Scroll dashboard | Recent activity section visible |
| 2 | Section title | "Recent Trips" or "Your Journeys" heading |
| 3 | Trip cards display | Shows last 5 trips in reverse chronological order |
| 4 | Each trip shows | Bus number, date, time, route |
| 5 | Trip details | Tap trip to see details |
| 6 | Feedback option | Option to give feedback on trip |
| 7 | Rebook option | Option to rebook the bus/route |
| 8 | Empty state | If no trips, "No trips yet" message |
| 9 | Navigation | "View All" link to see complete history |
| 10 | Time formatting | Shows relative time (e.g., "2 days ago") |
| 11 | Status indicator | Shows trip completed/cancelled status |
| 12 | Scroll within section | Can scroll horizontally if too many (if cards) |

### **Expected Result**
- Recent trips display in correct order
- Trip information clear and complete
- Tap opens trip details
- Related actions available (feedback, rebook)
- Empty state handled gracefully
- Time displays in user-friendly format

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Recent trips display  
✅ Details accurate  
✅ Actions available  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 043: Notification Icon and Badge

**Test Case ID:** TC-004-006  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify notification bell shows unread count badge

### **Description**
This test verifies the notification icon displays badge with unread count.

### **Preconditions**
- User is on dashboard
- Unread notifications exist
- Firebase Cloud Messaging configured

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Dashboard header | Notification bell icon visible |
| 2 | Check badge | Red badge with number shows unread count |
| 3 | Badge accurate | Number matches unread notifications |
| 4 | Tap notification icon | Notifications page/dropdown opens |
| 5 | Notifications list | Shows list of recent notifications |
| 6 | Mark as read | Notification marked read when viewed |
| 7 | Badge updates | Badge count decreases when notification read |
| 8 | All read notifications | Badge disappears when all read |
| 9 | New notification received | Badge reappears with new count |
| 10 | Badge animates | Subtle animation when count changes |
| 11 | Notification details | Tap notification shows full message |
| 12 | Clear notifications | Option to clear all notifications |

### **Expected Result**
- Notification badge displays correct count
- Badge updates when notifications read
- Badge disappears when all read
- Tapping bell opens notification list
- Each notification marked read correctly
- Animations smooth and subtle

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Badge displays  
✅ Count accurate  
✅ Updates when read  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 044: Page Refresh and Pull-to-Refresh

**Test Case ID:** TC-004-007  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify pull-to-refresh updates dashboard data

### **Description**
This test verifies the pull-to-refresh functionality loads fresh data.

### **Preconditions**
- User on dashboard
- App has internet connection
- Data might have changed in backend

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Dashboard displayed | Current data shown |
| 2 | Scroll to top | Ensures pull position available |
| 3 | Pull down gesture | Pull-to-refresh indicator appears |
| 4 | Pull beyond threshold | Refresh trigger activated |
| 5 | Release | Loading spinner displays |
| 6 | Loading state | "Refreshing..." message appears |
| 7 | Wait for refresh | Data reloads from server (2-5 seconds) |
| 8 | Refresh completes | Spinner disappears, data updates |
| 9 | New data displays | Stats and activities update |
| 10 | If no changes | Message shows "Already up to date" |
| 11 | Error handling | If offline, shows "No connection" error |
| 12 | Retry option | Can retry if refresh failed |

### **Expected Result**
- Pull-to-refresh gesture recognized
- Loading indicator displays
- Data reloads from server
- Changes reflect in UI
- Smooth animation
- Error handling if offline

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Pull-to-refresh works  
✅ Data updates  
✅ Error handling  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 045: Navigation Bar Icons and Labels

**Test Case ID:** TC-004-008  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify bottom navigation bar displays correctly and works

### **Description**
This test verifies the navigation bar with icons and labels.

### **Preconditions**
- User is on any page
- App has bottom or tab navigation

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View screen bottom | Navigation bar visible with 4-5 tabs |
| 2 | Tabs displayed | Each tab has icon and label |
| 3 | Current page highlighted | Active tab is highlighted/colored |
| 4 | Tap "Home" | Navigate to dashboard (tab highlights) |
| 5 | Tap "Feedback" | Navigate to feedback page |
| 6 | Tap "Profile" | Navigate to profile page |
| 7 | Tap "Help" | Navigate to help/support page |
| 8 | Tab titles | Icons have clear labels below |
| 9 | Touch targets | Each tab is easily tappable (min 48x48 dp) |
| 10 | Badge indicators | If unread items, badge shows on tab |
| 11 | Active state visual | Current page clearly indicated |
| 12 | Responsive | Tabs adjust on different screen sizes |

### **Expected Result**
- Navigation bar visible and stable
- All tabs functional and linked correctly
- Current page clearly indicated
- Icons clear and recognizable
- Touch targets adequate
- Badges show notifications

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Tabs functional  
✅ Navigation works  
✅ Visual indication clear  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 046: Back Navigation and History

**Test Case ID:** TC-004-009  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify back button navigates correctly through app history

### **Description**
This test verifies back navigation works correctly across pages.

### **Preconditions**
- User navigated through multiple pages
- Back button is available

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | On Dashboard | Back button may not be visible/disabled |
| 2 | Navigate to Profile | "Profile" page displays, back button visible |
| 3 | Tap back button | Returns to previous page (Dashboard) |
| 4 | Navigate Multiple times | Dashboard → Profile → Settings → Help |
| 5 | Tap back | Goes back one page (Help → Settings) |
| 6 | Tap back | Goes back another (Settings → Profile) |
| 7 | Continue back | Returns to Dashboard |
| 8 | Physical back (Android) | System back button also works |
| 9 | Gesture back (iOS) | Swipe from edge goes back |
| 10 | Navigation menu use | Using menu doesn't clear back history |
| 11 | Forms - back on form | Back button: confirm discard changes dialog |
| 12 | Modals - back | Closing modal returns to previous screen |

### **Expected Result**
- Back button navigates to previous screen
- Navigation history maintained correctly
- Physical back button works (Android)
- Gesture navigation works (iOS)
- Confirmation shown if leaving unsaved form
- Modal dialogs close on back

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Back button works  
✅ History maintained  
✅ Confirmations shown  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 047: Deep Linking Navigation

**Test Case ID:** TC-004-010  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify deep links navigate directly to specific pages

### **Description**
This test verifies deep linking allows direct page access via URLs.

### **Preconditions**
- App is installed
- Deep linking configured
- Test links available

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Open link: safedriver://home | App opens to dashboard |
| 2 | Open link: safedriver://feedback | App opens feedback page |
| 3 | Open link: safedriver://profile | App opens profile page |
| 4 | Open link: safedriver://trip/123 | Opens specific trip detail |
| 5 | Open link: safedriver://notification | Opens notifications |
| 6 | Not logged in case | Deep link opens app and redirects to login |
| 7 | After login | Deep link navigates to intended page |
| 8 | Invalid link | Shows error or home page |
| 9 | External link | Opens in-app browser or external link handler |
| 10 | From email link | Tapping link in email opens app correctly |
| 11 | From notification | Tapping notification link opens relevant page |
| 12 | App in background | Deep link brings app to foreground |

### **Expected Result**
- Deep links work and navigate correctly
- Logged-out users redirected to login first
- Invalid links handled gracefully
- External links handled appropriately
- App brought to foreground when needed
- Specific parameters passed correctly

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Deep links work  
✅ Navigation correct  
✅ Auth handled  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 048: Landscape Orientation

**Test Case ID:** TC-004-011  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify app layout adjusts correctly in landscape orientation

### **Description**
This test verifies responsive design works in landscape mode.

### **Preconditions**
- Device can rotate
- Auto-rotate enabled
- On various dashboard pages

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Portrait orientation | App displays in portrait mode |
| 2 | Rotate device 90° | Orientation changes to landscape |
| 3 | Layout adjustment | UI elements reflow to landscape format |
| 4 | Navigation bar | Tab bar or drawer adapts to landscape |
| 5 | No overlapping | Elements don't overlap in new layout |
| 6 | Scrolling works | Can still scroll if content exceeds screen |
| 7 | Buttons accessible | Action buttons still easily reachable |
| 8 | Text readable | Text remains readable, not squished |
| 9 | Images fit | Images scale appropriately |
| 10 | Back to portrait | Rotate back, layout returns to portrait |
| 11 | Forms in landscape | Form fields arrange properly |
| 12 | No data loss | Entered data preserved during rotation |

### **Expected Result**
- Layout properly adapts to landscape
- All elements visible and accessible
- No cropping or overlapping
- Touch targets remain adequate size
- Form data preserved through rotation
- Smooth transition animation

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Layout adapts  
✅ Elements visible  
✅ Data preserved  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 049: Page Transition Animations

**Test Case ID:** TC-004-012  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify smooth page transitions with animations

### **Description**
This test verifies page transitions are smooth and not jarring.

### **Preconditions**
- User navigating between pages
- Animations enabled in device

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Profile | Smooth transition animation (slide/fade) |
| 2 | Observe duration | Animation completes within 300-500ms |
| 3 | Animation smooth | No stuttering or jank |
| 4 | Back navigation | Return animation is smooth |
| 5 | Menu navigation | Opening/closing menu transitions smoothly |
| 6 | Bottom nav | Tab switching animated smoothly |
| 7 | Modal open | Modal appears with animation |
| 8 | Modal close | Modal disappears with animation |
| 9 | Loading state | Loading spinner animates smoothly |
| 10 | Data transitions | Data appears/updates with animations |
| 11 | Orientation change | Rotation animated smoothly |
| 12 | Performance | High FPS during animations (60fps target) |

### **Expected Result**
- Page transitions smooth and not jarring
- Animations enhance UX
- No performance issues
- Animations complete in reasonable time
- Consistent animation style throughout app
- Material Design animation principles followed

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Transitions smooth  
✅ No jank/stuttering  
✅ Performance good  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📊 Test Execution Summary - Dashboard & Navigation

| TC ID | Title | Status | Pass | Fail | Blocked | Notes |
|-------|-------|--------|------|------|---------|-------|
| TC-004-001 | Dashboard Load | | [ ] | [ ] | [ ] | |
| TC-004-002 | Navigation Menu | | [ ] | [ ] | [ ] | |
| TC-004-003 | Quick Actions | | [ ] | [ ] | [ ] | |
| TC-004-004 | Statistics | | [ ] | [ ] | [ ] | |
| TC-004-005 | Recent Activity | | [ ] | [ ] | [ ] | |
| TC-004-006 | Notification Badge | | [ ] | [ ] | [ ] | |
| TC-004-007 | Pull-to-Refresh | | [ ] | [ ] | [ ] | |
| TC-004-008 | Navigation Bar | | [ ] | [ ] | [ ] | |
| TC-004-009 | Back Navigation | | [ ] | [ ] | [ ] | |
| TC-004-010 | Deep Linking | | [ ] | [ ] | [ ] | |
| TC-004-011 | Landscape Orientation | | [ ] | [ ] | [ ] | |
| TC-004-012 | Page Transitions | | [ ] | [ ] | [ ] | |

**Total:** 12 Test Cases | **Passed:** [ ] | **Failed:** [ ] | **Blocked:** [ ]  
**Pass Rate:** ____%

---

**Test Module Created:** March 12, 2026  
**Last Updated:** March 12, 2026

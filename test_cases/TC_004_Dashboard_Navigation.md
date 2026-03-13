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

• **Step 1:** User logs in
  Expected: Dashboard loads automatically after auth
• **Step 2:** Wait for page
  Expected: Dashboard displays within 3 seconds
• **Step 3:** Verify header
  Expected: App title or logo displays at top
• **Step 4:** Check notification icon
  Expected: Notification bell with badge (if unread)
• **Step 5:** View welcome section
  Expected: "Welcome, [User Name]" greeting displays
• **Step 6:** Check quick stats
  Expected: Quick info cards shown (trips, rating, points)
• **Step 7:** Verify action buttons
  Expected: 4 main action buttons visible: Scan, Routes, Emergency, Feedback
• **Step 8:** Recent activity section
  Expected: Shows recent trips or activities
• **Step 9:** Promotional banner
  Expected: If configured, banner displays (no crash)
• **Step 10:** Navigation bar
  Expected: Bottom or side navigation visible
• **Step 11:** No loading errors
  Expected: No error messages displayed
• **Step 12:** Responsive layout
  Expected: All elements visible on different screen sizes

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

• **Step 1:** On dashboard
  Expected: Navigation menu visible (visible or hidden)
• **Step 2:** Tap hamburger menu icon (if hidden)
  Expected: Navigation drawer/menu slides in
• **Step 3:** View menu items
  Expected: Menu sections visible: Home, Profile, Feedback, History, Settings, Help
• **Step 4:** Tap "Home"
  Expected: Navigate back to dashboard
• **Step 5:** Tap "Profile"
  Expected: Navigate to user profile page
• **Step 6:** Tap "Feedback"
  Expected: Navigate to feedback system
• **Step 7:** Tap "Trip History"
  Expected: Navigate to trip history page
• **Step 8:** Tap "Settings"
  Expected: Navigate to settings page
• **Step 9:** Tap "Help & Support"
  Expected: Navigate to help page
• **Step 10:** Tap outside menu
  Expected: Menu closes (if drawer)
• **Step 11:** Each navigation item
  Expected: Works correctly, navigates to right page
• **Step 12:** Menu persists
  Expected: Available on all pages

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

• **Step 1:** View action buttons
  Expected: 4 buttons visible: Scan QR, Find Routes, Emergency, Give Feedback
• **Step 2:** Button styling
  Expected: All buttons have consistent styling and clear icons
• **Step 3:** Tap "Scan QR Code"
  Expected: QR scanner page/camera opens
• **Step 4:** Go back
  Expected: Return to dashboard
• **Step 5:** Tap "Find Routes"
  Expected: Routes/buses page opens
• **Step 6:** Back button works
  Expected: Return to dashboard
• **Step 7:** Tap "Emergency"
  Expected: Emergency/SOS page opens
• **Step 8:** Back navigation
  Expected: Return to dashboard
• **Step 9:** Tap "Give Feedback"
  Expected: Feedback system page opens
• **Step 10:** Each button responsive
  Expected: Tap detected immediately without lag
• **Step 11:** Position stable
  Expected: Buttons don't move or resize
• **Step 12:** Touch target size
  Expected: Buttons large enough to easily tap

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

• **Step 1:** View stats section
  Expected: Stats cards visible below welcome message
• **Step 2:** Check trip count
  Expected: Shows total trips completed (e.g., "12 Trips")
• **Step 3:** Check rating
  Expected: Shows current user rating (e.g., "4.5 ⭐")
• **Step 4:** Check reward points
  Expected: Shows accumulated points (e.g., "250 Points")
• **Step 5:** Submit new feedback
  Expected: Add feedback and navigate back to dashboard
• **Step 6:** Stats updated
  Expected: Trip/Feedback count increases
• **Step 7:** Tap on stat card
  Expected: Opens detailed view/history
• **Step 8:** Visual change
  Expected: Stat cards animate on update
• **Step 9:** Correct calculations
  Expected: Stats match actual data in Firestore
• **Step 10:** Refresh dashboard
  Expected: Pull down to refresh stats
• **Step 11:** Pull-to-refresh works
  Expected: Loads latest data
• **Step 12:** Loading state
  Expected: Shows loading during refresh

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

• **Step 1:** Scroll dashboard
  Expected: Recent activity section visible
• **Step 2:** Section title
  Expected: "Recent Trips" or "Your Journeys" heading
• **Step 3:** Trip cards display
  Expected: Shows last 5 trips in reverse chronological order
• **Step 4:** Each trip shows
  Expected: Bus number, date, time, route
• **Step 5:** Trip details
  Expected: Tap trip to see details
• **Step 6:** Feedback option
  Expected: Option to give feedback on trip
• **Step 7:** Rebook option
  Expected: Option to rebook the bus/route
• **Step 8:** Empty state
  Expected: If no trips, "No trips yet" message
• **Step 9:** Navigation
  Expected: "View All" link to see complete history
• **Step 10:** Time formatting
  Expected: Shows relative time (e.g., "2 days ago")
• **Step 11:** Status indicator
  Expected: Shows trip completed/cancelled status
• **Step 12:** Scroll within section
  Expected: Can scroll horizontally if too many (if cards)

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

• **Step 1:** Dashboard header
  Expected: Notification bell icon visible
• **Step 2:** Check badge
  Expected: Red badge with number shows unread count
• **Step 3:** Badge accurate
  Expected: Number matches unread notifications
• **Step 4:** Tap notification icon
  Expected: Notifications page/dropdown opens
• **Step 5:** Notifications list
  Expected: Shows list of recent notifications
• **Step 6:** Mark as read
  Expected: Notification marked read when viewed
• **Step 7:** Badge updates
  Expected: Badge count decreases when notification read
• **Step 8:** All read notifications
  Expected: Badge disappears when all read
• **Step 9:** New notification received
  Expected: Badge reappears with new count
• **Step 10:** Badge animates
  Expected: Subtle animation when count changes
• **Step 11:** Notification details
  Expected: Tap notification shows full message
• **Step 12:** Clear notifications
  Expected: Option to clear all notifications

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

• **Step 1:** Dashboard displayed
  Expected: Current data shown
• **Step 2:** Scroll to top
  Expected: Ensures pull position available
• **Step 3:** Pull down gesture
  Expected: Pull-to-refresh indicator appears
• **Step 4:** Pull beyond threshold
  Expected: Refresh trigger activated
• **Step 5:** Release
  Expected: Loading spinner displays
• **Step 6:** Loading state
  Expected: "Refreshing..." message appears
• **Step 7:** Wait for refresh
  Expected: Data reloads from server (2-5 seconds)
• **Step 8:** Refresh completes
  Expected: Spinner disappears, data updates
• **Step 9:** New data displays
  Expected: Stats and activities update
• **Step 10:** If no changes
  Expected: Message shows "Already up to date"
• **Step 11:** Error handling
  Expected: If offline, shows "No connection" error
• **Step 12:** Retry option
  Expected: Can retry if refresh failed

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

• **Step 1:** View screen bottom
  Expected: Navigation bar visible with 4-5 tabs
• **Step 2:** Tabs displayed
  Expected: Each tab has icon and label
• **Step 3:** Current page highlighted
  Expected: Active tab is highlighted/colored
• **Step 4:** Tap "Home"
  Expected: Navigate to dashboard (tab highlights)
• **Step 5:** Tap "Feedback"
  Expected: Navigate to feedback page
• **Step 6:** Tap "Profile"
  Expected: Navigate to profile page
• **Step 7:** Tap "Help"
  Expected: Navigate to help/support page
• **Step 8:** Tab titles
  Expected: Icons have clear labels below
• **Step 9:** Touch targets
  Expected: Each tab is easily tappable (min 48x48 dp)
• **Step 10:** Badge indicators
  Expected: If unread items, badge shows on tab
• **Step 11:** Active state visual
  Expected: Current page clearly indicated
• **Step 12:** Responsive
  Expected: Tabs adjust on different screen sizes

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

• **Step 1:** On Dashboard
  Expected: Back button may not be visible/disabled
• **Step 2:** Navigate to Profile
  Expected: "Profile" page displays, back button visible
• **Step 3:** Tap back button
  Expected: Returns to previous page (Dashboard)
• **Step 4:** Navigate Multiple times
  Expected: Dashboard → Profile → Settings → Help
• **Step 5:** Tap back
  Expected: Goes back one page (Help → Settings)
• **Step 6:** Tap back
  Expected: Goes back another (Settings → Profile)
• **Step 7:** Continue back
  Expected: Returns to Dashboard
• **Step 8:** Physical back (Android)
  Expected: System back button also works
• **Step 9:** Gesture back (iOS)
  Expected: Swipe from edge goes back
• **Step 10:** Navigation menu use
  Expected: Using menu doesn't clear back history
• **Step 11:** Forms - back on form
  Expected: Back button: confirm discard changes dialog
• **Step 12:** Modals - back
  Expected: Closing modal returns to previous screen

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

• **Step 1:** Open link: safedriver://home
  Expected: App opens to dashboard
• **Step 2:** Open link: safedriver://feedback
  Expected: App opens feedback page
• **Step 3:** Open link: safedriver://profile
  Expected: App opens profile page
• **Step 4:** Open link: safedriver://trip/123
  Expected: Opens specific trip detail
• **Step 5:** Open link: safedriver://notification
  Expected: Opens notifications
• **Step 6:** Not logged in case
  Expected: Deep link opens app and redirects to login
• **Step 7:** After login
  Expected: Deep link navigates to intended page
• **Step 8:** Invalid link
  Expected: Shows error or home page
• **Step 9:** External link
  Expected: Opens in-app browser or external link handler
• **Step 10:** From email link
  Expected: Tapping link in email opens app correctly
• **Step 11:** From notification
  Expected: Tapping notification link opens relevant page
• **Step 12:** App in background
  Expected: Deep link brings app to foreground

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

• **Step 1:** Portrait orientation
  Expected: App displays in portrait mode
• **Step 2:** Rotate device 90°
  Expected: Orientation changes to landscape
• **Step 3:** Layout adjustment
  Expected: UI elements reflow to landscape format
• **Step 4:** Navigation bar
  Expected: Tab bar or drawer adapts to landscape
• **Step 5:** No overlapping
  Expected: Elements don't overlap in new layout
• **Step 6:** Scrolling works
  Expected: Can still scroll if content exceeds screen
• **Step 7:** Buttons accessible
  Expected: Action buttons still easily reachable
• **Step 8:** Text readable
  Expected: Text remains readable, not squished
• **Step 9:** Images fit
  Expected: Images scale appropriately
• **Step 10:** Back to portrait
  Expected: Rotate back, layout returns to portrait
• **Step 11:** Forms in landscape
  Expected: Form fields arrange properly
• **Step 12:** No data loss
  Expected: Entered data preserved during rotation

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

• **Step 1:** Navigate to Profile
  Expected: Smooth transition animation (slide/fade)
• **Step 2:** Observe duration
  Expected: Animation completes within 300-500ms
• **Step 3:** Animation smooth
  Expected: No stuttering or jank
• **Step 4:** Back navigation
  Expected: Return animation is smooth
• **Step 5:** Menu navigation
  Expected: Opening/closing menu transitions smoothly
• **Step 6:** Bottom nav
  Expected: Tab switching animated smoothly
• **Step 7:** Modal open
  Expected: Modal appears with animation
• **Step 8:** Modal close
  Expected: Modal disappears with animation
• **Step 9:** Loading state
  Expected: Loading spinner animates smoothly
• **Step 10:** Data transitions
  Expected: Data appears/updates with animations
• **Step 11:** Orientation change
  Expected: Rotation animated smoothly
• **Step 12:** Performance
  Expected: High FPS during animations (60fps target)

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

# Feedback System Test Cases - SafeDriver Passenger App

**Module:** Feedback System (Bus & Driver Feedback)  
**Test Plan ID:** TP-SAFEDRIVER-001  
**Test Case Category:** TC-003  
**Created:** March 12, 2026  

---

## 📋 Test Case 026: Open Feedback System Page

**Test Case ID:** TC-003-001  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can access the feedback system from dashboard

### **Description**
This test verifies the feedback system page opens and displays bus selection options.

### **Preconditions**
- User is logged in
- User is on dashboard
- Internet connectivity available
- Bus data populated in Firestore

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | On dashboard, tap "Give Feedback" button | Loading spinner briefly displays |
| 2 | Wait for page load | Feedback system page opens with bus selection |
| 3 | Verify page title | "Select Bus" or "Give Feedback" title displays |
| 4 | Verify two tabs | Tabs visible: "Manual Selection" and "QR Scan" |
| 5 | Check bus list | List of available buses displays with numbers and route info |
| 6 | Verify each bus entry | Shows: Bus Number, Route, Current Time, Rating |
| 7 | Scroll bus list | All buses visible, list scrollable |
| 8 | Check recent buses | "Recent Buses" section shows recently used buses |
| 9 | Tap a bus from recent | Bus selected, feedback form appears |
| 10 | No data state | If no buses, "No buses available" message displays |

### **Expected Result**
- Feedback system page accessible from dashboard
- Bus list loads within 2 seconds
- Bus data displays correctly
- Recent buses shown for quick access
- Manual selection and QR scan tabs work
- No crashes or errors on load

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Page loads  
✅ Bus list displays  
✅ Tabs functional  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 027: Manual Bus Selection

**Test Case ID:** TC-003-002  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can select a bus manually for feedback

### **Description**
This test verifies the manual bus selection process from the list.

### **Preconditions**
- Feedback system page is open
- Bus list is visible with multiple buses
- User is on Manual Selection tab

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View bus list | Multiple buses displayed with details |
| 2 | Tap first bus (Bus #25) | Bus card highlights/shows selection |
| 3 | Verify bus info displays | Shows: Number, Route, Schedule, Driver Rating |
| 4 | Tap "Select" button | Bus selected, feedback form opens |
| 5 | Next page header | Shows "Feedback for Bus #25 - Route ABC" |
| 6 | Form displays | Feedback type selection shows |
| 7 | Go back | Bus selection page displays again |
| 8 | Select different bus | Previous selection cleared, new bus selected |
| 9 | Search bus feature | If available, search by bus number works |
| 10 | Filter options | Sort by rating, recent, etc. (if available) |

### **Expected Result**
- Tapping bus selects it with visual feedback
- Bus details display correctly
- Feedback form loads after selection
- User can go back and select another bus
- Bus number shows in feedback form
- Selection is not lost until user proceeds

### **Actual Result**
[To be filled]

### **Test Data**
- **Bus 1:** Bus #25 - Route ABC
- **Bus 2:** Bus #42 - Route XYZ

### **Pass Criteria**
✅ Bus selection works  
✅ Details display  
✅ Form opens  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 028: QR Code Scanning for Bus Identification

**Test Case ID:** TC-003-003  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can scan QR code to identify and select bus

### **Description**
This test verifies QR code scanning functionality to automatically identify buses.

### **Preconditions**
- Feedback system page is open
- User on "QR Scan" tab
- Device has camera
- Camera permissions granted
- QR codes available on test buses

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "QR Scan" tab | Camera view opens with scanning overlay |
| 2 | Verify camera frame | QR code scanning guide displayed on screen |
| 3 | Point camera at valid QR code | QR code area highlights when detected |
| 4 | QR code scanned | Bus information loads automatically from QR data |
| 5 | Auto-proceed | Feedback form opens automatically with bus selected |
| 6 | Scan invalid QR code | "Invalid QR code" error message displays |
| 7 | Try scanning text QR | "This is not a bus QR code" error displays |
| 8 | Point camera but don't scan | Camera remains open, scanner ready |
| 9 | Go back button | Returns to bus selection page |
| 10 | Camera off button | Can close camera without scanning |

### **Expected Result**
- Camera opens with QR scanning interface
- Valid QR codes detected and processed
- Bus information auto-loads from QR
- Invalid codes rejected with error message
- Smooth transition to feedback form after scan
- Camera can be closed without action
- No camera lag or freezing

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ QR scanning works  
✅ Bus loads automatically  
✅ Invalid codes handled  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 029: Feedback Type Selection (Bus vs Driver)

**Test Case ID:** TC-003-004  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can select between bus and driver feedback types

### **Description**
This test verifies the feedback type selection interface.

### **Preconditions**
- Bus has been selected
- Feedback form page is open
- User on feedback type selection screen

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View feedback type options | Two cards displayed: "Bus Feedback" and "Driver Feedback" |
| 2 | Tap "Bus Feedback" | Bus feedback form opens |
| 3 | Verify form fields | Shows: Cleanliness, Comfort, Facilities, Safety ratings |
| 4 | Go back and select Driver | Driver feedback form opens |
| 5 | Verify driver form | Shows: Driving Skill, Courtesy, Professionalism ratings |
| 6 | Tap bus feedback again | Form updates to bus feedback fields |
| 7 | Visual difference | Bus and driver forms have different categories |
| 8 | Icons/colors | Each type has distinct visual representation |
| 9 | Description text | Clear descriptions for each feedback type |
| 10 | Selection state | Currently selected type highlighted |

### **Expected Result**
- Two feedback types clearly presented
- Selecting type shows appropriate form
- Switching types updates form content
- Visual distinction between types
- Descriptions help user understand difference
- Form content relevant to selected type

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Type selection works  
✅ Forms update  
✅ Visual feedback clear  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 030: Star Rating System

**Test Case ID:** TC-003-005  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify interactive 5-star rating system works correctly

### **Description**
This test verifies the star rating functionality for feedback.

### **Preconditions**
- Feedback form is open
- Rating section is visible

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View rating section | 5 stars displayed, empty/gray by default |
| 2 | Hover over 3rd star | Stars fill up to 3rd star, showing preview |
| 3 | Tap 3rd star | 3 stars are selected (filled/highlighted) |
| 4 | Hover over 5th star | Shows preview of 5 stars |
| 5 | Tap 5th star | Rating changes to 5 stars |
| 6 | Hover over 2nd star | Shows preview of 2 stars |
| 7 | Tap 2nd star | Rating becomes 2 stars |
| 8 | Rating label updates | Text shows "Good", "Excellent", "Poor" etc. based on rating |
| 9 | Rating icon updates | Icon changes: Sad (1-2), Neutral (3), Happy (4-5) |
| 10 | Animation smooth | Star selection has smooth fill animation |
| 11 | Tap same star again | Can change rating by tapping different star |
| 12 | Rating persists | Selected rating remains until changed |

### **Expected Result**
- Stars highlight on tap and hover
- Selection persists visually
- Rating label and icon update appropriately
- Smooth animations on interactions
- User can change rating multiple times
- Rating value stored correctly

### **Actual Result**
[To be filled]

### **Test Data**
- **Rating 1:** Very Poor
- **Rating 3:** Average
- **Rating 5:** Excellent

### **Pass Criteria**
✅ Rating system responsive  
✅ Selection visual feedback  
✅ Labels update  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 031: Comment and Description Input

**Test Case ID:** TC-003-006  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can enter feedback comments with character limit

### **Description**
This test verifies text input for detailed feedback comments.

### **Preconditions**
- Feedback form is open
- Rating has been selected
- Comment field is visible

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap comment field | Text field becomes active (keyboard opens) |
| 2 | Type feedback | Text displays as typed without formatting |
| 3 | Enter 50 characters | Characters count displays (50/500) |
| 4 | Enter 200 characters | Continue typing, counter updates |
| 5 | Enter 500 characters | Maximum reached, "500/500" shows |
| 6 | Try typing beyond 500 | Additional characters not accepted |
| 7 | Clear and retype | Can delete text and retype |
| 8 | Emoji support | If supported, emojis display correctly |
| 9 | Special characters | Apostrophes, quotes, etc. work fine |
| 10 | Copy-paste text | Can paste text from clipboard |
| 11 | Character counter helpful | Shows remaining characters |
| 12 | Comments optional/required | App behavior when field empty clear |

### **Expected Result**
- Text field accepts input up to 500 characters
- Character counter displays current count
- No input allowed beyond 500 characters
- Text displays clearly
- Supports special characters
- Supports copy-paste functionality
- Field can be cleared and modified

### **Actual Result**
[To be filled]

### **Test Data**
- **Short Comment:** "Great bus service!"
- **Long Comment:** [500 character sample text]

### **Pass Criteria**
✅ Input accepts text  
✅ Limit enforced  
✅ Counter working  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 032: Photo/Media Upload in Feedback

**Test Case ID:** TC-003-007  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify user can attach photos and videos to feedback

### **Description**
This test verifies media upload functionality for evidence in feedback.

### **Preconditions**
- Feedback form is open
- Media attachment section is visible
- Device has gallery with images/videos
- Internet connectivity for upload

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "Attach Photo" button | Gallery picker opens showing photos |
| 2 | Select image | Image selected, preview appears in form |
| 3 | Add multiple photos | Can add up to 5 photos |
| 4 | View thumbnails | Photo previews displayed in form |
| 5 | Remove photo | Delete button available, photo removed |
| 6 | Tap "Attach Video" button | Gallery opens showing video files |
| 7 | Select video | Video preview displays |
| 8 | Maximum videos | Only 1 video allowed (or configured limit) |
| 9 | File size check | Video > 100MB: "File too large" error |
| 10 | Video preview | Plays short preview in form |
| 11 | Take photo option | "Take new photo" opens camera |
| 12 | Supported formats | JPG, PNG, MP4 formats accepted |

### **Expected Result**
- Media picker opens on tap
- Multiple photos can be selected (5 max)
- One video can be selected
- File size limits enforced
- Previews display correctly
- Can remove selected media
- Upload happens when submitting feedback

### **Actual Result**
[To be filled]

### **Test Data**
- **Test Photo 1:** test_photo_1.jpg (2MB)
- **Test Photo 2:** test_photo_2.jpg (3MB)
- **Test Video:** test_video.mp4 (50MB)
- **Large File:** large_video.mp4 (150MB - should fail)

### **Pass Criteria**
✅ Photos upload works  
✅ Video limits enforced  
✅ File size validation  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 033: Anonymous Feedback Submission

**Test Case ID:** TC-003-008  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can submit feedback anonymously

### **Description**
This test verifies anonymous feedback submission option.

### **Preconditions**
- Feedback form is filled with rating and comment
- Anonymous toggle option is visible

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View form | Anonymous checkbox displayed (unchecked by default) |
| 2 | Check "Submit Anonymous" | Checkbox marks as checked |
| 3 | Submit feedback | Anonymous submission processed |
| 4 | Verify in history | Feedback shows "Anonymous" instead of user name |
| 5 | Check admin view | Admin cannot identify who submitted |
| 6 | Uncheck anonymous | Can toggle anonymous off before submit |
| 7 | Submit with identity | User name shows with feedback |
| 8 | Data privacy | Anonymous feedback still has location/time data |
| 9 | Cannot contact anonymous | No reply option for anonymous feedback |
| 10 | Rating still counts | Anonymous feedback counts toward ratings |

### **Expected Result**
- Anonymous option available on form
- Can toggle anonymous on/off
- Anonymous feedback submitted successfully
- User cannot be identified if anonymous
- Anonymous feedback counted in statistics
- No contact options for anonymous feedback
- Location and time still recorded

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Anonymous toggle works  
✅ Submission processed  
✅ Privacy maintained  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 034: Feedback Submission Success

**Test Case ID:** TC-003-009  
**Test Type:** Functional Testing  
**Priority:** P0 - Critical  
**Status:** Ready

### **Title**
Verify feedback submits successfully to Firestore

### **Description**
This test verifies complete feedback submission process and data storage.

### **Preconditions**
- Feedback form completely filled (rating, comment)
- User is online
- Firebase Firestore configured

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | All fields filled | Rating selected, comment entered (optional) |
| 2 | Tap "Submit Feedback" | Form validation passes, no errors shown |
| 3 | Loading state | "Submitting..." loading indicator appears |
| 4 | Wait for submission | Loading for 2-5 seconds |
| 5 | Success message | "Thank you for your feedback!" notification |
| 6 | Navigation | Option to view feedback history or back to dashboard |
| 7 | Check Firestore | Feedback appears in Firestore "feedbacks" collection |
| 8 | Data verification | All submitted data stored correctly (rating, comment, timestamp) |
| 9 | User association | Feedback linked to user account |
| 10 | Bus/Driver association | Feedback linked to corresponding bus/driver |
| 11 | Timestamp recorded | Submission time recorded accurately |
| 12 | Reward notification | "You earned 10 points!" (if reward system active) |

### **Expected Result**
- Form validates before submission
- Loading state displays during upload
- Success message shown after completion
- Data persists in Firestore
- Feedback appears in user's history
- Timestamp recorded correctly
- User receives points/rewards (if configured)
- User navigated to next screen

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Submission successful  
✅ Data stored  
✅ Success message shown  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 035: Feedback History View

**Test Case ID:** TC-003-010  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify user can view their feedback submission history

### **Description**
This test verifies feedback history page shows all submitted feedback.

### **Preconditions**
- User has submitted at least one feedback
- User is logged in
- User navigated to Feedback History page

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Profile → Feedback History | History page loads |
| 2 | Verify feedback list | Shows all submitted feedback in reverse chronological order |
| 3 | Each entry shows | Date, bus number, rating, comment preview |
| 4 | Tap on feedback | Feedback detail view opens |
| 5 | Detail view shows | Full comment, attached photos, timestamps |
| 6 | Status indication | Shows if feedback was "Reviewed", "Pending", "Resolved" |
| 7 | Filter by status | Can filter: All, Recent, Highest Rated, Lowest Rated |
| 8 | Search function | Can search feedback by bus number or keyword |
| 9 | Sort options | Can sort by date, rating, recent |
| 10 | Pagination | If many entries, pagination or infinite scroll |
| 11 | No feedback state | If no feedback, "No feedback submitted yet" message |
| 12 | Empty state CTA | Button to submit first feedback |

### **Expected Result**
- History page loads all user's feedback
- Entries display in reverse chronological order (newest first)
- Each entry shows key information
- Tap opens detailed view
- Status visible for each feedback
- Filtering and sorting work correctly
- Search functionality works
- Handle empty state gracefully

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ History displays  
✅ Entries show details  
✅ Search/filter work  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 036: Feedback Rating Analytics

**Test Case ID:** TC-003-011  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify feedback analytics and rating statistics display correctly

### **Description**
This test verifies dashboard statistics showing feedback metrics.

### **Preconditions**
- Multiple feedback entries exist
- Analytics data calculated
- User on feedback or reviews page

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to Feedback Analytics | Analytics page displays |
| 2 | View statistics cards | Shows: Total Feedback, Average Rating, Submitted Count |
| 3 | Average rating calculation | Calculates correctly (e.g., 4.5/5 ⭐) |
| 4 | Feedback breakdown | Shows: Positive, Negative, Neutral count |
| 5 | Rating distribution | Shows 1-star, 2-star, 3-star, 4-star, 5-star counts |
| 6 | Visual chart | Bar chart or pie chart shows distribution |
| 7 | Timeline graph | Shows feedback trend over time (daily, weekly, monthly) |
| 8 | Category breakdown | If categorized, shows most/least common categories |
| 9 | Top rated items | Shows highest-rated buses/drivers |
| 10 | Recent feedback | Shows 5 most recent feedback entries |
| 11 | Time period filter | Can filter analytics by: Last 7 days, 30 days, All time |
| 12 | Export option | Option to export analytics (if available) |

### **Expected Result**
- Analytics data calculates correctly
- All metrics display accurately
- Charts render without errors
- Visual representations clear
- Filtering by time period works
- Statistics update when new feedback submitted
- Export option functional (if available)

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Analytics display  
✅ Calculations accurate  
✅ Charts render  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 037: Feedback with Network Latency

**Test Case ID:** TC-003-012  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify feedback submission handles network delays gracefully

### **Description**
This test verifies app behavior when network is slow or unstable during submission.

### **Preconditions**
- Feedback form filled and ready
- Can simulate network latency (slow 3G or similar)
- Firestore configured

### **Test Steps**

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enable slow network (3G simulation) | Device on simulated slow connection |
| 2 | Fill feedback form | All information entered |
| 3 | Tap "Submit Feedback" | Submission starts |
| 4 | During submission | Loading state displays with timeout indicator |
| 5 | Wait 10+ seconds | Loading continues, app doesn't hang |
| 6 | Submission eventually completes | "Thank you" message displays after delay |
| 7 | Network interrupts | Disable network during submission |
| 8 | Handle offline | "Network error" message displays with retry option |
| 9 | Tap "Retry" | Resubmits feedback when network returns |
| 10 | Network returns | Feedback submits successfully on retry |
| 11 | Data not duplicated | Feedback not submitted twice |
| 12 | User informed | Clear message about network status |

### **Expected Result**
- App doesn't freeze during slow uploads
- Loading state persists during delays
- Network errors handled gracefully
- Retry functionality available
- No duplicate submissions
- User informed of progress
- Eventually completes or shows error

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Handles latency  
✅ Retry works  
✅ No duplicates  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📊 Test Execution Summary - Feedback System

| TC ID | Title | Status | Pass | Fail | Blocked | Notes |
|-------|-------|--------|------|------|---------|-------|
| TC-003-001 | Open Feedback System | | [ ] | [ ] | [ ] | |
| TC-003-002 | Manual Bus Selection | | [ ] | [ ] | [ ] | |
| TC-003-003 | QR Code Scanning | | [ ] | [ ] | [ ] | |
| TC-003-004 | Feedback Type Selection | | [ ] | [ ] | [ ] | |
| TC-003-005 | Star Rating System | | [ ] | [ ] | [ ] | |
| TC-003-006 | Comment Input | | [ ] | [ ] | [ ] | |
| TC-003-007 | Media Upload | | [ ] | [ ] | [ ] | |
| TC-003-008 | Anonymous Feedback | | [ ] | [ ] | [ ] | |
| TC-003-009 | Successful Submission | | [ ] | [ ] | [ ] | |
| TC-003-010 | Feedback History | | [ ] | [ ] | [ ] | |
| TC-003-011 | Rating Analytics | | [ ] | [ ] | [ ] | |
| TC-003-012 | Network Latency | | [ ] | [ ] | [ ] | |

**Total:** 12 Test Cases | **Passed:** [ ] | **Failed:** [ ] | **Blocked:** [ ]  
**Pass Rate:** ____%

---

**Test Module Created:** March 12, 2026  
**Last Updated:** March 12, 2026

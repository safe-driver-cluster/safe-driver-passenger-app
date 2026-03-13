# Location & Maps Test Cases - SafeDriver Passenger App

**Module:** Location Services, Google Maps & Routes  
**Test Plan ID:** TP-SAFEDRIVER-001  
**Test Case Category:** TC-005  
**Created:** March 12, 2026  

---

## 📋 Test Case 050: Location Permission Request

**Test Case ID:** TC-005-001  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify location permission request displays on first access

### **Description**
This test verifies the app requests location permission and handles user choices.

### **Preconditions**
- App is freshly installed or permissions cleared
- User on dashboard
- Feature requiring location accessed for first time

### **Test Steps**

• **Step 1:** Tap "Find Routes" or location feature
  Expected: Permission request dialog appears
• **Step 2:** Dialog shows
  Expected: "SafeDriver needs access to your location" message
• **Step 3:** Permission options
  Expected: Buttons: "Allow", "Deny", "Don't Ask Again" (varies by OS)
• **Step 4:** Explanation text
  Expected: Clear reason why location needed displayed
• **Step 5:** Tap "Allow"
  Expected: Permission granted for app
• **Step 6:** Feature works
  Expected: Maps/routes load with location services enabled
• **Step 7:** Tap "Deny"
  Expected: Permission denied
• **Step 8:** Feature unavailable
  Expected: Feature shows "Location permission required" message
• **Step 9:** Re-request
  Expected: Icon/button to request permission again in settings
• **Step 10:** Settings access
  Expected: Can enable in Settings → Permissions → Location
• **Step 11:** Permission persistence
  Expected: Once granted, not asked again (until app reinstall)
• **Step 12:** Android/iOS differences
  Expected: Dialog phrasing matches OS standards

### **Expected Result**
- Permission dialog displays correctly
- User can grant or deny
- App behaves correctly based on permission grant/deny
- Settings link available if denied
- Permission persists across sessions
- Dialog follows platform guidelines

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Permission dialog works  
✅ User choice honored  
✅ App behaves accordingly  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 051: Get Current Location

**Test Case ID:** TC-005-002  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify app can retrieve and display current user location

### **Description**
This test verifies location services retrieve current GPS position.

### **Preconditions**
- Location permission is granted
- Device has GPS enabled
- Device in outdoor area with GPS signal (or location simulator)
- Maps page open

### **Test Steps**

• **Step 1:** On maps/routes page
  Expected: Map displays with default view
• **Step 2:** Wait for location
  Expected: GPS acquires location (within 10 seconds)
• **Step 3:** Current location indicator
  Expected: Blue dot appears on map at current location
• **Step 4:** Map centers
  Expected: Map auto-centers to current location
• **Step 5:** Accuracy circle
  Expected: Accuracy radius shown around location (if enabled)
• **Step 6:** Location info displays
  Expected: Shows: Latitude, Longitude, Accuracy
• **Step 7:** Address lookup
  Expected: Reverse geocoding shows nearest address
• **Step 8:** Loading state
  Expected: "Getting location..." shown while acquiring
• **Step 9:** Timeout handling
  Expected: After 30 seconds without signal, shows error
• **Step 10:** Retry option
  Expected: User can retry location fetch
• **Step 11:** Location updates
  Expected: Blue dot updates as user moves
• **Step 12:** Permissions denied
  Expected: If off, shows "Enable location" message

### **Expected Result**
- Current location retrieved accurately
- Displayed on map with visual indicator
- Auto-centers map to user
- Updates as user moves
- Timeout handled gracefully
- Address information provided

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Location retrieved  
✅ Displayed on map  
✅ Updates correctly  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 052: Search for Location

**Test Case ID:** TC-005-003  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify location search with Google Places autocomplete

### **Description**
This test verifies the location search feature with autocomplete suggestions.

### **Preconditions**
- Maps/routes page is open
- Location services enabled
- Internet connection available
- Google Places API configured

### **Test Steps**

• **Step 1:** Tap search field
  Expected: Search input field becomes active
• **Step 2:** Type location name
  Expected: Keyboard opens, text displays in search
• **Step 3:** Wait briefly
  Expected: Autocomplete suggestions appear (within 1 second)
• **Step 4:** View suggestions
  Expected: List of places matching search shown
• **Step 5:** Select from list
  Expected: Tap suggestion to select
• **Step 6:** Map updates
  Expected: Map centers to selected location
• **Step 7:** Location details
  Expected: Address, coordinates show for selected place
• **Step 8:** Search history
  Expected: Recently searched places available (if enabled)
• **Step 9:** Clear search
  Expected: 'X' button clears search field
• **Step 10:** Search special characters
  Expected: Searches with quotes, apostrophes work
• **Step 11:** No results
  Expected: "No results found" if nothing matches
• **Step 12:** Network error
  Expected: Handles offline gracefully

### **Expected Result**
- Search field functional and responsive
- Autocomplete suggestions appear
- Selection updates map
- Location details display correctly
- Search history available
- Special characters handled
- Error states managed

### **Actual Result**
[To be filled]

### **Test Data**
- **Search Inputs:** "Colombo", "Galle Face", "Airport", "Hospital"

### **Pass Criteria**
✅ Search works  
✅ Autocomplete functional  
✅ Map updates  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 053: Route Display on Map

**Test Case ID:** TC-005-004  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify bus routes display correctly on map

### **Description**
This test verifies that bus routes display as polylines connecting stops.

### **Preconditions**
- Maps/routes page open
- Route data available in Firestore
- Map loaded and centered

### **Test Steps**

• **Step 1:** View map
  Expected: Map displays with route polylines
• **Step 2:** Bus stops visible
  Expected: Stop markers display on map
• **Step 3:** Route line color
  Expected: Each route has distinct color
• **Step 4:** StartRoutes connected
  Expected: Stops connected with polyline
• **Step 5:** Tap stop marker
  Expected: Stop info window shows with details
• **Step 6:** Stop details
  Expected: Shows: Stop name, address, buses serving this stop
• **Step 7:** Zoom in/out
  Expected: Route remains visible but adapts to zoom level
• **Step 8:** Scroll map
  Expected: Can pan around without losing route
• **Step 9:** Multiple routes
  Expected: Can toggle routes on/off if overlapping
• **Step 10:** Route optimization
  Expected: Shows shortest path for buses
• **Step 11:** Traffic info
  Expected: If available, shows traffic conditions
• **Step 12:** Location sharing
  Expected: User's location shown in relation to route

### **Expected Result**
- Routes display clearly on map
- Bus stops marked with pins/markers
- Route lines connect stops properly
- Tap displays stop information
- Zoom works without issues
- Multiple routes handled
- User location shown relative to route

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Routes display  
✅ Stops marked  
✅ Info window works  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 054: Bus Live Location Tracking

**Test Case ID:** TC-005-005  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify real-time bus location displays and updates on map

### **Description**
This test verifies live bus position tracking on the map.

### **Preconditions**
- Map open with route displayed
- Bus live tracking data available
- Internet connection active
- Firestore Realtime updates configured

### **Test Steps**

• **Step 1:** View map
  Expected: Bus location marker displays
• **Step 2:** Bus marker icon
  Expected: Bus icon shows on current position
• **Step 3:** Watch for updates
  Expected: Bus position updates in real-time (every 10-15 seconds)
• **Step 4:** Movement shown
  Expected: Marker moves along route
• **Step 5:** Accuracy indicator
  Expected: Accuracy of location shown
• **Step 6:** Tap bus marker
  Expected: Info window shows: Bus number, route, speed, ETA
• **Step 7:** Speed displayed
  Expected: Current speed shown (if available)
• **Step 8:** Direction indicator
  Expected: Arrow or indicator shows direction of travel
• **Step 9:** Stop arrival
  Expected: When bus reaches stop, special indicator shown
• **Step 10:** Network loss
  Expected: If offline, cached position shown with timestamp
• **Step 11:** Reconnect
  Expected: Updates resume when network returns
• **Step 12:** Toggle tracking
  Expected: Can enable/disable live tracking

### **Expected Result**
- Bus location updates in real-time
- Position marker moves smoothly
- Bus info displayed when tapped
- Speed and direction shown
- Handles network disconnections
- Updates resume on reconnect
- Tracking can be toggled

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Live tracking works  
✅ Updates real-time  
✅ Info displays  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 055: ETA Calculation

**Test Case ID:** TC-005-006  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify Estimated Time of Arrival is calculated and displayed

### **Description**
This test verifies ETA calculation for bus arrival time.

### **Preconditions**
- Bus is live tracking
- Route displayed
- User location known

### **Test Steps**

• **Step 1:** View map with bus
  Expected: Bus location and route visible
• **Step 2:** ETA displayed
  Expected: Shows estimated arrival time
• **Step 3:** Time format
  Expected: Shows: "Arriving in 5 mins" or exact time "2:15 PM"
• **Step 4:** Bus approaching
  Expected: ETA decreases as bus gets closer
• **Step 5:** ETA accuracy
  Expected: Time should be relatively accurate (±2 min)
• **Step 6:** Traffic considered
  Expected: ETA adjusts for traffic conditions (if integrated)
• **Step 7:** Stops considered
  Expected: ETA accounts for upcoming stops
• **Step 8:** Updates frequently
  Expected: ETA refreshes every 30-60 seconds
• **Step 9:** Exceeded ETA
  Expected: If bus late, shows "Bus running late" warning
• **Step 10:** Early arrival
  Expected: If early, shows "Bus arriving early"
• **Step 11:** Bus arrived
  Expected: When bus reaches stop, "Bus arrived" shown
• **Step 12:** Next bus ETA
  Expected: Can view ETA for next bus on same route

### **Expected Result**
- ETA calculated and displayed
- Time updates frequently
- Format user-friendly
- Accuracy within ±2 minutes
- Late/early status indicated
- Accounts for traffic and stops
- Updates correctly

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ ETA calculated  
✅ Display accurate  
✅ Updates frequently  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 056: Hazard Zone Warnings

**Test Case ID:** TC-005-007  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify hazard zones display on map with appropriate warnings

### **Description**
This test verifies hazard zones are marked on map and user warned.

### **Preconditions**
- Maps page open
- Route passes through hazard zones
- Hazard data in Firestore
- User entering hazard area

### **Test Steps**

• **Step 1:** View map
  Expected: Hazard zones marked on map
• **Step 2:** Zone color/icon
  Expected: Hazard areas highlighted differently (orange/red)
• **Step 3:** Tap hazard zone
  Expected: Info shows: Zone type, severity, reason
• **Step 4:** User entering hazard
  Expected: Warning notification appears
• **Step 5:** Warning content
  Expected: "⚠️ Entering hazard zone: [Type]"
• **Step 6:** Safety tips
  Expected: Tips shown for hazard type
• **Step 7:** User leaving hazard
  Expected: "You have left the hazard zone" notification
• **Step 8:** Multiple zones
  Expected: If bus passes multiple, each warned
• **Step 9:** Zone history
  Expected: Can view zone history and statistics
| 10 | Report hazard: Users can report new hazards |
• **Step 11:** Real-time updates
  Expected: New hazards appear within 5 minutes
• **Step 12:** Severity level
  Expected: Zones color-coded: Green (low), Yellow (med), Red (high)

### **Expected Result**
- Hazard zones clearly marked on map
- Warnings displayed when entering zones
- Safety information provided
- Updates in real-time
- Users can report new hazards
- Severity indicated visually

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Zones displayed  
✅ Warnings shown  
✅ Info available  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 057: Offline Map Functionality

**Test Case ID:** TC-005-008  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify cached map data works offline

### **Description**
This test verifies app functionality when maps are offline.

### **Preconditions**
- Maps previously loaded and cached
- Device can go offline
- Offline maps configured

### **Test Steps**

• **Step 1:** Load maps offline
  Expected: Cached map tiles display
• **Step 2:** Zoom level
  Expected: Can zoom in/out using cached zoom levels
• **Step 3:** Pan/scroll
  Expected: Can scroll around cached area
• **Step 4:** Route visible
  Expected: Previously loaded routes remain visible
• **Step 5:** Current location
  Expected: User location still shown (if GPS available)
• **Step 6:** Search unavailable
  Expected: Search disabled with "Offline mode" message
• **Step 7:** Live tracking unavailable
  Expected: Live bus tracking stopped
• **Step 8:** Cached data used
  Expected: Shows last known bus positions
• **Step 9:** Reconnect
  Expected: Online features resume when connection returns
• **Step 10:** Auto-refresh
  Expected: Map refreshes when connection restored
• **Step 11:** Cache size
  Expected: Limits cache to reasonable size (e.g., 50MB)
• **Step 12:** Clear cache
  Expected: Option to clear offline cache in settings

### **Expected Result**
- Maps display offline using cached data
- Navigation works in offline mode
- Online features disabled gracefully
- Features resume on reconnect
- Cache has reasonable size
- User informed of offline status

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Offline map works  
✅ Cache used properly  
✅ Features resume online  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 058: Map Markers and Clustering

**Test Case ID:** TC-005-009  
**Test Type:** Functional Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify map markers cluster at high zoom levels

### **Description**
This test verifies marker clustering for performance with many stops.

### **Preconditions**
- Map showing many bus stops (50+)
- Clustering algorithm enabled

### **Test Steps**

• **Step 1:** View map zoomed out
  Expected: Individual markers may be clustered
• **Step 2:** Cluster display
  Expected: Number badge shows count of clustered markers
• **Step 3:** Cluster color
  Expected: Cluster color indicates quantity (gradient)
• **Step 4:** Tap cluster
  Expected: Cluster expands or zooms to show markers
• **Step 5:** Zoom in
  Expected: Clusters break apart into individual markers
• **Step 6:** Zoom out
  Expected: Markers recombine into clusters
• **Step 7:** Performance
  Expected: Map remains responsive with many markers
• **Step 8:** Animation smooth
  Expected: Clustering/unclustering is smooth
• **Step 9:** Single marker
  Expected: Tap single marker shows info window
• **Step 10:** Cluster info
  Expected: Info for cluster shows count and bounds
• **Step 11:** Custom colors
  Expected: Cluster styling matches app theme
• **Step 12:** Different zoom levels
  Expected: Clustering adjusts based on zoom

### **Expected Result**
- Markers cluster at high zoom levels
- Clustering improves performance
- Smooth expand/collapse animation
- Correct count displayed
- Individual markers accessible
- Info windows work for all

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Clustering works  
✅ Performance good  
✅ Animations smooth  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 059: Directions and Routing

**Test Case ID:** TC-005-010  
**Test Type:** Functional Testing  
**Priority:** P1 - High  
**Status:** Ready

### **Title**
Verify routing calculation between two points

### **Description**
This test verifies turn-by-turn directions calculation.

### **Preconditions**
- Maps page with route feature
- Start and end points set
- Internet connection available
- Google Directions API configured

### **Test Steps**

• **Step 1:** Select start location
  Expected: User's current location or search result
• **Step 2:** Select end location
  Expected: Destination selected from suggestions
• **Step 3:** Route calculated
  Expected: Route line drawn between points
• **Step 4:** Alternative routes
  Expected: Shows multiple route options (if available)
• **Step 5:** Distance displayed
  Expected: Shows route distance  (e.g., "5.2 km")
• **Step 6:** Duration shown
  Expected: Estimated travel time (e.g., "15 mins")
• **Step 7:** Turn-by-turn
  Expected: Detailed turn instructions available
• **Step 8:** Step details
  Expected: Each step shows instruction and distance
• **Step 9:** Icons
  Expected: Clear icons for turns (left, right, straight)
• **Step 10:** Scroll steps
  Expected: Can scroll through direction list
• **Step 11:** Start navigation
  Expected: "Start" button begins voice guidance
• **Step 12:** Avoid highways
  Expected: Option to avoid highways/toll roads

### **Expected Result**
- Route calculated correctly
- Visual route displayed on map
- Multiple routes offered
- Distance and time accurate
- Turn-by-turn directions available
- Voice guidance works
- Route options adjustable

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Route calculated  
✅ Directions shown  
✅ Accuracy good  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📋 Test Case 060: Map Accessibility (A11y)

**Test Case ID:** TC-005-011  
**Test Type:** Accessibility Testing  
**Priority:** P2 - Medium  
**Status:** Ready

### **Title**
Verify map features accessible to users with disabilities

### **Description**
This test verifies accessibility features for screen readers and keyboard navigation.

### **Preconditions**
- Screen reader enabled (TalkBack or VoiceOver)
- Accessibility features enabled

### **Test Steps**

• **Step 1:** Screen reader enabled
  Expected: Activates on app launch
• **Step 2:** Navigate by touch
  Expected: Screen reader describes touched elements
• **Step 3:** Map description
  Expected: "Map showing bus route ABC" announced
• **Step 4:** Marker focus
  Expected: Current marker described with "Stop XYZ"
• **Step 5:** Zoom controls
  Expected: "Zoom in button" and "Zoom out button" announced
• **Step 6:** Button labels
  Expected: All buttons have descriptive labels for screen reader
• **Step 7:** Color contrast
  Expected: Text meets WCAG AA contrast requirements
• **Step 8:** Text size
  Expected: Can increase text size in accessibility settings
• **Step 9:** Keyboard only
  Expected: Can operate all functions via keyboard
• **Step 10:** Focus indicators
  Expected: Clear focus indicators visible on all controls
• **Step 11:** Touch target size
  Expected: All touchable elements minimum 48x48 dp
• **Step 12:** Content descriptions
  Expected: Alt text for images describes their purpose

### **Expected Result**
- All map elements accessible to screen readers
- Keyboard navigation works
- Color contrast meets WCAG AA standards
- Text size adjustable
- Focus indicators visible
- Touch target sizes adequate
- Alternative descriptions provided

### **Actual Result**
[To be filled]

### **Pass Criteria**
✅ Screen reader works  
✅ Keyboard navigation  
✅ Contrast adequate  

### **Status**
- [ ] Pass
- [ ] Fail
- [ ] Blocked

---

## 📊 Test Execution Summary - Location & Maps

| TC ID | Title | Status | Pass | Fail | Blocked | Notes |
|-------|-------|--------|------|------|---------|-------|
| TC-005-001 | Location Permission | | [ ] | [ ] | [ ] | |
| TC-005-002 | Get Current Location | | [ ] | [ ] | [ ] | |
| TC-005-003 | Location Search | | [ ] | [ ] | [ ] | |
| TC-005-004 | Route Display | | [ ] | [ ] | [ ] | |
| TC-005-005 | Live Tracking | | [ ] | [ ] | [ ] | |
| TC-005-006 | ETA Calculation | | [ ] | [ ] | [ ] | |
| TC-005-007 | Hazard Zones | | [ ] | [ ] | [ ] | |
| TC-005-008 | Offline Maps | | [ ] | [ ] | [ ] | |
| TC-005-009 | Marker Clustering | | [ ] | [ ] | [ ] | |
| TC-005-010 | Directions | | [ ] | [ ] | [ ] | |
| TC-005-011 | Accessibility | | [ ] | [ ] | [ ] | |

**Total:** 11 Test Cases | **Passed:** [ ] | **Failed:** [ ] | **Blocked:** [ ]  
**Pass Rate:** ____%

---

**Test Module Created:** March 12, 2026  
**Last Updated:** March 12, 2026

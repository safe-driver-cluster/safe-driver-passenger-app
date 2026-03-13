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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap "Find Routes" or location feature | Permission request dialog appears |
| 2 | Dialog shows | "SafeDriver needs access to your location" message |
| 3 | Permission options | Buttons: "Allow", "Deny", "Don't Ask Again" (varies by OS) |
| 4 | Explanation text | Clear reason why location needed displayed |
| 5 | Tap "Allow" | Permission granted for app |
| 6 | Feature works | Maps/routes load with location services enabled |
| 7 | Tap "Deny" | Permission denied |
| 8 | Feature unavailable | Feature shows "Location permission required" message |
| 9 | Re-request | Icon/button to request permission again in settings |
| 10 | Settings access | Can enable in Settings → Permissions → Location |
| 11 | Permission persistence | Once granted, not asked again (until app reinstall) |
| 12 | Android/iOS differences | Dialog phrasing matches OS standards |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | On maps/routes page | Map displays with default view |
| 2 | Wait for location | GPS acquires location (within 10 seconds) |
| 3 | Current location indicator | Blue dot appears on map at current location |
| 4 | Map centers | Map auto-centers to current location |
| 5 | Accuracy circle | Accuracy radius shown around location (if enabled) |
| 6 | Location info displays | Shows: Latitude, Longitude, Accuracy |
| 7 | Address lookup | Reverse geocoding shows nearest address |
| 8 | Loading state | "Getting location..." shown while acquiring |
| 9 | Timeout handling | After 30 seconds without signal, shows error |
| 10 | Retry option | User can retry location fetch |
| 11 | Location updates | Blue dot updates as user moves |
| 12 | Permissions denied | If off, shows "Enable location" message |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Tap search field | Search input field becomes active |
| 2 | Type location name | Keyboard opens, text displays in search |
| 3 | Wait briefly | Autocomplete suggestions appear (within 1 second) |
| 4 | View suggestions | List of places matching search shown |
| 5 | Select from list | Tap suggestion to select |
| 6 | Map updates | Map centers to selected location |
| 7 | Location details | Address, coordinates show for selected place |
| 8 | Search history | Recently searched places available (if enabled) |
| 9 | Clear search | 'X' button clears search field |
| 10 | Search special characters | Searches with quotes, apostrophes work |
| 11 | No results | "No results found" if nothing matches |
| 12 | Network error | Handles offline gracefully |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View map | Map displays with route polylines |
| 2 | Bus stops visible | Stop markers display on map |
| 3 | Route line color | Each route has distinct color |
| 4 | StartRoutes connected | Stops connected with polyline |
| 5 | Tap stop marker | Stop info window shows with details |
| 6 | Stop details | Shows: Stop name, address, buses serving this stop |
| 7 | Zoom in/out | Route remains visible but adapts to zoom level |
| 8 | Scroll map | Can pan around without losing route |
| 9 | Multiple routes | Can toggle routes on/off if overlapping |
| 10 | Route optimization | Shows shortest path for buses |
| 11 | Traffic info | If available, shows traffic conditions |
| 12 | Location sharing | User's location shown in relation to route |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View map | Bus location marker displays |
| 2 | Bus marker icon | Bus icon shows on current position |
| 3 | Watch for updates | Bus position updates in real-time (every 10-15 seconds) |
| 4 | Movement shown | Marker moves along route |
| 5 | Accuracy indicator | Accuracy of location shown |
| 6 | Tap bus marker | Info window shows: Bus number, route, speed, ETA |
| 7 | Speed displayed | Current speed shown (if available) |
| 8 | Direction indicator | Arrow or indicator shows direction of travel |
| 9 | Stop arrival | When bus reaches stop, special indicator shown |
| 10 | Network loss | If offline, cached position shown with timestamp |
| 11 | Reconnect | Updates resume when network returns |
| 12 | Toggle tracking | Can enable/disable live tracking |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View map with bus | Bus location and route visible |
| 2 | ETA displayed | Shows estimated arrival time |
| 3 | Time format | Shows: "Arriving in 5 mins" or exact time "2:15 PM" |
| 4 | Bus approaching | ETA decreases as bus gets closer |
| 5 | ETA accuracy | Time should be relatively accurate (±2 min) |
| 6 | Traffic considered | ETA adjusts for traffic conditions (if integrated) |
| 7 | Stops considered | ETA accounts for upcoming stops |
| 8 | Updates frequently | ETA refreshes every 30-60 seconds |
| 9 | Exceeded ETA | If bus late, shows "Bus running late" warning |
| 10 | Early arrival | If early, shows "Bus arriving early" |
| 11 | Bus arrived | When bus reaches stop, "Bus arrived" shown |
| 12 | Next bus ETA | Can view ETA for next bus on same route |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View map | Hazard zones marked on map |
| 2 | Zone color/icon | Hazard areas highlighted differently (orange/red) |
| 3 | Tap hazard zone | Info shows: Zone type, severity, reason |
| 4 | User entering hazard | Warning notification appears |
| 5 | Warning content | "⚠️ Entering hazard zone: [Type]" |
| 6 | Safety tips | Tips shown for hazard type |
| 7 | User leaving hazard | "You have left the hazard zone" notification |
| 8 | Multiple zones | If bus passes multiple, each warned |
| 9 | Zone history | Can view zone history and statistics |
| 10 | Report hazard: Users can report new hazards |
| 11 | Real-time updates | New hazards appear within 5 minutes |
| 12 | Severity level | Zones color-coded: Green (low), Yellow (med), Red (high) |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Load maps offline | Cached map tiles display |
| 2 | Zoom level | Can zoom in/out using cached zoom levels |
| 3 | Pan/scroll | Can scroll around cached area |
| 4 | Route visible | Previously loaded routes remain visible |
| 5 | Current location | User location still shown (if GPS available) |
| 6 | Search unavailable | Search disabled with "Offline mode" message |
| 7 | Live tracking unavailable | Live bus tracking stopped |
| 8 | Cached data used | Shows last known bus positions |
| 9 | Reconnect | Online features resume when connection returns |
| 10 | Auto-refresh | Map refreshes when connection restored |
| 11 | Cache size | Limits cache to reasonable size (e.g., 50MB) |
| 12 | Clear cache | Option to clear offline cache in settings |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | View map zoomed out | Individual markers may be clustered |
| 2 | Cluster display | Number badge shows count of clustered markers |
| 3 | Cluster color | Cluster color indicates quantity (gradient) |
| 4 | Tap cluster | Cluster expands or zooms to show markers |
| 5 | Zoom in | Clusters break apart into individual markers |
| 6 | Zoom out | Markers recombine into clusters |
| 7 | Performance | Map remains responsive with many markers |
| 8 | Animation smooth | Clustering/unclustering is smooth |
| 9 | Single marker | Tap single marker shows info window |
| 10 | Cluster info | Info for cluster shows count and bounds |
| 11 | Custom colors | Cluster styling matches app theme |
| 12 | Different zoom levels | Clustering adjusts based on zoom |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Select start location | User's current location or search result |
| 2 | Select end location | Destination selected from suggestions |
| 3 | Route calculated | Route line drawn between points |
| 4 | Alternative routes | Shows multiple route options (if available) |
| 5 | Distance displayed | Shows route distance  (e.g., "5.2 km") |
| 6 | Duration shown | Estimated travel time (e.g., "15 mins") |
| 7 | Turn-by-turn | Detailed turn instructions available |
| 8 | Step details | Each step shows instruction and distance |
| 9 | Icons | Clear icons for turns (left, right, straight) |
| 10 | Scroll steps | Can scroll through direction list |
| 11 | Start navigation | "Start" button begins voice guidance |
| 12 | Avoid highways | Option to avoid highways/toll roads |

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

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Screen reader enabled | Activates on app launch |
| 2 | Navigate by touch | Screen reader describes touched elements |
| 3 | Map description | "Map showing bus route ABC" announced |
| 4 | Marker focus | Current marker described with "Stop XYZ" |
| 5 | Zoom controls | "Zoom in button" and "Zoom out button" announced |
| 6 | Button labels | All buttons have descriptive labels for screen reader |
| 7 | Color contrast | Text meets WCAG AA contrast requirements |
| 8 | Text size | Can increase text size in accessibility settings |
| 9 | Keyboard only | Can operate all functions via keyboard |
| 10 | Focus indicators | Clear focus indicators visible on all controls |
| 11 | Touch target size | All touchable elements minimum 48x48 dp |
| 12 | Content descriptions | Alt text for images describes their purpose |

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

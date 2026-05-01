# SafeDriver Passenger App - Test Plan

## 1. Document Control

| Item | Value |
| --- | --- |
| Project | SafeDriver Passenger App |
| Document | Test Plan |
| Version | 1.0 |
| Date | 2026-04-28 |
| Owner | QA Team |
| Status | Draft |

## 2. Objectives

- Validate all passenger app functions on Android and iOS.
- Verify backend integrations (Firebase Auth, Firestore, Cloud Functions, FCM, SMS gateway).
- Confirm data integrity, security rules, and error handling.
- Ensure localization, usability, and compatibility goals are met.

## 3. Scope

### 3.1 In Scope

- App installation, launch, and permissions.
- Language selection and language switching.
- Onboarding flow.
- Authentication: email/password, OTP registration, login, logout, password reset.
- Persistent login and biometric authentication.
- Passenger profile creation and updates.
- Dashboard features and time-based greeting.
- QR code scanning for bus selection.
- Live tracking and maps.
- Bus information and history.
- Driver information and history.
- Hazard zones and safety tips.
- Emergency response flow.
- Feedback system (bus/driver, ratings, comments, media, location, WhatsApp/email sharing).
- Reward points system and anti-fraud behavior.
- Push notifications and notification center behavior.
- Settings (privacy, notifications, language, biometric).
- Firebase data models and Firestore rules.
- SMS gateway and OTP Cloud Functions.
- Basic performance, offline behavior, and crash resilience.

### 3.2 Out of Scope

- Driver app and admin web portals.
- External AI/ML model validation and hardware sensors outside the mobile device.
- Third-party service SLAs not controlled by the app team.

## 4. Assumptions and Constraints

- Firebase project, Cloud Functions, and SMS gateway are configured and accessible.
- FCM and Google Maps API keys are valid for test environments.
- Testers have at least one Android device and one iOS device.
- Test data can be created in Firestore for buses, drivers, routes, and hazard zones.

## 5. Test Strategy

### 5.1 Test Levels

- System testing (end-to-end app flows).
- Integration testing (Firebase Auth, Firestore, Cloud Functions, FCM, SMS).
- Regression testing for critical flows.
- User acceptance testing for main journeys.

### 5.2 Test Types

- Functional and negative testing.
- Security and access control (Firestore rules, auth).
- Usability and accessibility checks.
- Localization (English, Sinhala, Tamil).
- Compatibility (Android and iOS versions, device sizes).
- Performance sanity checks (launch, map loading, QR scan response).
- Offline and network resilience.

### 5.3 Test Approach

- Manual end-to-end validation for user journeys.
- Targeted API validation using Firebase emulator or staging project.
- Use dedicated test accounts and test data in Firestore.
- Capture logs for Cloud Functions and notification delivery.

## 6. Test Environment

### 6.1 Platforms

- Android: 10, 12, 13, 14.
- iOS: 15, 16, 17.

### 6.2 Devices (Example Set)

- Android: low-end, mid-range, flagship.
- iOS: iPhone SE (small), iPhone 13/14 (mid), iPhone Pro Max (large).

### 6.3 Backend

- Firebase Auth, Firestore, Cloud Functions.
- FCM for push notifications.
- SMS provider for OTP.
- Google Maps API for tracking and map views.

## 7. Test Data

- Passenger accounts: new user, verified user, inactive user.
- Buses: active, inactive, different routes and statuses.
- Drivers: active, inactive, varying safety scores.
- Routes: short, long, multiple stops.
- Hazard zones: low, high severity.
- Feedback entries: positive, negative, spam-like.
- Notification tokens: valid, expired, invalid.

## 8. Entry Criteria

- Build is deployed to testers and installs successfully.
- Firebase environment configured and accessible.
- SMS gateway credentials active and test credits available.
- Test data seeded in Firestore.

## 9. Exit Criteria

- All critical and high severity defects are fixed or accepted.
- Core flows pass on Android and iOS.
- No blocker in onboarding, login, OTP, dashboard, feedback, tracking, or notifications.
- Test summary report delivered.

## 10. Deliverables

- Test Plan document.
- Test Cases document.
- Defect reports and test execution report.
- Test summary report.

## 11. Risks and Mitigation

| Risk | Impact | Mitigation |
| --- | --- | --- |
| SMS delivery delays | OTP failures | Use multiple carriers and retry tests |
| Push notification delivery issues | Missed alerts | Validate tokens and FCM logs |
| Firestore rules misconfig | Access issues | Validate rules with read/write tests |
| Maps API limits | Tracking failures | Use staging keys and monitor usage |
| Device permission variations | Feature failures | Test on multiple OS versions |

## 12. Roles and Responsibilities

- QA Lead: test planning, execution tracking.
- QA Engineer: execute tests, report defects.
- Developer: defect fixes and support.
- Product Owner: UAT sign-off.

## 13. Schedule (To Be Confirmed)

- Test plan review: TBD
- Test case review: TBD
- Test execution window: TBD
- Regression window: TBD
- UAT sign-off: TBD

## 14. Traceability (Feature to Test Suites)

| Feature | Test Suite |
| --- | --- |
| Language selection | LANG, SET |
| Onboarding | ONB |
| Auth and OTP | AUTH, OTP |
| Biometric and persistent login | BIO, AUTH |
| Passenger profile | PROF |
| Dashboard | DASH |
| QR scan | QR |
| Live tracking | TRK |
| Bus and driver info | BUS, DRV |
| Safety and emergency | SAF |
| Feedback | FEED |
| Reward points | RWD |
| Notifications | NOTIF |
| Security rules | SEC |
| Offline and resilience | OFF |
| Localization | LOC |
| Performance | PERF |
| Accessibility | ACC |

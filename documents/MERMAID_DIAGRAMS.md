# SafeDriver Passenger App - Architecture & Design Diagrams

This document contains comprehensive architecture diagrams including Class Diagram, Activity Diagram, Sequence Diagram, and Design Patterns used in the SafeDriver Passenger Application.

---

## 1. CLASS DIAGRAM

Shows the overall structure and relationships between major classes, models, services, and controllers in the application.

```mermaid
classDiagram
    %% Models
    class UserModel {
        -String id
        -String firstName
        -String lastName
        -String email
        -String phoneNumber
        -String profileImageUrl
        -DateTime dateOfBirth
        -String gender
        -Address address
        -EmergencyContact emergencyContact
        -UserPreferences preferences
        -DateTime createdAt
        -DateTime updatedAt
        -bool isVerified
        -bool isActive
        +String fullName
        +String displayName
        +fromJson(Map)
        +toJson() Map
    }

    class PassengerModel {
        -String id
        -String firstName
        -String lastName
        -String email
        -String phoneNumber
        -String profileImageUrl
        -DateTime dateOfBirth
        -String gender
        -PassengerAddress address
        -PassengerEmergencyContact emergencyContact
        -PassengerPreferences preferences
        -PassengerStats stats
        -List~String~ favoriteRoutes
        -List~String~ favoriteBuses
        -List~String~ recentSearches
        -DateTime createdAt
        -DateTime updatedAt
        +String fullName
        +String displayName
        +fromJson(Map)
        +toJson() Map
    }

    class BusModel {
        -String id
        -String busNumber
        -String routeNumber
        -String registration
        -BusType busType
        -int passengerCapacity
        -String driverId
        -String driverName
        -String imageUrl
        -BusStatus status
        -LocationModel currentLocation
        -double currentSpeed
        -double heading
        -double safetyScore
        -List~String~ amenities
        -BusSpecifications specifications
        -MaintenanceInfo maintenanceInfo
        -DateTime lastUpdated
        -bool isActive
        +String displayName
        +String routeDisplay
        +bool isOnline
        +bool isTracking
        +fromJson(Map)
        +toJson() Map
    }

    class DriverModel {
        -String id
        -String firstName
        -String lastName
        -String email
        -String phoneNumber
        -String licenseNumber
        -DateTime licenseExpiry
        -DriverStatus status
        -double safetyRating
        -int yearsOfExperience
        -List~String~ certifications
        -DateTime createdAt
        -DateTime updatedAt
        +String fullName
        +bool isLicenseValid
    }

    class LocationModel {
        -double latitude
        -double longitude
        -double accuracy
        -double speed
        -double heading
        -DateTime timestamp
        +double distanceTo(LocationModel)
    }

    class FeedbackModel {
        -String id
        -String passengerId
        -String busId
        -String driverId
        -FeedbackType type
        -int rating
        -String message
        -List~String~ attachments
        -DateTime createdAt
        -bool resolved
    }

    class SafetyAlertModel {
        -String id
        -String busId
        -String driverId
        -AlertType type
        -AlertSeverity severity
        -String description
        -LocationModel location
        -DateTime createdAt
        -bool isResolved
    }

    class HazardZoneModel {
        -String id
        -String zoneName
        -LocationModel center
        -double radius
        -HazardType type
        -String description
        -List~String~ affectedRoutes
        -bool isActive
    }

    %% Services
    class AuthService {
        -FirebaseAuth _firebaseAuth
        -StorageService _storage
        +Future~void~ initialize()
        +Future~UserCredential~ signInWithEmailAndPassword()
        +Future~UserCredential~ createUserWithEmailAndPassword()
        +Future~void~ signOut()
        +Future~void~ verifyPhoneNumber()
        +Stream~User~ get authStateChanges
    }

    class FirebaseService {
        -FirebaseFirestore _firestore
        -FirebaseAuth _auth
        +Future~void~ initialize()
        +Future~DocumentSnapshot~ getUserData(String uid)
        +Future~void~ updateUserData(String uid, Map data)
        +Future~List~ queryCollection(String path, Query query)
        +Stream get getRealtimeStream(String path)
    }

    class PassengerService {
        -FirebaseService _firebaseService
        +Future~PassengerModel~ getPassengerData(String passengerId)
        +Future~void~ updatePassengerProfile()
        +Future~void~ addFavoriteRoute()
        +Future~void~ removeFavoriteRoute()
        +Future~List~ getUserFeedbacks()
    }

    class DashboardService {
        -FirebaseService _firebaseService
        +Future~List~ getNearbyBuses(LocationModel)
        +Future~BusModel~ getBusDetails(String busId)
        +Future~DriverModel~ getDriverDetails(String driverId)
        +Stream~LocationModel~ getRealtimeBusLocation(String busId)
        +Future~List~ getPopularRoutes()
    }

    class FeedbackService {
        -FirebaseService _firebaseService
        -EmailService _emailService
        +Future~void~ submitFeedback(FeedbackModel)
        +Future~List~ getUserFeedbacks(String passengerId)
        +Future~void~ updateFeedbackStatus()
        +Future~void~ sendFeedbackNotification()
    }

    class NotificationService {
        -FirebaseMessaging _firebaseMessaging
        -FlutterLocalNotifications _localNotifications
        +Future~void~ initialize()
        +Future~void~ requestPermissions()
        +Future~void~ handleMessage(RemoteMessage)
        +Stream~RemoteMessage~ get onMessage
    }

    class LocationService {
        -GeolocatorPlatform _geolocator
        +Future~LocationModel~ getCurrentLocation()
        +Stream~LocationModel~ get positionStream
        +Future~List~ getAddressFromCoordinates(double, double)
        +Future~bool~ isLocationPermissionGranted()
    }

    class StorageService {
        -SharedPreferences _prefs
        +Future~void~ initialize()
        +Future~void~ saveBool(String key, bool value)
        +Future~void~ saveString(String key, String value)
        +bool? getBool(String key)
        +String? getString(String key)
        +Future~void~ clear()
    }

    class EmailService {
        -SendGrid _sendGrid
        +Future~void~ sendFeedbackEmail()
        +Future~void~ sendVerificationEmail()
        +Future~void~ sendNotificationEmail()
    }

    class CrashlyticsService {
        -FirebaseCrashlytics _crashlytics
        +void recordError(dynamic exception, StackTrace)
        +void setUserIdentifier(String userId)
        +void logMessage(String message)
    }

    %% Controllers
    class AuthController {
        -FirebaseService _firebaseService
        -StorageService _storageService
        -NotificationService _notificationService
        -UserRepository _userRepository
        +Future~void~ signInWithEmail()
        +Future~void~ signUpWithEmail()
        +Future~void~ signInWithGoogle()
        +Future~void~ verifyOTP()
        +Future~void~ signOut()
        +Future~void~ resetPassword()
    }

    class DashboardController {
        -DashboardService _dashboardService
        -LocationService _locationService
        -PassengerService _passengerService
        +Future~void~ loadDashboardData()
        +Future~void~ searchBuses()
        +Future~void~ trackBus(String busId)
        +Future~void~ reportSafetyIssue()
        +Future~List~ getRecommendedBuses()
    }

    %% Repositories
    class UserRepository {
        -FirebaseService _firebaseService
        +Future~UserModel~ getUserById(String uid)
        +Future~void~ createUser(UserModel)
        +Future~void~ updateUser(UserModel)
        +Future~void~ deleteUser(String uid)
        +Stream~UserModel~ getUserStream(String uid)
    }

    class PassengerRepository {
        -FirebaseService _firebaseService
        +Future~PassengerModel~ getPassengerById(String id)
        +Future~void~ createPassenger(PassengerModel)
        +Future~void~ updatePassenger(PassengerModel)
        +Future~List~ getAllPassengers()
    }

    class BusRepository {
        -FirebaseService _firebaseService
        +Future~BusModel~ getBusById(String id)
        +Future~List~ getAllBuses()
        +Future~List~ searchBuses(Query filters)
        +Stream~LocationModel~ getBusLocationStream(String busId)
    }

    class DriverRepository {
        -FirebaseService _firebaseService
        +Future~DriverModel~ getDriverById(String id)
        +Future~List~ getAllDrivers()
        +Future~void~ updateDriverRating(String driverId, double rating)
    }

    class FeedbackRepository {
        -FirebaseService _firebaseService
        +Future~void~ saveFeedback(FeedbackModel)
        +Future~List~ getFeedbackByPassenger(String passengerId)
        +Future~List~ getFeedbackByBus(String busId)
        +Future~void~ resolveFeedback(String feedbackId)
    }

    class SafetyRepository {
        -FirebaseService _firebaseService
        +Future~void~ reportSafetyIssue(SafetyAlertModel)
        +Future~List~ getActiveAlerts()
        +Future~List~ getHazardZones(LocationModel, double radius)
    }

    %% State Management
    class LanguageController {
        -AppLanguage state
        +Future~void~ changeLanguage(AppLanguage)
        +Future~void~ _loadSavedLanguage()
    }

    %% UI Layer
    class AuthPage {
        +Widget build(BuildContext)
    }

    class DashboardPage {
        +Widget build(BuildContext)
    }

    class BusDetailPage {
        +Widget build(BuildContext)
    }

    class ProfilePage {
        +Widget build(BuildContext)
    }

    %% Relationships
    AuthService --> StorageService
    FirebaseService --> Firestore
    PassengerService --> FirebaseService
    DashboardService --> FirebaseService
    FeedbackService --> FirebaseService
    FeedbackService --> EmailService
    NotificationService --> FirebaseMessaging
    LocationService --> GeolocatorPlatform
    CrashlyticsService --> FirebaseCrashlytics

    AuthController --> FirebaseService
    AuthController --> StorageService
    AuthController --> NotificationService
    AuthController --> UserRepository
    DashboardController --> DashboardService
    DashboardController --> LocationService
    DashboardController --> PassengerService

    UserRepository --> FirebaseService
    PassengerRepository --> FirebaseService
    BusRepository --> FirebaseService
    DriverRepository --> FirebaseService
    FeedbackRepository --> FirebaseService
    SafetyRepository --> FirebaseService

    AuthPage --> AuthController
    DashboardPage --> DashboardController
    BusDetailPage --> BusModel
    BusDetailPage --> DashboardService
    ProfilePage --> PassengerService

    UserModel --> Address
    UserModel --> EmergencyContact
    UserModel --> UserPreferences
    PassengerModel --> PassengerAddress
    PassengerModel --> PassengerEmergencyContact
    PassengerModel --> PassengerPreferences
    PassengerModel --> PassengerStats
    BusModel --> LocationModel
    BusModel --> BusSpecifications
    BusModel --> MaintenanceInfo
    BusModel --> SafetyFeature
    FeedbackModel --> FeedbackType
    SafetyAlertModel --> LocationModel
    HazardZoneModel --> LocationModel
```

---

## 2. ACTIVITY DIAGRAM

Shows the flow of activities and user interactions in the application.

```mermaid
graph TD
    Start([User Launches App]) --> CheckAuth{Is User<br/>Authenticated?}
    
    CheckAuth -->|No| AuthFlow[Authentication Flow]
    CheckAuth -->|Yes| DashboardFlow[Dashboard Flow]
    
    AuthFlow --> SelectAuthType{Select<br/>Authentication Type}
    SelectAuthType -->|Email/Password| EnterCreds[Enter Email & Password]
    SelectAuthType -->|Phone| EnterPhone[Enter Phone Number]
    SelectAuthType -->|Social Login| SelectSocial{Select Social<br/>Provider}
    
    SelectSocial -->|Google| SignGoogle[Sign in with Google]
    SelectSocial -->|Facebook| SignFB[Sign in with Facebook]
    
    EnterCreds --> ValidateAuth{Credentials<br/>Valid?}
    EnterPhone --> RequestOTP[Request OTP]
    RequestOTP --> EnterOTP[Enter OTP Code]
    EnterOTP --> ValidateOTP{OTP<br/>Valid?}
    
    SignGoogle --> ValidateAuth
    SignFB --> ValidateAuth
    
    ValidateAuth -->|No| ShowError1[Show Error Message]
    ShowError1 --> AuthFlow
    
    ValidateOTP -->|No| ShowError2[Show Error Message]
    ShowError2 --> EnterOTP
    
    ValidateAuth -->|Yes| CreateProfile[Create/Load User Profile]
    ValidateOTP -->|Yes| CreateProfile
    
    CreateProfile --> SetLanguage[Set Language Preference]
    SetLanguage --> InitServices[Initialize Services]
    InitServices --> DashboardFlow
    
    DashboardFlow --> LoadDashboard[Load Dashboard]
    LoadDashboard --> GetLocation[Get Current Location]
    GetLocation --> LoadBuses[Load Nearby Buses]
    LoadBuses --> DisplayDashboard[Display Dashboard]
    
    DisplayDashboard --> UserAction{User Action}
    
    UserAction -->|Search Bus| SearchFlow[Search & Filter Buses]
    UserAction -->|View Bus Details| ViewBusFlow[View Bus Details & Track]
    UserAction -->|Give Feedback| FeedbackFlow[Submit Feedback]
    UserAction -->|View Safety Alerts| SafetyFlow[View Safety Information]
    UserAction -->|Edit Profile| ProfileFlow[Edit User Profile]
    UserAction -->|View Hazards| HazardFlow[View Hazard Zones]
    
    SearchFlow --> FilterBuses[Apply Filters]
    FilterBuses --> DisplayResults[Display Search Results]
    DisplayResults --> SelectBus{Select<br/>Bus?}
    SelectBus -->|Yes| ViewBusFlow
    SelectBus -->|No| DashboardFlow
    
    ViewBusFlow --> GetBusInfo[Get Bus Details]
    GetBusInfo --> GetLiveLocation[Get Live Location]
    GetLiveLocation --> DisplayTracking[Display Bus on Map]
    DisplayTracking --> ViewDriver[View Driver Info]
    ViewDriver --> BookAction{Book or<br/>Back?}
    BookAction -->|Back| DashboardFlow
    BookAction -->|Book| BookingFlow[Booking Process]
    BookingFlow --> ConfirmBooking[Confirm Booking]
    ConfirmBooking --> PaymentFlow[Process Payment]
    PaymentFlow --> SendNotification[Send Confirmation]
    SendNotification --> DashboardFlow
    
    FeedbackFlow --> SelectFeedbackType{Select<br/>Feedback Type}
    SelectFeedbackType -->|Positive| PositiveFeedback[Rate: 5 Stars]
    SelectFeedbackType -->|Negative| NegativeFeedback[Report Issue]
    
    PositiveFeedback --> EnterComments[Enter Comments]
    NegativeFeedback --> SelectIssueType[Select Issue Type]
    SelectIssueType --> EnterIssueDetails[Enter Issue Details]
    EnterComments --> SubmitFeedback[Submit Feedback]
    EnterIssueDetails --> SubmitFeedback
    
    SubmitFeedback --> SaveFeedback[Save to Database]
    SaveFeedback --> NotifyAdmin[Notify Admin]
    NotifyAdmin --> ShowConfirmation[Show Confirmation]
    ShowConfirmation --> DashboardFlow
    
    SafetyFlow --> GetAlerts[Get Active Safety Alerts]
    GetAlerts --> DisplayAlerts[Display Alerts on Map]
    DisplayAlerts --> ViewAlertDetail{View<br/>Alert Details?}
    ViewAlertDetail -->|Yes| ShowAlertInfo[Show Alert Information]
    ViewAlertDetail -->|No| DashboardFlow
    ShowAlertInfo --> DashboardFlow
    
    HazardFlow --> GetHazards[Get Nearby Hazard Zones]
    GetHazards --> DisplayHazards[Display Hazards on Map]
    DisplayHazards --> DashboardFlow
    
    ProfileFlow --> LoadProfile[Load User Profile]
    LoadProfile --> EditDetails[Edit Personal Details]
    EditDetails --> UpdateAddress[Update Address]
    UpdateAddress --> UpdateEmergency[Update Emergency Contact]
    UpdateEmergency --> UploadPhoto[Upload Profile Photo]
    UploadPhoto --> SaveProfile[Save Changes]
    SaveProfile --> ShowSuccess[Show Success Message]
    ShowSuccess --> DashboardFlow
    
    UserAction -->|Logout| LogoutFlow[Sign Out]
    LogoutFlow --> ClearData[Clear Local Data]
    ClearData --> ReturnToAuth[Return to Auth Screen]
    ReturnToAuth --> Start
```

---

## 3. SEQUENCE DIAGRAM

Shows the interaction between different components during key user workflows.

### 3.1 User Authentication Sequence

```mermaid
sequenceDiagram
    actor User
    participant UI as Auth UI
    participant AuthCtrl as AuthController
    participant AuthSvc as AuthService
    participant Firebase as Firebase Auth
    participant UserRepo as UserRepository
    participant Storage as StorageService
    participant Notify as NotificationService

    User->>UI: Enter Email & Password
    UI->>AuthCtrl: signInWithEmail(email, pwd)
    AuthCtrl->>AuthCtrl: Set Loading State
    AuthCtrl->>AuthSvc: signInWithEmailAndPassword(email, pwd)
    AuthSvc->>Firebase: signInWithEmailAndPassword()
    Firebase-->>AuthSvc: UserCredential
    AuthSvc->>Storage: Save Session Token
    AuthSvc-->>AuthCtrl: UserCredential
    AuthCtrl->>AuthCtrl: Call Auth State Listener
    AuthCtrl->>UserRepo: getUserById(uid)
    UserRepo->>Firebase: getDocument(/users/{uid})
    Firebase-->>UserRepo: UserModel
    UserRepo-->>AuthCtrl: UserModel
    AuthCtrl->>Storage: Save User Data Locally
    AuthCtrl->>Notify: Initialize Notifications
    Notify->>Firebase: Get FCM Token
    Firebase-->>Notify: FCM Token
    AuthCtrl->>AuthCtrl: Update State to Authenticated
    AuthCtrl-->>UI: Authentication Success
    UI->>User: Navigate to Dashboard
```

### 3.2 Bus Search and Tracking Sequence

```mermaid
sequenceDiagram
    actor User
    participant Dashboard as Dashboard UI
    participant DashCtrl as DashboardController
    participant DashSvc as DashboardService
    participant LocSvc as LocationService
    participant Firebase as Firestore
    participant Maps as Google Maps API

    User->>Dashboard: Open Dashboard
    Dashboard->>DashCtrl: loadDashboardData()
    DashCtrl->>LocSvc: getCurrentLocation()
    LocSvc->>Maps: Get Current Position
    Maps-->>LocSvc: LocationModel
    LocSvc-->>DashCtrl: LocationModel
    DashCtrl->>DashSvc: getNearbyBuses(location, radius)
    DashSvc->>Firebase: Query buses near location
    Firebase-->>DashSvc: List<BusModel>
    DashSvc-->>DashCtrl: List<BusModel>
    DashCtrl->>DashCtrl: Update State with Buses
    DashCtrl-->>Dashboard: Display Nearby Buses

    User->>Dashboard: Search for Bus
    Dashboard->>DashCtrl: searchBuses(filters)
    DashCtrl->>DashSvc: queryBuses(searchCriteria)
    DashSvc->>Firebase: Complex Query for Buses
    Firebase-->>DashSvc: Filtered Buses
    DashSvc-->>DashCtrl: List<BusModel>
    DashCtrl-->>Dashboard: Display Search Results

    User->>Dashboard: Tap Bus to Track
    Dashboard->>DashCtrl: trackBus(busId)
    DashCtrl->>DashSvc: getRealtimeBusLocation(busId)
    DashSvc->>Firebase: Subscribe to Real-time Updates
    Firebase-->>DashSvc: LocationModel Stream
    DashSvc-->>DashCtrl: Location Updates
    DashCtrl-->>Dashboard: Update Bus Position on Map
    Dashboard->>Maps: Display Bus Location
    Maps-->>Dashboard: Bus Marker Updated
```

### 3.3 Feedback Submission Sequence

```mermaid
sequenceDiagram
    actor User
    participant FeedbackUI as Feedback UI
    participant FeedbackCtrl as FeedbackController
    participant FeedbackSvc as FeedbackService
    participant Firebase as Firestore
    participant EmailSvc as EmailService
    participant NotifSvc as NotificationService

    User->>FeedbackUI: Open Feedback Form
    FeedbackUI->>FeedbackUI: Load Bus & Driver Info

    User->>FeedbackUI: Select Rating & Comments
    FeedbackUI->>FeedbackUI: Validate Input

    User->>FeedbackUI: Submit Feedback
    FeedbackUI->>FeedbackCtrl: submitFeedback(feedbackModel)
    FeedbackCtrl->>FeedbackSvc: submitFeedback(feedbackModel)
    FeedbackSvc->>Firebase: Save Feedback Document
    Firebase-->>FeedbackSvc: Document Saved
    FeedbackSvc->>EmailSvc: Send Feedback Notification Email
    EmailSvc-->>FeedbackSvc: Email Sent
    FeedbackSvc->>Firebase: Update Driver Rating
    Firebase-->>FeedbackSvc: Rating Updated
    FeedbackSvc->>NotifSvc: Send Push Notification to Admin
    NotifSvc-->>FeedbackSvc: Notification Sent
    FeedbackSvc-->>FeedbackCtrl: Feedback Submitted Successfully
    FeedbackCtrl-->>FeedbackUI: Show Success Message
    FeedbackUI->>User: Display Confirmation
```

### 3.4 Safety Alert Reporting Sequence

```mermaid
sequenceDiagram
    actor User
    participant SafetyUI as Safety Alert UI
    participant SafetyCtrl as SafetyController
    participant SafetySvc as SafetyService
    participant LocSvc as LocationService
    participant Firebase as Firestore
    participant Notify as NotificationService

    User->>SafetyUI: Tap Report Safety Issue
    SafetyUI->>SafetyUI: Open Report Form

    User->>SafetyUI: Select Issue Type & Severity
    SafetyUI->>SafetyUI: Capture Screenshot/Photo (Optional)

    User->>SafetyUI: Submit Report
    SafetyUI->>SafetyCtrl: reportSafetyIssue(alertModel)
    SafetyCtrl->>LocSvc: getCurrentLocation()
    LocSvc-->>SafetyCtrl: LocationModel
    SafetyCtrl->>SafetySvc: createSafetyAlert(alertWithLocation)
    SafetySvc->>Firebase: Save Alert Document
    Firebase-->>SafetySvc: Alert Document Created
    SafetySvc->>Firebase: Update Bus Safety Score
    Firebase-->>SafetySvc: Score Updated
    SafetySvc->>Notify: Send Alert to Other Nearby Users
    Notify-->>SafetySvc: Notifications Sent
    SafetySvc->>Notify: Send Alert to Admin/Driver
    Notify-->>SafetySvc: Notifications Sent
    SafetySvc-->>SafetyCtrl: Alert Created Successfully
    SafetyCtrl-->>SafetyUI: Show Confirmation
    SafetyUI->>User: Alert Submitted
```

---

## 4. DESIGN PATTERNS

### 4.1 Singleton Pattern

**Usage**: Single instance across the entire application lifecycle

```mermaid
classDiagram
    class StorageService {
        -static StorageService _instance
        -SharedPreferences _prefs
        -StorageService._internal()
        +static StorageService get instance
        +Future~void~ initialize()
        +saveBool(String, bool)
        +getString(String) String
    }

    class AuthService {
        -static AuthService _instance
        -FirebaseAuth _firebaseAuth
        -AuthService._internal()
        +static AuthService get instance
        +Future~void~ initialize()
        +Future~UserCredential~ signInWithEmailAndPassword()
    }

    class CrashlyticsService {
        -static CrashlyticsService _instance
        -FirebaseCrashlytics _crashlytics
        +static CrashlyticsService get instance
        +void recordError()
        +void logMessage()
    }
```

**Benefits**:
- Ensures single instance of resource-intensive services
- Centralized management of Firebase connections
- Thread-safe initialization

---

### 4.2 Repository Pattern

**Usage**: Abstract data access logic and provide a clean API

```mermaid
classDiagram
    class Repository {
        <<interface>>
    }

    class UserRepository {
        -FirebaseService _firebaseService
        +Future~UserModel~ getUserById(String)
        +Future~void~ createUser(UserModel)
        +Future~void~ updateUser(UserModel)
        +Future~void~ deleteUser(String)
    }

    class PassengerRepository {
        -FirebaseService _firebaseService
        +Future~PassengerModel~ getPassengerById(String)
        +Future~List~ getAllPassengers()
        +Future~void~ updatePassenger(PassengerModel)
    }

    class BusRepository {
        -FirebaseService _firebaseService
        +Future~BusModel~ getBusById(String)
        +Future~List~ getAllBuses()
        +Future~List~ searchBuses(Query)
    }

    class FeedbackRepository {
        -FirebaseService _firebaseService
        +Future~void~ saveFeedback(FeedbackModel)
        +Future~List~ getFeedbackByPassenger(String)
        +Future~List~ getFeedbackByBus(String)
    }

    Repository <|-- UserRepository
    Repository <|-- PassengerRepository
    Repository <|-- BusRepository
    Repository <|-- FeedbackRepository
```

**Benefits**:
- Decouples business logic from data source
- Easy to mock for testing
- Centralized data access operations

---

### 4.3 Riverpod State Management Pattern

**Usage**: Manage application state with providers

```mermaid
classDiagram
    class StateNotifier {
        <<abstract>>
        +state T
    }

    class AuthController {
        -FirebaseService _firebaseService
        -StorageService _storageService
        -UserRepository _userRepository
        -AuthControllerState state
        +Future~void~ signInWithEmail()
        +Future~void~ signOut()
        +Future~void~ verifyOTP()
        -void _initializeAuthListener()
    }

    class LanguageController {
        -AppLanguage state
        +Future~void~ changeLanguage(AppLanguage)
        -Future~void~ _loadSavedLanguage()
    }

    class DashboardController {
        -DashboardService _dashboardService
        -LocationService _locationService
        -Future~void~ loadDashboardData()
        -Future~void~ searchBuses()
    }

    StateNotifier <|-- AuthController
    StateNotifier <|-- LanguageController
    StateNotifier <|-- DashboardController
```

**Benefits**:
- Reactive state management
- Type-safe providers
- Easy to compose providers

---

### 4.4 Observer Pattern

**Usage**: Real-time data updates through streams

```mermaid
classDiagram
    class StreamController {
        <<abstract>>
        -Stream _stream
        +Stream getStream()
    }

    class RealtimeDataObserver {
        -FirebaseService _firebaseService
        +Stream~LocationModel~ getBusLocationStream(String busId)
        +Stream~UserModel~ getUserStream(String uid)
        +Stream~List~ getAlertsStream()
    }

    class LocationService {
        -GeolocatorPlatform _geolocator
        +Stream~LocationModel~ get positionStream
        -void _listenToLocationChanges()
    }

    class NotificationService {
        -FirebaseMessaging _firebaseMessaging
        +Stream~RemoteMessage~ get onMessage
        +Stream~RemoteMessage~ get onMessageOpenedApp
    }

    StreamController <|-- RealtimeDataObserver
    StreamController <|-- LocationService
    StreamController <|-- NotificationService
```

**Benefits**:
- Real-time updates without polling
- Reactive UI updates
- Efficient resource utilization

---

### 4.5 Factory Pattern

**Usage**: Create objects with different implementations

```mermaid
classDiagram
    class AuthenticationFactory {
        +static Authentication createAuthMethod(AuthType)
        +static Authentication createEmailAuth()
        +static Authentication createPhoneAuth()
        +static Authentication createSocialAuth(SocialProvider)
    }

    class Authentication {
        <<abstract>>
        +Future~UserCredential~ authenticate()
    }

    class EmailAuthentication {
        -FirebaseAuth _firebaseAuth
        +Future~UserCredential~ authenticate()
        +Future~UserCredential~ register()
    }

    class PhoneAuthentication {
        -FirebaseAuth _firebaseAuth
        +Future~void~ requestOTP()
        +Future~UserCredential~ verifyOTP()
    }

    class GoogleAuthentication {
        -GoogleSignIn _googleSignIn
        +Future~UserCredential~ authenticate()
    }

    Authentication <|-- EmailAuthentication
    Authentication <|-- PhoneAuthentication
    Authentication <|-- GoogleAuthentication
    AuthenticationFactory --> Authentication
```

**Benefits**:
- Flexible object creation
- Easy to add new authentication methods
- Centralized object creation logic

---

### 4.6 Service Locator Pattern (Dependency Injection)

**Usage**: Manage dependencies and service instances

```mermaid
classDiagram
    class ServiceLocator {
        -static Map~Type, dynamic~ _services
        +static void register(Type, dynamic instance)
        +static T get~T~()
        +static void unregister(Type)
    }

    class AppProviders {
        +static void setupProviders(ProviderContainer)
        +FirebaseService firebaseServiceProvider
        +AuthService authServiceProvider
        +StorageService storageServiceProvider
        +LocationService locationServiceProvider
    }

    ServiceLocator --> AppProviders
```

**Code Example** (from app_providers.dart):
```dart
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthControllerState>((ref) {
  return AuthController(
    firebaseService: ref.watch(firebaseServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    notificationService: ref.watch(notificationServiceProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});
```

**Benefits**:
- Centralized dependency management
- Loose coupling between components
- Easy to swap implementations for testing

---

### 4.7 Builder Pattern

**Usage**: Construct complex objects step by step

```mermaid
classDiagram
    class UserModelBuilder {
        -String id
        -String firstName
        -String lastName
        -String email
        -String phoneNumber
        +setId(String) UserModelBuilder
        +setFirstName(String) UserModelBuilder
        +setLastName(String) UserModelBuilder
        +setEmail(String) UserModelBuilder
        +setPhoneNumber(String) UserModelBuilder
        +setAddress(Address) UserModelBuilder
        +setEmergencyContact(EmergencyContact) UserModelBuilder
        +build() UserModel
    }

    class UserModel {
        -String id
        -String firstName
        -String lastName
        -String email
        -String phoneNumber
        -Address address
        -EmergencyContact emergencyContact
    }

    UserModelBuilder --> UserModel
```

**Benefits**:
- Readable object construction
- Default values support
- Validation at build time

---

### 4.8 Strategy Pattern

**Usage**: Select different algorithms at runtime

```mermaid
classDiagram
    class SearchStrategy {
        <<abstract>>
        +Future~List~ search(SearchCriteria criteria)
    }

    class BusSearchStrategy {
        -FirebaseService _firebaseService
        +Future~List~ search(SearchCriteria)
        -Future~List~ filterByRoute()
        -Future~List~ filterByTime()
        -Future~List~ filterByPrice()
    }

    class DriverSearchStrategy {
        -FirebaseService _firebaseService
        +Future~List~ search(SearchCriteria)
        -Future~List~ filterByRating()
        -Future~List~ filterByExperience()
    }

    class RouteSearchStrategy {
        -FirebaseService _firebaseService
        +Future~List~ search(SearchCriteria)
        -Future~List~ filterByDistance()
        -Future~List~ filterByPopularity()
    }

    SearchStrategy <|-- BusSearchStrategy
    SearchStrategy <|-- DriverSearchStrategy
    SearchStrategy <|-- RouteSearchStrategy
```

**Benefits**:
- Flexible algorithm selection
- Easy to add new search strategies
- Runtime behavior modification

---

### 4.9 Adapter Pattern

**Usage**: Convert incompatible interfaces

```mermaid
classDiagram
    class LocationModel {
        -double latitude
        -double longitude
        -double accuracy
    }

    class GeoPoint {
        -double lat
        -double lng
    }

    class LocationAdapter {
        -LocationModel _location
        +double get latitude
        +double get longitude
        +GeoPoint toGeoPoint()
        +static LocationModel fromGeoPoint(GeoPoint)
    }

    LocationAdapter --> LocationModel
    LocationAdapter --> GeoPoint
```

**Benefits**:
- Seamless integration with third-party libraries
- Reduces code duplication
- Centralizes conversion logic

---

### 4.10 Facade Pattern

**Usage**: Provide simplified interface to complex subsystem

```mermaid
classDiagram
    class UserManagementFacade {
        -AuthService _authService
        -UserRepository _userRepository
        -PassengerRepository _passengerRepository
        -StorageService _storageService
        -NotificationService _notificationService
        +Future~void~ registerNewUser(UserData)
        +Future~void~ loginUser(String, String)
        +Future~void~ logoutUser()
        +Future~UserModel~ getUserProfile()
        +Future~void~ updateUserProfile(UserData)
    }

    class AuthService
    class UserRepository
    class PassengerRepository
    class StorageService
    class NotificationService

    UserManagementFacade --> AuthService
    UserManagementFacade --> UserRepository
    UserManagementFacade --> PassengerRepository
    UserManagementFacade --> StorageService
    UserManagementFacade --> NotificationService
```

**Benefits**:
- Simplified API for clients
- Reduces dependencies
- Easier to test

---

## 5. ARCHITECTURAL PATTERNS

### 5.1 Clean Architecture (MVVM)

```mermaid
graph TB
    subgraph UI["UI Layer (Presentation)"]
        Pages["Pages"]
        Widgets["Widgets"]
        Controllers["Controllers"]
    end

    subgraph Domain["Domain Layer"]
        Entities["Entities/Models"]
        Repositories["Abstract Repositories"]
        Usecases["Use Cases"]
    end

    subgraph Data["Data Layer"]
        DataServices["Firebase Services"]
        DataRepositories["Repository Implementations"]
        LocalStorage["Local Storage"]
        RemoteAPI["Remote API"]
    end

    subgraph External["External Services"]
        Firebase["Firebase"]
        GoogleMaps["Google Maps"]
        SendGrid["SendGrid"]
        Geolocator["Geolocator"]
    end

    Pages --> Controllers
    Widgets --> Controllers
    Controllers --> Usecases
    Usecases --> Repositories
    Repositories -.-> DataRepositories
    DataRepositories --> DataServices
    DataServices --> Firebase
    DataServices --> GoogleMaps
    DataServices --> SendGrid
    DataServices --> Geolocator
    DataRepositories --> LocalStorage
```

**Key Principles**:
- **Separation of Concerns**: Each layer has specific responsibilities
- **Dependency Inversion**: High-level modules depend on abstractions
- **Testability**: Each layer can be tested independently
- **Maintainability**: Changes in one layer don't affect others

---

### 5.2 State Management Architecture

```mermaid
graph LR
    User["User Interaction"]
    UI["UI (Pages/Widgets)"]
    Provider["Riverpod Providers"]
    Controller["StateNotifier Controller"]
    Service["Business Logic Service"]
    Repository["Repository"]
    DataSource["Data Source (Firebase/Local)"]

    User -->|User Action| UI
    UI -->|Watch Provider| Provider
    Provider -->|Get State| Controller
    Controller -->|Call Methods| Service
    Service -->|CRUD Operations| Repository
    Repository -->|Fetch/Save| DataSource
    DataSource -->|Return Data| Repository
    Repository -->|Return Data| Service
    Service -->|Update State| Controller
    Controller -->|Emit New State| Provider
    Provider -->|Rebuild UI| UI
```

---

## 6. DESIGN PATTERNS SUMMARY TABLE

| Pattern | Location | Purpose | Benefits |
|---------|----------|---------|----------|
| **Singleton** | Services (AuthService, StorageService) | Single instance management | Centralized control, resource efficiency |
| **Repository** | data/repositories/ | Abstract data access | Loose coupling, testability |
| **State Notifier** | controllers/ & providers/ | State management | Reactive UI, type safety |
| **Observer** | LocationService, NotificationService | Real-time updates | Reactive updates, efficiency |
| **Factory** | Authentication methods | Object creation | Flexibility, easy extension |
| **Service Locator** | app_providers.dart | Dependency injection | Loose coupling, modularity |
| **Builder** | Models | Complex object construction | Readable code, validation |
| **Strategy** | Search/Query operations | Algorithm selection | Flexibility, maintainability |
| **Adapter** | Model converters | Interface compatibility | Integration, reusability |
| **Facade** | UserManagementFacade | Simplified API | Usability, modularity |

---

## 7. TECHNOLOGY STACK

```mermaid
graph TB
    subgraph Frontend["Frontend"]
        Flutter["Flutter 3.x"]
        Dart["Dart"]
    end

    subgraph StateManagement["State Management"]
        Riverpod["Riverpod"]
    end

    subgraph Backend["Backend"]
        Firebase["Firebase"]
        Firestore["Cloud Firestore"]
        Auth["Firebase Auth"]
        Functions["Cloud Functions"]
        Storage["Cloud Storage"]
    end

    subgraph External["External Services"]
        GoogleMaps["Google Maps API"]
        Geolocator["Geolocator"]
        SendGrid["SendGrid Email"]
        LocalAuth["Local Authentication"]
    end

    subgraph Local["Local Storage"]
        SharedPrefs["SharedPreferences"]
        Hive["Hive Database"]
    end

    Flutter --> Riverpod
    Dart --> Flutter
    Flutter --> Firebase
    Riverpod --> Firebase
    Firebase --> Firestore
    Firebase --> Auth
    Firebase --> Functions
    Firebase --> Storage
    Flutter --> GoogleMaps
    Flutter --> Geolocator
    Flutter --> SendGrid
    Flutter --> LocalAuth
    Flutter --> SharedPrefs
    Flutter --> Hive
```

---

## 8. DATA FLOW EXAMPLE: User Authentication

```mermaid
flowchart LR
    subgraph Input["User Input"]
        Email["User Email"]
        Password["User Password"]
    end

    subgraph Processing["Processing Layer"]
        AuthCtrl["AuthController"]
        AuthSvc["AuthService"]
    end

    subgraph DataAccess["Data Access"]
        UserRepo["UserRepository"]
        FirebaseAuth["Firebase Auth"]
    end

    subgraph Storage["Local Storage"]
        SessionStore["Session Storage"]
        UserDataStore["User Data Cache"]
    end

    subgraph Output["Output"]
        State["Controller State"]
        UIUpdate["UI Update"]
    end

    Email --> AuthCtrl
    Password --> AuthCtrl
    AuthCtrl --> AuthSvc
    AuthSvc --> FirebaseAuth
    FirebaseAuth --> UserRepo
    UserRepo --> SessionStore
    UserRepo --> UserDataStore
    SessionStore --> State
    UserDataStore --> State
    State --> UIUpdate
```

---


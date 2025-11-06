# SafeDriver Passenger Mobile Application

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android">
</div>

## 📱 About The Project

SafeDriver Passenger App is an AI-powered real-time driver monitoring and accident prevention system designed specifically for Sri Lanka's public transport sector. The mobile application provides passengers with unprecedented transparency into bus safety, driver performance, and real-time monitoring capabilities.

### 🎯 Key Features

- **Real-time Driver Monitoring** - Live alertness and safety status
- **QR Code Integration** - Instant bus information and feedback system
- **Live Bus Tracking** - GPS-based real-time location tracking
- **Driver & Bus History** - Comprehensive safety records and analytics
- **Hazard Zone Mapping** - Location-based risk assessment
- **Emergency Response** - One-tap emergency alerts
- **Community Safety** - Passenger feedback and safety reporting
- **Predictive Analytics** - AI-powered safety insights

## 🚀 Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language
- **Provider** - State management
- **Material Design 3** - UI/UX design system

### Backend & Services
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Real-time database
- **Firebase Cloud Messaging** - Push notifications
- **Firebase Storage** - File storage
- **Google Maps API** - Maps and location services

### Key Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_messaging: ^14.7.10
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  qr_code_scanner: ^1.0.1
  provider: ^6.1.1
  cached_network_image: ^3.3.0
  fl_chart: ^0.65.0
```

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.16.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android SDK** (API level 21 or higher)
- **Git** for version control
- **Firebase CLI** for backend setup

## ⚙️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/CodeCrafters-Team/safedriver-passenger-app.git
cd safedriver-passenger-app
```

### 2. Install Flutter Dependencies
```bash
flutter clean
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "SafeDriver"
3. Enable the following services:
   - Authentication (Email/Password, Phone)
   - Cloud Firestore
   - Cloud Storage
   - Cloud Messaging

#### Android Configuration
1. Add Android app to Firebase project
2. Package name: `com.codecrafters.safedriver_passenger`
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### Firebase Configuration Files
Create the following configuration files:

**`lib/firebase_options.dart`**
```dart
// Generated file - run `flutterfire configure` to create
```

**`android/app/build.gradle`**
```gradle
// Add at the bottom
apply plugin: 'com.google.gms.google-services'
```

### 4. Environment Setup

Create `.env` file in the root directory:
```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
FIREBASE_WEB_API_KEY=your_firebase_web_api_key
```

### 5. Generate Required Files
```bash
# Generate app icons
flutter packages pub run flutter_launcher_icons:main

# Generate splash screen
flutter packages pub run flutter_native_splash:create
```

## 🏃‍♂️ Running the App

### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor
flutter run --flavor development -t lib/main_dev.dart

# Run with hot reload
flutter run --hot
```

### Build for Production
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build for specific architecture
flutter build apk --target-platform android-arm64 --release
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configurations
│   │   ├── app_constants.dart
│   │   ├── colors.dart
│   │   ├── strings.dart
│   │   └── routes.dart
│   ├── services/           # External services integration
│   │   ├── firebase_service.dart
│   │   ├── location_service.dart
│   │   ├── notification_service.dart
│   │   └── storage_service.dart
│   ├── utils/              # Utility functions and helpers
│   │   ├── validators.dart
│   │   ├── helpers.dart
│   │   ├── date_utils.dart
│   │   └── permissions.dart
│   └── themes/             # App theming
│       ├── app_theme.dart
│       └── custom_theme.dart
├── data/
│   ├── models/             # Data models
│   │   ├── user_model.dart
│   │   ├── bus_model.dart
│   │   ├── driver_model.dart
│   │   ├── journey_model.dart
│   │   └── hazard_zone_model.dart
│   ├── repositories/       # Data layer abstraction
│   │   ├── auth_repository.dart
│   │   ├── bus_repository.dart
│   │   ├── driver_repository.dart
│   │   └── feedback_repository.dart
│   └── datasources/        # Data sources
│       ├── firebase_datasource.dart
│       ├── local_datasource.dart
│       └── api_datasource.dart
├── presentation/
│   ├── screens/            # Application screens
│   │   ├── auth/           # Authentication screens
│   │   │   ├── sign_in_screen.dart
│   │   │   ├── sign_up_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   ├── dashboard/      # Dashboard and home screens
│   │   │   ├── dashboard_screen.dart
│   │   │   └── home_screen.dart
│   │   ├── tracking/       # Live tracking features
│   │   │   ├── live_map_screen.dart
│   │   │   ├── bus_tracking_screen.dart
│   │   │   └── route_tracking_screen.dart
│   │   ├── qr_scanner/     # QR code scanning
│   │   │   ├── qr_scanner_screen.dart
│   │   │   └── qr_result_screen.dart
│   │   ├── driver_info/    # Driver information
│   │   │   ├── driver_profile_screen.dart
│   │   │   ├── driver_history_screen.dart
│   │   │   └── driver_performance_screen.dart
│   │   ├── bus_info/       # Bus information
│   │   │   ├── bus_details_screen.dart
│   │   │   ├── bus_history_screen.dart
│   │   │   └── safety_metrics_screen.dart
│   │   ├── feedback/       # Feedback system
│   │   │   ├── feedback_form_screen.dart
│   │   │   ├── feedback_history_screen.dart
│   │   │   └── rating_screen.dart
│   │   ├── safety/         # Safety features
│   │   │   ├── emergency_screen.dart
│   │   │   ├── hazard_zones_screen.dart
│   │   │   └── safety_tips_screen.dart
│   │   └── settings/       # App settings
│   │       ├── settings_screen.dart
│   │       ├── profile_screen.dart
│   │       └── notifications_screen.dart
│   ├── widgets/            # Reusable UI components
│   │   ├── common/         # Common widgets
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_widget.dart
│   │   │   └── error_widget.dart
│   │   ├── dashboard/      # Dashboard specific widgets
│   │   │   ├── safety_overview_card.dart
│   │   │   ├── quick_actions_grid.dart
│   │   │   ├── current_journey_card.dart
│   │   │   └── live_tracking_panel.dart
│   │   ├── maps/           # Map related widgets
│   │   │   ├── custom_map_widget.dart
│   │   │   ├── bus_marker_widget.dart
│   │   │   └── route_polyline_widget.dart
│   │   └── safety/         # Safety related widgets
│   │       ├── safety_score_widget.dart
│   │       ├── alertness_indicator.dart
│   │       └── hazard_warning_widget.dart
│   └── providers/          # State management
│       ├── auth_provider.dart
│       ├── bus_provider.dart
│       ├── location_provider.dart
│       ├── driver_provider.dart
│       └── feedback_provider.dart
├── main.dart               # App entry point
├── main_dev.dart           # Development entry point
└── main_prod.dart          # Production entry point
```

## 🔧 Configuration

### Firebase Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Bus data is read-only for passengers
    match /buses/{busId} {
      allow read: if request.auth != null;
    }
    
    // Driver data is read-only for passengers
    match /drivers/{driverId} {
      allow read: if request.auth != null;
    }
    
    // Feedback can be created by authenticated users
    match /feedback/{feedbackId} {
      allow read, create: if request.auth != null;
      allow update: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Routes and hazard zones are public read-only
    match /routes/{routeId} {
      allow read: if true;
    }
    
    match /hazardZones/{zoneId} {
      allow read: if true;
    }
  }
}
```

### Google Maps Configuration

**`android/app/src/main/AndroidManifest.xml`**
```xml
<application>
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
</application>
```

### Permissions Configuration

**`android/app/src/main/AndroidManifest.xml`**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

## 🧪 Testing

### Unit Tests
```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/unit/auth_test.dart

# Run tests with coverage
flutter test --coverage
```

### Integration Tests
```bash
# Run integration tests
flutter drive --target=test_driver/app.dart

# Run on specific device
flutter drive --target=test_driver/app.dart -d device-id
```

### Test Structure
```
test/
├── unit/
│   ├── models/
│   ├── providers/
│   ├── repositories/
│   └── services/
├── widget/
│   ├── auth/
│   ├── dashboard/
│   └── common/
└── integration/
    ├── auth_flow_test.dart
    ├── qr_scanning_test.dart
    └── tracking_test.dart
```

## 📱 Features Guide

### 🔐 Authentication
- **Email/Password** registration and login
- **Phone number** verification with OTP
- **Social login** (Google, Facebook)
- **Guest mode** for limited access
- **Biometric authentication** support

### 📊 Dashboard
- **Real-time safety overview** of fleet
- **Current journey** monitoring
- **Quick actions** for common tasks
- **Personal safety** analytics
- **Recent activity** timeline

### 📱 QR Code Scanning
- **Instant bus access** via QR codes
- **Automatic trip** initiation
- **Real-time safety** status display
- **Direct feedback** submission
- **Offline data** storage capability

### 🗺️ Live Tracking
- **Real-time GPS** tracking of buses
- **Interactive maps** with custom markers
- **Route visualization** with stops
- **Traffic-aware** ETA predictions
- **Geofencing** alerts and notifications

### 👨‍💼 Driver Information
- **Comprehensive profiles** with photos
- **Safety history** and performance metrics
- **Certification status** tracking
- **Real-time alertness** monitoring
- **Route specialization** analysis

### 🚌 Bus Information
- **Vehicle specifications** and details
- **Maintenance history** tracking
- **Safety equipment** status
- **Performance analytics** and trends
- **Documentation** management

### ⚠️ Safety Features
- **Emergency SOS** button
- **Hazard zone** mapping and alerts
- **Incident reporting** system
- **Safety tips** and education
- **Community feedback** platform

## 🔔 Push Notifications

### Notification Types
- **Safety Alerts** - Critical driver issues
- **Journey Updates** - Trip progress notifications
- **Emergency Alerts** - Immediate danger warnings
- **Feedback Status** - Response to submitted feedback
- **Maintenance Alerts** - Bus service notifications

### Setup FCM
```dart
// Initialize FCM in main.dart
await FirebaseMessaging.instance.requestPermission();
String? token = await FirebaseMessaging.instance.getToken();

// Handle background messages
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
```

## 🛡️ Security & Privacy

### Data Protection
- **End-to-end encryption** for sensitive data
- **Privacy controls** for user data sharing
- **Anonymous feedback** options
- **Data minimization** principles
- **GDPR compliance** features

### Authentication Security
- **Multi-factor authentication** support
- **Secure session** management
- **Biometric authentication** integration
- **Account recovery** mechanisms

## 📈 Analytics & Monitoring

### Firebase Analytics Events
```dart
// Track user engagement
FirebaseAnalytics.instance.logEvent(
  name: 'qr_code_scanned',
  parameters: {'bus_id': busId, 'route': routeNumber},
);

// Track safety interactions
FirebaseAnalytics.instance.logEvent(
  name: 'emergency_alert_sent',
  parameters: {'location': currentLocation, 'timestamp': DateTime.now()},
);
```

### Performance Monitoring
- **Crash reporting** with Firebase Crashlytics
- **Performance tracking** for key user flows
- **Custom metrics** for safety features
- **User behavior** analysis

## 🚀 Deployment

### Development Environment
```bash
# Build debug version
flutter build apk --debug

# Install on connected device
flutter install
```

### Staging Environment
```bash
# Build staging version
flutter build apk --flavor staging -t lib/main_staging.dart
```

### Production Deployment
```bash
# Build production release
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# Upload to Google Play Console
# Use internal testing -> closed testing -> open testing -> production
```

### CI/CD Pipeline (GitHub Actions)
```yaml
name: Build and Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk
```

## 🐛 Troubleshooting

### Common Issues

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub deps
flutter build apk
```

#### Firebase Connection Issues
```bash
# Verify google-services.json placement
# Check package name consistency
# Ensure Firebase services are enabled
```

#### Location Permission Issues
```bash
# Add location permissions to AndroidManifest.xml
# Request runtime permissions in code
# Handle permission denied scenarios
```

#### QR Scanner Issues
```bash
# Add camera permissions
# Check camera availability
# Handle scanning errors gracefully
```

## 📝 Contributing

We welcome contributions to the SafeDriver Passenger App! Please follow these guidelines:

### Development Workflow
1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Code Standards
- Follow **Dart style guide**
- Write **unit tests** for new features
- Update **documentation** as needed
- Use **meaningful commit** messages

### Pull Request Process
- Ensure all tests pass
- Update README if needed
- Request review from maintainers
- Address feedback promptly

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

**CodeCrafters Team**
- **D. S. Sandeepa** (221444563) - Project Lead & Backend Development
- **R. U. Gonalagoda** (621429318) - Hardware Integration & IoT
- **P. S. Ekanayaka** (621429276) - UI/UX Design & Frontend
- **K. J. L. Perera** (621429815) - Mobile App Development & Firebase
- **T. P. Denagamage** (321429305) - Testing & Quality Assurance

## 📞 Support

For support and questions:
- **Email**: codecrafters.team@university.edu
- **Project Repository**: [GitHub Repository](https://github.com/CodeCrafters-Team/safedriver-passenger-app)
- **Documentation**: [Project Wiki](https://github.com/CodeCrafters-Team/safedriver-passenger-app/wiki)

## 🙏 Acknowledgments

- **University Faculty** for project guidance
- **Sri Lankan Transport Authorities** for domain expertise
- **Flutter Community** for excellent documentation
- **Firebase Team** for robust backend services
- **Open Source Contributors** for amazing packages

---

<div align="center">
  <p><strong>Made with ❤️ by CodeCrafters Team</strong></p>
  <p><em>Revolutionizing Public Transport Safety in Sri Lanka</em></p>
</div>

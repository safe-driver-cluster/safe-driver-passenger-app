class AppConstants {
  // App Information
  static const String appName = 'SafeDriver Passenger';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Firebase Configuration
  static const String firebaseProjectId = 'safedriver-passenger-app';
  static const String firebaseApiKey = 'your-firebase-api-key';
  static const String firebaseAuthDomain =
      'safedriver-passenger-app.firebaseapp.com';
  static const String firebaseStorageBucket =
      'safedriver-passenger-app.appspot.com';

  // API Endpoints
  static const String baseUrl = 'https://api.safedriver.com/v1';
  static const String socketUrl = 'wss://api.safedriver.com/ws';

  // Map Configuration
  static const String googleMapsApiKey = 'your-google-maps-api-key';
  static const double defaultZoom = 15.0;
  static const double trackingZoom = 18.0;

  // QR Code Configuration
  static const String qrCodePrefix = 'SAFEDRIVER_BUS_';
  static const int qrCodeValidityMinutes = 30;
  static const String qrEncryptionKey = 'your-encryption-key-32-chars';

  // Location Settings
  static const double locationUpdateIntervalSeconds = 5.0;
  static const double minDistanceFilterMeters = 10.0;
  static const double locationTimeoutSeconds = 30.0;

  // Safety Thresholds
  static const double maxSafeSpeedKmh = 80.0;
  static const double harshBrakingThreshold = -3.5; // m/s²
  static const double harshAccelerationThreshold = 3.0; // m/s²
  static const double drowsinessAlertThreshold = 0.7; // percentage
  static const double distractionAlertThreshold = 0.6; // percentage

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 20.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Settings
  static const Duration cacheExpiryDuration = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Notification Settings
  static const String notificationChannelId = 'safedriver_notifications';
  static const String notificationChannelName = 'SafeDriver Notifications';
  static const String notificationChannelDescription =
      'Safety alerts and updates';

  // Emergency Configuration
  static const String emergencyNumber = '911';
  static const String supportNumber = '+1-800-SAFEDRIVER';
  static const String supportEmail = 'support@safedriver.com';

  // Feedback Configuration
  static const int maxFeedbackPhotos = 5;
  static const int maxFeedbackVideoLengthSeconds = 30;
  static const double maxFileUploadSizeMB = 10.0;

  // Session Configuration
  static const Duration sessionTimeoutMinutes = Duration(minutes: 30);
  static const Duration authTokenExpiryHours = Duration(hours: 24);
  static const int maxLoginAttempts = 5;
  static const Duration loginAttemptCooldownMinutes = Duration(minutes: 15);

  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableDarkMode = true;
  static const bool enableLocationSharing = true;
  static const bool enablePushNotifications = true;
  static const bool enableCrashReporting = true;
  static const bool enableAnalytics = true;

  // Development/Debug
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableTestData = false;
}

// Route Names
class RouteNames {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String dashboard = '/dashboard';
  static const String busSearch = '/bus-search';
  static const String busDetails = '/bus-details';
  static const String liveTracking = '/live-tracking';
  static const String busHistory = '/bus-history';
  static const String driverProfile = '/driver-profile';
  static const String driverHistory = '/driver-history';
  static const String driverPerformance = '/driver-performance';
  static const String safetyAlerts = '/safety-alerts';
  static const String hazardZones = '/hazard-zones';
  static const String emergency = '/emergency';
  static const String feedback = '/feedback';
  static const String feedbackHistory = '/feedback-history';
  static const String qrScanner = '/qr-scanner';
  static const String userProfile = '/user-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
}

// Storage Keys
class StorageKeys {
  static const String userToken = 'user_token';
  static const String userProfile = 'user_profile';
  static const String isFirstLaunch = 'is_first_launch';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String notificationEnabled = 'notification_enabled';
  static const String locationPermissionGranted = 'location_permission_granted';
  static const String biometricEnabled = 'biometric_enabled';
  static const String searchHistory = 'search_history';
  static const String favoriteRoutes = 'favorite_routes';
  static const String emergencyContacts = 'emergency_contacts';
  static const String lastKnownLocation = 'last_known_location';
  static const String appSettings = 'app_settings';
  static const String cacheTimestamp = 'cache_timestamp';
}

// Asset Paths
class AssetPaths {
  // Images
  static const String logoImage = 'assets/images/logo.png';
  static const String splashImage = 'assets/images/splash_bg.png';
  static const String onboardingImage1 = 'assets/images/onboarding_1.png';
  static const String onboardingImage2 = 'assets/images/onboarding_2.png';
  static const String onboardingImage3 = 'assets/images/onboarding_3.png';
  static const String busPlaceholderImage = 'assets/images/bus_placeholder.png';
  static const String driverPlaceholderImage =
      'assets/images/driver_placeholder.png';
  static const String mapMarkerBus = 'assets/images/map_marker_bus.png';
  static const String mapMarkerUser = 'assets/images/map_marker_user.png';
  static const String emptyStateImage = 'assets/images/empty_state.png';
  static const String errorStateImage = 'assets/images/error_state.png';

  // Icons
  static const String dashboardIcon = 'assets/icons/dashboard.svg';
  static const String busIcon = 'assets/icons/bus.svg';
  static const String driverIcon = 'assets/icons/driver.svg';
  static const String safetyIcon = 'assets/icons/safety.svg';
  static const String feedbackIcon = 'assets/icons/feedback.svg';
  static const String qrScanIcon = 'assets/icons/qr_scan.svg';
  static const String emergencyIcon = 'assets/icons/emergency.svg';
  static const String locationIcon = 'assets/icons/location.svg';
  static const String notificationIcon = 'assets/icons/notification.svg';
  static const String profileIcon = 'assets/icons/profile.svg';

  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String emptyAnimation = 'assets/animations/empty.json';
  static const String scanningAnimation = 'assets/animations/scanning.json';
  static const String mapAnimation = 'assets/animations/map.json';
  static const String emergencyAnimation = 'assets/animations/emergency.json';
}

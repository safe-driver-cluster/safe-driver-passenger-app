// Environment configuration for Firebase
class FirebaseConfig {
  static const String projectId = 'safe-driver-system';
  static const String storageBucket = 'safe-driver-system.firebasestorage.app';
  static const String messagingSenderId = '719842751658';

  // Production API keys - These should be stored securely
  static const String androidApiKey = 'AIzaSyCcibaYhXUItkAhrUQuugWyDirmQ3-0VfY';
  static const String iosApiKey = 'AIzaSyCcibaYhXUItkAhrUQuugWyDirmQ3-0VfY';
  static const String webApiKey = 'AIzaSyCcibaYhXUItkAhrUQuugWyDirmQ3-0VfY';

  // App IDs for different platforms
  static const String androidAppId =
      '1:719842751658:android:c1b794fb9edad4d2514cd3';
  static const String iosAppId = '1:719842751658:ios:production_ios_app_id';
  static const String webAppId = '1:719842751658:web:production_web_app_id';

  // Bundle/Package identifiers
  static const String androidPackageName = 'com.safedriver.passenger';
  static const String iosBundleId = 'com.safedriver.passenger';

  // Environment-specific settings
  static const bool isProduction =
      bool.fromEnvironment('PRODUCTION', defaultValue: false);
  static const bool enableAnalytics =
      bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true);
  static const bool enableCrashlytics =
      bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: true);

  // Security settings
  static const String authDomain = 'safe-driver-system.firebaseapp.com';
  static const String measurementId = 'G-PRODUCTION_MEASUREMENT_ID';
}

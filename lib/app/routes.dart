import 'package:flutter/material.dart';

import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/otp_verification_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/auth/splash_page.dart';
import '../presentation/pages/bus/bus_details_page.dart';
import '../presentation/pages/bus/bus_history_page.dart';
import '../presentation/pages/bus/bus_search_page.dart';
import '../presentation/pages/bus/live_tracking_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/driver/driver_history_page.dart';
import '../presentation/pages/driver/driver_performance_page.dart';
import '../presentation/pages/driver/driver_profile_page.dart';
import '../presentation/pages/driver/driver_info_page.dart';
import '../presentation/pages/feedback/feedback_history_page.dart';
import '../presentation/pages/feedback/feedback_page.dart';
import '../presentation/pages/not_found_page.dart';
import '../presentation/pages/profile/notifications_page.dart';
import '../presentation/pages/profile/settings_page.dart';
import '../presentation/pages/profile/trip_history_page.dart';
import '../presentation/pages/profile/user_profile_page.dart';
import '../presentation/pages/qr/qr_scanner_page.dart';
import '../presentation/pages/hazard/hazard_zone_intelligence_page.dart';
import '../presentation/pages/safety/emergency_page.dart';
import '../presentation/pages/safety/hazard_zones_page.dart';
import '../presentation/pages/safety/safety_alerts_page.dart';
import '../presentation/pages/safety/safety_hub_page.dart';

/// Application route configuration and navigation management
class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String dashboard = '/dashboard';
  static const String notifications = '/notifications';

  // Bus routes
  static const String busSearch = '/bus-search';
  static const String busDetails = '/bus-details';
  static const String liveTracking = '/live-tracking';
  static const String busHistory = '/bus-history';

  // Driver routes
  static const String driverProfile = '/driver-profile';
  static const String driverHistory = '/driver-history';
  static const String driverPerformance = '/driver-performance';

  // Safety routes
  static const String safetyAlerts = '/safety-alerts';
  static const String safetyHub = '/safety-hub';
  static const String hazardZones = '/hazard-zones';
  static const String emergency = '/emergency';

  // Feedback routes
  static const String feedback = '/feedback';
  static const String feedbackHistory = '/feedback-history';

  // Trip routes
  static const String tripHistory = '/trip-history';

  // QR routes
  static const String qrScanner = '/qr-scanner';

  // Driver Info routes
  static const String driverInfo = '/driver-info';

  // Hazard Zone routes
  static const String hazardZoneIntelligence = '/hazard-zone-intelligence';

  // Profile routes
  static const String userProfile = '/user-profile';
  static const String settings = '/settings';

  /// Generate route based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );

      case otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationPage(
            phoneNumber: args?['phoneNumber'] ?? '',
            verificationId: args?['verificationId'] ?? '',
          ),
          settings: settings,
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
          settings: settings,
        );

      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsPage(),
          settings: settings,
        );

      case busSearch:
        return MaterialPageRoute(
          builder: (_) => const BusSearchPage(),
          settings: settings,
        );

      case busDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BusDetailsPage(
            busId: args?['busId'] ?? '',
          ),
          settings: settings,
        );

      case liveTracking:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LiveTrackingPage(
            busId: args?['busId'] ?? '',
          ),
          settings: settings,
        );

      case busHistory:
        return MaterialPageRoute(
          builder: (_) => const BusHistoryPage(),
          settings: settings,
        );

      case driverProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DriverProfilePage(
            driverId: args?['driverId'] ?? '',
          ),
          settings: settings,
        );

      case driverHistory:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DriverHistoryPage(
            driverId: args?['driverId'] ?? '',
          ),
          settings: settings,
        );

      case driverPerformance:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DriverPerformancePage(
            driverId: args?['driverId'] ?? '',
          ),
          settings: settings,
        );

      case safetyAlerts:
        return MaterialPageRoute(
          builder: (_) => const SafetyAlertsPage(),
          settings: settings,
        );

      case safetyHub:
        return MaterialPageRoute(
          builder: (_) => const SafetyHubPage(),
          settings: settings,
        );

      case hazardZones:
        return MaterialPageRoute(
          builder: (_) => const HazardZonesPage(),
          settings: settings,
        );

      case emergency:
        return MaterialPageRoute(
          builder: (_) => const EmergencyPage(),
          settings: settings,
        );

      case feedback:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FeedbackPage(
            busId: args?['busId'],
            driverId: args?['driverId'],
            tripId: args?['tripId'],
          ),
          settings: settings,
        );

      case feedbackHistory:
        return MaterialPageRoute(
          builder: (_) => const FeedbackHistoryPage(),
          settings: settings,
        );

      case qrScanner:
        return MaterialPageRoute(
          builder: (_) => const QrScannerPage(),
          settings: settings,
        );

      case driverInfo:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DriverInfoPage(
            driverId: args?['driverId'] ?? 'demo_driver_001',
            driverName: args?['driverName'] ?? 'John Doe',
          ),
          settings: settings,
        );

      case hazardZoneIntelligence:
        return MaterialPageRoute(
          builder: (_) => const HazardZoneIntelligencePage(),
          settings: settings,
        );

      case tripHistory:
        return MaterialPageRoute(
          builder: (_) => const TripHistoryPage(),
          settings: settings,
        );

      case userProfile:
        return MaterialPageRoute(
          builder: (_) => const UserProfilePage(),
          settings: settings,
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
          settings: settings,
        );
    }
  }

  /// Navigate to route with arguments
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
    bool replace = false,
  }) {
    if (replace) {
      return Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments,
      );
    } else {
      return Navigator.pushNamed(
        context,
        routeName,
        arguments: arguments,
      );
    }
  }

  /// Navigate and clear stack
  static Future<T?> navigateAndClearStack<T extends Object?>(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back to previous screen
  static void goBack(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }
}

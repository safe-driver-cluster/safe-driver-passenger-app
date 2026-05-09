import 'package:flutter/material.dart';

import '../presentation/pages/auth/account_verification_page.dart';
import '../presentation/pages/auth/forgot_password_otp_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/otp_verification_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/auth/reset_password_page.dart';
import '../presentation/pages/auth/splash_page.dart';
import '../presentation/pages/buses/bus_list_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/driver/driver_history_page.dart';
import '../presentation/pages/driver/driver_info_page.dart';
import '../presentation/pages/driver/driver_performance_page.dart';
import '../presentation/pages/driver/driver_profile_page.dart';
import '../presentation/pages/drivers/driver_list_page.dart';
import '../presentation/pages/feedback/feedback_form_screen.dart';
import '../presentation/pages/feedback/feedback_history_page.dart';
import '../presentation/pages/feedback/feedback_page.dart';
import '../presentation/pages/feedback/feedback_system_page.dart';
import '../presentation/pages/feedback/feedback_test_page.dart';
import '../presentation/pages/hazard/hazard_zone_intelligence_page.dart';
import '../presentation/pages/language/language_selection_page.dart';
import '../presentation/pages/not_found_page.dart';
import '../presentation/pages/onboarding/onboarding_page.dart';
import '../presentation/pages/profile/notifications_page.dart';
import '../presentation/pages/profile/settings_page.dart';
import '../presentation/pages/profile/trip_history_page.dart';
import '../presentation/pages/profile/user_profile_page.dart';
import '../presentation/pages/qr/qr_scanner_page.dart';
import '../presentation/pages/safety/emergency_page.dart';
import '../presentation/pages/safety/hazard_zones_page.dart';
import '../presentation/pages/safety/safety_alerts_page.dart';
import '../presentation/pages/safety/safety_hub_page.dart';
import '../presentation/pages/safety/sos_contacts_page.dart';
import '../presentation/widgets/common/web_responsive_layout.dart';

/// Application route configuration and navigation management
class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String accountVerification = '/account-verification';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordOtp = '/forgot-password-otp';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String dashboard = '/dashboard';
  static const String notifications = '/notifications';

  // Bus routes
  static const String buses = '/buses';
  static const String busSearch = '/bus-search';
  static const String busDetails = '/bus-details';
  static const String liveTracking = '/live-tracking';
  static const String busHistory = '/bus-history';

  // Driver routes
  static const String drivers = '/drivers';
  static const String driverProfile = '/driver-profile';
  static const String driverHistory = '/driver-history';
  static const String driverPerformance = '/driver-performance';

  // Safety routes
  static const String safetyAlerts = '/safety-alerts';
  static const String safetyHub = '/safety-hub';
  static const String hazardZones = '/hazard-zones';
  static const String emergency = '/emergency';
  static const String sosContacts = '/sos-contacts';

  // Feedback routes
  static const String feedback = '/feedback';
  static const String feedbackForm = '/feedback-form';
  static const String feedbackSystem = '/feedback-system';
  static const String feedbackTest = '/feedback-test';
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
  static const String profile = '/profile';
  static const String userProfile = '/user-profile';
  static const String settings = '/settings';

  /// Generate route based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _route(settings, const SplashPage());

      case languageSelection:
        return _route(settings, const LanguageSelectionPage());

      case onboarding:
        return _route(settings, const OnboardingPage());

      case login:
        return _route(settings, const LoginPage());

      case register:
        return _route(settings, const RegisterPage());

      case accountVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          AccountVerificationPage(
            phoneNumber: args?['phoneNumber'] ?? '',
            email: args?['email'] ?? '',
            firstName: args?['firstName'] ?? '',
            lastName: args?['lastName'] ?? '',
            password: args?['password'] ?? '',
          ),
        );

      case forgotPassword:
        return _route(settings, const ForgotPasswordPage());

      case forgotPasswordOtp:
        return _route(settings, const ForgotPasswordOtpPage());

      case resetPassword:
        return _route(settings, const ResetPasswordPage());

      case otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          OtpVerificationPage(
            phoneNumber: args?['phoneNumber'] ?? '',
            verificationId: args?['verificationId'] ?? '',
          ),
        );

      case dashboard:
        final args = settings.arguments as Map<String, dynamic>?;
        final initialTab = args?['initialTab'] as int?;
        return _route(settings, DashboardPage(initialTab: initialTab));

      case notifications:
        return _route(settings, const NotificationsPage());

      case buses:
        return _route(settings, const BusListPage());

      case drivers:
        return _route(settings, const DriverListPage());

      case busSearch:
        return _route(settings, const BusListPage());

      // case busDetails:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   return MaterialPageRoute(
      //     builder: (_) => BusDetailsPage(
      //       busId: args?['busId'] ?? '',
      //     ),
      //     settings: settings,
      //   );

      // case liveTracking:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   return MaterialPageRoute(
      //     builder: (_) => LiveTrackingPage(
      //       busId: args?['busId'] ?? '',
      //     ),
      //     settings: settings,
      //   );

      // case busHistory:
      //   return MaterialPageRoute(
      //     builder: (_) => const BusHistoryPage(),
      //     settings: settings,
      //   );

      case driverProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          DriverProfilePage(
            driverId: args?['driverId'] ?? '',
          ),
        );

      case driverHistory:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          DriverHistoryPage(
            driverId: args?['driverId'] ?? '',
          ),
        );

      case driverPerformance:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          DriverPerformancePage(
            driverId: args?['driverId'] ?? '',
          ),
        );

      case safetyAlerts:
        return _route(settings, const SafetyAlertsPage());

      case safetyHub:
        return _route(settings, const SafetyHubPage());

      case hazardZones:
        return _route(settings, const HazardZonesPage());

      case emergency:
        return _route(settings, const EmergencyPage());

      case sosContacts:
        return _route(settings, const SosContactsPage());

      case feedback:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          FeedbackPage(
            busId: args?['busId'],
            driverId: args?['driverId'],
            tripId: args?['tripId'],
          ),
        );

      case feedbackForm:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          FeedbackFormScreen(
            busId: args?['busId'],
            driverId: args?['driverId'],
            journeyId: args?['journeyId'],
          ),
        );

      case feedbackSystem:
        return _route(settings, const FeedbackSystemPage());

      case feedbackTest:
        return _route(settings, const FeedbackTestPage());

      case feedbackHistory:
        return _route(settings, const FeedbackHistoryPage());

      case qrScanner:
        return _route(settings, const QrScannerPage());

      case driverInfo:
        final args = settings.arguments as Map<String, dynamic>?;
        return _route(
          settings,
          DriverInfoPage(
            driverId: args?['driverId'] ?? 'demo_driver_001',
            driverName: args?['driverName'] ?? 'John Doe',
          ),
        );

      case hazardZoneIntelligence:
        return _route(settings, const HazardZoneIntelligencePage());

      case tripHistory:
        return _route(settings, const TripHistoryPage());

      case userProfile:
        return _route(settings, const UserProfilePage());

      case profile:
        return _route(settings, const UserProfilePage());

      case AppRoutes.settings:
        return _route(settings, const SettingsPage());

      default:
        return _route(settings, const NotFoundPage());
    }
  }

  static MaterialPageRoute<dynamic> _route(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute(
      builder: (_) => WebPageFrame(
        maxWidth: _webMaxWidthFor(settings.name),
        child: page,
      ),
      settings: settings,
    );
  }

  static double _webMaxWidthFor(String? routeName) {
    switch (routeName) {
      case splash:
      case languageSelection:
      case onboarding:
      case login:
      case register:
      case accountVerification:
      case forgotPassword:
      case forgotPasswordOtp:
      case resetPassword:
      case otpVerification:
        return 520;
      case dashboard:
      case liveTracking:
        return 1440;
      case buses:
      case busSearch:
      case drivers:
      case safetyHub:
      case feedbackSystem:
      case hazardZoneIntelligence:
        return 1180;
      case qrScanner:
        return 760;
      default:
        return 960;
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

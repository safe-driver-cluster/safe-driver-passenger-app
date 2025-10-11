import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import 'package:safedriver_passenger_app/providers/language_provider.dart';

import 'app/routes.dart';
import 'core/constants/string_constants.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/themes/app_theme.dart';
import 'firebase_options.dart';

// Top-level function to handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized (but don't initialize if already done)
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    // If Firebase is already initialized, continue
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }
  debugPrint('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // Initialize Firebase with proper configuration (only if not already initialized)
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      // If Firebase is already initialized (common during hot restart), continue
      if (!e.toString().contains('duplicate-app')) {
        rethrow;
      }
      debugPrint('Firebase already initialized, continuing...');
    }

    // Initialize Firebase services
    await FirebaseService.instance.initialize();

    // Initialize Firebase Messaging background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize Crashlytics for error logging
    await CrashlyticsService.instance.initialize();

    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Initialize notification service
    final notificationService = NotificationService.instance;
    await notificationService.initialize();

    runApp(
      const ProviderScope(
        child: SafeDriverApp(),
      ),
    );
  } catch (error, stackTrace) {
    // Log error to Crashlytics if available
    try {
      await CrashlyticsService.instance.logError(
        error,
        stackTrace,
        reason: 'App initialization failed',
        fatal: true,
      );
    } catch (_) {
      // Crashlytics logging failed, continue with normal error handling
    }

    // Handle initialization errors
    debugPrint('Initialization error: $error');
    runApp(const SafeDriverErrorApp());
  }
}

class SafeDriverApp extends ConsumerWidget {
  const SafeDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageController.supportedLocales,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class SafeDriverErrorApp extends StatelessWidget {
  const SafeDriverErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeDriver',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize the app',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please restart the application',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

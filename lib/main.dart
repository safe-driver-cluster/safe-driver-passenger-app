import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import 'package:safedriver_passenger_app/providers/app_providers.dart';
import 'package:safedriver_passenger_app/providers/language_provider.dart';

import 'app/routes.dart';
import 'core/constants/string_constants.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/themes/app_theme.dart';
import 'data/services/auth_service.dart';
import 'data/services/biometric_service.dart';
import 'firebase_options.dart';
import 'presentation/widgets/common/web_responsive_layout.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (error) {
    if (!error.toString().contains('duplicate-app')) {
      rethrow;
    }
  }

  debugPrint('Handling a background message: ${message.messageId}');
  await NotificationService.persistBackgroundMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _runStartupTask(
    'Load environment variables',
    () => dotenv.load(fileName: '.env'),
  );

  await _runStartupTask(
    'Set preferred orientations',
    () => SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  );

  final firebaseReady = await _initializeFirebaseCore();

  if (firebaseReady) {
    await _initializeFirebaseAppCheck();

    await _runStartupTask(
      'Configure Firebase Auth persistence',
      () => FirebaseAuth.instance.setPersistence(Persistence.LOCAL),
    );

    await _runStartupTask(
      'Initialize Firebase services',
      () => FirebaseService.instance.initialize(),
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _runStartupTask(
      'Initialize Crashlytics',
      () => CrashlyticsService.instance.initialize(),
    );

    await _runStartupTask(
      'Initialize notification service',
      () => NotificationService.instance.initialize(),
    );
  }

  await _runStartupTask(
    'Initialize storage service',
    () => StorageService.instance.initialize(),
  );

  if (firebaseReady) {
    await _runStartupTask(
      'Initialize auth service',
      () => AuthService().initialize(),
    );
  }

  await _runStartupTask(
    'Initialize biometric service',
    () => BiometricService().initialize(),
  );

  runApp(
    const ProviderScope(
      child: SafeDriverApp(),
    ),
  );
}

Future<bool> _initializeFirebaseCore() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    return true;
  } catch (error, stackTrace) {
    if (error.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized, continuing...');
      return true;
    }

    debugPrint('Firebase initialization skipped: $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}

Future<void> _initializeFirebaseAppCheck() async {
  await _runStartupTask('Initialize Firebase App Check', () async {
    // Web App Check requires a registered reCAPTCHA site key. Activating it
    // with an empty key prevents Firebase web requests from completing.
    if (kIsWeb) {
      return;
    }

    if (kDebugMode) {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
      return;
    }

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  });
}

Future<void> _runStartupTask(
  String label,
  Future<dynamic> Function() task,
) async {
  try {
    await task();
    debugPrint('$label completed');
  } catch (error, stackTrace) {
    debugPrint('$label failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    await CrashlyticsService.instance.logError(
      error,
      stackTrace,
      reason: label,
      fatal: false,
    );
  }
}

class SafeDriverApp extends ConsumerWidget {
  const SafeDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);
    final themeMode = ref.watch(themeModeProvider);
    debugPrint(
      'MaterialApp building with locale: ${currentLocale.languageCode}',
    );

    return MaterialApp(
      key: ValueKey(currentLocale.languageCode),
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) => WebPageFrame(
        maxWidth: 1440,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

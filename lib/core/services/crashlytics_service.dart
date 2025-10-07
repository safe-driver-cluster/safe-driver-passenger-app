import 'dart:developer' as developer;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CrashlyticsService {
  static CrashlyticsService? _instance;
  static CrashlyticsService get instance =>
      _instance ??= CrashlyticsService._();
  CrashlyticsService._();

  late FirebaseCrashlytics _crashlytics;
  bool _isInitialized = false;

  /// Initialize Crashlytics
  Future<void> initialize() async {
    try {
      // Check if crashlytics is enabled (default to true in release mode)
      bool crashlyticsEnabled = kReleaseMode;

      _crashlytics = FirebaseCrashlytics.instance;

      // Enable collection in release mode
      if (kReleaseMode) {
        await _crashlytics.setCrashlyticsCollectionEnabled(true);
      } else {
        // Disable in debug mode for development
        await _crashlytics.setCrashlyticsCollectionEnabled(false);
      }

      // Set up Flutter error handling
      FlutterError.onError = _crashlytics.recordFlutterFatalError;

      // Set up Dart error handling
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      _isInitialized = true;
      developer.log('Crashlytics initialized successfully');
    } catch (e) {
      developer.log('Failed to initialize Crashlytics: $e');
    }
  }

  /// Log custom error with context
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? context,
    bool fatal = false,
  }) async {
    if (!_isInitialized) return;

    try {
      // Add context as custom keys
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }

      // Log the error
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );

      // Also log to console in debug mode
      if (kDebugMode) {
        developer.log(
          'Error logged: $exception',
          name: 'CrashlyticsService',
          error: exception,
          stackTrace: stackTrace,
        );
      }
    } catch (e) {
      developer.log('Failed to log error to Crashlytics: $e');
    }
  }

  /// Log custom message
  Future<void> log(String message) async {
    if (!_isInitialized) return;

    try {
      await _crashlytics.log(message);

      if (kDebugMode) {
        developer.log(message, name: 'CrashlyticsService');
      }
    } catch (e) {
      developer.log('Failed to log message to Crashlytics: $e');
    }
  }

  /// Set user identifier
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) return;

    try {
      await _crashlytics.setUserIdentifier(userId);
    } catch (e) {
      developer.log('Failed to set user ID in Crashlytics: $e');
    }
  }

  /// Set custom key-value pair
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!_isInitialized) return;

    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      developer.log('Failed to set custom key in Crashlytics: $e');
    }
  }

  /// Record user action
  Future<void> recordUserAction(String action,
      {Map<String, dynamic>? parameters}) async {
    if (!_isInitialized) return;

    try {
      await _crashlytics.log('User Action: $action');

      if (parameters != null) {
        for (final entry in parameters.entries) {
          await _crashlytics.setCustomKey('action_${entry.key}', entry.value);
        }
      }
    } catch (e) {
      developer.log('Failed to record user action: $e');
    }
  }

  /// Test crash (only in debug mode)
  Future<void> testCrash() async {
    if (!kDebugMode) return;

    try {
      _crashlytics.crash();
    } catch (e) {
      developer.log('Test crash failed: $e');
    }
  }

  /// Check if crashes are enabled
  bool get isCrashCollectionEnabled => _isInitialized;
}

/// Error boundary widget for handling widget errors
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? errorWidget;
  final Function(FlutterErrorDetails)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorWidget,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget ??
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
    }

    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set up error handling for this widget tree
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _hasError = true;
      });

      // Log to Crashlytics
      CrashlyticsService.instance.logError(
        details.exception,
        details.stack,
        reason: 'Widget Error: ${details.context}',
        fatal: false,
      );

      // Call custom error handler
      widget.onError?.call(details);
    };
  }
}

import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';

/// Extension to easily access localizations from context
extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Helper class for localization-related utilities
class LocalizationHelper {
  /// Get localized text for app name
  static String getAppName(BuildContext context) {
    return context.l10n.appName;
  }

  /// Get localized text for common actions
  static String getCommonAction(BuildContext context, String action) {
    switch (action) {
      case 'save':
        return context.l10n.save;
      case 'cancel':
        return context.l10n.cancel;
      case 'ok':
        return context.l10n.ok;
      case 'yes':
        return context.l10n.yes;
      case 'no':
        return context.l10n.no;
      case 'done':
        return context.l10n.done;
      case 'next':
        return context.l10n.next;
      case 'previous':
        return context.l10n.previous;
      case 'skip':
        return context.l10n.skip;
      case 'retry':
        return context.l10n.retry;
      case 'refresh':
        return context.l10n.refresh;
      default:
        return action; // Return the key if not found
    }
  }

  /// Get localized error message
  static String getErrorMessage(BuildContext context, String errorType) {
    switch (errorType) {
      case 'network':
        return context.l10n.networkError;
      case 'server':
        return context.l10n.serverError;
      case 'timeout':
        return context.l10n.connectionTimeout;
      case 'noInternet':
        return context.l10n.noInternetConnection;
      default:
        return context.l10n.errorOccurred;
    }
  }

  /// Check if the current locale is RTL (Right-to-Left)
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Get text direction based on locale
  static TextDirection getTextDirection(Locale locale) {
    // Add RTL languages here if needed in the future
    // For now, all supported languages (English, Sinhala, Tamil) are LTR
    return TextDirection.ltr;
  }
}

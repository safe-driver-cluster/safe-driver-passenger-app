import '../../l10n/arb/app_localizations.dart';

/// Utility class for time-based greetings
class GreetingUtil {
  /// Get time-based greeting
  static String getTimeBasedGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return l10n.goodMorning;
    } else if (hour >= 12 && hour < 17) {
      return l10n.goodAfternoon;
    } else if (hour >= 17 && hour < 21) {
      return l10n.goodEvening;
    } else {
      return l10n.goodNight;
    }
  }

  /// Get greeting emoji based on time
  static String getGreetingEmoji() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return '🌅';
    } else if (hour >= 12 && hour < 17) {
      return '☀️';
    } else if (hour >= 17 && hour < 21) {
      return '🌆';
    } else {
      return '🌙';
    }
  }

  /// Get full greeting with emoji
  static String getFullGreeting(String firstName, AppLocalizations l10n) {
    final greeting = getTimeBasedGreeting(l10n);
    final name = firstName.isNotEmpty ? firstName : l10n.traveler;
    return '$greeting, $name ${getGreetingEmoji()}';
  }
}

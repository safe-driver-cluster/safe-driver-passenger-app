/// Utility class for time-based greetings
class GreetingUtil {
  /// Get time-based greeting
  static String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
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
  static String getFullGreeting(String firstName) {
    return '${getTimeBasedGreeting()}, ${firstName.isNotEmpty ? firstName : 'Traveler'} ${getGreetingEmoji()}';
  }
}

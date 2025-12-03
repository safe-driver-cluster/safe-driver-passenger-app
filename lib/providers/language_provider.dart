import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages in the app
enum AppLanguage {
  english('en', 'English', 'English'),
  sinhala('si', 'සිංහල', 'Sinhala'),
  tamil('ta', 'தமிழ்', 'Tamil');

  const AppLanguage(this.code, this.nativeName, this.englishName);

  final String code;
  final String nativeName;
  final String englishName;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Language controller to manage current language state
class LanguageController extends StateNotifier<AppLanguage> {
  static const String _languageKey = 'selected_language';

  LanguageController() : super(AppLanguage.english) {
    _loadSavedLanguage();
  }

  /// Load saved language from shared preferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);
      
      debugPrint('🌐 Loading saved language...');
      debugPrint('🌐 Saved language code: $savedLanguageCode');
      debugPrint('🌐 Current state before: ${state.code}');

      if (savedLanguageCode != null) {
        state = AppLanguage.fromCode(savedLanguageCode);
        debugPrint('🌐 Language loaded: ${state.code} (${state.englishName})');
      } else {
        debugPrint('🌐 No saved language found, using default: ${state.code}');
      }
    } catch (e) {
      // If there's an error loading, keep default language
      debugPrint('❌ Error loading saved language: $e');
    }
  }

  /// Check if language has been selected before
  Future<bool> hasLanguageBeenSelected() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('language_selected') ?? false;
    } catch (e) {
      debugPrint('Error checking language selection: $e');
      return false;
    }
  }

  /// Reset language selection (for testing)
  Future<void> resetLanguageSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('language_selected');
      await prefs.remove(_languageKey);
      state = AppLanguage.english;
    } catch (e) {
      debugPrint('Error resetting language selection: $e');
    }
  }

  /// Change the current language and save to preferences
  Future<void> changeLanguage(AppLanguage language) async {
    try {
      debugPrint('🌐 Changing language to: ${language.code} (${language.englishName})');
      state = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.code);
      await prefs.setBool('language_selected', true);
      debugPrint('🌐 Language saved to preferences: ${language.code}');
    } catch (e) {
      debugPrint('❌ Error saving language: $e');
    }
  }

  /// Get the current locale
  Locale get currentLocale => Locale(state.code);

  /// Get all supported locales
  static List<Locale> get supportedLocales =>
      AppLanguage.values.map((lang) => Locale(lang.code)).toList();
}

/// Provider for language controller
final languageControllerProvider =
    StateNotifierProvider<LanguageController, AppLanguage>(
  (ref) => LanguageController(),
);

/// Provider for current locale
final currentLocaleProvider = Provider<Locale>((ref) {
  final language = ref.watch(languageControllerProvider);
  return Locale(language.code);
});

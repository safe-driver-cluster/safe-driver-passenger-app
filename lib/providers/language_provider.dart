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
      
      if (savedLanguageCode != null) {
        state = AppLanguage.fromCode(savedLanguageCode);
      }
    } catch (e) {
      // If there's an error loading, keep default language
      debugPrint('Error loading saved language: $e');
    }
  }

  /// Change the current language and save to preferences
  Future<void> changeLanguage(AppLanguage language) async {
    try {
      state = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.code);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  /// Get the current locale
  Locale get currentLocale => Locale(state.code);

  /// Get all supported locales
  static List<Locale> get supportedLocales => AppLanguage.values
      .map((lang) => Locale(lang.code))
      .toList();
}

/// Provider for language controller
final languageControllerProvider = StateNotifierProvider<LanguageController, AppLanguage>(
  (ref) => LanguageController(),
);

/// Provider for current locale
final currentLocaleProvider = Provider<Locale>((ref) {
  final language = ref.watch(languageControllerProvider);
  return Locale(language.code);
});
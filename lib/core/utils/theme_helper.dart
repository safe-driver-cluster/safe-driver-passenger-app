import 'package:flutter/material.dart';

/// Helper class to get theme-aware colors throughout the app.
/// Instead of using hardcoded colors like `Colors.white` or `AppColors.textPrimary`,
/// use `ThemeHelper.of(context)` to get colors that adapt to light/dark mode.
///
/// Usage:
/// ```dart
/// final th = ThemeHelper.of(context);
/// th.textPrimary   // dark text in light mode, light text in dark mode
/// th.background    // adapts to scaffold background
/// th.cardBackground // adapts to card background
/// ```
class ThemeHelper {
  final ThemeData _theme;
  final ColorScheme _colors;
  final bool _isDark;

  ThemeHelper._(this._theme, this._colors, this._isDark);

  static ThemeHelper of(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeHelper._(theme, theme.colorScheme, theme.brightness == Brightness.dark);
  }

  bool get isDark => _isDark;

  // ─── Background Colors ──────────────────────────────────────
  /// Scaffold background (light grey in light mode, dark blue-grey in dark)
  Color get background => _theme.scaffoldBackgroundColor;

  /// Card / container background (white in light, darkSurface in dark)
  Color get cardBackground => _colors.surfaceContainer;

  /// Surface color for sheets, dialogs, etc.
  Color get surface => _colors.surface;

  /// Input field fill color
  Color get inputFill => _isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFFAFAFA);

  /// Subtle background for dividers, separators
  Color get subtleBackground => _isDark
      ? const Color(0xFF334155)
      : const Color(0xFFF3F4F6);

  // ─── Text Colors ────────────────────────────────────────────
  /// Primary text color (dark in light mode, light in dark mode)
  Color get textPrimary => _colors.onSurface;

  /// Secondary text color
  Color get textSecondary => _isDark
      ? const Color(0xFFCBD5E1)
      : const Color(0xFF6B7280);

  /// Hint / placeholder text color
  Color get textHint => _isDark
      ? const Color(0xFF64748B)
      : const Color(0xFF9CA3AF);

  /// Disabled text color
  Color get textDisabled => _isDark
      ? const Color(0xFF475569)
      : const Color(0xFFD1D5DB);

  /// Text on primary/accent colored backgrounds (always white)
  Color get textOnPrimary => _colors.onPrimary;

  // ─── Border / Divider Colors ────────────────────────────────
  /// Standard border color
  Color get border => _isDark
      ? const Color(0xFF334155)
      : const Color(0xFFE5E7EB);

  /// Light border (subtle)
  Color get borderLight => _isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFF3F4F6);

  /// Divider color
  Color get divider => _isDark
      ? const Color(0xFF334155)
      : const Color(0xFFE5E7EB);

  // ─── Shadow Colors ──────────────────────────────────────────
  /// Light shadow
  Color get shadowLight => _isDark
      ? Colors.black.withOpacity(0.3)
      : Colors.black.withOpacity(0.05);

  /// Medium shadow
  Color get shadowMedium => _isDark
      ? Colors.black.withOpacity(0.4)
      : Colors.black.withOpacity(0.08);

  // ─── Overlay Colors ─────────────────────────────────────────
  /// Overlay for modal backgrounds
  Color get overlay => _isDark
      ? Colors.black.withOpacity(0.6)
      : Colors.black.withOpacity(0.4);

  /// Glass/frosted background
  Color get glassBackground => _isDark
      ? const Color(0x1A1E293B)
      : const Color(0x1AFFFFFF);

  // ─── Status Bar / System UI ─────────────────────────────────
  /// Status bar icon brightness
  Brightness get statusBarIconBrightness =>
      _isDark ? Brightness.light : Brightness.dark;

  // ─── Action Colors (same in both themes) ─────────────────────
  Color get primary => _colors.primary;
  Color get error => _colors.error;
  Color get success => const Color(0xFF10B981);
  Color get warning => const Color(0xFFF59E0B);
}

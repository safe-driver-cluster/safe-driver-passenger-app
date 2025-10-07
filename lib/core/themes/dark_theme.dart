import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dark theme configuration for SafeDriver Passenger App
class DarkTheme {
  /// Primary dark theme data
  static ThemeData get themeData {
    return ThemeData(
      // Base theme
      brightness: Brightness.dark,
      useMaterial3: true,

      // Color scheme
      colorScheme: _darkColorScheme,

      // App bar theme
      appBarTheme: _appBarTheme,

      // Navigation bar theme
      navigationBarTheme: _navigationBarThemeData,

      // Bottom navigation bar theme
      bottomNavigationBarTheme: _bottomNavigationBarThemeData,

      // Card theme
      cardTheme: _cardTheme,

      // Elevated button theme
      elevatedButtonTheme: _elevatedButtonTheme,

      // Text button theme
      textButtonTheme: _textButtonTheme,

      // Outlined button theme
      outlinedButtonTheme: _outlinedButtonTheme,

      // Floating action button theme
      floatingActionButtonTheme: _floatingActionButtonTheme,

      // Input decoration theme
      inputDecorationTheme: _inputDecorationTheme,

      // Text theme
      textTheme: _textTheme,

      // Icon theme
      iconTheme: _iconTheme,

      // Divider theme
      dividerTheme: _dividerTheme,

      // Chip theme
      chipTheme: _chipTheme,

      // Dialog theme
      dialogTheme: _dialogTheme,

      // Snack bar theme
      snackBarTheme: _snackBarTheme,

      // Progress indicator theme
      progressIndicatorTheme: _progressIndicatorTheme,

      // Switch theme
      switchTheme: _switchTheme,

      // Checkbox theme
      checkboxTheme: _checkboxTheme,

      // Radio theme
      radioTheme: _radioTheme,

      // Slider theme
      sliderTheme: _sliderTheme,

      // Tab bar theme
      tabBarTheme: _tabBarTheme,

      // List tile theme
      listTileTheme: _listTileTheme,

      // Drawer theme
      drawerTheme: _drawerTheme,

      // Scaffold background color
      scaffoldBackgroundColor: const Color(0xFF121212),

      // Canvas color
      canvasColor: const Color(0xFF1E1E1E),

      // System overlay style - removed from extensions
      // extensions: const [],
    );
  }

  /// Dark color scheme
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    // Primary colors
    primary: Color(0xFF2196F3), // Blue
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF1565C0),
    onPrimaryContainer: Color(0xFFE3F2FD),

    // Secondary colors
    secondary: Color(0xFF4CAF50), // Green
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF388E3C),
    onSecondaryContainer: Color(0xFFE8F5E8),

    // Tertiary colors
    tertiary: Color(0xFFFF9800), // Orange
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE65100),
    onTertiaryContainer: Color(0xFFFFF3E0),

    // Error colors
    error: Color(0xFFCF6679),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFFB00020),
    onErrorContainer: Color(0xFFFFDAD6),

    // Surface colors
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    surfaceContainerHighest: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFB0B0B0),

    // Outline colors
    outline: Color(0xFF737373),
    outlineVariant: Color(0xFF404040),

    // Shadow and scrim
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // Inverse colors
    inverseSurface: Color(0xFFE0E0E0),
    onInverseSurface: Color(0xFF121212),
    inversePrimary: Color(0xFF1976D2),
  );

  /// App bar theme
  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Color(0xFFE0E0E0),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFE0E0E0),
      size: 24,
    ),
    actionsIconTheme: IconThemeData(
      color: Color(0xFFE0E0E0),
      size: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  /// Navigation bar theme
  static const NavigationBarThemeData _navigationBarThemeData = NavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 8,
    height: 80,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    iconTheme: WidgetStatePropertyAll(IconThemeData(
      color: Color(0xFFB0B0B0),
      size: 24,
    )),
    labelTextStyle: WidgetStatePropertyAll(TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    )),
  );

  /// Bottom navigation bar theme
  static const BottomNavigationBarThemeData _bottomNavigationBarThemeData =
      BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xFF2196F3),
    unselectedItemColor: Color(0xFFB0B0B0),
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );

  /// Card theme
  static const CardTheme _cardTheme = CardTheme(
    color: Color(0xFF2C2C2C),
    elevation: 4,
    shadowColor: Color(0x40000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  /// Elevated button theme
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2196F3),
      foregroundColor: const Color(0xFFFFFFFF),
      elevation: 2,
      shadowColor: const Color(0x40000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Text button theme
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF2196F3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Outlined button theme
  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF2196F3),
      side: const BorderSide(color: Color(0xFF2196F3), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Floating action button theme
  static const FloatingActionButtonThemeData _floatingActionButtonTheme =
      FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF2196F3),
    foregroundColor: Color(0xFFFFFFFF),
    elevation: 6,
    shape: CircleBorder(),
  );

  /// Input decoration theme
  static const InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF2C2C2C),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFF404040)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFF404040)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFCF6679)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFCF6679), width: 2),
    ),
    labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
    hintStyle: TextStyle(color: Color(0xFF737373)),
    helperStyle: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
    errorStyle: TextStyle(color: Color(0xFFCF6679), fontSize: 12),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  /// Text theme
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  /// Icon theme
  static const IconThemeData _iconTheme = IconThemeData(
    color: Color(0xFFE0E0E0),
    size: 24,
  );

  /// Divider theme
  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: Color(0xFF404040),
    thickness: 1,
    space: 1,
  );

  /// Chip theme
  static const ChipThemeData _chipTheme = ChipThemeData(
    backgroundColor: Color(0xFF2C2C2C),
    selectedColor: Color(0xFF2196F3),
    disabledColor: Color(0xFF404040),
    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
    secondaryLabelStyle: TextStyle(color: Color(0xFFFFFFFF)),
    side: BorderSide(color: Color(0xFF404040)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  /// Dialog theme
  static const DialogTheme _dialogTheme = DialogTheme(
    backgroundColor: Color(0xFF2C2C2C),
    elevation: 24,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );

  /// Snack bar theme
  static const SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: Color(0xFF404040),
    contentTextStyle: TextStyle(color: Color(0xFFE0E0E0)),
    actionTextColor: Color(0xFF2196F3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    behavior: SnackBarBehavior.floating,
  );

  /// Progress indicator theme
  static const ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData(
    color: Color(0xFF2196F3),
    linearTrackColor: Color(0xFF404040),
    circularTrackColor: Color(0xFF404040),
  );

  /// Switch theme
  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF2196F3);
      }
      return const Color(0xFF737373);
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF1565C0);
      }
      return const Color(0xFF404040);
    }),
  );

  /// Checkbox theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF2196F3);
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
    side: const BorderSide(color: Color(0xFF737373), width: 2),
  );

  /// Radio theme
  static final RadioThemeData _radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF2196F3);
      }
      return const Color(0xFF737373);
    }),
  );

  /// Slider theme
  static const SliderThemeData _sliderTheme = SliderThemeData(
    activeTrackColor: Color(0xFF2196F3),
    inactiveTrackColor: Color(0xFF404040),
    thumbColor: Color(0xFF2196F3),
    overlayColor: Color(0x1F2196F3),
    valueIndicatorColor: Color(0xFF2196F3),
    valueIndicatorTextStyle: TextStyle(color: Color(0xFFFFFFFF)),
  );

  /// Tab bar theme
  static const TabBarTheme _tabBarTheme = TabBarTheme(
    labelColor: Color(0xFF2196F3),
    unselectedLabelColor: Color(0xFFB0B0B0),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
    ),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );

  /// List tile theme
  static const ListTileThemeData _listTileTheme = ListTileThemeData(
    tileColor: Color(0xFF2C2C2C),
    selectedTileColor: Color(0xFF1565C0),
    iconColor: Color(0xFFB0B0B0),
    selectedColor: Color(0xFFFFFFFF),
    textColor: Color(0xFFE0E0E0),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitleTextStyle: TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  /// Drawer theme
  static const DrawerThemeData _drawerTheme = DrawerThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    ),
  );
}

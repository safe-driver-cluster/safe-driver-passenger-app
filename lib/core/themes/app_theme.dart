import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constants.dart';
import '../constants/design_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',

      // Professional Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondaryColor,
        secondaryContainer: AppColors.secondaryLight,
        tertiary: AppColors.accentColor,
        tertiaryContainer: AppColors.accentLight,
        surface: AppColors.surfaceColor,
        surfaceContainer: AppColors.cardColor,
        error: AppColors.errorColor,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onError: AppColors.white,
        outline: AppColors.textHint,
        shadow: AppColors.shadowLight,
      ),

      // Professional App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.headline5.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        toolbarTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppDesign.iconMD,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppDesign.iconMD,
        ),
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.scaffoldBackground,

      // Professional Text Theme
      textTheme: TextTheme(
        displayLarge:
            AppTextStyles.headline1.copyWith(color: AppColors.textPrimary),
        displayMedium:
            AppTextStyles.headline2.copyWith(color: AppColors.textPrimary),
        displaySmall:
            AppTextStyles.headline3.copyWith(color: AppColors.textPrimary),
        headlineLarge:
            AppTextStyles.headline4.copyWith(color: AppColors.textPrimary),
        headlineMedium:
            AppTextStyles.headline5.copyWith(color: AppColors.textPrimary),
        headlineSmall:
            AppTextStyles.headline6.copyWith(color: AppColors.textPrimary),
        titleLarge:
            AppTextStyles.headline5.copyWith(color: AppColors.textPrimary),
        titleMedium:
            AppTextStyles.headline6.copyWith(color: AppColors.textPrimary),
        titleSmall: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        bodyMedium:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        bodySmall:
            AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        labelLarge:
            AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
        labelMedium:
            AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
        labelSmall:
            AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
      ),

      // Professional Card Theme
      cardTheme: CardTheme(
        color: AppColors.cardColor,
        shadowColor: Colors.black.withOpacity(0.08),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        margin: const EdgeInsets.all(AppDesign.spaceXS),
      ),

      // Professional ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceLG,
            vertical: AppDesign.spaceMD,
          ),
          minimumSize: const Size(0, AppDesign.buttonHeightMD),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Professional OutlinedButton Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryColor,
          side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceLG,
            vertical: AppDesign.spaceMD,
          ),
          minimumSize: const Size(0, AppDesign.buttonHeightMD),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // Professional TextButton Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceLG,
            vertical: AppDesign.spaceMD,
          ),
          minimumSize: const Size(0, AppDesign.buttonHeightMD),
          textStyle: AppTextStyles.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
        ),
      ),

      // Professional InputDecoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greyExtraLight,
        labelStyle: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceLG,
          vertical: AppDesign.spaceMD,
        ),
      ),

      // Professional BottomNavigationBar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),

      // Professional FloatingActionButton Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDesign.radiusLG),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',

      // Dark Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.accentLight,
        tertiaryContainer: AppColors.accentDark,
        surface: AppColors.darkSurface,
        surfaceContainer: AppColors.darkCard,
        error: AppColors.errorColor,
        onPrimary: AppColors.darkTextPrimary,
        onSecondary: AppColors.darkTextPrimary,
        onSurface: AppColors.darkTextPrimary,
        onError: AppColors.darkTextPrimary,
        outline: AppColors.darkTextSecondary,
        shadow: AppColors.shadowDark,
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,

      // Dark Text Theme
      textTheme: TextTheme(
        displayLarge:
            AppTextStyles.headline1.copyWith(color: AppColors.darkTextPrimary),
        displayMedium:
            AppTextStyles.headline2.copyWith(color: AppColors.darkTextPrimary),
        displaySmall:
            AppTextStyles.headline3.copyWith(color: AppColors.darkTextPrimary),
        headlineLarge:
            AppTextStyles.headline4.copyWith(color: AppColors.darkTextPrimary),
        headlineMedium:
            AppTextStyles.headline5.copyWith(color: AppColors.darkTextPrimary),
        headlineSmall:
            AppTextStyles.headline6.copyWith(color: AppColors.darkTextPrimary),
        titleLarge:
            AppTextStyles.headline5.copyWith(color: AppColors.darkTextPrimary),
        titleMedium:
            AppTextStyles.headline6.copyWith(color: AppColors.darkTextPrimary),
        titleSmall: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextPrimary),
        bodySmall: AppTextStyles.bodySmall
            .copyWith(color: AppColors.darkTextSecondary),
        labelLarge:
            AppTextStyles.labelLarge.copyWith(color: AppColors.darkTextPrimary),
        labelMedium: AppTextStyles.labelMedium
            .copyWith(color: AppColors.darkTextSecondary),
        labelSmall: AppTextStyles.labelSmall
            .copyWith(color: AppColors.darkTextSecondary),
      ),

      // Dark App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.headline5.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: AppDesign.iconMD,
        ),
      ),

      // Dark Card Theme
      cardTheme: CardTheme(
        color: AppColors.darkCard,
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppColors {
  // Professional Primary Colors - Modern Blue Spectrum
  static const Color primaryColor = Color(0xFF2563EB); // Professional Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryVariant = Color(0xFF1E40AF);
  static const Color primaryGradientStart = Color(0xFF6366F1); // Indigo
  static const Color primaryGradientEnd = Color(0xFF3B82F6); // Blue

  // Accent Colors - Premium Purple & Teal
  static const Color accentColor = Color(0xFF8B5CF6); // Professional Purple
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);
  static const Color tealAccent = Color(0xFF06B6D4); // Modern Teal

  // Modern Secondary Colors - Success Green
  static const Color secondaryColor = Color(0xFF10B981); // Emerald Green
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Enhanced Safety Colors
  static const Color safeColor = Color(0xFF10B981); // Emerald Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color dangerColor = Color(0xFFEF4444); // Red
  static const Color criticalColor = Color(0xFFDC2626); // Dark Red

  // Status Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);
  static const Color warningColorAlt = Color(0xFFF59E0B);

  // Professional Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF6B7280);
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color greyDark = Color(0xFF374151);
  static const Color greyExtraLight = Color(0xFFFAFAFA);
  static const Color greyMedium = Color(0xFF9CA3AF);

  // Modern Background Colors
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF3F4F6);
  static const Color glassBackground = Color(0x1AFFFFFF);

  // Enhanced Text Colors - Modern Typography
  static const Color textPrimary = Color(0xFF111827); // Dark Grey
  static const Color textSecondary = Color(0xFF6B7280); // Medium Grey
  static const Color textHint = Color(0xFF9CA3AF); // Light Grey
  static const Color textDisabled = Color(0xFFD1D5DB); // Very Light Grey
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textAccent = Color(0xFF2563EB); // Primary Blue
  static const Color textOnCard = Color(0xFF374151); // Card Text

  // Premium Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // Professional Gradient Collections
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
    stops: [0.0, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, accentDark],
    stops: [0.0, 1.0],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successColor, secondaryDark],
    stops: [0.0, 1.0],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warningColor, Color(0xFFEA580C)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [dangerColor, criticalColor],
    stops: [0.0, 1.0],
  );

  // Glass Morphism Effects
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0DFFFFFF),
    ],
  );

  // Premium Card Gradients
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAFBFF),
    ],
  );

  // Bus Status Colors
  static const Color busOnline = Color(0xFF4CAF50);
  static const Color busOffline = Color(0xFF9E9E9E);
  static const Color busInTransit = Color(0xFF2196F3);
  static const Color busAtStop = Color(0xFFFF9800);
  static const Color busEmergency = Color(0xFFF44336);
  static const Color busMaintenance = Color(0xFF9C27B0);

  // Driver Status Colors
  static const Color driverActive = Color(0xFF4CAF50);
  static const Color driverResting = Color(0xFFFF9800);
  static const Color driverOffDuty = Color(0xFF9E9E9E);
  static const Color driverAlert = Color(0xFFF44336);

  // Safety Score Colors
  static const Color safetyExcellent = Color(0xFF4CAF50); // 90-100
  static const Color safetyGood = Color(0xFF8BC34A); // 80-89
  static const Color safetyAverage = Color(0xFFFFEB3B); // 70-79
  static const Color safetyPoor = Color(0xFFFF9800); // 60-69
  static const Color safetyCritical = Color(0xFFF44336); // Below 60

  // Map Colors
  static const Color routeColorActive = Color(0xFF2196F3);
  static const Color routeColorInactive = Color(0xFF9E9E9E);
  static const Color hazardZoneColor = Color(0x80F44336);
  static const Color safeZoneColor = Color(0x804CAF50);

  // Transparent Colors
  static const Color transparent = Colors.transparent;
  static const Color blackTransparent = Color(0x80000000);
  static const Color whiteTransparent = Color(0x80FFFFFF);

  // Shadow Colors
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowMedium = Color(0x3D000000);
  static const Color shadowDark = Color(0x5C000000);
}

// Color utility methods
extension AppColorsExtension on AppColors {
  static Color getSafetyColor(double score) {
    if (score >= 90) return AppColors.safetyExcellent;
    if (score >= 80) return AppColors.safetyGood;
    if (score >= 70) return AppColors.safetyAverage;
    if (score >= 60) return AppColors.safetyPoor;
    return AppColors.safetyCritical;
  }

  static Color getBusStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
      case 'active':
        return AppColors.busOnline;
      case 'in_transit':
      case 'moving':
        return AppColors.busInTransit;
      case 'at_stop':
      case 'stopped':
        return AppColors.busAtStop;
      case 'emergency':
        return AppColors.busEmergency;
      case 'maintenance':
        return AppColors.busMaintenance;
      default:
        return AppColors.busOffline;
    }
  }

  static Color getDriverStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'driving':
        return AppColors.driverActive;
      case 'resting':
      case 'break':
        return AppColors.driverResting;
      case 'alert':
      case 'drowsy':
      case 'distracted':
        return AppColors.driverAlert;
      default:
        return AppColors.driverOffDuty;
    }
  }

  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

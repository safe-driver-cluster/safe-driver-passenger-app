import 'package:flutter/material.dart';

class AppDesign {
  // Professional Spacing System
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;
  static const double space3XL = 64.0;

  // Modern Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radius2XL = 24.0;
  static const double radiusFull = 999.0;

  // Professional Elevation System
  static const double elevationNone = 0.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 12.0;
  static const double elevation2XL = 16.0;
  static const double elevation3XL = 24.0;

  // Typography Scale
  static const double textXS = 12.0;
  static const double textSM = 14.0;
  static const double textMD = 16.0;
  static const double textLG = 18.0;
  static const double textXL = 20.0;
  static const double text2XL = 24.0;
  static const double text3XL = 30.0;
  static const double text4XL = 36.0;
  static const double text5XL = 48.0;

  // Professional Shadows
  static List<BoxShadow> get shadowSM => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMD => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowLG => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowXL => [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  // Glass Morphism Shadow
  static List<BoxShadow> get glassShadow => [
        BoxShadow(
          color: Colors.white.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(-1, -1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(2, 2),
        ),
      ];

  // Professional Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);
  static const Duration animationSlower = Duration(milliseconds: 600);

  // Professional Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;

  // Button Heights
  static const double buttonHeightSM = 36.0;
  static const double buttonHeightMD = 44.0;
  static const double buttonHeightLG = 52.0;
  static const double buttonHeightXL = 60.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 28.0;
  static const double iconXL = 32.0;
  static const double icon2XL = 40.0;
  static const double icon3XL = 48.0;

  // Professional Borders
  static Border get borderLight => Border.all(
        color: Colors.grey.withOpacity(0.15),
        width: 1.0,
      );

  static Border get borderMedium => Border.all(
        color: Colors.grey.withOpacity(0.25),
        width: 1.0,
      );

  static Border get borderStrong => Border.all(
        color: Colors.grey.withOpacity(0.35),
        width: 1.5,
      );

  // Professional Backdrop Filter
  static const double blurStrength = 10.0;
  static const double glassOpacity = 0.15;
}

// Professional Theme Extensions
class AppTextStyles {
  // Headlines
  static const TextStyle headline1 = TextStyle(
    fontSize: AppDesign.text5XL,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.025,
    height: 1.2,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: AppDesign.text4XL,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.025,
    height: 1.25,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: AppDesign.text3XL,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
    height: 1.3,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: AppDesign.text2XL,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
    height: 1.35,
  );

  static const TextStyle headline5 = TextStyle(
    fontSize: AppDesign.textXL,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
    height: 1.4,
  );

  static const TextStyle headline6 = TextStyle(
    fontSize: AppDesign.textLG,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
    height: 1.45,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppDesign.textLG,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppDesign.textMD,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AppDesign.textSM,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
  );

  // Labels & Buttons
  static const TextStyle labelLarge = TextStyle(
    fontSize: AppDesign.textSM,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: AppDesign.textXS,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.4,
  );

  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AppDesign.textMD,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    height: 1.25,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppDesign.textSM,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    height: 1.25,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: AppDesign.textXS,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    height: 1.25,
  );
}

import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/theme_helper.dart';

class DriverRatingPage extends StatelessWidget {
  final String? driverId;

  const DriverRatingPage({super.key, this.driverId});

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Scaffold(
      backgroundColor: th.background,
      appBar: AppBar(
        title: const Text(
          'Rate Driver',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Driver Rating Page - Driver ID: ${driverId ?? 'Unknown'}',
          style: TextStyle(fontSize: 18, color: th.textPrimary),
        ),
      ),
    );
  }
}

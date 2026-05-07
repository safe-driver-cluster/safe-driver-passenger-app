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
      appBar: AppBar(
        title: const Text('Rate Driver'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Driver Rating Page - Driver ID: ${driverId ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

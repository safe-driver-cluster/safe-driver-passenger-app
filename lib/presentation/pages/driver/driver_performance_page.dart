import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class DriverPerformancePage extends StatelessWidget {
  final String? driverId;

  const DriverPerformancePage({super.key, this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Performance'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Driver Performance Page - Driver ID: ${driverId ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

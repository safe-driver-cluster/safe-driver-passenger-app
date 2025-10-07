import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class DriverHistoryPage extends StatelessWidget {
  final String? driverId;

  const DriverHistoryPage({super.key, this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver History'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Driver History Page - Driver ID: ${driverId ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

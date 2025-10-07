import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class DriverProfilePage extends StatelessWidget {
  final String? driverId;

  const DriverProfilePage({super.key, this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Driver Profile Page - Driver ID: ${driverId ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

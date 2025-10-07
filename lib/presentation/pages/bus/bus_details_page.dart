import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class BusDetailsPage extends StatelessWidget {
  final String? busId;

  const BusDetailsPage({super.key, this.busId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Details'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Bus Details Page - Bus ID: ${busId ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

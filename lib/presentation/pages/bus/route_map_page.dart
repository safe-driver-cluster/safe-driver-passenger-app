import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class RouteMapPage extends StatelessWidget {
  const RouteMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Route Map Page - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class HazardZonesPage extends StatelessWidget {
  const HazardZonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Zones'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Hazard Zones Page - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

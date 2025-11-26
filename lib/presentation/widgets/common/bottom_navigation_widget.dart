import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDesign.space2XL),
          topRight: Radius.circular(AppDesign.space2XL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDesign.space2XL),
          topRight: Radius.circular(AppDesign.space2XL),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.2,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          showUnselectedLabels: true,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceMD,
                  vertical: AppDesign.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: currentIndex == 0
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: Icon(
                  currentIndex == 0
                      ? Icons.dashboard
                      : Icons.dashboard_outlined,
                  size: AppDesign.iconMD,
                ),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceMD,
                  vertical: AppDesign.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: currentIndex == 1
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: Icon(
                  currentIndex == 1 ? Icons.search : Icons.search_outlined,
                  size: AppDesign.iconMD,
                ),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceMD,
                  vertical: AppDesign.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: currentIndex == 2
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: Icon(
                  currentIndex == 2 ? Icons.map : Icons.map_outlined,
                  size: AppDesign.iconMD,
                ),
              ),
              label: 'Maps',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceMD,
                  vertical: AppDesign.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: currentIndex == 3
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: Icon(
                  currentIndex == 3 ? Icons.person : Icons.person_outlined,
                  size: AppDesign.iconMD,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
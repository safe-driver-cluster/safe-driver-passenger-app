import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';

import '../../../core/constants/color_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).profile,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
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
          AppLocalizations.of(context).profilePageComingSoon,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

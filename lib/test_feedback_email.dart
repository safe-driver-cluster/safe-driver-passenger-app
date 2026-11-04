import 'package:flutter/material.dart';

import 'core/services/email_service.dart';

/// Manual helper to verify the password-change email callable from the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final emailService = EmailService();
  final success = await emailService.sendPasswordChangedEmail(
    source: 'manual_test',
  );

  if (success) {
    print('Password change email callable completed successfully.');
  } else {
    print('Password change email callable did not complete successfully.');
  }
}

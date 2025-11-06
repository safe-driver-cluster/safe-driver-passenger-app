import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../data/models/feedback_model.dart';
import '../../controllers/feedback_controller.dart';

class FeedbackTestPage extends ConsumerStatefulWidget {
  const FeedbackTestPage({super.key});

  @override
  ConsumerState<FeedbackTestPage> createState() => _FeedbackTestPageState();
}

class _FeedbackTestPageState extends ConsumerState<FeedbackTestPage> {
  bool isLoading = false;
  String? lastResult;

  Future<void> _testFirebaseConnection() async {
    setState(() {
      isLoading = true;
      lastResult = null;
    });

    try {
      debugPrint('🧪 Testing Firebase connection...');
      
      await ref.read(feedbackControllerProvider.notifier).submitFeedback(
        userId: 'test_user_001',
        userName: 'Test User',
        busId: 'TEST_BUS',
        busNumber: 'TEST_BUS',
        rating: 5,
        comment: 'Test feedback from debug page',
        category: FeedbackCategory.general,
        type: FeedbackType.positive,
        title: 'Firebase Connection Test',
        metadata: {
          'test': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      setState(() {
        lastResult = '✅ SUCCESS: Feedback submitted to Firebase!';
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Test failed: $e');
      setState(() {
        lastResult = '❌ ERROR: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        title: const Text(
          'Firebase Test',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload,
                    size: 64,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  const Text(
                    'Firebase Integration Test',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceSM),
                  Text(
                    'Test the Firebase connection by submitting a test feedback entry.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDesign.spaceXL),
            ElevatedButton(
              onPressed: isLoading ? null : _testFirebaseConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Test Firebase Connection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            if (lastResult != null)
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceLG),
                decoration: BoxDecoration(
                  color: lastResult!.startsWith('✅')
                      ? AppColors.successColor.withOpacity(0.1)
                      : AppColors.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  border: Border.all(
                    color: lastResult!.startsWith('✅')
                        ? AppColors.successColor.withOpacity(0.3)
                        : AppColors.errorColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  lastResult!,
                  style: TextStyle(
                    fontSize: 14,
                    color: lastResult!.startsWith('✅')
                        ? AppColors.successColor
                        : AppColors.errorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                border: Border.all(
                  color: AppColors.infoColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Information:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.infoColor,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    '• Check Flutter logs for detailed error messages\n'
                    '• Ensure Firebase project is properly configured\n'
                    '• Verify google-services.json is in android/app/\n'
                    '• Check internet connection and Firebase rules',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
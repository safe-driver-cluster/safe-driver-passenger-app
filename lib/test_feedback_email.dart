import 'package:flutter/material.dart';

import 'core/services/email_service.dart';
import 'data/models/feedback_model.dart';

/// Test file to demonstrate email functionality
/// This can be used to test the email service independently
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🧪 Testing Email Service...');

  // Create a sample feedback for testing
  final testFeedback = FeedbackModel(
    id: 'test_${DateTime.now().millisecondsSinceEpoch}',
    userId: 'test_user_123',
    userName: 'John Doe',
    busId: 'bus_001',
    busNumber: 'B-123',
    driverId: 'driver_456',
    driverName: 'Mike Johnson',
    category: FeedbackCategory.service,
    type: FeedbackType.positive,
    title: 'Test Feedback Submission',
    description: 'This is a test feedback to verify email functionality.',
    rating: FeedbackRating(overall: 4),
    tags: ['test', 'email'],
    attachments: [],
    location: null,
    timestamp: DateTime.now(),
    status: FeedbackStatus.submitted,
    priority: FeedbackPriority.medium,
    metadata: {
      'quickAction': 'Good Service',
      'testMode': true,
    },
    relatedFeedbackIds: [],
    comment: 'Great service overall, just a minor suggestion for improvement.',
    images: [],
    submittedAt: DateTime.now(),
  );

  // Test the email service
  final emailService = EmailService();

  try {
    print('📧 Sending test feedback email...');

    final success = await emailService.sendFeedbackSummary(
      testFeedback,
      'test@example.com', // Replace with actual test email
    );

    if (success) {
      print('✅ Test email sent successfully!');
    } else {
      print('❌ Test email failed to send.');
    }
  } catch (e) {
    print('❌ Error during email test: $e');
  }

  print('🧪 Email test completed.');
}

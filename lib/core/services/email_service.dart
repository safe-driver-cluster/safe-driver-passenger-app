import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../data/models/feedback_model.dart';

class EmailService {
  // Admin email configuration
  static const String _adminEmail = 'rensithudaragonalagoda@gmail.com';
  static const String _smtpUsername = 'rensithudaragonalagoda@gmail.com';
  static const String _smtpPassword = 'gtrkvhgjaqfplaup';
  static const String _smtpHost = 'smtp.gmail.com';
  static const int _smtpPort = 587;

  // EmailJS configuration (alternative to direct SMTP)
  static const String _emailJsServiceId = 'service_feedback';
  static const String _emailJsTemplateId = 'template_feedback';
  static const String _emailJsUserId = 'your_emailjs_user_id';

  /// Send feedback confirmation email to user
  static Future<bool> sendUserConfirmationEmail({
    required String userEmail,
    required String userName,
    required FeedbackModel feedback,
  }) async {
    try {
      debugPrint('📧 Sending confirmation email to user: $userEmail');

      final emailContent = _generateUserEmailContent(
        userName: userName,
        feedback: feedback,
      );

      // Using EmailJS service for easier email sending
      final success = await _sendEmailViaEmailJS(
        toEmail: userEmail,
        toName: userName,
        subject: 'Feedback Confirmation - SafeDriver App',
        content: emailContent,
        isHtml: true,
      );

      if (success) {
        debugPrint('✅ User confirmation email sent successfully');
      } else {
        debugPrint('❌ Failed to send user confirmation email');
      }

      return success;
    } catch (e) {
      debugPrint('❌ Error sending user confirmation email: $e');
      return false;
    }
  }

  /// Send feedback notification email to admin
  static Future<bool> sendAdminNotificationEmail({
    required FeedbackModel feedback,
    required String userEmail,
  }) async {
    try {
      debugPrint('📧 Sending notification email to admin: $_adminEmail');

      final emailContent = _generateAdminEmailContent(
        feedback: feedback,
        userEmail: userEmail,
      );

      // Using EmailJS service
      final success = await _sendEmailViaEmailJS(
        toEmail: _adminEmail,
        toName: 'SafeDriver Admin',
        subject: 'New Feedback Received - Bus ${feedback.busNumber}',
        content: emailContent,
        isHtml: true,
      );

      if (success) {
        debugPrint('✅ Admin notification email sent successfully');
      } else {
        debugPrint('❌ Failed to send admin notification email');
      }

      return success;
    } catch (e) {
      debugPrint('❌ Error sending admin notification email: $e');
      return false;
    }
  }

  /// Send both user confirmation and admin notification emails
  static Future<Map<String, bool>> sendFeedbackEmails({
    required String userEmail,
    required String userName,
    required FeedbackModel feedback,
  }) async {
    debugPrint('📨 Sending feedback emails for Bus ${feedback.busNumber}');

    final results = await Future.wait([
      sendUserConfirmationEmail(
        userEmail: userEmail,
        userName: userName,
        feedback: feedback,
      ),
      sendAdminNotificationEmail(
        feedback: feedback,
        userEmail: userEmail,
      ),
    ]);

    return {
      'userEmail': results[0],
      'adminEmail': results[1],
    };
  }

  /// Send email via EmailJS service (recommended approach)
  static Future<bool> _sendEmailViaEmailJS({
    required String toEmail,
    required String toName,
    required String subject,
    required String content,
    bool isHtml = false,
  }) async {
    try {
      // For demo purposes, we'll simulate email sending
      // In production, you would integrate with EmailJS or similar service
      debugPrint('📤 Simulating email send to: $toEmail');
      debugPrint('📋 Subject: $subject');

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // In real implementation, you would make HTTP request to EmailJS
      /*
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': _emailJsServiceId,
          'template_id': _emailJsTemplateId,
          'user_id': _emailJsUserId,
          'template_params': {
            'to_email': toEmail,
            'to_name': toName,
            'subject': subject,
            'message': content,
          },
        }),
      );
      
      return response.statusCode == 200;
      */

      // For demo, always return true
      return true;
    } catch (e) {
      debugPrint('❌ Error in _sendEmailViaEmailJS: $e');
      return false;
    }
  }

  /// Generate HTML email content for user confirmation
  static String _generateUserEmailContent({
    required String userName,
    required FeedbackModel feedback,
  }) {
    final dateFormatter = DateFormat('MMMM dd, yyyy \'at\' h:mm a');
    final formattedDate = dateFormatter.format(feedback.submittedAt);

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Confirmation</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #2563EB, #3B82F6); color: white; padding: 30px; border-radius: 8px 8px 0 0; text-align: center; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 8px 8px; }
        .feedback-card { background: white; padding: 20px; border-radius: 8px; margin: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .rating-stars { font-size: 24px; color: #fbbf24; margin: 10px 0; }
        .footer { text-align: center; margin-top: 30px; color: #6b7280; font-size: 14px; }
        .highlight { background: #dbeafe; padding: 15px; border-radius: 6px; margin: 15px 0; }
        .badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .badge-bus { background: #dbeafe; color: #1e40af; }
        .badge-driver { background: #fce7f3; color: #be185d; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🚌 Feedback Received!</h1>
        <p>Thank you for helping us improve SafeDriver</p>
    </div>
    
    <div class="content">
        <h2>Hello, $userName!</h2>
        
        <p>We've successfully received your feedback and truly appreciate you taking the time to share your experience with us.</p>
        
        <div class="feedback-card">
            <h3>📋 Feedback Summary</h3>
            
            <div class="highlight">
                <strong>🚌 Bus Number:</strong> ${feedback.busNumber}<br>
                <strong>📅 Submitted:</strong> $formattedDate<br>
                <strong>🎯 Category:</strong> <span class="badge ${feedback.category == FeedbackCategory.vehicle ? 'badge-bus' : 'badge-driver'}">${feedback.categoryDisplay}</span>
            </div>
            
            <p><strong>⭐ Your Rating:</strong></p>
            <div class="rating-stars">
                ${'★' * feedback.rating.overall}${'☆' * (5 - feedback.rating.overall)} (${feedback.rating.overall}/5)
            </div>
            
            <p><strong>💭 Your Comments:</strong></p>
            <div style="background: #f3f4f6; padding: 15px; border-radius: 6px; font-style: italic;">
                "${feedback.comment.isNotEmpty ? feedback.comment : feedback.title}"
            </div>
            
            ${feedback.metadata['quickAction'] != null ? '''
            <p><strong>🏷️ Quick Feedback:</strong> ${feedback.metadata['quickAction']}</p>
            ''' : ''}
        </div>
        
        <div style="background: #ecfdf5; border: 1px solid #d1fae5; padding: 20px; border-radius: 8px; margin: 20px 0;">
            <h4 style="color: #065f46; margin-top: 0;">✅ What happens next?</h4>
            <ul style="color: #047857;">
                <li>Our team will review your feedback within 24-48 hours</li>
                <li>If action is required, we'll work to address the issue promptly</li>
                <li>For urgent safety concerns, we'll investigate immediately</li>
                <li>You may receive a follow-up email if we need additional information</li>
            </ul>
        </div>
        
        <p>Your feedback helps us maintain high standards and improve our service for everyone. Thank you for being part of the SafeDriver community!</p>
        
        <div class="footer">
            <p><strong>SafeDriver Team</strong><br>
            Making public transport safer, one trip at a time 🚌✨</p>
            <p style="font-size: 12px; margin-top: 20px;">
                This is an automated confirmation email. Please do not reply to this message.<br>
                If you have urgent concerns, please contact our support team directly.
            </p>
        </div>
    </div>
</body>
</html>
    ''';
  }

  /// Generate HTML email content for admin notification
  static String _generateAdminEmailContent({
    required FeedbackModel feedback,
    required String userEmail,
  }) {
    final dateFormatter = DateFormat('MMMM dd, yyyy \'at\' h:mm a');
    final formattedDate = dateFormatter.format(feedback.submittedAt);

    final priorityColor = feedback.priority == FeedbackPriority.high
        ? '#dc2626'
        : feedback.priority == FeedbackPriority.medium
            ? '#d97706'
            : '#059669';
    final priorityBg = feedback.priority == FeedbackPriority.high
        ? '#fef2f2'
        : feedback.priority == FeedbackPriority.medium
            ? '#fffbeb'
            : '#f0fdf4';

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Feedback Alert</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 700px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #dc2626, #ef4444); color: white; padding: 30px; border-radius: 8px 8px 0 0; text-align: center; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 8px 8px; }
        .feedback-card { background: white; padding: 25px; border-radius: 8px; margin: 20px 0; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .rating-stars { font-size: 24px; color: #fbbf24; margin: 10px 0; }
        .priority-badge { padding: 6px 16px; border-radius: 20px; font-weight: bold; display: inline-block; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0; }
        .info-item { background: #f9fafb; padding: 15px; border-radius: 6px; }
        .alert-box { padding: 20px; border-radius: 8px; margin: 20px 0; }
        .footer { text-align: center; margin-top: 30px; color: #6b7280; font-size: 14px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🚨 New Feedback Alert</h1>
        <p>Bus ${feedback.busNumber} - ${feedback.categoryDisplay} Feedback</p>
    </div>
    
    <div class="content">
        <div class="alert-box" style="background: $priorityBg; border-left: 4px solid $priorityColor;">
            <h3 style="margin-top: 0; color: $priorityColor;">
                🔔 Priority Level: 
                <span class="priority-badge" style="background: $priorityColor; color: white;">
                    ${feedback.priorityDisplay.toUpperCase()}
                </span>
            </h3>
        </div>
        
        <div class="feedback-card">
            <h3>📊 Feedback Details</h3>
            
            <div class="info-grid">
                <div class="info-item">
                    <strong>👤 User Information</strong><br>
                    Name: ${feedback.userName}<br>
                    Email: $userEmail<br>
                    User ID: ${feedback.userId}
                </div>
                
                <div class="info-item">
                    <strong>🚌 Service Information</strong><br>
                    Bus Number: ${feedback.busNumber}<br>
                    Category: ${feedback.categoryDisplay}<br>
                    Type: ${feedback.typeDisplay}
                </div>
                
                <div class="info-item">
                    <strong>⏰ Timing</strong><br>
                    Submitted: $formattedDate<br>
                    Status: ${feedback.statusDisplay}<br>
                    Platform: Mobile App
                </div>
                
                <div class="info-item">
                    <strong>⭐ Rating & Sentiment</strong><br>
                    Rating: ${feedback.rating.overall}/5 stars<br>
                    ${'★' * feedback.rating.overall}${'☆' * (5 - feedback.rating.overall)}<br>
                    Sentiment: ${feedback.rating.overall >= 4 ? '😊 Positive' : feedback.rating.overall >= 3 ? '😐 Neutral' : '😞 Negative'}
                </div>
            </div>
            
            <h4>💭 User Comments:</h4>
            <div style="background: #f3f4f6; padding: 20px; border-radius: 8px; border-left: 4px solid #6366f1;">
                <em>"${feedback.comment.isNotEmpty ? feedback.comment : feedback.title}"</em>
            </div>
            
            ${feedback.metadata['quickAction'] != null ? '''
            <h4>🏷️ Quick Action Selected:</h4>
            <div style="background: #e0e7ff; padding: 15px; border-radius: 6px; color: #3730a3;">
                <strong>${feedback.metadata['quickAction']}</strong>
            </div>
            ''' : ''}
            
            <h4>📋 Metadata:</h4>
            <ul style="background: #fafafa; padding: 20px; border-radius: 6px;">
                <li><strong>Feedback ID:</strong> ${feedback.id}</li>
                <li><strong>Target:</strong> ${feedback.metadata['feedbackTarget'] ?? 'General'}</li>
                <li><strong>Platform:</strong> ${feedback.metadata['platform'] ?? 'Mobile'}</li>
                <li><strong>Tags:</strong> ${feedback.tags.join(', ')}</li>
            </ul>
        </div>
        
        <div class="alert-box" style="background: #dbeafe; border-left: 4px solid #2563eb;">
            <h4 style="color: #1e40af; margin-top: 0;">⚡ Recommended Actions:</h4>
            <ul style="color: #1e40af;">
                ${feedback.rating.overall <= 2 ? '<li><strong>🚨 URGENT:</strong> Follow up immediately for low rating</li>' : ''}
                ${feedback.category == FeedbackCategory.driver ? '<li>👨‍✈️ Review with driver management team</li>' : ''}
                ${feedback.category == FeedbackCategory.vehicle ? '<li>🔧 Schedule maintenance inspection if needed</li>' : ''}
                <li>📧 Consider sending follow-up email to user within 48 hours</li>
                <li>📊 Add to monthly feedback analysis report</li>
                ${feedback.priority == FeedbackPriority.high ? '<li>🔴 Escalate to management immediately</li>' : ''}
            </ul>
        </div>
        
        <div class="footer">
            <p><strong>SafeDriver Admin Dashboard</strong><br>
            Feedback Management System</p>
            <p style="font-size: 12px; margin-top: 20px;">
                This notification was generated automatically when new feedback was submitted.<br>
                Please review and take appropriate action as needed.
            </p>
        </div>
    </div>
</body>
</html>
    ''';
  }

  /// Generate plain text email for fallback
  static String _generatePlainTextEmail({
    required String userName,
    required FeedbackModel feedback,
    bool isAdminEmail = false,
  }) {
    final dateFormatter = DateFormat('MMMM dd, yyyy \'at\' h:mm a');
    final formattedDate = dateFormatter.format(feedback.submittedAt);

    if (isAdminEmail) {
      return '''
NEW FEEDBACK ALERT - SafeDriver

Bus Number: ${feedback.busNumber}
User: ${feedback.userName}
Category: ${feedback.categoryDisplay}
Rating: ${feedback.rating.overall}/5 stars
Priority: ${feedback.priorityDisplay}
Submitted: $formattedDate

User Comments:
"${feedback.comment.isNotEmpty ? feedback.comment : feedback.title}"

${feedback.metadata['quickAction'] != null ? 'Quick Action: ${feedback.metadata['quickAction']}\n' : ''}

Feedback ID: ${feedback.id}
Status: ${feedback.statusDisplay}

Please review and take appropriate action.

---
SafeDriver Admin Dashboard
      ''';
    } else {
      return '''
Thank you for your feedback - SafeDriver

Hello $userName,

We've received your feedback about Bus ${feedback.busNumber} and appreciate you taking the time to share your experience.

Your Feedback Summary:
- Bus Number: ${feedback.busNumber}
- Category: ${feedback.categoryDisplay}
- Rating: ${feedback.rating.overall}/5 stars
- Submitted: $formattedDate

Your Comments: "${feedback.comment.isNotEmpty ? feedback.comment : feedback.title}"

${feedback.metadata['quickAction'] != null ? 'Quick Feedback: ${feedback.metadata['quickAction']}\n' : ''}

What happens next:
- Our team will review your feedback within 24-48 hours
- If action is required, we'll work to address it promptly
- For urgent concerns, we investigate immediately

Thank you for helping us improve SafeDriver!

---
SafeDriver Team
Making public transport safer, one trip at a time
      ''';
    }
  }
}

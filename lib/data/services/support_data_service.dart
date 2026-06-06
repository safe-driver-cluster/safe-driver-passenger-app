import 'package:safedriver_passenger_app/data/models/faq_model.dart';

class SupportDataService {
  static final SupportDataService _instance = SupportDataService._internal();

  factory SupportDataService() {
    return _instance;
  }

  SupportDataService._internal();

  // FAQ Data
  final List<FAQItem> _faqs = [
    // General App Issues
    FAQItem(
      id: 'faq_1',
      question: 'How do I download and install the app?',
      answer:
          'You can download SafeDriver - Passenger App from Google Play Store for Android or Apple App Store for iOS. Search for "SafeDriver - Passenger App" and tap Install. Once installed, open the app and sign up with your email or phone number.',
      category: 'App Issues',
      displayOrder: 1,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_2',
      question: 'The app is crashing. What should I do?',
      answer:
          'Try these steps:\n1. Force close the app\n2. Clear app cache (Settings > Apps > SafeDriver > Storage > Clear Cache)\n3. Uninstall and reinstall the app\n4. Ensure your device has at least 100MB free storage\n5. Update your device OS to the latest version\n\nIf the issue persists, contact our support team with your device information.',
      category: 'App Issues',
      displayOrder: 2,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_3',
      question: 'Why is my location not updating?',
      answer:
          'Location issues can be resolved by:\n1. Enabling Location Services on your device\n2. Ensuring the app has location permissions (Settings > Permissions > Location > Allow)\n3. Using "While Using the App" permission setting\n4. Checking if GPS is enabled\n5. Restarting the app\n\nIf using Android, make sure Battery Saver mode is not restricting the app.',
      category: 'App Issues',
      displayOrder: 3,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_4',
      question: 'I\'m not receiving notifications. How can I fix this?',
      answer:
          'To fix notification issues:\n1. Go to Settings > Notifications > SafeDriver\n2. Ensure notifications are enabled (toggle is ON)\n3. Check notification sound and vibration settings\n4. Try disabling and re-enabling notifications\n5. Restart your phone\n6. Update the app to the latest version\n\nFor iOS: Settings > Notifications > SafeDriver App > Allow Notifications',
      category: 'App Issues',
      displayOrder: 4,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_5',
      question: 'Can I use the app offline?',
      answer:
          'Some features work offline with limited functionality:\n• Viewing your saved routes and favorites (cached data)\n• Accessing your profile information\n• Reading historical data\n\nFeatures requiring internet:\n• Real-time bus tracking\n• Live traffic updates\n• Booking a bus\n• Sending emergency alerts\n\nThe app will sync data once you\'re back online.',
      category: 'App Issues',
      displayOrder: 5,
    ),

    // Bus Services
    FAQItem(
      id: 'faq_6',
      question: 'How do I find and book a bus?',
      answer:
          'To book a bus:\n1. Open the app and go to the "Buses" section\n2. Enter your pickup location and destination\n3. Select your preferred date and time\n4. View available buses with prices and ratings\n5. Tap "Book Now" to confirm\n6. Complete payment using your preferred method\n7. You\'ll receive a confirmation with bus details and tracking info',
      category: 'Bus Services',
      displayOrder: 1,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_7',
      question: 'What payment methods are accepted?',
      answer:
          'We accept multiple payment methods:\n• Credit/Debit Cards (Visa, Mastercard)\n• Digital Wallets (Google Pay, Apple Pay)\n• Bank Transfers\n• UPI (in India)\n• Cash Payment on Bus (where available)\n• In-app wallet credits\n\nAll payments are secured with encrypted transactions.',
      category: 'Bus Services',
      displayOrder: 2,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_8',
      question: 'Can I cancel or modify my booking?',
      answer:
          'Cancellation and modification policies:\n• Free cancellation up to 24 hours before departure\n• After 24 hours: 50% refund\n• Within 2 hours of departure: No refund\n• To modify: Cancel and rebook (subject to availability)\n• Refunds are processed within 3-5 business days\n\nTo cancel: Go to "My Bookings" > Select booking > Tap "Cancel"',
      category: 'Bus Services',
      displayOrder: 3,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_9',
      question: 'How do I track my bus in real-time?',
      answer:
          'Real-time tracking is available for all confirmed bookings:\n1. Go to "My Bookings"\n2. Select your active booking\n3. Tap "Track Bus" button\n4. You\'ll see the bus location on the map\n5. Get live updates of driver location and estimated arrival time\n6. Share your booking details with trusted contacts for safety',
      category: 'Bus Services',
      displayOrder: 4,
    ),
    FAQItem(
      id: 'faq_10',
      question: 'What should I do if I miss my bus?',
      answer:
          'If you miss your bus:\n1. Contact the driver immediately through the app\n2. For refund or rebooking, contact Support within 30 minutes\n3. Provide proof of your booking ID\n4. Eligible passengers may get a refund or free rebooking on the same route\n5. Future missed buses may result in account restrictions',
      category: 'Bus Services',
      displayOrder: 5,
    ),

    // Account & Security
    FAQItem(
      id: 'faq_11',
      question: 'How do I create an account?',
      answer:
          'Creating an account is simple:\n1. Open the SafeDriver app\n2. Tap "Sign Up"\n3. Choose phone number or email registration\n4. Enter your details (name, email/phone, password)\n5. Verify your email or phone with the OTP sent to you\n6. Set up your profile with photo and preferences\n7. Add emergency contacts for safety features\n8. Start booking buses!',
      category: 'Account & Security',
      displayOrder: 1,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_12',
      question: 'I forgot my password. How do I reset it?',
      answer:
          'To reset your password:\n1. Tap "Sign In" on the login screen\n2. Tap "Forgot Password?"\n3. Enter your registered email or phone number\n4. You\'ll receive a reset link or OTP\n5. Click the link or enter the OTP\n6. Create a new strong password (min 8 characters, mix of letters, numbers, symbols)\n7. Confirm your new password\n8. Sign in with your new password',
      category: 'Account & Security',
      displayOrder: 2,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_13',
      question: 'How do I enable two-factor authentication?',
      answer:
          'Two-factor authentication adds extra security to your account:\n1. Go to Settings > Security\n2. Tap "Two-Factor Authentication"\n3. Choose your preferred method (SMS or Email)\n4. Enter the code sent to you\n5. Save backup codes in a safe place\n6. 2FA is now enabled\n\nYou\'ll need to enter a code each time you sign in from a new device.',
      category: 'Account & Security',
      displayOrder: 3,
      isPopular: true,
    ),
    FAQItem(
      id: 'faq_14',
      question: 'What personal information do you collect?',
      answer:
          'We collect:\n• Name and contact information\n• Email and phone number\n• Payment information\n• Location data for safety and service delivery\n• Device information for app functionality\n• Usage analytics to improve services\n\nWe do NOT sell or share personal data with third parties without consent. See our Privacy Policy for complete details. All data is encrypted and securely stored.',
      category: 'Account & Security',
      displayOrder: 4,
    ),
    FAQItem(
      id: 'faq_15',
      question: 'Is my payment information secure?',
      answer:
          'Yes, your payment information is highly secure:\n• We use industry-standard SSL encryption\n• Payment data is processed through PCI DSS certified gateways\n• We never store full credit card details\n• All transactions are protected with fraud detection\n• Your data is securely encrypted at rest and in transit\n\nIf you notice suspicious activity, contact support immediately.',
      category: 'Account & Security',
      displayOrder: 5,
    ),
    FAQItem(
      id: 'faq_16',
      question: 'How do I delete my account?',
      answer:
          'To delete your account:\n1. Go to Settings > Account\n2. Tap "Delete Account"\n3. Review the consequences (lose booking history, etc.)\n4. Enter your password to confirm\n5. Your account will be deleted within 30 days\n6. A confirmation email will be sent\n\nNote: Some data may be retained for legal/compliance reasons.',
      category: 'Account & Security',
      displayOrder: 6,
    ),
  ];

  // Support Issues Data
  final List<SupportIssue> _supportIssues = [
    // App Issues
    SupportIssue(
      id: 'issue_1',
      title: 'App Won\'t Start or Keeps Crashing',
      description:
          'The app fails to launch or crashes immediately after opening.',
      category: 'App Issues',
      solutions: [
        'Force stop the app: Settings > Apps > SafeDriver > Force Stop',
        'Clear cache: Settings > Apps > SafeDriver > Storage > Clear Cache',
        'Restart your device',
        'Update the app from Play Store/App Store',
        'Check if you have at least 100MB free storage',
        'Try reinstalling the app',
        'If issue persists, contact support with your device model and OS version'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_2',
      title: 'Login Issues - Cannot Sign In',
      description:
          'Unable to login to account despite correct credentials or getting error messages.',
      category: 'App Issues',
      solutions: [
        'Verify you\'re using the correct email/phone number',
        'Use "Forgot Password" to reset your password',
        'Ensure you have an active internet connection',
        'Clear app cache and data, then try again',
        'Update the app to the latest version',
        'Try logging in from a different device to verify account access',
        'If 2FA is enabled, ensure you\'re entering the correct code',
        'Contact support if the issue persists'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_3',
      title: 'Notifications Not Working',
      description: 'Not receiving booking confirmations, alerts, or messages.',
      category: 'App Issues',
      solutions: [
        'Check notification settings: Settings > Notifications > SafeDriver',
        'Ensure "Allow Notifications" is turned ON',
        'Check if notifications are muted at the system level',
        'For Android: Check Battery Saver doesn\'t restrict the app',
        'For iOS: Check app notification permissions in Settings',
        'Restart the app',
        'Restart your device',
        'Reinstall the app if issue persists'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_4',
      title: 'GPS/Location Not Working',
      description:
          'Location services are not available or not updating in real-time.',
      category: 'App Issues',
      solutions: [
        'Enable Location Services: Settings > Location > Turn ON',
        'Grant location permission: Settings > Permissions > Location > Allow "While Using the App"',
        'Ensure GPS is enabled on your device',
        'For Android: Disable Battery Saver mode temporarily',
        'Restart the app',
        'Move to an open area (GPS works better outdoors)',
        'Restart your device if needed',
        'Check if other location apps work to diagnose system issue'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_5',
      title: 'Payment Failed or Pending',
      description: 'Payment issues during booking or refund not received.',
      category: 'App Issues',
      solutions: [
        'Check your internet connection',
        'Verify payment method has sufficient funds',
        'Try a different payment method',
        'Clear app cache and retry',
        'Contact your bank if payment was deducted',
        'Allow 3-5 business days for refund processing',
        'Provide transaction ID to support for verification',
        'Contact support with order/booking number'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),

    // Bus Services
    SupportIssue(
      id: 'issue_6',
      title: 'Cannot Find or Book Buses',
      description:
          'No bus results showing or unable to complete booking process.',
      category: 'Bus Services',
      solutions: [
        'Verify pickup and drop-off locations are valid',
        'Check if selected date/time has available buses',
        'Try searching for different times or dates',
        'Ensure your profile is complete with required information',
        'Check internet connection',
        'Try clearing app cache and restarting',
        'Update the app to latest version',
        'Contact support if no buses available in your area'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_7',
      title: 'Booking Confirmation Not Received',
      description:
          'Booking was completed but no confirmation email/SMS received.',
      category: 'Bus Services',
      solutions: [
        'Check your email spam/junk folder',
        'Check SMS inbox (messages may be delayed)',
        'Go to "My Bookings" in the app to view your booking',
        'Verify your phone number and email in your profile',
        'Request email resend from booking details page',
        'Check if push notifications show booking confirmation',
        'Wait up to 10 minutes for email/SMS delivery',
        'Contact support with your booking ID'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_8',
      title: 'Cannot Cancel or Modify Booking',
      description: 'Unable to cancel or modify an existing booking.',
      category: 'Bus Services',
      solutions: [
        'Go to "My Bookings" and find your booking',
        'Check cancellation window (24 hours before departure)',
        'If within 2 hours of departure, cancellation not allowed',
        'Ensure you have internet connection',
        'Try refreshing the bookings page',
        'For modifications, cancel and rebook if within refund window',
        'For emergency changes, contact support immediately',
        'Provide your booking ID to support'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_9',
      title: 'Real-Time Bus Tracking Not Working',
      description: 'Cannot see bus location or tracking updates are not live.',
      category: 'Bus Services',
      solutions: [
        'Ensure you have active internet connection',
        'Enable Location Services on your device',
        'Close and reopen the tracking screen',
        'Restart the app',
        'For older buses: Tracking may not be available',
        'Check if bus has departed (tracking starts after departure)',
        'Try refreshing the page',
        'Contact driver or support if still no tracking'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_10',
      title: 'Refund Not Received',
      description: 'Refund processing delayed or refund amount incorrect.',
      category: 'Bus Services',
      solutions: [
        'Check "Transactions" section in app for refund status',
        'Wait 3-5 business days for refund to reflect',
        'For card payments: Check with your bank',
        'For wallet refunds: Check wallet balance in app',
        'Verify refund amount based on cancellation policy',
        'Check if refund was processed to correct account',
        'Provide transaction/booking ID to support',
        'Contact support if refund shows as "failed"'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),

    // Account & Security
    SupportIssue(
      id: 'issue_11',
      title: 'Account Hacked or Unauthorized Access',
      description: 'Suspicious account activity or unauthorized bookings.',
      category: 'Account & Security',
      solutions: [
        'Immediately change your password',
        'Enable two-factor authentication',
        'Review recent bookings and transactions',
        'Report suspicious activity to support immediately',
        'Contact your bank if fraudulent charges occurred',
        'Remove unknown payment methods from your account',
        'Review and update security settings',
        'Contact support with details of unauthorized activity'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_12',
      title: 'Cannot Update Profile Information',
      description:
          'Unable to edit name, phone, email, or other profile details.',
      category: 'Account & Security',
      solutions: [
        'Go to Settings > Profile > Edit Profile',
        'Ensure you\'re not changing to an already registered email/phone',
        'Verify changes by completing OTP verification',
        'Clear app cache and try again',
        'Check internet connection',
        'Some fields may be locked if used in transactions',
        'Contact support to unlock fields if necessary',
        'Restart app and try again'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_13',
      title: 'Two-Factor Authentication Issues',
      description:
          'Unable to enable 2FA, not receiving verification codes, or locked out.',
      category: 'Account & Security',
      solutions: [
        'Ensure you have internet connection',
        'Check SMS/Email for verification code',
        'OTP codes expire after 10 minutes, request a new one',
        'Try different 2FA method (SMS vs Email)',
        'Add trusted device to skip 2FA on that device',
        'Save backup codes in secure location',
        'For locked account, contact support with ID verification',
        'Support can temporarily disable 2FA for account recovery'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_14',
      title: 'Privacy and Data Protection Concerns',
      description:
          'Questions about data collection, privacy, or data security.',
      category: 'Account & Security',
      solutions: [
        'Review our comprehensive Privacy Policy in Settings',
        'We collect only necessary data for service delivery',
        'Location data is encrypted and used only for your safety',
        'Payment data is handled by certified payment processors',
        'We never sell personal data to third parties',
        'You can request data export in Settings',
        'You can delete your account and associated data',
        'Contact our Privacy Officer for detailed inquiries'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
    SupportIssue(
      id: 'issue_15',
      title: 'Verification Code Not Received',
      description: 'OTP or verification code not arriving via SMS or email.',
      category: 'Account & Security',
      solutions: [
        'Check spam/junk folder for email',
        'Check SMS inbox (may take 1-2 minutes)',
        'Tap "Resend Code" to request a new code',
        'Ensure your phone number/email is correct',
        'Try using email instead of SMS or vice versa',
        'Codes expire after 10 minutes, request new one if expired',
        'Check internet connection',
        'Contact support if codes consistently not received'
      ],
      contactEmail: 'info@safedriver.com',
      contactPhone: '0112123123',
    ),
  ];

  // Get all FAQs
  List<FAQItem> getAllFAQs() => List.from(_faqs);

  // Get FAQs by category
  List<FAQItem> getFAQsByCategory(String category) {
    return _faqs.where((faq) => faq.category == category).toList();
  }

  // Get popular FAQs
  List<FAQItem> getPopularFAQs() {
    final popular = _faqs.where((faq) => faq.isPopular).toList();
    return popular.take(5).toList();
  }

  // Get FAQ categories
  List<String> getFAQCategories() {
    final categories = <String>{};
    for (var faq in _faqs) {
      categories.add(faq.category);
    }
    return categories.toList();
  }

  // Search FAQs
  List<FAQItem> searchFAQs(String query) {
    final lowerQuery = query.toLowerCase();
    return _faqs
        .where((faq) =>
            faq.question.toLowerCase().contains(lowerQuery) ||
            faq.answer.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Get all support issues
  List<SupportIssue> getAllSupportIssues() => List.from(_supportIssues);

  // Get support issues by category
  List<SupportIssue> getSupportIssuesByCategory(String category) {
    return _supportIssues.where((issue) => issue.category == category).toList();
  }

  // Search support issues
  List<SupportIssue> searchSupportIssues(String query) {
    final lowerQuery = query.toLowerCase();
    return _supportIssues
        .where((issue) =>
            issue.title.toLowerCase().contains(lowerQuery) ||
            issue.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Get support issue by ID
  SupportIssue? getSupportIssueById(String id) {
    try {
      return _supportIssues.firstWhere((issue) => issue.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get support categories
  List<String> getSupportCategories() {
    final categories = <String>{};
    for (var issue in _supportIssues) {
      categories.add(issue.category);
    }
    return categories.toList();
  }

  // Get contact information
  Map<String, String> getContactInfo() {
    return {
      'phone': '0112123123',
      'email': 'info@safedriver.com',
      'hours': '24/7 Support Available',
      'website': 'www.safedriver.com',
    };
  }
}

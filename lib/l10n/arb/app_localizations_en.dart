// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SafeDriver - Passenger App';

  @override
  String get appTagline => 'Your Safety, Our Priority';

  @override
  String get login => 'Login';

  @override
  String get signIn => 'Sign In';

  @override
  String get viewBus => 'View Bus';

  @override
  String get availableBuses => 'Available buses';

  @override
  String get viewDriverDetails => 'View Driver Details';

  @override
  String get driverInformation => 'Driver Information';

  @override
  String get myTrips => 'My Trips';

  @override
  String get viewHistory => 'View history';

  @override
  String get emergencyHelp => 'Emergency help';

  @override
  String get noRecentTrips => 'No recent trips';

  @override
  String get startFirstJourney => 'Start your first journey with SafeDriver';

  @override
  String get verifyYourAccount => 'Verify Your Account';

  @override
  String verificationCodeSent(String phoneNumber) {
    return 'We sent a verification code to\n$phoneNumber';
  }

  @override
  String get verifyAndCreateAccount => 'Verify & Create Account';

  @override
  String get didntReceiveCode => 'Didn\'t receive the code? ';

  @override
  String get resend => 'Resend';

  @override
  String resendIn(int seconds) {
    return 'Resend in $seconds s';
  }

  @override
  String get changePhoneNumber => 'Change phone number';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully!';

  @override
  String get accountCreatedAndVerified =>
      'Account created and verified successfully! Please login with your credentials.';

  @override
  String get pleaseEnterCompleteOtp => 'Please enter the complete OTP';

  @override
  String get verificationIdNotFound =>
      'Verification ID not found. Please try again.';

  @override
  String get otpSentSuccessfully => 'OTP sent successfully';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registrationSuccess => 'Registration successful';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get biometricAuthReason => 'Authenticate to access SafeDriver';

  @override
  String get biometricAuthFailed => 'Authentication failed. Please try again.';

  @override
  String get biometricAuthError => 'Authentication error';

  @override
  String get biometricAuthTitle => 'Biometric Authentication';

  @override
  String get biometricAuthDescription =>
      'Place your finger on the fingerprint sensor or look at the camera to authenticate.';

  @override
  String get biometricAuthWaiting => 'Waiting for authentication...';

  @override
  String get biometricAuthRetry => 'Try Again';

  @override
  String get biometricAuthInfo => 'This is required for your account security.';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get enterOTP => 'Enter OTP';

  @override
  String get otpSent => 'OTP sent to';

  @override
  String get otpFailed => 'Failed to send OTP';

  @override
  String get verificationFailed => 'Verification failed';

  @override
  String get emailValidationFailed =>
      'Email validation failed. Please check your email address.';

  @override
  String get passwordValidationFailed =>
      'Password validation failed. Please try again.';

  @override
  String get accountAlreadyExists =>
      'An account with this email already exists.';

  @override
  String get resendOTP => 'Resend OTP';

  @override
  String get otpExpired => 'OTP expired';

  @override
  String get invalidOTP => 'Invalid OTP';

  @override
  String get verifyOTP => 'Verify OTP';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get safetyOverview => 'Safety Overview';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get activeJourney => 'Active Journey';

  @override
  String get noActiveJourney => 'No active journey';

  @override
  String get safetyScore => 'Safety Score';

  @override
  String get fleetStatus => 'Fleet Status';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get busInformation => 'Bus Information';

  @override
  String get busDetails => 'Bus Details';

  @override
  String get busNumber => 'Bus Number';

  @override
  String get routeNumber => 'Route Number';

  @override
  String get driverName => 'Driver Name';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get nextStop => 'Next Stop';

  @override
  String get estimatedArrival => 'Estimated Arrival';

  @override
  String get passengerCapacity => 'Passenger Capacity';

  @override
  String get busStatus => 'Bus Status';

  @override
  String get liveTracking => 'Live Tracking';

  @override
  String get trackBus => 'Track Bus';

  @override
  String get busHistory => 'Bus History';

  @override
  String get searchBus => 'Search Bus';

  @override
  String get scanQRCode => 'Scan QR Code';

  @override
  String get driverProfile => 'Driver Profile';

  @override
  String get driverHistory => 'Driver History';

  @override
  String get driverPerformance => 'Driver Performance';

  @override
  String get driverRating => 'Driver Rating';

  @override
  String get driverExperience => 'Experience';

  @override
  String get driverLicense => 'License';

  @override
  String get driverCertifications => 'Certifications';

  @override
  String get driverContact => 'Contact';

  @override
  String get driverStatus => 'Driver Status';

  @override
  String get alertnessLevel => 'Alertness Level';

  @override
  String get safety => 'Safety';

  @override
  String get safetyAlerts => 'Safety Alerts';

  @override
  String get emergencyAlert => 'Emergency Alert';

  @override
  String get hazardZones => 'Hazard Zones';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get callEmergency => 'Call Emergency';

  @override
  String get reportIncident => 'Report incident';

  @override
  String get safetyTips => 'Safety Tips';

  @override
  String get weatherWarning => 'Weather Warning';

  @override
  String get roadConditions => 'Road Conditions';

  @override
  String get trafficAlert => 'Traffic Alert';

  @override
  String get feedback => 'Feedback';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get feedbackHistory => 'Feedback History';

  @override
  String get rateBus => 'Rate Bus';

  @override
  String get rateDriver => 'Rate Driver';

  @override
  String get reportProblem => 'Report Problem';

  @override
  String get suggestion => 'Suggestion';

  @override
  String get complaint => 'Complaint';

  @override
  String get compliment => 'Compliment';

  @override
  String get feedbackSubmitted => 'Feedback submitted successfully';

  @override
  String get general => 'General';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get autoMode => 'Auto Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get fontSize => 'Font Size';

  @override
  String get privacy => 'Privacy';

  @override
  String get dataUsage => 'Data Usage';

  @override
  String get location => 'Location';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Change Password';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get or => 'OR';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get noAccountFoundPhone => 'No account found with this phone number.';

  @override
  String get enterPhoneResetPassword =>
      'Enter your phone number and we will send you\na code to reset your password';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get pleaseEnterComplete6DigitOtp =>
      'Please enter the complete 6-digit OTP';

  @override
  String get invalidOtpTryAgain => 'Invalid OTP. Please try again.';

  @override
  String get sending => 'Sending...';

  @override
  String get passwordResetSuccessful => 'Password Reset Successful';

  @override
  String get passwordResetSuccessMessage =>
      'Your password has been reset successfully. You can now sign in with your new password.';

  @override
  String get goToSignIn => 'Go to Sign In';

  @override
  String get passwordResetSuccessLoginMessage =>
      'Password reset successful. Please sign in with your new password.';

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordRequirements => 'Password Requirements:';

  @override
  String get passwordReq1 => '• At least 8 characters long';

  @override
  String get passwordReq2 => '• Contains uppercase and lowercase letters';

  @override
  String get passwordReq3 => '• Contains at least one number';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get verifyYourPhone => 'Verify Your Phone';

  @override
  String get enterVerificationCode => 'Enter Verification Code';

  @override
  String get type6DigitCode => 'Type the 6-digit code we sent you';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String otpSentTo(String phoneNumber) {
    return 'OTP sent successfully to $phoneNumber';
  }

  @override
  String get createStrongNewPassword =>
      'Create a strong new password\nfor your account';

  @override
  String get enterYourPhoneNumber => 'Enter Your Phone Number';

  @override
  String get sendVerificationCodeViaSMS =>
      'We\'ll send you a verification code via SMS';

  @override
  String get enterSriLankanMobile => 'Enter your Sri Lankan mobile number';

  @override
  String get sendVerificationCode => 'Send Verification Code';

  @override
  String get smsAgreement =>
      'By continuing, you agree to receive SMS messages from SafeDriver for verification purposes. Message and data rates may apply.';

  @override
  String get phoneHint => '77 123 4567';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get emailAndPassword => 'Email & Password';

  @override
  String get invalidSriLankanPhone =>
      'Please enter a valid Sri Lankan phone number';

  @override
  String get done => 'Done';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get skip => 'Skip';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get updating => 'Updating...';

  @override
  String get searching => 'Searching...';

  @override
  String get processing => 'Processing...';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get preferNotToSay => 'Prefer not to say';

  @override
  String get manageSosContacts => 'Manage SOS contacts for emergency alerts';

  @override
  String get manage => 'Manage';

  @override
  String errorSelectingImage(String error) {
    return 'Error selecting image: $error';
  }

  @override
  String errorSavingProfile(String error) {
    return 'Error saving profile: $error';
  }

  @override
  String errorLoadingProfile(String error) {
    return 'Error loading profile: $error';
  }

  @override
  String get error => 'Error';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get networkError => 'Network error';

  @override
  String get serverError => 'Server error';

  @override
  String get connectionTimeout => 'Connection timeout';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get dataMissing => 'Data missing';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get requiredField => 'This field is required';

  @override
  String get tryAgainLater => 'Please try again later';

  @override
  String get success => 'Success';

  @override
  String get operationSuccessful => 'Operation successful';

  @override
  String get dataSaved => 'Data saved successfully';

  @override
  String get dataUpdated => 'Data updated successfully';

  @override
  String get dataDeleted => 'Data deleted successfully';

  @override
  String get noData => 'No data available';

  @override
  String get noResults => 'No results found';

  @override
  String get noBuses => 'No buses found';

  @override
  String get noDrivers => 'No drivers found';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noHistory => 'No history available';

  @override
  String get noFeedback => 'No feedback submitted';

  @override
  String get noAlerts => 'No active alerts';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get thisWeek => 'This Week';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get minutes => 'minutes';

  @override
  String get hours => 'hours';

  @override
  String get days => 'days';

  @override
  String get weeks => 'weeks';

  @override
  String get months => 'months';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get firstNameMinLength => 'First name must be at least 2 characters';

  @override
  String get lastNameMinLength => 'Last name must be at least 2 characters';

  @override
  String get passwordComplexity =>
      'Password must contain uppercase, lowercase, and number';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get acceptTerms => 'Please accept the terms and conditions';

  @override
  String get welcomeTitle => 'Welcome to SafeDriver';

  @override
  String get onboarding1Title => 'Safe & Reliable Transport';

  @override
  String get onboarding1Description =>
      'Experience the most secure and dependable transportation service. Your safety is our top priority with professionally trained drivers.';

  @override
  String get onboarding2Title => 'Real-Time Tracking';

  @override
  String get onboarding2Description =>
      'Track your ride in real-time and stay connected with live location updates. Know exactly where your ride is at every moment.';

  @override
  String get onboarding3Title => 'Smart Feedback System';

  @override
  String get onboarding3Description =>
      'Share your experience and help us maintain the highest service standards. Your feedback makes every journey better.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get legal => 'Legal';

  @override
  String get licenses => 'Licenses';

  @override
  String get emergency => 'Emergency';

  @override
  String get police => 'Police';

  @override
  String get medical => 'Medical';

  @override
  String get fire => 'Fire';

  @override
  String get callNow => 'Call Now';

  @override
  String get emergencyHotline => 'Emergency Hotline';

  @override
  String get policeStation => 'Police Station';

  @override
  String get hospital => 'Hospital';

  @override
  String get fireStation => 'Fire Station';

  @override
  String get alwaysWearSeatbelt => 'Always wear your seatbelt';

  @override
  String get stayAlert => 'Stay alert and aware of your surroundings';

  @override
  String get keepEmergencyContacts =>
      'Keep emergency contacts readily available';

  @override
  String get reportSuspiciousActivity =>
      'Report any suspicious activity immediately';

  @override
  String get followBusSafety =>
      'Follow bus safety protocols and driver instructions';

  @override
  String get close => 'Close';

  @override
  String get bookTicket => 'Book Ticket';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get trackLive => 'Track Live';

  @override
  String get share => 'Share';

  @override
  String get shareFunctionality => 'Share functionality will be implemented';

  @override
  String get english => 'English';

  @override
  String get sinhala => 'සිංහල';

  @override
  String get tamil => 'தமிழ்';

  @override
  String reportedBy(String name) {
    return 'Reported by: $name';
  }

  @override
  String busIdLabel(String busId) {
    return 'Bus ID: $busId';
  }

  @override
  String driverIdLabel(String driverId) {
    return 'Driver ID: $driverId';
  }

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get acknowledge => 'Acknowledge';

  @override
  String get viewDetails => 'View Details';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get contact => 'Contact';

  @override
  String get viewAll => 'View All';

  @override
  String get scanQR => 'Scan QR';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get goBack => 'Go Back';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get details => 'Details';

  @override
  String get track => 'Track';

  @override
  String get safetyTipsTitle => 'Safety Tips';

  @override
  String get safetyHub => 'Safety Hub';

  @override
  String get reportSafetyIssue => 'Report Safety Issue';

  @override
  String get report => 'Report';

  @override
  String get gotIt => 'Got it';

  @override
  String get safetyAlertsTitle => 'Safety Alerts';

  @override
  String get reportIncidentTitle => 'Report Incident';

  @override
  String get hazardZonesTitle => 'Hazard Zones';

  @override
  String get emergencyContactsTitle => 'Emergency Contacts';

  @override
  String get enterCodeManually => 'Enter Code Manually';

  @override
  String qrCodeDetected(String code) {
    return 'QR Code detected: $code';
  }

  @override
  String get signOut => 'Sign Out';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out?';

  @override
  String get tripHistory => 'Trip History';

  @override
  String get review => 'Review';

  @override
  String tripDetails(String id) {
    return 'Trip $id';
  }

  @override
  String get giveFeedback => 'Give Feedback';

  @override
  String get comingSoonFeature =>
      'This feature will be available in a future update.';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get cacheClearedSuccessfully => 'Cache cleared successfully!';

  @override
  String get clear => 'Clear';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String failedToUpdateProfile(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get myProfile => 'My Profile';

  @override
  String get noProfileFound => 'No profile found';

  @override
  String get viewFAQ => 'View FAQ';

  @override
  String get changePicture => 'Change Picture';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get aboutTitle => 'About';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get searchFunctionalityComingSoon =>
      'Search functionality coming soon!';

  @override
  String get busRoutesComingSoon => 'Bus routes coming soon!';

  @override
  String get navigationComingSoon => 'Navigation coming soon!';

  @override
  String selected(String description) {
    return 'Selected: $description';
  }

  @override
  String placeLookupFailed(String error) {
    return 'Place lookup failed: $error';
  }

  @override
  String foundBusStopsNearby(int count) {
    return 'Found $count bus stops nearby';
  }

  @override
  String foundQueryTapNavigate(String query) {
    return 'Found \"$query\". Tap Navigate to see bus route!';
  }

  @override
  String searchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String get unableToGetCurrentLocation => 'Unable to get current location';

  @override
  String get pleaseSearchForDestination =>
      'Please search for a destination first';

  @override
  String errorSelectingLanguage(String error) {
    return 'Error selecting language: $error';
  }

  @override
  String get hazardZoneIntelligence => 'Hazard Zone Intelligence';

  @override
  String get loadingHazardZoneData => 'Loading hazard zone data...';

  @override
  String get driverIdRequiredForAlerts => 'Driver ID required to view alerts';

  @override
  String get noActiveHazardAlerts => 'No active hazard alerts';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String get back => 'Back';

  @override
  String get addMedia => 'Add Media';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String fileTooLarge(String fileName) {
    return '$fileName is too large. Maximum size is 10MB.';
  }

  @override
  String get locationPermissionRequired =>
      'Location permission is required to share location';

  @override
  String failedToGetLocation(String error) {
    return 'Failed to get location: $error';
  }

  @override
  String get incidentReportingImplemented =>
      'Incident reporting will be implemented';

  @override
  String get priority => 'Priority';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get urgent => 'Urgent';

  @override
  String get submitAnonymously => 'Submit anonymously';

  @override
  String get personalInfoNotShared =>
      'Your personal information will not be shared';

  @override
  String get chooseYourLanguage => 'Choose Your Language';

  @override
  String get selectYourPreferredLanguage =>
      'Select your preferred language to continue';

  @override
  String get availableLanguages => 'Available Languages';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get profilePageComingSoon => 'Profile Page - Coming Soon';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get profilePicture => 'Profile Picture';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get noEmail => 'No email';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get addressInformation => 'Address Information';

  @override
  String get streetAddress => 'Street Address';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get zipCode => 'ZIP Code';

  @override
  String get country => 'Country';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get contactName => 'Contact Name';

  @override
  String get relationship => 'Relationship';

  @override
  String get preferences => 'Preferences';

  @override
  String get cameraError => 'Camera Error';

  @override
  String get positionQrCode => 'Position QR code here';

  @override
  String get qrScanner => 'QR Scanner';

  @override
  String get scanQrInstruction => 'Scan QR code on bus or stop';

  @override
  String get alignQrInstruction =>
      'Hold steady and align QR code within the frame';

  @override
  String get enterBusStopCode => 'Enter bus or stop code';

  @override
  String get submit => 'Submit';

  @override
  String get mapsNavigation => 'Maps & Navigation';

  @override
  String get searchDestination => 'Search for destination...';

  @override
  String get busStop => 'Bus Stop';

  @override
  String get navigate => 'Navigate';

  @override
  String get yourLocation => 'Your Location';

  @override
  String get currentPosition => 'Current position';

  @override
  String get unableToLoadMap => 'Unable to load map';

  @override
  String get loadingMap => 'Loading map...';

  @override
  String get busRouteToDestination => 'Bus Route to Destination';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String failedToChangeLanguage(String error) {
    return 'Failed to change language: $error';
  }

  @override
  String tripId(String tripId) {
    return 'Trip ID: $tripId';
  }

  @override
  String get safetyFirst => 'Safety First';

  @override
  String get safetyDescription =>
      'Your safety is our top priority. Access emergency features, report incidents, and stay informed about safety measures.';

  @override
  String get emergencyActions => 'Emergency Actions';

  @override
  String get callForHelp => 'Call for help';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get safetyFeatures => 'Safety Features';

  @override
  String get realTimeSafetyNotifications => 'Real-time safety notifications';

  @override
  String get viewKnownHazardousAreas => 'View known hazardous areas';

  @override
  String get learnSafetyBestPractices => 'Learn safety best practices';

  @override
  String get support => 'Support';

  @override
  String get reportSafetyDialogContent =>
      'Would you like to report a safety incident or concern?';

  @override
  String get safetyTip1 => '• Always wear your seatbelt';

  @override
  String get safetyTip2 => '• Stay alert and aware of your surroundings';

  @override
  String get safetyTip3 => '• Keep emergency contacts readily available';

  @override
  String get safetyTip4 => '• Report any suspicious activity immediately';

  @override
  String get safetyTip5 =>
      '• Follow bus safety protocols and driver instructions';

  @override
  String get iAgreeTo => 'I agree to the ';

  @override
  String get and => ' and ';

  @override
  String errorOccurredGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get goodNight => 'Good Night';

  @override
  String get traveler => 'Traveler';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get activeBuses => 'Active Buses';

  @override
  String activeBusesCount(Object count) {
    return '$count Active Buses';
  }

  @override
  String safetyScoreLabel(Object score) {
    return 'Safety Score: $score%';
  }

  @override
  String driversCount(Object count) {
    return '$count Drivers';
  }

  @override
  String hazardZonesCount(Object count) {
    return '$count Hazard Zones';
  }

  @override
  String get busQrScanned => 'Bus QR code scanned';

  @override
  String get safetyAlertAcknowledged => 'Safety alert acknowledged';

  @override
  String get newHazardZoneReported => 'New hazard zone reported';

  @override
  String timeAgo(Object time) {
    return '$time ago';
  }

  @override
  String get poweredBy => 'Powered by SafeDriver Technologies';

  @override
  String get addSosContact => 'Add SOS Contact';

  @override
  String get editSosContact => 'Edit SOS Contact';

  @override
  String get removeSosContact => 'Remove SOS Contact';

  @override
  String areYouSureRemoveContact(Object name) {
    return 'Are you sure you want to remove $name from your SOS contacts?';
  }

  @override
  String get contactNameLabel => 'Contact Name';

  @override
  String get contactNameHint => 'e.g., Mom, Dad, Spouse';

  @override
  String get relationshipLabel => 'Relationship';

  @override
  String get relationshipHint => 'e.g., Parent, Friend';

  @override
  String get alertMethods => 'Alert Methods';

  @override
  String get autoSendSos => 'Auto-Send SOS';

  @override
  String get autoSendSosDescription =>
      'Automatically send alerts to all contacts';

  @override
  String get sosContactsDescription =>
      'Add trusted contacts who will receive your SOS alerts via SMS and WhatsApp with your live location.';

  @override
  String get noSosContactsYet => 'No SOS Contacts Yet';

  @override
  String get addYourFirstContact => 'Add Your First Contact';

  @override
  String get mySosContacts => 'My SOS Contacts';

  @override
  String sosContactsCount(Object count) {
    return '$count contacts';
  }

  @override
  String get sms => 'SMS';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get onDuty => 'On Duty';

  @override
  String get offDuty => 'Off Duty';

  @override
  String get onBreak => 'On Break';

  @override
  String get unknown => 'Unknown';

  @override
  String experienceYears(Object years) {
    return '$years years';
  }

  @override
  String get joined => 'Joined';

  @override
  String get license => 'License';

  @override
  String get model => 'Model';

  @override
  String get searchBusesHint => 'Search by bus number, route, driver...';

  @override
  String get searchDriversHint => 'Search by name, license, route...';

  @override
  String get searchPlacesHint => 'Search for places, bus stops...';

  @override
  String get noBusesAvailable => 'No buses available';

  @override
  String get checkBackLaterBuses => 'Check back later for available buses';

  @override
  String get noMatchingDrivers => 'No matching drivers';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get locationServicesDisabled =>
      'Location services are disabled. Please enable location services.';

  @override
  String get locationPermissionDenied =>
      'Location permission denied. Please grant location access.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permissions are permanently denied. Please enable them in settings.';

  @override
  String get noMatchingLocations => 'No matching locations found';

  @override
  String get destination => 'Destination';

  @override
  String get boardBus => 'Board bus';

  @override
  String get leaveBus => 'Leave bus';

  @override
  String get googleBusDirectionsUnavailable =>
      'Google bus directions unavailable. Showing estimated road route.';

  @override
  String get distance => 'Distance';

  @override
  String get duration => 'Duration';

  @override
  String get avgSpeed => 'Avg speed';

  @override
  String get zoomIn => 'Zoom In';

  @override
  String get zoomOut => 'Zoom Out';

  @override
  String get toggleMapType => 'Toggle Map Type';

  @override
  String get toggleTraffic => 'Toggle Traffic';

  @override
  String get centerOnLocation => 'Center on Location';

  @override
  String stopsCount(Object count) {
    return '$count stops';
  }

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Good';

  @override
  String get fair => 'Fair';

  @override
  String get poor => 'Poor';

  @override
  String get critical => 'Critical';

  @override
  String get healthRecord => 'Health Record';

  @override
  String get lastMedicalCheck => 'Last Medical Check';

  @override
  String get medicalStatus => 'Medical Status';

  @override
  String get healthy => 'Healthy';

  @override
  String get healthIssues => 'Health Issues';

  @override
  String get medicalExamDue => 'Medical Exam Due';

  @override
  String get medicalConditions => 'Medical Conditions';

  @override
  String get none => 'None';

  @override
  String get performanceOverview => 'Performance Overview';

  @override
  String get totalTrips => 'Total Trips';

  @override
  String get totalDistance => 'Total Distance';

  @override
  String get punctuality => 'Punctuality';

  @override
  String get fuelEfficiency => 'Fuel Efficiency';

  @override
  String get routeSpecializations => 'Route Specializations';

  @override
  String get trainingHistory => 'Training History';

  @override
  String get noTrainingRecords => 'No training records available';

  @override
  String get passed => 'Passed';

  @override
  String get failed => 'Failed';

  @override
  String get expires => 'Expires';

  @override
  String get active => 'Active';

  @override
  String get expired => 'Expired';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get currentStatus => 'Current Status';

  @override
  String get currentBus => 'Current Bus';

  @override
  String get currentRoute => 'Current Route';

  @override
  String get alertness => 'Alertness';

  @override
  String get mainFeatures => 'Main Features';

  @override
  String get qrScannerDescription =>
      'Scan bus QR codes to get instant information';

  @override
  String get liveTrackingDescription =>
      'Real-time bus location tracking with maps';

  @override
  String get driverInfoDescription =>
      'Detailed driver information and performance';

  @override
  String get hazardZonesDescription =>
      'Monitor dangerous areas and safety alerts';

  @override
  String get quickStats => 'Quick Stats';

  @override
  String get appDescription =>
      'Your comprehensive bus safety monitoring platform';

  @override
  String get driverInfo => 'Driver Info';

  @override
  String get drivers => 'Drivers';

  @override
  String get verifiedMember => 'Verified Member';

  @override
  String get updateInfo => 'Update info';

  @override
  String get viewTrips => 'View trips';

  @override
  String get yourFeedback => 'Your Feedback';

  @override
  String get getHelp => 'Get help';

  @override
  String get accountAndSettings => 'Account & Settings';

  @override
  String get notProvided => 'Not provided';

  @override
  String get appSettings => 'App Settings';

  @override
  String get aboutApp => 'About App';

  @override
  String get unableToLoadProfile => 'Unable to load profile';

  @override
  String get shareFeedback => 'Share Feedback';

  @override
  String get feedbackSubtitle => 'Help us improve your experience';

  @override
  String get tripInformation => 'Trip Information';

  @override
  String get busIdTitle => 'Bus ID';

  @override
  String get tripIdTitle => 'Trip ID';

  @override
  String get rateExperience => 'Rate Your Experience';

  @override
  String get noFeedbackYet => 'No Feedback Yet';

  @override
  String get noFeedbackSubtitle =>
      'Share your feedback about buses and drivers to get started';

  @override
  String busLabel(String busNumber) {
    return 'Bus $busNumber';
  }

  @override
  String get statusSubmitted => 'Submitted';

  @override
  String get statusReviewed => 'Reviewed';

  @override
  String get statusResolved => 'Resolved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusPending => 'Pending';

  @override
  String get commentLabel => 'Comment';

  @override
  String submittedDateLabel(String date) {
    return 'Submitted: $date';
  }

  @override
  String get feedbackHistorySubtitle => 'Track all your feedback submissions';

  @override
  String get typePositive => 'Positive';

  @override
  String get typeNegative => 'Negative';

  @override
  String get typeNeutral => 'Neutral';

  @override
  String get typeSuggestion => 'Suggestion';

  @override
  String get typeInquiry => 'Inquiry';

  @override
  String get typeUrgent => 'Urgent';

  @override
  String get typeGeneral => 'General';

  @override
  String get categoryComfort => 'Comfort';

  @override
  String get categoryVehicle => 'Vehicle';

  @override
  String feedbackSuccessWithId(String id) {
    return 'Feedback submitted successfully! ID: $id';
  }

  @override
  String feedbackFailed(String error) {
    return 'Failed to submit feedback: $error';
  }

  @override
  String get failedToLoadPassenger => 'Failed to load passenger data';

  @override
  String get pleaseTryAgainLater => 'Please try again later';

  @override
  String get noPassengerProfile => 'No passenger profile found';

  @override
  String get passengerInformation => 'Passenger Information';

  @override
  String get submitFeedbackSubtitle =>
      'Share your experience and help us improve';

  @override
  String nameLabel(String name) {
    return 'Name: $name';
  }

  @override
  String emailLabel(String email) {
    return 'Email: $email';
  }

  @override
  String phoneLabel(String phone) {
    return 'Phone: $phone';
  }

  @override
  String totalTripsLabel(int count) {
    return 'Total Trips: $count';
  }

  @override
  String get feedbackDetails => 'Feedback Details';

  @override
  String get feedbackType => 'Feedback Type';

  @override
  String get categoryLabel => 'Category';

  @override
  String get ratings => 'Ratings';

  @override
  String get comfort => 'Comfort';

  @override
  String get cleanliness => 'Cleanliness';

  @override
  String get driverBehavior => 'Driver Behavior';

  @override
  String get vehicleCondition => 'Vehicle Condition';

  @override
  String get feedbackContent => 'Feedback Content';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get options => 'Options';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityUrgent => 'Urgent';

  @override
  String get anonymousFeedback => 'Anonymous Feedback';

  @override
  String get anonymousFeedbackSubtitle => 'Your identity will not be shared';

  @override
  String get busFeedback => 'Bus Feedback';

  @override
  String get driverFeedback => 'Driver Feedback';

  @override
  String get shareExperience => 'Share your experience';

  @override
  String get addPhotosVideos => 'Add Photos or Videos (Optional)';

  @override
  String get uploadMediaSubtitle =>
      'Upload images or videos to better explain your feedback (Max 10MB)';

  @override
  String get tapToSelectMedia => 'Tap to select photos or videos';

  @override
  String get mediaFormatNote => 'PNG, JPG, MP4 (Max 10MB)';

  @override
  String get cleanAndComfortable => 'Clean and comfortable';

  @override
  String get goodCondition => 'Good condition';

  @override
  String get acWorksWell => 'Air conditioning works well';

  @override
  String get seatsComfortable => 'Seats are comfortable';

  @override
  String get needsCleaning => 'Bus needs cleaning';

  @override
  String get maintenanceRequired => 'Maintenance required';

  @override
  String get uncomfortableSeats => 'Uncomfortable seats';

  @override
  String get poorVentilation => 'Poor ventilation';

  @override
  String get excellentDriving => 'Excellent driving';

  @override
  String get courteousAndHelpful => 'Courteous and helpful';

  @override
  String get safeDriving => 'Safe driving';

  @override
  String get professionalBehavior => 'Professional behavior';

  @override
  String get recklessDriving => 'Reckless driving';

  @override
  String get unprofessionalBehavior => 'Unprofessional behavior';

  @override
  String get poorCustomerService => 'Poor customer service';

  @override
  String get safetyConcerns => 'Safety concerns';

  @override
  String get locationInformation => 'Location Information';

  @override
  String get locationSubtitle =>
      'Your location helps us understand the context of your feedback';

  @override
  String get gettingLocation => 'Getting your location...';

  @override
  String get locationCaptured => 'Location captured successfully';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get needMoreHelp => 'Need More Help?';

  @override
  String get contactDirectlySubtitle =>
      'For large files or detailed discussions, contact us directly';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get overallExperience => 'How was your overall experience?';

  @override
  String get veryPoor => 'Very Poor';

  @override
  String get average => 'Average';

  @override
  String get feedbackCategory => 'Feedback Category';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categoryDriver => 'Driver';

  @override
  String get categoryBusCondition => 'Bus Condition';

  @override
  String get categorySafety => 'Safety';

  @override
  String get categoryRoute => 'Route';

  @override
  String get categoryService => 'Service';

  @override
  String get feedbackHint => 'Tell us about your experience...';

  @override
  String get feedbackRewardNote =>
      'Your feedback helps us improve our service\n✨ Earn +1 Reward Point!';

  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get feedbackSuccess =>
      '✅ Thank you for your feedback! +1 Reward Point';

  @override
  String feedbackError(String error) {
    return 'Failed to submit feedback: $error';
  }

  @override
  String busNumberLabel(String number) {
    return 'Bus $number';
  }

  @override
  String submittedOn(String date) {
    return 'Submitted: $date';
  }

  @override
  String get rateYourExperience => 'Rate your experience';

  @override
  String get additionalComments => 'Additional Comments';

  @override
  String get shareMoreDetails =>
      'Share more details about your experience (optional)';

  @override
  String get typeFeedbackHint => 'Type your feedback here...';

  @override
  String get feedbackSubmittedTitle => 'Feedback Submitted!';

  @override
  String get feedbackSubmittedSubtitle =>
      'Thank you for your feedback. It helps us improve our service.';

  @override
  String get submissionFailedTitle => 'Submission Failed';

  @override
  String get submissionFailedSubtitle =>
      'Failed to submit feedback. Please try again.';

  @override
  String get uploadingMedia => 'Uploading media files...';

  @override
  String filesSelected(int count) {
    return '$count file(s) selected for upload';
  }

  @override
  String get maxFilesReached => 'Maximum 10 files allowed';

  @override
  String fileExceedsLimit(String fileName) {
    return 'File $fileName exceeds 10MB limit';
  }

  @override
  String mediaUploadFailed(String error) {
    return 'Media upload failed: $error';
  }

  @override
  String pickMediaFailed(String error) {
    return 'Failed to pick media files: $error';
  }

  @override
  String couldNotLaunchUrl(String url) {
    return 'Could not launch $url';
  }

  @override
  String errorLaunchingUrl(String error) {
    return 'Error launching URL: $error';
  }

  @override
  String get busFeedbackLabel => 'Bus Feedback';

  @override
  String get driverFeedbackLabel => 'Driver Feedback';

  @override
  String get rateBusExperience =>
      'How would you rate the overall condition and comfort of the bus?';

  @override
  String get rateDriverExperience =>
      'How would you rate the driver\'s performance and professionalism?';
}

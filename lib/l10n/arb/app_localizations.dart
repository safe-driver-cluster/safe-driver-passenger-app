import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta')
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'SafeDriver Passenger'**
  String get appName;

  /// The tagline of the application
  ///
  /// In en, this message translates to:
  /// **'Your Safety, Our Priority'**
  String get appTagline;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @viewBus.
  ///
  /// In en, this message translates to:
  /// **'View Bus'**
  String get viewBus;

  /// No description provided for @availableBuses.
  ///
  /// In en, this message translates to:
  /// **'Available buses'**
  String get availableBuses;

  /// No description provided for @viewDriverDetails.
  ///
  /// In en, this message translates to:
  /// **'View Driver Details'**
  String get viewDriverDetails;

  /// No description provided for @driverInformation.
  ///
  /// In en, this message translates to:
  /// **'Driver Information'**
  String get driverInformation;

  /// No description provided for @myTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTrips;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @emergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Emergency help'**
  String get emergencyHelp;

  /// No description provided for @noRecentTrips.
  ///
  /// In en, this message translates to:
  /// **'No recent trips'**
  String get noRecentTrips;

  /// No description provided for @startFirstJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your first journey with SafeDriver'**
  String get startFirstJourney;

  /// No description provided for @verifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Account'**
  String get verifyYourAccount;

  /// Message when verification code is sent
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to\n{phoneNumber}'**
  String verificationCodeSent(String phoneNumber);

  /// No description provided for @verifyAndCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify & Create Account'**
  String get verifyAndCreateAccount;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// Timer for resending OTP
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds} s'**
  String resendIn(int seconds);

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhoneNumber;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @accountCreatedAndVerified.
  ///
  /// In en, this message translates to:
  /// **'Account created and verified successfully! Please login with your credentials.'**
  String get accountCreatedAndVerified;

  /// No description provided for @pleaseEnterCompleteOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete OTP'**
  String get pleaseEnterCompleteOtp;

  /// No description provided for @verificationIdNotFound.
  ///
  /// In en, this message translates to:
  /// **'Verification ID not found. Please try again.'**
  String get verificationIdNotFound;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccessfully;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to'**
  String get otpSent;

  /// No description provided for @otpFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP'**
  String get otpFailed;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @emailValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Email validation failed. Please check your email address.'**
  String get emailValidationFailed;

  /// No description provided for @passwordValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Password validation failed. Please try again.'**
  String get passwordValidationFailed;

  /// No description provided for @accountAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get accountAlreadyExists;

  /// No description provided for @resendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOTP;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'OTP expired'**
  String get otpExpired;

  /// No description provided for @invalidOTP.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOTP;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOTP;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @safetyOverview.
  ///
  /// In en, this message translates to:
  /// **'Safety Overview'**
  String get safetyOverview;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @activeJourney.
  ///
  /// In en, this message translates to:
  /// **'Active Journey'**
  String get activeJourney;

  /// No description provided for @noActiveJourney.
  ///
  /// In en, this message translates to:
  /// **'No active journey'**
  String get noActiveJourney;

  /// No description provided for @safetyScore.
  ///
  /// In en, this message translates to:
  /// **'Safety Score'**
  String get safetyScore;

  /// No description provided for @fleetStatus.
  ///
  /// In en, this message translates to:
  /// **'Fleet Status'**
  String get fleetStatus;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @busInformation.
  ///
  /// In en, this message translates to:
  /// **'Bus Information'**
  String get busInformation;

  /// No description provided for @busDetails.
  ///
  /// In en, this message translates to:
  /// **'Bus Details'**
  String get busDetails;

  /// No description provided for @busNumber.
  ///
  /// In en, this message translates to:
  /// **'Bus Number'**
  String get busNumber;

  /// No description provided for @routeNumber.
  ///
  /// In en, this message translates to:
  /// **'Route Number'**
  String get routeNumber;

  /// No description provided for @driverName.
  ///
  /// In en, this message translates to:
  /// **'Driver Name'**
  String get driverName;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @nextStop.
  ///
  /// In en, this message translates to:
  /// **'Next Stop'**
  String get nextStop;

  /// No description provided for @estimatedArrival.
  ///
  /// In en, this message translates to:
  /// **'Estimated Arrival'**
  String get estimatedArrival;

  /// No description provided for @passengerCapacity.
  ///
  /// In en, this message translates to:
  /// **'Passenger Capacity'**
  String get passengerCapacity;

  /// No description provided for @busStatus.
  ///
  /// In en, this message translates to:
  /// **'Bus Status'**
  String get busStatus;

  /// No description provided for @liveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTracking;

  /// No description provided for @trackBus.
  ///
  /// In en, this message translates to:
  /// **'Track Bus'**
  String get trackBus;

  /// No description provided for @busHistory.
  ///
  /// In en, this message translates to:
  /// **'Bus History'**
  String get busHistory;

  /// No description provided for @searchBus.
  ///
  /// In en, this message translates to:
  /// **'Search Bus'**
  String get searchBus;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @driverProfile.
  ///
  /// In en, this message translates to:
  /// **'Driver Profile'**
  String get driverProfile;

  /// No description provided for @driverHistory.
  ///
  /// In en, this message translates to:
  /// **'Driver History'**
  String get driverHistory;

  /// No description provided for @driverPerformance.
  ///
  /// In en, this message translates to:
  /// **'Driver Performance'**
  String get driverPerformance;

  /// No description provided for @driverRating.
  ///
  /// In en, this message translates to:
  /// **'Driver Rating'**
  String get driverRating;

  /// No description provided for @driverExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get driverExperience;

  /// No description provided for @driverLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get driverLicense;

  /// No description provided for @driverCertifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get driverCertifications;

  /// No description provided for @driverContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get driverContact;

  /// No description provided for @driverStatus.
  ///
  /// In en, this message translates to:
  /// **'Driver Status'**
  String get driverStatus;

  /// No description provided for @alertnessLevel.
  ///
  /// In en, this message translates to:
  /// **'Alertness Level'**
  String get alertnessLevel;

  /// No description provided for @safety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safety;

  /// No description provided for @safetyAlerts.
  ///
  /// In en, this message translates to:
  /// **'Safety Alerts'**
  String get safetyAlerts;

  /// No description provided for @emergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alert'**
  String get emergencyAlert;

  /// No description provided for @hazardZones.
  ///
  /// In en, this message translates to:
  /// **'Hazard Zones'**
  String get hazardZones;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @callEmergency.
  ///
  /// In en, this message translates to:
  /// **'Call Emergency'**
  String get callEmergency;

  /// No description provided for @reportIncident.
  ///
  /// In en, this message translates to:
  /// **'Report incident'**
  String get reportIncident;

  /// No description provided for @safetyTips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTips;

  /// No description provided for @weatherWarning.
  ///
  /// In en, this message translates to:
  /// **'Weather Warning'**
  String get weatherWarning;

  /// No description provided for @roadConditions.
  ///
  /// In en, this message translates to:
  /// **'Road Conditions'**
  String get roadConditions;

  /// No description provided for @trafficAlert.
  ///
  /// In en, this message translates to:
  /// **'Traffic Alert'**
  String get trafficAlert;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @feedbackHistory.
  ///
  /// In en, this message translates to:
  /// **'Feedback History'**
  String get feedbackHistory;

  /// No description provided for @rateBus.
  ///
  /// In en, this message translates to:
  /// **'Rate Bus'**
  String get rateBus;

  /// No description provided for @rateDriver.
  ///
  /// In en, this message translates to:
  /// **'Rate Driver'**
  String get rateDriver;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report Problem'**
  String get reportProblem;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @complaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get complaint;

  /// No description provided for @compliment.
  ///
  /// In en, this message translates to:
  /// **'Compliment'**
  String get compliment;

  /// No description provided for @feedbackSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully'**
  String get feedbackSubmitted;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @autoMode.
  ///
  /// In en, this message translates to:
  /// **'Auto Mode'**
  String get autoMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noAccountFoundPhone.
  ///
  /// In en, this message translates to:
  /// **'No account found with this phone number.'**
  String get noAccountFoundPhone;

  /// No description provided for @enterPhoneResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we will send you\na code to reset your password'**
  String get enterPhoneResetPassword;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @pleaseEnterComplete6DigitOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit OTP'**
  String get pleaseEnterComplete6DigitOtp;

  /// No description provided for @invalidOtpTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtpTryAgain;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @passwordResetSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successful'**
  String get passwordResetSuccessful;

  /// No description provided for @passwordResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully. You can now sign in with your new password.'**
  String get passwordResetSuccessMessage;

  /// No description provided for @goToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Go to Sign In'**
  String get goToSignIn;

  /// No description provided for @passwordResetSuccessLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful. Please sign in with your new password.'**
  String get passwordResetSuccessLoginMessage;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements:'**
  String get passwordRequirements;

  /// No description provided for @passwordReq1.
  ///
  /// In en, this message translates to:
  /// **'• At least 8 characters long'**
  String get passwordReq1;

  /// No description provided for @passwordReq2.
  ///
  /// In en, this message translates to:
  /// **'• Contains uppercase and lowercase letters'**
  String get passwordReq2;

  /// No description provided for @passwordReq3.
  ///
  /// In en, this message translates to:
  /// **'• Contains at least one number'**
  String get passwordReq3;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @verifyYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Phone'**
  String get verifyYourPhone;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @type6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Type the 6-digit code we sent you'**
  String get type6DigitCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// Message when OTP is sent successfully to a phone number
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully to {phoneNumber}'**
  String otpSentTo(String phoneNumber);

  /// No description provided for @createStrongNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a strong new password\nfor your account'**
  String get createStrongNewPassword;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterYourPhoneNumber;

  /// No description provided for @sendVerificationCodeViaSMS.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a verification code via SMS'**
  String get sendVerificationCodeViaSMS;

  /// No description provided for @enterSriLankanMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your Sri Lankan mobile number'**
  String get enterSriLankanMobile;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @smsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to receive SMS messages from SafeDriver for verification purposes. Message and data rates may apply.'**
  String get smsAgreement;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'77 123 4567'**
  String get phoneHint;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @emailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Email & Password'**
  String get emailAndPassword;

  /// No description provided for @invalidSriLankanPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Sri Lankan phone number'**
  String get invalidSriLankanPhone;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @preferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// No description provided for @manageSosContacts.
  ///
  /// In en, this message translates to:
  /// **'Manage SOS contacts for emergency alerts'**
  String get manageSosContacts;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// Error message when image selection fails
  ///
  /// In en, this message translates to:
  /// **'Error selecting image: {error}'**
  String errorSelectingImage(String error);

  /// Error message when profile saving fails
  ///
  /// In en, this message translates to:
  /// **'Error saving profile: {error}'**
  String errorSavingProfile(String error);

  /// Error message when profile loading fails
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String errorLoadingProfile(String error);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connectionTimeout;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @dataMissing.
  ///
  /// In en, this message translates to:
  /// **'Data missing'**
  String get dataMissing;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get tryAgainLater;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @operationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Operation successful'**
  String get operationSuccessful;

  /// No description provided for @dataSaved.
  ///
  /// In en, this message translates to:
  /// **'Data saved successfully'**
  String get dataSaved;

  /// No description provided for @dataUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully'**
  String get dataUpdated;

  /// No description provided for @dataDeleted.
  ///
  /// In en, this message translates to:
  /// **'Data deleted successfully'**
  String get dataDeleted;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noBuses.
  ///
  /// In en, this message translates to:
  /// **'No buses found'**
  String get noBuses;

  /// No description provided for @noDrivers.
  ///
  /// In en, this message translates to:
  /// **'No drivers found'**
  String get noDrivers;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history available'**
  String get noHistory;

  /// No description provided for @noFeedback.
  ///
  /// In en, this message translates to:
  /// **'No feedback submitted'**
  String get noFeedback;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No active alerts'**
  String get noAlerts;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @firstNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'First name must be at least 2 characters'**
  String get firstNameMinLength;

  /// No description provided for @lastNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Last name must be at least 2 characters'**
  String get lastNameMinLength;

  /// No description provided for @passwordComplexity.
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase, and number'**
  String get passwordComplexity;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions'**
  String get acceptTerms;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SafeDriver'**
  String get welcomeTitle;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Safe & Reliable Transport'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Description.
  ///
  /// In en, this message translates to:
  /// **'Experience the most secure and dependable transportation service. Your safety is our top priority with professionally trained drivers.'**
  String get onboarding1Description;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Tracking'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Description.
  ///
  /// In en, this message translates to:
  /// **'Track your ride in real-time and stay connected with live location updates. Know exactly where your ride is at every moment.'**
  String get onboarding2Description;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Feedback System'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Description.
  ///
  /// In en, this message translates to:
  /// **'Share your experience and help us maintain the highest service standards. Your feedback makes every journey better.'**
  String get onboarding3Description;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get police;

  /// No description provided for @medical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get medical;

  /// No description provided for @fire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fire;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// No description provided for @emergencyHotline.
  ///
  /// In en, this message translates to:
  /// **'Emergency Hotline'**
  String get emergencyHotline;

  /// No description provided for @policeStation.
  ///
  /// In en, this message translates to:
  /// **'Police Station'**
  String get policeStation;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @fireStation.
  ///
  /// In en, this message translates to:
  /// **'Fire Station'**
  String get fireStation;

  /// No description provided for @alwaysWearSeatbelt.
  ///
  /// In en, this message translates to:
  /// **'Always wear your seatbelt'**
  String get alwaysWearSeatbelt;

  /// No description provided for @stayAlert.
  ///
  /// In en, this message translates to:
  /// **'Stay alert and aware of your surroundings'**
  String get stayAlert;

  /// No description provided for @keepEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Keep emergency contacts readily available'**
  String get keepEmergencyContacts;

  /// No description provided for @reportSuspiciousActivity.
  ///
  /// In en, this message translates to:
  /// **'Report any suspicious activity immediately'**
  String get reportSuspiciousActivity;

  /// No description provided for @followBusSafety.
  ///
  /// In en, this message translates to:
  /// **'Follow bus safety protocols and driver instructions'**
  String get followBusSafety;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @bookTicket.
  ///
  /// In en, this message translates to:
  /// **'Book Ticket'**
  String get bookTicket;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @trackLive.
  ///
  /// In en, this message translates to:
  /// **'Track Live'**
  String get trackLive;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareFunctionality.
  ///
  /// In en, this message translates to:
  /// **'Share functionality will be implemented'**
  String get shareFunctionality;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @sinhala.
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get sinhala;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get tamil;

  /// Shows who reported something
  ///
  /// In en, this message translates to:
  /// **'Reported by: {name}'**
  String reportedBy(String name);

  /// Shows bus ID
  ///
  /// In en, this message translates to:
  /// **'Bus ID: {busId}'**
  String busIdLabel(String busId);

  /// Shows driver ID
  ///
  /// In en, this message translates to:
  /// **'Driver ID: {driverId}'**
  String driverIdLabel(String driverId);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get acknowledge;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @scanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQR;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @safetyTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTipsTitle;

  /// No description provided for @safetyHub.
  ///
  /// In en, this message translates to:
  /// **'Safety Hub'**
  String get safetyHub;

  /// No description provided for @reportSafetyIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Safety Issue'**
  String get reportSafetyIssue;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @safetyAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Alerts'**
  String get safetyAlertsTitle;

  /// No description provided for @reportIncidentTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Incident'**
  String get reportIncidentTitle;

  /// No description provided for @hazardZonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Hazard Zones'**
  String get hazardZonesTitle;

  /// No description provided for @emergencyContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContactsTitle;

  /// No description provided for @enterCodeManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Code Manually'**
  String get enterCodeManually;

  /// Message when QR code is detected
  ///
  /// In en, this message translates to:
  /// **'QR Code detected: {code}'**
  String qrCodeDetected(String code);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @areYouSureSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureSignOut;

  /// No description provided for @tripHistory.
  ///
  /// In en, this message translates to:
  /// **'Trip History'**
  String get tripHistory;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// Trip details title with ID
  ///
  /// In en, this message translates to:
  /// **'Trip {id}'**
  String tripDetails(String id);

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get giveFeedback;

  /// No description provided for @comingSoonFeature.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available in a future update.'**
  String get comingSoonFeature;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @cacheClearedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully!'**
  String get cacheClearedSuccessfully;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// Profile update failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String failedToUpdateProfile(String error);

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @noProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No profile found'**
  String get noProfileFound;

  /// No description provided for @viewFAQ.
  ///
  /// In en, this message translates to:
  /// **'View FAQ'**
  String get viewFAQ;

  /// No description provided for @changePicture.
  ///
  /// In en, this message translates to:
  /// **'Change Picture'**
  String get changePicture;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// No description provided for @searchFunctionalityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Search functionality coming soon!'**
  String get searchFunctionalityComingSoon;

  /// No description provided for @busRoutesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Bus routes coming soon!'**
  String get busRoutesComingSoon;

  /// No description provided for @navigationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Navigation coming soon!'**
  String get navigationComingSoon;

  /// Selection message
  ///
  /// In en, this message translates to:
  /// **'Selected: {description}'**
  String selected(String description);

  /// Place lookup error message
  ///
  /// In en, this message translates to:
  /// **'Place lookup failed: {error}'**
  String placeLookupFailed(String error);

  /// Bus stops found message
  ///
  /// In en, this message translates to:
  /// **'Found {count} bus stops nearby'**
  String foundBusStopsNearby(int count);

  /// Search result navigation message
  ///
  /// In en, this message translates to:
  /// **'Found \"{query}\". Tap Navigate to see bus route!'**
  String foundQueryTapNavigate(String query);

  /// Search failure message
  ///
  /// In en, this message translates to:
  /// **'Search failed: {error}'**
  String searchFailed(String error);

  /// No description provided for @unableToGetCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to get current location'**
  String get unableToGetCurrentLocation;

  /// No description provided for @pleaseSearchForDestination.
  ///
  /// In en, this message translates to:
  /// **'Please search for a destination first'**
  String get pleaseSearchForDestination;

  /// Language selection error
  ///
  /// In en, this message translates to:
  /// **'Error selecting language: {error}'**
  String errorSelectingLanguage(String error);

  /// No description provided for @hazardZoneIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Hazard Zone Intelligence'**
  String get hazardZoneIntelligence;

  /// No description provided for @loadingHazardZoneData.
  ///
  /// In en, this message translates to:
  /// **'Loading hazard zone data...'**
  String get loadingHazardZoneData;

  /// No description provided for @driverIdRequiredForAlerts.
  ///
  /// In en, this message translates to:
  /// **'Driver ID required to view alerts'**
  String get driverIdRequiredForAlerts;

  /// No description provided for @noActiveHazardAlerts.
  ///
  /// In en, this message translates to:
  /// **'No active hazard alerts'**
  String get noActiveHazardAlerts;

  /// No description provided for @reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @addMedia.
  ///
  /// In en, this message translates to:
  /// **'Add Media'**
  String get addMedia;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// File size error message
  ///
  /// In en, this message translates to:
  /// **'{fileName} is too large. Maximum size is 10MB.'**
  String fileTooLarge(String fileName);

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to share location'**
  String get locationPermissionRequired;

  /// Location error message
  ///
  /// In en, this message translates to:
  /// **'Failed to get location: {error}'**
  String failedToGetLocation(String error);

  /// No description provided for @incidentReportingImplemented.
  ///
  /// In en, this message translates to:
  /// **'Incident reporting will be implemented'**
  String get incidentReportingImplemented;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @submitAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Submit anonymously'**
  String get submitAnonymously;

  /// No description provided for @personalInfoNotShared.
  ///
  /// In en, this message translates to:
  /// **'Your personal information will not be shared'**
  String get personalInfoNotShared;

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseYourLanguage;

  /// No description provided for @selectYourPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language to continue'**
  String get selectYourPreferredLanguage;

  /// No description provided for @availableLanguages.
  ///
  /// In en, this message translates to:
  /// **'Available Languages'**
  String get availableLanguages;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @profilePageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Profile Page - Coming Soon'**
  String get profilePageComingSoon;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @addressInformation.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get addressInformation;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera Error'**
  String get cameraError;

  /// No description provided for @positionQrCode.
  ///
  /// In en, this message translates to:
  /// **'Position QR code here'**
  String get positionQrCode;

  /// No description provided for @qrScanner.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner'**
  String get qrScanner;

  /// No description provided for @scanQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code on bus or stop'**
  String get scanQrInstruction;

  /// No description provided for @alignQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold steady and align QR code within the frame'**
  String get alignQrInstruction;

  /// No description provided for @enterBusStopCode.
  ///
  /// In en, this message translates to:
  /// **'Enter bus or stop code'**
  String get enterBusStopCode;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @mapsNavigation.
  ///
  /// In en, this message translates to:
  /// **'Maps & Navigation'**
  String get mapsNavigation;

  /// No description provided for @searchDestination.
  ///
  /// In en, this message translates to:
  /// **'Search for destination...'**
  String get searchDestination;

  /// No description provided for @busStop.
  ///
  /// In en, this message translates to:
  /// **'Bus Stop'**
  String get busStop;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get yourLocation;

  /// No description provided for @currentPosition.
  ///
  /// In en, this message translates to:
  /// **'Current position'**
  String get currentPosition;

  /// No description provided for @unableToLoadMap.
  ///
  /// In en, this message translates to:
  /// **'Unable to load map'**
  String get unableToLoadMap;

  /// No description provided for @loadingMap.
  ///
  /// In en, this message translates to:
  /// **'Loading map...'**
  String get loadingMap;

  /// No description provided for @busRouteToDestination.
  ///
  /// In en, this message translates to:
  /// **'Bus Route to Destination'**
  String get busRouteToDestination;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Message when language is changed
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChanged(String language);

  /// Error message when language change fails
  ///
  /// In en, this message translates to:
  /// **'Failed to change language: {error}'**
  String failedToChangeLanguage(String error);

  /// Shows trip ID
  ///
  /// In en, this message translates to:
  /// **'Trip ID: {tripId}'**
  String tripId(String tripId);

  /// No description provided for @safetyFirst.
  ///
  /// In en, this message translates to:
  /// **'Safety First'**
  String get safetyFirst;

  /// No description provided for @safetyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your safety is our top priority. Access emergency features, report incidents, and stay informed about safety measures.'**
  String get safetyDescription;

  /// No description provided for @emergencyActions.
  ///
  /// In en, this message translates to:
  /// **'Emergency Actions'**
  String get emergencyActions;

  /// No description provided for @callForHelp.
  ///
  /// In en, this message translates to:
  /// **'Call for help'**
  String get callForHelp;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @safetyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Safety Features'**
  String get safetyFeatures;

  /// No description provided for @realTimeSafetyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Real-time safety notifications'**
  String get realTimeSafetyNotifications;

  /// No description provided for @viewKnownHazardousAreas.
  ///
  /// In en, this message translates to:
  /// **'View known hazardous areas'**
  String get viewKnownHazardousAreas;

  /// No description provided for @learnSafetyBestPractices.
  ///
  /// In en, this message translates to:
  /// **'Learn safety best practices'**
  String get learnSafetyBestPractices;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @reportSafetyDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Would you like to report a safety incident or concern?'**
  String get reportSafetyDialogContent;

  /// No description provided for @safetyTip1.
  ///
  /// In en, this message translates to:
  /// **'• Always wear your seatbelt'**
  String get safetyTip1;

  /// No description provided for @safetyTip2.
  ///
  /// In en, this message translates to:
  /// **'• Stay alert and aware of your surroundings'**
  String get safetyTip2;

  /// No description provided for @safetyTip3.
  ///
  /// In en, this message translates to:
  /// **'• Keep emergency contacts readily available'**
  String get safetyTip3;

  /// No description provided for @safetyTip4.
  ///
  /// In en, this message translates to:
  /// **'• Report any suspicious activity immediately'**
  String get safetyTip4;

  /// No description provided for @safetyTip5.
  ///
  /// In en, this message translates to:
  /// **'• Follow bus safety protocols and driver instructions'**
  String get safetyTip5;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeTo;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorOccurredGeneric(String error);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get goodNight;

  /// No description provided for @traveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get traveler;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @activeBuses.
  ///
  /// In en, this message translates to:
  /// **'Active Buses'**
  String get activeBuses;

  /// No description provided for @activeBusesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active Buses'**
  String activeBusesCount(Object count);

  /// No description provided for @safetyScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Safety Score: {score}%'**
  String safetyScoreLabel(Object score);

  /// No description provided for @driversCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Drivers'**
  String driversCount(Object count);

  /// No description provided for @hazardZonesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Hazard Zones'**
  String hazardZonesCount(Object count);

  /// No description provided for @busQrScanned.
  ///
  /// In en, this message translates to:
  /// **'Bus QR code scanned'**
  String get busQrScanned;

  /// No description provided for @safetyAlertAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Safety alert acknowledged'**
  String get safetyAlertAcknowledged;

  /// No description provided for @newHazardZoneReported.
  ///
  /// In en, this message translates to:
  /// **'New hazard zone reported'**
  String get newHazardZoneReported;

  /// No description provided for @timeAgo.
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String timeAgo(Object time);

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by SafeDriver Technologies'**
  String get poweredBy;

  /// No description provided for @addSosContact.
  ///
  /// In en, this message translates to:
  /// **'Add SOS Contact'**
  String get addSosContact;

  /// No description provided for @editSosContact.
  ///
  /// In en, this message translates to:
  /// **'Edit SOS Contact'**
  String get editSosContact;

  /// No description provided for @removeSosContact.
  ///
  /// In en, this message translates to:
  /// **'Remove SOS Contact'**
  String get removeSosContact;

  /// No description provided for @areYouSureRemoveContact.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from your SOS contacts?'**
  String areYouSureRemoveContact(Object name);

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactNameLabel;

  /// No description provided for @contactNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Mom, Dad, Spouse'**
  String get contactNameHint;

  /// No description provided for @relationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationshipLabel;

  /// No description provided for @relationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Parent, Friend'**
  String get relationshipHint;

  /// No description provided for @alertMethods.
  ///
  /// In en, this message translates to:
  /// **'Alert Methods'**
  String get alertMethods;

  /// No description provided for @autoSendSos.
  ///
  /// In en, this message translates to:
  /// **'Auto-Send SOS'**
  String get autoSendSos;

  /// No description provided for @autoSendSosDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically send alerts to all contacts'**
  String get autoSendSosDescription;

  /// No description provided for @sosContactsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add trusted contacts who will receive your SOS alerts via SMS and WhatsApp with your live location.'**
  String get sosContactsDescription;

  /// No description provided for @noSosContactsYet.
  ///
  /// In en, this message translates to:
  /// **'No SOS Contacts Yet'**
  String get noSosContactsYet;

  /// No description provided for @addYourFirstContact.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Contact'**
  String get addYourFirstContact;

  /// No description provided for @mySosContacts.
  ///
  /// In en, this message translates to:
  /// **'My SOS Contacts'**
  String get mySosContacts;

  /// No description provided for @sosContactsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} contacts'**
  String sosContactsCount(Object count);

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @onDuty.
  ///
  /// In en, this message translates to:
  /// **'On Duty'**
  String get onDuty;

  /// No description provided for @offDuty.
  ///
  /// In en, this message translates to:
  /// **'Off Duty'**
  String get offDuty;

  /// No description provided for @onBreak.
  ///
  /// In en, this message translates to:
  /// **'On Break'**
  String get onBreak;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @experienceYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String experienceYears(Object years);

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @searchBusesHint.
  ///
  /// In en, this message translates to:
  /// **'Search by bus number, route, driver...'**
  String get searchBusesHint;

  /// No description provided for @searchDriversHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, license, route...'**
  String get searchDriversHint;

  /// No description provided for @searchPlacesHint.
  ///
  /// In en, this message translates to:
  /// **'Search for places, bus stops...'**
  String get searchPlacesHint;

  /// No description provided for @noBusesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No buses available'**
  String get noBusesAvailable;

  /// No description provided for @checkBackLaterBuses.
  ///
  /// In en, this message translates to:
  /// **'Check back later for available buses'**
  String get checkBackLaterBuses;

  /// No description provided for @noMatchingDrivers.
  ///
  /// In en, this message translates to:
  /// **'No matching drivers'**
  String get noMatchingDrivers;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable location services.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Please grant location access.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied. Please enable them in settings.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @noMatchingLocations.
  ///
  /// In en, this message translates to:
  /// **'No matching locations found'**
  String get noMatchingLocations;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @boardBus.
  ///
  /// In en, this message translates to:
  /// **'Board bus'**
  String get boardBus;

  /// No description provided for @leaveBus.
  ///
  /// In en, this message translates to:
  /// **'Leave bus'**
  String get leaveBus;

  /// No description provided for @googleBusDirectionsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google bus directions unavailable. Showing estimated road route.'**
  String get googleBusDirectionsUnavailable;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @avgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Avg speed'**
  String get avgSpeed;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get zoomOut;

  /// No description provided for @toggleMapType.
  ///
  /// In en, this message translates to:
  /// **'Toggle Map Type'**
  String get toggleMapType;

  /// No description provided for @toggleTraffic.
  ///
  /// In en, this message translates to:
  /// **'Toggle Traffic'**
  String get toggleTraffic;

  /// No description provided for @centerOnLocation.
  ///
  /// In en, this message translates to:
  /// **'Center on Location'**
  String get centerOnLocation;

  /// No description provided for @stopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stops'**
  String stopsCount(Object count);

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @healthRecord.
  ///
  /// In en, this message translates to:
  /// **'Health Record'**
  String get healthRecord;

  /// No description provided for @lastMedicalCheck.
  ///
  /// In en, this message translates to:
  /// **'Last Medical Check'**
  String get lastMedicalCheck;

  /// No description provided for @medicalStatus.
  ///
  /// In en, this message translates to:
  /// **'Medical Status'**
  String get medicalStatus;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @healthIssues.
  ///
  /// In en, this message translates to:
  /// **'Health Issues'**
  String get healthIssues;

  /// No description provided for @medicalExamDue.
  ///
  /// In en, this message translates to:
  /// **'Medical Exam Due'**
  String get medicalExamDue;

  /// No description provided for @medicalConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical Conditions'**
  String get medicalConditions;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @performanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Performance Overview'**
  String get performanceOverview;

  /// No description provided for @totalTrips.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get totalTrips;

  /// No description provided for @totalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get totalDistance;

  /// No description provided for @punctuality.
  ///
  /// In en, this message translates to:
  /// **'Punctuality'**
  String get punctuality;

  /// No description provided for @fuelEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Fuel Efficiency'**
  String get fuelEfficiency;

  /// No description provided for @routeSpecializations.
  ///
  /// In en, this message translates to:
  /// **'Route Specializations'**
  String get routeSpecializations;

  /// No description provided for @trainingHistory.
  ///
  /// In en, this message translates to:
  /// **'Training History'**
  String get trainingHistory;

  /// No description provided for @noTrainingRecords.
  ///
  /// In en, this message translates to:
  /// **'No training records available'**
  String get noTrainingRecords;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// No description provided for @currentBus.
  ///
  /// In en, this message translates to:
  /// **'Current Bus'**
  String get currentBus;

  /// No description provided for @currentRoute.
  ///
  /// In en, this message translates to:
  /// **'Current Route'**
  String get currentRoute;

  /// No description provided for @alertness.
  ///
  /// In en, this message translates to:
  /// **'Alertness'**
  String get alertness;

  /// No description provided for @mainFeatures.
  ///
  /// In en, this message translates to:
  /// **'Main Features'**
  String get mainFeatures;

  /// No description provided for @qrScannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan bus QR codes to get instant information'**
  String get qrScannerDescription;

  /// No description provided for @liveTrackingDescription.
  ///
  /// In en, this message translates to:
  /// **'Real-time bus location tracking with maps'**
  String get liveTrackingDescription;

  /// No description provided for @driverInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed driver information and performance'**
  String get driverInfoDescription;

  /// No description provided for @hazardZonesDescription.
  ///
  /// In en, this message translates to:
  /// **'Monitor dangerous areas and safety alerts'**
  String get hazardZonesDescription;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Your comprehensive bus safety monitoring platform'**
  String get appDescription;

  /// No description provided for @driverInfo.
  ///
  /// In en, this message translates to:
  /// **'Driver Info'**
  String get driverInfo;

  /// No description provided for @drivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get drivers;

  /// No description provided for @verifiedMember.
  ///
  /// In en, this message translates to:
  /// **'Verified Member'**
  String get verifiedMember;

  /// No description provided for @updateInfo.
  ///
  /// In en, this message translates to:
  /// **'Update info'**
  String get updateInfo;

  /// No description provided for @viewTrips.
  ///
  /// In en, this message translates to:
  /// **'View trips'**
  String get viewTrips;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get yourFeedback;

  /// No description provided for @getHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get getHelp;

  /// No description provided for @accountAndSettings.
  ///
  /// In en, this message translates to:
  /// **'Account & Settings'**
  String get accountAndSettings;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @unableToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get unableToLoadProfile;

  /// No description provided for @shareFeedback.
  ///
  /// In en, this message translates to:
  /// **'Share Feedback'**
  String get shareFeedback;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve your experience'**
  String get feedbackSubtitle;

  /// No description provided for @tripInformation.
  ///
  /// In en, this message translates to:
  /// **'Trip Information'**
  String get tripInformation;

  /// No description provided for @busIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Bus ID'**
  String get busIdTitle;

  /// No description provided for @tripIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip ID'**
  String get tripIdTitle;

  /// No description provided for @rateExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get rateExperience;

  /// No description provided for @noFeedbackYet.
  ///
  /// In en, this message translates to:
  /// **'No Feedback Yet'**
  String get noFeedbackYet;

  /// No description provided for @noFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback about buses and drivers to get started'**
  String get noFeedbackSubtitle;

  /// Label for bus with number
  ///
  /// In en, this message translates to:
  /// **'Bus {busNumber}'**
  String busLabel(String busNumber);

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @statusReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get statusReviewed;

  /// No description provided for @statusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get statusResolved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @commentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentLabel;

  /// Label for submission date
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String submittedDateLabel(String date);

  /// No description provided for @feedbackHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track all your feedback submissions'**
  String get feedbackHistorySubtitle;

  /// No description provided for @typePositive.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get typePositive;

  /// No description provided for @typeNegative.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get typeNegative;

  /// No description provided for @typeNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get typeNeutral;

  /// No description provided for @typeSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get typeSuggestion;

  /// No description provided for @typeInquiry.
  ///
  /// In en, this message translates to:
  /// **'Inquiry'**
  String get typeInquiry;

  /// No description provided for @typeUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get typeUrgent;

  /// No description provided for @typeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get typeGeneral;

  /// No description provided for @categoryComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get categoryComfort;

  /// No description provided for @categoryVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get categoryVehicle;

  /// Success message after submitting feedback
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully! ID: {id}'**
  String feedbackSuccessWithId(String id);

  /// Error message when feedback submission fails
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback: {error}'**
  String feedbackFailed(String error);

  /// No description provided for @failedToLoadPassenger.
  ///
  /// In en, this message translates to:
  /// **'Failed to load passenger data'**
  String get failedToLoadPassenger;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @noPassengerProfile.
  ///
  /// In en, this message translates to:
  /// **'No passenger profile found'**
  String get noPassengerProfile;

  /// No description provided for @passengerInformation.
  ///
  /// In en, this message translates to:
  /// **'Passenger Information'**
  String get passengerInformation;

  /// No description provided for @submitFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience and help us improve'**
  String get submitFeedbackSubtitle;

  /// Label for passenger name
  ///
  /// In en, this message translates to:
  /// **'Name: {name}'**
  String nameLabel(String name);

  /// Label for passenger email
  ///
  /// In en, this message translates to:
  /// **'Email: {email}'**
  String emailLabel(String email);

  /// Label for passenger phone
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String phoneLabel(String phone);

  /// Label for total trips count
  ///
  /// In en, this message translates to:
  /// **'Total Trips: {count}'**
  String totalTripsLabel(int count);

  /// No description provided for @feedbackDetails.
  ///
  /// In en, this message translates to:
  /// **'Feedback Details'**
  String get feedbackDetails;

  /// No description provided for @feedbackType.
  ///
  /// In en, this message translates to:
  /// **'Feedback Type'**
  String get feedbackType;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @comfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get comfort;

  /// No description provided for @cleanliness.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness'**
  String get cleanliness;

  /// No description provided for @driverBehavior.
  ///
  /// In en, this message translates to:
  /// **'Driver Behavior'**
  String get driverBehavior;

  /// No description provided for @vehicleCondition.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Condition'**
  String get vehicleCondition;

  /// No description provided for @feedbackContent.
  ///
  /// In en, this message translates to:
  /// **'Feedback Content'**
  String get feedbackContent;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priorityUrgent;

  /// No description provided for @anonymousFeedback.
  ///
  /// In en, this message translates to:
  /// **'Anonymous Feedback'**
  String get anonymousFeedback;

  /// No description provided for @anonymousFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your identity will not be shared'**
  String get anonymousFeedbackSubtitle;

  /// No description provided for @busFeedback.
  ///
  /// In en, this message translates to:
  /// **'Bus Feedback'**
  String get busFeedback;

  /// No description provided for @driverFeedback.
  ///
  /// In en, this message translates to:
  /// **'Driver Feedback'**
  String get driverFeedback;

  /// No description provided for @shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get shareExperience;

  /// No description provided for @addPhotosVideos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos or Videos (Optional)'**
  String get addPhotosVideos;

  /// No description provided for @uploadMediaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload images or videos to better explain your feedback (Max 10MB)'**
  String get uploadMediaSubtitle;

  /// No description provided for @tapToSelectMedia.
  ///
  /// In en, this message translates to:
  /// **'Tap to select photos or videos'**
  String get tapToSelectMedia;

  /// No description provided for @mediaFormatNote.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPG, MP4 (Max 10MB)'**
  String get mediaFormatNote;

  /// No description provided for @cleanAndComfortable.
  ///
  /// In en, this message translates to:
  /// **'Clean and comfortable'**
  String get cleanAndComfortable;

  /// No description provided for @goodCondition.
  ///
  /// In en, this message translates to:
  /// **'Good condition'**
  String get goodCondition;

  /// No description provided for @acWorksWell.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning works well'**
  String get acWorksWell;

  /// No description provided for @seatsComfortable.
  ///
  /// In en, this message translates to:
  /// **'Seats are comfortable'**
  String get seatsComfortable;

  /// No description provided for @needsCleaning.
  ///
  /// In en, this message translates to:
  /// **'Bus needs cleaning'**
  String get needsCleaning;

  /// No description provided for @maintenanceRequired.
  ///
  /// In en, this message translates to:
  /// **'Maintenance required'**
  String get maintenanceRequired;

  /// No description provided for @uncomfortableSeats.
  ///
  /// In en, this message translates to:
  /// **'Uncomfortable seats'**
  String get uncomfortableSeats;

  /// No description provided for @poorVentilation.
  ///
  /// In en, this message translates to:
  /// **'Poor ventilation'**
  String get poorVentilation;

  /// No description provided for @excellentDriving.
  ///
  /// In en, this message translates to:
  /// **'Excellent driving'**
  String get excellentDriving;

  /// No description provided for @courteousAndHelpful.
  ///
  /// In en, this message translates to:
  /// **'Courteous and helpful'**
  String get courteousAndHelpful;

  /// No description provided for @safeDriving.
  ///
  /// In en, this message translates to:
  /// **'Safe driving'**
  String get safeDriving;

  /// No description provided for @professionalBehavior.
  ///
  /// In en, this message translates to:
  /// **'Professional behavior'**
  String get professionalBehavior;

  /// No description provided for @recklessDriving.
  ///
  /// In en, this message translates to:
  /// **'Reckless driving'**
  String get recklessDriving;

  /// No description provided for @unprofessionalBehavior.
  ///
  /// In en, this message translates to:
  /// **'Unprofessional behavior'**
  String get unprofessionalBehavior;

  /// No description provided for @poorCustomerService.
  ///
  /// In en, this message translates to:
  /// **'Poor customer service'**
  String get poorCustomerService;

  /// No description provided for @safetyConcerns.
  ///
  /// In en, this message translates to:
  /// **'Safety concerns'**
  String get safetyConcerns;

  /// No description provided for @locationInformation.
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get locationInformation;

  /// No description provided for @locationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your location helps us understand the context of your feedback'**
  String get locationSubtitle;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get gettingLocation;

  /// No description provided for @locationCaptured.
  ///
  /// In en, this message translates to:
  /// **'Location captured successfully'**
  String get locationCaptured;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get locationNotAvailable;

  /// No description provided for @needMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Need More Help?'**
  String get needMoreHelp;

  /// No description provided for @contactDirectlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'For large files or detailed discussions, contact us directly'**
  String get contactDirectlySubtitle;

  /// No description provided for @whatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// No description provided for @overallExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your overall experience?'**
  String get overallExperience;

  /// No description provided for @veryPoor.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get veryPoor;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @feedbackCategory.
  ///
  /// In en, this message translates to:
  /// **'Feedback Category'**
  String get feedbackCategory;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneral;

  /// No description provided for @categoryDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get categoryDriver;

  /// No description provided for @categoryBusCondition.
  ///
  /// In en, this message translates to:
  /// **'Bus Condition'**
  String get categoryBusCondition;

  /// No description provided for @categorySafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get categorySafety;

  /// No description provided for @categoryRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get categoryRoute;

  /// No description provided for @categoryService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get categoryService;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience...'**
  String get feedbackHint;

  /// No description provided for @feedbackRewardNote.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve our service\n✨ Earn +1 Reward Point!'**
  String get feedbackRewardNote;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// No description provided for @feedbackSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Thank you for your feedback! +1 Reward Point'**
  String get feedbackSuccess;

  /// No description provided for @feedbackError.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback: {error}'**
  String feedbackError(String error);

  /// No description provided for @busNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Bus {number}'**
  String busNumberLabel(String number);

  /// No description provided for @submittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String submittedOn(String date);

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rateYourExperience;

  /// No description provided for @additionalComments.
  ///
  /// In en, this message translates to:
  /// **'Additional Comments'**
  String get additionalComments;

  /// No description provided for @shareMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Share more details about your experience (optional)'**
  String get shareMoreDetails;

  /// No description provided for @typeFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Type your feedback here...'**
  String get typeFeedbackHint;

  /// No description provided for @feedbackSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback Submitted!'**
  String get feedbackSubmittedTitle;

  /// No description provided for @feedbackSubmittedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback. It helps us improve our service.'**
  String get feedbackSubmittedSubtitle;

  /// No description provided for @submissionFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Submission Failed'**
  String get submissionFailedTitle;

  /// No description provided for @submissionFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback. Please try again.'**
  String get submissionFailedSubtitle;

  /// No description provided for @uploadingMedia.
  ///
  /// In en, this message translates to:
  /// **'Uploading media files...'**
  String get uploadingMedia;

  /// No description provided for @filesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s) selected for upload'**
  String filesSelected(int count);

  /// No description provided for @maxFilesReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 files allowed'**
  String get maxFilesReached;

  /// No description provided for @fileExceedsLimit.
  ///
  /// In en, this message translates to:
  /// **'File {fileName} exceeds 10MB limit'**
  String fileExceedsLimit(String fileName);

  /// No description provided for @mediaUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Media upload failed: {error}'**
  String mediaUploadFailed(String error);

  /// No description provided for @pickMediaFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick media files: {error}'**
  String pickMediaFailed(String error);

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String couldNotLaunchUrl(String url);

  /// No description provided for @errorLaunchingUrl.
  ///
  /// In en, this message translates to:
  /// **'Error launching URL: {error}'**
  String errorLaunchingUrl(String error);

  /// No description provided for @busFeedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Bus Feedback'**
  String get busFeedbackLabel;

  /// No description provided for @driverFeedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver Feedback'**
  String get driverFeedbackLabel;

  /// No description provided for @rateBusExperience.
  ///
  /// In en, this message translates to:
  /// **'How would you rate the overall condition and comfort of the bus?'**
  String get rateBusExperience;

  /// No description provided for @rateDriverExperience.
  ///
  /// In en, this message translates to:
  /// **'How would you rate the driver\'s performance and professionalism?'**
  String get rateDriverExperience;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

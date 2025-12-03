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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @driverInformation.
  ///
  /// In en, this message translates to:
  /// **'Driver Information'**
  String get driverInformation;

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

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SafeDriver'**
  String get welcomeTitle;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Track Buses in Real-time'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Description.
  ///
  /// In en, this message translates to:
  /// **'Monitor your bus location and get accurate arrival times'**
  String get onboarding1Description;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Driver Safety Monitoring'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Description.
  ///
  /// In en, this message translates to:
  /// **'Real-time alerts for driver drowsiness and distraction'**
  String get onboarding2Description;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Emergency Response'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Description.
  ///
  /// In en, this message translates to:
  /// **'Quick access to emergency services and safety features'**
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

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorOccurredGeneric(String error);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'si': return AppLocalizationsSi();
    case 'ta': return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

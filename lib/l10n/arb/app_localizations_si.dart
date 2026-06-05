// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get appName => 'SafeDriver මගී';

  @override
  String get appTagline => 'ඔබේ ආරක්ෂාව, අපේ ප්‍රමුඛතාවය';

  @override
  String get login => 'ඇතුල් වන්න';

  @override
  String get signIn => 'පුරනය වන්න';

  @override
  String get viewBus => 'බස් රථය බලන්න';

  @override
  String get availableBuses => 'ලබා ගත හැකි බස් රථ';

  @override
  String get viewDriverDetails => 'රියදුරු විස්තර බලන්න';

  @override
  String get driverInformation => 'රියදුරු තොරතුරු';

  @override
  String get myTrips => 'මගේ ගමන්';

  @override
  String get viewHistory => 'ඉතිහාසය බලන්න';

  @override
  String get emergencyHelp => 'හදිසි උපකාර';

  @override
  String get noRecentTrips => 'මෑතකදී ගමන් නොමැත';

  @override
  String get startFirstJourney => 'SafeDriver සමඟ ඔබේ පළමු ගමන ආරම්භ කරන්න';

  @override
  String get verifyYourAccount => 'ඔබේ ගිණුම තහවුරු කරන්න';

  @override
  String verificationCodeSent(String phoneNumber) {
    return 'අපි තහවුරු කිරීමේ කේතයක් මෙයට එවා ඇත\n$phoneNumber';
  }

  @override
  String get verifyAndCreateAccount => 'තහවුරු කර ගිණුම සාදන්න';

  @override
  String get didntReceiveCode => 'කේතය ලැබුණේ නැද්ද? ';

  @override
  String get resend => 'නැවත එවන්න';

  @override
  String resendIn(int seconds) {
    return 'තත්පර $seconds කින් නැවත එවන්න';
  }

  @override
  String get changePhoneNumber => 'දුරකථන අංකය වෙනස් කරන්න';

  @override
  String get accountCreatedSuccessfully => 'ගිණුම සාර්ථකව සාදන ලදී!';

  @override
  String get accountCreatedAndVerified =>
      'ගිණුම සාර්ථකව සාදා තහවුරු කරන ලදී! කරුණාකර ඔබේ අක්තපත්‍ර සමඟ ඇතුල් වන්න.';

  @override
  String get pleaseEnterCompleteOtp => 'කරුණාකර සම්පූර්ණ OTP ඇතුළත් කරන්න';

  @override
  String get verificationIdNotFound =>
      'තහවුරු කිරීමේ හැඳුනුම්පත හමු නොවීය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get otpSentSuccessfully => 'OTP සාර්ථකව යවන ලදී';

  @override
  String get register => 'ලියාපදිංචි වන්න';

  @override
  String get logout => 'පිටවන්න';

  @override
  String get email => 'විද්‍යුත් තැපෑල';

  @override
  String get password => 'මුරපදය';

  @override
  String get confirmPassword => 'මුරපදය තහවුරු කරන්න';

  @override
  String get forgotPassword => 'මුරපදය අමතකද?';

  @override
  String get resetPassword => 'මුරපදය නැවත සකසන්න';

  @override
  String get createAccount => 'ගිණුමක් සාදන්න';

  @override
  String get alreadyHaveAccount => 'දැනටමත් ගිණුමක් තිබේද?';

  @override
  String get dontHaveAccount => 'ගිණුමක් නොමැතිද?';

  @override
  String get loginSuccess => 'ඇතුල් වීම සාර්ථකයි';

  @override
  String get loginFailed => 'ඇතුල් වීම අසාර්ථකයි';

  @override
  String get registrationSuccess => 'ලියාපදිංචිය සාර්ථකයි';

  @override
  String get registrationFailed => 'ලියාපදිංචිය අසාර්ථකයි';

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
  String get otpVerification => 'OTP තහවුරු කිරීම';

  @override
  String get enterOTP => 'OTP ඇතුළත් කරන්න';

  @override
  String get otpSent => 'OTP යවන ලදී';

  @override
  String get otpFailed => 'OTP යැවීමට අපොහොසත් විය';

  @override
  String get verificationFailed => 'තහවුරු කිරීම අසාර්ථකයි';

  @override
  String get emailValidationFailed =>
      'විද්‍යුත් තැපෑල තහවුරු කිරීම අසාර්ථකයි. කරුණාකර ඔබේ විද්‍යුත් තැපැල් ලිපිනය පරීක්ෂා කරන්න.';

  @override
  String get passwordValidationFailed =>
      'මුරපදය තහවුරු කිරීම අසාර්ථකයි. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get accountAlreadyExists =>
      'මෙම විද්‍යුත් තැපෑලෙන් දැනටමත් ගිණුමක් පවතී.';

  @override
  String get resendOTP => 'OTP නැවත එවන්න';

  @override
  String get otpExpired => 'OTP කල් ඉකුත් වී ඇත';

  @override
  String get invalidOTP => 'අවලංගු OTP';

  @override
  String get verifyOTP => 'OTP තහවුරු කරන්න';

  @override
  String get dashboard => 'පුවරුව';

  @override
  String get safetyOverview => 'ආරක්ෂක දළ විශ්ලේෂණය';

  @override
  String get quickActions => 'ඉක්මන් ක්‍රියා';

  @override
  String get recentActivity => 'මෑත ක්‍රියාකාරකම්';

  @override
  String get activeJourney => 'සක්‍රීය ගමන';

  @override
  String get noActiveJourney => 'සක්‍රීය ගමන් නොමැත';

  @override
  String get safetyScore => 'ආරක්ෂක ලකුණු';

  @override
  String get fleetStatus => 'යාත්‍රා තත්ත්වය';

  @override
  String get home => 'මුල් පිටුව';

  @override
  String get search => 'සොයන්න';

  @override
  String get history => 'ඉතිහාසය';

  @override
  String get profile => 'පැතිකඩ';

  @override
  String get settings => 'සැකසුම්';

  @override
  String get notifications => 'දැනුම්දීම්';

  @override
  String get busInformation => 'බස් තොරතුරු';

  @override
  String get busDetails => 'බස් විස්තර';

  @override
  String get busNumber => 'බස් අංකය';

  @override
  String get routeNumber => 'මාර්ග අංකය';

  @override
  String get driverName => 'රියදුරු නම';

  @override
  String get currentLocation => 'වත්මන් ස්ථානය';

  @override
  String get nextStop => 'ඊළඟ නැවතුම';

  @override
  String get estimatedArrival => 'ඇස්තමේන්තුගත පැමිණීම';

  @override
  String get passengerCapacity => 'මගී ධාරිතාව';

  @override
  String get busStatus => 'බස් තත්ත්වය';

  @override
  String get liveTracking => 'සජීවී ලුහුබැඳීම';

  @override
  String get trackBus => 'බස් රථය ලුහුබඳින්න';

  @override
  String get busHistory => 'බස් ඉතිහාසය';

  @override
  String get searchBus => 'බස් රථයක් සොයන්න';

  @override
  String get scanQRCode => 'QR කේතය ස්කෑන් කරන්න';

  @override
  String get driverProfile => 'රියදුරු පැතිකඩ';

  @override
  String get driverHistory => 'රියදුරු ඉතිහාසය';

  @override
  String get driverPerformance => 'රියදුරු කාර්ය සාධනය';

  @override
  String get driverRating => 'රියදුරු ශ්‍රේණිගත කිරීම';

  @override
  String get driverExperience => 'අත්දැකීම්';

  @override
  String get driverLicense => 'බලපත්‍රය';

  @override
  String get driverCertifications => 'සහතික';

  @override
  String get driverContact => 'සම්බන්ධතා';

  @override
  String get driverStatus => 'රියදුරු තත්ත්වය';

  @override
  String get alertnessLevel => 'සීරුවෙන් සිටීමේ මට්ටම';

  @override
  String get safety => 'ආරක්ෂාව';

  @override
  String get safetyAlerts => 'ආරක්ෂක ඇඟවීම්';

  @override
  String get emergencyAlert => 'හදිසි ඇඟවීම්';

  @override
  String get hazardZones => 'අන්තරායකර කලාප';

  @override
  String get emergencyContacts => 'හදිසි සම්බන්ධතා';

  @override
  String get callEmergency => 'හදිසි ඇමතුම්';

  @override
  String get reportIncident => 'සිදුවීමක් වාර්තා කරන්න';

  @override
  String get safetyTips => 'ආරක්ෂක උපදෙස්';

  @override
  String get weatherWarning => 'කාලගුණ අනතුරු ඇඟවීම';

  @override
  String get roadConditions => 'මාර්ග තත්ත්වයන්';

  @override
  String get trafficAlert => 'රථවාහන ඇඟවීම්';

  @override
  String get feedback => 'ප්‍රතිපෝෂණ';

  @override
  String get submitFeedback => 'ප්‍රතිපෝෂණ ඉදිරිපත් කරන්න';

  @override
  String get feedbackHistory => 'ප්‍රතිපෝෂණ ඉතිහාසය';

  @override
  String get rateBus => 'බස් රථය ශ්‍රේණිගත කරන්න';

  @override
  String get rateDriver => 'රියදුරු ශ්‍රේණිගත කරන්න';

  @override
  String get reportProblem => 'ගැටලුවක් වාර්තා කරන්න';

  @override
  String get suggestion => 'යෝජනාව';

  @override
  String get complaint => 'පැමිණිල්ල';

  @override
  String get compliment => 'ප්‍රශංසාව';

  @override
  String get feedbackSubmitted => 'ප්‍රතිපෝෂණය සාර්ථකව ඉදිරිපත් කරන ලදී';

  @override
  String get general => 'සාමාන්‍ය';

  @override
  String get languageSettings => 'භාෂා සැකසුම්';

  @override
  String get selectLanguage => 'භාෂාව තෝරන්න';

  @override
  String get notificationSettings => 'දැනුම්දීම් සැකසුම්';

  @override
  String get pushNotifications => 'Push දැනුම්දීම්';

  @override
  String get emailNotifications => 'විද්‍යුත් තැපැල් දැනුම්දීම්';

  @override
  String get darkMode => 'අඳුරු ප්‍රකාරය';

  @override
  String get autoMode => 'ස්වයංක්‍රීය ප්‍රකාරය';

  @override
  String get lightMode => 'ආලෝක ප්‍රකාරය';

  @override
  String get fontSize => 'අකුරු ප්‍රමාණය';

  @override
  String get privacy => 'පෞද්ගලිකත්වය';

  @override
  String get dataUsage => 'දත්ත භාවිතය';

  @override
  String get location => 'ස්ථානය';

  @override
  String get account => 'ගිණුම';

  @override
  String get changePassword => 'මුරපදය වෙනස් කරන්න';

  @override
  String get deleteAccount => 'ගිණුම මකා දමන්න';

  @override
  String get save => 'සුරකින්න';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get ok => 'හරි';

  @override
  String get or => 'හෝ';

  @override
  String get yes => 'ඔව්';

  @override
  String get no => 'නැත';

  @override
  String get noAccountFoundPhone => 'මෙම දුරකථන අංකය සමඟ ගිණුමක් හමු නොවීය.';

  @override
  String get enterPhoneResetPassword =>
      'ඔබේ දුරකථන අංකය ඇතුළත් කරන්න, එවිට අපි ඔබේ මුරපදය නැවත සැකසීමට කේතයක් එවන්නෙමු';

  @override
  String get sendOTP => 'OTP යවන්න';

  @override
  String get backToLogin => 'නැවත ඇතුල් වීමට';

  @override
  String get pleaseEnterComplete6DigitOtp =>
      'කරුණාකර සම්පූර්ණ ඉලක්කම් 6 ක OTP ඇතුළත් කරන්න';

  @override
  String get invalidOtpTryAgain => 'අවලංගු OTP. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get sending => 'යවමින්...';

  @override
  String get passwordResetSuccessful => 'මුරපදය නැවත සැකසීම සාර්ථකයි';

  @override
  String get passwordResetSuccessMessage =>
      'ඔබේ මුරපදය සාර්ථකව නැවත සකසා ඇත. ඔබට දැන් ඔබේ නව මුරපදය සමඟ පුරනය විය හැක.';

  @override
  String get goToSignIn => 'පුරනය වීමට යන්න';

  @override
  String get passwordResetSuccessLoginMessage =>
      'මුරපදය නැවත සැකසීම සාර්ථකයි. කරුණාකර ඔබේ නව මුරපදය සමඟ පුරනය වන්න.';

  @override
  String get newPassword => 'නව මුරපදය';

  @override
  String get passwordRequirements => 'මුරපද අවශ්‍යතා:';

  @override
  String get passwordReq1 => '• අවම වශයෙන් අක්ෂර 8 ක් දිග';

  @override
  String get passwordReq2 => '• ලොකු අකුරු සහ කුඩා අකුරු අඩංගු වේ';

  @override
  String get passwordReq3 => '• අවම වශයෙන් එක් අංකයක් අඩංගු වේ';

  @override
  String get backToSignIn => 'නැවත පුරනය වීමට';

  @override
  String get verifyYourPhone => 'ඔබේ දුරකථනය තහවුරු කරන්න';

  @override
  String get enterVerificationCode => 'තහවුරු කිරීමේ කේතය ඇතුළත් කරන්න';

  @override
  String get type6DigitCode => 'අපි ඔබට එවූ ඉලක්කම් 6 ක කේතය ටයිප් කරන්න';

  @override
  String get verifyCode => 'කේතය තහවුරු කරන්න';

  @override
  String otpSentTo(String phoneNumber) {
    return 'OTP සාර්ථකව $phoneNumber වෙත යවන ලදී';
  }

  @override
  String get createStrongNewPassword =>
      'ඔබේ ගිණුම සඳහා ශක්තිමත් නව මුරපදයක් සාදන්න';

  @override
  String get enterYourPhoneNumber => 'ඔබේ දුරකථන අංකය ඇතුළත් කරන්න';

  @override
  String get sendVerificationCodeViaSMS =>
      'අපි ඔබට SMS මගින් තහවුරු කිරීමේ කේතයක් එවන්නෙමු';

  @override
  String get enterSriLankanMobile =>
      'ඔබේ ශ්‍රී ලාංකික ජංගම දුරකථන අංකය ඇතුළත් කරන්න';

  @override
  String get sendVerificationCode => 'තහවුරු කිරීමේ කේතය එවන්න';

  @override
  String get smsAgreement =>
      'ඉදිරියට යාමෙන්, තහවුරු කිරීමේ අරමුණු සඳහා SafeDriver වෙතින් SMS පණිවිඩ ලබා ගැනීමට ඔබ එකඟ වේ. පණිවිඩ සහ දත්ත ගාස්තු අදාළ විය හැක.';

  @override
  String get phoneHint => '77 123 4567';

  @override
  String get orContinueWith => 'නැතහොත් මෙයින් ඉදිරියට යන්න';

  @override
  String get emailAndPassword => 'විද්‍යුත් තැපෑල සහ මුරපදය';

  @override
  String get invalidSriLankanPhone =>
      'කරුණාකර වලංගු ශ්‍රී ලාංකික දුරකථන අංකයක් ඇතුළත් කරන්න';

  @override
  String get done => 'අවසන්';

  @override
  String get next => 'ඊළඟ';

  @override
  String get previous => 'පෙර';

  @override
  String get skip => 'මග හරින්න';

  @override
  String get retry => 'නැවත උත්සාහ කරන්න';

  @override
  String get refresh => 'නැවුම් කරන්න';

  @override
  String get loading => 'පූරණය වෙමින්...';

  @override
  String get updating => 'යාවත්කාලීන වෙමින්...';

  @override
  String get searching => 'සොයමින්...';

  @override
  String get processing => 'සැකසෙමින්...';

  @override
  String get male => 'පුරුෂ';

  @override
  String get female => 'ස්ත්‍රී';

  @override
  String get other => 'වෙනත්';

  @override
  String get preferNotToSay => 'පැවසීමට අකමැති';

  @override
  String get manageSosContacts =>
      'හදිසි ඇඟවීම් සඳහා SOS සම්බන්ධතා කළමනාකරණය කරන්න';

  @override
  String get manage => 'කළමනාකරණය';

  @override
  String errorSelectingImage(String error) {
    return 'රූපය තේරීමේ දෝෂයකි: $error';
  }

  @override
  String errorSavingProfile(String error) {
    return 'පැතිකඩ සුරැකීමේ දෝෂයකි: $error';
  }

  @override
  String errorLoadingProfile(String error) {
    return 'පැතිකඩ පූරණය කිරීමේ දෝෂයකි: $error';
  }

  @override
  String get error => 'දෝෂය';

  @override
  String get errorOccurred => 'දෝෂයක් සිදු විය';

  @override
  String get networkError => 'ජාල දෝෂය';

  @override
  String get serverError => 'සේවාදායක දෝෂය';

  @override
  String get connectionTimeout => 'සම්බන්ධතා කාලය ඉක්මවා ඇත';

  @override
  String get noInternetConnection => 'අන්තර්ජාල සම්බන්ධතාවයක් නොමැත';

  @override
  String get dataMissing => 'දත්ත අස්ථානගත වී ඇත';

  @override
  String get invalidInput => 'අවලංගු ආදානය';

  @override
  String get requiredField => 'මෙම ක්ෂේත්‍රය අත්‍යවශ්‍ය වේ';

  @override
  String get tryAgainLater => 'කරුණාකර පසුව නැවත උත්සාහ කරන්න';

  @override
  String get success => 'සාර්ථකයි';

  @override
  String get operationSuccessful => 'මෙහෙයුම සාර්ථකයි';

  @override
  String get dataSaved => 'දත්ත සාර්ථකව සුරකින ලදී';

  @override
  String get dataUpdated => 'දත්ත සාර්ථකව යාවත්කාලීන කරන ලදී';

  @override
  String get dataDeleted => 'දත්ත සාර්ථකව මකා දමන ලදී';

  @override
  String get noData => 'දත්ත ලබා ගත නොහැක';

  @override
  String get noResults => 'ප්‍රතිඵල හමු නොවීය';

  @override
  String get noBuses => 'බස් රථ හමු නොවීය';

  @override
  String get noDrivers => 'රියදුරන් හමු නොවීය';

  @override
  String get noNotifications => 'දැනුම්දීම් නොමැත';

  @override
  String get noHistory => 'ඉතිහාසය ලබා ගත නොහැක';

  @override
  String get noFeedback => 'ප්‍රතිපෝෂණ ඉදිරිපත් කර නොමැත';

  @override
  String get noAlerts => 'සක්‍රීය ඇඟවීම් නොමැත';

  @override
  String get today => 'අද';

  @override
  String get yesterday => 'ඊයේ';

  @override
  String get tomorrow => 'හෙට';

  @override
  String get thisWeek => 'මේ සතියේ';

  @override
  String get lastWeek => 'පසුගිය සතියේ';

  @override
  String get thisMonth => 'මේ මාසයේ';

  @override
  String get lastMonth => 'පසුගිය මාසයේ';

  @override
  String get minutes => 'විනාඩි';

  @override
  String get hours => 'පැය';

  @override
  String get days => 'දින';

  @override
  String get weeks => 'සති';

  @override
  String get months => 'මාස';

  @override
  String get emailRequired => 'විද්‍යුත් තැපෑල අවශ්‍ය වේ';

  @override
  String get passwordRequired => 'මුරපදය අවශ්‍ය වේ';

  @override
  String get invalidEmail => 'අවලංගු විද්‍යුත් තැපැල් ආකෘතිය';

  @override
  String get passwordTooShort => 'මුරපදය අවම වශයෙන් අක්ෂර 8 ක් විය යුතුය';

  @override
  String get passwordsDoNotMatch => 'මුරපද නොගැලපේ';

  @override
  String get phoneRequired => 'දුරකථන අංකය අවශ්‍ය වේ';

  @override
  String get invalidPhone => 'අවලංගු දුරකථන අංකය';

  @override
  String get nameRequired => 'නම අවශ්‍ය වේ';

  @override
  String get firstNameRequired => 'මුල් නම අවශ්‍ය වේ';

  @override
  String get lastNameRequired => 'වාසගම අවශ්‍ය වේ';

  @override
  String get firstNameMinLength => 'මුල් නම අවම වශයෙන් අක්ෂර 2 ක් විය යුතුය';

  @override
  String get lastNameMinLength => 'වාසගම අවම වශයෙන් අක්ෂර 2 ක් විය යුතුය';

  @override
  String get passwordComplexity =>
      'මුරපදයේ ලොකු අකුරු, කුඩා අකුරු සහ අංක අඩංගු විය යුතුය';

  @override
  String get confirmPasswordRequired => 'කරුණාකර ඔබේ මුරපදය තහවුරු කරන්න';

  @override
  String get acceptTerms => 'කරුණාකර නියමයන් සහ කොන්දේසි පිළිගන්න';

  @override
  String get welcomeTitle => 'SafeDriver වෙත සාදරයෙන් පිළිගනිමු';

  @override
  String get onboarding1Title => 'ආරක්ෂිත සහ විශ්වසනීය ප්‍රවාහනය';

  @override
  String get onboarding1Description =>
      'වඩාත්ම ආරක්ෂිත සහ විශ්වසනීය ප්‍රවාහන සේවාව අත්විඳින්න. වෘත්තීයමය වශයෙන් පුහුණු වූ රියදුරන් සමඟ ඔබේ ආරක්ෂාව අපගේ ප්‍රමුඛතාවයයි.';

  @override
  String get onboarding2Title => 'තථ්‍ය කාලීන ලුහුබැඳීම';

  @override
  String get onboarding2Description =>
      'ඔබේ ගමන තථ්‍ය කාලීනව ලුහුබඳින්න සහ සජීවී ස්ථාන යාවත්කාලීන කිරීම් සමඟ සම්බන්ධ වී සිටින්න. සෑම මොහොතකම ඔබේ ගමන කොතැනදැයි හරියටම දැන ගන්න.';

  @override
  String get onboarding3Title => 'බුද්ධිමත් ප්‍රතිපෝෂණ පද්ධතිය';

  @override
  String get onboarding3Description =>
      'ඔබේ අත්දැකීම් බෙදාගෙන ඉහළම සේවා ප්‍රමිතීන් පවත්වා ගැනීමට අපට උදවු කරන්න. ඔබේ ප්‍රතිපෝෂණය සෑම ගමනක්ම වඩා හොඳ කරයි.';

  @override
  String get getStarted => 'ආරම්භ කරන්න';

  @override
  String get about => 'පිළිබඳව';

  @override
  String get version => 'අනුවාදය';

  @override
  String get privacyPolicy => 'පෞද්ගලිකත්ව ප්‍රතිපත්තිය';

  @override
  String get termsOfService => 'සේවා කොන්දේසි';

  @override
  String get contactSupport => 'සහාය අමතන්න';

  @override
  String get rateApp => 'යෙදුම ශ්‍රේණිගත කරන්න';

  @override
  String get shareApp => 'යෙදුම බෙදා ගන්න';

  @override
  String get legal => 'නීතිමය';

  @override
  String get licenses => 'බලපත්‍ර';

  @override
  String get emergency => 'හදිසි';

  @override
  String get police => 'පොලිසිය';

  @override
  String get medical => 'වෛද්‍ය';

  @override
  String get fire => 'ගිනි නිවන දෙපාර්තමේන්තුව';

  @override
  String get callNow => 'දැන් අමතන්න';

  @override
  String get emergencyHotline => 'හදිසි ඇමතුම් අංකය';

  @override
  String get policeStation => 'පොලිස් ස්ථානය';

  @override
  String get hospital => 'රෝහල';

  @override
  String get fireStation => 'ගිනි නිවන ස්ථානය';

  @override
  String get alwaysWearSeatbelt => 'සෑම විටම ඔබේ ආසන පටිය පලඳින්න';

  @override
  String get stayAlert => 'අවධානයෙන් සිටින්න සහ ඔබේ වටපිටාව ගැන දැනුවත් වන්න';

  @override
  String get keepEmergencyContacts =>
      'හදිසි සම්බන්ධතා පහසුවෙන් ලබා ගත හැකි පරිදි තබා ගන්න';

  @override
  String get reportSuspiciousActivity =>
      'ඕනෑම සැක සහිත ක්‍රියාකාරකමක් වහාම වාර්තා කරන්න';

  @override
  String get followBusSafety =>
      'බස් ආරක්ෂණ ප්‍රොටෝකෝල සහ රියදුරු උපදෙස් අනුගමනය කරන්න';

  @override
  String get close => 'වසා දමන්න';

  @override
  String get bookTicket => 'ප්‍රවේශ පත්‍රයක් වෙන්කරවා ගන්න';

  @override
  String get comingSoon => 'ළඟදීම බලාපොරොත්තු වන්න';

  @override
  String get trackLive => 'සජීවීව ලුහුබඳින්න';

  @override
  String get share => 'බෙදා ගන්න';

  @override
  String get shareFunctionality =>
      'බෙදා ගැනීමේ ක්‍රියාකාරිත්වය ක්‍රියාත්මක කරනු ඇත';

  @override
  String get english => 'ඉංග්‍රීසි';

  @override
  String get sinhala => 'සිංහල';

  @override
  String get tamil => 'දෙමළ';

  @override
  String reportedBy(String name) {
    return 'වාර්තා කළේ: $name';
  }

  @override
  String busIdLabel(String busId) {
    return 'බස් හැඳුනුම්පත: $busId';
  }

  @override
  String driverIdLabel(String driverId) {
    return 'රියදුරු හැඳුනුම්පත: $driverId';
  }

  @override
  String get language => 'භාෂාව';

  @override
  String get systemDefault => 'පද්ධති පෙරනිමිය';

  @override
  String get acknowledge => 'පිළිගන්න';

  @override
  String get viewDetails => 'විස්තර බලන්න';

  @override
  String get viewProfile => 'පැතිකඩ බලන්න';

  @override
  String get contact => 'සම්බන්ධ වන්න';

  @override
  String get viewAll => 'සියල්ල බලන්න';

  @override
  String get scanQR => 'QR ස්කෑන් කරන්න';

  @override
  String get tryAgain => 'නැවත උත්සාහ කරන්න';

  @override
  String get goBack => 'ආපසු යන්න';

  @override
  String get openSettings => 'සැකසුම් විවෘත කරන්න';

  @override
  String get details => 'විස්තර';

  @override
  String get track => 'ලුහුබඳින්න';

  @override
  String get safetyTipsTitle => 'ආරක්ෂක උපදෙස්';

  @override
  String get safetyHub => 'ආරක්ෂක මධ්‍යස්ථානය';

  @override
  String get reportSafetyIssue => 'ආරක්ෂක ගැටලුවක් වාර්තා කරන්න';

  @override
  String get report => 'වාර්තා කරන්න';

  @override
  String get gotIt => 'තේරුණා';

  @override
  String get safetyAlertsTitle => 'ආරක්ෂක ඇඟවීම්';

  @override
  String get reportIncidentTitle => 'සිදුවීමක් වාර්තා කරන්න';

  @override
  String get hazardZonesTitle => 'අන්තරායකර කලාප';

  @override
  String get emergencyContactsTitle => 'හදිසි සම්බන්ධතා';

  @override
  String get enterCodeManually => 'කේතය අතින් ඇතුළත් කරන්න';

  @override
  String qrCodeDetected(String code) {
    return 'QR කේතය හඳුනා ගන්නා ලදී: $code';
  }

  @override
  String get signOut => 'පිටවන්න';

  @override
  String get areYouSureSignOut => 'ඔබට විශ්වාසද ඔබට පිටවීමට අවශ්‍ය බව?';

  @override
  String get tripHistory => 'ගමන් ඉතිහාසය';

  @override
  String get review => 'සමාලෝචනය';

  @override
  String tripDetails(String id) {
    return 'ගමන $id';
  }

  @override
  String get giveFeedback => 'ප්‍රතිපෝෂණ ලබා දෙන්න';

  @override
  String get comingSoonFeature =>
      'මෙම විශේෂාංගය අනාගත යාවත්කාලීනයකින් ලබා ගත හැකි වනු ඇත.';

  @override
  String get clearCache => 'Cache මකන්න';

  @override
  String get cacheClearedSuccessfully => 'Cache සාර්ථකව මකා දමන ලදී!';

  @override
  String get clear => 'මකන්න';

  @override
  String get profileTitle => 'පැතිකඩ';

  @override
  String get profileUpdatedSuccessfully => 'පැතිකඩ සාර්ථකව යාවත්කාලීන කරන ලදී';

  @override
  String failedToUpdateProfile(String error) {
    return 'පැතිකඩ යාවත්කාලීන කිරීමට අපොහොසත් විය: $error';
  }

  @override
  String get myProfile => 'මගේ පැතිකඩ';

  @override
  String get noProfileFound => 'පැතිකඩක් හමු නොවීය';

  @override
  String get viewFAQ => 'FAQ බලන්න';

  @override
  String get changePicture => 'පින්තූරය වෙනස් කරන්න';

  @override
  String get profileUpdated => 'පැතිකඩ සාර්ථකව යාවත්කාලීන කරන ලදී!';

  @override
  String get aboutTitle => 'පිළිබඳව';

  @override
  String get pageNotFound => 'පිටුව හමු නොවීය';

  @override
  String get searchFunctionalityComingSoon => 'සෙවුම් ක්‍රියාකාරිත්වය ළඟදීම!';

  @override
  String get busRoutesComingSoon => 'බස් මාර්ග ළඟදීම!';

  @override
  String get navigationComingSoon => 'සංචාලනය ළඟදීම!';

  @override
  String selected(String description) {
    return 'තෝරාගත්: $description';
  }

  @override
  String placeLookupFailed(String error) {
    return 'ස්ථානය සෙවීම අසාර්ථකයි: $error';
  }

  @override
  String foundBusStopsNearby(int count) {
    return 'අසල බස් නැවතුම් $count ක් හමු විය';
  }

  @override
  String foundQueryTapNavigate(String query) {
    return '\"$query\" හමු විය. බස් මාර්ගය බැලීමට Navigate තට්ටු කරන්න!';
  }

  @override
  String searchFailed(String error) {
    return 'සෙවීම අසාර්ථකයි: $error';
  }

  @override
  String get unableToGetCurrentLocation => 'වත්මන් ස්ථානය ලබා ගැනීමට නොහැක';

  @override
  String get pleaseSearchForDestination => 'කරුණාකර පළමුව ගමනාන්තයක් සොයන්න';

  @override
  String errorSelectingLanguage(String error) {
    return 'භාෂාව තේරීමේ දෝෂයකි: $error';
  }

  @override
  String get hazardZoneIntelligence => 'අන්තරායකර කලාප බුද්ධිය';

  @override
  String get loadingHazardZoneData => 'අන්තරායකර කලාප දත්ත පූරණය වෙමින්...';

  @override
  String get driverIdRequiredForAlerts =>
      'ඇඟවීම් බැලීමට රියදුරු හැඳුනුම්පත අවශ්‍ය වේ';

  @override
  String get noActiveHazardAlerts => 'සක්‍රීය අන්තරායකර ඇඟවීම් නොමැත';

  @override
  String get reviewsTitle => 'සමාලෝචන';

  @override
  String get back => 'ආපසු';

  @override
  String get addMedia => 'මාධ්‍ය එක් කරන්න';

  @override
  String get takePhoto => 'ඡායාරූපයක් ගන්න';

  @override
  String get chooseFromGallery => 'ගැලරියෙන් තෝරන්න';

  @override
  String fileTooLarge(String fileName) {
    return '$fileName ඉතා විශාලයි. උපරිම ප්‍රමාණය 10MB වේ.';
  }

  @override
  String get locationPermissionRequired =>
      'ස්ථානය බෙදා ගැනීමට ස්ථාන අවසරය අවශ්‍ය වේ';

  @override
  String failedToGetLocation(String error) {
    return 'ස්ථානය ලබා ගැනීමට අපොහොසත් විය: $error';
  }

  @override
  String get incidentReportingImplemented =>
      'සිදුවීම් වාර්තා කිරීම ක්‍රියාත්මක කරනු ඇත';

  @override
  String get priority => 'ප්‍රමුඛතාවය';

  @override
  String get low => 'අඩු';

  @override
  String get medium => 'මධ්‍යම';

  @override
  String get high => 'ඉහළ';

  @override
  String get urgent => 'හදිසි';

  @override
  String get submitAnonymously => 'නිර්නාමිකව ඉදිරිපත් කරන්න';

  @override
  String get personalInfoNotShared => 'ඔබේ පුද්ගලික තොරතුරු බෙදා නොගනු ඇත';

  @override
  String get chooseYourLanguage => 'ඔබේ භාෂාව තෝරන්න';

  @override
  String get selectYourPreferredLanguage =>
      'ඉදිරියට යාමට ඔබේ කැමති භාෂාව තෝරන්න';

  @override
  String get availableLanguages => 'ලබා ගත හැකි භාෂාවන්';

  @override
  String get continueButton => 'ඉදිරියට යන්න';

  @override
  String get continueWithGoogle => 'Google සමඟ ඉදිරියට යන්න';

  @override
  String get profilePageComingSoon => 'පැතිකඩ පිටුව - ළඟදීම';

  @override
  String get editProfile => 'පැතිකඩ සංස්කරණය කරන්න';

  @override
  String get loadingProfile => 'පැතිකඩ පූරණය වෙමින්...';

  @override
  String get profilePicture => 'පැතිකඩ පින්තූරය';

  @override
  String get basicInformation => 'මූලික තොරතුරු';

  @override
  String get emailAddress => 'විද්‍යුත් තැපැල් ලිපිනය';

  @override
  String get noEmail => 'විද්‍යුත් තැපෑලක් නැත';

  @override
  String get firstName => 'මුල් නම';

  @override
  String get lastName => 'වාසගම';

  @override
  String get dateOfBirth => 'උපන් දිනය';

  @override
  String get gender => 'ස්ත්‍රී පුරුෂ භාවය';

  @override
  String get addressInformation => 'ලිපින තොරතුරු';

  @override
  String get streetAddress => 'වීදි ලිපිනය';

  @override
  String get city => 'නගරය';

  @override
  String get state => 'පළාත/ප්‍රාන්තය';

  @override
  String get zipCode => 'තැපැල් කේතය';

  @override
  String get country => 'රට';

  @override
  String get emergencyContact => 'හදිසි සම්බන්ධතා';

  @override
  String get contactName => 'සම්බන්ධක නම';

  @override
  String get relationship => 'සම්බන්ධතාවය';

  @override
  String get preferences => 'මනාප';

  @override
  String get cameraError => 'කැමරා දෝෂය';

  @override
  String get positionQrCode => 'QR කේතය මෙහි තබන්න';

  @override
  String get qrScanner => 'QR ස්කෑනරය';

  @override
  String get scanQrInstruction =>
      'බස් රථයේ හෝ නැවතුමේ ඇති QR කේතය ස්කෑන් කරන්න';

  @override
  String get alignQrInstruction => 'නිශ්චලව තබා QR කේතය රාමුව තුළ පෙළගස්වන්න';

  @override
  String get enterBusStopCode => 'බස් හෝ නැවතුම් කේතය ඇතුළත් කරන්න';

  @override
  String get submit => 'ඉදිරිපත් කරන්න';

  @override
  String get mapsNavigation => 'සිතියම් සහ සංචාලනය';

  @override
  String get searchDestination => 'ගමනාන්තය සොයන්න...';

  @override
  String get busStop => 'බස් නැවතුම';

  @override
  String get navigate => 'සංචාලනය';

  @override
  String get yourLocation => 'ඔබේ ස්ථානය';

  @override
  String get currentPosition => 'වත්මන් ස්ථානය';

  @override
  String get unableToLoadMap => 'සිතියම පූරණය කිරීමට නොහැක';

  @override
  String get loadingMap => 'සිතියම පූරණය වෙමින්...';

  @override
  String get busRouteToDestination => 'ගමනාන්තයට බස් මාර්ගය';

  @override
  String get phoneNumber => 'දුරකථන අංකය';

  @override
  String languageChanged(String language) {
    return 'භාෂාව $language ලෙස වෙනස් කරන ලදී';
  }

  @override
  String failedToChangeLanguage(String error) {
    return 'භාෂාව වෙනස් කිරීමට අපොහොසත් විය: $error';
  }

  @override
  String tripId(String tripId) {
    return 'ගමන් හැඳුනුම්පත: $tripId';
  }

  @override
  String get safetyFirst => 'ආරක්ෂාව පළමුව';

  @override
  String get safetyDescription =>
      'ඔබේ ආරක්ෂාව අපගේ ප්‍රමුඛතාවයයි. හදිසි විශේෂාංග වෙත ප්‍රවේශ වන්න, සිදුවීම් වාර්තා කරන්න, සහ ආරක්ෂක පියවරයන් පිළිබඳව දැනුවත් වන්න.';

  @override
  String get emergencyActions => 'හදිසි ක්‍රියාමාර්ග';

  @override
  String get callForHelp => 'උදව් සඳහා අමතන්න';

  @override
  String get reportIssue => 'ගැටලුවක් වාර්තා කරන්න';

  @override
  String get safetyFeatures => 'ආරක්ෂක විශේෂාංග';

  @override
  String get realTimeSafetyNotifications => 'තථ්‍ය කාලීන ආරක්ෂක දැනුම්දීම්';

  @override
  String get viewKnownHazardousAreas => 'දන්නා අන්තරායකර ප්‍රදේශ බලන්න';

  @override
  String get learnSafetyBestPractices => 'ආරක්ෂක හොඳම භාවිතයන් ඉගෙන ගන්න';

  @override
  String get support => 'සහාය';

  @override
  String get reportSafetyDialogContent =>
      'ඔබට ආරක්ෂක සිදුවීමක් හෝ සැලකිල්ලක් වාර්තා කිරීමට අවශ්‍යද?';

  @override
  String get safetyTip1 => '• සෑම විටම ඔබේ ආසන පටිය පලඳින්න';

  @override
  String get safetyTip2 =>
      '• අවධානයෙන් සිටින්න සහ ඔබේ වටපිටාව ගැන දැනුවත් වන්න';

  @override
  String get safetyTip3 =>
      '• හදිසි සම්බන්ධතා පහසුවෙන් ලබා ගත හැකි පරිදි තබා ගන්න';

  @override
  String get safetyTip4 => '• ඕනෑම සැක සහිත ක්‍රියාකාරකමක් වහාම වාර්තා කරන්න';

  @override
  String get safetyTip5 =>
      '• බස් ආරක්ෂණ ප්‍රොටෝකෝල සහ රියදුරු උපදෙස් අනුගමනය කරන්න';

  @override
  String get iAgreeTo => 'මම මෙයට එකඟ වෙමි ';

  @override
  String get and => ' සහ ';

  @override
  String errorOccurredGeneric(String error) {
    return 'දෝෂය: $error';
  }

  @override
  String get goodMorning => 'සුභ උදෑසනක්';

  @override
  String get goodAfternoon => 'සුභ දහවලක්';

  @override
  String get goodEvening => 'සුභ සැන්දෑවක්';

  @override
  String get goodNight => 'සුභ රාත්‍රියක්';

  @override
  String get traveler => 'සංචාරකයා';

  @override
  String get rememberMe => 'මාව මතක තබා ගන්න';

  @override
  String get dismiss => 'ඉවත් කරන්න';

  @override
  String get activeBuses => 'සක්‍රීය බස් රථ';

  @override
  String activeBusesCount(Object count) {
    return 'සක්‍රීය බස් රථ $count';
  }

  @override
  String safetyScoreLabel(Object score) {
    return 'ආරක්ෂක ලකුණු: $score%';
  }

  @override
  String driversCount(Object count) {
    return 'රියදුරන් $count';
  }

  @override
  String hazardZonesCount(Object count) {
    return 'අන්තරායකර කලාප $count';
  }

  @override
  String get busQrScanned => 'බස් QR කේතය ස්කෑන් කරන ලදී';

  @override
  String get safetyAlertAcknowledged => 'ආරක්ෂක ඇඟවීම පිළිගන්නා ලදී';

  @override
  String get newHazardZoneReported => 'නව අන්තරායකර කලාපයක් වාර්තා විය';

  @override
  String timeAgo(Object time) {
    return 'මීට පෙර $time';
  }

  @override
  String get poweredBy => 'SafeDriver Technologies මගින් බලගන්වන ලදී';

  @override
  String get addSosContact => 'SOS සම්බන්ධතාවක් එක් කරන්න';

  @override
  String get editSosContact => 'SOS සම්බන්ධතාව සංස්කරණය කරන්න';

  @override
  String get removeSosContact => 'SOS සම්බන්ධතාව මකා දමන්න';

  @override
  String areYouSureRemoveContact(Object name) {
    return 'ඔබට විශ්වාසද $name ඔබේ SOS සම්බන්ධතා වලින් ඉවත් කිරීමට අවශ්‍ය බව?';
  }

  @override
  String get contactNameLabel => 'සම්බන්ධක නම';

  @override
  String get contactNameHint => 'උදා: අම්මා, තාත්තා, කලත්‍රයා';

  @override
  String get relationshipLabel => 'සම්බන්ධතාවය';

  @override
  String get relationshipHint => 'උදා: දෙමාපියන්, මිතුරා';

  @override
  String get alertMethods => 'ඇඟවීම් ක්‍රම';

  @override
  String get autoSendSos => 'ස්වයංක්‍රීය SOS යැවීම';

  @override
  String get autoSendSosDescription =>
      'සියලුම සම්බන්ධතා වෙත ස්වයංක්‍රීයව ඇඟවීම් යවන්න';

  @override
  String get sosContactsDescription =>
      'ඔබේ සජීවී ස්ථානය සමඟ SMS සහ WhatsApp හරහා ඔබේ SOS ඇඟවීම් ලබා ගන්නා විශ්වාසදායක සම්බන්ධතා එක් කරන්න.';

  @override
  String get noSosContactsYet => 'තවමත් SOS සම්බන්ධතා නොමැත';

  @override
  String get addYourFirstContact => 'ඔබේ පළමු සම්බන්ධතාව එක් කරන්න';

  @override
  String get mySosContacts => 'මගේ SOS සම්බන්ධතා';

  @override
  String sosContactsCount(Object count) {
    return 'සම්බන්ධතා $count';
  }

  @override
  String get sms => 'SMS';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get onDuty => 'සේවයේ යෙදී සිටී';

  @override
  String get offDuty => 'සේවයේ නොමැත';

  @override
  String get onBreak => 'විවේකයේ සිටී';

  @override
  String get unknown => 'නොදනී';

  @override
  String experienceYears(Object years) {
    return 'වසර $years';
  }

  @override
  String get joined => 'එකතු වූයේ';

  @override
  String get license => 'බලපත්‍රය';

  @override
  String get model => 'මාදිලිය';

  @override
  String get searchBusesHint => 'බස් අංකය, මාර්ගය, රියදුරු මගින් සොයන්න...';

  @override
  String get searchDriversHint => 'නම, බලපත්‍රය, මාර්ගය මගින් සොයන්න...';

  @override
  String get searchPlacesHint => 'ස්ථාන, බස් නැවතුම් සොයන්න...';

  @override
  String get noBusesAvailable => 'බස් රථ ලබා ගත නොහැක';

  @override
  String get checkBackLaterBuses =>
      'ලබා ගත හැකි බස් රථ සඳහා පසුව නැවත පරීක්ෂා කරන්න';

  @override
  String get noMatchingDrivers => 'ගැලපෙන රියදුරන් නැත';

  @override
  String get tryDifferentSearch => 'වෙනත් සෙවුම් පදයක් උත්සාහ කරන්න';

  @override
  String get locationServicesDisabled =>
      'ස්ථාන සේවා අක්‍රිය කර ඇත. කරුණාකර ස්ථාන සේවා සක්‍රිය කරන්න.';

  @override
  String get locationPermissionDenied =>
      'ස්ථාන අවසරය ප්‍රතික්ෂේප විය. කරුණාකර ස්ථාන ප්‍රවේශය ලබා දෙන්න.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'ස්ථාන අවසර ස්ථිරවම ප්‍රතික්ෂේප කර ඇත. කරුණාකර ඒවා සැකසුම් තුළ සක්‍රිය කරන්න.';

  @override
  String get noMatchingLocations => 'ගැලපෙන ස්ථාන හමු නොවීය';

  @override
  String get destination => 'ගමනාන්තය';

  @override
  String get boardBus => 'බස් රථයට ගොඩ වන්න';

  @override
  String get leaveBus => 'බස් රථයෙන් බසින්න';

  @override
  String get googleBusDirectionsUnavailable =>
      'Google බස් උපදෙස් ලබා ගත නොහැක. ඇස්තමේන්තුගත මාර්ගය පෙන්වයි.';

  @override
  String get distance => 'දුර';

  @override
  String get duration => 'කාලය';

  @override
  String get avgSpeed => 'සාමාන්්‍ය වේගය';

  @override
  String get zoomIn => 'විශාලනය කරන්න';

  @override
  String get zoomOut => 'කුඩා කරන්න';

  @override
  String get toggleMapType => 'සිතියම් වර්ගය වෙනස් කරන්න';

  @override
  String get toggleTraffic => 'රථවාහන පෙන්වන්න';

  @override
  String get centerOnLocation => 'ස්ථානයට යොමු කරන්න';

  @override
  String stopsCount(Object count) {
    return 'නැවතුම් $count';
  }

  @override
  String get excellent => 'විශිෂ්ටයි';

  @override
  String get good => 'හොඳයි';

  @override
  String get fair => 'සාමාන්‍ය';

  @override
  String get poor => 'දුර්වලයි';

  @override
  String get critical => 'අවදානම්';

  @override
  String get healthRecord => 'සෞඛ්‍ය වාර්තාව';

  @override
  String get lastMedicalCheck => 'අවසාන වෛද්‍ය පරීක්ෂණය';

  @override
  String get medicalStatus => 'වෛද්‍ය තත්ත්වය';

  @override
  String get healthy => 'නිරෝගී';

  @override
  String get healthIssues => 'සෞඛ්‍ය ගැටලු';

  @override
  String get medicalExamDue => 'වෛද්‍ය පරීක්ෂණය නියමිත දිනය';

  @override
  String get medicalConditions => 'වෛද්‍ය තත්ත්වයන්';

  @override
  String get none => 'කිසිවක් නැත';

  @override
  String get performanceOverview => 'කාර්ය සාධන දළ විශ්ලේෂණය';

  @override
  String get totalTrips => 'මුළු ගමන් වාර';

  @override
  String get totalDistance => 'මුළු දුර';

  @override
  String get punctuality => 'වේලාවට වැඩ කිරීම';

  @override
  String get fuelEfficiency => 'ඉන්ධන කාර්යක්ෂමතාව';

  @override
  String get routeSpecializations => 'විශේෂිත මාර්ග';

  @override
  String get trainingHistory => 'පුහුණු ඉතිහාසය';

  @override
  String get noTrainingRecords => 'පුහුණු වාර්තා ලබා ගත නොහැක';

  @override
  String get passed => 'සමත්';

  @override
  String get failed => 'අසමත්';

  @override
  String get expires => 'කල් ඉකුත් වේ';

  @override
  String get active => 'සක්‍රීය';

  @override
  String get expired => 'කල් ඉකුත් වී ඇත';

  @override
  String get personalInformation => 'පෞද්ගලික තොරතුරු';

  @override
  String get currentStatus => 'වත්මන් තත්ත්වය';

  @override
  String get currentBus => 'වත්මන් බස් රථය';

  @override
  String get currentRoute => 'වත්මන් මාර්ගය';

  @override
  String get alertness => 'සීරුවෙන් සිටීම';

  @override
  String get mainFeatures => 'ප්‍රධාන අංග';

  @override
  String get qrScannerDescription =>
      'ක්ෂණික තොරතුරු ලබා ගැනීමට බස් QR කේත ස්කෑන් කරන්න';

  @override
  String get liveTrackingDescription =>
      'සිතියම් සමඟ තථ්‍ය කාලීன බස් රථ පිහිටීම ලුහුබැඳීම';

  @override
  String get driverInfoDescription =>
      'සවිස්තරාත්මක රියදුරු තොරතුරු සහ කාර්ය සාධනය';

  @override
  String get hazardZonesDescription =>
      'අන්තරාදායක ප්‍රදේශ සහ ආරක්ෂක ඇඟවීම් නිරීක්ෂණය කරන්න';

  @override
  String get quickStats => 'ඉක්මන් සංඛ්‍යාලේඛන';

  @override
  String get appDescription => 'ඔබේ සවිස්තරාත්මක බස් ආරක්ෂණ අධීක්ෂණ වේදිකාව';

  @override
  String get driverInfo => 'රියදුරු තොරතුරු';

  @override
  String get drivers => 'රියදුරන්';

  @override
  String get verifiedMember => 'තහවුරු කළ සාමාජික';

  @override
  String get updateInfo => 'තොරතුරු යාවත්කාලීන කරන්න';

  @override
  String get viewTrips => 'ගමන් වාර බලන්න';

  @override
  String get yourFeedback => 'ඔබේ ප්‍රතිපෝෂණය';

  @override
  String get getHelp => 'උදව් ලබා ගන්න';

  @override
  String get accountAndSettings => 'ගිණුම සහ සැකසුම්';

  @override
  String get notProvided => 'සපයා නැත';

  @override
  String get appSettings => 'යෙදුම් සැකසුම්';

  @override
  String get aboutApp => 'යෙදුම පිළිබඳව';

  @override
  String get unableToLoadProfile => 'පැතිකඩ පූරණය කිරීමට නොහැක';

  @override
  String get shareFeedback => 'ප්‍රතිපෝෂණ බෙදා ගන්න';

  @override
  String get feedbackSubtitle =>
      'ඔබේ අත්දැකීම් වැඩිදියුණු කිරීමට අපට උදවු කරන්න';

  @override
  String get tripInformation => 'ගමන් තොරතුරු';

  @override
  String get busIdTitle => 'බස් හැඳුනුම්පත';

  @override
  String get tripIdTitle => 'ගමන් හැඳුනුම්පත';

  @override
  String get rateExperience => 'ඔබේ අත්දැකීම ශ්‍රේණිගත කරන්න';

  @override
  String get noFeedbackYet => 'තවමත් ප්‍රතිපෝෂණ නොමැත';

  @override
  String get noFeedbackSubtitle =>
      'ආරම්භ කිරීමට බස් රථ සහ රියදුරන් පිළිබඳ ඔබේ ප්‍රතිපෝෂණ බෙදා ගන්න';

  @override
  String busLabel(String busNumber) {
    return 'බස් රථය $busNumber';
  }

  @override
  String get statusSubmitted => 'ඉදිරිපත් කරන ලදී';

  @override
  String get statusReviewed => 'සමාලෝචනය කරන ලදී';

  @override
  String get statusResolved => 'විසඳන ලදී';

  @override
  String get statusRejected => 'ප්‍රතික්ෂේප කරන ලදී';

  @override
  String get statusPending => 'පොරොත්තුවෙන්';

  @override
  String get commentLabel => 'අදහස්';

  @override
  String submittedDateLabel(String date) {
    return 'ඉදිරිපත් කළ දිනය: $date';
  }

  @override
  String get feedbackHistorySubtitle =>
      'ඔබේ සියලුම ප්‍රතිපෝෂණ ඉදිරිපත් කිරීම් නිරීක්ෂණය කරන්න';

  @override
  String get typePositive => 'ධනාත්මක';

  @override
  String get typeNegative => 'සෘණාත්මක';

  @override
  String get typeNeutral => 'මධ්‍යස්ථ';

  @override
  String get typeSuggestion => 'යෝජනාව';

  @override
  String get typeInquiry => 'විමසීම';

  @override
  String get typeUrgent => 'හදිසි';

  @override
  String get typeGeneral => 'සාමාන්‍ය';

  @override
  String get categoryComfort => 'පහසුව';

  @override
  String get categoryVehicle => 'වාහනය';

  @override
  String feedbackSuccessWithId(String id) {
    return 'ප්‍රතිපෝෂණය සාර්ථකව ඉදිරිපත් කරන ලදී! හැඳුනුම්පත: $id';
  }

  @override
  String feedbackFailed(String error) {
    return 'ප්‍රතිපෝෂණය ඉදිරිපත් කිරීමට අපොහොසත් විය: $error';
  }

  @override
  String get failedToLoadPassenger => 'මගී දත්ත පැටවීමට අපොහොසත් විය';

  @override
  String get pleaseTryAgainLater => 'කරුණාකර පසුව නැවත උත්සාහ කරන්න';

  @override
  String get noPassengerProfile => 'මගී පැතිකඩක් හමු නොවීය';

  @override
  String get passengerInformation => 'මගී තොරතුරු';

  @override
  String get submitFeedbackSubtitle =>
      'ඔබේ අත්දැකීම් බෙදාගෙන අපට දියුණු වීමට උදවු වන්න';

  @override
  String nameLabel(String name) {
    return 'නම: $name';
  }

  @override
  String emailLabel(String email) {
    return 'විද්‍යුත් තැපෑල: $email';
  }

  @override
  String phoneLabel(String phone) {
    return 'දුරකථනය: $phone';
  }

  @override
  String totalTripsLabel(int count) {
    return 'මුළු ගමන් වාර: $count';
  }

  @override
  String get feedbackDetails => 'ප්‍රතිපෝෂණ විස්තර';

  @override
  String get feedbackType => 'ප්‍රතිපෝෂණ වර්ගය';

  @override
  String get categoryLabel => 'ප්‍රවර්ගය';

  @override
  String get ratings => 'ශ්‍රේණිගත කිරීම්';

  @override
  String get comfort => 'පහසුව';

  @override
  String get cleanliness => 'පිරිසිදුකම';

  @override
  String get driverBehavior => 'රියදුරු හැසිරීම';

  @override
  String get vehicleCondition => 'වාහනයේ තත්ත්වය';

  @override
  String get feedbackContent => 'ප්‍රතිපෝෂණ අන්තර්ගතය';

  @override
  String get title => 'මාතෘකාව';

  @override
  String get description => 'විස්තරය';

  @override
  String get titleRequired => 'මාතෘකාව අවශ්‍ය වේ';

  @override
  String get descriptionRequired => 'විස්තරය අවශ්‍ය වේ';

  @override
  String get options => 'විකල්ප';

  @override
  String get priorityLow => 'අඩු';

  @override
  String get priorityMedium => 'මධ්‍යම';

  @override
  String get priorityHigh => 'ඉහළ';

  @override
  String get priorityUrgent => 'හදිසි';

  @override
  String get anonymousFeedback => 'නිර්නාමික ප්‍රතිපෝෂණය';

  @override
  String get anonymousFeedbackSubtitle => 'ඔබේ අනන්‍යතාවය හෙළි නොකරනු ඇත';

  @override
  String get busFeedback => 'බස් රථ ප්‍රතිපෝෂණය';

  @override
  String get driverFeedback => 'රියදුරු ප්‍රතිපෝෂණය';

  @override
  String get shareExperience => 'ඔබේ අත්දැකීම් බෙදා ගන්න';

  @override
  String get addPhotosVideos => 'ඡායාරූප හෝ වීඩියෝ එක් කරන්න (විකල්ප)';

  @override
  String get uploadMediaSubtitle =>
      'ඔබේ ප්‍රතිපෝෂණය වඩා හොඳින් පැහැදිලි කිරීමට පින්තූර හෝ වීඩියෝ උඩුගත කරන්න (උපරිම 10MB)';

  @override
  String get tapToSelectMedia => 'ඡායාරූප හෝ වීඩියෝ තෝරා ගැනීමට තට්ටු කරන්න';

  @override
  String get mediaFormatNote => 'PNG, JPG, MP4 (උපරිම 10MB)';

  @override
  String get cleanAndComfortable => 'පිරිසිදු හා සුවපහසු';

  @override
  String get goodCondition => 'හොඳ තත්ත්වයේ';

  @override
  String get acWorksWell => 'වායුසමීකරණය හොඳින් ක්‍රියා කරයි';

  @override
  String get seatsComfortable => 'ආසන සුවපහසුයි';

  @override
  String get needsCleaning => 'බස් රථය පිරිසිදු කිරීම අවශ්‍යයි';

  @override
  String get maintenanceRequired => 'නඩත්තු කිරීම අවශ්‍යයි';

  @override
  String get uncomfortableSeats => 'සුවපහසු නොවන ආසන';

  @override
  String get poorVentilation => 'වාතාශ්‍රය දුර්වලයි';

  @override
  String get excellentDriving => 'විශිෂ්ට රිය පැදවීම';

  @override
  String get courteousAndHelpful => 'Courteous and helpful';

  @override
  String get safeDriving => 'ආරක්ෂිත රිය පැදවීම';

  @override
  String get professionalBehavior => 'වෘත්තීය හැසිරීම';

  @override
  String get recklessDriving => 'නොසැලකිලිමත් ලෙස රිය පැදවීම';

  @override
  String get unprofessionalBehavior => 'වෘත්තීය නොවන හැසිරීම';

  @override
  String get poorCustomerService => 'දුර්වල පාරිභෝගික සේවය';

  @override
  String get safetyConcerns => 'ආරක්ෂක ගැටළු';

  @override
  String get locationInformation => 'ස්ථාන තොරතුරු';

  @override
  String get locationSubtitle =>
      'ඔබේ ස්ථානය ඔබේ ප්‍රතිපෝෂණයේ සන්දර්භය තේරුම් ගැනීමට අපට උපකාරී වේ';

  @override
  String get gettingLocation => 'ඔබේ ස්ථානය ලබා ගනිමින්...';

  @override
  String get locationCaptured => 'ස්ථානය සාර්ථකව ලබා ගන්නා ලදී';

  @override
  String get locationNotAvailable => 'ස්ථානය ලබා ගත නොහැක';

  @override
  String get needMoreHelp => 'වැඩිදුර සහාය අවශ්‍යද?';

  @override
  String get contactDirectlySubtitle =>
      'විශාල ලිපිගොනු හෝ සවිස්තරාත්මක සාකච්ඡා සඳහා, අපව කෙලින්ම සම්බන්ධ කරගන්න';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get overallExperience => 'ඔබේ සමස්ත අත්දැකීම කෙසේද?';

  @override
  String get veryPoor => 'ඉතා දුර්වලයි';

  @override
  String get average => 'සාමාන්‍ය';

  @override
  String get feedbackCategory => 'ප්‍රතිපෝෂණ වර්ගය';

  @override
  String get categoryGeneral => 'සාමාන්‍ය';

  @override
  String get categoryDriver => 'රියදුරු';

  @override
  String get categoryBusCondition => 'බස් රථයේ තත්ත්වය';

  @override
  String get categorySafety => 'ආරක්ෂාව';

  @override
  String get categoryRoute => 'මාර්ගය';

  @override
  String get categoryService => 'සේවාව';

  @override
  String get feedbackHint => 'ඔබේ අත්දැකීම ගැන අපට කියන්න...';

  @override
  String get feedbackRewardNote =>
      'ඔබේ ප්‍රතිපෝෂණය අපගේ සේවාව වැඩිදියුණු කිරීමට උපකාරී වේ\n✨ +1 ත්‍යාග ලකුණක් උපයන්න!';

  @override
  String get userNotAuthenticated => 'පරිශීලකයා තහවුරු කර නැත';

  @override
  String get feedbackSuccess => '✅ ඔබේ ප්‍රතිපෝෂණයට ස්තූතියි! +1 ත්‍යාග ලකුණක්';

  @override
  String feedbackError(String error) {
    return 'ප්‍රතිපෝෂණය ඉදිරිපත් කිරීමට අපොහොසත් විය: $error';
  }

  @override
  String busNumberLabel(String number) {
    return 'බස් $number';
  }

  @override
  String submittedOn(String date) {
    return 'ඉදිරිපත් කළේ: $date';
  }

  @override
  String get rateYourExperience => 'ඔබේ අත්දැකීම ශ්‍රේණිගත කරන්න';

  @override
  String get additionalComments => 'අමතර අදහස්';

  @override
  String get shareMoreDetails =>
      'ඔබේ අත්දැකීම ගැන වැඩි විස්තර බෙදා ගන්න (විකල්ප)';

  @override
  String get typeFeedbackHint => 'ඔබේ ප්‍රතිපෝෂණය මෙහි ටයිප් කරන්න...';

  @override
  String get feedbackSubmittedTitle => 'ප්‍රතිපෝෂණය ඉදිරිපත් කරන ලදී!';

  @override
  String get feedbackSubmittedSubtitle =>
      'ඔබේ ප්‍රතිපෝෂණයට ස්තූතියි. එය අපගේ සේවාව වැඩිදියුණු කිරීමට උපකාරී වේ.';

  @override
  String get submissionFailedTitle => 'ඉදිරිපත් කිරීම අසාර්ථකයි';

  @override
  String get submissionFailedSubtitle =>
      'ප්‍රතිපෝෂණය ඉදිරිපත් කිරීමට අපොහොසත් විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get uploadingMedia => 'මාධ්‍ය ගොනු උඩුගත වෙමින්...';

  @override
  String filesSelected(int count) {
    return 'ගොනු $count ක් උඩුගත කිරීම සඳහා තෝරා ගන්නා ලදී';
  }

  @override
  String get maxFilesReached => 'උපරිම ගොනු 10 කට අවසර ඇත';

  @override
  String fileExceedsLimit(String fileName) {
    return '$fileName ගොනුව 10MB සීමාව ඉක්මවා යයි';
  }

  @override
  String mediaUploadFailed(String error) {
    return 'මාධ්‍ය උඩුගත කිරීම අසාර්ථකයි: $error';
  }

  @override
  String pickMediaFailed(String error) {
    return 'මාධ්‍ය ගොනු තෝරා ගැනීමට අපොහොසත් විය: $error';
  }

  @override
  String couldNotLaunchUrl(String url) {
    return '$url විවෘත කිරීමට නොහැකි විය';
  }

  @override
  String errorLaunchingUrl(String error) {
    return 'URL විවෘත කිරීමේ දෝෂයකි: $error';
  }

  @override
  String get busFeedbackLabel => 'බස් රථ ප්‍රතිපෝෂණය';

  @override
  String get driverFeedbackLabel => 'රියදුරු ප්‍රතිපෝෂණය';

  @override
  String get rateBusExperience =>
      'බස් රථයේ සමස්ත තත්ත්වය සහ සුවපහසුව ඔබ ශ්‍රේණිගත කරන්නේ කෙසේද?';

  @override
  String get rateDriverExperience =>
      'රියදුරුගේ කාර්ය සාධනය සහ වෘත්තීයභාවය ඔබ ශ්‍රේණිගත කරන්නේ කෙසේද?';
}

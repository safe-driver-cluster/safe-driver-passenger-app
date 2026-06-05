// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'SafeDriver பயணி';

  @override
  String get appTagline => 'உங்கள் பாதுகாப்பு, எங்கள் முன்னுரிமை';

  @override
  String get login => 'உள்நுழை';

  @override
  String get signIn => 'உள்நுழைக';

  @override
  String get viewBus => 'பேருந்தைப் பார்';

  @override
  String get availableBuses => 'கிடைக்கக்கூடிய பேருந்துகள்';

  @override
  String get viewDriverDetails => 'ஓட்டுநர் விவரங்களைப் பார்';

  @override
  String get driverInformation => 'ஓட்டுநர் தகவல்';

  @override
  String get myTrips => 'எனது பயணங்கள்';

  @override
  String get viewHistory => 'வரலாற்றைப் பார்';

  @override
  String get emergencyHelp => 'அவசர உதவி';

  @override
  String get noRecentTrips => 'சமீபத்திய பயணங்கள் இல்லை';

  @override
  String get startFirstJourney =>
      'SafeDriver உடன் உங்கள் முதல் பயணத்தைத் தொடங்குங்கள்';

  @override
  String get verifyYourAccount => 'உங்கள் கணக்கைச் சரிபார்க்கவும்';

  @override
  String verificationCodeSent(String phoneNumber) {
    return 'சரிபார்ப்புக் குறியீட்டை இங்கே அனுப்பியுள்ளோம்\n$phoneNumber';
  }

  @override
  String get verifyAndCreateAccount => 'சரிபார்த்து கணக்கை உருவாக்கு';

  @override
  String get didntReceiveCode => 'குறியீடு கிடைக்கவில்லையா? ';

  @override
  String get resend => 'மீண்டும் அனுப்பு';

  @override
  String resendIn(int seconds) {
    return '$seconds வினாடிகளில் மீண்டும் அனுப்பு';
  }

  @override
  String get changePhoneNumber => 'தொலைபேசி எண்ணை மாற்று';

  @override
  String get accountCreatedSuccessfully =>
      'கணக்கு வெற்றிகரமாக உருவாக்கப்பட்டது!';

  @override
  String get accountCreatedAndVerified =>
      'கணக்கு வெற்றிகரமாக உருவாக்கப்பட்டு சரிபார்க்கப்பட்டது! உங்கள் நற்சான்றிதழ்களுடன் உள்நுழையவும்.';

  @override
  String get pleaseEnterCompleteOtp => 'முழுமையான OTP ஐ உள்ளிடவும்';

  @override
  String get verificationIdNotFound =>
      'சரிபார்ப்பு ஐடி கிடைக்கவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get otpSentSuccessfully => 'OTP வெற்றிகரமாக அனுப்பப்பட்டது';

  @override
  String get register => 'பதிவு செய்';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்து';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்ததா?';

  @override
  String get resetPassword => 'கடவுச்சொல்லை மீட்டமை';

  @override
  String get createAccount => 'கணக்கை உருவாக்கு';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get dontHaveAccount => 'கணக்கு இல்லையா?';

  @override
  String get loginSuccess => 'உள்நுழைவு வெற்றி';

  @override
  String get loginFailed => 'உள்நுழைவு தோல்வி';

  @override
  String get registrationSuccess => 'பதிவு வெற்றி';

  @override
  String get registrationFailed => 'பதிவு தோல்வி';

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
  String get otpVerification => 'OTP சரிபார்ப்பு';

  @override
  String get enterOTP => 'OTP ஐ உள்ளிடவும்';

  @override
  String get otpSent => 'OTP அனுப்பப்பட்டது';

  @override
  String get otpFailed => 'OTP அனுப்பத் தவறிவிட்டது';

  @override
  String get verificationFailed => 'சரிபார்ப்பு தோல்வி';

  @override
  String get emailValidationFailed =>
      'மின்னஞ்சல் சரிபார்ப்பு தோல்வியடைந்தது. உங்கள் மின்னஞ்சல் முகவரியைச் சரிபார்க்கவும்.';

  @override
  String get passwordValidationFailed =>
      'கடவுச்சொல் சரிபார்ப்பு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get accountAlreadyExists =>
      'இந்த மின்னஞ்சலில் ஏற்கனவே ஒரு கணக்கு உள்ளது.';

  @override
  String get resendOTP => 'OTP ஐ மீண்டும் அனுப்பு';

  @override
  String get otpExpired => 'OTP காலாவதியானது';

  @override
  String get invalidOTP => 'செல்லாத OTP';

  @override
  String get verifyOTP => 'OTP ஐச் சரிபார்';

  @override
  String get dashboard => 'டாஷ்போர்டு';

  @override
  String get safetyOverview => 'பாதுகாப்பு மேலோட்டம்';

  @override
  String get quickActions => 'விரைவான செயல்கள்';

  @override
  String get recentActivity => 'சமீபத்திய செயல்பாடு';

  @override
  String get activeJourney => 'செயலில் உள்ள பயணம்';

  @override
  String get noActiveJourney => 'செயலில் உள்ள பயணம் இல்லை';

  @override
  String get safetyScore => 'பாதுகாப்பு மதிப்பெண்';

  @override
  String get fleetStatus => 'கடற்படை நிலை';

  @override
  String get home => 'முகப்பு';

  @override
  String get search => 'தேடு';

  @override
  String get history => 'வரலாறு';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get busInformation => 'பேருந்து தகவல்';

  @override
  String get busDetails => 'பேருந்து விவரங்கள்';

  @override
  String get busNumber => 'பேருந்து எண்';

  @override
  String get routeNumber => 'வழித்தட எண்';

  @override
  String get driverName => 'ஓட்டுநர் பெயர்';

  @override
  String get currentLocation => 'தற்போதைய இருப்பிடம்';

  @override
  String get nextStop => 'அடுத்த நிறுத்தம்';

  @override
  String get estimatedArrival => 'மதிப்பிடப்பட்ட வருகை';

  @override
  String get passengerCapacity => 'பயணிகள் திறன்';

  @override
  String get busStatus => 'பேருந்து நிலை';

  @override
  String get liveTracking => 'நேரடி கண்காணிப்பு';

  @override
  String get trackBus => 'பேருந்தைக் கண்காணி';

  @override
  String get busHistory => 'பேருந்து வரலாறு';

  @override
  String get searchBus => 'பேருந்தைத் தேடு';

  @override
  String get scanQRCode => 'QR குறியீட்டை ஸ்கேன் செய்';

  @override
  String get driverProfile => 'ஓட்டுநர் சுயவிவரம்';

  @override
  String get driverHistory => 'ஓட்டுநர் வரலாறு';

  @override
  String get driverPerformance => 'ஓட்டுநர் செயல்திறன்';

  @override
  String get driverRating => 'ஓட்டுநர் மதிப்பீடு';

  @override
  String get driverExperience => 'அனுபவம்';

  @override
  String get driverLicense => 'உரிமம்';

  @override
  String get driverCertifications => 'சான்றிதழ்கள்';

  @override
  String get driverContact => 'தொடர்பு';

  @override
  String get driverStatus => 'ஓட்டுநர் நிலை';

  @override
  String get alertnessLevel => 'விழிப்புணர்வு நிலை';

  @override
  String get safety => 'பாதுகாப்பு';

  @override
  String get safetyAlerts => 'பாதுகாப்பு எச்சரிக்கைகள்';

  @override
  String get emergencyAlert => 'அவசர எச்சரிக்கை';

  @override
  String get hazardZones => 'ஆபத்தான மண்டலங்கள்';

  @override
  String get emergencyContacts => 'அவசர தொடர்புகள்';

  @override
  String get callEmergency => 'அவசர அழைப்பு';

  @override
  String get reportIncident => 'சம்பவத்தைப் புகாரளி';

  @override
  String get safetyTips => 'பாதுகாப்பு குறிப்புகள்';

  @override
  String get weatherWarning => 'வானிலை எச்சரிக்கை';

  @override
  String get roadConditions => 'சாலை நிலைமைகள்';

  @override
  String get trafficAlert => 'போக்குவரத்து எச்சரிக்கை';

  @override
  String get feedback => 'கருத்து';

  @override
  String get submitFeedback => 'கருத்தைச் சமர்ப்பி';

  @override
  String get feedbackHistory => 'கருத்து வரலாறு';

  @override
  String get rateBus => 'பேருந்தை மதிப்பிடு';

  @override
  String get rateDriver => 'ஓட்டுநரை மதிப்பிடு';

  @override
  String get reportProblem => 'சிக்கலைப் புகாரளி';

  @override
  String get suggestion => 'ஆலோசனை';

  @override
  String get complaint => 'புகார்';

  @override
  String get compliment => 'பாராட்டு';

  @override
  String get feedbackSubmitted => 'கருத்து வெற்றிகரமாகச் சமர்ப்பிக்கப்பட்டது';

  @override
  String get general => 'பொதுவானது';

  @override
  String get languageSettings => 'மொழி அமைப்புகள்';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடு';

  @override
  String get notificationSettings => 'அறிவிப்பு அமைப்புகள்';

  @override
  String get pushNotifications => 'புஷ் அறிவிப்புகள்';

  @override
  String get emailNotifications => 'மின்னஞ்சல் அறிவிப்புகள்';

  @override
  String get darkMode => 'இருண்ட பயன்முறை';

  @override
  String get autoMode => 'தானியங்கி பயன்முறை';

  @override
  String get lightMode => 'ஒளி பயன்முறை';

  @override
  String get fontSize => 'எழுத்து அளவு';

  @override
  String get privacy => 'தனியுரிமை';

  @override
  String get dataUsage => 'தரவு பயன்பாடு';

  @override
  String get location => 'இருப்பிடம்';

  @override
  String get account => 'கணக்கு';

  @override
  String get changePassword => 'கடவுச்சொல்லை மாற்று';

  @override
  String get deleteAccount => 'கணக்கை நீக்கு';

  @override
  String get save => 'சேமி';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get ok => 'சரி';

  @override
  String get or => 'அல்லது';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get noAccountFoundPhone =>
      'இந்தத் தொலைபேசி எண்ணுடன் எந்தக் கணக்கும் காணப்படவில்லை.';

  @override
  String get enterPhoneResetPassword =>
      'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும், உங்கள் கடவுச்சொல்லை மீட்டமைக்க ஒரு குறியீட்டை அனுப்புவோம்';

  @override
  String get sendOTP => 'OTP அனுப்பு';

  @override
  String get backToLogin => 'மீண்டும் உள்நுழைவுக்கு';

  @override
  String get pleaseEnterComplete6DigitOtp =>
      'முழுமையான 6 இலக்க OTP ஐ உள்ளிடவும்';

  @override
  String get invalidOtpTryAgain => 'செல்லாத OTP. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get sending => 'அனுப்பப்படுகிறது...';

  @override
  String get passwordResetSuccessful => 'கடவுச்சொல் மீட்டமைப்பு வெற்றி';

  @override
  String get passwordResetSuccessMessage =>
      'உங்கள் கடவுச்சொல் வெற்றிகரமாக மீட்டமைக்கப்பட்டது. இப்போது உங்கள் புதிய கடவுச்சொல்லுடன் உள்நுழையலாம்.';

  @override
  String get goToSignIn => 'உள்நுழைவுக்குச் செல்';

  @override
  String get passwordResetSuccessLoginMessage =>
      'கடவுச்சொல் மீட்டமைப்பு வெற்றி. உங்கள் புதிய கடவுச்சொல்லுடன் உள்நுழையவும்.';

  @override
  String get newPassword => 'புதிய கடவுச்சொல்';

  @override
  String get passwordRequirements => 'கடவுச்சொல் தேவைகள்:';

  @override
  String get passwordReq1 => '• குறைந்தது 8 எழுத்துக்கள் நீளம்';

  @override
  String get passwordReq2 => '• பெரிய மற்றும் சிறிய எழுத்துக்களைக் கொண்டுள்ளது';

  @override
  String get passwordReq3 => '• குறைந்தது ஒரு எண்ணைக் கொண்டுள்ளது';

  @override
  String get backToSignIn => 'மீண்டும் உள்நுழைவுக்கு';

  @override
  String get verifyYourPhone => 'உங்கள் தொலைபேசியைச் சரிபார்க்கவும்';

  @override
  String get enterVerificationCode => 'சரிபார்ப்புக் குறியீட்டை உள்ளிடவும்';

  @override
  String get type6DigitCode =>
      'நாங்கள் உங்களுக்கு அனுப்பிய 6 இலக்கக் குறியீட்டைத் தட்டச்சு செய்யவும்';

  @override
  String get verifyCode => 'குறியீட்டைச் சரிபார்';

  @override
  String otpSentTo(String phoneNumber) {
    return 'OTP வெற்றிகரமாக $phoneNumber க்கு அனுப்பப்பட்டது';
  }

  @override
  String get createStrongNewPassword =>
      'உங்கள் கணக்கிற்கு வலுவான புதிய கடவுச்சொல்லை உருவாக்கவும்';

  @override
  String get enterYourPhoneNumber => 'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get sendVerificationCodeViaSMS =>
      'SMS மூலம் சரிபார்ப்புக் குறியீட்டை அனுப்புவோம்';

  @override
  String get enterSriLankanMobile => 'உங்கள் இலங்கை மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get sendVerificationCode => 'சரிபார்ப்புக் குறியீட்டை அனுப்பு';

  @override
  String get smsAgreement =>
      'தொடர்வதன் மூலம், சரிபார்ப்பு நோக்கங்களுக்காக SafeDriver இலிருந்து SMS செய்திகளைப் பெற ஒப்புக்கொள்கிறீர்கள். செய்தி மற்றும் தரவு கட்டணங்கள் விதிக்கப்படலாம்.';

  @override
  String get phoneHint => '77 123 4567';

  @override
  String get orContinueWith => 'அல்லது இதனுடன் தொடரவும்';

  @override
  String get emailAndPassword => 'மின்னஞ்சல் மற்றும் கடவுச்சொல்';

  @override
  String get invalidSriLankanPhone =>
      'தயவுசெய்து சரியான இலங்கை தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get done => 'முடிந்தது';

  @override
  String get next => 'அடுத்து';

  @override
  String get previous => 'முந்தைய';

  @override
  String get skip => 'தவிர்';

  @override
  String get retry => 'மீண்டும் முயற்சி';

  @override
  String get refresh => 'புதுப்பி';

  @override
  String get loading => 'ஏற்றப்படுகிறது...';

  @override
  String get updating => 'புதுப்பிக்கப்படுகிறது...';

  @override
  String get searching => 'தேடப்படுகிறது...';

  @override
  String get processing => 'செயலாக்கப்படுகிறது...';

  @override
  String get male => 'ஆண்';

  @override
  String get female => 'பெண்';

  @override
  String get other => 'மற்றவை';

  @override
  String get preferNotToSay => 'கூற விரும்பவில்லை';

  @override
  String get manageSosContacts =>
      'அவசர எச்சரிக்கைகளுக்கான SOS தொடர்புகளை நிர்வகிக்கவும்';

  @override
  String get manage => 'நிர்வகி';

  @override
  String errorSelectingImage(String error) {
    return 'படம் தேர்ந்தெடுப்பதில் பிழை: $error';
  }

  @override
  String errorSavingProfile(String error) {
    return 'சுயவிவரத்தைச் சேமிப்பதில் பிழை: $error';
  }

  @override
  String errorLoadingProfile(String error) {
    return 'சுயவிவரத்தை ஏற்றுவதில் பிழை: $error';
  }

  @override
  String get error => 'பிழை';

  @override
  String get errorOccurred => 'ஒரு பிழை ஏற்பட்டது';

  @override
  String get networkError => 'பிணைய பிழை';

  @override
  String get serverError => 'சர்வர் பிழை';

  @override
  String get connectionTimeout => 'இணைப்பு நேரம் முடிந்தது';

  @override
  String get noInternetConnection => 'இணைய இணைப்பு இல்லை';

  @override
  String get dataMissing => 'தரவு இல்லை';

  @override
  String get invalidInput => 'செல்லாத உள்ளீடு';

  @override
  String get requiredField => 'இந்தப் புலம் கட்டாயமானது';

  @override
  String get tryAgainLater =>
      'தயவுசெய்து சிறிது நேரம் கழித்து மீண்டும் முயற்சிக்கவும்';

  @override
  String get success => 'வெற்றி';

  @override
  String get operationSuccessful => 'செயல்பாடு வெற்றி';

  @override
  String get dataSaved => 'தரவு வெற்றிகரமாகச் சேமிக்கப்பட்டது';

  @override
  String get dataUpdated => 'தரவு வெற்றிகரமாகப் புதுப்பிக்கப்பட்டது';

  @override
  String get dataDeleted => 'தரவு வெற்றிகரமாக நீக்கப்பட்டது';

  @override
  String get noData => 'தரவு எதுவும் இல்லை';

  @override
  String get noResults => 'முடிவுகள் எதுவும் இல்லை';

  @override
  String get noBuses => 'பேருந்துகள் எதுவும் இல்லை';

  @override
  String get noDrivers => 'ஓட்டுநர்கள் எதுவும் இல்லை';

  @override
  String get noNotifications => 'அறிவிப்புகள் இல்லை';

  @override
  String get noHistory => 'வரலாறு எதுவும் இல்லை';

  @override
  String get noFeedback => 'கருத்து எதுவும் சமர்ப்பிக்கப்படவில்லை';

  @override
  String get noAlerts => 'செயலில் உள்ள எச்சரிக்கைகள் இல்லை';

  @override
  String get today => 'இன்று';

  @override
  String get yesterday => 'நேற்று';

  @override
  String get tomorrow => 'நாளை';

  @override
  String get thisWeek => 'இந்த வாரம்';

  @override
  String get lastWeek => 'கடந்த வாரம்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get lastMonth => 'கடந்த மாதம்';

  @override
  String get minutes => 'நிமிடங்கள்';

  @override
  String get hours => 'மணிநேரம்';

  @override
  String get days => 'நாட்கள்';

  @override
  String get weeks => 'வாரங்கள்';

  @override
  String get months => 'மாதங்கள்';

  @override
  String get emailRequired => 'மின்னஞ்சல் தேவை';

  @override
  String get passwordRequired => 'கடவுச்சொல் தேவை';

  @override
  String get invalidEmail => 'செல்லாத மின்னஞ்சல் வடிவம்';

  @override
  String get passwordTooShort =>
      'கடவுச்சொல் குறைந்தது 8 எழுத்துக்கள் இருக்க வேண்டும்';

  @override
  String get passwordsDoNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get phoneRequired => 'தொலைபேசி எண் தேவை';

  @override
  String get invalidPhone => 'செல்லாத தொலைபேசி எண்';

  @override
  String get nameRequired => 'பெயர் தேவை';

  @override
  String get firstNameRequired => 'முதல் பெயர் தேவை';

  @override
  String get lastNameRequired => 'குடும்பப் பெயர் தேவை';

  @override
  String get firstNameMinLength =>
      'முதல் பெயர் குறைந்தது 2 எழுத்துக்கள் இருக்க வேண்டும்';

  @override
  String get lastNameMinLength =>
      'குடும்பப் பெயர் குறைந்தது 2 எழுத்துக்கள் இருக்க வேண்டும்';

  @override
  String get passwordComplexity =>
      'கடவுச்சொல்லில் பெரிய எழுத்து, சிறிய எழுத்து மற்றும் எண் இருக்க வேண்டும்';

  @override
  String get confirmPasswordRequired =>
      'தயவுசெய்து உங்கள் கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get acceptTerms =>
      'தயவுசெய்து விதிமுறைகள் மற்றும் நிபந்தனைகளை ஏற்கவும்';

  @override
  String get welcomeTitle => 'SafeDriver க்கு உங்களை வரவேற்கிறோம்';

  @override
  String get onboarding1Title => 'பாதுகாப்பான மற்றும் நம்பகமான போக்குவரத்து';

  @override
  String get onboarding1Description =>
      'மிகவும் பாதுகாப்பான மற்றும் நம்பகமான போக்குவரத்து சேவையை அனுபவிக்கவும். தொழில்முறை பயிற்சி பெற்ற ஓட்டுநர்களுடன் உங்கள் பாதுகாப்பு எங்களின் முதன்மையான முன்னுரிமையாகும்.';

  @override
  String get onboarding2Title => 'நேரடி கண்காணிப்பு';

  @override
  String get onboarding2Description =>
      'உங்கள் பயணத்தை நேரலையில் கண்காணிக்கவும் மற்றும் நேரடி இருப்பிட அறிவிப்புகளுடன் இணைந்திருக்கவும். ஒவ்வொரு கணமும் உங்கள் பயணம் எங்கே இருக்கிறது என்பதைத் துல்லியமாக அறிந்து கொள்ளுங்கள்.';

  @override
  String get onboarding3Title => 'புத்திசாலித்தனமான கருத்து அமைப்பு';

  @override
  String get onboarding3Description =>
      'உங்கள் அனுபவத்தைப் பகிர்ந்து கொள்ளுங்கள் மற்றும் மிக உயர்ந்த சேவைத் தரத்தைப் பராமரிக்க எங்களுக்கு உதவுங்கள். உங்கள் கருத்து ஒவ்வொரு பயணத்தையும் சிறப்பாக்குகிறது.';

  @override
  String get getStarted => 'தொடங்குவோம்';

  @override
  String get about => 'பற்றி';

  @override
  String get version => 'பதிப்பு';

  @override
  String get privacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get termsOfService => 'சேவை விதிமுறைகள்';

  @override
  String get contactSupport => 'ஆதரவைத் தொடர்பு கொள்ளவும்';

  @override
  String get rateApp => 'செயலியை மதிப்பிடவும்';

  @override
  String get shareApp => 'செயலியைப் பகிரவும்';

  @override
  String get legal => 'சட்டபூர்வமானது';

  @override
  String get licenses => 'உரிமங்கள்';

  @override
  String get emergency => 'அவசரம்';

  @override
  String get police => 'காவல்துறை';

  @override
  String get medical => 'மருத்துவம்';

  @override
  String get fire => 'தீயணைப்புத் துறை';

  @override
  String get callNow => 'இப்போதே அழை';

  @override
  String get emergencyHotline => 'அவசர அழைப்பு எண்';

  @override
  String get policeStation => 'காவல் நிலையம்';

  @override
  String get hospital => 'மருத்துவமனை';

  @override
  String get fireStation => 'தீயணைப்பு நிலையம்';

  @override
  String get alwaysWearSeatbelt =>
      'எப்போதும் உங்கள் இருக்கை பட்டையை அணியுங்கள்';

  @override
  String get stayAlert =>
      'விழிப்புடன் இருங்கள் மற்றும் உங்கள் சுற்றுப்புறத்தைப் பற்றி அறிந்து கொள்ளுங்கள்';

  @override
  String get keepEmergencyContacts =>
      'அவசர தொடர்புகளை எளிதில் கிடைக்கக்கூடியதாக வைத்திருங்கள்';

  @override
  String get reportSuspiciousActivity =>
      'சந்தேகத்திற்கிடமான எந்தவொரு செயல்பாட்டையும் உடனடியாகப் புகாரளிக்கவும்';

  @override
  String get followBusSafety =>
      'பேருந்து பாதுகாப்பு நெறிமுறைகள் மற்றும் ஓட்டுநர் வழிமுறைகளைப் பின்பற்றவும்';

  @override
  String get close => 'மூடு';

  @override
  String get bookTicket => 'டிக்கெட் முன்பதிவு செய்';

  @override
  String get comingSoon => 'விரைவில் எதிர்பார்க்கலாம்';

  @override
  String get trackLive => 'நேரலையில் கண்காணி';

  @override
  String get share => 'பகிர்';

  @override
  String get shareFunctionality => 'பகிர்தல் செயல்பாடு செயல்படுத்தப்படும்';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get sinhala => 'සිංහල';

  @override
  String get tamil => 'தமிழ்';

  @override
  String reportedBy(String name) {
    return 'புகாரளித்தவர்: $name';
  }

  @override
  String busIdLabel(String busId) {
    return 'பேருந்து ஐடி: $busId';
  }

  @override
  String driverIdLabel(String driverId) {
    return 'ஓட்டுநர் ஐடி: $driverId';
  }

  @override
  String get language => 'மொழி';

  @override
  String get systemDefault => 'கணினி இயல்புநிலை';

  @override
  String get acknowledge => 'ஏற்றுக்கொள்';

  @override
  String get viewDetails => 'விவரங்களைப் பார்';

  @override
  String get viewProfile => 'சுயவிவரத்தைப் பார்';

  @override
  String get contact => 'தொடர்பு கொள்';

  @override
  String get viewAll => 'அனைத்தையும் பார்';

  @override
  String get scanQR => 'QR ஸ்கேன் செய்';

  @override
  String get tryAgain => 'மீண்டும் முயற்சி';

  @override
  String get goBack => 'பின்னால் செல்';

  @override
  String get openSettings => 'அமைப்புகளைத் திற';

  @override
  String get details => 'விவரங்கள்';

  @override
  String get track => 'கண்காணி';

  @override
  String get safetyTipsTitle => 'பாதுகாப்பு குறிப்புகள்';

  @override
  String get safetyHub => 'பாதுகாப்பு மையம்';

  @override
  String get reportSafetyIssue => 'பாதுகாப்பு சிக்கலைப் புகாரளி';

  @override
  String get report => 'புகாரளி';

  @override
  String get gotIt => 'புரிந்தது';

  @override
  String get safetyAlertsTitle => 'பாதுகாப்பு எச்சரிக்கைகள்';

  @override
  String get reportIncidentTitle => 'சம்பவத்தைப் புகாரளி';

  @override
  String get hazardZonesTitle => 'ஆபத்தான மண்டலங்கள்';

  @override
  String get emergencyContactsTitle => 'அவசர தொடர்புகள்';

  @override
  String get enterCodeManually => 'குறியீட்டை கைமுறையாக உள்ளிடவும்';

  @override
  String qrCodeDetected(String code) {
    return 'QR குறியீடு கண்டறியப்பட்டது: $code';
  }

  @override
  String get signOut => 'வெளியேறு';

  @override
  String get areYouSureSignOut => 'நிச்சயமாக வெளியேற வேண்டுமா?';

  @override
  String get tripHistory => 'பயண வரலாறு';

  @override
  String get review => 'மதிப்பாய்வு';

  @override
  String tripDetails(String id) {
    return 'பயணம் $id';
  }

  @override
  String get giveFeedback => 'கருத்து தெரிவிக்கவும்';

  @override
  String get comingSoonFeature =>
      'இந்த அம்சம் எதிர்கால புதுப்பிப்பில் கிடைக்கும்.';

  @override
  String get clearCache => 'தற்காலிக சேமிப்பை அழி';

  @override
  String get cacheClearedSuccessfully =>
      'தற்காலிக சேமிப்பு வெற்றிகரமாக அழிக்கப்பட்டது!';

  @override
  String get clear => 'அழி';

  @override
  String get profileTitle => 'சுயவிவரம்';

  @override
  String get profileUpdatedSuccessfully =>
      'சுயவிவரம் வெற்றிகரமாகப் புதுப்பிக்கப்பட்டது';

  @override
  String failedToUpdateProfile(String error) {
    return 'சுயவிவரத்தைப் புதுப்பிக்கத் தவறிவிட்டது: $error';
  }

  @override
  String get myProfile => 'எனது சுயவிவரம்';

  @override
  String get noProfileFound => 'சுயவிவரம் எதுவும் காணப்படவில்லை';

  @override
  String get viewFAQ => 'FAQ ஐப் பார்';

  @override
  String get changePicture => 'படத்தை மாற்று';

  @override
  String get profileUpdated => 'சுயவிவரம் வெற்றிகரமாகப் புதுப்பிக்கப்பட்டது!';

  @override
  String get aboutTitle => 'பற்றி';

  @override
  String get pageNotFound => 'பக்கம் காணப்படவில்லை';

  @override
  String get searchFunctionalityComingSoon => 'தேடல் செயல்பாடு விரைவில்!';

  @override
  String get busRoutesComingSoon => 'பேருந்து வழித்தடங்கள் விரைவில்!';

  @override
  String get navigationComingSoon => 'வழிசெலுத்தல் விரைவில்!';

  @override
  String selected(String description) {
    return 'தேர்ந்தெடுக்கப்பட்டது: $description';
  }

  @override
  String placeLookupFailed(String error) {
    return 'இடத்தைத் தேடுவதில் தோல்வி: $error';
  }

  @override
  String foundBusStopsNearby(int count) {
    return 'அருகில் $count பேருந்து நிறுத்தங்கள் காணப்பட்டன';
  }

  @override
  String foundQueryTapNavigate(String query) {
    return '\"$query\" காணப்பட்டது. பேருந்து வழித்தடத்தைப் பார்க்க Navigate ஐத் தட்டவும்!';
  }

  @override
  String searchFailed(String error) {
    return 'தேடல் தோல்வியடைந்தது: $error';
  }

  @override
  String get unableToGetCurrentLocation =>
      'தற்போதைய இருப்பிடத்தைப் பெற முடியவில்லை';

  @override
  String get pleaseSearchForDestination =>
      'தயவுசெய்து முதலில் ஒரு இலக்கைத் தேடவும்';

  @override
  String errorSelectingLanguage(String error) {
    return 'மொழியைத் தேர்ந்தெடுப்பதில் பிழை: $error';
  }

  @override
  String get hazardZoneIntelligence => 'ஆபத்தான மண்டல நுண்ணறிவு';

  @override
  String get loadingHazardZoneData => 'ஆபத்தான மண்டல தரவு ஏற்றப்படுகிறது...';

  @override
  String get driverIdRequiredForAlerts =>
      'எச்சரிக்கைகளைப் பார்க்க ஓட்டுநர் ஐடி தேவை';

  @override
  String get noActiveHazardAlerts => 'செயலில் உள்ள ஆபத்தான எச்சரிக்கைகள் இல்லை';

  @override
  String get reviewsTitle => 'மதிப்பாய்வுகள்';

  @override
  String get back => 'பின்னால்';

  @override
  String get addMedia => 'ஊடகத்தைச் சேர்';

  @override
  String get takePhoto => 'புகைப்படம் எடு';

  @override
  String get chooseFromGallery => 'கேலரியில் இருந்து தேர்ந்தெடு';

  @override
  String fileTooLarge(String fileName) {
    return '$fileName மிகவும் பெரியது. அதிகபட்ச அளவு 10MB ஆகும்.';
  }

  @override
  String get locationPermissionRequired =>
      'இருப்பிடத்தைப் பகிர இருப்பிட அனுமதி தேவை';

  @override
  String failedToGetLocation(String error) {
    return 'இருப்பிடத்தைப் பெறத் தவறிவிட்டது: $error';
  }

  @override
  String get incidentReportingImplemented =>
      'சம்பவப் புகாரளிப்பு செயல்படுத்தப்படும்';

  @override
  String get priority => 'முன்னுரிமை';

  @override
  String get low => 'குறைந்த';

  @override
  String get medium => 'நடுத்தர';

  @override
  String get high => 'உயர்';

  @override
  String get urgent => 'அவசரம்';

  @override
  String get submitAnonymously => 'அநாமதேயமாகச் சமர்ப்பிக்கவும்';

  @override
  String get personalInfoNotShared => 'உங்கள் தனிப்பட்ட தகவல்கள் பகிரப்படாது';

  @override
  String get chooseYourLanguage => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectYourPreferredLanguage =>
      'தொடர உங்களுக்கு விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get availableLanguages => 'கிடைக்கக்கூடிய மொழிகள்';

  @override
  String get continueButton => 'தொடரவும்';

  @override
  String get continueWithGoogle => 'Google உடன் தொடரவும்';

  @override
  String get profilePageComingSoon => 'சுயவிவரப் பக்கம் - விரைவில்';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get loadingProfile => 'சுயவிவரம் ஏற்றப்படுகிறது...';

  @override
  String get profilePicture => 'சுயவிவரப் படம்';

  @override
  String get basicInformation => 'அடிப்படைத் தகவல்';

  @override
  String get emailAddress => 'மின்னஞ்சல் முகவரி';

  @override
  String get noEmail => 'மின்னஞ்சல் இல்லை';

  @override
  String get firstName => 'முதல் பெயர்';

  @override
  String get lastName => 'குடும்பப் பெயர்';

  @override
  String get dateOfBirth => 'பிறந்த தேதி';

  @override
  String get gender => 'பாலினம்';

  @override
  String get addressInformation => 'முகவரி தகவல்';

  @override
  String get streetAddress => 'தெரு முகவரி';

  @override
  String get city => 'நகரம்';

  @override
  String get state => 'மாநிலம்';

  @override
  String get zipCode => 'அஞ்சல் குறியீடு';

  @override
  String get country => 'நாடு';

  @override
  String get emergencyContact => 'அவசர தொடர்பு';

  @override
  String get contactName => 'தொடர்பு பெயர்';

  @override
  String get relationship => 'உறவு';

  @override
  String get preferences => 'விருப்பங்கள்';

  @override
  String get cameraError => 'கேமரா பிழை';

  @override
  String get positionQrCode => 'QR குறியீட்டை இங்கே வைக்கவும்';

  @override
  String get qrScanner => 'QR ஸ்கேனர்';

  @override
  String get scanQrInstruction =>
      'பேருந்து அல்லது நிறுத்தத்தில் உள்ள QR குறியீட்டை ஸ்கேன் செய்யவும்';

  @override
  String get alignQrInstruction =>
      'அசையாமல் பிடித்து QR குறியீட்டை சட்டத்திற்குள் சீரமைக்கவும்';

  @override
  String get enterBusStopCode =>
      'பேருந்து அல்லது நிறுத்தக் குறியீட்டை உள்ளிடவும்';

  @override
  String get submit => 'சமர்ப்பி';

  @override
  String get mapsNavigation => 'வரைபடங்கள் மற்றும் வழிசெலுத்தல்';

  @override
  String get searchDestination => 'இலக்கைத் தேடு...';

  @override
  String get busStop => 'பேருந்து நிறுத்தம்';

  @override
  String get navigate => 'வழிசெலுத்து';

  @override
  String get yourLocation => 'உங்கள் இருப்பிடம்';

  @override
  String get currentPosition => 'தற்போதைய நிலை';

  @override
  String get unableToLoadMap => 'வரைபடத்தை ஏற்ற முடியவில்லை';

  @override
  String get loadingMap => 'வரைபடம் ஏற்றப்படுகிறது...';

  @override
  String get busRouteToDestination => 'இலக்கிற்கான பேருந்து வழித்தடம்';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String languageChanged(String language) {
    return 'மொழி $language ஆக மாற்றப்பட்டது';
  }

  @override
  String failedToChangeLanguage(String error) {
    return 'மொழியை மாற்றத் தவறிவிட்டது: $error';
  }

  @override
  String tripId(String tripId) {
    return 'பயண ஐடி: $tripId';
  }

  @override
  String get safetyFirst => 'பாதுகாப்பு முதலில்';

  @override
  String get safetyDescription =>
      'உங்கள் பாதுகாப்பு எங்களின் முதன்மையான முன்னுரிமையாகும். அவசர அம்சங்களை அணுகவும், சம்பவங்களைப் புகாரளிக்கவும் மற்றும் பாதுகாப்பு நடவடிக்கைகள் குறித்து அறிந்து கொள்ளவும்.';

  @override
  String get emergencyActions => 'அவசர நடவடிக்கைகள்';

  @override
  String get callForHelp => 'உதவிக்கு அழைக்கவும்';

  @override
  String get reportIssue => 'சிக்கலைப் புகாரளி';

  @override
  String get safetyFeatures => 'பாதுகாப்பு அம்சங்கள்';

  @override
  String get realTimeSafetyNotifications => 'நேரடி பாதுகாப்பு அறிவிப்புகள்';

  @override
  String get viewKnownHazardousAreas =>
      'அறியப்பட்ட ஆபத்தான பகுதிகளைப் பார்க்கவும்';

  @override
  String get learnSafetyBestPractices =>
      'பாதுகாப்பு சிறந்த நடைமுறைகளைக் கற்றுக்கொள்ளுங்கள்';

  @override
  String get support => 'ஆதரவு';

  @override
  String get reportSafetyDialogContent =>
      'பாதுகாப்புச் சம்பவம் அல்லது கவலையைப் புகாரளிக்க விரும்புகிறீர்களா?';

  @override
  String get safetyTip1 => '• எப்போதும் உங்கள் இருக்கை பட்டையை அணியுங்கள்';

  @override
  String get safetyTip2 =>
      '• விழிப்புடன் இருங்கள் மற்றும் உங்கள் சுற்றுப்புறத்தைப் பற்றி அறிந்து கொள்ளுங்கள்';

  @override
  String get safetyTip3 =>
      '• அவசர தொடர்புகளை எளிதில் கிடைக்கக்கூடியதாக வைத்திருங்கள்';

  @override
  String get safetyTip4 =>
      '• சந்தேகத்திற்கிடமான எந்தவொரு செயல்பாட்டையும் உடனடியாகப் புகாரளிக்கவும்';

  @override
  String get safetyTip5 =>
      '• பேருந்து பாதுகாப்பு நெறிமுறைகள் மற்றும் ஓட்டுநர் வழிமுறைகளைப் பின்பற்றவும்';

  @override
  String get iAgreeTo => 'நான் இதற்கு ஒப்புக்கொள்கிறேன் ';

  @override
  String get and => ' மற்றும் ';

  @override
  String errorOccurredGeneric(String error) {
    return 'பிழை: $error';
  }

  @override
  String get goodMorning => 'காலை வணக்கம்';

  @override
  String get goodAfternoon => 'மதிய வணக்கம்';

  @override
  String get goodEvening => 'மாலை வணக்கம்';

  @override
  String get goodNight => 'இரவு வணக்கம்';

  @override
  String get traveler => 'பயணி';

  @override
  String get rememberMe => 'என்னை நினைவில் கொள்க';

  @override
  String get dismiss => 'நிராகரி';

  @override
  String get activeBuses => 'செயலில் உள்ள பேருந்துகள்';

  @override
  String activeBusesCount(Object count) {
    return '$count செயலில் உள்ள பேருந்துகள்';
  }

  @override
  String safetyScoreLabel(Object score) {
    return 'பாதுகாப்பு மதிப்பெண்: $score%';
  }

  @override
  String driversCount(Object count) {
    return '$count ஓட்டுநர்கள்';
  }

  @override
  String hazardZonesCount(Object count) {
    return '$count ஆபத்தான மண்டலங்கள்';
  }

  @override
  String get busQrScanned => 'பேருந்து QR குறியீடு ஸ்கேன் செய்யப்பட்டது';

  @override
  String get safetyAlertAcknowledged => 'பாதுகாப்பு எச்சரிக்கை ஏற்கப்பட்டது';

  @override
  String get newHazardZoneReported =>
      'புதிய ஆபத்தான மண்டலம் புகாரளிக்கப்பட்டது';

  @override
  String timeAgo(Object time) {
    return '$time முன்பு';
  }

  @override
  String get poweredBy => 'SafeDriver Technologies மூலம் இயக்கப்படுகிறது';

  @override
  String get addSosContact => 'SOS தொடர்பைச் சேர்';

  @override
  String get editSosContact => 'SOS தொடர்பைத் திருத்து';

  @override
  String get removeSosContact => 'SOS தொடர்பை நீக்கு';

  @override
  String areYouSureRemoveContact(Object name) {
    return 'நிச்சயமாக $name ஐ உங்கள் SOS தொடர்புகளிலிருந்து நீக்க வேண்டுமா?';
  }

  @override
  String get contactNameLabel => 'தொடர்பு பெயர்';

  @override
  String get contactNameHint => 'உதாரணம்: அம்மா, அப்பா, துணைவர்';

  @override
  String get relationshipLabel => 'உறவு';

  @override
  String get relationshipHint => 'உதாரணம்: பெற்றோர், நண்பர்';

  @override
  String get alertMethods => 'Alert Methods';

  @override
  String get autoSendSos => 'தானியங்கி SOS அனுப்புதல்';

  @override
  String get autoSendSosDescription =>
      'அனைத்து தொடர்புகளுக்கும் தானாகவே எச்சரிக்கைகளை அனுப்பு';

  @override
  String get sosContactsDescription =>
      'உங்கள் நேரடி இருப்பிடத்துடன் SMS மற்றும் WhatsApp மூலம் உங்கள் SOS எச்சரிக்கைகளைப் பெறும் நம்பகமான தொடர்புகளைச் சேர்க்கவும்.';

  @override
  String get noSosContactsYet => 'SOS தொடர்புகள் இன்னும் இல்லை';

  @override
  String get addYourFirstContact => 'உங்கள் முதல் தொடர்பைச் சேர்க்கவும்';

  @override
  String get mySosContacts => 'எனது SOS தொடர்புகள்';

  @override
  String sosContactsCount(Object count) {
    return '$count தொடர்புகள்';
  }

  @override
  String get sms => 'SMS';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get onDuty => 'பணியில்';

  @override
  String get offDuty => 'பணியில் இல்லை';

  @override
  String get onBreak => 'ஓய்வில்';

  @override
  String get unknown => 'தெரியவில்லை';

  @override
  String experienceYears(Object years) {
    return '$years ஆண்டுகள்';
  }

  @override
  String get joined => 'சேர்ந்தது';

  @override
  String get license => 'உரிமம்';

  @override
  String get model => 'மாதிரி';

  @override
  String get searchBusesHint =>
      'பேருந்து எண், வழித்தடம், ஓட்டுநர் மூலம் தேடு...';

  @override
  String get searchDriversHint => 'பெயர், உரிமம், வழித்தடம் மூலம் தேடு...';

  @override
  String get searchPlacesHint => 'இடங்கள், பேருந்து நிறுத்தங்களைத் தேடு...';

  @override
  String get noBusesAvailable => 'பேருந்துகள் எதுவும் இல்லை';

  @override
  String get checkBackLaterBuses =>
      'கிடைக்கக்கூடிய பேருந்துகளுக்குப் பிறகு மீண்டும் பார்க்கவும்';

  @override
  String get noMatchingDrivers => 'பொருந்தும் ஓட்டுநர்கள் இல்லை';

  @override
  String get tryDifferentSearch => 'வேறு தேடல் சொல்லை முயற்சிக்கவும்';

  @override
  String get locationServicesDisabled =>
      'இருப்பிடச் சேவைகள் முடக்கப்பட்டுள்ளன. இருப்பிடச் சேவைகளை இயக்கவும்.';

  @override
  String get locationPermissionDenied =>
      'இருப்பிட அனுமதி மறுக்கப்பட்டது. இருப்பிட அணுகலை வழங்கவும்.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'இருப்பிட அனுமதிகள் நிரந்தரமாக மறுக்கப்பட்டுள்ளன. அமைப்புகளில் அவற்றை இயக்கவும்.';

  @override
  String get noMatchingLocations => 'பொருந்தும் இடங்கள் எதுவும் காணப்படவில்லை';

  @override
  String get destination => 'இலக்கு';

  @override
  String get boardBus => 'பேருந்தில் ஏறவும்';

  @override
  String get leaveBus => 'பேருந்திலிருந்து இறங்கவும்';

  @override
  String get googleBusDirectionsUnavailable =>
      'Google பேருந்து வழிமுறைகள் கிடைக்கவில்லை. மதிப்பிடப்பட்ட சாலை வழித்தடம் காட்டப்படுகிறது.';

  @override
  String get distance => 'தூரம்';

  @override
  String get duration => 'காலம்';

  @override
  String get avgSpeed => 'சராசரி வேகம்';

  @override
  String get zoomIn => 'பெரிதாக்கு';

  @override
  String get zoomOut => 'சிறிதாக்கு';

  @override
  String get toggleMapType => 'வரைபட வகையை மாற்று';

  @override
  String get toggleTraffic => 'போக்குவரத்தைக் காட்டு';

  @override
  String get centerOnLocation => 'இருப்பிடத்தில் மையப்படுத்து';

  @override
  String stopsCount(Object count) {
    return '$count நிறுத்தங்கள்';
  }

  @override
  String get excellent => 'மிகச்சிறப்பு';

  @override
  String get good => 'நல்லது';

  @override
  String get fair => 'சராசரி';

  @override
  String get poor => 'மோசம்';

  @override
  String get critical => 'மிக மோசம்';

  @override
  String get healthRecord => 'சுகாதார பதிவு';

  @override
  String get lastMedicalCheck => 'கடைசி மருத்துவ பரிசோதனை';

  @override
  String get medicalStatus => 'மருத்துவ நிலை';

  @override
  String get healthy => 'ஆரோக்கியமான';

  @override
  String get healthIssues => 'சுகாதார சிக்கல்கள்';

  @override
  String get medicalExamDue => 'மருத்துவ பரிசோதனைக்கான தேதி';

  @override
  String get medicalConditions => 'மருத்துவ நிலைமைகள்';

  @override
  String get none => 'எதுவுமில்லை';

  @override
  String get performanceOverview => 'செயல்திறன் மேலோட்டம்';

  @override
  String get totalTrips => 'மொத்த பயணங்கள்';

  @override
  String get totalDistance => 'மொத்த தூரம்';

  @override
  String get punctuality => 'நேரம் தவறாமை';

  @override
  String get fuelEfficiency => 'எரிபொருள் திறன்';

  @override
  String get routeSpecializations => 'வழித்தட நிபுணத்துவம்';

  @override
  String get trainingHistory => 'பயிற்சி வரலாறு';

  @override
  String get noTrainingRecords => 'பயிற்சி பதிவுகள் எதுவும் இல்லை';

  @override
  String get passed => 'தேர்ச்சி';

  @override
  String get failed => 'தோல்வி';

  @override
  String get expires => 'காலாவதியாகிறது';

  @override
  String get active => 'செயலில்';

  @override
  String get expired => 'காலாவதியானது';

  @override
  String get personalInformation => 'தனிப்பட்ட தகவல்';

  @override
  String get currentStatus => 'தற்போதைய நிலை';

  @override
  String get currentBus => 'தற்போதைய பேருந்து';

  @override
  String get currentRoute => 'தற்போதைய வழித்தடம்';

  @override
  String get alertness => 'விழிப்புணர்வு';

  @override
  String get mainFeatures => 'முக்கிய அம்சங்கள்';

  @override
  String get qrScannerDescription =>
      'உடனடி தகவலைப் பெற பேருந்து QR குறியீடுகளை ஸ்கேன் செய்யவும்';

  @override
  String get liveTrackingDescription =>
      'வரைபடங்களுடன் நிகழ்நேர பேருந்து இருப்பிடக் கண்காணிப்பு';

  @override
  String get driverInfoDescription =>
      'விரிவான ஓட்டுநர் தகவல் மற்றும் செயல்திறன்';

  @override
  String get hazardZonesDescription =>
      'ஆபத்தான பகுதிகள் மற்றும் பாதுகாப்பு எச்சரிக்கைகளைக் கண்காணிக்கவும்';

  @override
  String get quickStats => 'விரைவான புள்ளிவிவரங்கள்';

  @override
  String get appDescription =>
      'உங்கள் விரிவான பேருந்து பாதுகாப்பு கண்காணிப்பு தளம்';

  @override
  String get driverInfo => 'ஓட்டுநர் தகவல்';

  @override
  String get drivers => 'ஓட்டுநர்கள்';

  @override
  String get verifiedMember => 'சரிபார்க்கப்பட்ட உறுப்பினர்';

  @override
  String get updateInfo => 'தகவலைப் புதுப்பிக்கவும்';

  @override
  String get viewTrips => 'பயணங்களைப் பார்க்கவும்';

  @override
  String get yourFeedback => 'உங்கள் கருத்து';

  @override
  String get getHelp => 'உதவி பெறவும்';

  @override
  String get accountAndSettings => 'கணக்கு மற்றும் அமைப்புகள்';

  @override
  String get notProvided => 'வழங்கப்படவில்லை';

  @override
  String get appSettings => 'செயலி அமைப்புகள்';

  @override
  String get aboutApp => 'செயலி பற்றி';

  @override
  String get unableToLoadProfile => 'சுயவிவரத்தை ஏற்ற முடியவில்லை';

  @override
  String get shareFeedback => 'கருத்தைப் பகிரவும்';

  @override
  String get feedbackSubtitle =>
      'உங்கள் அனுபவத்தை மேம்படுத்த எங்களுக்கு உதவுங்கள்';

  @override
  String get tripInformation => 'பயணத் தகவல்';

  @override
  String get busIdTitle => 'பேருந்து ஐடி';

  @override
  String get tripIdTitle => 'பயண ஐடி';

  @override
  String get rateExperience => 'உங்கள் அனுபவத்தை மதிப்பிடுங்கள்';

  @override
  String get noFeedbackYet => 'கருத்துகள் இன்னும் இல்லை';

  @override
  String get noFeedbackSubtitle =>
      'தொடங்குவதற்கு பேருந்துகள் மற்றும் ஓட்டுநர்கள் பற்றிய உங்கள் கருத்தைப் பகிரவும்';

  @override
  String busLabel(String busNumber) {
    return 'பேருந்து $busNumber';
  }

  @override
  String get statusSubmitted => 'சமர்ப்பிக்கப்பட்டது';

  @override
  String get statusReviewed => 'மதிப்பாய்வு செய்யப்பட்டது';

  @override
  String get statusResolved => 'தீர்வு காணப்பட்டது';

  @override
  String get statusRejected => 'நிராகரிக்கப்பட்டது';

  @override
  String get statusPending => 'நிலுவையில் உள்ளது';

  @override
  String get commentLabel => 'கருத்து';

  @override
  String submittedDateLabel(String date) {
    return 'சமர்ப்பிக்கப்பட்ட தேதி: $date';
  }

  @override
  String get feedbackHistorySubtitle =>
      'உங்கள் அனைத்து கருத்து சமர்ப்பிப்புகளையும் கண்காணிக்கவும்';

  @override
  String get typePositive => 'நேர்மறையானது';

  @override
  String get typeNegative => 'எதிர்மறையானது';

  @override
  String get typeNeutral => 'நடுநிலையானது';

  @override
  String get typeSuggestion => 'பரிந்துரை';

  @override
  String get typeInquiry => 'விசாரணை';

  @override
  String get typeUrgent => 'அவசரம்';

  @override
  String get typeGeneral => 'பொதுவானது';

  @override
  String get categoryComfort => 'வசதி';

  @override
  String get categoryVehicle => 'வாகனம்';

  @override
  String feedbackSuccessWithId(String id) {
    return 'கருத்து வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது! ஐடி: $id';
  }

  @override
  String feedbackFailed(String error) {
    return 'கருத்தைச் சமர்ப்பிக்கத் தவறிவிட்டது: $error';
  }

  @override
  String get failedToLoadPassenger => 'பயணிகளின் தரவை ஏற்றத் தவறிவிட்டது';

  @override
  String get pleaseTryAgainLater => 'தயவுசெய்து பின்னர் முயற்சிக்கவும்';

  @override
  String get noPassengerProfile => 'பயணிகள் சுயவிவரம் எதுவும் கிடைக்கவில்லை';

  @override
  String get passengerInformation => 'பயணிகள் தகவல்';

  @override
  String get submitFeedbackSubtitle =>
      'உங்கள் அனுபவத்தைப் பகிர்ந்து மேம்படுத்த எங்களுக்கு உதவுங்கள்';

  @override
  String nameLabel(String name) {
    return 'பெயர்: $name';
  }

  @override
  String emailLabel(String email) {
    return 'மின்னஞ்சல்: $email';
  }

  @override
  String phoneLabel(String phone) {
    return 'தொலைபேசி: $phone';
  }

  @override
  String totalTripsLabel(int count) {
    return 'மொத்த பயணங்கள்: $count';
  }

  @override
  String get feedbackDetails => 'கருத்து விவரங்கள்';

  @override
  String get feedbackType => 'கருத்து வகை';

  @override
  String get categoryLabel => 'வகை';

  @override
  String get ratings => 'மதிப்பீடுகள்';

  @override
  String get comfort => 'வசதி';

  @override
  String get cleanliness => 'தூய்மை';

  @override
  String get driverBehavior => 'ஓட்டுநர் நடத்தை';

  @override
  String get vehicleCondition => 'வாகன நிலை';

  @override
  String get feedbackContent => 'கருத்து உள்ளடக்கம்';

  @override
  String get title => 'தலைப்பு';

  @override
  String get description => 'விளக்கம்';

  @override
  String get titleRequired => 'தலைப்பு தேவை';

  @override
  String get descriptionRequired => 'விளக்கம் தேவை';

  @override
  String get options => 'விருப்பங்கள்';

  @override
  String get priorityLow => 'குறைந்த';

  @override
  String get priorityMedium => 'நடுத்தர';

  @override
  String get priorityHigh => 'அதிக';

  @override
  String get priorityUrgent => 'அவசரம்';

  @override
  String get anonymousFeedback => 'அநாமதேய கருத்து';

  @override
  String get anonymousFeedbackSubtitle => 'உங்கள் அடையாளம் பகிரப்படாது';

  @override
  String get busFeedback => 'பேருந்து கருத்து';

  @override
  String get driverFeedback => 'ஓட்டுநர் கருத்து';

  @override
  String get shareExperience => 'உங்கள் அனுபவத்தைப் பகிர்ந்து கொள்ளுங்கள்';

  @override
  String get addPhotosVideos =>
      'புகைப்படங்கள் அல்லது வீடியோக்களைச் சேர்க்கவும் (விருப்பத்தேர்வு)';

  @override
  String get uploadMediaSubtitle =>
      'உங்கள் கருத்தை சிறப்பாக விளக்க படங்கள் அல்லது வீடியோக்களைப் பதிவேற்றவும் (அதிகபட்சம் 10MB)';

  @override
  String get tapToSelectMedia =>
      'புகைப்படங்கள் அல்லது வீடியோக்களைத் தேர்ந்தெடுக்க தட்டவும்';

  @override
  String get mediaFormatNote => 'PNG, JPG, MP4 (அதிகபட்சம் 10MB)';

  @override
  String get cleanAndComfortable => 'சுத்தமான மற்றும் வசதியானது';

  @override
  String get goodCondition => 'நல்ல நிலை';

  @override
  String get acWorksWell => 'ஏர் கண்டிஷனிங் நன்றாக வேலை செய்கிறது';

  @override
  String get seatsComfortable => 'இருக்கைகள் வசதியாக உள்ளன';

  @override
  String get needsCleaning => 'பேருந்து சுத்தம் செய்யப்பட வேண்டும்';

  @override
  String get maintenanceRequired => 'பராமரிப்பு தேவை';

  @override
  String get uncomfortableSeats => 'வசதியற்ற இருக்கைகள்';

  @override
  String get poorVentilation => 'மோசமான காற்றோட்டம்';

  @override
  String get excellentDriving => 'சிறந்த ஓட்டுநர்';

  @override
  String get courteousAndHelpful => 'மரியாதையான மற்றும் உதவியாக';

  @override
  String get safeDriving => 'பாதுகாப்பான ஓட்டுநர்';

  @override
  String get professionalBehavior => 'தொழில்முறை நடத்தை';

  @override
  String get recklessDriving => 'அலட்சியமாக வாகனம் ஓட்டுதல்';

  @override
  String get unprofessionalBehavior => 'தொழில்முறையற்ற நடத்தை';

  @override
  String get poorCustomerService => 'மோசமான வாடிக்கையாளர் சேவை';

  @override
  String get safetyConcerns => 'பாதுகாப்பு கவலைகள்';

  @override
  String get locationInformation => 'இருப்பிடத் தகவல்';

  @override
  String get locationSubtitle =>
      'உங்கள் இருப்பிடம் உங்கள் கருத்தின் சூழலைப் புரிந்துகொள்ள உதவுகிறது';

  @override
  String get gettingLocation => 'உங்கள் இருப்பிடத்தைப் பெறுகிறது...';

  @override
  String get locationCaptured => 'இருப்பிடம் வெற்றிகரமாகப் பிடிக்கப்பட்டது';

  @override
  String get locationNotAvailable => 'இருப்பிடம் கிடைக்கவில்லை';

  @override
  String get needMoreHelp => 'கூடுதல் உதவி தேவையா?';

  @override
  String get contactDirectlySubtitle =>
      'பெரிய கோப்புகள் அல்லது விரிவான விவாதங்களுக்கு, எங்களை நேரடியாகத் தொடர்பு கொள்ளவும்';

  @override
  String get whatsApp => 'வாட்ஸ்அப்';

  @override
  String get overallExperience => 'உங்கள் ஒட்டுமொத்த அனுபவம் எப்படி இருந்தது?';

  @override
  String get veryPoor => 'மிகவும் மோசம்';

  @override
  String get average => 'சராசரி';

  @override
  String get feedbackCategory => 'கருத்து வகை';

  @override
  String get categoryGeneral => 'பொதுவானது';

  @override
  String get categoryDriver => 'ஓட்டுநர்';

  @override
  String get categoryBusCondition => 'பேருந்து நிலை';

  @override
  String get categorySafety => 'பாதுகாப்பு';

  @override
  String get categoryRoute => 'வழித்தடம்';

  @override
  String get categoryService => 'சேவை';

  @override
  String get feedbackHint => 'உங்கள் அனுபவத்தைப் பற்றி எங்களிடம் கூறுங்கள்...';

  @override
  String get feedbackRewardNote =>
      'உங்கள் கருத்து எங்கள் சேவையை மேம்படுத்த உதவுகிறது\n✨ +1 வெகுமதி புள்ளியைப் பெறுங்கள்!';

  @override
  String get userNotAuthenticated => 'பயனர் அங்கீகரிக்கப்படவில்லை';

  @override
  String get feedbackSuccess => '✅ உங்கள் கருத்துக்கு நன்றி! +1 வெகுமதி புள்ளி';

  @override
  String feedbackError(String error) {
    return 'கருத்தைச் சமர்ப்பிப்பதில் தோல்வி: $error';
  }

  @override
  String busNumberLabel(String number) {
    return 'பேருந்து $number';
  }

  @override
  String submittedOn(String date) {
    return 'சமர்ப்பிக்கப்பட்டது: $date';
  }

  @override
  String get rateYourExperience => 'உங்கள் அனுபவத்தை மதிப்பிடுங்கள்';

  @override
  String get additionalComments => 'கூடுதல் கருத்துகள்';

  @override
  String get shareMoreDetails =>
      'உங்கள் அனுபவத்தைப் பற்றிய கூடுதல் விவரங்களைப் பகிரவும் (விருப்பத்தேர்வு)';

  @override
  String get typeFeedbackHint => 'உங்கள் கருத்தை இங்கே தட்டச்சு செய்யவும்...';

  @override
  String get feedbackSubmittedTitle => 'கருத்து சமர்ப்பிக்கப்பட்டது!';

  @override
  String get feedbackSubmittedSubtitle =>
      'உங்கள் கருத்துக்கு நன்றி. இது எங்கள் சேவையை மேம்படுத்த உதவுகிறது.';

  @override
  String get submissionFailedTitle => 'சமர்ப்பிப்பு தோல்வியடைந்தது';

  @override
  String get submissionFailedSubtitle =>
      'கருத்தைச் சமர்ப்பிக்கத் தவறிவிட்டது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get uploadingMedia => 'ஊடகக் கோப்புகள் பதிவேற்றப்படுகின்றன...';

  @override
  String filesSelected(int count) {
    return '$count கோப்பு(கள்) பதிவேற்றத் தேர்ந்தெடுக்கப்பட்டுள்ளன';
  }

  @override
  String get maxFilesReached => 'அதிகபட்சம் 10 கோப்புகள் அனுமதிக்கப்படுகின்றன';

  @override
  String fileExceedsLimit(String fileName) {
    return '$fileName கோப்பு 10MB வரம்பை மீறுகிறது';
  }

  @override
  String mediaUploadFailed(String error) {
    return 'ஊடகப் பதிவேற்றம் தோல்வியடைந்தது: $error';
  }

  @override
  String pickMediaFailed(String error) {
    return 'ஊடகக் கோப்புகளைத் தேர்ந்தெடுக்கத் தவறிவிட்டது: $error';
  }

  @override
  String couldNotLaunchUrl(String url) {
    return '$url ஐத் தொடங்க முடியவில்லை';
  }

  @override
  String errorLaunchingUrl(String error) {
    return 'URL ஐத் தொடங்குவதில் பிழை: $error';
  }

  @override
  String get busFeedbackLabel => 'பேருந்து கருத்து';

  @override
  String get driverFeedbackLabel => 'ஓட்டுநர் கருத்து';

  @override
  String get rateBusExperience =>
      'பேருந்தின் ஒட்டுமொத்த நிலை மற்றும் வசதியை நீங்கள் எவ்வாறு மதிப்பிடுவீர்கள்?';

  @override
  String get rateDriverExperience =>
      'ஓட்டுநரின் செயல்திறன் மற்றும் தொழில்முறை நடத்தையை நீங்கள் எவ்வாறு மதிப்பிடுவீர்கள்?';
}

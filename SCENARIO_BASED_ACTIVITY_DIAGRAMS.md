# SafeDriver Passenger App - Scenario-Based Activity Diagrams

Detailed activity diagrams for each major use case and scenario in the SafeDriver application.

---

## 1. USER REGISTRATION FLOW

```mermaid
graph TD
    Start([User Launches App]) --> CheckAuth{Is User<br/>Already<br/>Signed In?}
    
    CheckAuth -->|Yes| SkipToHome[Skip to Home]
    CheckAuth -->|No| ShowAuth[Show Authentication Screen]
    
    ShowAuth --> SelectRegister[User Taps Register]
    SelectRegister --> ShowRegisterForm[Display Registration Form]
    
    ShowRegisterForm --> EnterEmail[Enter Email Address]
    EnterEmail --> ValidateEmail{Email<br/>Valid?}
    
    ValidateEmail -->|No| ShowEmailError[Show Error: Invalid Email]
    ShowEmailError --> EnterEmail
    
    ValidateEmail -->|Yes| EnterPassword[Enter Password]
    EnterPassword --> ValidatePassword{Password<br/>Strong Enough?}
    
    ValidatePassword -->|No| ShowPwdError[Show Error: Weak Password]
    ShowPwdError --> EnterPassword
    
    ValidatePassword -->|Yes| EnterName[Enter First & Last Name]
    EnterName --> EnterPhone[Enter Phone Number]
    EnterPhone --> ValidatePhone{Phone<br/>Valid?}
    
    ValidatePhone -->|No| ShowPhoneError[Show Error: Invalid Phone]
    ShowPhoneError --> EnterPhone
    
    ValidatePhone -->|Yes| AcceptTerms[Read & Accept Terms & Conditions]
    AcceptTerms --> ClickRegister[Click Register Button]
    
    ClickRegister --> CreateAccount[Create Firebase Account]
    CreateAccount --> CreateSuccess{Account<br/>Created?}
    
    CreateSuccess -->|No| ShowRegError[Show Registration Error]
    ShowRegError --> ClickRegister
    
    CreateSuccess -->|Yes| SendVerification[Send Verification Email]
    SendVerification --> VerifyEmail{User Verified<br/>Email?}
    
    VerifyEmail -->|No| ShowVerifyPrompt[Show Verification Reminder]
    ShowVerifyPrompt --> VerifyEmail
    
    VerifyEmail -->|Yes| CreateProfile[Create User Profile]
    CreateProfile --> StoreLocally[Cache Profile Locally]
    StoreLocally --> OnboardingFlow[Go to Onboarding]
    OnboardingFlow --> End([Navigate to Dashboard])
```

---

## 2. USER LOGIN FLOW (EMAIL/PASSWORD)

```mermaid
graph TD
    Start([User Opens App]) --> CheckAuth{Is User<br/>Authenticated?}
    
    CheckAuth -->|Yes| LoadDashboard[Load Dashboard Directly]
    CheckAuth -->|No| ShowLoginScreen[Display Login Screen]
    
    ShowLoginScreen --> CheckSavedCreds{Saved<br/>Credentials?}
    
    CheckSavedCreds -->|Yes| ShowAutoLogin[Show Auto-Login Option]
    ShowAutoLogin --> UserChoice{User Chooses<br/>to Login?}
    UserChoice -->|Yes| AutoLogin[Auto Login with Saved Creds]
    UserChoice -->|No| ManualLogin[Manual Entry]
    
    CheckSavedCreds -->|No| ManualLogin
    
    ManualLogin --> EnterEmail[Enter Email Address]
    EnterEmail --> EnterPassword[Enter Password]
    EnterPassword --> CheckRememberMe{Remember<br/>Me Selected?}
    
    CheckRememberMe -->|Yes| EnableRemember[Enable Remember Me]
    CheckRememberMe -->|No| SkipRemember[Skip Remember Me]
    
    EnableRemember --> ClickLogin[Click Login Button]
    SkipRemember --> ClickLogin
    
    AutoLogin --> ValidateAuth[Validate Credentials with Firebase]
    ClickLogin --> ValidateAuth
    
    ValidateAuth --> AuthSuccess{Authentication<br/>Successful?}
    
    AuthSuccess -->|No| ShowAuthError[Show Error Message]
    ShowAuthError --> RetryCount{Retry Count<br/>< 3?}
    RetryCount -->|Yes| EnterEmail
    RetryCount -->|No| LockAccount[Temporarily Lock Account]
    LockAccount --> ShowLockMsg[Show: Account Locked for 15 mins]
    ShowLockMsg --> Start
    
    AuthSuccess -->|Yes| GetUserData[Fetch User Profile from Firestore]
    GetUserData --> CheckProfile{Profile<br/>Complete?}
    
    CheckProfile -->|No| RequireProfile[Require Complete Profile]
    RequireProfile --> ProfileSetup[Go to Profile Setup]
    ProfileSetup --> StoreData[Store Data Locally]
    
    CheckProfile -->|Yes| StoreData
    StoreData --> InitServices[Initialize Services]
    InitServices --> LoadDashboard
    LoadDashboard --> End([Dashboard Ready])
```

---

## 3. PHONE NUMBER AUTHENTICATION (OTP) FLOW

```mermaid
graph TD
    Start([User Selects Phone Login]) --> ShowPhoneForm[Display Phone Entry Form]
    
    ShowPhoneForm --> SelectCountry[Select Country Code]
    SelectCountry --> EnterPhone[Enter Phone Number]
    EnterPhone --> ValidatePhone{Phone<br/>Format Valid?}
    
    ValidatePhone -->|No| ShowError1[Show Error: Invalid Format]
    ShowError1 --> EnterPhone
    
    ValidatePhone -->|Yes| CheckPhone{Phone Already<br/>Registered?}
    
    CheckPhone -->|Yes| ShowExists[Show: Phone Already Registered]
    ShowExists --> ShowLoginOption[Show Login Option]
    ShowLoginOption --> Start
    
    CheckPhone -->|No| SendOTP[Send OTP via SMS]
    SendOTP --> OTPSent{OTP Sent<br/>Successfully?}
    
    OTPSent -->|No| ShowSendError[Show: Failed to Send OTP]
    ShowSendError --> RetryBtn[Show Retry Button]
    RetryBtn --> ClickRetry{User Retries?}
    ClickRetry -->|Yes| SendOTP
    ClickRetry -->|No| Cancel1[User Cancels]
    Cancel1 --> Start
    
    OTPSent -->|Yes| ShowOTPForm[Display OTP Input Form]
    ShowOTPForm --> ShowTimer[Start 5-Minute Timer]
    ShowTimer --> EnterOTP[Enter 6-Digit OTP]
    
    EnterOTP --> ValidateOTP{OTP<br/>Valid?}
    
    ValidateOTP -->|No| IncAttempt[Increment Failed Attempts]
    IncAttempt --> CheckAttempts{Attempts<br/>< 3?}
    CheckAttempts -->|Yes| ShowOTPError[Show Error: Invalid OTP]
    ShowOTPError --> EnterOTP
    CheckAttempts -->|No| BlockOTP[Block OTP Entry]
    BlockOTP --> ShowBlockMsg[Show: OTP Blocked - Resend After 5 mins]
    ShowBlockMsg --> ShowResendBtn[Show Resend Button]
    ShowResendBtn --> WaitTimer[Wait for Timer]
    WaitTimer --> ShowOTPForm
    
    ValidateOTP -->|Yes| VerifyPhone[Phone Verified]
    VerifyPhone --> CheckUserExists{User Account<br/>Exists?}
    
    CheckUserExists -->|No| CreateNewAccount[Create New Account]
    CreateNewAccount --> CompleteProfile[Complete User Profile]
    CompleteProfile --> StoreProfile[Store Profile Locally]
    
    CheckUserExists -->|Yes| FetchProfile[Fetch User Profile]
    FetchProfile --> StoreProfile
    
    StoreProfile --> InitServices[Initialize Services]
    InitServices --> LoadDashboard[Load Dashboard]
    LoadDashboard --> End([Ready to Use App])
```

---

## 4. BUS SEARCH AND BOOKING FLOW

```mermaid
graph TD
    Start([User on Dashboard]) --> SelectSearch[Tap Search Bar]
    SelectSearch --> ShowSearchForm[Display Search Form]
    
    ShowSearchForm --> SelectSource[Select Source Location]
    SelectSource --> GetSourceLocation{Use Current<br/>Location?}
    
    GetSourceLocation -->|Yes| GetCurrent[Get Current Location]
    GetCurrent --> DisplaySource[Display Source]
    
    GetSourceLocation -->|No| SearchSource[Search Source Location]
    SearchSource --> SelectSourceManual[Select from Results]
    SelectSourceManual --> DisplaySource
    
    DisplaySource --> SelectDestination[Select Destination Location]
    SelectDestination --> SearchDest[Search Destination]
    SearchDest --> SelectDestManual[Select from Results]
    SelectDestManual --> DisplayDest[Display Destination]
    
    DisplayDest --> SelectDate[Select Travel Date]
    SelectDate --> ShowDatePicker[Show Date Picker]
    ShowDatePicker --> PickDate[Pick Date]
    PickDate --> SelectTime{Select<br/>Time?}
    
    SelectTime -->|Optional| SelectDepartTime[Select Departure Time]
    SelectDepartTime --> DisplayTime[Display Selected Time]
    
    SelectTime -->|Skip| DisplayTime
    
    DisplayTime --> SelectFilter[Select Additional Filters]
    SelectFilter --> ShowFilters[Bus Type, Price Range, Ratings]
    ShowFilters --> ApplyFilters[Apply Filters]
    
    ApplyFilters --> SearchBuses[Search Available Buses]
    SearchBuses --> LoadingScreen[Show Loading]
    LoadingScreen --> BusSearchResult{Buses<br/>Found?}
    
    BusSearchResult -->|No| ShowNoResult[Show: No Buses Available]
    ShowNoResult --> OfferAlternate[Offer Alternative Dates/Times]
    OfferAlternate --> SelectSearch
    
    BusSearchResult -->|Yes| DisplayList[Display Bus Search Results]
    DisplayList --> SortOptions[Show Sort Options]
    SortOptions --> ApplySort[Sort by Price/Rating/Time]
    ApplySort --> ViewResults[View Bus List]
    
    ViewResults --> SelectBus[User Selects a Bus]
    SelectBus --> ShowBusDetail[Display Bus Details Page]
    
    ShowBusDetail --> LoadBusInfo[Load Bus Info, Routes, Amenities]
    LoadBusInfo --> LoadSeats[Load Available Seats]
    LoadSeats --> LoadDriver[Load Driver Information]
    LoadDriver --> DisplayDetails[Display All Details]
    
    DisplayDetails --> UserChoice{User Wants<br/>to Book?}
    
    UserChoice -->|No| GoBack[Go Back to Search Results]
    GoBack --> ViewResults
    
    UserChoice -->|Yes| SelectSeats[Select Desired Seats]
    SelectSeats --> ShowSeating[Display Seating Chart]
    ShowSeating --> ClickSeat[Click to Select Seat]
    ClickSeat --> SeatSelected{Seat<br/>Available?}
    
    SeatSelected -->|No| ShowError[Show: Seat Unavailable]
    ShowError --> ShowSeating
    
    SeatSelected -->|Yes| AddSeat[Add Seat to Booking]
    AddSeat --> MoreSeats{Add More<br/>Seats?}
    
    MoreSeats -->|Yes| ClickSeat
    MoreSeats -->|No| ReviewBooking[Review Booking Summary]
    
    ReviewBooking --> ShowSummary[Show Price, Seats, Schedule]
    ShowSummary --> ProceedPayment[Tap Proceed to Payment]
    
    ProceedPayment --> SelectPaymentMethod[Select Payment Method]
    SelectPaymentMethod --> CreditCard[Credit/Debit Card]
    SelectPaymentMethod --> MobileWallet[Mobile Wallet]
    SelectPaymentMethod --> BankTransfer[Bank Transfer]
    
    CreditCard --> ProcessPayment[Process Payment]
    MobileWallet --> ProcessPayment
    BankTransfer --> ProcessPayment
    
    ProcessPayment --> PaymentLoading[Show Loading Animation]
    PaymentLoading --> PaymentResult{Payment<br/>Successful?}
    
    PaymentResult -->|No| PaymentError[Show Payment Error]
    PaymentError --> RetryPayment{User Retries?}
    RetryPayment -->|Yes| SelectPaymentMethod
    RetryPayment -->|No| SaveDraft[Save as Draft Booking]
    SaveDraft --> GoBack
    
    PaymentResult -->|Yes| CreateBooking[Create Booking Record]
    CreateBooking --> SaveBooking[Save to Firestore]
    SaveBooking --> SendConfirmation[Send Confirmation Email/SMS]
    SendConfirmation --> GenerateTicket[Generate E-Ticket]
    GenerateTicket --> ShowConfirmation[Show Booking Confirmation]
    
    ShowConfirmation --> DisplayTicket[Display E-Ticket with QR Code]
    DisplayTicket --> OfferOptions[Offer Download/Share Options]
    OfferOptions --> UserAction{User Action}
    
    UserAction -->|Download| DownloadTicket[Download as PDF]
    UserAction -->|Share| ShareTicket[Share via Social/Email]
    UserAction -->|Go Home| NavigateHome[Navigate to Dashboard]
    
    DownloadTicket --> NavigateHome
    ShareTicket --> NavigateHome
    NavigateHome --> End([Booking Complete])
```

---

## 5. FEEDBACK SUBMISSION FLOW

```mermaid
graph TD
    Start([Recent Trip Shown]) --> ShowFeedbackPrompt[Display Feedback Prompt]
    
    ShowFeedbackPrompt --> UserChoice{User Wants<br/>to Give<br/>Feedback?}
    
    UserChoice -->|Not Now| RemindLater[Remind Later]
    UserChoice -->|Dismiss| SkipFeedback[Skip Feedback]
    
    RemindLater --> End1([Continue])
    SkipFeedback --> End1
    
    UserChoice -->|Yes| OpenFeedback[Open Feedback Form]
    
    OpenFeedback --> SelectRating[Select Overall Rating]
    SelectRating --> DisplayStars[Display 5-Star Rating System]
    DisplayStars --> RateTrip[Rate Trip 1-5 Stars]
    
    RateTrip --> CheckRating{Rating<br/>Score?}
    
    CheckRating -->|1-2 Stars| ShowNegativeForm[Show Negative Feedback Form]
    CheckRating -->|3-4 Stars| ShowNeutralForm[Show Neutral Feedback Form]
    CheckRating -->|5 Stars| ShowPositiveForm[Show Positive Feedback Form]
    
    ShowNegativeForm --> SelectIssueType[Select Issue Category]
    SelectIssueType --> Issues["Safety, Comfort,<br/>Driver Behavior,<br/>Cleanliness, etc."]
    Issues --> ProvideDetails[Provide Issue Details]
    ProvideDetails --> CanAttach{Attach<br/>Photos/Video?}
    
    ShowNeutralForm --> EnterComment[Enter Additional Comments]
    EnterComment --> CanAttach
    
    ShowPositiveForm --> SelectProbs["Select Positive Aspects:<br/>Driver Behavior, Cleanliness,<br/>Comfort, Safety, etc."]
    SelectProbs --> EnterComment
    
    CanAttach -->|Yes| LaunchCamera[Launch Camera/Gallery]
    LaunchCamera --> CaptureMedia[Capture/Select Media]
    CaptureMedia --> PreviewMedia[Preview Media Files]
    PreviewMedia --> ConfirmMedia[Confirm Media Selection]
    ConfirmMedia --> DisplayAttached[Display Attached Files]
    
    CanAttach -->|No| DisplayAttached
    
    DisplayAttached --> DisplayForm[Display Complete Feedback Form]
    DisplayForm --> UserReview[User Reviews Feedback]
    UserReview --> EditChoice{Edit<br/>Needed?}
    
    EditChoice -->|Yes| EditFeedback[Edit Feedback Content]
    EditFeedback --> DisplayForm
    
    EditChoice -->|No| SubmitFeedback[Tap Submit Button]
    
    SubmitFeedback --> ValidateForm[Validate Form Data]
    ValidateForm --> ValidResult{Data<br/>Valid?}
    
    ValidResult -->|No| ShowValidError[Show Validation Error]
    ShowValidError --> EditFeedback
    
    ValidResult -->|Yes| EncryptData[Encrypt Sensitive Data]
    EncryptData --> UploadMedia[Upload Media to Cloud Storage]
    UploadMedia --> MediaUploaded{Media Upload<br/>Complete?}
    
    MediaUploaded -->|No| ShowUploadError[Show Upload Error]
    ShowUploadError --> RetryUpload{Retry?}
    RetryUpload -->|Yes| UploadMedia
    RetryUpload -->|No| SaveDraft[Save as Draft]
    SaveDraft --> End1
    
    MediaUploaded -->|Yes| SaveFeedback[Save Feedback to Firestore]
    SaveFeedback --> FeedbackSaved{Saved<br/>Successfully?}
    
    FeedbackSaved -->|No| ShowSaveError[Show Save Error]
    ShowSaveError --> RetrySubmit{Retry?}
    RetrySubmit -->|Yes| SaveFeedback
    RetrySubmit -->|No| SaveDraft
    
    FeedbackSaved -->|Yes| UpdateBusRating[Update Bus Rating Score]
    UpdateBusRating --> UpdateDriverRating[Update Driver Rating Score]
    UpdateDriverRating --> NotifyAdmin[Send Notification to Admin]
    NotifyAdmin --> NotifyDriver{Negative<br/>Feedback?}
    
    NotifyDriver -->|Yes| NotifyDriverMsg[Notify Driver about Feedback]
    NotifyDriver -->|No| SkipNotify[Skip Driver Notification]
    
    NotifyDriverMsg --> SendEmail[Send Feedback Confirmation Email]
    SkipNotify --> SendEmail
    
    SendEmail --> ShowSuccess[Display Success Message]
    ShowSuccess --> OfferReward[Offer Reward Points]
    OfferReward --> RewardUser[Add Points to Account]
    RewardUser --> ShowRewardMsg[Show Reward Confirmation]
    ShowRewardMsg --> DisplayOptions[Display Navigation Options]
    
    DisplayOptions --> UserNav{Next<br/>Action?}
    
    UserNav -->|View More| ViewMore[View More Feedback Options]
    UserNav -->|Home| GoHome[Navigate to Dashboard]
    UserNav -->|Trip History| ViewHistory[View Trip History]
    
    ViewMore --> End1
    GoHome --> End1
    ViewHistory --> End1
```

---

## 6. REAL-TIME BUS TRACKING FLOW

```mermaid
graph TD
    Start([User on Dashboard]) --> ViewBookings[View Active Bookings]
    ViewBookings --> SelectBooking[Select Booking to Track]
    
    SelectBooking --> LoadTracking[Load Bus Tracking Page]
    LoadTracking --> RequestPermission{Location<br/>Permission<br/>Granted?}
    
    RequestPermission -->|No| RequestPerm[Request Location Permission]
    RequestPerm --> PermGranted{User Grants<br/>Permission?}
    PermGranted -->|No| ContinueWithoutLoc[Continue without Location]
    PermGranted -->|Yes| EnableLocation[Enable Location Services]
    
    EnableLocation --> InitLocation[Initialize Location Tracking]
    ContinueWithoutLoc --> InitLocation
    
    InitLocation --> GetBusLocation[Get Real-time Bus Location]
    GetBusLocation --> DisplayMap[Display Map Interface]
    DisplayMap --> ShowBusMarker[Show Bus Marker on Map]
    
    ShowBusMarker --> ShowUserMarker[Show User Current Location]
    ShowUserMarker --> DrawRoute[Draw Bus Route on Map]
    DrawRoute --> CalculateDistance[Calculate Distance to Bus]
    
    CalculateDistance --> DisplayDistance[Display Distance & ETA]
    DisplayDistance --> ListenUpdates[Listen to Real-time Updates]
    
    ListenUpdates --> UpdateStream[Stream: Bus Location Updates]
    UpdateStream --> ReceiveUpdate{Update<br/>Received?}
    
    ReceiveUpdate -->|Yes| UpdateMarker[Update Bus Marker Position]
    UpdateMarker --> UpdateDistance[Recalculate Distance & ETA]
    UpdateDistance --> RefreshDisplay[Refresh Display]
    RefreshDisplay --> ListenUpdates
    
    ReceiveUpdate -->|No| CheckConnection{Connection<br/>Active?}
    CheckConnection -->|Yes| WaitUpdate[Wait for Next Update]
    WaitUpdate --> ListenUpdates
    
    CheckConnection -->|No| ShowOffline[Show: Offline/Connection Lost]
    ShowOffline --> RetryConnection[Retry Connection]
    RetryConnection --> ListenUpdates
    
    DisplayDistance --> UserInteraction{User<br/>Interaction?}
    
    UserInteraction -->|View Details| ViewDetails[Tap Bus Info]
    ViewDetails --> ShowBusDetails[Display Bus Details Modal]
    ShowBusDetails --> DisplayInfo[Show Bus#, Route, Amenities]
    DisplayInfo --> ViewDriver[View Driver Information]
    ViewDriver --> CloseModal[Close Modal]
    CloseModal --> UserInteraction
    
    UserInteraction -->|Call Driver| CallOption[Tap Call Driver]
    CallOption --> InitCall[Initiate Phone Call]
    InitCall --> PhoneApp[Open Phone Application]
    PhoneApp --> UserInteraction
    
    UserInteraction -->|Message Driver| ChatOption[Tap Chat Driver]
    ChatOption --> OpenChat[Open Chat Interface]
    OpenChat --> SendMessage[Send Message to Driver]
    SendMessage --> CloseChat[Close Chat]
    CloseChat --> UserInteraction
    
    UserInteraction -->|Share Location| ShareOption[Tap Share ETA]
    ShareOption --> ShareETA[Share Tracking Link]
    ShareETA --> CopyLink[Copy to Clipboard/Share]
    CopyLink --> UserInteraction
    
    UserInteraction -->|Navigate| NavOption[Tap Navigate]
    NavOption --> OpenMaps[Open Google Maps]
    OpenMaps --> UserInteraction
    
    UserInteraction -->|Report Issue| ReportOption[Tap Report Issue]
    ReportOption --> ReportForm[Open Report Form]
    ReportForm --> SelectIssue[Select Issue Type]
    SelectIssue --> SubmitReport[Submit Report]
    SubmitReport --> UserInteraction
    
    UserInteraction -->|Go Home| HomeOption[Tap Home]
    HomeOption --> Stop[Stop Tracking]
    Stop --> CancelStream[Cancel Update Stream]
    CancelStream --> NavigateHome[Navigate to Dashboard]
    NavigateHome --> End([Tracking Stopped])
    
    UserInteraction -->|Bus Arrived| ArrivedNotif[Bus Arrival Notification]
    ArrivedNotif --> ShowNotif[Display Notification]
    ShowNotif --> AutoStop[Auto Stop Tracking]
    AutoStop --> ShowArrival[Show Arrival Confirmation]
    ShowArrival --> OfferFeedback[Offer Give Feedback]
    OfferFeedback --> End
```

---

## 7. SAFETY ALERT REPORTING FLOW

```mermaid
graph TD
    Start([Emergency/Safety Issue Occurs]) --> ReportOption1{Report<br/>Method?}
    
    ReportOption1 -->|Floating Button| TapButton[Tap Floating Report Button]
    ReportOption1 -->|Menu| OpenMenu[Open App Menu]
    OpenMenu --> TapReport[Select Report Option]
    
    TapButton --> ShowReportForm[Display Report Form]
    TapReport --> ShowReportForm
    
    ShowReportForm --> SelectCategory[Select Issue Category]
    SelectCategory --> ShowCategories["- Unsafe Driving<br/>- Hazardous Road Condition<br/>- Accident<br/>- Vehicle Issue<br/>- Harassment/Assault<br/>- Other"]
    
    ShowCategories --> PickCategory[Pick Issue Category]
    PickCategory --> ShowSubForm[Display Subcategory Form]
    
    ShowSubForm --> SelectSeverity[Select Severity Level]
    SelectSeverity --> ShowSeverity["- Critical (Immediate Danger)<br/>- High (Serious Issue)<br/>- Medium (Concern)<br/>- Low (Minor Issue)"]
    
    ShowSeverity --> PickSeverity[Pick Severity Level]
    PickSeverity --> CheckCritical{Critical<br/>Severity?}
    
    CheckCritical -->|Yes| AlertEmergency[Alert Emergency Services]
    AlertEmergency --> ShowWarning[Show: Emergency Alert Sent]
    CheckCritical -->|No| Continue1[Continue with Report]
    
    ShowWarning --> Continue1
    
    Continue1 --> EnterDescription[Enter Description Details]
    EnterDescription --> TextInput[Type Problem Description]
    TextInput --> CharCount[Show Character Count]
    CharCount --> EnterLocation[Confirm Location]
    
    EnterLocation --> GetLocation{Use Current<br/>Location?}
    
    GetLocation -->|Yes| GetCurrent[Get GPS Coordinates]
    GetCurrent --> DisplayLocation[Display Location on Map]
    
    GetLocation -->|No| SelectOnMap[Select Location on Map]
    SelectOnMap --> DisplayLocation
    
    DisplayLocation --> AddMedia[Add Evidence Media]
    AddMedia --> MediaOption{Add<br/>Photos/Video?}
    
    MediaOption -->|Yes| LaunchCamera[Launch Camera/Gallery]
    LaunchCamera --> CaptureMedia[Capture/Select Media]
    CaptureMedia --> PreviewMedia[Preview Captured Media]
    PreviewMedia --> AddMore{Add More<br/>Media?}
    AddMore -->|Yes| LaunchCamera
    AddMore -->|No| ReviewMedia[Review All Media]
    
    MediaOption -->|No| ReviewMedia
    
    ReviewMedia --> DisplayMediaList[Display Media List]
    DisplayMediaList --> SelectAnonymous{Report<br/>Anonymously?}
    
    SelectAnonymous -->|Yes| SetAnonymous[Set as Anonymous Report]
    SelectAnonymous -->|No| UseIdentity[Use Identity Information]
    
    SetAnonymous --> ReviewReport[Review Full Report]
    UseIdentity --> ReviewReport
    
    ReviewReport --> DisplaySummary[Display Report Summary]
    DisplaySummary --> UserVerify{User Confirms<br/>Report?}
    
    UserVerify -->|No| EditReport[Edit Report Content]
    EditReport --> ReviewReport
    
    UserVerify -->|Yes| SubmitReport[Submit Report]
    
    SubmitReport --> ValidateData[Validate Report Data]
    ValidateData --> ValidOK{Data Valid?}
    
    ValidOK -->|No| ShowError[Show Validation Error]
    ShowError --> EditReport
    
    ValidOK -->|Yes| UploadMedia[Upload Media Files]
    UploadMedia --> UploadProgress[Show Upload Progress]
    UploadProgress --> MediaUploaded{All Media<br/>Uploaded?}
    
    MediaUploaded -->|No| UploadFailed[Upload Failed]
    UploadFailed --> RetryUpload{Retry?}
    RetryUpload -->|Yes| UploadMedia
    RetryUpload -->|No| SaveDraft[Save as Draft]
    SaveDraft --> ShowDraftMsg[Show: Saved as Draft]
    ShowDraftMsg --> End1([Return to App])
    
    MediaUploaded -->|Yes| EncryptData[Encrypt Report Data]
    EncryptData --> SaveReport[Save Report to Firestore]
    SaveReport --> ReportSaved{Saved<br/>Successfully?}
    
    ReportSaved -->|No| ShowSaveError[Show Save Error]
    ShowSaveError --> RetrySubmit{Retry?}
    RetrySubmit -->|Yes| SaveReport
    RetrySubmit -->|No| SaveDraft
    
    ReportSaved -->|Yes| GenerateID[Generate Report ID]
    GenerateID --> NotifyAdmin[Send Alert to Safety Team]
    NotifyAdmin --> CheckCritical2{Critical<br/>Report?}
    
    CheckCritical2 -->|Yes| AlertPolice[Alert Local Police/Emergency]
    CheckCritical2 -->|No| Standard[Standard Processing]
    
    AlertPolice --> NotifyDriver[Send Report to Driver]
    Standard --> NotifyDriver
    
    NotifyDriver --> SendEmail[Send Email Confirmation]
    SendEmail --> ShowConfirm[Display Confirmation Page]
    
    ShowConfirm --> DisplayID[Show Report ID & Reference]
    DisplayID --> ShowNext[Show Next Steps]
    ShowNext --> OfferSupport[Offer Support Resources]
    OfferSupport --> UserChoice{User Action}
    
    UserChoice -->|View Report| ViewReport[View Submitted Report]
    UserChoice -->|Call Support| CallSupport[Call Safety Support]
    UserChoice -->|Go Home| GoHome[Navigate to Dashboard]
    
    ViewReport --> End1
    CallSupport --> End1
    GoHome --> End1
```

---

## 8. USER PROFILE MANAGEMENT FLOW

```mermaid
graph TD
    Start([User Taps Profile Icon]) --> LoadProfile[Load User Profile]
    LoadProfile --> FetchData[Fetch Profile Data from Firestore]
    FetchData --> DisplayProfile[Display Profile Page]
    
    DisplayProfile --> ProfileView{User Action}
    
    ProfileView -->|Edit Personal Info| EditPersonal[Tap Edit Personal Info]
    ProfileView -->|Edit Address| EditAddress[Tap Edit Address]
    ProfileView -->|Change Password| ChangePassword[Tap Change Password]
    ProfileView -->|Emergency Contact| EditEmergency[Tap Edit Emergency Contact]
    ProfileView -->|Preferences| EditPrefs[Tap Edit Preferences]
    ProfileView -->|Trip History| ViewHistory[View Trip History]
    ProfileView -->|Logout| LogoutFlow[Logout]
    
    %% Edit Personal Info Flow
    EditPersonal --> OpenPersonalForm[Open Personal Info Form]
    OpenPersonalForm --> ShowFields[Show: First Name, Last Name, DOB, Gender]
    ShowFields --> EditFields[Edit Personal Fields]
    EditFields --> ValidateInfo{Info Valid?}
    ValidateInfo -->|No| ShowError1[Show Validation Error]
    ShowError1 --> EditFields
    ValidateInfo -->|Yes| SavePersonal[Save Personal Info]
    SavePersonal --> UpdateDisplay[Update Profile Display]
    UpdateDisplay --> ShowSuccess1[Show Success Message]
    ShowSuccess1 --> DisplayProfile
    
    %% Edit Address Flow
    EditAddress --> OpenAddrForm[Open Address Form]
    OpenAddrForm --> ShowAddrFields[Show: Street, City, State, ZIP, Country]
    ShowAddrFields --> EditAddr[Edit Address Fields]
    EditAddr --> ValidateAddr{Address Valid?}
    ValidateAddr -->|No| ShowError2[Show Validation Error]
    ShowError2 --> EditAddr
    ValidateAddr -->|Yes| GeoCode[Geocode Address]
    GeoCode --> SaveAddr[Save Address]
    SaveAddr --> UpdateDisplay2[Update Profile]
    UpdateDisplay2 --> ShowSuccess2[Show Success Message]
    ShowSuccess2 --> DisplayProfile
    
    %% Change Password Flow
    ChangePassword --> OpenPwdForm[Open Password Change Form]
    OpenPwdForm --> EnterOldPwd[Enter Current Password]
    EnterOldPwd --> VerifyOldPwd[Verify Current Password]
    VerifyOldPwd --> OldPwdCorrect{Password<br/>Correct?}
    OldPwdCorrect -->|No| ShowError3[Show Error: Incorrect Password]
    ShowError3 --> EnterOldPwd
    OldPwdCorrect -->|Yes| EnterNewPwd[Enter New Password]
    EnterNewPwd --> CheckStrength{Password<br/>Strong?}
    CheckStrength -->|No| ShowWeakPwd[Show: Password Too Weak]
    ShowWeakPwd --> EnterNewPwd
    CheckStrength -->|Yes| ConfirmNewPwd[Confirm New Password]
    ConfirmNewPwd --> MatchCheck{Passwords<br/>Match?}
    MatchCheck -->|No| ShowMismatch[Show: Passwords Don't Match]
    ShowMismatch --> ConfirmNewPwd
    MatchCheck -->|Yes| UpdatePwd[Update Password in Firebase]
    UpdatePwd --> ShowSuccess3[Show Success Message]
    ShowSuccess3 --> DisplayProfile
    
    %% Edit Emergency Contact Flow
    EditEmergency --> OpenEmergForm[Open Emergency Contact Form]
    OpenEmergForm --> EnterContactName[Enter Contact Name]
    EnterContactName --> EnterContactPhone[Enter Contact Phone]
    EnterContactPhone --> EnterRelation[Select Relation]
    EnterRelation --> ValidateContact{Contact Valid?}
    ValidateContact -->|No| ShowError4[Show Validation Error]
    ShowError4 --> EnterContactName
    ValidateContact -->|Yes| SaveContact[Save Emergency Contact]
    SaveContact --> ShowSuccess4[Show Success Message]
    ShowSuccess4 --> DisplayProfile
    
    %% Edit Preferences Flow
    EditPrefs --> OpenPrefForm[Open Preferences Form]
    OpenPrefForm --> PrefOptions["Language Selection<br/>Notification Settings<br/>Privacy Settings<br/>Payment Methods"]
    PrefOptions --> SelectLang[Select Language]
    SelectLang --> SaveLang[Save Language Preference]
    SaveLang --> SelectNotif[Select Notification Preferences]
    SelectNotif --> SaveNotif[Save Notification Settings]
    SaveNotif --> SelectPrivacy[Select Privacy Settings]
    SelectPrivacy --> SavePrivacy[Save Privacy Settings]
    SavePrivacy --> ShowSuccess5[Show Success Message]
    ShowSuccess5 --> DisplayProfile
    
    %% Trip History Flow
    ViewHistory --> LoadHistory[Load Trip History]
    LoadHistory --> FetchTrips[Fetch Completed Trips]
    FetchTrips --> DisplayTrips[Display Trip List]
    DisplayTrips --> SelectTrip{Select Trip?}
    SelectTrip -->|Yes| ShowTripDetail[Show Trip Details]
    SelectTrip -->|No| DisplayProfile
    ShowTripDetail --> TripOptions{Trip Action?}
    TripOptions -->|Rebook| RebookTrip[Rebook Same Route]
    TripOptions -->|Give Feedback| GiveFeedback[Submit Feedback]
    TripOptions -->|Back| DisplayProfile
    RebookTrip --> DisplayProfile
    GiveFeedback --> DisplayProfile
    
    %% Logout Flow
    LogoutFlow --> ConfirmLogout[Show Confirm Logout Dialog]
    ConfirmLogout --> UserConfirm{Confirm Logout?}
    UserConfirm -->|No| DisplayProfile
    UserConfirm -->|Yes| SignOut[Sign Out from Firebase]
    SignOut --> ClearCache[Clear Local Cache]
    ClearCache --> CancelNotif[Cancel Notifications]
    CancelNotif --> NavigateLogin[Navigate to Login Screen]
    NavigateLogin --> End([Logged Out])
```

---

## 9. LANGUAGE PREFERENCE SETTING FLOW

```mermaid
graph TD
    Start([App Launches or User Opens Language Settings]) --> CheckSavedLang{Saved Language<br/>Preference?}
    
    CheckSavedLang -->|Yes| LoadSavedLang[Load Saved Language]
    CheckSavedLang -->|No| UseDefault[Use Default Language - English]
    
    LoadSavedLang --> CheckFirstTime{First Time<br/>User?}
    UseDefault --> CheckFirstTime
    
    CheckFirstTime -->|Yes| ShowOnboarding[Show Onboarding Screen]
    ShowOnboarding --> PromptLanguage[Prompt to Select Language]
    
    CheckFirstTime -->|No| UserOpensSettings[User Opens Settings]
    PromptLanguage --> ShowLanguageOptions
    UserOpensSettings --> ShowLanguageOptions
    
    ShowLanguageOptions[Display Language Options]
    ShowLanguageOptions --> DisplayLangs["- English<br/>- Sinhala (සිංහල)<br/>- Tamil (தமிழ்)"]
    
    DisplayLangs --> SelectLang[User Taps Language Option]
    SelectLang --> HighlightSelected[Highlight Selected Language]
    HighlightSelected --> SavePref[Save to SharedPreferences]
    SavePref --> LoadTranslations[Load Language Translations]
    LoadTranslations --> SetLocale[Set App Locale]
    SetLocale --> RebuildUI[Rebuild UI with New Language]
    RebuildUI --> CheckContext{Onboarding or<br/>Settings?}
    
    CheckContext -->|Onboarding| ContinueOnboarding[Continue Onboarding]
    CheckContext -->|Settings| ShowSuccess[Show Success Message]
    
    ContinueOnboarding --> ValidateLanguage{Language<br/>Applied<br/>Successfully?}
    ShowSuccess --> ValidateLanguage
    
    ValidateLanguage -->|No| ShowError[Show Error: Language Change Failed]
    ShowError --> Retry{Retry?}
    Retry -->|Yes| SelectLang
    Retry -->|No| SelectLang
    
    ValidateLanguage -->|Yes| VerifyTranslations[Verify All Text in New Language]
    VerifyTranslations --> CheckMissing{Missing<br/>Translations?}
    
    CheckMissing -->|Yes| UseFallback[Use Fallback Language English]
    UseFallback --> LogWarning[Log Warning]
    
    CheckMissing -->|No| Complete[Language Changed Successfully]
    
    LogWarning --> Complete
    
    Complete --> DisplayUI[Display App in Selected Language]
    DisplayUI --> End([Language Setting Complete])
```

---

## 10. PAYMENT PROCESSING FLOW

```mermaid
graph TD
    Start([User Taps Proceed to Payment]) --> DisplayPaymentMethods[Display Payment Methods]
    
    DisplayPaymentMethods --> SelectMethod{Select Payment<br/>Method}
    
    SelectMethod -->|Credit/Debit Card| CardFlow[Card Payment Flow]
    SelectMethod -->|Mobile Wallet| WalletFlow[Wallet Payment Flow]
    SelectMethod -->|Net Banking| BankFlow[Bank Transfer Flow]
    SelectMethod -->|Save for Later| SaveDraft[Save Booking Draft]
    
    SaveDraft --> End1([Return to Dashboard])
    
    %% Card Payment
    CardFlow --> ShowCardForm[Display Card Entry Form]
    ShowCardForm --> EnterCardNo[Enter Card Number]
    EnterCardNo --> ValidateCardNo{Card No<br/>Valid?}
    ValidateCardNo -->|No| ShowError1[Show: Invalid Card Number]
    ShowError1 --> EnterCardNo
    ValidateCardNo -->|Yes| EnterExpiry[Enter Expiry Date]
    EnterExpiry --> ValidateExpiry{Card<br/>Not Expired?}
    ValidateExpiry -->|No| ShowError2[Show: Card Expired]
    ShowError2 --> EnterExpiry
    ValidateExpiry -->|Yes| EnterCVV[Enter CVV]
    EnterCVV --> EnterBillingAddr[Enter Billing Address]
    EnterBillingAddr --> EnterName[Enter Cardholder Name]
    EnterName --> ReviewCard[Review Card Details]
    ReviewCard --> EncryptCard[Encrypt Card Details]
    EncryptCard --> InitCardPayment[Initiate Card Payment]
    
    %% Mobile Wallet
    WalletFlow --> ShowWalletOptions[Display Wallet Apps]
    ShowWalletOptions --> SelectWallet["Apple Pay, Google Pay,<br/>Samsung Pay, PayPal"]
    SelectWallet --> LaunchWallet[Launch Wallet Application]
    LaunchWallet --> AuthPayment[Authenticate Payment]
    AuthPayment --> InitWalletPayment[Initiate Wallet Payment]
    
    %% Bank Transfer
    BankFlow --> ShowBankOptions[Display Bank Options]
    ShowBankOptions --> SelectBank[Select Bank]
    SelectBank --> ShowBankDetails[Show Bank Account Details]
    ShowBankDetails --> DisplayRef[Display Reference Number]
    DisplayRef --> OpenBank[Open Bank App/Website]
    OpenBank --> UserTransfers[User Transfers Money]
    UserTransfers --> ShowInstruct[Show Verification Instructions]
    ShowInstruct --> WaitVerification[Wait for Payment Verification]
    WaitVerification --> ManualVerify[Admin Manual Verification]
    ManualVerify --> VerifySuccess{Payment<br/>Verified?}
    
    %% Common Payment Processing
    InitCardPayment --> ProcessPayment[Process Payment]
    InitWalletPayment --> ProcessPayment
    ManualVerify --> ProcessPayment
    
    ProcessPayment --> ContactGateway[Contact Payment Gateway]
    ContactGateway --> ShowLoading[Show Loading Animation]
    ShowLoading --> PaymentResult{Payment<br/>Successful?}
    
    PaymentResult -->|Failed| HandleFailure[Handle Payment Failure]
    HandleFailure --> ErrorType{Error Type?}
    
    ErrorType -->|Insufficient Funds| ShowInsufficient[Show: Insufficient Funds]
    ErrorType -->|Card Declined| ShowDeclined[Show: Card Declined]
    ErrorType -->|Network Error| ShowNetError[Show: Network Error]
    ErrorType -->|Timeout| ShowTimeout[Show: Payment Timeout]
    
    ShowInsufficient --> OfferRetry{Retry or<br/>Change Method?}
    ShowDeclined --> OfferRetry
    ShowNetError --> OfferRetry
    ShowTimeout --> OfferRetry
    
    OfferRetry -->|Retry| SelectMethod
    OfferRetry -->|Change Method| DisplayPaymentMethods
    OfferRetry -->|Save Draft| SaveDraft
    
    PaymentResult -->|Successful| ReceiptNo[Generate Receipt Number]
    ReceiptNo --> RecordTransaction[Record Transaction in DB]
    RecordTransaction --> UpdateBooking[Update Booking Status to PAID]
    UpdateBooking --> SaveTransRef[Save Transaction Reference]
    SaveTransRef --> SendReceipt[Send Payment Receipt Email]
    SendReceipt --> ShowSuccessMsg[Display Success Message]
    
    ShowSuccessMsg --> DisplayReceipt[Show Payment Receipt]
    DisplayReceipt --> OfferOptions{User Action?}
    
    OfferOptions -->|Download Receipt| DownloadReceipt[Download Receipt PDF]
    OfferOptions -->|Share Receipt| ShareReceipt[Share Receipt]
    OfferOptions -->|Continue| Continue[Continue to Booking Confirmation]
    
    DownloadReceipt --> Continue
    ShareReceipt --> Continue
    Continue --> GenerateTicket[Generate E-Ticket]
    GenerateTicket --> DisplayTicket[Display Bus Ticket]
    DisplayTicket --> End2([Payment Complete])
```

---

## 11. OTP VERIFICATION AND REGISTRATION FLOW

```mermaid
graph TD
    Start([User Enters Phone Number]) --> RequestOTP[Request OTP]
    RequestOTP --> SendOTP{OTP Sent<br/>Successfully?}
    
    SendOTP -->|No| Retry1{Retry?}
    Retry1 -->|Yes| RequestOTP
    Retry1 -->|No| Start
    
    SendOTP -->|Yes| ShowOTPEntry[Display OTP Entry Screen]
    ShowOTPEntry --> StartTimer[Start 5-Minute Timer]
    StartTimer --> DisplayTimer[Display Countdown Timer]
    
    DisplayTimer --> EnterOTP[User Enters OTP]
    EnterOTP --> AutoVerify{Verify as<br/>User Types?}
    
    AutoVerify -->|Yes| VerifyOnType[Verify OTP on Each Digit]
    AutoVerify -->|No| ManualVerify[User Taps Verify Button]
    
    VerifyOnType --> VerifyOTP{OTP<br/>Correct?}
    ManualVerify --> VerifyOTP
    
    VerifyOTP -->|No| IncAttempt[Increment Failed Attempts]
    IncAttempt --> CheckAttempts{Attempts<br/>< 3?}
    
    CheckAttempts -->|Yes| ShowError[Show: Invalid OTP]
    ShowError --> OfferRetry{Retry or<br/>Resend?}
    OfferRetry -->|Retry| EnterOTP
    OfferRetry -->|Resend| ResendCheck{Timer<br/>< 60 sec?}
    ResendCheck -->|Yes| ShowWait[Show: Wait Before Resending]
    ShowWait --> EnterOTP
    ResendCheck -->|No| RequestOTP
    
    CheckAttempts -->|No| BlockOTP[Block OTP Entry]
    BlockOTP --> ShowBlock[Show: OTP Blocked for 5 minutes]
    ShowBlock --> WaitBlock[Waiting for 5 minutes]
    WaitBlock --> ShowOTPEntry
    
    VerifyOTP -->|Yes| VerifySuccess[OTP Verified Successfully]
    VerifySuccess --> CheckUser{Existing<br/>User?}
    
    CheckUser -->|No| CreateNewAccount[Create New Account]
    CreateNewAccount --> SaveUID[Save User ID]
    
    CheckUser -->|Yes| FetchAccount[Fetch Existing Account]
    FetchAccount --> SaveUID
    
    SaveUID --> SetupProfile{Complete<br/>Profile?}
    
    SetupProfile -->|No| ShowRegForm[Display Registration Form]
    ShowRegForm --> EnterEmail[Enter Email Address]
    EnterEmail --> ValidateEmail{Email Valid<br/>& Unique?}
    ValidateEmail -->|No| ShowEmailError[Show Error]
    ShowEmailError --> EnterEmail
    ValidateEmail -->|Yes| EnterName[Enter Full Name]
    EnterName --> EnterDOB[Enter Date of Birth]
    EnterDOB --> SelectGender[Select Gender]
    SelectGender --> EnterAddr[Enter Address]
    EnterAddr --> SelectEmergency[Select Emergency Contact]
    SelectEmergency --> AcceptTerms[Accept Terms & Conditions]
    AcceptTerms --> SaveProfile[Save Profile to Firestore]
    
    SetupProfile -->|Yes| SaveProfile
    
    SaveProfile --> ProfileSaved{Profile Saved<br/>Successfully?}
    
    ProfileSaved -->|No| ShowSaveError[Show Save Error]
    ShowSaveError --> Retry2{Retry?}
    Retry2 -->|Yes| SaveProfile
    Retry2 -->|No| SaveDraft[Save as Draft]
    SaveDraft --> End1([Return to App])
    
    ProfileSaved -->|Yes| SendWelcome[Send Welcome Email]
    SendWelcome --> SendNotif[Send Welcome Notification]
    SendNotif --> InitServices[Initialize User Services]
    InitServices --> CacheData[Cache User Data Locally]
    CacheData --> ShowSuccess[Show Success Message]
    
    ShowSuccess --> NavigateDash[Navigate to Dashboard]
    NavigateDash --> End2([Registration Complete])
```

---

## 12. HAZARD ZONE AND SAFETY INFORMATION FLOW

```mermaid
graph TD
    Start([User Taps Safety Info or Views Map]) --> LoadHazards[Load Hazard Zone Data]
    LoadHazards --> GetLocation[Get User Current Location]
    GetLocation --> QueryHazards[Query Hazard Zones Near Location]
    QueryHazards --> FetchHazards{Hazards<br/>Found?}
    
    FetchHazards -->|No| ShowNoHazards[Show: No Hazards in Area]
    ShowNoHazards --> OfferFunctions{User Action?}
    
    FetchHazards -->|Yes| DisplayHazards[Display Hazard Zones on Map]
    DisplayHazards --> ShowMarkers[Show Hazard Zone Markers]
    ShowMarkers --> ColorCode[Color Code by Severity]
    ColorCode --> OfferFunctions
    
    OfferFunctions -->|View Details| ViewDetail[Tap Hazard Marker]
    OfferFunctions -->|Report Hazard| ReportHazard[Open Report Form]
    OfferFunctions -->|View List| ListView[Show Hazard List View]
    OfferFunctions -->|Zoom Control| ZoomMap[Zoom In/Out]
    OfferFunctions -->|Back| GoBack[Return to Previous Screen]
    
    ViewDetail --> ShowPopup[Display Hazard Popup]
    ShowPopup --> HazardInfo["Show: Type, Severity,<br/>Location, Time Reported,<br/>Description"]
    HazardInfo --> PopupAction{User Action?}
    
    PopupAction -->|Close| OfferFunctions
    PopupAction -->|Report Similar| ReportHazard
    PopupAction -->|Avoid Route| AvoidRoute[Mark Route as Avoid]
    
    AvoidRoute --> UpdatePrefs[Update User Preferences]
    UpdatePrefs --> RecalculateRoutes[System Recalculates Routes]
    RecalculateRoutes --> OfferFunctions
    
    ReportHazard --> OpenReportForm[Display Hazard Report Form]
    OpenReportForm --> SelectType[Select Hazard Type]
    SelectType --> HazardTypes["- Accident<br/>- Construction<br/>- Bad Road Condition<br/>- Heavy Traffic<br/>- Weather Hazard<br/>- Other"]
    HazardTypes --> PickType[Pick Hazard Type]
    PickType --> SelectSeverity[Select Severity]
    SelectSeverity --> EnterDesc[Enter Description]
    EnterDesc --> AddMedia[Attach Photos]
    AddMedia --> ReviewReport[Review Report]
    ReviewReport --> SubmitHazard[Submit Hazard Report]
    
    SubmitHazard --> SaveHazard[Save to Firestore]
    SaveHazard --> NotifyUsers[Notify Nearby Users]
    NotifyUsers --> UpdateMap[Update Map Display]
    UpdateMap --> ShowSuccess[Show Success Message]
    ShowSuccess --> OfferFunctions
    
    ListView --> DisplayList[Show Hazard List]
    DisplayList --> HazardItems["Each Item Shows:<br/>- Type, Severity<br/>- Distance, Time<br/>- Number of Reports"]
    HazardItems --> SelectFromList[Select Hazard from List]
    SelectFromList --> ShowDetail[Show Full Details]
    ShowDetail --> OfferFunctions
    
    ZoomMap --> AdjustZoom[Adjust Map Zoom Level]
    AdjustZoom --> UpdateMarkers[Update Visible Markers]
    UpdateMarkers --> OfferFunctions
    
    GoBack --> SavePrefs[Save User Preferences]
    SavePrefs --> End([Return to Previous Screen])
```

---


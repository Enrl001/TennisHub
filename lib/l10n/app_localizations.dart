import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('mn'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MyClub'**
  String get appName;

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

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @roleSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'I am a...'**
  String get roleSelectTitle;

  /// No description provided for @roleCoach.
  ///
  /// In en, this message translates to:
  /// **'Tennis Coach'**
  String get roleCoach;

  /// No description provided for @roleCoachDesc.
  ///
  /// In en, this message translates to:
  /// **'I offer lessons and training'**
  String get roleCoachDesc;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Player / Student'**
  String get roleCustomer;

  /// No description provided for @roleCustomerDesc.
  ///
  /// In en, this message translates to:
  /// **'I\'m looking for lessons'**
  String get roleCustomerDesc;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Find Your Coach'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Connect with certified tennis coaches near you'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Book Sessions'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Schedule private or group lessons with ease'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Play Your Best'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Track your progress and improve your game'**
  String get onboardingDesc3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @searchCoaches.
  ///
  /// In en, this message translates to:
  /// **'Search coaches...'**
  String get searchCoaches;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get filterPrivate;

  /// No description provided for @filterGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get filterGroup;

  /// No description provided for @filterCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get filterCommunity;

  /// No description provided for @filterVirtual.
  ///
  /// In en, this message translates to:
  /// **'Virtual'**
  String get filterVirtual;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @slotsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} spots left'**
  String slotsLeft(int count);

  /// No description provided for @perHour.
  ///
  /// In en, this message translates to:
  /// **'/hr'**
  String get perHour;

  /// No description provided for @noCoachesFound.
  ///
  /// In en, this message translates to:
  /// **'No coaches found'**
  String get noCoachesFound;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @experienceYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years experience'**
  String experienceYears(int years);

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviews;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @selectSlot.
  ///
  /// In en, this message translates to:
  /// **'Select a Time Slot'**
  String get selectSlot;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @availableSpots.
  ///
  /// In en, this message translates to:
  /// **'{count} spots available'**
  String availableSpots(int count);

  /// No description provided for @slotFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get slotFull;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @requestBooking.
  ///
  /// In en, this message translates to:
  /// **'Request Booking'**
  String get requestBooking;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @payWithSmartpay.
  ///
  /// In en, this message translates to:
  /// **'Pay with Smartpay'**
  String get payWithSmartpay;

  /// No description provided for @paymentInstructions.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to Smartpay to complete your payment'**
  String get paymentInstructions;

  /// No description provided for @waitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment...'**
  String get waitingPayment;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @securePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure Payment'**
  String get securePayment;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get addToCalendar;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @bookingReference.
  ///
  /// In en, this message translates to:
  /// **'Booking Reference'**
  String get bookingReference;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for booking!'**
  String get thankYou;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @noBookingsToday.
  ///
  /// In en, this message translates to:
  /// **'No bookings today'**
  String get noBookingsToday;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get mySchedule;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

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

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @mongolian.
  ///
  /// In en, this message translates to:
  /// **'Монгол'**
  String get mongolian;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @upcomingSessions.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get upcomingSessions;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @addSlot.
  ///
  /// In en, this message translates to:
  /// **'Add Time Slot'**
  String get addSlot;

  /// No description provided for @manageServices.
  ///
  /// In en, this message translates to:
  /// **'Manage Services'**
  String get manageServices;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @bioMn.
  ///
  /// In en, this message translates to:
  /// **'Bio (Mongolian)'**
  String get bioMn;

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get yearsExperience;

  /// No description provided for @courtAddress.
  ///
  /// In en, this message translates to:
  /// **'Court Address'**
  String get courtAddress;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @privateLesson.
  ///
  /// In en, this message translates to:
  /// **'Private Lesson'**
  String get privateLesson;

  /// No description provided for @groupLesson.
  ///
  /// In en, this message translates to:
  /// **'Group Lesson'**
  String get groupLesson;

  /// No description provided for @communityEvent.
  ///
  /// In en, this message translates to:
  /// **'Community Event'**
  String get communityEvent;

  /// No description provided for @virtualSession.
  ///
  /// In en, this message translates to:
  /// **'Virtual Session'**
  String get virtualSession;

  /// No description provided for @titleEn.
  ///
  /// In en, this message translates to:
  /// **'Title (English)'**
  String get titleEn;

  /// No description provided for @titleMn.
  ///
  /// In en, this message translates to:
  /// **'Title (Mongolian)'**
  String get titleMn;

  /// No description provided for @descriptionEn.
  ///
  /// In en, this message translates to:
  /// **'Description (English)'**
  String get descriptionEn;

  /// No description provided for @descriptionMn.
  ///
  /// In en, this message translates to:
  /// **'Description (Mongolian)'**
  String get descriptionMn;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// No description provided for @priceAmount.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceAmount;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @maxParticipants.
  ///
  /// In en, this message translates to:
  /// **'Max Participants'**
  String get maxParticipants;

  /// No description provided for @videoPlatform.
  ///
  /// In en, this message translates to:
  /// **'Video Platform'**
  String get videoPlatform;

  /// No description provided for @videoUrl.
  ///
  /// In en, this message translates to:
  /// **'Video URL'**
  String get videoUrl;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @createSlot.
  ///
  /// In en, this message translates to:
  /// **'Create Slot'**
  String get createSlot;

  /// No description provided for @slotCreated.
  ///
  /// In en, this message translates to:
  /// **'Time slot created successfully'**
  String get slotCreated;

  /// No description provided for @duplicateSlot.
  ///
  /// In en, this message translates to:
  /// **'A slot already exists at this time for this service.'**
  String get duplicateSlot;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetails;

  /// No description provided for @requiredEquipment.
  ///
  /// In en, this message translates to:
  /// **'Required Equipment'**
  String get requiredEquipment;

  /// No description provided for @leaveReview.
  ///
  /// In en, this message translates to:
  /// **'Leave a Review'**
  String get leaveReview;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get reviewSubmitted;

  /// No description provided for @reviewAfterSession.
  ///
  /// In en, this message translates to:
  /// **'You can leave a review after the session ends.'**
  String get reviewAfterSession;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @noEquipmentListed.
  ///
  /// In en, this message translates to:
  /// **'No equipment listed'**
  String get noEquipmentListed;

  /// No description provided for @noLocationListed.
  ///
  /// In en, this message translates to:
  /// **'Location not specified'**
  String get noLocationListed;

  /// No description provided for @writeReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get writeReviewHint;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @sessionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get sessionLocation;

  /// No description provided for @serviceLocation.
  ///
  /// In en, this message translates to:
  /// **'Session location'**
  String get serviceLocation;

  /// No description provided for @equipmentHint.
  ///
  /// In en, this message translates to:
  /// **'Racket, shoes, water...'**
  String get equipmentHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutes(int count);

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @joinSession.
  ///
  /// In en, this message translates to:
  /// **'Join Session'**
  String get joinSession;

  /// No description provided for @noServicesYet.
  ///
  /// In en, this message translates to:
  /// **'No services yet'**
  String get noServicesYet;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Find. Book. Play.'**
  String get splashTagline;

  /// No description provided for @roleSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you will use MyClub'**
  String get roleSelectSubtitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your MyClub account'**
  String get createAccountSubtitle;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterYourName;

  /// No description provided for @checkEmailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Check your email and click the confirmation link, then sign in.'**
  String get checkEmailConfirm;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Try signing in instead.'**
  String get emailAlreadyRegistered;

  /// No description provided for @weeklyOverview.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY OVERVIEW'**
  String get weeklyOverview;

  /// No description provided for @weekView.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekView;

  /// No description provided for @monthView.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthView;

  /// No description provided for @openSlot.
  ///
  /// In en, this message translates to:
  /// **'Open Slot'**
  String get openSlot;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'OPEN'**
  String get statusOpen;

  /// No description provided for @playersBooked.
  ///
  /// In en, this message translates to:
  /// **'booked'**
  String get playersBooked;

  /// No description provided for @nothingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled'**
  String get nothingScheduled;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @startsInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Starts in {minutes} min'**
  String startsInMinutes(int minutes);

  /// No description provided for @noBioProvided.
  ///
  /// In en, this message translates to:
  /// **'No bio provided.'**
  String get noBioProvided;

  /// No description provided for @reviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewCount(int count);
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
      <String>['en', 'mn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mn':
      return AppLocalizationsMn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

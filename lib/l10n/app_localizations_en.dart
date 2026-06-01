// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tennis Hub';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get orDivider => 'OR';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get alreadyAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get roleSelectTitle => 'I am a...';

  @override
  String get roleCoach => 'Tennis Coach';

  @override
  String get roleCoachDesc => 'I offer lessons and training';

  @override
  String get roleCustomer => 'Player / Student';

  @override
  String get roleCustomerDesc => 'I\'m looking for lessons';

  @override
  String get onboardingTitle1 => 'Find Your Coach';

  @override
  String get onboardingDesc1 =>
      'Connect with certified tennis coaches near you';

  @override
  String get onboardingTitle2 => 'Book Sessions';

  @override
  String get onboardingDesc2 => 'Schedule private or group lessons with ease';

  @override
  String get onboardingTitle3 => 'Play Your Best';

  @override
  String get onboardingDesc3 => 'Track your progress and improve your game';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get home => 'Home';

  @override
  String get searchCoaches => 'Search coaches...';

  @override
  String get filterAll => 'All';

  @override
  String get filterPrivate => 'Private';

  @override
  String get filterGroup => 'Group';

  @override
  String get filterCommunity => 'Community';

  @override
  String get filterVirtual => 'Virtual';

  @override
  String get bookNow => 'Book Now';

  @override
  String slotsLeft(int count) {
    return '$count spots left';
  }

  @override
  String get perHour => '/hr';

  @override
  String get noCoachesFound => 'No coaches found';

  @override
  String get viewAll => 'View All';

  @override
  String get about => 'About';

  @override
  String get services => 'Services';

  @override
  String get reviews => 'Reviews';

  @override
  String experienceYears(int years) {
    return '$years years experience';
  }

  @override
  String get certifications => 'Certifications';

  @override
  String get location => 'Location';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get rating => 'Rating';

  @override
  String get selectSlot => 'Select a Time Slot';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get total => 'Total';

  @override
  String get duration => 'Duration';

  @override
  String get service => 'Service';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String availableSpots(int count) {
    return '$count spots available';
  }

  @override
  String get slotFull => 'Full';

  @override
  String get proceed => 'Proceed';

  @override
  String get payment => 'Payment';

  @override
  String get payWithSmartpay => 'Pay with Smartpay';

  @override
  String get paymentInstructions => 'You will be redirected to Smartpay to complete your payment';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get cvv => 'CVV';

  @override
  String get cardholderName => 'Cardholder Name';

  @override
  String get payNow => 'Pay Now';

  @override
  String get securePayment => 'Secure Payment';

  @override
  String get bookingConfirmed => 'Booking Confirmed!';

  @override
  String get addToCalendar => 'Add to Calendar';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get bookingReference => 'Booking Reference';

  @override
  String get thankYou => 'Thank you for booking!';

  @override
  String get calendar => 'Calendar';

  @override
  String get noBookingsToday => 'No bookings today';

  @override
  String get mySchedule => 'My Schedule';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get mongolian => 'Монгол';

  @override
  String get logout => 'Logout';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get upcomingSessions => 'Upcoming Sessions';

  @override
  String get totalEarnings => 'Total Earnings';

  @override
  String get thisMonth => 'This Month';

  @override
  String get addService => 'Add Service';

  @override
  String get addSlot => 'Add Time Slot';

  @override
  String get manageServices => 'Manage Services';

  @override
  String get sessions => 'Sessions';

  @override
  String get bio => 'Bio';

  @override
  String get bioMn => 'Bio (Mongolian)';

  @override
  String get yearsExperience => 'Years of Experience';

  @override
  String get courtAddress => 'Court Address';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get serviceType => 'Service Type';

  @override
  String get privateLesson => 'Private Lesson';

  @override
  String get groupLesson => 'Group Lesson';

  @override
  String get communityEvent => 'Community Event';

  @override
  String get virtualSession => 'Virtual Session';

  @override
  String get titleEn => 'Title (English)';

  @override
  String get titleMn => 'Title (Mongolian)';

  @override
  String get descriptionEn => 'Description (English)';

  @override
  String get descriptionMn => 'Description (Mongolian)';

  @override
  String get durationMinutes => 'Duration (minutes)';

  @override
  String get priceAmount => 'Price';

  @override
  String get currency => 'Currency';

  @override
  String get maxParticipants => 'Max Participants';

  @override
  String get videoPlatform => 'Video Platform';

  @override
  String get videoUrl => 'Video URL';

  @override
  String get selectDate => 'Select Date';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get createSlot => 'Create Slot';

  @override
  String get slotCreated => 'Time slot created successfully';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get loading => 'Loading...';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get success => 'Success';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get viewProfile => 'View Profile';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get completed => 'Completed';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get pending => 'Pending';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get joinSession => 'Join Session';

  @override
  String get noServicesYet => 'No services yet';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get required => 'Required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';
}

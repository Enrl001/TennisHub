// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class AppLocalizationsMn extends AppLocalizations {
  AppLocalizationsMn([String locale = 'mn']) : super(locale);

  @override
  String get appName => 'MyClub';

  @override
  String get login => 'Нэвтрэх';

  @override
  String get register => 'Бүртгүүлэх';

  @override
  String get email => 'Имэйл';

  @override
  String get password => 'Нууц үг';

  @override
  String get forgotPassword => 'Нууц үг мартсан уу?';

  @override
  String get continueWithGoogle => 'Google-ээр үргэлжлүүлэх';

  @override
  String get continueWithApple => 'Apple-ээр үргэлжлүүлэх';

  @override
  String get orDivider => 'ЭСВЭЛ';

  @override
  String get noAccount => 'Бүртгэл байхгүй юу?';

  @override
  String get signUp => 'Бүртгүүлэх';

  @override
  String get alreadyAccount => 'Аль хэдийн бүртгэлтэй юу?';

  @override
  String get signIn => 'Нэвтрэх';

  @override
  String get roleSelectTitle => 'Би...';

  @override
  String get roleCoach => 'Теннисийн дасгалжуулагч';

  @override
  String get roleCoachDesc => 'Би хичээл заадаг';

  @override
  String get roleCustomer => 'Тоглогч / Оюутан';

  @override
  String get roleCustomerDesc => 'Би хичээл хайж байна';

  @override
  String get onboardingTitle1 => 'Дасгалжуулагчаа олоорой';

  @override
  String get onboardingDesc1 =>
      'Ойролцоо мэргэшсэн теннисийн дасгалжуулагчтай холбогдоорой';

  @override
  String get onboardingTitle2 => 'Хичээл захиалаарай';

  @override
  String get onboardingDesc2 =>
      'Хувийн эсвэл бүлгийн хичээлийг хялбархан товлоорой';

  @override
  String get onboardingTitle3 => 'Хамгийн сайн тоглоорой';

  @override
  String get onboardingDesc3 => 'Дэвшлээ хянаж, тоглоомоо сайжруулаарай';

  @override
  String get getStarted => 'Эхлэх';

  @override
  String get next => 'Дараах';

  @override
  String get skip => 'Алгасах';

  @override
  String get home => 'Нүүр';

  @override
  String get searchCoaches => 'Дасгалжуулагч хайх...';

  @override
  String get filterAll => 'Бүгд';

  @override
  String get filterPrivate => 'Хувийн';

  @override
  String get filterGroup => 'Бүлгийн';

  @override
  String get filterCommunity => 'Нийтийн';

  @override
  String get filterVirtual => 'Виртуал';

  @override
  String get bookNow => 'Одоо захиалах';

  @override
  String get book => 'Захиалах';

  @override
  String slotsLeft(int count) {
    return '$count байр үлдсэн';
  }

  @override
  String get perHour => '/цаг';

  @override
  String get noCoachesFound => 'Дасгалжуулагч олдсонгүй';

  @override
  String get viewAll => 'Бүгдийг харах';

  @override
  String get about => 'Тухай';

  @override
  String get services => 'Үйлчилгээ';

  @override
  String get reviews => 'Үнэлгээ';

  @override
  String experienceYears(int years) {
    return '$years жилийн туршлага';
  }

  @override
  String get certifications => 'Гэрчилгээ';

  @override
  String get location => 'Байршил';

  @override
  String get noReviews => 'Үнэлгээ байхгүй байна';

  @override
  String get rating => 'Үнэлгээ';

  @override
  String get selectSlot => 'Цаг сонгох';

  @override
  String get bookingDetails => 'Захиалгын дэлгэрэнгүй';

  @override
  String get confirmBooking => 'Захиалга баталгаажуулах';

  @override
  String get total => 'Нийт';

  @override
  String get duration => 'Үргэлжлэх хугацаа';

  @override
  String get service => 'Үйлчилгээ';

  @override
  String get date => 'Огноо';

  @override
  String get time => 'Цаг';

  @override
  String availableSpots(int count) {
    return '$count байр боломжтой';
  }

  @override
  String get slotFull => 'Дүүрсэн';

  @override
  String get proceed => 'Үргэлжлүүлэх';

  @override
  String get requestBooking => 'Захиалга илгээх';

  @override
  String get payment => 'Төлбөр';

  @override
  String get payWithSmartpay => 'Smartpay-ээр төлөх';

  @override
  String get paymentInstructions => 'Та Smartpay руу хандан төлбөрөө гүйцэтгэнэ';

  @override
  String get cardNumber => 'Картын дугаар';

  @override
  String get expiryDate => 'Дуусах хугацаа';

  @override
  String get cvv => 'CVV';

  @override
  String get cardholderName => 'Карт эзэмшигчийн нэр';

  @override
  String get payNow => 'Одоо төлөх';

  @override
  String get securePayment => 'Найдвартай төлбөр';

  @override
  String get bookingConfirmed => 'Захиалга баталгаажлаа!';

  @override
  String get addToCalendar => 'Хуанлид нэмэх';

  @override
  String get backToHome => 'Нүүр хуудас руу буцах';

  @override
  String get bookingReference => 'Захиалгын лавлагаа';

  @override
  String get thankYou => 'Захиалсанд баярлалаа!';

  @override
  String get calendar => 'Хуанли';

  @override
  String get noBookingsToday => 'Өнөөдөр захиалга байхгүй';

  @override
  String get mySchedule => 'Миний хуваарь';

  @override
  String get notifications => 'Мэдэгдэл';

  @override
  String get noNotifications => 'Мэдэгдэл байхгүй байна';

  @override
  String get markAllRead => 'Бүгдийг уншсан гэж тэмдэглэх';

  @override
  String get profile => 'Профайл';

  @override
  String get settings => 'Тохиргоо';

  @override
  String get language => 'Хэл';

  @override
  String get english => 'English';

  @override
  String get mongolian => 'Монгол';

  @override
  String get logout => 'Гарах';

  @override
  String get editProfile => 'Профайл засах';

  @override
  String get dashboard => 'Хяналтын самбар';

  @override
  String get upcomingSessions => 'Удахгүй болох хичээлүүд';

  @override
  String get totalEarnings => 'Нийт орлого';

  @override
  String get thisMonth => 'Энэ сар';

  @override
  String get addService => 'Үйлчилгээ нэмэх';

  @override
  String get addSlot => 'Цагийн алхам нэмэх';

  @override
  String get manageServices => 'Үйлчилгээ удирдах';

  @override
  String get sessions => 'Хичээлүүд';

  @override
  String get bio => 'Намтар';

  @override
  String get bioMn => 'Намтар (Монгол)';

  @override
  String get yearsExperience => 'Туршлагын жил';

  @override
  String get courtAddress => 'Талбайн хаяг';

  @override
  String get saveChanges => 'Өөрчлөлт хадгалах';

  @override
  String get serviceType => 'Үйлчилгээний төрөл';

  @override
  String get privateLesson => 'Хувийн хичээл';

  @override
  String get groupLesson => 'Бүлгийн хичээл';

  @override
  String get communityEvent => 'Нийтийн арга хэмжээ';

  @override
  String get virtualSession => 'Виртуал хичээл';

  @override
  String get titleEn => 'Гарчиг (Англи)';

  @override
  String get titleMn => 'Гарчиг (Монгол)';

  @override
  String get descriptionEn => 'Тайлбар (Англи)';

  @override
  String get descriptionMn => 'Тайлбар (Монгол)';

  @override
  String get durationMinutes => 'Үргэлжлэх хугацаа (минут)';

  @override
  String get priceAmount => 'Үнэ';

  @override
  String get currency => 'Валют';

  @override
  String get maxParticipants => 'Дээд тоо';

  @override
  String get videoPlatform => 'Видео платформ';

  @override
  String get videoUrl => 'Видео URL';

  @override
  String get selectDate => 'Огноо сонгох';

  @override
  String get startTime => 'Эхлэх цаг';

  @override
  String get endTime => 'Дуусах цаг';

  @override
  String get createSlot => 'Цаг үүсгэх';

  @override
  String get slotCreated => 'Цагийн алхам амжилттай үүслэлаа';

  @override
  String get cancel => 'Цуцлах';

  @override
  String get save => 'Хадгалах';

  @override
  String get delete => 'Устгах';

  @override
  String get confirm => 'Баталгаажуулах';

  @override
  String get close => 'Хаах';

  @override
  String get loading => 'Ачааллаж байна...';

  @override
  String get errorOccurred => 'Алдаа гарлаа';

  @override
  String get retry => 'Дахин оролдох';

  @override
  String get success => 'Амжилттай';

  @override
  String minutes(int count) {
    return '$count мин';
  }

  @override
  String get viewProfile => 'Профайл харах';

  @override
  String get myBookings => 'Миний захиалгууд';

  @override
  String get completed => 'Дууссан';

  @override
  String get confirmed => 'Баталгаажсан';

  @override
  String get pending => 'Хүлээгдэж байна';

  @override
  String get cancelled => 'Цуцалсан';

  @override
  String get joinSession => 'Хичээлд нэгдэх';

  @override
  String get noServicesYet => 'Үйлчилгээ байхгүй байна';

  @override
  String get fullName => 'Бүтэн нэр';

  @override
  String get phoneNumber => 'Утасны дугаар';

  @override
  String get required => 'Шаардлагатай';

  @override
  String get invalidEmail => 'Зөв имэйл оруулна уу';

  @override
  String get passwordTooShort => 'Нууц үг дор хаяж 6 тэмдэгт байх ёстой';
}

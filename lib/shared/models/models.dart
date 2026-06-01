import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String role,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? phone,
    String? locale,
    @JsonKey(name: 'fcm_token') String? fcmToken,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@freezed
abstract class Coach with _$Coach {
  const factory Coach({
    required String id,
    @JsonKey(name: 'profile_id') required String profileId,
    String? bio,
    @JsonKey(name: 'bio_mn') String? bioMn,
    List<String>? certifications,
    @JsonKey(name: 'years_experience') int? yearsExperience,
    String? location,
    @JsonKey(name: 'avg_rating') double? avgRating,
    @JsonKey(name: 'total_reviews') int? totalReviews,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    Profile? profile,
    List<Service>? services,
  }) = _Coach;

  factory Coach.fromJson(Map<String, dynamic> json) => _$CoachFromJson(json);
}

@freezed
abstract class Service with _$Service {
  const factory Service({
    required String id,
    @JsonKey(name: 'coach_id') required String coachId,
    required String type,
    required String title,
    @JsonKey(name: 'title_mn') String? titleMn,
    String? description,
    @JsonKey(name: 'description_mn') String? descriptionMn,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'price_amount') double? priceAmount,
    String? currency,
    @JsonKey(name: 'max_participants') int? maxParticipants,
    @JsonKey(name: 'video_platform') String? videoPlatform,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}

@freezed
abstract class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required String id,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'coach_id') required String coachId,
    @JsonKey(name: 'starts_at') required DateTime startsAt,
    @JsonKey(name: 'ends_at') required DateTime endsAt,
    @JsonKey(name: 'booked_count') @Default(0) int bookedCount,
    @JsonKey(name: 'is_cancelled') @Default(false) bool isCancelled,
    Service? service,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}

@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,
    @JsonKey(name: 'slot_id') required String slotId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'coach_id') required String coachId,
    @JsonKey(name: 'customer_id') required String customerId,
    required String status,
    @JsonKey(name: 'amount_paid') double? amountPaid,
    String? currency,
    @JsonKey(name: 'video_room_id') String? videoRoomId,
    @JsonKey(name: 'video_room_url') String? videoRoomUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    TimeSlot? slot,
    Service? service,
    Coach? coach,
    Profile? customer,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'coach_id') required String coachId,
    required String status,
    required double amount,
    required String currency,
    @JsonKey(name: 'provider_payment_id') String? providerPaymentId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    String? type,
    String? title,
    @JsonKey(name: 'title_mn') String? titleMn,
    String? body,
    @JsonKey(name: 'body_mn') String? bodyMn,
    Map<String, dynamic>? data,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'coach_id') required String coachId,
    @JsonKey(name: 'customer_id') required String customerId,
    required int rating,
    String? comment,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    Profile? customer,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

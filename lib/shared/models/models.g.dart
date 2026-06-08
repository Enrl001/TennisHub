// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  role: json['role'] as String,
  fullName: json['full_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  phone: json['phone'] as String?,
  locale: json['locale'] as String?,
  fcmToken: json['fcm_token'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'role': instance.role,
  'full_name': instance.fullName,
  'avatar_url': instance.avatarUrl,
  'phone': instance.phone,
  'locale': instance.locale,
  'fcm_token': instance.fcmToken,
  'created_at': instance.createdAt?.toIso8601String(),
};

_Coach _$CoachFromJson(Map<String, dynamic> json) => _Coach(
  id: json['id'] as String,
  profileId: json['profile_id'] as String,
  bio: json['bio'] as String?,
  bioMn: json['bio_mn'] as String?,
  certifications: (json['certifications'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  yearsExperience: (json['years_experience'] as num?)?.toInt(),
  location: json['location'] as String?,
  avgRating: (json['avg_rating'] as num?)?.toDouble(),
  totalReviews: (json['total_reviews'] as num?)?.toInt(),
  isActive: json['is_active'] as bool? ?? true,
  profile: json['profile'] == null
      ? null
      : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  services: (json['services'] as List<dynamic>?)
      ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CoachToJson(_Coach instance) => <String, dynamic>{
  'id': instance.id,
  'profile_id': instance.profileId,
  'bio': instance.bio,
  'bio_mn': instance.bioMn,
  'certifications': instance.certifications,
  'years_experience': instance.yearsExperience,
  'location': instance.location,
  'avg_rating': instance.avgRating,
  'total_reviews': instance.totalReviews,
  'is_active': instance.isActive,
  'profile': instance.profile,
  'services': instance.services,
};

_Service _$ServiceFromJson(Map<String, dynamic> json) => _Service(
  id: json['id'] as String,
  coachId: json['coach_id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  titleMn: json['title_mn'] as String?,
  description: json['description'] as String?,
  descriptionMn: json['description_mn'] as String?,
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  priceAmount: (json['price_amount'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  maxParticipants: (json['max_participants'] as num?)?.toInt(),
  videoPlatform: json['video_platform'] as String?,
  videoUrl: json['video_url'] as String?,
  location: json['location'] as String?,
  locationMn: json['location_mn'] as String?,
  requiredEquipment: json['required_equipment'] as String?,
  requiredEquipmentMn: json['required_equipment_mn'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$ServiceToJson(_Service instance) => <String, dynamic>{
  'id': instance.id,
  'coach_id': instance.coachId,
  'type': instance.type,
  'title': instance.title,
  'title_mn': instance.titleMn,
  'description': instance.description,
  'description_mn': instance.descriptionMn,
  'duration_minutes': instance.durationMinutes,
  'price_amount': instance.priceAmount,
  'currency': instance.currency,
  'max_participants': instance.maxParticipants,
  'video_platform': instance.videoPlatform,
  'video_url': instance.videoUrl,
  'location': instance.location,
  'location_mn': instance.locationMn,
  'required_equipment': instance.requiredEquipment,
  'required_equipment_mn': instance.requiredEquipmentMn,
  'is_active': instance.isActive,
};

_TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => _TimeSlot(
  id: json['id'] as String,
  serviceId: json['service_id'] as String,
  coachId: json['coach_id'] as String,
  startsAt: DateTime.parse(json['starts_at'] as String),
  endsAt: DateTime.parse(json['ends_at'] as String),
  bookedCount: (json['booked_count'] as num?)?.toInt() ?? 0,
  isCancelled: json['is_cancelled'] as bool? ?? false,
  service: json['service'] == null
      ? null
      : Service.fromJson(json['service'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TimeSlotToJson(_TimeSlot instance) => <String, dynamic>{
  'id': instance.id,
  'service_id': instance.serviceId,
  'coach_id': instance.coachId,
  'starts_at': instance.startsAt.toIso8601String(),
  'ends_at': instance.endsAt.toIso8601String(),
  'booked_count': instance.bookedCount,
  'is_cancelled': instance.isCancelled,
  'service': instance.service,
};

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  slotId: json['slot_id'] as String,
  serviceId: json['service_id'] as String,
  coachId: json['coach_id'] as String,
  customerId: json['customer_id'] as String,
  status: json['status'] as String,
  amountPaid: (json['amount_paid'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  videoRoomId: json['video_room_id'] as String?,
  videoRoomUrl: json['video_room_url'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  slot: json['slot'] == null
      ? null
      : TimeSlot.fromJson(json['slot'] as Map<String, dynamic>),
  service: json['service'] == null
      ? null
      : Service.fromJson(json['service'] as Map<String, dynamic>),
  coach: json['coach'] == null
      ? null
      : Coach.fromJson(json['coach'] as Map<String, dynamic>),
  customer: json['customer'] == null
      ? null
      : Profile.fromJson(json['customer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'slot_id': instance.slotId,
  'service_id': instance.serviceId,
  'coach_id': instance.coachId,
  'customer_id': instance.customerId,
  'status': instance.status,
  'amount_paid': instance.amountPaid,
  'currency': instance.currency,
  'video_room_id': instance.videoRoomId,
  'video_room_url': instance.videoRoomUrl,
  'created_at': instance.createdAt?.toIso8601String(),
  'slot': instance.slot,
  'service': instance.service,
  'coach': instance.coach,
  'customer': instance.customer,
};

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  bookingId: json['booking_id'] as String,
  customerId: json['customer_id'] as String,
  coachId: json['coach_id'] as String,
  status: json['status'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  providerPaymentId: json['provider_payment_id'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'booking_id': instance.bookingId,
  'customer_id': instance.customerId,
  'coach_id': instance.coachId,
  'status': instance.status,
  'amount': instance.amount,
  'currency': instance.currency,
  'provider_payment_id': instance.providerPaymentId,
  'created_at': instance.createdAt?.toIso8601String(),
};

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String?,
      title: json['title'] as String?,
      titleMn: json['title_mn'] as String?,
      body: json['body'] as String?,
      bodyMn: json['body_mn'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'title_mn': instance.titleMn,
      'body': instance.body,
      'body_mn': instance.bodyMn,
      'data': instance.data,
      'is_read': instance.isRead,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  bookingId: json['booking_id'] as String,
  coachId: json['coach_id'] as String,
  customerId: json['customer_id'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  customer: json['customer'] == null
      ? null
      : Profile.fromJson(json['customer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'booking_id': instance.bookingId,
  'coach_id': instance.coachId,
  'customer_id': instance.customerId,
  'rating': instance.rating,
  'comment': instance.comment,
  'created_at': instance.createdAt?.toIso8601String(),
  'customer': instance.customer,
};

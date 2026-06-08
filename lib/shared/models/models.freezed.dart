// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get id; String get role;@JsonKey(name: 'full_name') String? get fullName;@JsonKey(name: 'avatar_url') String? get avatarUrl; String? get phone; String? get locale;@JsonKey(name: 'fcm_token') String? get fcmToken;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,fullName,avatarUrl,phone,locale,fcmToken,createdAt);

@override
String toString() {
  return 'Profile(id: $id, role: $role, fullName: $fullName, avatarUrl: $avatarUrl, phone: $phone, locale: $locale, fcmToken: $fcmToken, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id, String role,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'avatar_url') String? avatarUrl, String? phone, String? locale,@JsonKey(name: 'fcm_token') String? fcmToken,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? phone = freezed,Object? locale = freezed,Object? fcmToken = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? phone,  String? locale, @JsonKey(name: 'fcm_token')  String? fcmToken, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.role,_that.fullName,_that.avatarUrl,_that.phone,_that.locale,_that.fcmToken,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? phone,  String? locale, @JsonKey(name: 'fcm_token')  String? fcmToken, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.role,_that.fullName,_that.avatarUrl,_that.phone,_that.locale,_that.fcmToken,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? phone,  String? locale, @JsonKey(name: 'fcm_token')  String? fcmToken, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.role,_that.fullName,_that.avatarUrl,_that.phone,_that.locale,_that.fcmToken,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.id, required this.role, @JsonKey(name: 'full_name') this.fullName, @JsonKey(name: 'avatar_url') this.avatarUrl, this.phone, this.locale, @JsonKey(name: 'fcm_token') this.fcmToken, @JsonKey(name: 'created_at') this.createdAt});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String id;
@override final  String role;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  String? phone;
@override final  String? locale;
@override@JsonKey(name: 'fcm_token') final  String? fcmToken;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,fullName,avatarUrl,phone,locale,fcmToken,createdAt);

@override
String toString() {
  return 'Profile(id: $id, role: $role, fullName: $fullName, avatarUrl: $avatarUrl, phone: $phone, locale: $locale, fcmToken: $fcmToken, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String role,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'avatar_url') String? avatarUrl, String? phone, String? locale,@JsonKey(name: 'fcm_token') String? fcmToken,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? phone = freezed,Object? locale = freezed,Object? fcmToken = freezed,Object? createdAt = freezed,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Coach {

 String get id;@JsonKey(name: 'profile_id') String get profileId; String? get bio;@JsonKey(name: 'bio_mn') String? get bioMn; List<String>? get certifications;@JsonKey(name: 'years_experience') int? get yearsExperience; String? get location;@JsonKey(name: 'avg_rating') double? get avgRating;@JsonKey(name: 'total_reviews') int? get totalReviews;@JsonKey(name: 'is_active') bool get isActive; Profile? get profile; List<Service>? get services;
/// Create a copy of Coach
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachCopyWith<Coach> get copyWith => _$CoachCopyWithImpl<Coach>(this as Coach, _$identity);

  /// Serializes this Coach to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coach&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.bioMn, bioMn) || other.bioMn == bioMn)&&const DeepCollectionEquality().equals(other.certifications, certifications)&&(identical(other.yearsExperience, yearsExperience) || other.yearsExperience == yearsExperience)&&(identical(other.location, location) || other.location == location)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.services, services));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,bio,bioMn,const DeepCollectionEquality().hash(certifications),yearsExperience,location,avgRating,totalReviews,isActive,profile,const DeepCollectionEquality().hash(services));

@override
String toString() {
  return 'Coach(id: $id, profileId: $profileId, bio: $bio, bioMn: $bioMn, certifications: $certifications, yearsExperience: $yearsExperience, location: $location, avgRating: $avgRating, totalReviews: $totalReviews, isActive: $isActive, profile: $profile, services: $services)';
}


}

/// @nodoc
abstract mixin class $CoachCopyWith<$Res>  {
  factory $CoachCopyWith(Coach value, $Res Function(Coach) _then) = _$CoachCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'profile_id') String profileId, String? bio,@JsonKey(name: 'bio_mn') String? bioMn, List<String>? certifications,@JsonKey(name: 'years_experience') int? yearsExperience, String? location,@JsonKey(name: 'avg_rating') double? avgRating,@JsonKey(name: 'total_reviews') int? totalReviews,@JsonKey(name: 'is_active') bool isActive, Profile? profile, List<Service>? services
});


$ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$CoachCopyWithImpl<$Res>
    implements $CoachCopyWith<$Res> {
  _$CoachCopyWithImpl(this._self, this._then);

  final Coach _self;
  final $Res Function(Coach) _then;

/// Create a copy of Coach
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? bio = freezed,Object? bioMn = freezed,Object? certifications = freezed,Object? yearsExperience = freezed,Object? location = freezed,Object? avgRating = freezed,Object? totalReviews = freezed,Object? isActive = null,Object? profile = freezed,Object? services = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,bioMn: freezed == bioMn ? _self.bioMn : bioMn // ignore: cast_nullable_to_non_nullable
as String?,certifications: freezed == certifications ? _self.certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<String>?,yearsExperience: freezed == yearsExperience ? _self.yearsExperience : yearsExperience // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,avgRating: freezed == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double?,totalReviews: freezed == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,services: freezed == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<Service>?,
  ));
}
/// Create a copy of Coach
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [Coach].
extension CoachPatterns on Coach {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coach value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coach() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coach value)  $default,){
final _that = this;
switch (_that) {
case _Coach():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coach value)?  $default,){
final _that = this;
switch (_that) {
case _Coach() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'profile_id')  String profileId,  String? bio, @JsonKey(name: 'bio_mn')  String? bioMn,  List<String>? certifications, @JsonKey(name: 'years_experience')  int? yearsExperience,  String? location, @JsonKey(name: 'avg_rating')  double? avgRating, @JsonKey(name: 'total_reviews')  int? totalReviews, @JsonKey(name: 'is_active')  bool isActive,  Profile? profile,  List<Service>? services)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coach() when $default != null:
return $default(_that.id,_that.profileId,_that.bio,_that.bioMn,_that.certifications,_that.yearsExperience,_that.location,_that.avgRating,_that.totalReviews,_that.isActive,_that.profile,_that.services);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'profile_id')  String profileId,  String? bio, @JsonKey(name: 'bio_mn')  String? bioMn,  List<String>? certifications, @JsonKey(name: 'years_experience')  int? yearsExperience,  String? location, @JsonKey(name: 'avg_rating')  double? avgRating, @JsonKey(name: 'total_reviews')  int? totalReviews, @JsonKey(name: 'is_active')  bool isActive,  Profile? profile,  List<Service>? services)  $default,) {final _that = this;
switch (_that) {
case _Coach():
return $default(_that.id,_that.profileId,_that.bio,_that.bioMn,_that.certifications,_that.yearsExperience,_that.location,_that.avgRating,_that.totalReviews,_that.isActive,_that.profile,_that.services);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'profile_id')  String profileId,  String? bio, @JsonKey(name: 'bio_mn')  String? bioMn,  List<String>? certifications, @JsonKey(name: 'years_experience')  int? yearsExperience,  String? location, @JsonKey(name: 'avg_rating')  double? avgRating, @JsonKey(name: 'total_reviews')  int? totalReviews, @JsonKey(name: 'is_active')  bool isActive,  Profile? profile,  List<Service>? services)?  $default,) {final _that = this;
switch (_that) {
case _Coach() when $default != null:
return $default(_that.id,_that.profileId,_that.bio,_that.bioMn,_that.certifications,_that.yearsExperience,_that.location,_that.avgRating,_that.totalReviews,_that.isActive,_that.profile,_that.services);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coach implements Coach {
  const _Coach({required this.id, @JsonKey(name: 'profile_id') required this.profileId, this.bio, @JsonKey(name: 'bio_mn') this.bioMn, final  List<String>? certifications, @JsonKey(name: 'years_experience') this.yearsExperience, this.location, @JsonKey(name: 'avg_rating') this.avgRating, @JsonKey(name: 'total_reviews') this.totalReviews, @JsonKey(name: 'is_active') this.isActive = true, this.profile, final  List<Service>? services}): _certifications = certifications,_services = services;
  factory _Coach.fromJson(Map<String, dynamic> json) => _$CoachFromJson(json);

@override final  String id;
@override@JsonKey(name: 'profile_id') final  String profileId;
@override final  String? bio;
@override@JsonKey(name: 'bio_mn') final  String? bioMn;
 final  List<String>? _certifications;
@override List<String>? get certifications {
  final value = _certifications;
  if (value == null) return null;
  if (_certifications is EqualUnmodifiableListView) return _certifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'years_experience') final  int? yearsExperience;
@override final  String? location;
@override@JsonKey(name: 'avg_rating') final  double? avgRating;
@override@JsonKey(name: 'total_reviews') final  int? totalReviews;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override final  Profile? profile;
 final  List<Service>? _services;
@override List<Service>? get services {
  final value = _services;
  if (value == null) return null;
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Coach
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachCopyWith<_Coach> get copyWith => __$CoachCopyWithImpl<_Coach>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coach&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.bioMn, bioMn) || other.bioMn == bioMn)&&const DeepCollectionEquality().equals(other._certifications, _certifications)&&(identical(other.yearsExperience, yearsExperience) || other.yearsExperience == yearsExperience)&&(identical(other.location, location) || other.location == location)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other._services, _services));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,bio,bioMn,const DeepCollectionEquality().hash(_certifications),yearsExperience,location,avgRating,totalReviews,isActive,profile,const DeepCollectionEquality().hash(_services));

@override
String toString() {
  return 'Coach(id: $id, profileId: $profileId, bio: $bio, bioMn: $bioMn, certifications: $certifications, yearsExperience: $yearsExperience, location: $location, avgRating: $avgRating, totalReviews: $totalReviews, isActive: $isActive, profile: $profile, services: $services)';
}


}

/// @nodoc
abstract mixin class _$CoachCopyWith<$Res> implements $CoachCopyWith<$Res> {
  factory _$CoachCopyWith(_Coach value, $Res Function(_Coach) _then) = __$CoachCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'profile_id') String profileId, String? bio,@JsonKey(name: 'bio_mn') String? bioMn, List<String>? certifications,@JsonKey(name: 'years_experience') int? yearsExperience, String? location,@JsonKey(name: 'avg_rating') double? avgRating,@JsonKey(name: 'total_reviews') int? totalReviews,@JsonKey(name: 'is_active') bool isActive, Profile? profile, List<Service>? services
});


@override $ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$CoachCopyWithImpl<$Res>
    implements _$CoachCopyWith<$Res> {
  __$CoachCopyWithImpl(this._self, this._then);

  final _Coach _self;
  final $Res Function(_Coach) _then;

/// Create a copy of Coach
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? bio = freezed,Object? bioMn = freezed,Object? certifications = freezed,Object? yearsExperience = freezed,Object? location = freezed,Object? avgRating = freezed,Object? totalReviews = freezed,Object? isActive = null,Object? profile = freezed,Object? services = freezed,}) {
  return _then(_Coach(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,bioMn: freezed == bioMn ? _self.bioMn : bioMn // ignore: cast_nullable_to_non_nullable
as String?,certifications: freezed == certifications ? _self._certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<String>?,yearsExperience: freezed == yearsExperience ? _self.yearsExperience : yearsExperience // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,avgRating: freezed == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double?,totalReviews: freezed == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,services: freezed == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<Service>?,
  ));
}

/// Create a copy of Coach
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$Service {

 String get id;@JsonKey(name: 'coach_id') String get coachId; String get type; String get title;@JsonKey(name: 'title_mn') String? get titleMn; String? get description;@JsonKey(name: 'description_mn') String? get descriptionMn;@JsonKey(name: 'duration_minutes') int? get durationMinutes;@JsonKey(name: 'price_amount') double? get priceAmount; String? get currency;@JsonKey(name: 'max_participants') int? get maxParticipants;@JsonKey(name: 'video_platform') String? get videoPlatform;@JsonKey(name: 'video_url') String? get videoUrl; String? get location;@JsonKey(name: 'location_mn') String? get locationMn;@JsonKey(name: 'required_equipment') String? get requiredEquipment;@JsonKey(name: 'required_equipment_mn') String? get requiredEquipmentMn;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCopyWith<Service> get copyWith => _$ServiceCopyWithImpl<Service>(this as Service, _$identity);

  /// Serializes this Service to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Service&&(identical(other.id, id) || other.id == id)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleMn, titleMn) || other.titleMn == titleMn)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionMn, descriptionMn) || other.descriptionMn == descriptionMn)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.videoPlatform, videoPlatform) || other.videoPlatform == videoPlatform)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.locationMn, locationMn) || other.locationMn == locationMn)&&(identical(other.requiredEquipment, requiredEquipment) || other.requiredEquipment == requiredEquipment)&&(identical(other.requiredEquipmentMn, requiredEquipmentMn) || other.requiredEquipmentMn == requiredEquipmentMn)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,coachId,type,title,titleMn,description,descriptionMn,durationMinutes,priceAmount,currency,maxParticipants,videoPlatform,videoUrl,location,locationMn,requiredEquipment,requiredEquipmentMn,isActive);

@override
String toString() {
  return 'Service(id: $id, coachId: $coachId, type: $type, title: $title, titleMn: $titleMn, description: $description, descriptionMn: $descriptionMn, durationMinutes: $durationMinutes, priceAmount: $priceAmount, currency: $currency, maxParticipants: $maxParticipants, videoPlatform: $videoPlatform, videoUrl: $videoUrl, location: $location, locationMn: $locationMn, requiredEquipment: $requiredEquipment, requiredEquipmentMn: $requiredEquipmentMn, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ServiceCopyWith<$Res>  {
  factory $ServiceCopyWith(Service value, $Res Function(Service) _then) = _$ServiceCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'coach_id') String coachId, String type, String title,@JsonKey(name: 'title_mn') String? titleMn, String? description,@JsonKey(name: 'description_mn') String? descriptionMn,@JsonKey(name: 'duration_minutes') int? durationMinutes,@JsonKey(name: 'price_amount') double? priceAmount, String? currency,@JsonKey(name: 'max_participants') int? maxParticipants,@JsonKey(name: 'video_platform') String? videoPlatform,@JsonKey(name: 'video_url') String? videoUrl, String? location,@JsonKey(name: 'location_mn') String? locationMn,@JsonKey(name: 'required_equipment') String? requiredEquipment,@JsonKey(name: 'required_equipment_mn') String? requiredEquipmentMn,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ServiceCopyWithImpl<$Res>
    implements $ServiceCopyWith<$Res> {
  _$ServiceCopyWithImpl(this._self, this._then);

  final Service _self;
  final $Res Function(Service) _then;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? coachId = null,Object? type = null,Object? title = null,Object? titleMn = freezed,Object? description = freezed,Object? descriptionMn = freezed,Object? durationMinutes = freezed,Object? priceAmount = freezed,Object? currency = freezed,Object? maxParticipants = freezed,Object? videoPlatform = freezed,Object? videoUrl = freezed,Object? location = freezed,Object? locationMn = freezed,Object? requiredEquipment = freezed,Object? requiredEquipmentMn = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleMn: freezed == titleMn ? _self.titleMn : titleMn // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionMn: freezed == descriptionMn ? _self.descriptionMn : descriptionMn // ignore: cast_nullable_to_non_nullable
as String?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,priceAmount: freezed == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,videoPlatform: freezed == videoPlatform ? _self.videoPlatform : videoPlatform // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,locationMn: freezed == locationMn ? _self.locationMn : locationMn // ignore: cast_nullable_to_non_nullable
as String?,requiredEquipment: freezed == requiredEquipment ? _self.requiredEquipment : requiredEquipment // ignore: cast_nullable_to_non_nullable
as String?,requiredEquipmentMn: freezed == requiredEquipmentMn ? _self.requiredEquipmentMn : requiredEquipmentMn // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Service].
extension ServicePatterns on Service {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Service value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Service value)  $default,){
final _that = this;
switch (_that) {
case _Service():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Service value)?  $default,){
final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'coach_id')  String coachId,  String type,  String title, @JsonKey(name: 'title_mn')  String? titleMn,  String? description, @JsonKey(name: 'description_mn')  String? descriptionMn, @JsonKey(name: 'duration_minutes')  int? durationMinutes, @JsonKey(name: 'price_amount')  double? priceAmount,  String? currency, @JsonKey(name: 'max_participants')  int? maxParticipants, @JsonKey(name: 'video_platform')  String? videoPlatform, @JsonKey(name: 'video_url')  String? videoUrl,  String? location, @JsonKey(name: 'location_mn')  String? locationMn, @JsonKey(name: 'required_equipment')  String? requiredEquipment, @JsonKey(name: 'required_equipment_mn')  String? requiredEquipmentMn, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that.id,_that.coachId,_that.type,_that.title,_that.titleMn,_that.description,_that.descriptionMn,_that.durationMinutes,_that.priceAmount,_that.currency,_that.maxParticipants,_that.videoPlatform,_that.videoUrl,_that.location,_that.locationMn,_that.requiredEquipment,_that.requiredEquipmentMn,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'coach_id')  String coachId,  String type,  String title, @JsonKey(name: 'title_mn')  String? titleMn,  String? description, @JsonKey(name: 'description_mn')  String? descriptionMn, @JsonKey(name: 'duration_minutes')  int? durationMinutes, @JsonKey(name: 'price_amount')  double? priceAmount,  String? currency, @JsonKey(name: 'max_participants')  int? maxParticipants, @JsonKey(name: 'video_platform')  String? videoPlatform, @JsonKey(name: 'video_url')  String? videoUrl,  String? location, @JsonKey(name: 'location_mn')  String? locationMn, @JsonKey(name: 'required_equipment')  String? requiredEquipment, @JsonKey(name: 'required_equipment_mn')  String? requiredEquipmentMn, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Service():
return $default(_that.id,_that.coachId,_that.type,_that.title,_that.titleMn,_that.description,_that.descriptionMn,_that.durationMinutes,_that.priceAmount,_that.currency,_that.maxParticipants,_that.videoPlatform,_that.videoUrl,_that.location,_that.locationMn,_that.requiredEquipment,_that.requiredEquipmentMn,_that.isActive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'coach_id')  String coachId,  String type,  String title, @JsonKey(name: 'title_mn')  String? titleMn,  String? description, @JsonKey(name: 'description_mn')  String? descriptionMn, @JsonKey(name: 'duration_minutes')  int? durationMinutes, @JsonKey(name: 'price_amount')  double? priceAmount,  String? currency, @JsonKey(name: 'max_participants')  int? maxParticipants, @JsonKey(name: 'video_platform')  String? videoPlatform, @JsonKey(name: 'video_url')  String? videoUrl,  String? location, @JsonKey(name: 'location_mn')  String? locationMn, @JsonKey(name: 'required_equipment')  String? requiredEquipment, @JsonKey(name: 'required_equipment_mn')  String? requiredEquipmentMn, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that.id,_that.coachId,_that.type,_that.title,_that.titleMn,_that.description,_that.descriptionMn,_that.durationMinutes,_that.priceAmount,_that.currency,_that.maxParticipants,_that.videoPlatform,_that.videoUrl,_that.location,_that.locationMn,_that.requiredEquipment,_that.requiredEquipmentMn,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Service implements Service {
  const _Service({required this.id, @JsonKey(name: 'coach_id') required this.coachId, required this.type, required this.title, @JsonKey(name: 'title_mn') this.titleMn, this.description, @JsonKey(name: 'description_mn') this.descriptionMn, @JsonKey(name: 'duration_minutes') this.durationMinutes, @JsonKey(name: 'price_amount') this.priceAmount, this.currency, @JsonKey(name: 'max_participants') this.maxParticipants, @JsonKey(name: 'video_platform') this.videoPlatform, @JsonKey(name: 'video_url') this.videoUrl, this.location, @JsonKey(name: 'location_mn') this.locationMn, @JsonKey(name: 'required_equipment') this.requiredEquipment, @JsonKey(name: 'required_equipment_mn') this.requiredEquipmentMn, @JsonKey(name: 'is_active') this.isActive = true});
  factory _Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

@override final  String id;
@override@JsonKey(name: 'coach_id') final  String coachId;
@override final  String type;
@override final  String title;
@override@JsonKey(name: 'title_mn') final  String? titleMn;
@override final  String? description;
@override@JsonKey(name: 'description_mn') final  String? descriptionMn;
@override@JsonKey(name: 'duration_minutes') final  int? durationMinutes;
@override@JsonKey(name: 'price_amount') final  double? priceAmount;
@override final  String? currency;
@override@JsonKey(name: 'max_participants') final  int? maxParticipants;
@override@JsonKey(name: 'video_platform') final  String? videoPlatform;
@override@JsonKey(name: 'video_url') final  String? videoUrl;
@override final  String? location;
@override@JsonKey(name: 'location_mn') final  String? locationMn;
@override@JsonKey(name: 'required_equipment') final  String? requiredEquipment;
@override@JsonKey(name: 'required_equipment_mn') final  String? requiredEquipmentMn;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCopyWith<_Service> get copyWith => __$ServiceCopyWithImpl<_Service>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Service&&(identical(other.id, id) || other.id == id)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleMn, titleMn) || other.titleMn == titleMn)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionMn, descriptionMn) || other.descriptionMn == descriptionMn)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.videoPlatform, videoPlatform) || other.videoPlatform == videoPlatform)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.locationMn, locationMn) || other.locationMn == locationMn)&&(identical(other.requiredEquipment, requiredEquipment) || other.requiredEquipment == requiredEquipment)&&(identical(other.requiredEquipmentMn, requiredEquipmentMn) || other.requiredEquipmentMn == requiredEquipmentMn)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,coachId,type,title,titleMn,description,descriptionMn,durationMinutes,priceAmount,currency,maxParticipants,videoPlatform,videoUrl,location,locationMn,requiredEquipment,requiredEquipmentMn,isActive);

@override
String toString() {
  return 'Service(id: $id, coachId: $coachId, type: $type, title: $title, titleMn: $titleMn, description: $description, descriptionMn: $descriptionMn, durationMinutes: $durationMinutes, priceAmount: $priceAmount, currency: $currency, maxParticipants: $maxParticipants, videoPlatform: $videoPlatform, videoUrl: $videoUrl, location: $location, locationMn: $locationMn, requiredEquipment: $requiredEquipment, requiredEquipmentMn: $requiredEquipmentMn, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ServiceCopyWith<$Res> implements $ServiceCopyWith<$Res> {
  factory _$ServiceCopyWith(_Service value, $Res Function(_Service) _then) = __$ServiceCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'coach_id') String coachId, String type, String title,@JsonKey(name: 'title_mn') String? titleMn, String? description,@JsonKey(name: 'description_mn') String? descriptionMn,@JsonKey(name: 'duration_minutes') int? durationMinutes,@JsonKey(name: 'price_amount') double? priceAmount, String? currency,@JsonKey(name: 'max_participants') int? maxParticipants,@JsonKey(name: 'video_platform') String? videoPlatform,@JsonKey(name: 'video_url') String? videoUrl, String? location,@JsonKey(name: 'location_mn') String? locationMn,@JsonKey(name: 'required_equipment') String? requiredEquipment,@JsonKey(name: 'required_equipment_mn') String? requiredEquipmentMn,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ServiceCopyWithImpl<$Res>
    implements _$ServiceCopyWith<$Res> {
  __$ServiceCopyWithImpl(this._self, this._then);

  final _Service _self;
  final $Res Function(_Service) _then;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? coachId = null,Object? type = null,Object? title = null,Object? titleMn = freezed,Object? description = freezed,Object? descriptionMn = freezed,Object? durationMinutes = freezed,Object? priceAmount = freezed,Object? currency = freezed,Object? maxParticipants = freezed,Object? videoPlatform = freezed,Object? videoUrl = freezed,Object? location = freezed,Object? locationMn = freezed,Object? requiredEquipment = freezed,Object? requiredEquipmentMn = freezed,Object? isActive = null,}) {
  return _then(_Service(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleMn: freezed == titleMn ? _self.titleMn : titleMn // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionMn: freezed == descriptionMn ? _self.descriptionMn : descriptionMn // ignore: cast_nullable_to_non_nullable
as String?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,priceAmount: freezed == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,videoPlatform: freezed == videoPlatform ? _self.videoPlatform : videoPlatform // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,locationMn: freezed == locationMn ? _self.locationMn : locationMn // ignore: cast_nullable_to_non_nullable
as String?,requiredEquipment: freezed == requiredEquipment ? _self.requiredEquipment : requiredEquipment // ignore: cast_nullable_to_non_nullable
as String?,requiredEquipmentMn: freezed == requiredEquipmentMn ? _self.requiredEquipmentMn : requiredEquipmentMn // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TimeSlot {

 String get id;@JsonKey(name: 'service_id') String get serviceId;@JsonKey(name: 'coach_id') String get coachId;@JsonKey(name: 'starts_at') DateTime get startsAt;@JsonKey(name: 'ends_at') DateTime get endsAt;@JsonKey(name: 'booked_count') int get bookedCount;@JsonKey(name: 'is_cancelled') bool get isCancelled; Service? get service;
/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<TimeSlot> get copyWith => _$TimeSlotCopyWithImpl<TimeSlot>(this as TimeSlot, _$identity);

  /// Serializes this TimeSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.bookedCount, bookedCount) || other.bookedCount == bookedCount)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.service, service) || other.service == service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serviceId,coachId,startsAt,endsAt,bookedCount,isCancelled,service);

@override
String toString() {
  return 'TimeSlot(id: $id, serviceId: $serviceId, coachId: $coachId, startsAt: $startsAt, endsAt: $endsAt, bookedCount: $bookedCount, isCancelled: $isCancelled, service: $service)';
}


}

/// @nodoc
abstract mixin class $TimeSlotCopyWith<$Res>  {
  factory $TimeSlotCopyWith(TimeSlot value, $Res Function(TimeSlot) _then) = _$TimeSlotCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'service_id') String serviceId,@JsonKey(name: 'coach_id') String coachId,@JsonKey(name: 'starts_at') DateTime startsAt,@JsonKey(name: 'ends_at') DateTime endsAt,@JsonKey(name: 'booked_count') int bookedCount,@JsonKey(name: 'is_cancelled') bool isCancelled, Service? service
});


$ServiceCopyWith<$Res>? get service;

}
/// @nodoc
class _$TimeSlotCopyWithImpl<$Res>
    implements $TimeSlotCopyWith<$Res> {
  _$TimeSlotCopyWithImpl(this._self, this._then);

  final TimeSlot _self;
  final $Res Function(TimeSlot) _then;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serviceId = null,Object? coachId = null,Object? startsAt = null,Object? endsAt = null,Object? bookedCount = null,Object? isCancelled = null,Object? service = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,bookedCount: null == bookedCount ? _self.bookedCount : bookedCount // ignore: cast_nullable_to_non_nullable
as int,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,
  ));
}
/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}
}


/// Adds pattern-matching-related methods to [TimeSlot].
extension TimeSlotPatterns on TimeSlot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSlot value)  $default,){
final _that = this;
switch (_that) {
case _TimeSlot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSlot value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'service_id')  String serviceId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt, @JsonKey(name: 'booked_count')  int bookedCount, @JsonKey(name: 'is_cancelled')  bool isCancelled,  Service? service)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that.id,_that.serviceId,_that.coachId,_that.startsAt,_that.endsAt,_that.bookedCount,_that.isCancelled,_that.service);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'service_id')  String serviceId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt, @JsonKey(name: 'booked_count')  int bookedCount, @JsonKey(name: 'is_cancelled')  bool isCancelled,  Service? service)  $default,) {final _that = this;
switch (_that) {
case _TimeSlot():
return $default(_that.id,_that.serviceId,_that.coachId,_that.startsAt,_that.endsAt,_that.bookedCount,_that.isCancelled,_that.service);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'service_id')  String serviceId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'starts_at')  DateTime startsAt, @JsonKey(name: 'ends_at')  DateTime endsAt, @JsonKey(name: 'booked_count')  int bookedCount, @JsonKey(name: 'is_cancelled')  bool isCancelled,  Service? service)?  $default,) {final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that.id,_that.serviceId,_that.coachId,_that.startsAt,_that.endsAt,_that.bookedCount,_that.isCancelled,_that.service);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSlot implements TimeSlot {
  const _TimeSlot({required this.id, @JsonKey(name: 'service_id') required this.serviceId, @JsonKey(name: 'coach_id') required this.coachId, @JsonKey(name: 'starts_at') required this.startsAt, @JsonKey(name: 'ends_at') required this.endsAt, @JsonKey(name: 'booked_count') this.bookedCount = 0, @JsonKey(name: 'is_cancelled') this.isCancelled = false, this.service});
  factory _TimeSlot.fromJson(Map<String, dynamic> json) => _$TimeSlotFromJson(json);

@override final  String id;
@override@JsonKey(name: 'service_id') final  String serviceId;
@override@JsonKey(name: 'coach_id') final  String coachId;
@override@JsonKey(name: 'starts_at') final  DateTime startsAt;
@override@JsonKey(name: 'ends_at') final  DateTime endsAt;
@override@JsonKey(name: 'booked_count') final  int bookedCount;
@override@JsonKey(name: 'is_cancelled') final  bool isCancelled;
@override final  Service? service;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSlotCopyWith<_TimeSlot> get copyWith => __$TimeSlotCopyWithImpl<_TimeSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.bookedCount, bookedCount) || other.bookedCount == bookedCount)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.service, service) || other.service == service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serviceId,coachId,startsAt,endsAt,bookedCount,isCancelled,service);

@override
String toString() {
  return 'TimeSlot(id: $id, serviceId: $serviceId, coachId: $coachId, startsAt: $startsAt, endsAt: $endsAt, bookedCount: $bookedCount, isCancelled: $isCancelled, service: $service)';
}


}

/// @nodoc
abstract mixin class _$TimeSlotCopyWith<$Res> implements $TimeSlotCopyWith<$Res> {
  factory _$TimeSlotCopyWith(_TimeSlot value, $Res Function(_TimeSlot) _then) = __$TimeSlotCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'service_id') String serviceId,@JsonKey(name: 'coach_id') String coachId,@JsonKey(name: 'starts_at') DateTime startsAt,@JsonKey(name: 'ends_at') DateTime endsAt,@JsonKey(name: 'booked_count') int bookedCount,@JsonKey(name: 'is_cancelled') bool isCancelled, Service? service
});


@override $ServiceCopyWith<$Res>? get service;

}
/// @nodoc
class __$TimeSlotCopyWithImpl<$Res>
    implements _$TimeSlotCopyWith<$Res> {
  __$TimeSlotCopyWithImpl(this._self, this._then);

  final _TimeSlot _self;
  final $Res Function(_TimeSlot) _then;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serviceId = null,Object? coachId = null,Object? startsAt = null,Object? endsAt = null,Object? bookedCount = null,Object? isCancelled = null,Object? service = freezed,}) {
  return _then(_TimeSlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,bookedCount: null == bookedCount ? _self.bookedCount : bookedCount // ignore: cast_nullable_to_non_nullable
as int,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,
  ));
}

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}
}


/// @nodoc
mixin _$Booking {

 String get id;@JsonKey(name: 'slot_id') String get slotId;@JsonKey(name: 'service_id') String get serviceId;@JsonKey(name: 'coach_id') String get coachId;@JsonKey(name: 'customer_id') String get customerId; String get status;@JsonKey(name: 'amount_paid') double? get amountPaid; String? get currency;@JsonKey(name: 'video_room_id') String? get videoRoomId;@JsonKey(name: 'video_room_url') String? get videoRoomUrl;@JsonKey(name: 'created_at') DateTime? get createdAt; TimeSlot? get slot; Service? get service; Coach? get coach; Profile? get customer;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.videoRoomId, videoRoomId) || other.videoRoomId == videoRoomId)&&(identical(other.videoRoomUrl, videoRoomUrl) || other.videoRoomUrl == videoRoomUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.service, service) || other.service == service)&&(identical(other.coach, coach) || other.coach == coach)&&(identical(other.customer, customer) || other.customer == customer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slotId,serviceId,coachId,customerId,status,amountPaid,currency,videoRoomId,videoRoomUrl,createdAt,slot,service,coach,customer);

@override
String toString() {
  return 'Booking(id: $id, slotId: $slotId, serviceId: $serviceId, coachId: $coachId, customerId: $customerId, status: $status, amountPaid: $amountPaid, currency: $currency, videoRoomId: $videoRoomId, videoRoomUrl: $videoRoomUrl, createdAt: $createdAt, slot: $slot, service: $service, coach: $coach, customer: $customer)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'slot_id') String slotId,@JsonKey(name: 'service_id') String serviceId,@JsonKey(name: 'coach_id') String coachId,@JsonKey(name: 'customer_id') String customerId, String status,@JsonKey(name: 'amount_paid') double? amountPaid, String? currency,@JsonKey(name: 'video_room_id') String? videoRoomId,@JsonKey(name: 'video_room_url') String? videoRoomUrl,@JsonKey(name: 'created_at') DateTime? createdAt, TimeSlot? slot, Service? service, Coach? coach, Profile? customer
});


$TimeSlotCopyWith<$Res>? get slot;$ServiceCopyWith<$Res>? get service;$CoachCopyWith<$Res>? get coach;$ProfileCopyWith<$Res>? get customer;

}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slotId = null,Object? serviceId = null,Object? coachId = null,Object? customerId = null,Object? status = null,Object? amountPaid = freezed,Object? currency = freezed,Object? videoRoomId = freezed,Object? videoRoomUrl = freezed,Object? createdAt = freezed,Object? slot = freezed,Object? service = freezed,Object? coach = freezed,Object? customer = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amountPaid: freezed == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,videoRoomId: freezed == videoRoomId ? _self.videoRoomId : videoRoomId // ignore: cast_nullable_to_non_nullable
as String?,videoRoomUrl: freezed == videoRoomUrl ? _self.videoRoomUrl : videoRoomUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,coach: freezed == coach ? _self.coach : coach // ignore: cast_nullable_to_non_nullable
as Coach?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<$Res>? get slot {
    if (_self.slot == null) {
    return null;
  }

  return $TimeSlotCopyWith<$Res>(_self.slot!, (value) {
    return _then(_self.copyWith(slot: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachCopyWith<$Res>? get coach {
    if (_self.coach == null) {
    return null;
  }

  return $CoachCopyWith<$Res>(_self.coach!, (value) {
    return _then(_self.copyWith(coach: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'slot_id')  String slotId, @JsonKey(name: 'service_id')  String serviceId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'customer_id')  String customerId,  String status, @JsonKey(name: 'amount_paid')  double? amountPaid,  String? currency, @JsonKey(name: 'video_room_id')  String? videoRoomId, @JsonKey(name: 'video_room_url')  String? videoRoomUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  TimeSlot? slot,  Service? service,  Coach? coach,  Profile? customer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.slotId,_that.serviceId,_that.coachId,_that.customerId,_that.status,_that.amountPaid,_that.currency,_that.videoRoomId,_that.videoRoomUrl,_that.createdAt,_that.slot,_that.service,_that.coach,_that.customer);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'slot_id')  String slotId, @JsonKey(name: 'service_id')  String serviceId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'customer_id')  String customerId,  String status, @JsonKey(name: 'amount_paid')  double? amountPaid,  String? currency, @JsonKey(name: 'video_room_id')  String? videoRoomId, @JsonKey(name: 'video_room_url')  String? videoRoomUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  TimeSlot? slot,  Service? service,  Coach? coach,  Profile? customer)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.slotId,_that.serviceId,_that.coachId,_that.customerId,_that.status,_that.amountPaid,_that.currency,_that.videoRoomId,_that.videoRoomUrl,_that.createdAt,_that.slot,_that.service,_that.coach,_that.customer);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'slot_id')  String slotId, @JsonKey(name: 'service_id')  String serviceId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'customer_id')  String customerId,  String status, @JsonKey(name: 'amount_paid')  double? amountPaid,  String? currency, @JsonKey(name: 'video_room_id')  String? videoRoomId, @JsonKey(name: 'video_room_url')  String? videoRoomUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  TimeSlot? slot,  Service? service,  Coach? coach,  Profile? customer)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.slotId,_that.serviceId,_that.coachId,_that.customerId,_that.status,_that.amountPaid,_that.currency,_that.videoRoomId,_that.videoRoomUrl,_that.createdAt,_that.slot,_that.service,_that.coach,_that.customer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.id, @JsonKey(name: 'slot_id') required this.slotId, @JsonKey(name: 'service_id') required this.serviceId, @JsonKey(name: 'coach_id') required this.coachId, @JsonKey(name: 'customer_id') required this.customerId, required this.status, @JsonKey(name: 'amount_paid') this.amountPaid, this.currency, @JsonKey(name: 'video_room_id') this.videoRoomId, @JsonKey(name: 'video_room_url') this.videoRoomUrl, @JsonKey(name: 'created_at') this.createdAt, this.slot, this.service, this.coach, this.customer});
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String id;
@override@JsonKey(name: 'slot_id') final  String slotId;
@override@JsonKey(name: 'service_id') final  String serviceId;
@override@JsonKey(name: 'coach_id') final  String coachId;
@override@JsonKey(name: 'customer_id') final  String customerId;
@override final  String status;
@override@JsonKey(name: 'amount_paid') final  double? amountPaid;
@override final  String? currency;
@override@JsonKey(name: 'video_room_id') final  String? videoRoomId;
@override@JsonKey(name: 'video_room_url') final  String? videoRoomUrl;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override final  TimeSlot? slot;
@override final  Service? service;
@override final  Coach? coach;
@override final  Profile? customer;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.videoRoomId, videoRoomId) || other.videoRoomId == videoRoomId)&&(identical(other.videoRoomUrl, videoRoomUrl) || other.videoRoomUrl == videoRoomUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.service, service) || other.service == service)&&(identical(other.coach, coach) || other.coach == coach)&&(identical(other.customer, customer) || other.customer == customer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slotId,serviceId,coachId,customerId,status,amountPaid,currency,videoRoomId,videoRoomUrl,createdAt,slot,service,coach,customer);

@override
String toString() {
  return 'Booking(id: $id, slotId: $slotId, serviceId: $serviceId, coachId: $coachId, customerId: $customerId, status: $status, amountPaid: $amountPaid, currency: $currency, videoRoomId: $videoRoomId, videoRoomUrl: $videoRoomUrl, createdAt: $createdAt, slot: $slot, service: $service, coach: $coach, customer: $customer)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'slot_id') String slotId,@JsonKey(name: 'service_id') String serviceId,@JsonKey(name: 'coach_id') String coachId,@JsonKey(name: 'customer_id') String customerId, String status,@JsonKey(name: 'amount_paid') double? amountPaid, String? currency,@JsonKey(name: 'video_room_id') String? videoRoomId,@JsonKey(name: 'video_room_url') String? videoRoomUrl,@JsonKey(name: 'created_at') DateTime? createdAt, TimeSlot? slot, Service? service, Coach? coach, Profile? customer
});


@override $TimeSlotCopyWith<$Res>? get slot;@override $ServiceCopyWith<$Res>? get service;@override $CoachCopyWith<$Res>? get coach;@override $ProfileCopyWith<$Res>? get customer;

}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slotId = null,Object? serviceId = null,Object? coachId = null,Object? customerId = null,Object? status = null,Object? amountPaid = freezed,Object? currency = freezed,Object? videoRoomId = freezed,Object? videoRoomUrl = freezed,Object? createdAt = freezed,Object? slot = freezed,Object? service = freezed,Object? coach = freezed,Object? customer = freezed,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amountPaid: freezed == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,videoRoomId: freezed == videoRoomId ? _self.videoRoomId : videoRoomId // ignore: cast_nullable_to_non_nullable
as String?,videoRoomUrl: freezed == videoRoomUrl ? _self.videoRoomUrl : videoRoomUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,coach: freezed == coach ? _self.coach : coach // ignore: cast_nullable_to_non_nullable
as Coach?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<$Res>? get slot {
    if (_self.slot == null) {
    return null;
  }

  return $TimeSlotCopyWith<$Res>(_self.slot!, (value) {
    return _then(_self.copyWith(slot: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachCopyWith<$Res>? get coach {
    if (_self.coach == null) {
    return null;
  }

  return $CoachCopyWith<$Res>(_self.coach!, (value) {
    return _then(_self.copyWith(coach: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// @nodoc
mixin _$Payment {

 String get id;@JsonKey(name: 'booking_id') String get bookingId;@JsonKey(name: 'customer_id') String get customerId;@JsonKey(name: 'coach_id') String get coachId; String get status; double get amount; String get currency;@JsonKey(name: 'provider_payment_id') String? get providerPaymentId;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.providerPaymentId, providerPaymentId) || other.providerPaymentId == providerPaymentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,customerId,coachId,status,amount,currency,providerPaymentId,createdAt);

@override
String toString() {
  return 'Payment(id: $id, bookingId: $bookingId, customerId: $customerId, coachId: $coachId, status: $status, amount: $amount, currency: $currency, providerPaymentId: $providerPaymentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'coach_id') String coachId, String status, double amount, String currency,@JsonKey(name: 'provider_payment_id') String? providerPaymentId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingId = null,Object? customerId = null,Object? coachId = null,Object? status = null,Object? amount = null,Object? currency = null,Object? providerPaymentId = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,providerPaymentId: freezed == providerPaymentId ? _self.providerPaymentId : providerPaymentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'coach_id')  String coachId,  String status,  double amount,  String currency, @JsonKey(name: 'provider_payment_id')  String? providerPaymentId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.bookingId,_that.customerId,_that.coachId,_that.status,_that.amount,_that.currency,_that.providerPaymentId,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'coach_id')  String coachId,  String status,  double amount,  String currency, @JsonKey(name: 'provider_payment_id')  String? providerPaymentId, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.bookingId,_that.customerId,_that.coachId,_that.status,_that.amount,_that.currency,_that.providerPaymentId,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'coach_id')  String coachId,  String status,  double amount,  String currency, @JsonKey(name: 'provider_payment_id')  String? providerPaymentId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.bookingId,_that.customerId,_that.coachId,_that.status,_that.amount,_that.currency,_that.providerPaymentId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({required this.id, @JsonKey(name: 'booking_id') required this.bookingId, @JsonKey(name: 'customer_id') required this.customerId, @JsonKey(name: 'coach_id') required this.coachId, required this.status, required this.amount, required this.currency, @JsonKey(name: 'provider_payment_id') this.providerPaymentId, @JsonKey(name: 'created_at') this.createdAt});
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String id;
@override@JsonKey(name: 'booking_id') final  String bookingId;
@override@JsonKey(name: 'customer_id') final  String customerId;
@override@JsonKey(name: 'coach_id') final  String coachId;
@override final  String status;
@override final  double amount;
@override final  String currency;
@override@JsonKey(name: 'provider_payment_id') final  String? providerPaymentId;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.providerPaymentId, providerPaymentId) || other.providerPaymentId == providerPaymentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,customerId,coachId,status,amount,currency,providerPaymentId,createdAt);

@override
String toString() {
  return 'Payment(id: $id, bookingId: $bookingId, customerId: $customerId, coachId: $coachId, status: $status, amount: $amount, currency: $currency, providerPaymentId: $providerPaymentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'coach_id') String coachId, String status, double amount, String currency,@JsonKey(name: 'provider_payment_id') String? providerPaymentId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingId = null,Object? customerId = null,Object? coachId = null,Object? status = null,Object? amount = null,Object? currency = null,Object? providerPaymentId = freezed,Object? createdAt = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,providerPaymentId: freezed == providerPaymentId ? _self.providerPaymentId : providerPaymentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AppNotification {

 String get id;@JsonKey(name: 'user_id') String get userId; String? get type; String? get title;@JsonKey(name: 'title_mn') String? get titleMn; String? get body;@JsonKey(name: 'body_mn') String? get bodyMn; Map<String, dynamic>? get data;@JsonKey(name: 'is_read') bool get isRead;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleMn, titleMn) || other.titleMn == titleMn)&&(identical(other.body, body) || other.body == body)&&(identical(other.bodyMn, bodyMn) || other.bodyMn == bodyMn)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,title,titleMn,body,bodyMn,const DeepCollectionEquality().hash(data),isRead,createdAt);

@override
String toString() {
  return 'AppNotification(id: $id, userId: $userId, type: $type, title: $title, titleMn: $titleMn, body: $body, bodyMn: $bodyMn, data: $data, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String? type, String? title,@JsonKey(name: 'title_mn') String? titleMn, String? body,@JsonKey(name: 'body_mn') String? bodyMn, Map<String, dynamic>? data,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? type = freezed,Object? title = freezed,Object? titleMn = freezed,Object? body = freezed,Object? bodyMn = freezed,Object? data = freezed,Object? isRead = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleMn: freezed == titleMn ? _self.titleMn : titleMn // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,bodyMn: freezed == bodyMn ? _self.bodyMn : bodyMn // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String? type,  String? title, @JsonKey(name: 'title_mn')  String? titleMn,  String? body, @JsonKey(name: 'body_mn')  String? bodyMn,  Map<String, dynamic>? data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.titleMn,_that.body,_that.bodyMn,_that.data,_that.isRead,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String? type,  String? title, @JsonKey(name: 'title_mn')  String? titleMn,  String? body, @JsonKey(name: 'body_mn')  String? bodyMn,  Map<String, dynamic>? data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.id,_that.userId,_that.type,_that.title,_that.titleMn,_that.body,_that.bodyMn,_that.data,_that.isRead,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String? type,  String? title, @JsonKey(name: 'title_mn')  String? titleMn,  String? body, @JsonKey(name: 'body_mn')  String? bodyMn,  Map<String, dynamic>? data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.titleMn,_that.body,_that.bodyMn,_that.data,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification implements AppNotification {
  const _AppNotification({required this.id, @JsonKey(name: 'user_id') required this.userId, this.type, this.title, @JsonKey(name: 'title_mn') this.titleMn, this.body, @JsonKey(name: 'body_mn') this.bodyMn, final  Map<String, dynamic>? data, @JsonKey(name: 'is_read') this.isRead = false, @JsonKey(name: 'created_at') this.createdAt}): _data = data;
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String? type;
@override final  String? title;
@override@JsonKey(name: 'title_mn') final  String? titleMn;
@override final  String? body;
@override@JsonKey(name: 'body_mn') final  String? bodyMn;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'is_read') final  bool isRead;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleMn, titleMn) || other.titleMn == titleMn)&&(identical(other.body, body) || other.body == body)&&(identical(other.bodyMn, bodyMn) || other.bodyMn == bodyMn)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,title,titleMn,body,bodyMn,const DeepCollectionEquality().hash(_data),isRead,createdAt);

@override
String toString() {
  return 'AppNotification(id: $id, userId: $userId, type: $type, title: $title, titleMn: $titleMn, body: $body, bodyMn: $bodyMn, data: $data, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String? type, String? title,@JsonKey(name: 'title_mn') String? titleMn, String? body,@JsonKey(name: 'body_mn') String? bodyMn, Map<String, dynamic>? data,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? type = freezed,Object? title = freezed,Object? titleMn = freezed,Object? body = freezed,Object? bodyMn = freezed,Object? data = freezed,Object? isRead = null,Object? createdAt = freezed,}) {
  return _then(_AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleMn: freezed == titleMn ? _self.titleMn : titleMn // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,bodyMn: freezed == bodyMn ? _self.bodyMn : bodyMn // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Review {

 String get id;@JsonKey(name: 'booking_id') String get bookingId;@JsonKey(name: 'coach_id') String get coachId;@JsonKey(name: 'customer_id') String get customerId; int get rating; String? get comment;@JsonKey(name: 'created_at') DateTime? get createdAt; Profile? get customer;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.customer, customer) || other.customer == customer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,coachId,customerId,rating,comment,createdAt,customer);

@override
String toString() {
  return 'Review(id: $id, bookingId: $bookingId, coachId: $coachId, customerId: $customerId, rating: $rating, comment: $comment, createdAt: $createdAt, customer: $customer)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId,@JsonKey(name: 'coach_id') String coachId,@JsonKey(name: 'customer_id') String customerId, int rating, String? comment,@JsonKey(name: 'created_at') DateTime? createdAt, Profile? customer
});


$ProfileCopyWith<$Res>? get customer;

}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingId = null,Object? coachId = null,Object? customerId = null,Object? rating = null,Object? comment = freezed,Object? createdAt = freezed,Object? customer = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'customer_id')  String customerId,  int rating,  String? comment, @JsonKey(name: 'created_at')  DateTime? createdAt,  Profile? customer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.bookingId,_that.coachId,_that.customerId,_that.rating,_that.comment,_that.createdAt,_that.customer);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'customer_id')  String customerId,  int rating,  String? comment, @JsonKey(name: 'created_at')  DateTime? createdAt,  Profile? customer)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.id,_that.bookingId,_that.coachId,_that.customerId,_that.rating,_that.comment,_that.createdAt,_that.customer);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'booking_id')  String bookingId, @JsonKey(name: 'coach_id')  String coachId, @JsonKey(name: 'customer_id')  String customerId,  int rating,  String? comment, @JsonKey(name: 'created_at')  DateTime? createdAt,  Profile? customer)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.bookingId,_that.coachId,_that.customerId,_that.rating,_that.comment,_that.createdAt,_that.customer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.id, @JsonKey(name: 'booking_id') required this.bookingId, @JsonKey(name: 'coach_id') required this.coachId, @JsonKey(name: 'customer_id') required this.customerId, required this.rating, this.comment, @JsonKey(name: 'created_at') this.createdAt, this.customer});
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String id;
@override@JsonKey(name: 'booking_id') final  String bookingId;
@override@JsonKey(name: 'coach_id') final  String coachId;
@override@JsonKey(name: 'customer_id') final  String customerId;
@override final  int rating;
@override final  String? comment;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override final  Profile? customer;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.customer, customer) || other.customer == customer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,coachId,customerId,rating,comment,createdAt,customer);

@override
String toString() {
  return 'Review(id: $id, bookingId: $bookingId, coachId: $coachId, customerId: $customerId, rating: $rating, comment: $comment, createdAt: $createdAt, customer: $customer)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'booking_id') String bookingId,@JsonKey(name: 'coach_id') String coachId,@JsonKey(name: 'customer_id') String customerId, int rating, String? comment,@JsonKey(name: 'created_at') DateTime? createdAt, Profile? customer
});


@override $ProfileCopyWith<$Res>? get customer;

}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingId = null,Object? coachId = null,Object? customerId = null,Object? rating = null,Object? comment = freezed,Object? createdAt = freezed,Object? customer = freezed,}) {
  return _then(_Review(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,coachId: null == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

// dart format on

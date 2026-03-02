// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progression_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressionEntity {

 int get totalXp; int get currentWinStreak; int get bestWinStreak;
/// Create a copy of ProgressionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressionEntityCopyWith<ProgressionEntity> get copyWith => _$ProgressionEntityCopyWithImpl<ProgressionEntity>(this as ProgressionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressionEntity&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.currentWinStreak, currentWinStreak) || other.currentWinStreak == currentWinStreak)&&(identical(other.bestWinStreak, bestWinStreak) || other.bestWinStreak == bestWinStreak));
}


@override
int get hashCode => Object.hash(runtimeType,totalXp,currentWinStreak,bestWinStreak);

@override
String toString() {
  return 'ProgressionEntity(totalXp: $totalXp, currentWinStreak: $currentWinStreak, bestWinStreak: $bestWinStreak)';
}


}

/// @nodoc
abstract mixin class $ProgressionEntityCopyWith<$Res>  {
  factory $ProgressionEntityCopyWith(ProgressionEntity value, $Res Function(ProgressionEntity) _then) = _$ProgressionEntityCopyWithImpl;
@useResult
$Res call({
 int totalXp, int currentWinStreak, int bestWinStreak
});




}
/// @nodoc
class _$ProgressionEntityCopyWithImpl<$Res>
    implements $ProgressionEntityCopyWith<$Res> {
  _$ProgressionEntityCopyWithImpl(this._self, this._then);

  final ProgressionEntity _self;
  final $Res Function(ProgressionEntity) _then;

/// Create a copy of ProgressionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalXp = null,Object? currentWinStreak = null,Object? bestWinStreak = null,}) {
  return _then(_self.copyWith(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,currentWinStreak: null == currentWinStreak ? _self.currentWinStreak : currentWinStreak // ignore: cast_nullable_to_non_nullable
as int,bestWinStreak: null == bestWinStreak ? _self.bestWinStreak : bestWinStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressionEntity].
extension ProgressionEntityPatterns on ProgressionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressionEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProgressionEntity():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalXp,  int currentWinStreak,  int bestWinStreak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressionEntity() when $default != null:
return $default(_that.totalXp,_that.currentWinStreak,_that.bestWinStreak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalXp,  int currentWinStreak,  int bestWinStreak)  $default,) {final _that = this;
switch (_that) {
case _ProgressionEntity():
return $default(_that.totalXp,_that.currentWinStreak,_that.bestWinStreak);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalXp,  int currentWinStreak,  int bestWinStreak)?  $default,) {final _that = this;
switch (_that) {
case _ProgressionEntity() when $default != null:
return $default(_that.totalXp,_that.currentWinStreak,_that.bestWinStreak);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressionEntity extends ProgressionEntity {
  const _ProgressionEntity({this.totalXp = 0, this.currentWinStreak = 0, this.bestWinStreak = 0}): super._();
  

@override@JsonKey() final  int totalXp;
@override@JsonKey() final  int currentWinStreak;
@override@JsonKey() final  int bestWinStreak;

/// Create a copy of ProgressionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressionEntityCopyWith<_ProgressionEntity> get copyWith => __$ProgressionEntityCopyWithImpl<_ProgressionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressionEntity&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.currentWinStreak, currentWinStreak) || other.currentWinStreak == currentWinStreak)&&(identical(other.bestWinStreak, bestWinStreak) || other.bestWinStreak == bestWinStreak));
}


@override
int get hashCode => Object.hash(runtimeType,totalXp,currentWinStreak,bestWinStreak);

@override
String toString() {
  return 'ProgressionEntity(totalXp: $totalXp, currentWinStreak: $currentWinStreak, bestWinStreak: $bestWinStreak)';
}


}

/// @nodoc
abstract mixin class _$ProgressionEntityCopyWith<$Res> implements $ProgressionEntityCopyWith<$Res> {
  factory _$ProgressionEntityCopyWith(_ProgressionEntity value, $Res Function(_ProgressionEntity) _then) = __$ProgressionEntityCopyWithImpl;
@override @useResult
$Res call({
 int totalXp, int currentWinStreak, int bestWinStreak
});




}
/// @nodoc
class __$ProgressionEntityCopyWithImpl<$Res>
    implements _$ProgressionEntityCopyWith<$Res> {
  __$ProgressionEntityCopyWithImpl(this._self, this._then);

  final _ProgressionEntity _self;
  final $Res Function(_ProgressionEntity) _then;

/// Create a copy of ProgressionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalXp = null,Object? currentWinStreak = null,Object? bestWinStreak = null,}) {
  return _then(_ProgressionEntity(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,currentWinStreak: null == currentWinStreak ? _self.currentWinStreak : currentWinStreak // ignore: cast_nullable_to_non_nullable
as int,bestWinStreak: null == bestWinStreak ? _self.bestWinStreak : bestWinStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_result_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameResultEntity {

 GameStatus get result; PlayerSide get humanSide; double get aiLevel; int get betAmount; int get winnings; DateTime get playedAt; Duration get duration; int get moveCount; bool get isCashOut;
/// Create a copy of GameResultEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameResultEntityCopyWith<GameResultEntity> get copyWith => _$GameResultEntityCopyWithImpl<GameResultEntity>(this as GameResultEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameResultEntity&&(identical(other.result, result) || other.result == result)&&(identical(other.humanSide, humanSide) || other.humanSide == humanSide)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.winnings, winnings) || other.winnings == winnings)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount)&&(identical(other.isCashOut, isCashOut) || other.isCashOut == isCashOut));
}


@override
int get hashCode => Object.hash(runtimeType,result,humanSide,aiLevel,betAmount,winnings,playedAt,duration,moveCount,isCashOut);

@override
String toString() {
  return 'GameResultEntity(result: $result, humanSide: $humanSide, aiLevel: $aiLevel, betAmount: $betAmount, winnings: $winnings, playedAt: $playedAt, duration: $duration, moveCount: $moveCount, isCashOut: $isCashOut)';
}


}

/// @nodoc
abstract mixin class $GameResultEntityCopyWith<$Res>  {
  factory $GameResultEntityCopyWith(GameResultEntity value, $Res Function(GameResultEntity) _then) = _$GameResultEntityCopyWithImpl;
@useResult
$Res call({
 GameStatus result, PlayerSide humanSide, double aiLevel, int betAmount, int winnings, DateTime playedAt, Duration duration, int moveCount, bool isCashOut
});




}
/// @nodoc
class _$GameResultEntityCopyWithImpl<$Res>
    implements $GameResultEntityCopyWith<$Res> {
  _$GameResultEntityCopyWithImpl(this._self, this._then);

  final GameResultEntity _self;
  final $Res Function(GameResultEntity) _then;

/// Create a copy of GameResultEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = null,Object? humanSide = null,Object? aiLevel = null,Object? betAmount = null,Object? winnings = null,Object? playedAt = null,Object? duration = null,Object? moveCount = null,Object? isCashOut = null,}) {
  return _then(_self.copyWith(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as GameStatus,humanSide: null == humanSide ? _self.humanSide : humanSide // ignore: cast_nullable_to_non_nullable
as PlayerSide,aiLevel: null == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as double,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,winnings: null == winnings ? _self.winnings : winnings // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,isCashOut: null == isCashOut ? _self.isCashOut : isCashOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GameResultEntity].
extension GameResultEntityPatterns on GameResultEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameResultEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameResultEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameResultEntity value)  $default,){
final _that = this;
switch (_that) {
case _GameResultEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameResultEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GameResultEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameStatus result,  PlayerSide humanSide,  double aiLevel,  int betAmount,  int winnings,  DateTime playedAt,  Duration duration,  int moveCount,  bool isCashOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameResultEntity() when $default != null:
return $default(_that.result,_that.humanSide,_that.aiLevel,_that.betAmount,_that.winnings,_that.playedAt,_that.duration,_that.moveCount,_that.isCashOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameStatus result,  PlayerSide humanSide,  double aiLevel,  int betAmount,  int winnings,  DateTime playedAt,  Duration duration,  int moveCount,  bool isCashOut)  $default,) {final _that = this;
switch (_that) {
case _GameResultEntity():
return $default(_that.result,_that.humanSide,_that.aiLevel,_that.betAmount,_that.winnings,_that.playedAt,_that.duration,_that.moveCount,_that.isCashOut);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameStatus result,  PlayerSide humanSide,  double aiLevel,  int betAmount,  int winnings,  DateTime playedAt,  Duration duration,  int moveCount,  bool isCashOut)?  $default,) {final _that = this;
switch (_that) {
case _GameResultEntity() when $default != null:
return $default(_that.result,_that.humanSide,_that.aiLevel,_that.betAmount,_that.winnings,_that.playedAt,_that.duration,_that.moveCount,_that.isCashOut);case _:
  return null;

}
}

}

/// @nodoc


class _GameResultEntity extends GameResultEntity {
  const _GameResultEntity({required this.result, required this.humanSide, required this.aiLevel, required this.betAmount, required this.winnings, required this.playedAt, required this.duration, required this.moveCount, this.isCashOut = false}): super._();
  

@override final  GameStatus result;
@override final  PlayerSide humanSide;
@override final  double aiLevel;
@override final  int betAmount;
@override final  int winnings;
@override final  DateTime playedAt;
@override final  Duration duration;
@override final  int moveCount;
@override@JsonKey() final  bool isCashOut;

/// Create a copy of GameResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameResultEntityCopyWith<_GameResultEntity> get copyWith => __$GameResultEntityCopyWithImpl<_GameResultEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameResultEntity&&(identical(other.result, result) || other.result == result)&&(identical(other.humanSide, humanSide) || other.humanSide == humanSide)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.winnings, winnings) || other.winnings == winnings)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount)&&(identical(other.isCashOut, isCashOut) || other.isCashOut == isCashOut));
}


@override
int get hashCode => Object.hash(runtimeType,result,humanSide,aiLevel,betAmount,winnings,playedAt,duration,moveCount,isCashOut);

@override
String toString() {
  return 'GameResultEntity(result: $result, humanSide: $humanSide, aiLevel: $aiLevel, betAmount: $betAmount, winnings: $winnings, playedAt: $playedAt, duration: $duration, moveCount: $moveCount, isCashOut: $isCashOut)';
}


}

/// @nodoc
abstract mixin class _$GameResultEntityCopyWith<$Res> implements $GameResultEntityCopyWith<$Res> {
  factory _$GameResultEntityCopyWith(_GameResultEntity value, $Res Function(_GameResultEntity) _then) = __$GameResultEntityCopyWithImpl;
@override @useResult
$Res call({
 GameStatus result, PlayerSide humanSide, double aiLevel, int betAmount, int winnings, DateTime playedAt, Duration duration, int moveCount, bool isCashOut
});




}
/// @nodoc
class __$GameResultEntityCopyWithImpl<$Res>
    implements _$GameResultEntityCopyWith<$Res> {
  __$GameResultEntityCopyWithImpl(this._self, this._then);

  final _GameResultEntity _self;
  final $Res Function(_GameResultEntity) _then;

/// Create a copy of GameResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = null,Object? humanSide = null,Object? aiLevel = null,Object? betAmount = null,Object? winnings = null,Object? playedAt = null,Object? duration = null,Object? moveCount = null,Object? isCashOut = null,}) {
  return _then(_GameResultEntity(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as GameStatus,humanSide: null == humanSide ? _self.humanSide : humanSide // ignore: cast_nullable_to_non_nullable
as PlayerSide,aiLevel: null == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as double,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,winnings: null == winnings ? _self.winnings : winnings // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,isCashOut: null == isCashOut ? _self.isCashOut : isCashOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

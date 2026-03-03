// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameResultModel {

 String get result; String get humanSide; double get aiLevel; int get betAmount; int get winnings; String get playedAt; int get durationSeconds; int get moveCount; bool get isCashOut;
/// Create a copy of GameResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameResultModelCopyWith<GameResultModel> get copyWith => _$GameResultModelCopyWithImpl<GameResultModel>(this as GameResultModel, _$identity);

  /// Serializes this GameResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameResultModel&&(identical(other.result, result) || other.result == result)&&(identical(other.humanSide, humanSide) || other.humanSide == humanSide)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.winnings, winnings) || other.winnings == winnings)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount)&&(identical(other.isCashOut, isCashOut) || other.isCashOut == isCashOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,humanSide,aiLevel,betAmount,winnings,playedAt,durationSeconds,moveCount,isCashOut);

@override
String toString() {
  return 'GameResultModel(result: $result, humanSide: $humanSide, aiLevel: $aiLevel, betAmount: $betAmount, winnings: $winnings, playedAt: $playedAt, durationSeconds: $durationSeconds, moveCount: $moveCount, isCashOut: $isCashOut)';
}


}

/// @nodoc
abstract mixin class $GameResultModelCopyWith<$Res>  {
  factory $GameResultModelCopyWith(GameResultModel value, $Res Function(GameResultModel) _then) = _$GameResultModelCopyWithImpl;
@useResult
$Res call({
 String result, String humanSide, double aiLevel, int betAmount, int winnings, String playedAt, int durationSeconds, int moveCount, bool isCashOut
});




}
/// @nodoc
class _$GameResultModelCopyWithImpl<$Res>
    implements $GameResultModelCopyWith<$Res> {
  _$GameResultModelCopyWithImpl(this._self, this._then);

  final GameResultModel _self;
  final $Res Function(GameResultModel) _then;

/// Create a copy of GameResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = null,Object? humanSide = null,Object? aiLevel = null,Object? betAmount = null,Object? winnings = null,Object? playedAt = null,Object? durationSeconds = null,Object? moveCount = null,Object? isCashOut = null,}) {
  return _then(_self.copyWith(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,humanSide: null == humanSide ? _self.humanSide : humanSide // ignore: cast_nullable_to_non_nullable
as String,aiLevel: null == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as double,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,winnings: null == winnings ? _self.winnings : winnings // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,isCashOut: null == isCashOut ? _self.isCashOut : isCashOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GameResultModel].
extension GameResultModelPatterns on GameResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameResultModel value)  $default,){
final _that = this;
switch (_that) {
case _GameResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _GameResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String result,  String humanSide,  double aiLevel,  int betAmount,  int winnings,  String playedAt,  int durationSeconds,  int moveCount,  bool isCashOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameResultModel() when $default != null:
return $default(_that.result,_that.humanSide,_that.aiLevel,_that.betAmount,_that.winnings,_that.playedAt,_that.durationSeconds,_that.moveCount,_that.isCashOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String result,  String humanSide,  double aiLevel,  int betAmount,  int winnings,  String playedAt,  int durationSeconds,  int moveCount,  bool isCashOut)  $default,) {final _that = this;
switch (_that) {
case _GameResultModel():
return $default(_that.result,_that.humanSide,_that.aiLevel,_that.betAmount,_that.winnings,_that.playedAt,_that.durationSeconds,_that.moveCount,_that.isCashOut);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String result,  String humanSide,  double aiLevel,  int betAmount,  int winnings,  String playedAt,  int durationSeconds,  int moveCount,  bool isCashOut)?  $default,) {final _that = this;
switch (_that) {
case _GameResultModel() when $default != null:
return $default(_that.result,_that.humanSide,_that.aiLevel,_that.betAmount,_that.winnings,_that.playedAt,_that.durationSeconds,_that.moveCount,_that.isCashOut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameResultModel implements GameResultModel {
  const _GameResultModel({required this.result, required this.humanSide, required this.aiLevel, required this.betAmount, required this.winnings, required this.playedAt, required this.durationSeconds, required this.moveCount, this.isCashOut = false});
  factory _GameResultModel.fromJson(Map<String, dynamic> json) => _$GameResultModelFromJson(json);

@override final  String result;
@override final  String humanSide;
@override final  double aiLevel;
@override final  int betAmount;
@override final  int winnings;
@override final  String playedAt;
@override final  int durationSeconds;
@override final  int moveCount;
@override@JsonKey() final  bool isCashOut;

/// Create a copy of GameResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameResultModelCopyWith<_GameResultModel> get copyWith => __$GameResultModelCopyWithImpl<_GameResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameResultModel&&(identical(other.result, result) || other.result == result)&&(identical(other.humanSide, humanSide) || other.humanSide == humanSide)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.winnings, winnings) || other.winnings == winnings)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount)&&(identical(other.isCashOut, isCashOut) || other.isCashOut == isCashOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,humanSide,aiLevel,betAmount,winnings,playedAt,durationSeconds,moveCount,isCashOut);

@override
String toString() {
  return 'GameResultModel(result: $result, humanSide: $humanSide, aiLevel: $aiLevel, betAmount: $betAmount, winnings: $winnings, playedAt: $playedAt, durationSeconds: $durationSeconds, moveCount: $moveCount, isCashOut: $isCashOut)';
}


}

/// @nodoc
abstract mixin class _$GameResultModelCopyWith<$Res> implements $GameResultModelCopyWith<$Res> {
  factory _$GameResultModelCopyWith(_GameResultModel value, $Res Function(_GameResultModel) _then) = __$GameResultModelCopyWithImpl;
@override @useResult
$Res call({
 String result, String humanSide, double aiLevel, int betAmount, int winnings, String playedAt, int durationSeconds, int moveCount, bool isCashOut
});




}
/// @nodoc
class __$GameResultModelCopyWithImpl<$Res>
    implements _$GameResultModelCopyWith<$Res> {
  __$GameResultModelCopyWithImpl(this._self, this._then);

  final _GameResultModel _self;
  final $Res Function(_GameResultModel) _then;

/// Create a copy of GameResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = null,Object? humanSide = null,Object? aiLevel = null,Object? betAmount = null,Object? winnings = null,Object? playedAt = null,Object? durationSeconds = null,Object? moveCount = null,Object? isCashOut = null,}) {
  return _then(_GameResultModel(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,humanSide: null == humanSide ? _self.humanSide : humanSide // ignore: cast_nullable_to_non_nullable
as String,aiLevel: null == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as double,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,winnings: null == winnings ? _self.winnings : winnings // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,isCashOut: null == isCashOut ? _self.isCashOut : isCashOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

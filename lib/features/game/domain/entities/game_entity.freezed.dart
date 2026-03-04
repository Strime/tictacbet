// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameEntity {

 BoardEntity get board; PlayerSide get humanSide; double get aiLevel; int get betAmount; DateTime get startedAt; DateTime? get endedAt; bool get isAllIn;
/// Create a copy of GameEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameEntityCopyWith<GameEntity> get copyWith => _$GameEntityCopyWithImpl<GameEntity>(this as GameEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameEntity&&(identical(other.board, board) || other.board == board)&&(identical(other.humanSide, humanSide) || other.humanSide == humanSide)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.isAllIn, isAllIn) || other.isAllIn == isAllIn));
}


@override
int get hashCode => Object.hash(runtimeType,board,humanSide,aiLevel,betAmount,startedAt,endedAt,isAllIn);

@override
String toString() {
  return 'GameEntity(board: $board, humanSide: $humanSide, aiLevel: $aiLevel, betAmount: $betAmount, startedAt: $startedAt, endedAt: $endedAt, isAllIn: $isAllIn)';
}


}

/// @nodoc
abstract mixin class $GameEntityCopyWith<$Res>  {
  factory $GameEntityCopyWith(GameEntity value, $Res Function(GameEntity) _then) = _$GameEntityCopyWithImpl;
@useResult
$Res call({
 BoardEntity board, PlayerSide humanSide, double aiLevel, int betAmount, DateTime startedAt, DateTime? endedAt, bool isAllIn
});


$BoardEntityCopyWith<$Res> get board;

}
/// @nodoc
class _$GameEntityCopyWithImpl<$Res>
    implements $GameEntityCopyWith<$Res> {
  _$GameEntityCopyWithImpl(this._self, this._then);

  final GameEntity _self;
  final $Res Function(GameEntity) _then;

/// Create a copy of GameEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? humanSide = null,Object? aiLevel = null,Object? betAmount = null,Object? startedAt = null,Object? endedAt = freezed,Object? isAllIn = null,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardEntity,humanSide: null == humanSide ? _self.humanSide : humanSide // ignore: cast_nullable_to_non_nullable
as PlayerSide,aiLevel: null == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as double,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAllIn: null == isAllIn ? _self.isAllIn : isAllIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of GameEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardEntityCopyWith<$Res> get board {
  
  return $BoardEntityCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameEntity].
extension GameEntityPatterns on GameEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameEntity value)  $default,){
final _that = this;
switch (_that) {
case _GameEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GameEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BoardEntity board,  PlayerSide humanSide,  double aiLevel,  int betAmount,  DateTime startedAt,  DateTime? endedAt,  bool isAllIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameEntity() when $default != null:
return $default(_that.board,_that.humanSide,_that.aiLevel,_that.betAmount,_that.startedAt,_that.endedAt,_that.isAllIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BoardEntity board,  PlayerSide humanSide,  double aiLevel,  int betAmount,  DateTime startedAt,  DateTime? endedAt,  bool isAllIn)  $default,) {final _that = this;
switch (_that) {
case _GameEntity():
return $default(_that.board,_that.humanSide,_that.aiLevel,_that.betAmount,_that.startedAt,_that.endedAt,_that.isAllIn);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BoardEntity board,  PlayerSide humanSide,  double aiLevel,  int betAmount,  DateTime startedAt,  DateTime? endedAt,  bool isAllIn)?  $default,) {final _that = this;
switch (_that) {
case _GameEntity() when $default != null:
return $default(_that.board,_that.humanSide,_that.aiLevel,_that.betAmount,_that.startedAt,_that.endedAt,_that.isAllIn);case _:
  return null;

}
}

}

/// @nodoc


class _GameEntity extends GameEntity {
  const _GameEntity({required this.board, required this.humanSide, required this.aiLevel, required this.betAmount, required this.startedAt, this.endedAt, this.isAllIn = false}): super._();
  

@override final  BoardEntity board;
@override final  PlayerSide humanSide;
@override final  double aiLevel;
@override final  int betAmount;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
@override@JsonKey() final  bool isAllIn;

/// Create a copy of GameEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameEntityCopyWith<_GameEntity> get copyWith => __$GameEntityCopyWithImpl<_GameEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameEntity&&(identical(other.board, board) || other.board == board)&&(identical(other.humanSide, humanSide) || other.humanSide == humanSide)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.isAllIn, isAllIn) || other.isAllIn == isAllIn));
}


@override
int get hashCode => Object.hash(runtimeType,board,humanSide,aiLevel,betAmount,startedAt,endedAt,isAllIn);

@override
String toString() {
  return 'GameEntity(board: $board, humanSide: $humanSide, aiLevel: $aiLevel, betAmount: $betAmount, startedAt: $startedAt, endedAt: $endedAt, isAllIn: $isAllIn)';
}


}

/// @nodoc
abstract mixin class _$GameEntityCopyWith<$Res> implements $GameEntityCopyWith<$Res> {
  factory _$GameEntityCopyWith(_GameEntity value, $Res Function(_GameEntity) _then) = __$GameEntityCopyWithImpl;
@override @useResult
$Res call({
 BoardEntity board, PlayerSide humanSide, double aiLevel, int betAmount, DateTime startedAt, DateTime? endedAt, bool isAllIn
});


@override $BoardEntityCopyWith<$Res> get board;

}
/// @nodoc
class __$GameEntityCopyWithImpl<$Res>
    implements _$GameEntityCopyWith<$Res> {
  __$GameEntityCopyWithImpl(this._self, this._then);

  final _GameEntity _self;
  final $Res Function(_GameEntity) _then;

/// Create a copy of GameEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? humanSide = null,Object? aiLevel = null,Object? betAmount = null,Object? startedAt = null,Object? endedAt = freezed,Object? isAllIn = null,}) {
  return _then(_GameEntity(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardEntity,humanSide: null == humanSide ? _self.humanSide : humanSide // ignore: cast_nullable_to_non_nullable
as PlayerSide,aiLevel: null == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as double,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAllIn: null == isAllIn ? _self.isAllIn : isAllIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GameEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardEntityCopyWith<$Res> get board {
  
  return $BoardEntityCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}

// dart format on

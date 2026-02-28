// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardEntity {

 List<CellEntity> get cells; PlayerSide get currentPlayer; int get moveCount;
/// Create a copy of BoardEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardEntityCopyWith<BoardEntity> get copyWith => _$BoardEntityCopyWithImpl<BoardEntity>(this as BoardEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardEntity&&const DeepCollectionEquality().equals(other.cells, cells)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cells),currentPlayer,moveCount);

@override
String toString() {
  return 'BoardEntity(cells: $cells, currentPlayer: $currentPlayer, moveCount: $moveCount)';
}


}

/// @nodoc
abstract mixin class $BoardEntityCopyWith<$Res>  {
  factory $BoardEntityCopyWith(BoardEntity value, $Res Function(BoardEntity) _then) = _$BoardEntityCopyWithImpl;
@useResult
$Res call({
 List<CellEntity> cells, PlayerSide currentPlayer, int moveCount
});




}
/// @nodoc
class _$BoardEntityCopyWithImpl<$Res>
    implements $BoardEntityCopyWith<$Res> {
  _$BoardEntityCopyWithImpl(this._self, this._then);

  final BoardEntity _self;
  final $Res Function(BoardEntity) _then;

/// Create a copy of BoardEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cells = null,Object? currentPlayer = null,Object? moveCount = null,}) {
  return _then(_self.copyWith(
cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<CellEntity>,currentPlayer: null == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerSide,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardEntity].
extension BoardEntityPatterns on BoardEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardEntity value)  $default,){
final _that = this;
switch (_that) {
case _BoardEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BoardEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CellEntity> cells,  PlayerSide currentPlayer,  int moveCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardEntity() when $default != null:
return $default(_that.cells,_that.currentPlayer,_that.moveCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CellEntity> cells,  PlayerSide currentPlayer,  int moveCount)  $default,) {final _that = this;
switch (_that) {
case _BoardEntity():
return $default(_that.cells,_that.currentPlayer,_that.moveCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CellEntity> cells,  PlayerSide currentPlayer,  int moveCount)?  $default,) {final _that = this;
switch (_that) {
case _BoardEntity() when $default != null:
return $default(_that.cells,_that.currentPlayer,_that.moveCount);case _:
  return null;

}
}

}

/// @nodoc


class _BoardEntity extends BoardEntity {
  const _BoardEntity({required final  List<CellEntity> cells, required this.currentPlayer, this.moveCount = 0}): _cells = cells,super._();
  

 final  List<CellEntity> _cells;
@override List<CellEntity> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

@override final  PlayerSide currentPlayer;
@override@JsonKey() final  int moveCount;

/// Create a copy of BoardEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardEntityCopyWith<_BoardEntity> get copyWith => __$BoardEntityCopyWithImpl<_BoardEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardEntity&&const DeepCollectionEquality().equals(other._cells, _cells)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.moveCount, moveCount) || other.moveCount == moveCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cells),currentPlayer,moveCount);

@override
String toString() {
  return 'BoardEntity(cells: $cells, currentPlayer: $currentPlayer, moveCount: $moveCount)';
}


}

/// @nodoc
abstract mixin class _$BoardEntityCopyWith<$Res> implements $BoardEntityCopyWith<$Res> {
  factory _$BoardEntityCopyWith(_BoardEntity value, $Res Function(_BoardEntity) _then) = __$BoardEntityCopyWithImpl;
@override @useResult
$Res call({
 List<CellEntity> cells, PlayerSide currentPlayer, int moveCount
});




}
/// @nodoc
class __$BoardEntityCopyWithImpl<$Res>
    implements _$BoardEntityCopyWith<$Res> {
  __$BoardEntityCopyWithImpl(this._self, this._then);

  final _BoardEntity _self;
  final $Res Function(_BoardEntity) _then;

/// Create a copy of BoardEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cells = null,Object? currentPlayer = null,Object? moveCount = null,}) {
  return _then(_BoardEntity(
cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<CellEntity>,currentPlayer: null == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerSide,moveCount: null == moveCount ? _self.moveCount : moveCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cell_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CellEntity {

 int get row; int get col; CellBonus? get bonus; CardEntity? get card; bool get revealed;
/// Create a copy of CellEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellEntityCopyWith<CellEntity> get copyWith => _$CellEntityCopyWithImpl<CellEntity>(this as CellEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CellEntity&&(identical(other.row, row) || other.row == row)&&(identical(other.col, col) || other.col == col)&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.card, card) || other.card == card)&&(identical(other.revealed, revealed) || other.revealed == revealed));
}


@override
int get hashCode => Object.hash(runtimeType,row,col,bonus,card,revealed);

@override
String toString() {
  return 'CellEntity(row: $row, col: $col, bonus: $bonus, card: $card, revealed: $revealed)';
}


}

/// @nodoc
abstract mixin class $CellEntityCopyWith<$Res>  {
  factory $CellEntityCopyWith(CellEntity value, $Res Function(CellEntity) _then) = _$CellEntityCopyWithImpl;
@useResult
$Res call({
 int row, int col, CellBonus? bonus, CardEntity? card, bool revealed
});


$CardEntityCopyWith<$Res>? get card;

}
/// @nodoc
class _$CellEntityCopyWithImpl<$Res>
    implements $CellEntityCopyWith<$Res> {
  _$CellEntityCopyWithImpl(this._self, this._then);

  final CellEntity _self;
  final $Res Function(CellEntity) _then;

/// Create a copy of CellEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? row = null,Object? col = null,Object? bonus = freezed,Object? card = freezed,Object? revealed = null,}) {
  return _then(_self.copyWith(
row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,col: null == col ? _self.col : col // ignore: cast_nullable_to_non_nullable
as int,bonus: freezed == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as CellBonus?,card: freezed == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as CardEntity?,revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CellEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardEntityCopyWith<$Res>? get card {
    if (_self.card == null) {
    return null;
  }

  return $CardEntityCopyWith<$Res>(_self.card!, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// Adds pattern-matching-related methods to [CellEntity].
extension CellEntityPatterns on CellEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CellEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CellEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CellEntity value)  $default,){
final _that = this;
switch (_that) {
case _CellEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CellEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CellEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int row,  int col,  CellBonus? bonus,  CardEntity? card,  bool revealed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CellEntity() when $default != null:
return $default(_that.row,_that.col,_that.bonus,_that.card,_that.revealed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int row,  int col,  CellBonus? bonus,  CardEntity? card,  bool revealed)  $default,) {final _that = this;
switch (_that) {
case _CellEntity():
return $default(_that.row,_that.col,_that.bonus,_that.card,_that.revealed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int row,  int col,  CellBonus? bonus,  CardEntity? card,  bool revealed)?  $default,) {final _that = this;
switch (_that) {
case _CellEntity() when $default != null:
return $default(_that.row,_that.col,_that.bonus,_that.card,_that.revealed);case _:
  return null;

}
}

}

/// @nodoc


class _CellEntity implements CellEntity {
  const _CellEntity({required this.row, required this.col, this.bonus, this.card, this.revealed = false});
  

@override final  int row;
@override final  int col;
@override final  CellBonus? bonus;
@override final  CardEntity? card;
@override@JsonKey() final  bool revealed;

/// Create a copy of CellEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CellEntityCopyWith<_CellEntity> get copyWith => __$CellEntityCopyWithImpl<_CellEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CellEntity&&(identical(other.row, row) || other.row == row)&&(identical(other.col, col) || other.col == col)&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.card, card) || other.card == card)&&(identical(other.revealed, revealed) || other.revealed == revealed));
}


@override
int get hashCode => Object.hash(runtimeType,row,col,bonus,card,revealed);

@override
String toString() {
  return 'CellEntity(row: $row, col: $col, bonus: $bonus, card: $card, revealed: $revealed)';
}


}

/// @nodoc
abstract mixin class _$CellEntityCopyWith<$Res> implements $CellEntityCopyWith<$Res> {
  factory _$CellEntityCopyWith(_CellEntity value, $Res Function(_CellEntity) _then) = __$CellEntityCopyWithImpl;
@override @useResult
$Res call({
 int row, int col, CellBonus? bonus, CardEntity? card, bool revealed
});


@override $CardEntityCopyWith<$Res>? get card;

}
/// @nodoc
class __$CellEntityCopyWithImpl<$Res>
    implements _$CellEntityCopyWith<$Res> {
  __$CellEntityCopyWithImpl(this._self, this._then);

  final _CellEntity _self;
  final $Res Function(_CellEntity) _then;

/// Create a copy of CellEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? row = null,Object? col = null,Object? bonus = freezed,Object? card = freezed,Object? revealed = null,}) {
  return _then(_CellEntity(
row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,col: null == col ? _self.col : col // ignore: cast_nullable_to_non_nullable
as int,bonus: freezed == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as CellBonus?,card: freezed == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as CardEntity?,revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CellEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardEntityCopyWith<$Res>? get card {
    if (_self.card == null) {
    return null;
  }

  return $CardEntityCopyWith<$Res>(_self.card!, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}

// dart format on

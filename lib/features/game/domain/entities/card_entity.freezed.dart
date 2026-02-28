// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CardEntity {

 CardSuit get suit; CardRank get rank;
/// Create a copy of CardEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardEntityCopyWith<CardEntity> get copyWith => _$CardEntityCopyWithImpl<CardEntity>(this as CardEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardEntity&&(identical(other.suit, suit) || other.suit == suit)&&(identical(other.rank, rank) || other.rank == rank));
}


@override
int get hashCode => Object.hash(runtimeType,suit,rank);

@override
String toString() {
  return 'CardEntity(suit: $suit, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $CardEntityCopyWith<$Res>  {
  factory $CardEntityCopyWith(CardEntity value, $Res Function(CardEntity) _then) = _$CardEntityCopyWithImpl;
@useResult
$Res call({
 CardSuit suit, CardRank rank
});




}
/// @nodoc
class _$CardEntityCopyWithImpl<$Res>
    implements $CardEntityCopyWith<$Res> {
  _$CardEntityCopyWithImpl(this._self, this._then);

  final CardEntity _self;
  final $Res Function(CardEntity) _then;

/// Create a copy of CardEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suit = null,Object? rank = null,}) {
  return _then(_self.copyWith(
suit: null == suit ? _self.suit : suit // ignore: cast_nullable_to_non_nullable
as CardSuit,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as CardRank,
  ));
}

}


/// Adds pattern-matching-related methods to [CardEntity].
extension CardEntityPatterns on CardEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardEntity value)  $default,){
final _that = this;
switch (_that) {
case _CardEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CardEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CardSuit suit,  CardRank rank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardEntity() when $default != null:
return $default(_that.suit,_that.rank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CardSuit suit,  CardRank rank)  $default,) {final _that = this;
switch (_that) {
case _CardEntity():
return $default(_that.suit,_that.rank);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CardSuit suit,  CardRank rank)?  $default,) {final _that = this;
switch (_that) {
case _CardEntity() when $default != null:
return $default(_that.suit,_that.rank);case _:
  return null;

}
}

}

/// @nodoc


class _CardEntity implements CardEntity {
  const _CardEntity({required this.suit, required this.rank});
  

@override final  CardSuit suit;
@override final  CardRank rank;

/// Create a copy of CardEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardEntityCopyWith<_CardEntity> get copyWith => __$CardEntityCopyWithImpl<_CardEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardEntity&&(identical(other.suit, suit) || other.suit == suit)&&(identical(other.rank, rank) || other.rank == rank));
}


@override
int get hashCode => Object.hash(runtimeType,suit,rank);

@override
String toString() {
  return 'CardEntity(suit: $suit, rank: $rank)';
}


}

/// @nodoc
abstract mixin class _$CardEntityCopyWith<$Res> implements $CardEntityCopyWith<$Res> {
  factory _$CardEntityCopyWith(_CardEntity value, $Res Function(_CardEntity) _then) = __$CardEntityCopyWithImpl;
@override @useResult
$Res call({
 CardSuit suit, CardRank rank
});




}
/// @nodoc
class __$CardEntityCopyWithImpl<$Res>
    implements _$CardEntityCopyWith<$Res> {
  __$CardEntityCopyWithImpl(this._self, this._then);

  final _CardEntity _self;
  final $Res Function(_CardEntity) _then;

/// Create a copy of CardEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suit = null,Object? rank = null,}) {
  return _then(_CardEntity(
suit: null == suit ? _self.suit : suit // ignore: cast_nullable_to_non_nullable
as CardSuit,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as CardRank,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameResultModel _$GameResultModelFromJson(Map<String, dynamic> json) =>
    _GameResultModel(
      result: json['result'] as String,
      humanSide: json['humanSide'] as String,
      aiLevel: (json['aiLevel'] as num).toDouble(),
      betAmount: (json['betAmount'] as num).toInt(),
      winnings: (json['winnings'] as num).toInt(),
      playedAt: json['playedAt'] as String,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      moveCount: (json['moveCount'] as num).toInt(),
    );

Map<String, dynamic> _$GameResultModelToJson(_GameResultModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'humanSide': instance.humanSide,
      'aiLevel': instance.aiLevel,
      'betAmount': instance.betAmount,
      'winnings': instance.winnings,
      'playedAt': instance.playedAt,
      'durationSeconds': instance.durationSeconds,
      'moveCount': instance.moveCount,
    };

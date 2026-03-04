import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_result_model.freezed.dart';
part 'game_result_model.g.dart';

@freezed
sealed class GameResultModel with _$GameResultModel {
  const factory GameResultModel({
    required String result,
    required String humanSide,
    required double aiLevel,
    required int betAmount,
    required int winnings,
    required String playedAt,
    required int durationSeconds,
    required int moveCount,
    @Default(false) bool isCashOut,
    @Default(false) bool isAllIn,
  }) = _GameResultModel;

  factory GameResultModel.fromJson(Map<String, dynamic> json) =>
      _$GameResultModelFromJson(json);
}

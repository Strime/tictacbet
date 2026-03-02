import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/history/data/mappers/game_result_mapper.dart';
import 'package:tictacbet/features/history/data/models/game_result_model.dart';
import 'package:tictacbet/features/history/domain/entities/game_result_entity.dart';

void main() {
  group('GameResultMapper', () {
    final entity = GameResultEntity(
      result: GameStatus.redWins,
      humanSide: PlayerSide.red,
      aiLevel: 0.7,
      betAmount: 20,
      winnings: 45,
      playedAt: DateTime(2026, 3, 1, 14, 30),
      duration: const Duration(minutes: 2, seconds: 15),
      moveCount: 7,
    );

    const model = GameResultModel(
      result: 'redWins',
      humanSide: 'red',
      aiLevel: 0.7,
      betAmount: 20,
      winnings: 45,
      playedAt: '2026-03-01T14:30:00.000',
      durationSeconds: 135,
      moveCount: 7,
    );

    group('toModel', () {
      test('converts entity to model with serialized values', () {
        final result = GameResultMapper.toModel(entity);

        expect(result.result, equals('redWins'));
        expect(result.humanSide, equals('red'));
        expect(result.aiLevel, equals(0.7));
        expect(result.betAmount, equals(20));
        expect(result.winnings, equals(45));
        expect(result.playedAt, equals('2026-03-01T14:30:00.000'));
        expect(result.durationSeconds, equals(135));
        expect(result.moveCount, equals(7));
      });
    });

    group('toEntity', () {
      test('converts model to entity with proper types', () {
        final result = GameResultMapper.toEntity(model);

        expect(result.result, equals(GameStatus.redWins));
        expect(result.humanSide, equals(PlayerSide.red));
        expect(result.aiLevel, equals(0.7));
        expect(result.betAmount, equals(20));
        expect(result.winnings, equals(45));
        expect(result.playedAt, equals(DateTime(2026, 3, 1, 14, 30)));
        expect(result.duration, equals(const Duration(minutes: 2, seconds: 15)));
        expect(result.moveCount, equals(7));
      });

      test('falls back to draw for unknown game status', () {
        const invalidModel = GameResultModel(
          result: 'unknown',
          humanSide: 'red',
          aiLevel: 0.5,
          betAmount: 10,
          winnings: 0,
          playedAt: '2026-03-01T10:00:00.000',
          durationSeconds: 60,
          moveCount: 5,
        );

        final result = GameResultMapper.toEntity(invalidModel);

        expect(result.result, equals(GameStatus.draw));
      });

      test('falls back to red for unknown player side', () {
        const invalidModel = GameResultModel(
          result: 'draw',
          humanSide: 'unknown',
          aiLevel: 0.5,
          betAmount: 10,
          winnings: 0,
          playedAt: '2026-03-01T10:00:00.000',
          durationSeconds: 60,
          moveCount: 5,
        );

        final result = GameResultMapper.toEntity(invalidModel);

        expect(result.humanSide, equals(PlayerSide.red));
      });
    });

    group('round-trip', () {
      test('toEntity(toModel(entity)) preserves all values', () {
        final roundTripped = GameResultMapper.toEntity(
          GameResultMapper.toModel(entity),
        );

        expect(roundTripped, equals(entity));
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/ai/domain/services/minimax_service.dart';
import 'package:tictacbet/features/game/domain/entities/board_entity.dart';
import 'package:tictacbet/features/game/domain/usecases/compute_cash_out_use_case.dart';

class MockMinimaxService extends Mock implements MinimaxService {}

void main() {
  late MockMinimaxService mockMinimax;
  late ComputeCashOutUseCase useCase;
  late BoardEntity board;

  setUp(() {
    mockMinimax = MockMinimaxService();
    useCase = ComputeCashOutUseCase(mockMinimax);
    board = BoardEntity.generate();
  });

  group('ComputeCashOutUseCase', () {
    test('returns betAmount when no moves available', () {
      when(() => mockMinimax.getMovesWithScores(board)).thenReturn([]);

      expect(useCase(board, 20), equals(20));
    });

    test('returns max multiplier (1.8x) for best score +10', () {
      when(() => mockMinimax.getMovesWithScores(board))
          .thenReturn([(move: 0, score: 10)]);

      // betAmount * 1.8 = 20 * 1.8 = 36
      expect(useCase(board, 20), equals(36));
    });

    test('returns min multiplier (0.1x) for best score -10', () {
      when(() => mockMinimax.getMovesWithScores(board))
          .thenReturn([(move: 0, score: -10)]);

      // betAmount * 0.1 = 20 * 0.1 = 2
      expect(useCase(board, 20), equals(2));
    });

    test('returns mid multiplier (0.95x) for best score 0', () {
      when(() => mockMinimax.getMovesWithScores(board))
          .thenReturn([(move: 0, score: 0)]);

      // normalizedScore = (0+10)/20 = 0.5
      // multiplier = 0.1 + 0.5 * (1.8 - 0.1) = 0.95
      // betAmount * 0.95 = 20 * 0.95 = 19
      expect(useCase(board, 20), equals(19));
    });

    test('picks the best score among multiple moves', () {
      when(() => mockMinimax.getMovesWithScores(board)).thenReturn([
        (move: 0, score: -5),
        (move: 1, score: 3),
        (move: 2, score: -2),
      ]);

      // bestScore = 3
      // normalizedScore = (3+10)/20 = 0.65
      // multiplier = 0.1 + 0.65 * 1.7 = 1.205
      // betAmount * 1.205 = 20 * 1.205 = 24.1 -> 24
      expect(useCase(board, 20), equals(24));
    });

    test('enforces floor of 1 for very small results', () {
      when(() => mockMinimax.getMovesWithScores(board))
          .thenReturn([(move: 0, score: -10)]);

      // betAmount * 0.1 = 1 * 0.1 = 0.1 -> rounds to 0, floor of 1 applies
      expect(useCase(board, 1), equals(1));
    });
  });
}

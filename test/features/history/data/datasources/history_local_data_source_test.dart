import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/history/data/datasources/history_local_data_source.dart';
import 'package:tictacbet/features/history/data/models/game_result_model.dart';

class MockBox extends Mock implements Box<Map> {}

void main() {
  late MockBox mockBox;
  late HistoryLocalDataSource dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = HistoryLocalDataSource(mockBox);
  });

  final sampleJson = const GameResultModel(
    result: 'redWins',
    humanSide: 'red',
    aiLevel: 0.5,
    betAmount: 10,
    winnings: 25,
    playedAt: '2026-03-01T10:00:00.000',
    durationSeconds: 120,
    moveCount: 7,
  ).toJson();

  group('HistoryLocalDataSource', () {
    group('getHistory', () {
      test('returns models from box values in reverse order', () {
        final json1 = {
          ...sampleJson,
          'playedAt': '2026-03-01T10:00:00.000',
        };
        final json2 = {
          ...sampleJson,
          'playedAt': '2026-03-02T10:00:00.000',
        };
        when(() => mockBox.values).thenReturn([json1, json2]);

        final results = dataSource.getHistory();

        expect(results.length, equals(2));
        expect(results.first.playedAt, equals('2026-03-02T10:00:00.000'));
        expect(results.last.playedAt, equals('2026-03-01T10:00:00.000'));
      });

      test('returns empty list when box is empty', () {
        when(() => mockBox.values).thenReturn([]);

        final results = dataSource.getHistory();

        expect(results, isEmpty);
      });
    });

    group('saveResult', () {
      test('adds JSON map to box', () async {
        final model = GameResultModel.fromJson(
          Map<String, dynamic>.from(sampleJson),
        );
        when(() => mockBox.add(any())).thenAnswer((_) async => 0);
        when(() => mockBox.length).thenReturn(1);

        await dataSource.saveResult(model);

        verify(() => mockBox.add(any())).called(1);
      });

      test('trims oldest entries when exceeding max', () async {
        final model = GameResultModel.fromJson(
          Map<String, dynamic>.from(sampleJson),
        );
        when(() => mockBox.add(any())).thenAnswer((_) async => 0);
        when(() => mockBox.length).thenReturn(52);
        when(() => mockBox.keys).thenReturn(List.generate(52, (i) => i));
        when(() => mockBox.deleteAll(any())).thenAnswer((_) async {});

        await dataSource.saveResult(model);

        verify(() => mockBox.deleteAll([0, 1])).called(1);
      });

      test('does not trim when at max entries', () async {
        final model = GameResultModel.fromJson(
          Map<String, dynamic>.from(sampleJson),
        );
        when(() => mockBox.add(any())).thenAnswer((_) async => 0);
        when(() => mockBox.length).thenReturn(50);

        await dataSource.saveResult(model);

        verifyNever(() => mockBox.deleteAll(any()));
      });
    });
  });
}

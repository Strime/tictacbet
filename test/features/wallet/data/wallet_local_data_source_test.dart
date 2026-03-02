import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictacbet/core/config/game_constants.dart';
import 'package:tictacbet/features/wallet/data/datasources/wallet_local_data_source.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late WalletLocalDataSource dataSource;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = WalletLocalDataSource(mockPrefs);
  });

  group('WalletLocalDataSource', () {
    group('getBalance', () {
      test('returns stored balance', () {
        when(() => mockPrefs.getInt('wallet_balance')).thenReturn(42);

        expect(dataSource.getBalance(), equals(42));
      });

      test('returns initialBalance when no stored value', () {
        when(() => mockPrefs.getInt('wallet_balance')).thenReturn(null);

        expect(dataSource.getBalance(), equals(GameConstants.initialBalance));
      });
    });

    group('setBalance', () {
      test('stores balance in SharedPreferences', () async {
        when(() => mockPrefs.setInt('wallet_balance', 25))
            .thenAnswer((_) async => true);

        await dataSource.setBalance(25);

        verify(() => mockPrefs.setInt('wallet_balance', 25)).called(1);
      });
    });

    group('getLastBonusDate', () {
      test('returns null when no stored value', () {
        when(() => mockPrefs.getString('wallet_last_bonus_date'))
            .thenReturn(null);

        expect(dataSource.getLastBonusDate(), isNull);
      });

      test('parses stored ISO8601 date', () {
        when(() => mockPrefs.getString('wallet_last_bonus_date'))
            .thenReturn('2026-03-01T10:30:00.000');

        final result = dataSource.getLastBonusDate();

        expect(result, equals(DateTime(2026, 3, 1, 10, 30)));
      });

      test('returns null for invalid date string', () {
        when(() => mockPrefs.getString('wallet_last_bonus_date'))
            .thenReturn('not-a-date');

        expect(dataSource.getLastBonusDate(), isNull);
      });
    });

    group('setLastBonusDate', () {
      test('stores date as ISO8601 string', () async {
        final date = DateTime(2026, 3, 1, 10, 30);
        when(() => mockPrefs.setString(
              'wallet_last_bonus_date',
              any(that: contains('2026-03-01')),
            )).thenAnswer((_) async => true);

        await dataSource.setLastBonusDate(date);

        verify(() => mockPrefs.setString(
              'wallet_last_bonus_date',
              date.toIso8601String(),
            )).called(1);
      });
    });
  });
}

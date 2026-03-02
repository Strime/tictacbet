import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/wallet/data/datasources/wallet_local_data_source.dart';
import 'package:tictacbet/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:tictacbet/features/wallet/domain/entities/wallet_entity.dart';

class MockWalletLocalDataSource extends Mock implements WalletLocalDataSource {}

void main() {
  late MockWalletLocalDataSource mockDataSource;
  late WalletRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockWalletLocalDataSource();
    repository = WalletRepositoryImpl(mockDataSource);
  });

  group('WalletRepositoryImpl', () {
    group('loadWallet', () {
      test('returns WalletEntity from data source values', () async {
        final date = DateTime(2026, 3, 1);
        when(() => mockDataSource.getBalance()).thenReturn(42);
        when(() => mockDataSource.getLastBonusDate()).thenReturn(date);

        final result = await repository.loadWallet();

        expect(result, equals(WalletEntity(balance: 42, lastBonusDate: date)));
      });

      test('returns WalletEntity with null lastBonusDate', () async {
        when(() => mockDataSource.getBalance()).thenReturn(10);
        when(() => mockDataSource.getLastBonusDate()).thenReturn(null);

        final result = await repository.loadWallet();

        expect(result, equals(const WalletEntity(balance: 10)));
      });
    });

    group('saveWallet', () {
      test('saves balance and lastBonusDate when present', () async {
        final date = DateTime(2026, 3, 1);
        final wallet = WalletEntity(balance: 30, lastBonusDate: date);

        when(() => mockDataSource.setBalance(30))
            .thenAnswer((_) async {});
        when(() => mockDataSource.setLastBonusDate(date))
            .thenAnswer((_) async {});

        await repository.saveWallet(wallet);

        verify(() => mockDataSource.setBalance(30)).called(1);
        verify(() => mockDataSource.setLastBonusDate(date)).called(1);
      });

      test('saves only balance when lastBonusDate is null', () async {
        const wallet = WalletEntity(balance: 15);

        when(() => mockDataSource.setBalance(15))
            .thenAnswer((_) async {});

        await repository.saveWallet(wallet);

        verify(() => mockDataSource.setBalance(15)).called(1);
        verifyNever(() => mockDataSource.setLastBonusDate(any()));
      });
    });
  });
}

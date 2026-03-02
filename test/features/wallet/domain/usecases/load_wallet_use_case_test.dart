import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:tictacbet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:tictacbet/features/wallet/domain/usecases/load_wallet_use_case.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  late MockWalletRepository mockRepository;
  late LoadWalletUseCase useCase;

  setUp(() {
    mockRepository = MockWalletRepository();
    useCase = LoadWalletUseCase(mockRepository);
  });

  group('LoadWalletUseCase', () {
    test('delegates to repository.loadWallet()', () async {
      final wallet = WalletEntity(
        balance: 42,
        lastBonusDate: DateTime(2026, 3, 1),
      );
      when(() => mockRepository.loadWallet()).thenAnswer((_) async => wallet);

      final result = await useCase();

      expect(result, equals(wallet));
      verify(() => mockRepository.loadWallet()).called(1);
    });
  });
}

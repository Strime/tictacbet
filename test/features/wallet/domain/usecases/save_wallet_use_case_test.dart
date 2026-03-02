import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:tictacbet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:tictacbet/features/wallet/domain/usecases/save_wallet_use_case.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  late MockWalletRepository mockRepository;
  late SaveWalletUseCase useCase;

  setUp(() {
    mockRepository = MockWalletRepository();
    useCase = SaveWalletUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const WalletEntity(balance: 0));
  });

  group('SaveWalletUseCase', () {
    test('delegates to repository.saveWallet()', () async {
      final wallet = WalletEntity(
        balance: 30,
        lastBonusDate: DateTime(2026, 3, 1),
      );
      when(() => mockRepository.saveWallet(any())).thenAnswer((_) async {});

      await useCase(wallet);

      verify(() => mockRepository.saveWallet(wallet)).called(1);
    });
  });
}

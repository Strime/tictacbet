import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/core/config/game_constants.dart';
import 'package:tictacbet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:tictacbet/features/wallet/domain/usecases/load_wallet_use_case.dart';
import 'package:tictacbet/features/wallet/domain/usecases/save_wallet_use_case.dart';
import 'package:tictacbet/features/wallet/presentation/bloc/wallet_bloc.dart';

class MockLoadWalletUseCase extends Mock implements LoadWalletUseCase {}

class MockSaveWalletUseCase extends Mock implements SaveWalletUseCase {}

void main() {
  late MockLoadWalletUseCase mockLoadWallet;
  late MockSaveWalletUseCase mockSaveWallet;

  setUp(() {
    mockLoadWallet = MockLoadWalletUseCase();
    mockSaveWallet = MockSaveWalletUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const WalletEntity(balance: 0));
  });

  WalletBloc buildBloc() => WalletBloc(mockLoadWallet, mockSaveWallet);

  group('WalletBloc', () {
    test('initial state is WalletInitial', () {
      expect(buildBloc().state, equals(const WalletInitial()));
    });

    group('WalletStarted', () {
      final today = DateTime.now();
      final walletClaimedToday = WalletEntity(
        balance: 20,
        lastBonusDate: today,
      );
      final walletClaimedYesterday = WalletEntity(
        balance: 10,
        lastBonusDate: today.subtract(const Duration(days: 1)),
      );
      const walletNeverClaimed = WalletEntity(balance: 10);

      blocTest<WalletBloc, WalletState>(
        'emits WalletLoaded when bonus already claimed today',
        build: () {
          when(() => mockLoadWallet()).thenAnswer(
            (_) async => walletClaimedToday,
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const WalletStarted()),
        expect: () => [
          WalletLoaded(wallet: walletClaimedToday),
        ],
        verify: (_) {
          verify(() => mockLoadWallet()).called(1);
          verifyNever(() => mockSaveWallet(any()));
        },
      );

      blocTest<WalletBloc, WalletState>(
        'claims daily bonus when lastBonusDate is yesterday',
        build: () {
          when(() => mockLoadWallet()).thenAnswer(
            (_) async => walletClaimedYesterday,
          );
          when(() => mockSaveWallet(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        act: (bloc) => bloc.add(const WalletStarted()),
        expect: () => [
          isA<WalletLoaded>()
              .having(
                (s) => s.balance,
                'balance',
                10 + GameConstants.dailyBonusAmount,
              )
              .having(
                (s) => s.dailyBonusJustClaimed,
                'dailyBonusJustClaimed',
                isTrue,
              ),
        ],
        verify: (_) {
          verify(() => mockSaveWallet(any())).called(1);
        },
      );

      blocTest<WalletBloc, WalletState>(
        'claims daily bonus when lastBonusDate is null (first launch)',
        build: () {
          when(() => mockLoadWallet()).thenAnswer(
            (_) async => walletNeverClaimed,
          );
          when(() => mockSaveWallet(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        act: (bloc) => bloc.add(const WalletStarted()),
        expect: () => [
          isA<WalletLoaded>()
              .having(
                (s) => s.balance,
                'balance',
                10 + GameConstants.dailyBonusAmount,
              )
              .having(
                (s) => s.dailyBonusJustClaimed,
                'dailyBonusJustClaimed',
                isTrue,
              ),
        ],
      );
    });

    group('WalletBetPlaced', () {
      final today = DateTime.now();
      final loadedWallet = WalletEntity(
        balance: 20,
        lastBonusDate: today,
      );

      blocTest<WalletBloc, WalletState>(
        'deducts bet amount from balance',
        build: () {
          when(() => mockLoadWallet()).thenAnswer(
            (_) async => loadedWallet,
          );
          when(() => mockSaveWallet(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => WalletLoaded(wallet: loadedWallet),
        act: (bloc) => bloc.add(const WalletBetPlaced(5)),
        expect: () => [
          isA<WalletLoaded>().having(
            (s) => s.balance,
            'balance',
            15,
          ),
        ],
        verify: (_) {
          verify(() => mockSaveWallet(any())).called(1);
        },
      );

      blocTest<WalletBloc, WalletState>(
        'does nothing when balance is insufficient',
        build: () => buildBloc(),
        seed: () => WalletLoaded(wallet: loadedWallet),
        act: (bloc) => bloc.add(const WalletBetPlaced(25)),
        expect: () => [],
      );

      blocTest<WalletBloc, WalletState>(
        'does nothing when state is not WalletLoaded',
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const WalletBetPlaced(5)),
        expect: () => [],
      );

      blocTest<WalletBloc, WalletState>(
        'deducts full balance when bet equals balance',
        build: () {
          when(() => mockSaveWallet(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => WalletLoaded(wallet: loadedWallet),
        act: (bloc) => bloc.add(const WalletBetPlaced(20)),
        expect: () => [
          isA<WalletLoaded>().having(
            (s) => s.balance,
            'balance',
            0,
          ),
        ],
        verify: (_) {
          verify(() => mockSaveWallet(any())).called(1);
        },
      );
    });

    group('WalletGameSettled', () {
      final today = DateTime.now();
      final loadedWallet = WalletEntity(
        balance: 15,
        lastBonusDate: today,
      );

      blocTest<WalletBloc, WalletState>(
        'adds winnings to balance on win',
        build: () {
          when(() => mockSaveWallet(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => WalletLoaded(wallet: loadedWallet),
        act: (bloc) => bloc.add(const WalletGameSettled(25)),
        expect: () => [
          isA<WalletLoaded>().having(
            (s) => s.balance,
            'balance',
            40,
          ),
        ],
        verify: (_) {
          verify(() => mockSaveWallet(any())).called(1);
        },
      );

      blocTest<WalletBloc, WalletState>(
        'refunds bet on draw',
        build: () {
          when(() => mockSaveWallet(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => WalletLoaded(wallet: loadedWallet),
        act: (bloc) => bloc.add(const WalletGameSettled(10)),
        expect: () => [
          isA<WalletLoaded>().having(
            (s) => s.balance,
            'balance',
            25,
          ),
        ],
      );

      blocTest<WalletBloc, WalletState>(
        'emits no new state on loss (winnings = 0, balance unchanged)',
        build: () {
          when(() => mockSaveWallet(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => WalletLoaded(wallet: loadedWallet),
        act: (bloc) => bloc.add(const WalletGameSettled(0)),
        expect: () => [],
        verify: (_) {
          verify(() => mockSaveWallet(any())).called(1);
        },
      );

      blocTest<WalletBloc, WalletState>(
        'does nothing when state is not WalletLoaded',
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const WalletGameSettled(10)),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockSaveWallet(any()));
        },
      );
    });
  });
}

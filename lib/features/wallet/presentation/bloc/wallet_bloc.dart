import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/game_constants.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/usecases/load_wallet_use_case.dart';
import '../../domain/usecases/save_wallet_use_case.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

@lazySingleton
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final LoadWalletUseCase _loadWallet;
  final SaveWalletUseCase _saveWallet;

  WalletBloc(this._loadWallet, this._saveWallet)
      : super(const WalletInitial()) {
    on<WalletStarted>(_onStarted);
    on<WalletBetPlaced>(_onBetPlaced);
    on<WalletGameSettled>(_onGameSettled);
  }

  Future<void> _onStarted(
    WalletStarted event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final wallet = await _loadWallet();

      if (wallet.canClaimDailyBonus) {
        final updated = wallet.copyWith(
          balance: wallet.balance + GameConstants.dailyBonusAmount,
          lastBonusDate: DateTime.now(),
        );
        emit(WalletLoaded(wallet: updated, dailyBonusJustClaimed: true));
        await _saveWallet(updated);
      } else {
        emit(WalletLoaded(wallet: wallet));
      }
    } catch (_) {
      emit(const WalletLoaded(
        wallet: WalletEntity(balance: GameConstants.initialBalance),
      ));
    }
  }

  Future<void> _onBetPlaced(
    WalletBetPlaced event,
    Emitter<WalletState> emit,
  ) async {
    final currentState = state;
    if (currentState is! WalletLoaded) return;

    final wallet = currentState.wallet;
    if (!wallet.canPlaceBet(event.amount)) return;

    final updated = wallet.copyWith(
      balance: wallet.balance - event.amount,
    );
    emit(WalletLoaded(wallet: updated));
    try {
      await _saveWallet(updated);
    } catch (_) {}
  }

  Future<void> _onGameSettled(
    WalletGameSettled event,
    Emitter<WalletState> emit,
  ) async {
    final currentState = state;
    if (currentState is! WalletLoaded) return;

    final wallet = currentState.wallet;
    final updated = wallet.copyWith(
      balance: wallet.balance + event.winnings,
    );
    emit(WalletLoaded(wallet: updated));
    try {
      await _saveWallet(updated);
    } catch (_) {}
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/game_constants.dart';
import '../../../game/domain/entities/player_side.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

@injectable
class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc() : super(const LobbyInitial()) {
    on<LobbyInitialized>(_onInitialized);
    on<LobbySideChanged>(_onSideChanged);
    on<LobbyBetChanged>(_onBetChanged);
    on<LobbyBetAdded>(_onBetAdded);
    on<LobbyBetReset>(_onBetReset);
    on<LobbyBetMaxed>(_onBetMaxed);
  }

  void _onInitialized(LobbyInitialized event, Emitter<LobbyState> emit) {
    final currentState = state;
    final balance = event.playerBalance;

    final selectedSide = currentState is LobbyReady
        ? currentState.selectedSide
        : PlayerSide.red;
    final previousBet = currentState is LobbyReady
        ? currentState.betAmount
        : 1;

    emit(LobbyReady(
      selectedSide: selectedSide,
      betAmount: balance > 0 ? previousBet.clamp(1, balance) : 0,
      maxBet: balance,
    ));
  }

  void _onSideChanged(LobbySideChanged event, Emitter<LobbyState> emit) {
    final currentState = state;
    if (currentState is LobbyReady) {
      emit(LobbyReady(
        selectedSide: event.side,
        betAmount: currentState.betAmount,
        maxBet: currentState.maxBet,
      ));
    }
  }

  void _onBetChanged(LobbyBetChanged event, Emitter<LobbyState> emit) {
    final currentState = state;
    if (currentState is LobbyReady) {
      emit(LobbyReady(
        selectedSide: currentState.selectedSide,
        betAmount: event.amount.clamp(1, currentState.maxBet),
        maxBet: currentState.maxBet,
      ));
    }
  }

  void _onBetAdded(LobbyBetAdded event, Emitter<LobbyState> emit) {
    final currentState = state;
    if (currentState is LobbyReady) {
      emit(LobbyReady(
        selectedSide: currentState.selectedSide,
        betAmount: (currentState.betAmount + event.chipAmount)
            .clamp(1, currentState.maxBet),
        maxBet: currentState.maxBet,
      ));
    }
  }

  void _onBetReset(LobbyBetReset event, Emitter<LobbyState> emit) {
    final currentState = state;
    if (currentState is LobbyReady) {
      emit(LobbyReady(
        selectedSide: currentState.selectedSide,
        betAmount: currentState.maxBet > 0 ? 1 : 0,
        maxBet: currentState.maxBet,
      ));
    }
  }

  void _onBetMaxed(LobbyBetMaxed event, Emitter<LobbyState> emit) {
    final currentState = state;
    if (currentState is LobbyReady) {
      emit(LobbyReady(
        selectedSide: currentState.selectedSide,
        betAmount: currentState.maxBet,
        maxBet: currentState.maxBet,
      ));
    }
  }
}

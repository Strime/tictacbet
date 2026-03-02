part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  final bool dailyBonusJustClaimed;

  const WalletLoaded({
    required this.wallet,
    this.dailyBonusJustClaimed = false,
  });

  int get balance => wallet.balance;

  @override
  List<Object?> get props => [wallet, dailyBonusJustClaimed];
}

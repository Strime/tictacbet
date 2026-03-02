import 'package:injectable/injectable.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_local_data_source.dart';

@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletLocalDataSource _localDataSource;

  WalletRepositoryImpl(this._localDataSource);

  @override
  Future<WalletEntity> loadWallet() async {
    final balance = _localDataSource.getBalance();
    final lastBonusDate = _localDataSource.getLastBonusDate();
    return WalletEntity(
      balance: balance,
      lastBonusDate: lastBonusDate,
    );
  }

  @override
  Future<void> saveWallet(WalletEntity wallet) async {
    await _localDataSource.setBalance(wallet.balance);
    if (wallet.lastBonusDate != null) {
      await _localDataSource.setLastBonusDate(wallet.lastBonusDate!);
    }
  }
}

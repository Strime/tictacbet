import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<WalletEntity> loadWallet();
  Future<void> saveWallet(WalletEntity wallet);
}

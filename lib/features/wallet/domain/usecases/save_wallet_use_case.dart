import 'package:injectable/injectable.dart';

import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

@injectable
class SaveWalletUseCase {
  final WalletRepository _repository;

  SaveWalletUseCase(this._repository);

  Future<void> call(WalletEntity wallet) => _repository.saveWallet(wallet);
}

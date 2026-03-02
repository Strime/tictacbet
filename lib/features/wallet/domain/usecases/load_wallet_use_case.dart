import 'package:injectable/injectable.dart';

import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

@injectable
class LoadWalletUseCase {
  final WalletRepository _repository;

  LoadWalletUseCase(this._repository);

  Future<WalletEntity> call() => _repository.loadWallet();
}

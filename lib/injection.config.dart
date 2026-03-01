// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:tictacbet/core/di/app_module.dart' as _i109;
import 'package:tictacbet/features/ai/domain/services/minimax_service.dart'
    as _i801;
import 'package:tictacbet/features/ai/domain/usecases/compute_ai_move_use_case.dart'
    as _i802;
import 'package:tictacbet/features/game/domain/usecases/check_win_use_case.dart'
    as _i805;
import 'package:tictacbet/features/game/domain/usecases/generate_board_use_case.dart'
    as _i806;
import 'package:tictacbet/features/game/domain/usecases/play_move_use_case.dart'
    as _i807;
import 'package:tictacbet/features/game/presentation/bloc/game_bloc.dart'
    as _i808;
import 'package:tictacbet/features/lobby/presentation/bloc/lobby_bloc.dart'
    as _i809;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );

    // AI
    gh.lazySingleton<_i801.MinimaxService>(() => _i801.MinimaxService());
    gh.factory<_i802.ComputeAiMoveUseCase>(
      () => _i802.ComputeAiMoveUseCase(gh<_i801.MinimaxService>()),
    );

    // Game domain
    gh.factory<_i806.GenerateBoardUseCase>(
      () => _i806.GenerateBoardUseCase(),
    );
    gh.factory<_i805.CheckWinUseCase>(() => _i805.CheckWinUseCase());
    gh.factory<_i807.PlayMoveUseCase>(() => _i807.PlayMoveUseCase());

    // Game presentation
    gh.factory<_i808.GameBloc>(
      () => _i808.GameBloc(
        gh<_i806.GenerateBoardUseCase>(),
        gh<_i807.PlayMoveUseCase>(),
        gh<_i802.ComputeAiMoveUseCase>(),
      ),
    );

    // Lobby
    gh.factory<_i809.LobbyBloc>(() => _i809.LobbyBloc());

    return this;
  }
}

class _$AppModule extends _i109.AppModule {}

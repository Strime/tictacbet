// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:math' as _i407;

import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:tictacbet/core/analytics/analytics_service.dart' as _i815;
import 'package:tictacbet/core/analytics/debug_analytics_service.dart' as _i776;
import 'package:tictacbet/core/di/app_module.dart' as _i109;
import 'package:tictacbet/features/ai/domain/services/minimax_service.dart'
    as _i274;
import 'package:tictacbet/features/ai/domain/usecases/compute_ai_move_use_case.dart'
    as _i466;
import 'package:tictacbet/features/game/domain/usecases/check_win_use_case.dart'
    as _i991;
import 'package:tictacbet/features/game/domain/usecases/compute_cash_out_use_case.dart'
    as _i880;
import 'package:tictacbet/features/game/domain/usecases/generate_board_use_case.dart'
    as _i800;
import 'package:tictacbet/features/game/domain/usecases/play_move_use_case.dart'
    as _i740;
import 'package:tictacbet/features/game/presentation/bloc/game_bloc.dart'
    as _i789;
import 'package:tictacbet/features/history/data/datasources/history_local_data_source.dart'
    as _i948;
import 'package:tictacbet/features/history/data/repositories/history_repository_impl.dart'
    as _i980;
import 'package:tictacbet/features/history/domain/repositories/history_repository.dart'
    as _i509;
import 'package:tictacbet/features/history/domain/usecases/load_history_use_case.dart'
    as _i721;
import 'package:tictacbet/features/history/domain/usecases/save_game_result_use_case.dart'
    as _i542;
import 'package:tictacbet/features/history/presentation/bloc/history_bloc.dart'
    as _i341;
import 'package:tictacbet/features/lobby/presentation/bloc/lobby_bloc.dart'
    as _i335;
import 'package:tictacbet/features/onboarding/data/datasources/onboarding_local_data_source.dart'
    as _i185;
import 'package:tictacbet/features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i289;
import 'package:tictacbet/features/profile/presentation/bloc/profile_bloc.dart'
    as _i169;
import 'package:tictacbet/features/progression/data/datasources/progression_local_data_source.dart'
    as _i949;
import 'package:tictacbet/features/progression/data/repositories/progression_repository_impl.dart'
    as _i364;
import 'package:tictacbet/features/progression/domain/repositories/progression_repository.dart'
    as _i926;
import 'package:tictacbet/features/progression/domain/usecases/load_progression_use_case.dart'
    as _i545;
import 'package:tictacbet/features/progression/domain/usecases/save_progression_use_case.dart'
    as _i182;
import 'package:tictacbet/features/progression/presentation/bloc/progression_bloc.dart'
    as _i657;
import 'package:tictacbet/features/wallet/data/datasources/wallet_local_data_source.dart'
    as _i774;
import 'package:tictacbet/features/wallet/data/repositories/wallet_repository_impl.dart'
    as _i83;
import 'package:tictacbet/features/wallet/domain/repositories/wallet_repository.dart'
    as _i411;
import 'package:tictacbet/features/wallet/domain/usecases/load_wallet_use_case.dart'
    as _i27;
import 'package:tictacbet/features/wallet/domain/usecases/save_wallet_use_case.dart'
    as _i278;
import 'package:tictacbet/features/wallet/presentation/bloc/wallet_bloc.dart'
    as _i939;

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
    gh.factory<_i991.CheckWinUseCase>(() => _i991.CheckWinUseCase());
    gh.factory<_i800.GenerateBoardUseCase>(() => _i800.GenerateBoardUseCase());
    gh.lazySingleton<_i274.MinimaxService>(() => _i274.MinimaxService());
    gh.factory<_i774.WalletLocalDataSource>(
      () => _i774.WalletLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i185.OnboardingLocalDataSource>(
      () => _i185.OnboardingLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i949.ProgressionLocalDataSource>(
      () => _i949.ProgressionLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.factoryParam<_i466.ComputeAiMoveUseCase, _i407.Random?, dynamic>(
      (random, _) => _i466.ComputeAiMoveUseCase(
        gh<_i274.MinimaxService>(),
        random: random,
      ),
    );
    gh.factory<_i411.WalletRepository>(
      () => _i83.WalletRepositoryImpl(gh<_i774.WalletLocalDataSource>()),
    );
    gh.factory<_i880.ComputeCashOutUseCase>(
      () => _i880.ComputeCashOutUseCase(gh<_i274.MinimaxService>()),
    );
    gh.factory<_i27.LoadWalletUseCase>(
      () => _i27.LoadWalletUseCase(gh<_i411.WalletRepository>()),
    );
    gh.factory<_i278.SaveWalletUseCase>(
      () => _i278.SaveWalletUseCase(gh<_i411.WalletRepository>()),
    );
    await gh.factoryAsync<_i979.Box<Map<dynamic, dynamic>>>(
      () => appModule.historyBox,
      instanceName: 'historyBox',
      preResolve: true,
    );
    gh.factoryParam<_i740.PlayMoveUseCase, _i407.Random?, dynamic>(
      (random, _) => _i740.PlayMoveUseCase(random: random),
    );
    gh.lazySingleton<_i815.AnalyticsService>(
      () => _i776.DebugAnalyticsService(),
    );
    gh.factory<_i948.HistoryLocalDataSource>(
      () => _i948.HistoryLocalDataSource(
        gh<_i979.Box<Map<dynamic, dynamic>>>(instanceName: 'historyBox'),
      ),
    );
    gh.lazySingleton<_i926.ProgressionRepository>(
      () => _i364.ProgressionRepositoryImpl(
        gh<_i949.ProgressionLocalDataSource>(),
      ),
    );
    gh.factory<_i545.LoadProgressionUseCase>(
      () => _i545.LoadProgressionUseCase(gh<_i926.ProgressionRepository>()),
    );
    gh.factory<_i182.SaveProgressionUseCase>(
      () => _i182.SaveProgressionUseCase(gh<_i926.ProgressionRepository>()),
    );
    gh.lazySingleton<_i657.ProgressionBloc>(
      () => _i657.ProgressionBloc(
        gh<_i545.LoadProgressionUseCase>(),
        gh<_i182.SaveProgressionUseCase>(),
      ),
    );
    gh.factory<_i509.HistoryRepository>(
      () => _i980.HistoryRepositoryImpl(gh<_i948.HistoryLocalDataSource>()),
    );
    gh.factory<_i289.OnboardingCubit>(
      () => _i289.OnboardingCubit(gh<_i185.OnboardingLocalDataSource>()),
    );
    gh.lazySingleton<_i939.WalletBloc>(
      () => _i939.WalletBloc(
        gh<_i27.LoadWalletUseCase>(),
        gh<_i278.SaveWalletUseCase>(),
      ),
    );
    gh.factory<_i721.LoadHistoryUseCase>(
      () => _i721.LoadHistoryUseCase(gh<_i509.HistoryRepository>()),
    );
    gh.factory<_i542.SaveGameResultUseCase>(
      () => _i542.SaveGameResultUseCase(gh<_i509.HistoryRepository>()),
    );
    gh.factory<_i169.ProfileBloc>(
      () => _i169.ProfileBloc(
        gh<_i721.LoadHistoryUseCase>(),
        gh<_i545.LoadProgressionUseCase>(),
      ),
    );
    gh.factory<_i341.HistoryBloc>(
      () => _i341.HistoryBloc(gh<_i721.LoadHistoryUseCase>()),
    );
    gh.factory<_i335.LobbyBloc>(
      () => _i335.LobbyBloc(gh<_i721.LoadHistoryUseCase>()),
    );
    gh.factory<_i789.GameBloc>(
      () => _i789.GameBloc(
        gh<_i800.GenerateBoardUseCase>(),
        gh<_i740.PlayMoveUseCase>(),
        gh<_i466.ComputeAiMoveUseCase>(),
        gh<_i542.SaveGameResultUseCase>(),
        gh<_i880.ComputeCashOutUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i109.AppModule {}

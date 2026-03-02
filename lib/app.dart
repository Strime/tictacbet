import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/progression/presentation/bloc/progression_bloc.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'injection.dart';
import 'l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<WalletBloc>()..add(const WalletStarted()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<ProgressionBloc>()..add(const ProgressionStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'TicTacBet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter,
      ),
    );
  }
}

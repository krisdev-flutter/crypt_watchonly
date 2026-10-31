import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'core/network/dio_client.dart';
import 'features/coin/data/datasources/coin_remote_data_source.dart';
import 'features/coin/data/repositories/coin_repository_impl.dart';
import 'features/coin/domain/repositories/coin_repository.dart';
import 'features/coin/presentation/bloc/coin_detail_bloc.dart';
import 'features/market/presentation/bloc/market_bloc.dart';
import 'features/watchlist/data/watchlist_local_data_source.dart';
import 'features/watchlist/presentation/bloc/watchlist_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = DioClient.create();
  final remoteDataSource = CoinRemoteDataSource(dio);
  final CoinRepository coinRepository = CoinRepositoryImpl(remoteDataSource);
  final watchlistDataSource = WatchlistLocalDataSource();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CoinRepository>.value(value: coinRepository),
        RepositoryProvider<WatchlistLocalDataSource>.value(
          value: watchlistDataSource,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                MarketBloc(coinRepository)..add(const MarketStarted()),
          ),
          BlocProvider(
            create: (_) => WatchlistBloc(watchlistDataSource)
              ..add(const WatchlistStarted()),
          ),
          BlocProvider(
            create: (_) => CoinDetailBloc(coinRepository),
          ),
        ],
        child: const CryptoWatchonlyApp(),
      ),
    ),
  );
}

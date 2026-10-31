import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/coin/presentation/bloc/coin_detail_bloc.dart';
import '../features/coin/presentation/pages/coin_detail_page.dart';
import '../features/market/presentation/pages/market_page.dart';
import '../features/watchlist/presentation/pages/watchlist_page.dart';
import 'theme/app_theme.dart';

class CryptoWatchonlyApp extends StatelessWidget {
  const CryptoWatchonlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Watchonly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routes: {'/': (_) => const MainNavigationPage()},
      onGenerateRoute: (settings) {
        if (settings.name == CoinDetailPage.routeName) {
          final argument = settings.arguments;
          if (argument is! String || argument.isEmpty) {
            return MaterialPageRoute<void>(
              builder: (_) => const _InvalidRoutePage(),
            );
          }
          return PageRouteBuilder<void>(
            settings: settings,
            transitionDuration: const Duration(milliseconds: 260),
            pageBuilder: (context, animation, secondaryAnimation) =>
                BlocProvider.value(
              value: context.read<CoinDetailBloc>()
                ..add(CoinDetailRequested(argument)),
              child: CoinDetailPage(coinId: argument),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic);
              return FadeTransition(
                opacity: curved,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0.025, 0), end: Offset.zero)
                      .animate(curved),
                  child: child,
                ),
              );
            },
          );
        }
        return null;
      },
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [MarketPage(), WatchlistPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart_outlined),
            selectedIcon: Icon(Icons.candlestick_chart_rounded),
            label: 'Markets',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }
}

class _InvalidRoutePage extends StatelessWidget {
  const _InvalidRoutePage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Coin details')),
        body: const Center(child: Text('This coin could not be opened.')),
      );
}

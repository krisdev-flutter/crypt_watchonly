import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../coin/presentation/pages/coin_detail_page.dart';
import '../../../market/presentation/bloc/market_bloc.dart';
import '../bloc/watchlist_bloc.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, watchlist) {
            final market = context.watch<MarketBloc>().state;
            final coins = market.coins
                .where((coin) => watchlist.ids.contains(coin.id))
                .toList()
              ..sort((a, b) =>
                  a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Your watchlist',
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.9)),
                              const SizedBox(height: 5),
                              Text('The assets you want to keep an eye on.',
                                  style: TextStyle(
                                      color: AppTheme.muted, fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: AppTheme.emerald.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppTheme.emerald.withOpacity(0.2))),
                          child: const Icon(Icons.bookmarks_rounded,
                              color: AppTheme.emerald),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(color: AppTheme.border)),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined,
                              color: AppTheme.emerald, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Following',
                                    style: TextStyle(
                                        color: AppTheme.muted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 3),
                                Text(
                                    '${watchlist.ids.length} ${watchlist.ids.length == 1 ? 'asset' : 'assets'} saved',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                          const Icon(Icons.lock_clock_outlined,
                              color: AppTheme.muted, size: 19),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
                if (watchlist.loading)
                  const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()))
                else if (coins.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyWatchlist(
                      title: watchlist.ids.isEmpty
                          ? 'Your watchlist starts here'
                          : 'Saved assets are not loaded',
                      message: watchlist.ids.isEmpty
                          ? 'Tap the bookmark on any market asset to save it here for quick access.'
                          : 'Your saved coin IDs are still stored. Refresh the market to load their latest details.',
                      showRefresh: watchlist.ids.isNotEmpty,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final coin = coins[index];
                          final positive = coin.priceChangePercentage24h >= 0;
                          final accent =
                              positive ? AppTheme.emerald : AppTheme.danger;
                          final initials = coin.symbol.isEmpty
                              ? '?'
                              : coin.symbol.characters.first.toUpperCase();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(22),
                                onTap: () => Navigator.pushNamed(
                                    context, CoinDetailPage.routeName,
                                    arguments: coin.id),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 46,
                                        height: 46,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppTheme.surfaceRaised,
                                            border: Border.all(
                                                color: AppTheme.border)),
                                        child: ClipOval(
                                          child: coin.image.isEmpty
                                              ? Center(
                                                  child: Text(initials,
                                                      style: const TextStyle(
                                                          color:
                                                              AppTheme.emerald,
                                                          fontWeight:
                                                              FontWeight.w800)))
                                              : Image.network(coin.image,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => Center(
                                                      child: Text(initials,
                                                          style: const TextStyle(
                                                              color: AppTheme
                                                                  .emerald,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800)))),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(coin.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w800)),
                                            const SizedBox(height: 4),
                                            Text(coin.symbol.toUpperCase(),
                                                style: const TextStyle(
                                                    color: AppTheme.muted,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              AppFormatters.price(
                                                  coin.currentPrice),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 13)),
                                          const SizedBox(height: 5),
                                          Text(
                                              AppFormatters.percentage(coin
                                                  .priceChangePercentage24h),
                                              style: TextStyle(
                                                  color: accent,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      IconButton(
                                        tooltip: 'Remove from watchlist',
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () => context
                                            .read<WatchlistBloc>()
                                            .add(WatchlistToggled(coin.id)),
                                        icon: const Icon(
                                            Icons.bookmark_remove_outlined,
                                            color: AppTheme.muted,
                                            size: 21),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: coins.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist(
      {required this.title, required this.message, required this.showRefresh});
  final String title;
  final String message;
  final bool showRefresh;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppTheme.border)),
                child: const Icon(Icons.bookmark_add_outlined,
                    size: 32, color: AppTheme.emerald),
              ),
              const SizedBox(height: 18),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.muted, height: 1.5)),
              if (showRefresh) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () =>
                      context.read<MarketBloc>().add(const MarketRefreshed()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh market'),
                ),
              ],
            ],
          ),
        ),
      );
}

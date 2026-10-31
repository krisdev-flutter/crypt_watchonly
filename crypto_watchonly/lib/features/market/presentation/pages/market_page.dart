import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../coin/domain/entities/coin.dart';
import '../../../coin/presentation/pages/coin_detail_page.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../bloc/market_bloc.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.emerald.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: AppTheme.emerald.withOpacity(0.22)),
                      ),
                      child: const Icon(Icons.candlestick_chart_rounded,
                          color: AppTheme.emerald, size: 25),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Crypto Watchonly',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5)),
                          SizedBox(height: 3),
                          Text('Your market, in focus.',
                              style: TextStyle(
                                  color: AppTheme.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: IconButton(
                        tooltip: 'Refresh market',
                        onPressed: () => context
                            .read<MarketBloc>()
                            .add(const MarketRefreshed()),
                        icon: const Icon(Icons.refresh_rounded, size: 21),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF163A2A),
                        Color(0xFF10221A),
                        Color(0xFF101715)
                      ],
                    ),
                    border:
                        Border.all(color: AppTheme.emerald.withOpacity(0.2)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -14,
                        top: -22,
                        child: Icon(Icons.show_chart_rounded,
                            size: 112,
                            color: AppTheme.emerald.withOpacity(0.08)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                    color: AppTheme.emerald,
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 7),
                              const Text('MARKET OVERVIEW',
                                  style: TextStyle(
                                      color: Color(0xFFB9D8C7),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.4)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text('Track the market.',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.8)),
                          const SizedBox(height: 5),
                          const Text(
                              'Explore prices, discover trends, build your watchlist.',
                              style: TextStyle(
                                  color: Color(0xFFB3C8BB),
                                  fontSize: 12,
                                  height: 1.45)),
                          const SizedBox(height: 18),
                          BlocBuilder<MarketBloc, MarketState>(
                            buildWhen: (previous, current) =>
                                previous.coins.length != current.coins.length ||
                                previous.status != current.status,
                            builder: (context, state) => Row(
                              children: [
                                _OverviewMetric(
                                    label: 'ASSETS TRACKED',
                                    value: state.coins.isEmpty
                                        ? '—'
                                        : state.coins.length.toString()),
                                Container(
                                    width: 1,
                                    height: 30,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    color: Colors.white.withOpacity(0.12)),
                                const _OverviewMetric(
                                    label: 'DATA SOURCE', value: 'Live API'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                child: TextField(
                  onChanged: (value) =>
                      context.read<MarketBloc>().add(MarketQueryChanged(value)),
                  decoration: const InputDecoration(
                    hintText: 'Search name or symbol',
                    prefixIcon: Icon(Icons.search_rounded),
                    suffixIcon: Icon(Icons.tune_rounded, size: 19),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: BlocBuilder<MarketBloc, MarketState>(
                  buildWhen: (a, b) => a.filter != b.filter,
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Market movement',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                                label: 'All assets',
                                value: MarketFilter.all,
                                selected: state.filter),
                            const SizedBox(width: 8),
                            _FilterChip(
                                label: 'Gainers',
                                value: MarketFilter.gainers,
                                selected: state.filter),
                            const SizedBox(width: 8),
                            _FilterChip(
                                label: 'Losers',
                                value: MarketFilter.losers,
                                selected: state.filter),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: BlocBuilder<MarketBloc, MarketState>(
                  buildWhen: (a, b) => a.sort != b.sort,
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Explore assets',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _SortChip(
                                label: 'Market cap',
                                value: MarketSort.marketCap,
                                selected: state.sort),
                            const SizedBox(width: 8),
                            _SortChip(
                                label: 'Price',
                                value: MarketSort.price,
                                selected: state.sort),
                            const SizedBox(width: 8),
                            _SortChip(
                                label: '24h change',
                                value: MarketSort.change,
                                selected: state.sort),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: BlocBuilder<MarketBloc, MarketState>(
                  buildWhen: (a, b) =>
                      a.coins.length != b.coins.length ||
                      a.query != b.query ||
                      a.filter != b.filter,
                  builder: (context, state) => Text(
                    state.coins.isEmpty
                        ? 'Loading market assets…'
                        : '${state.visibleCoins.length} of ${state.coins.length} assets',
                    style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            BlocBuilder<MarketBloc, MarketState>(
              builder: (context, state) {
                if (state.status == MarketStatus.loading &&
                    state.coins.isEmpty) {
                  return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status == MarketStatus.failure &&
                    state.coins.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _MessageState(
                      icon: Icons.cloud_off_rounded,
                      title: 'Market data unavailable',
                      message: state.errorMessage ??
                          'We could not connect to the market service.',
                      action: () =>
                          context.read<MarketBloc>().add(const MarketStarted()),
                    ),
                  );
                }
                final coins = state.visibleCoins;
                if (coins.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _MessageState(
                      icon: Icons.search_off_rounded,
                      title: state.query.isEmpty &&
                              state.filter == MarketFilter.all
                          ? 'No assets yet'
                          : 'No matching assets',
                      message: state.query.isEmpty &&
                              state.filter == MarketFilter.all
                          ? 'Market assets will appear here when data is available.'
                          : 'Try another search or switch the market movement filter.',
                      action: () {
                        if (state.query.isEmpty &&
                            state.filter == MarketFilter.all) {
                          context.read<MarketBloc>().add(const MarketStarted());
                        } else {
                          context
                              .read<MarketBloc>()
                              .add(const MarketQueryChanged(''));
                          context
                              .read<MarketBloc>()
                              .add(const MarketFilterChanged(MarketFilter.all));
                        }
                      },
                      actionLabel: state.query.isEmpty &&
                              state.filter == MarketFilter.all
                          ? 'Try again'
                          : 'Clear filters',
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 9),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text('ASSET',
                                        style: TextStyle(
                                            color: AppTheme.muted,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1))),
                                Text('PRICE / 24H',
                                    style: TextStyle(
                                        color: AppTheme.muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1)),
                              ],
                            ),
                          );
                        }
                        final coin = coins[index - 1];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: _CoinTile(coin: coin),
                        );
                      },
                      childCount: coins.length + 1,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF9CB9A8),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        ],
      );
}

class _SortChip extends StatelessWidget {
  const _SortChip(
      {required this.label, required this.value, required this.selected});
  final String label;
  final MarketSort value;
  final MarketSort selected;

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) =>
          context.read<MarketBloc>().add(MarketSortChanged(value)),
      avatar: isSelected
          ? const Icon(Icons.check_rounded, size: 14, color: AppTheme.emerald)
          : null,
      labelStyle: TextStyle(
          color: isSelected ? AppTheme.emerald : AppTheme.muted,
          fontWeight: FontWeight.w700,
          fontSize: 12),
      side: BorderSide(
          color: isSelected
              ? AppTheme.emerald.withOpacity(0.35)
              : AppTheme.border),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.value,
    required this.selected,
  });

  final String label;
  final MarketFilter value;
  final MarketFilter selected;

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) =>
          context.read<MarketBloc>().add(MarketFilterChanged(value)),
      avatar: isSelected
          ? const Icon(Icons.check_rounded, size: 14, color: AppTheme.emerald)
          : null,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.emerald : AppTheme.muted,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      side: BorderSide(
        color:
            isSelected ? AppTheme.emerald.withOpacity(0.35) : AppTheme.border,
      ),
    );
  }
}

class _CoinTile extends StatelessWidget {
  const _CoinTile({required this.coin});
  final Coin coin;

  @override
  Widget build(BuildContext context) {
    final positive = coin.priceChangePercentage24h >= 0;
    final changeColor = positive ? AppTheme.emerald : AppTheme.danger;
    final initials =
        coin.symbol.isEmpty ? '?' : coin.symbol.characters.first.toUpperCase();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.pushNamed(context, CoinDetailPage.routeName,
            arguments: coin.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceRaised,
                  border: Border.all(color: AppTheme.border),
                ),
                child: ClipOval(
                  child: coin.image.isEmpty
                      ? Center(
                          child: Text(initials,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.emerald)))
                      : Image.network(
                          coin.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                              child: Text(initials,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.emerald))),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coin.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                        '${coin.symbol.toUpperCase()}  ·  ${coin.marketCapRank > 0 ? '#${coin.marketCapRank}' : 'Unranked'}',
                        style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppFormatters.price(coin.currentPrice),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFeatures: [FontFeature.tabularFigures()])),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: changeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            positive
                                ? Icons.north_east_rounded
                                : Icons.south_east_rounded,
                            size: 11,
                            color: changeColor),
                        const SizedBox(width: 3),
                        Text(
                            AppFormatters.percentage(
                                coin.priceChangePercentage24h),
                            style: TextStyle(
                                fontSize: 10,
                                color: changeColor,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              BlocBuilder<WatchlistBloc, WatchlistState>(
                builder: (context, state) => IconButton(
                  visualDensity: VisualDensity.compact,
                  constraints:
                      const BoxConstraints.tightFor(width: 34, height: 40),
                  onPressed: () => context
                      .read<WatchlistBloc>()
                      .add(WatchlistToggled(coin.id)),
                  icon: Icon(
                      state.contains(coin.id)
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 20,
                      color: state.contains(coin.id)
                          ? AppTheme.emerald
                          : AppTheme.muted),
                  tooltip: state.contains(coin.id)
                      ? 'Remove from watchlist'
                      : 'Add to watchlist',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState(
      {required this.icon,
      required this.title,
      required this.message,
      required this.action,
      this.actionLabel = 'Try again'});
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback action;
  final String actionLabel;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                    color: AppTheme.surfaceRaised,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.border)),
                child: Icon(icon, size: 29, color: AppTheme.emerald),
              ),
              const SizedBox(height: 18),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 7),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.muted, height: 1.5)),
              const SizedBox(height: 18),
              FilledButton.icon(
                  onPressed: action,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(actionLabel)),
            ],
          ),
        ),
      );
}

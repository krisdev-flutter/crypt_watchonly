import 'dart:ui' show FontFeature;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../bloc/coin_detail_bloc.dart';

class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({super.key, required this.coinId});
  static const routeName = '/coin-detail';
  final String coinId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset overview'),
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          BlocBuilder<CoinDetailBloc, CoinDetailState>(
            builder: (context, state) {
              final id = state.detail?.id ?? coinId;
              return BlocBuilder<WatchlistBloc, WatchlistState>(
                builder: (context, watchlist) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton.filledTonal(
                    tooltip: watchlist.contains(id)
                        ? 'Remove from watchlist'
                        : 'Add to watchlist',
                    onPressed: () =>
                        context.read<WatchlistBloc>().add(WatchlistToggled(id)),
                    icon: Icon(watchlist.contains(id)
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_add_outlined),
                    style: IconButton.styleFrom(
                      foregroundColor: watchlist.contains(id)
                          ? AppTheme.emerald
                          : AppTheme.muted,
                      backgroundColor: AppTheme.surfaceRaised,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CoinDetailBloc, CoinDetailState>(
        builder: (context, state) {
          if (state.status == CoinDetailStatus.loading &&
              state.detail == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CoinDetailStatus.failure &&
              state.detail == null) {
            return _DetailError(
              message:
                  state.errorMessage ?? 'Unable to load this asset right now.',
              onRetry: () => context
                  .read<CoinDetailBloc>()
                  .add(CoinDetailRequested(coinId)),
            );
          }
          final coin = state.detail;
          if (coin == null) {
            return _DetailError(
              message: state.errorMessage ??
                  'No details are available for this asset.',
              onRetry: () => context
                  .read<CoinDetailBloc>()
                  .add(CoinDetailRequested(coinId)),
            );
          }
          final positive = coin.priceChangePercentage24h >= 0;
          final accent = positive ? AppTheme.emerald : AppTheme.danger;
          final initials = coin.symbol.isEmpty
              ? '?'
              : coin.symbol.characters.first.toUpperCase();

          return RefreshIndicator(
            color: AppTheme.emerald,
            backgroundColor: AppTheme.surfaceRaised,
            onRefresh: () async =>
                context.read<CoinDetailBloc>().add(CoinDetailRequested(coinId)),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF173A2A),
                        Color(0xFF101C16),
                        Color(0xFF101715)
                      ],
                    ),
                    border:
                        Border.all(color: AppTheme.emerald.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.07),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.12))),
                            child: ClipOval(
                              child: coin.image.isEmpty
                                  ? Center(
                                      child: Text(initials,
                                          style: const TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w800,
                                              color: AppTheme.emerald)))
                                  : Image.network(coin.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                          child: Text(initials,
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppTheme.emerald)))),
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(coin.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5)),
                                const SizedBox(height: 4),
                                Text(
                                    '${coin.symbol.toUpperCase()}  ·  ${coin.marketCapRank > 0 ? 'Rank #${coin.marketCapRank}' : 'Market asset'}',
                                    style: const TextStyle(
                                        color: Color(0xFFB4C9BC),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 7),
                            decoration: BoxDecoration(
                                color: accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(11)),
                            child: Icon(
                                positive
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                                color: accent,
                                size: 19),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      const Text('CURRENT PRICE',
                          style: TextStyle(
                              color: Color(0xFF9DB9A8),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4)),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(AppFormatters.price(coin.currentPrice),
                            style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                                fontFeatures: [FontFeature.tabularFigures()])),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                                color: accent.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(9)),
                            child: Row(
                              children: [
                                Icon(
                                    positive
                                        ? Icons.north_east_rounded
                                        : Icons.south_east_rounded,
                                    color: accent,
                                    size: 13),
                                const SizedBox(width: 4),
                                Text(
                                    AppFormatters.percentage(
                                        coin.priceChangePercentage24h),
                                    style: TextStyle(
                                        color: accent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('past 24 hours',
                              style: TextStyle(
                                  color: Color(0xFF9DB9A8), fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                        child: Text('Price history',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4))),
                    if (state.chartLoading)
                      const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
                const SizedBox(height: 5),
                const Text('Explore price movement over time',
                    style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 17, 14, 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            for (final period in const [
                              (1, '24H'),
                              (7, '7D'),
                              (30, '30D'),
                              (90, '90D')
                            ])
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: _PeriodButton(
                                    label: period.$2,
                                    selected: state.days == period.$1,
                                    onTap: () => context
                                        .read<CoinDetailBloc>()
                                        .add(CoinChartPeriodChanged(period.$1)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          height: 205,
                          child: state.chartLoading && state.points.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : state.points.length < 2
                                  ? const _ChartEmptyState()
                                  : LineChart(
                                      LineChartData(
                                        minX: 0,
                                        maxX: (state.points.length - 1)
                                            .toDouble(),
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: false,
                                          horizontalInterval:
                                              _horizontalInterval(state.points
                                                  .map((p) => p.price)
                                                  .toList()),
                                          getDrawingHorizontalLine: (_) =>
                                              FlLine(
                                                  color: AppTheme.border,
                                                  strokeWidth: 0.7,
                                                  dashArray: [4, 4]),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        titlesData: const FlTitlesData(
                                          topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          rightTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                        ),
                                        lineTouchData: LineTouchData(
                                          enabled: true,
                                          touchSpotThreshold: 18,
                                          getTouchedSpotIndicator: (barData,
                                                  spotIndexes) =>
                                              spotIndexes
                                                  .map((index) =>
                                                      TouchedSpotIndicatorData(
                                                        FlLine(
                                                            color: AppTheme
                                                                .emerald
                                                                .withOpacity(
                                                                    0.55),
                                                            strokeWidth: 1,
                                                            dashArray: [3, 3]),
                                                        FlDotData(
                                                            show: true,
                                                            getDotPainter: (spot,
                                                                    percent,
                                                                    bar,
                                                                    index) =>
                                                                FlDotCirclePainter(
                                                                    radius: 4,
                                                                    color: AppTheme
                                                                        .emerald,
                                                                    strokeWidth:
                                                                        2,
                                                                    strokeColor:
                                                                        AppTheme
                                                                            .background)),
                                                      ))
                                                  .toList(),
                                          touchTooltipData:
                                              LineTouchTooltipData(
                                            getTooltipColor: (_) =>
                                                AppTheme.surfaceRaised,
                                            tooltipRoundedRadius: 10,
                                            tooltipPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 7),
                                            getTooltipItems: (spots) => spots
                                                .map((spot) => LineTooltipItem(
                                                      AppFormatters.price(
                                                          spot.y),
                                                      const TextStyle(
                                                          color:
                                                              AppTheme.emerald,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: state.points
                                                .asMap()
                                                .entries
                                                .map((entry) => FlSpot(
                                                    entry.key.toDouble(),
                                                    entry.value.price))
                                                .toList(),
                                            isCurved: true,
                                            curveSmoothness: 0.18,
                                            color: AppTheme.emerald,
                                            barWidth: 2.5,
                                            isStrokeCapRound: true,
                                            dotData:
                                                const FlDotData(show: false),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              color: AppTheme.emerald
                                                  .withOpacity(0.1),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppTheme.emerald
                                                      .withOpacity(0.2),
                                                  AppTheme.emerald
                                                      .withOpacity(0.005)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                        ),
                        if (state.errorMessage != null &&
                            state.detail != null) ...[
                          const SizedBox(height: 10),
                          Text('Chart update failed: ${state.errorMessage}',
                              style: const TextStyle(
                                  color: AppTheme.danger, fontSize: 11)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Market statistics',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4)),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 520 ? 3 : 2,
                  childAspectRatio:
                      MediaQuery.of(context).size.width > 520 ? 2.0 : 1.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _StatCard(
                        label: 'Market cap',
                        value: AppFormatters.moneyCompact(coin.marketCap),
                        icon: Icons.pie_chart_outline_rounded),
                    _StatCard(
                        label: '24h volume',
                        value: AppFormatters.moneyCompact(coin.totalVolume),
                        icon: Icons.swap_vert_rounded),
                    _StatCard(
                        label: '24h high',
                        value: AppFormatters.price(coin.high24h),
                        icon: Icons.arrow_upward_rounded,
                        valueColor: AppTheme.emerald),
                    _StatCard(
                        label: '24h low',
                        value: AppFormatters.price(coin.low24h),
                        icon: Icons.arrow_downward_rounded,
                        valueColor: AppTheme.danger),
                    _StatCard(
                        label: 'Circulating supply',
                        value:
                            AppFormatters.numberCompact(coin.circulatingSupply),
                        icon: Icons.toll_outlined),
                    _StatCard(
                        label: 'Max supply',
                        value: coin.maxSupply == null
                            ? 'N/A'
                            : AppFormatters.numberCompact(coin.maxSupply!),
                        icon: Icons.all_inclusive_rounded),
                  ],
                ),
                if (coin.description.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('About this asset',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Text(coin.description,
                          style: const TextStyle(
                              color: AppTheme.muted,
                              height: 1.65,
                              fontSize: 13)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  double _horizontalInterval(List<double> values) {
    if (values.isEmpty) return 1;
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    return range <= 0
        ? (maxValue.abs() * 0.2).clamp(0.01, double.infinity).toDouble()
        : range / 4;
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color:
            selected ? AppTheme.emerald.withOpacity(0.13) : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                  color: selected
                      ? AppTheme.emerald.withOpacity(0.35)
                      : AppTheme.border),
            ),
            child: Text(label,
                style: TextStyle(
                    color: selected ? AppTheme.emerald : AppTheme.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
          ),
        ),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      this.valueColor});
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: AppTheme.emerald),
              const SizedBox(height: 11),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppTheme.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: valueColor ?? const Color(0xFFF2F7F3))),
            ],
          ),
        ),
      );
}

class _ChartEmptyState extends StatelessWidget {
  const _ChartEmptyState();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart_rounded, size: 32, color: AppTheme.muted),
            SizedBox(height: 8),
            Text('Chart data unavailable',
                style: TextStyle(color: AppTheme.muted, fontSize: 12)),
          ],
        ),
      );
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

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
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.border)),
                child: const Icon(Icons.cloud_off_rounded,
                    color: AppTheme.emerald, size: 29),
              ),
              const SizedBox(height: 17),
              const Text('Could not load asset',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.muted, height: 1.5)),
              const SizedBox(height: 18),
              FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try again')),
            ],
          ),
        ),
      );
}

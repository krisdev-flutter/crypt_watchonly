import '../../domain/entities/coin_detail.dart';

class CoinDetailModel extends CoinDetail {
  const CoinDetailModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.description,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    required super.marketCapRank,
    required super.high24h,
    required super.low24h,
    required super.priceChangePercentage24h,
    required super.totalVolume,
    required super.circulatingSupply,
    required super.maxSupply,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    final market = (json['market_data'] as Map<String, dynamic>?) ?? {};
    final current = (market['current_price'] as Map<String, dynamic>?) ?? {};
    final high = (market['high_24h'] as Map<String, dynamic>?) ?? {};
    final low = (market['low_24h'] as Map<String, dynamic>?) ?? {};
    final description = (json['description'] as Map<String, dynamic>?) ?? {};
    final image = (json['image'] as Map<String, dynamic>?) ?? {};
    double value(Map<String, dynamic> map, String key) =>
        (map[key] as num?)?.toDouble() ?? 0;

    return CoinDetailModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      symbol: (json['symbol']?.toString() ?? '').toUpperCase(),
      description: (description['en']?.toString() ?? '')
          .replaceAll(RegExp(r'<[^>]*>'), ''),
      image: image['large']?.toString() ?? image['small']?.toString() ?? '',
      currentPrice: value(current, 'usd'),
      marketCap:
          value((market['market_cap'] as Map<String, dynamic>?) ?? {}, 'usd'),
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      high24h: value(high, 'usd'),
      low24h: value(low, 'usd'),
      priceChangePercentage24h: value(market, 'price_change_percentage_24h'),
      totalVolume:
          value((market['total_volume'] as Map<String, dynamic>?) ?? {}, 'usd'),
      circulatingSupply: value(market, 'circulating_supply'),
      maxSupply: (market['max_supply'] as num?)?.toDouble(),
    );
  }
}

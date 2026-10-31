import '../../domain/entities/coin.dart';

class CoinModel extends Coin {
  const CoinModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    required super.marketCapRank,
    required super.priceChangePercentage24h,
    required super.totalVolume,
    required super.circulatingSupply,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    double number(String key) => (json[key] as num?)?.toDouble() ?? 0;
    return CoinModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      symbol: (json['symbol']?.toString() ?? '').toUpperCase(),
      image: json['image']?.toString() ?? '',
      currentPrice: number('current_price'),
      marketCap: number('market_cap'),
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      priceChangePercentage24h: number('price_change_percentage_24h'),
      totalVolume: number('total_volume'),
      circulatingSupply: number('circulating_supply'),
    );
  }
}

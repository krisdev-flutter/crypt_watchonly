import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  const Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    required this.circulatingSupply,
  });

  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double priceChangePercentage24h;
  final double totalVolume;
  final double circulatingSupply;

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        image,
        currentPrice,
        marketCap,
        marketCapRank,
        priceChangePercentage24h,
        totalVolume,
        circulatingSupply,
      ];
}

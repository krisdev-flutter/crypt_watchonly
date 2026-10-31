import 'package:equatable/equatable.dart';

class CoinDetail extends Equatable {
  const CoinDetail({
    required this.id,
    required this.name,
    required this.symbol,
    required this.description,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.high24h,
    required this.low24h,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    required this.circulatingSupply,
    required this.maxSupply,
  });

  final String id;
  final String name;
  final String symbol;
  final String description;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double high24h;
  final double low24h;
  final double priceChangePercentage24h;
  final double totalVolume;
  final double circulatingSupply;
  final double? maxSupply;

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        description,
        image,
        currentPrice,
        marketCap,
        marketCapRank,
        high24h,
        low24h,
        priceChangePercentage24h,
        totalVolume,
        circulatingSupply,
        maxSupply,
      ];
}

import '../entities/coin.dart';
import '../entities/coin_detail.dart';
import '../entities/price_point.dart';

abstract interface class CoinRepository {
  Future<List<Coin>> getMarkets(
      {String currency = 'usd', int page = 1, int perPage = 100});
  Future<CoinDetail> getCoinDetails(String id);
  Future<List<PricePoint>> getCoinChart(String id, {int days = 7});
}

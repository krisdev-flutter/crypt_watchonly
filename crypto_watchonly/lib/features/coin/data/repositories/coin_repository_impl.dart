import '../../domain/entities/coin.dart';
import '../../domain/entities/coin_detail.dart';
import '../../domain/entities/price_point.dart';
import '../../domain/repositories/coin_repository.dart';
import '../datasources/coin_remote_data_source.dart';

class CoinRepositoryImpl implements CoinRepository {
  CoinRepositoryImpl(this._remote);
  final CoinRemoteDataSource _remote;

  @override
  Future<List<Coin>> getMarkets(
          {String currency = 'usd', int page = 1, int perPage = 100}) =>
      _remote.getMarkets(currency: currency, page: page, perPage: perPage);

  @override
  Future<CoinDetail> getCoinDetails(String id) => _remote.getCoinDetails(id);

  @override
  Future<List<PricePoint>> getCoinChart(String id, {int days = 7}) =>
      _remote.getCoinChart(id, days: days);
}

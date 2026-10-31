import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../models/coin_detail_model.dart';
import '../models/coin_model.dart';
import '../models/price_point_model.dart';

class CoinRemoteDataSource {
  CoinRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<CoinModel>> getMarkets({
    String currency = 'usd',
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.market,
        queryParameters: {
          'vs_currency': currency,
          'order': 'market_cap_desc',
          'per_page': perPage,
          'page': page,
          'sparkline': false,
        },
      );
      final data = response.data;
      final list =
          data is Map<String, dynamic> ? data['data'] as List? : data as List?;
      if (list == null) {
        throw const AppException('Unexpected market response format.');
      }
      return list
          .map((item) =>
              CoinModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } on DioException catch (error) {
      throw AppException(_messageFromDio(error));
    }
  }

  Future<CoinDetailModel> getCoinDetails(String id) async {
    try {
      final response = await _dio.get(ApiConstants.coinDetails(id));
      final data = response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data')
          ? (response.data as Map<String, dynamic>)['data']
          : response.data;
      return CoinDetailModel.fromJson(Map<String, dynamic>.from(data as Map));
    } on DioException catch (error) {
      throw AppException(_messageFromDio(error));
    }
  }

  Future<List<PricePointModel>> getCoinChart(String id, {int days = 7}) async {
    try {
      final response = await _dio.get(
        ApiConstants.coinChart(id),
        queryParameters: {'vs_currency': 'usd', 'days': days},
      );
      final raw = response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('data')
          ? (response.data as Map<String, dynamic>)['data']
          : response.data;
      final prices =
          raw is Map<String, dynamic> ? raw['prices'] as List? : null;
      if (prices == null) {
        throw const AppException('Unexpected chart response format.');
      }
      return prices
          .map((item) =>
              PricePointModel.fromList(List<dynamic>.from(item as List)))
          .toList();
    } on DioException catch (error) {
      throw AppException(_messageFromDio(error));
    }
  }

  String _messageFromDio(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'The server took too long to respond. Please try again.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Cannot connect to the backend. Check that the Node server is running and the API URL is correct.';
    }
    final status = error.response?.statusCode;
    if (status == 404) {
      return 'The requested data was not found (404).';
    }
    if (status == 429) {
      return 'API rate limit reached. Please wait and try again.';
    }
    if (status != null && status >= 500) {
      return 'The market service is temporarily unavailable.';
    }
    return 'Unable to load data. Please try again.';
  }
}

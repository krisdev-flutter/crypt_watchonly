class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const String market = '/coins/markets';

  static String coinDetails(String id) => '/coins/$id';

  static String coinChart(String id) => '/coins/$id/market-chart';
}

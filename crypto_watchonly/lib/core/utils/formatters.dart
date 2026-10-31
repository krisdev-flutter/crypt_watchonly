import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final _currency =
      NumberFormat.currency(symbol: r'$', decimalDigits: 2);
  static final _compact =
      NumberFormat.compactCurrency(symbol: r'$', decimalDigits: 2);
  static final _number = NumberFormat.compact();

  static String price(double value) {
    if (value >= 1) return _currency.format(value);
    return '\$${value.toStringAsFixed(6)}';
  }

  static String moneyCompact(double value) => _compact.format(value);
  static String numberCompact(double value) => _number.format(value);
  static String percentage(double value) =>
      '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}%';
}

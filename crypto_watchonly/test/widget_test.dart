import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_watchonly/core/utils/formatters.dart';

void main() {
  test('formats positive and negative percentage changes', () {
    expect(AppFormatters.percentage(1.234), '+1.23%');
    expect(AppFormatters.percentage(-2.345), '-2.35%');
  });
}

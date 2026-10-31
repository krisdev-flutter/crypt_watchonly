import '../../domain/entities/price_point.dart';

class PricePointModel extends PricePoint {
  const PricePointModel({required super.timestamp, required super.price});

  factory PricePointModel.fromList(List<dynamic> values) {
    return PricePointModel(
      timestamp:
          DateTime.fromMillisecondsSinceEpoch((values[0] as num).toInt()),
      price: (values[1] as num).toDouble(),
    );
  }
}

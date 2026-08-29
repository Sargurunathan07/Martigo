/// Aggregated demand for a single product/menu item on a given date,
/// computed from multiple customer [Order]s. Consumed by sellers to
/// plan stock/preparation.
class Demand {
  final String productId;
  final String productName;
  final DateTime date;
  final int totalQuantity;
  final String unit;

  /// Number of distinct orders that contributed to this aggregated demand.
  final int numberOfOrders;

  const Demand({
    required this.productId,
    required this.productName,
    required this.date,
    required this.totalQuantity,
    required this.unit,
    required this.numberOfOrders,
  });

  factory Demand.fromJson(Map<String, dynamic> json) {
    return Demand(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      date: DateTime.parse(json['date'] as String),
      totalQuantity: json['totalQuantity'] as int,
      unit: json['unit'] as String,
      numberOfOrders: json['numberOfOrders'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'date': date.toIso8601String(),
      'totalQuantity': totalQuantity,
      'unit': unit,
      'numberOfOrders': numberOfOrders,
    };
  }

  /// Builds aggregated [Demand] entries from a list of orders for a given
  /// date, grouping by product. This is the link in the chain:
  /// Customer → Pre-order → Order items → Aggregated demand → Seller.
  static List<Demand> aggregateFromOrders({
    required List<dynamic> orders, // expects List<Order>
    required DateTime date,
  }) {
    // Kept generic/untyped here to avoid a circular import between
    // order.dart and demand.dart; real aggregation logic belongs in
    // core/services, not in the model layer.
    throw UnimplementedError(
      'Aggregation logic belongs in a service, not in the model layer.',
    );
  }
}
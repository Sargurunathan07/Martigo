/// Lifecycle status of a pre-order.
enum OrderStatus { pending, confirmed, preparing, ready, completed, cancelled }

/// A single product line within an [Order].
class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => unitPrice * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}

/// A customer's pre-order, placed ahead of a chosen pickup date.
class Order {
  final String id;
  final String customerId;
  final List<OrderItem> items;
  final double total;
  final String communityId;

  /// Date the customer has selected for pickup/fulfillment.
  final DateTime preOrderDate;
  final OrderStatus status;
  final String pickupLocation;

  const Order({
    required this.id,
    required this.customerId,
    required this.items,
    required this.total,
    required this.communityId,
    required this.preOrderDate,
    required this.pickupLocation,
    this.status = OrderStatus.pending,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      communityId: json['communityId'] as String,
      preOrderDate: DateTime.parse(json['preOrderDate'] as String),
      pickupLocation: json['pickupLocation'] as String,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'items': items.map((i) => i.toJson()).toList(),
      'total': total,
      'communityId': communityId,
      'preOrderDate': preOrderDate.toIso8601String(),
      'pickupLocation': pickupLocation,
      'status': status.name,
    };
  }

  Order copyWith({
    String? id,
    String? customerId,
    List<OrderItem>? items,
    double? total,
    String? communityId,
    DateTime? preOrderDate,
    OrderStatus? status,
    String? pickupLocation,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      total: total ?? this.total,
      communityId: communityId ?? this.communityId,
      preOrderDate: preOrderDate ?? this.preOrderDate,
      status: status ?? this.status,
      pickupLocation: pickupLocation ?? this.pickupLocation,
    );
  }
}

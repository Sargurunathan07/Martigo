/// Availability state of a product as set by the seller.
enum ProductAvailability { available, outOfStock, comingSoon }

/// A product or menu item offered by a seller.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;

  /// Unit of measure/sale, e.g. "kg", "litre", "piece", "plate".
  final String unit;
  final int stock;
  final ProductAvailability availability;

  /// URL or local asset path for the product image.
  final String? image;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.stock,
    this.availability = ProductAvailability.available,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      stock: json['stock'] as int? ?? 0,
      availability: ProductAvailability.values.firstWhere(
        (a) => a.name == json['availability'],
        orElse: () => ProductAvailability.available,
      ),
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'unit': unit,
      'stock': stock,
      'availability': availability.name,
      'image': image,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? unit,
    int? stock,
    ProductAvailability? availability,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      availability: availability ?? this.availability,
      image: image ?? this.image,
    );
  }
}
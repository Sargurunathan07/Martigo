import 'package:flutter/material.dart';

import '../../models/product.dart';

class CustomerCartItem {
  final Product product;
  int quantity;

  CustomerCartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

class CustomerCartStore extends ChangeNotifier {
  CustomerCartStore._();

  static final CustomerCartStore instance = CustomerCartStore._();

  final Map<String, CustomerCartItem> _items = {};

  DateTime? _pickupDate;
  String? _pickupSlot;

  List<CustomerCartItem> get items => List.unmodifiable(_items.values);

  DateTime? get pickupDate => _pickupDate;
  String? get pickupSlot => _pickupSlot;

  bool get isEmpty => _items.isEmpty;

  int get itemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  double get total =>
      _items.values.fold(0, (total, item) => total + item.subtotal);

  void addProduct(Product product) {
    if (product.stock <= 0) return;

    final existing = _items[product.id];

    if (existing != null) {
      if (existing.quantity < product.stock) {
        existing.quantity++;
      }
    } else {
      _items[product.id] = CustomerCartItem(product: product);
    }

    notifyListeners();
  }

  void increment(String productId) {
    final item = _items[productId];

    if (item == null) return;

    if (item.quantity < item.product.stock) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decrement(String productId) {
    final item = _items[productId];

    if (item == null) return;

    if (item.quantity <= 1) {
      _items.remove(productId);
    } else {
      item.quantity--;
    }

    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void setPickup({required DateTime date, required String slot}) {
    _pickupDate = date;
    _pickupSlot = slot;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _pickupDate = null;
    _pickupSlot = null;
    notifyListeners();
  }
}

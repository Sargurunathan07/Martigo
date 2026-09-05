import '../../models/community.dart';
import '../../models/product.dart';
import 'customer_mock_data.dart';

class CustomerCatalogData {
  CustomerCatalogData._();

  static const List<Product> supermarketProducts = [
    Product(
      id: 'sm001',
      name: 'Fresh Milk 1L',
      category: 'Dairy',
      price: 60,
      unit: 'packet',
      stock: 50,
    ),
    Product(
      id: 'sm002',
      name: 'Whole Wheat Bread',
      category: 'Bakery',
      price: 45,
      unit: 'loaf',
      stock: 30,
    ),
    Product(
      id: 'sm003',
      name: 'Eggs',
      category: 'Dairy',
      price: 72,
      unit: '6 pcs',
      stock: 60,
    ),
    Product(
      id: 'sm004',
      name: 'Tomatoes',
      category: 'Vegetables',
      price: 40,
      unit: 'kg',
      stock: 25,
    ),
    Product(
      id: 'sm005',
      name: 'Brown Rice',
      category: 'Groceries',
      price: 280,
      unit: '5 kg',
      stock: 20,
    ),
    Product(
      id: 'sm006',
      name: 'Potato Chips',
      category: 'Snacks',
      price: 30,
      unit: 'pack',
      stock: 40,
    ),
  ];

  static const List<Product> collegeMenu = [
    Product(
      id: 'cl001',
      name: 'Veg Meals',
      category: 'Meals',
      price: 80,
      unit: 'plate',
      stock: 60,
    ),
    Product(
      id: 'cl002',
      name: 'Chicken Rice',
      category: 'Meals',
      price: 120,
      unit: 'plate',
      stock: 45,
    ),
    Product(
      id: 'cl003',
      name: 'Veg Burger',
      category: 'Snacks',
      price: 65,
      unit: 'piece',
      stock: 30,
    ),
    Product(
      id: 'cl004',
      name: 'French Fries',
      category: 'Snacks',
      price: 55,
      unit: 'portion',
      stock: 35,
    ),
    Product(
      id: 'cl005',
      name: 'Fresh Lime Juice',
      category: 'Drinks',
      price: 35,
      unit: 'glass',
      stock: 50,
    ),
    Product(
      id: 'cl006',
      name: 'Cold Coffee',
      category: 'Drinks',
      price: 60,
      unit: 'glass',
      stock: 30,
    ),
  ];

  static List<Product> get currentProducts {
    final community = CustomerMockData.currentCommunity;

    if (community.businessType == BusinessType.canteen) {
      return collegeMenu;
    }

    return supermarketProducts;
  }

  static List<String> get currentCategories {
    final categories = currentProducts.map((p) => p.category).toSet().toList();
    categories.sort();
    return categories;
  }
}

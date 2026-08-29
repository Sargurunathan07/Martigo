import '../../models/user.dart';
import '../../models/community.dart';
import '../../models/product.dart';
import '../../models/order.dart';
import '../../models/demand.dart';

/// Static mock data used for local development and UI building before
/// any backend integration exists. Not connected to any API or database.
class MockData {
  MockData._();

  static const List<User> users = [
    User(
      id: 'u001',
      name: 'Aarav Sharma',
      email: 'aarav.sharma@example.com',
      mobile: '9876543210',
      role: UserRole.customer,
      communityId: 'com001',
    ),
    User(
      id: 'u002',
      name: 'Priya Nair',
      email: 'priya.nair@example.com',
      mobile: '9876500001',
      role: UserRole.seller,
      communityId: 'com001',
    ),
    User(
      id: 'u003',
      name: 'Ravi Kumar',
      email: 'ravi.kumar@example.com',
      mobile: '9876500002',
      role: UserRole.admin,
    ),
    User(
      id: 'u004',
      name: 'Divya Menon',
      email: 'divya.menon@example.com',
      mobile: '9876500003',
      role: UserRole.customer,
      communityId: 'com002',
    ),
  ];

  static const List<Community> communities = [
    Community(
      id: 'com001',
      name: 'Sunrise Apartments',
      code: 'SUNRISE-A72',
      type: CommunityType.apartment,
      businessName: 'Sunrise Supermarket',
      businessType: BusinessType.supermarket,
    ),
    Community(
      id: 'com002',
      name: 'ABC Engineering College',
      code: 'ABCENGG-C14',
      type: CommunityType.college,
      businessName: 'ABC Campus Canteen',
      businessType: BusinessType.canteen,
    ),
  ];

  static const List<Product> products = [
    Product(
      id: 'p001',
      name: 'Fresh Milk (1L)',
      category: 'Dairy',
      price: 60.0,
      unit: 'litre',
      stock: 50,
      availability: ProductAvailability.available,
    ),
    Product(
      id: 'p002',
      name: 'Whole Wheat Bread',
      category: 'Bakery',
      price: 45.0,
      unit: 'piece',
      stock: 30,
      availability: ProductAvailability.available,
    ),
    Product(
      id: 'p003',
      name: 'Organic Vegetables Box',
      category: 'Vegetables',
      price: 250.0,
      unit: 'box',
      stock: 15,
      availability: ProductAvailability.available,
    ),
  ];

  static final List<Order> orders = [
    Order(
      id: 'o001',
      customerId: 'u001',
      items: const [
        OrderItem(
          productId: 'p001',
          productName: 'Fresh Milk (1L)',
          quantity: 2,
          unitPrice: 60.0,
        ),
        OrderItem(
          productId: 'p002',
          productName: 'Whole Wheat Bread',
          quantity: 1,
          unitPrice: 45.0,
        ),
      ],
      total: 165.0,
      communityId: 'com001',
      preOrderDate: DateTime(2026, 8, 30),
      pickupLocation: 'Sunrise Supermarket Counter',
      status: OrderStatus.confirmed,
    ),
    Order(
      id: 'o002',
      customerId: 'u004',
      items: const [
        OrderItem(
          productId: 'p003',
          productName: 'Organic Vegetables Box',
          quantity: 1,
          unitPrice: 250.0,
        ),
      ],
      total: 250.0,
      communityId: 'com002',
      preOrderDate: DateTime(2026, 8, 29),
      pickupLocation: 'ABC Campus Canteen Counter',
      status: OrderStatus.pending,
    ),
  ];

  static final List<Demand> demands = [
    Demand(
      productId: 'p004',
      productName: 'Paneer (500g)',
      date: DateTime(2026, 8, 30),
      totalQuantity: 20,
      unit: 'kg',
      numberOfOrders: 8,
    ),
    Demand(
      productId: 'p005',
      productName: 'Brown Rice (5kg)',
      date: DateTime(2026, 8, 30),
      totalQuantity: 10,
      unit: 'bag',
      numberOfOrders: 4,
    ),
  ];
}

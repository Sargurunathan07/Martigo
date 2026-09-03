import '../../models/community.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import 'customer_session.dart';

/// Represents a single notification shown to the customer.
class NotificationItem {
  final String id;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

/// Mock data for the customer experience: the signed-in user, their
/// community, their orders, and notifications. No backend involved.
class CustomerMockData {
  CustomerMockData._();

  static const User currentUser = User(
    id: 'u001',
    name: 'Aarav Sharma',
    email: 'aarav.sharma@example.com',
    mobile: '9876543210',
    role: UserRole.customer,
    communityId: 'com001',
  );

  /// Change this to `collegeCanteenCommunity` to preview the
  /// college + canteen home layout instead.
  static Community get currentCommunity =>
      CustomerSession.instance.selectedCommunity ??
      apartmentSupermarketCommunity;

  static const Community apartmentSupermarketCommunity = Community(
    id: 'com001',
    name: 'Sunrise Apartments',
    code: 'SUNRISE-A72',
    type: CommunityType.apartment,
    businessName: 'Sunrise Supermarket',
    businessType: BusinessType.supermarket,
  );

  static const Community collegeCanteenCommunity = Community(
    id: 'com002',
    name: 'ABC Engineering College',
    code: 'ABCENGG-C14',
    type: CommunityType.college,
    businessName: 'ABC Campus Canteen',
    businessType: BusinessType.canteen,
  );

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
      customerId: 'u001',
      items: const [
        OrderItem(
          productId: 'p003',
          productName: 'Organic Vegetables Box',
          quantity: 1,
          unitPrice: 250.0,
        ),
      ],
      total: 250.0,
      communityId: 'com001',
      preOrderDate: DateTime(2026, 8, 20),
      pickupLocation: 'Sunrise Supermarket Counter',
      status: OrderStatus.completed,
    ),
    Order(
      id: 'o003',
      customerId: 'u001',
      items: const [
        OrderItem(
          productId: 'p004',
          productName: 'Paneer (500g)',
          quantity: 1,
          unitPrice: 120.0,
        ),
      ],
      total: 120.0,
      communityId: 'com001',
      preOrderDate: DateTime(2026, 8, 18),
      pickupLocation: 'Sunrise Supermarket Counter',
      status: OrderStatus.cancelled,
    ),
  ];

  static final List<NotificationItem> notifications = [
    NotificationItem(
      id: 'n001',
      message: 'Your Sunday pre-order is confirmed.',
      timestamp: DateTime(2026, 8, 27, 9, 0),
      isRead: false,
    ),
    NotificationItem(
      id: 'n002',
      message: 'Your order deadline is tonight.',
      timestamp: DateTime(2026, 8, 26, 18, 30),
      isRead: false,
    ),
    NotificationItem(
      id: 'n003',
      message: 'Your order is ready for pickup.',
      timestamp: DateTime(2026, 8, 25, 12, 15),
      isRead: true,
    ),
    NotificationItem(
      id: 'n004',
      message: 'Milk is currently unavailable.',
      timestamp: DateTime(2026, 8, 24, 8, 45),
      isRead: true,
    ),
  ];
}

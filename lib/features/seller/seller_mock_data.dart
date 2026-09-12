import 'package:shared_preferences/shared_preferences.dart';

import 'seller_models.dart';

/// Centralized mutable development data for the Seller Portal.
///
/// Seller trial/membership state is persisted locally so restarting
/// Martigo does not reset the 14-day trial.
class SellerDataStore {
  SellerDataStore._internal();

  static final SellerDataStore instance = SellerDataStore._internal();

  factory SellerDataStore() => instance;

  static const String _membershipStatusKey = 'martigo_seller_membership_status';

  static const String _trialUsedKey = 'martigo_seller_trial_used';

  static const String _trialStartKey = 'martigo_seller_trial_start';

  static const String _trialEndKey = 'martigo_seller_trial_end';

  static const String _nextBillingKey = 'martigo_seller_next_billing';

  bool trialUsed = false;

  Seller seller = Seller(
    businessName: 'Sunrise Supermarket',
    ownerName: 'Priya Nair',
    mobile: '9876500001',
    email: 'priya.nair@example.com',
    storeAddress: 'Shop 4, Sunrise Apartments, Chennai',
  );

  SellerMembership membership = SellerMembership(
    status: MembershipStatus.inactive,
    planName: 'Martigo Seller Membership',
    monthlyPrice: 1000,
    paymentMethod: 'Razorpay',
  );

  Future<void> loadMembership() async {
    final prefs = await SharedPreferences.getInstance();

    final savedStatus = prefs.getString(_membershipStatusKey);

    if (savedStatus != null) {
      membership.status = MembershipStatus.values.firstWhere(
        (status) => status.name == savedStatus,
        orElse: () => MembershipStatus.inactive,
      );
    }

    trialUsed = prefs.getBool(_trialUsedKey) ?? false;

    final trialStart = prefs.getString(_trialStartKey);

    final trialEnd = prefs.getString(_trialEndKey);

    final nextBilling = prefs.getString(_nextBillingKey);

    membership.trialStartDate = trialStart == null
        ? null
        : DateTime.tryParse(trialStart);

    membership.trialEndDate = trialEnd == null
        ? null
        : DateTime.tryParse(trialEnd);

    membership.nextBillingDate = nextBilling == null
        ? null
        : DateTime.tryParse(nextBilling);

    if (membership.isTrialExpired) {
      membership.status = MembershipStatus.inactive;

      await _saveMembership();
    }
  }

  Future<void> _saveMembership() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_membershipStatusKey, membership.status.name);

    await prefs.setBool(_trialUsedKey, trialUsed);

    final trialStart = membership.trialStartDate;

    if (trialStart == null) {
      await prefs.remove(_trialStartKey);
    } else {
      await prefs.setString(_trialStartKey, trialStart.toIso8601String());
    }

    final trialEnd = membership.trialEndDate;

    if (trialEnd == null) {
      await prefs.remove(_trialEndKey);
    } else {
      await prefs.setString(_trialEndKey, trialEnd.toIso8601String());
    }

    final nextBilling = membership.nextBillingDate;

    if (nextBilling == null) {
      await prefs.remove(_nextBillingKey);
    } else {
      await prefs.setString(_nextBillingKey, nextBilling.toIso8601String());
    }
  }

  Future<bool> startFreeTrial() async {
    await loadMembership();

    if (membership.isTrialActive) {
      return true;
    }

    if (trialUsed || membership.status == MembershipStatus.active) {
      return false;
    }

    final now = DateTime.now();

    membership.status = MembershipStatus.trial;

    membership.trialStartDate = now;

    membership.trialEndDate = now.add(const Duration(days: 14));

    membership.nextBillingDate = null;

    trialUsed = true;

    await _saveMembership();

    return true;
  }

  Future<void> activateMembership() async {
    await loadMembership();

    membership.status = MembershipStatus.active;

    membership.nextBillingDate = DateTime.now().add(const Duration(days: 30));

    await _saveMembership();
  }

  bool get hasPortalAccess {
    if (membership.status == MembershipStatus.active) {
      return true;
    }

    return membership.isTrialActive;
  }

  bool get trialExpired {
    final end = membership.trialEndDate;

    if (!trialUsed ||
        end == null ||
        membership.status == MembershipStatus.active) {
      return false;
    }

    return !DateTime.now().isBefore(end);
  }

  int get trialDaysRemaining {
    return membership.trialDaysRemaining;
  }

  final List<SellerProduct> products = [
    SellerProduct(
      id: 'sp001',
      name: 'Milk',
      category: 'Dairy',
      price: 30,
      unit: '1 L',
      stock: 42,
    ),
    SellerProduct(
      id: 'sp002',
      name: 'Bread',
      category: 'Bakery',
      price: 40,
      unit: '400 g',
      stock: 18,
    ),
    SellerProduct(
      id: 'sp003',
      name: 'Eggs',
      category: 'Dairy',
      price: 42,
      unit: '6 pcs',
      stock: 86,
    ),
    SellerProduct(
      id: 'sp004',
      name: 'Curd',
      category: 'Dairy',
      price: 35,
      unit: '500 g',
      stock: 25,
    ),
    SellerProduct(
      id: 'sp005',
      name: 'Rice',
      category: 'Groceries',
      price: 60,
      unit: '1 kg',
      stock: 50,
    ),
  ];

  final List<SellerProduct> canteenProducts = [
    SellerProduct(
      id: 'cf001',
      name: 'Idli',
      category: 'Breakfast',
      price: 20,
      unit: 'plate',
      stock: 40,
    ),
    SellerProduct(
      id: 'cf002',
      name: 'Dosa',
      category: 'Breakfast',
      price: 35,
      unit: 'plate',
      stock: 30,
    ),
    SellerProduct(
      id: 'cf003',
      name: 'Veg Meals',
      category: 'Lunch',
      price: 80,
      unit: 'plate',
      stock: 60,
    ),
    SellerProduct(
      id: 'cf004',
      name: 'Lemon Rice',
      category: 'Lunch',
      price: 50,
      unit: 'plate',
      stock: 35,
    ),
    SellerProduct(
      id: 'cf005',
      name: 'Samosa',
      category: 'Evening Snacks',
      price: 15,
      unit: 'piece',
      stock: 50,
    ),
    SellerProduct(
      id: 'cf006',
      name: 'Tea',
      category: 'Drinks',
      price: 12,
      unit: 'cup',
      stock: 70,
    ),
  ];

  List<SellerProduct> productsForMode(bool isCanteen) {
    return isCanteen ? canteenProducts : products;
  }

  List<SellerProduct> lowAvailabilityForMode(bool isCanteen) {
    return productsForMode(isCanteen)
        .where((product) => product.stock <= 20)
        .toList();
  }

  final List<SellerPreOrder> preOrders = [
    SellerPreOrder(
      id: 'MRT1024',
      customerLabel: 'Apartment Resident',
      pickupDate: DateTime.now(),
      pickupTime: '8:00 AM',
      items: const [
        SellerPreOrderItem(productName: 'Milk', quantity: 2),
        SellerPreOrderItem(productName: 'Bread', quantity: 1),
        SellerPreOrderItem(productName: 'Eggs', quantity: 6),
      ],
      total: 352,
      status: PreOrderStatus.received,
    ),
    SellerPreOrder(
      id: 'MRT1025',
      customerLabel: 'Apartment Resident',
      pickupDate: DateTime.now().add(const Duration(days: 1)),
      pickupTime: '9:00 AM',
      items: const [
        SellerPreOrderItem(productName: 'Curd', quantity: 2),
        SellerPreOrderItem(productName: 'Rice', quantity: 1),
      ],
      total: 130,
      status: PreOrderStatus.preparing,
    ),
    SellerPreOrder(
      id: 'MRT1010',
      customerLabel: 'Apartment Resident',
      pickupDate: DateTime.now().subtract(const Duration(days: 2)),
      pickupTime: '8:30 AM',
      items: const [SellerPreOrderItem(productName: 'Milk', quantity: 1)],
      total: 30,
      status: PreOrderStatus.completed,
    ),
  ];

  final Map<String, DemandSummary> demandByPeriod = {
    'tomorrow': const DemandSummary(
      dateLabel: 'Tomorrow • 03 September',
      entries: [
        DemandEntry(productName: 'Milk', quantity: 18),
        DemandEntry(productName: 'Bread', quantity: 12),
        DemandEntry(productName: 'Eggs', quantity: 30),
        DemandEntry(productName: 'Curd', quantity: 14),
        DemandEntry(productName: 'Rice', quantity: 8),
      ],
    ),
    'week': const DemandSummary(
      dateLabel: 'This Week • 03–09 Sep',
      entries: [
        DemandEntry(productName: 'Milk', quantity: 87),
        DemandEntry(productName: 'Bread', quantity: 43),
        DemandEntry(productName: 'Eggs', quantity: 210),
        DemandEntry(productName: 'Curd', quantity: 60),
        DemandEntry(productName: 'Rice', quantity: 35),
      ],
    ),
  };

  final List<SellerNotification> notifications = [
    SellerNotification(
      id: 'sn001',
      message: '18 customers pre-ordered Milk for tomorrow.',
      timestamp: DateTime(2026, 8, 29, 9, 0),
    ),
    SellerNotification(
      id: 'sn002',
      message: 'Low stock alert: Bread has only 18 units remaining.',
      timestamp: DateTime(2026, 8, 29, 8, 30),
    ),
    SellerNotification(
      id: 'sn003',
      message: 'New pre-order received.',
      timestamp: DateTime(2026, 8, 28, 18, 10),
    ),
    SellerNotification(
      id: 'sn004',
      message: 'Your Martigo membership payment was successful.',
      timestamp: DateTime(2026, 8, 1, 10, 0),
      isRead: true,
    ),
  ];

  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<SellerPreOrder> ordersForPeriod(String period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    switch (period) {
      case 'today':
        return preOrders
            .where((order) => _sameDate(order.pickupDate, today))
            .toList();

      case 'tomorrow':
        return preOrders
            .where((order) => _sameDate(order.pickupDate, tomorrow))
            .toList();

      case 'week':
        return preOrders.where((order) {
          return !order.pickupDate.isBefore(startOfWeek) &&
              order.pickupDate.isBefore(endOfWeek);
        }).toList();

      default:
        return List<SellerPreOrder>.from(preOrders);
    }
  }

  Map<String, int> aggregateDemand(Iterable<SellerPreOrder> orders) {
    final result = <String, int>{};

    for (final order in orders) {
      if (order.status == PreOrderStatus.completed) {
        continue;
      }

      for (final item in order.items) {
        result.update(
          item.productName,
          (quantity) => quantity + item.quantity,
          ifAbsent: () => item.quantity,
        );
      }
    }

    return result;
  }

  void updateOrderStatus(SellerPreOrder order, PreOrderStatus status) {
    order.status = status;
  }

  List<SellerProduct> get lowStockProducts =>
      products.where((p) => p.stock <= 20).toList();

  int get todaysOrdersCount => preOrders
      .where(
        (o) =>
            o.pickupDate.year == DateTime.now().year &&
            o.pickupDate.month == DateTime.now().month &&
            o.pickupDate.day == DateTime.now().day,
      )
      .length;
}

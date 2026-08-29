import 'admin_models.dart';

/// Centralized mock data for the admin experience: dashboard metrics,
/// subscription plans, subscriptions, and recent activity. No backend
/// or real billing is involved.
class AdminMockData {
  AdminMockData._();

  static const List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      id: 'plan_starter',
      name: 'Starter',
      monthlyPrice: 999,
      features: [
        'Small supermarket/canteen',
        'Basic demand dashboard',
        'Pre-order management',
      ],
    ),
    SubscriptionPlan(
      id: 'plan_standard',
      name: 'Standard',
      monthlyPrice: 2499,
      features: [
        'Demand analytics',
        'Stock/preparation management',
        'Community management',
      ],
    ),
    SubscriptionPlan(
      id: 'plan_premium',
      name: 'Premium',
      monthlyPrice: 4999,
      features: [
        'Advanced analytics',
        'Future forecasting features',
        'Additional seller tools',
      ],
    ),
  ];

  static List<Subscription> buildSubscriptions() {
    return [
      Subscription(
        id: 'sub001',
        businessName: 'Sunrise Supermarket',
        communityName: 'Sunrise Apartments',
        plan: plans[1],
        startDate: DateTime(2026, 3, 1),
        nextBillingDate: DateTime(2026, 9, 1),
        status: SubscriptionStatus.active,
        paymentStatus: PaymentStatus.paid,
      ),
      Subscription(
        id: 'sub002',
        businessName: 'ABC Campus Canteen',
        communityName: 'ABC Engineering College',
        plan: plans[0],
        startDate: DateTime(2026, 5, 15),
        nextBillingDate: DateTime(2026, 8, 30),
        status: SubscriptionStatus.paymentDue,
        paymentStatus: PaymentStatus.pending,
      ),
      Subscription(
        id: 'sub003',
        businessName: 'Lakeview Grocers',
        communityName: 'Lakeview Society',
        plan: plans[2],
        startDate: DateTime(2025, 11, 1),
        nextBillingDate: DateTime(2026, 8, 1),
        status: SubscriptionStatus.expired,
        paymentStatus: PaymentStatus.overdue,
      ),
      Subscription(
        id: 'sub004',
        businessName: 'Maple Heights Canteen',
        communityName: 'Maple Heights',
        plan: plans[1],
        startDate: DateTime(2026, 1, 10),
        nextBillingDate: DateTime(2026, 9, 10),
        status: SubscriptionStatus.cancelled,
        paymentStatus: PaymentStatus.overdue,
      ),
    ];
  }

  static const int totalCommunities = 12;
  static const int activeSellers = 9;
  static const int activeCustomers = 486;
  static const int totalPreOrders = 1320;

  static int activeSubscriptionsCount(List<Subscription> subs) =>
      subs.where((s) => s.status == SubscriptionStatus.active).length;

  static double monthlySubscriptionRevenue(List<Subscription> subs) {
    return subs
        .where((s) => s.status == SubscriptionStatus.active)
        .fold(0.0, (sum, s) => sum + s.plan.monthlyPrice);
  }

  static const List<DemandTrendPoint> weeklyDemandTrend = [
    DemandTrendPoint(label: 'Mon', value: 210),
    DemandTrendPoint(label: 'Tue', value: 240),
    DemandTrendPoint(label: 'Wed', value: 198),
    DemandTrendPoint(label: 'Thu', value: 260),
    DemandTrendPoint(label: 'Fri', value: 300),
    DemandTrendPoint(label: 'Sat', value: 340),
    DemandTrendPoint(label: 'Sun', value: 410),
  ];

  static final List<RecentActivityItem> recentActivity = [
    RecentActivityItem(
      title: 'New community joined',
      subtitle: 'Maple Heights registered with Martigo',
      timestamp: DateTime(2026, 8, 27, 10, 15),
    ),
    RecentActivityItem(
      title: 'Subscription payment received',
      subtitle: 'Sunrise Supermarket paid for Standard plan',
      timestamp: DateTime(2026, 8, 26, 16, 40),
    ),
    RecentActivityItem(
      title: 'New seller onboarded',
      subtitle: 'ABC Campus Canteen started using Martigo',
      timestamp: DateTime(2026, 8, 25, 9, 5),
    ),
    RecentActivityItem(
      title: 'Complaint raised',
      subtitle: 'Customer reported a delayed pickup',
      timestamp: DateTime(2026, 8, 24, 14, 20),
    ),
  ];
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_card.dart';
import 'admin_mock_data.dart';
import 'admin_models.dart';

/// "Dashboard" section of the admin experience: high-level metrics,
/// a simple weekly demand trend, and recent platform activity.
class AdminDashboardHomeScreen extends StatelessWidget {
  final List<Subscription> subscriptions;

  const AdminDashboardHomeScreen({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    final activeSubs = AdminMockData.activeSubscriptionsCount(subscriptions);
    final revenue = AdminMockData.monthlySubscriptionRevenue(subscriptions);

    final metrics = <_MetricData>[
      _MetricData(
        label: 'Total Communities',
        value: '${AdminMockData.totalCommunities}',
        icon: Icons.groups_outlined,
      ),
      _MetricData(
        label: 'Active Sellers',
        value: '${AdminMockData.activeSellers}',
        icon: Icons.storefront_outlined,
      ),
      _MetricData(
        label: 'Active Customers',
        value: '${AdminMockData.activeCustomers}',
        icon: Icons.people_outline,
      ),
      _MetricData(
        label: 'Total Pre-orders',
        value: '${AdminMockData.totalPreOrders}',
        icon: Icons.receipt_long_outlined,
      ),
      _MetricData(
        label: 'Active Subscriptions',
        value: '$activeSubs',
        icon: Icons.card_membership_outlined,
      ),
      _MetricData(
        label: 'Monthly Subscription Revenue',
        value: '₹${revenue.toStringAsFixed(0)}',
        icon: Icons.payments_outlined,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 600
                    ? 2
                    : 1;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.4,
              children: metrics.map((m) => _MetricCard(data: m)).toList(),
            );
          },
        ),
        const SizedBox(height: 24),
        Text('Weekly Demand Trend',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        AppCard(
          child: _DemandTrendBars(points: AdminMockData.weeklyDemandTrend),
        ),
        const SizedBox(height: 24),
        Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...AdminMockData.recentActivity.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Row(
                children: [
                  const Icon(Icons.circle_notifications_outlined,
                      color: AppColors.primaryMaroon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(item.subtitle,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final IconData icon;

  const _MetricData({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;

  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.softMaroon,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, color: AppColors.primaryMaroon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemandTrendBars extends StatelessWidget {
  final List<DemandTrendPoint> points;

  const _DemandTrendBars({required this.points});

  static const double _maxBarHeight = 90;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: points.map((point) {
          final barHeight =
              (_maxBarHeight * point.value / maxValue).clamp(6.0, _maxBarHeight);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${point.value}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primaryMaroon,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(point.label, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

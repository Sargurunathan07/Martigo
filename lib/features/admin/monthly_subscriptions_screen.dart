import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_card.dart';
import 'admin_mock_data.dart';
import 'admin_models.dart';
import 'subscription_detail_sheet.dart';

/// Admin page for managing subscriptions paid by supermarkets/canteens
/// using Martigo. Uses mock/local data only — no payment gateway or
/// real billing is integrated.
class MonthlySubscriptionsScreen extends StatelessWidget {
  final List<Subscription> subscriptions;
  final VoidCallback onChanged;

  const MonthlySubscriptionsScreen({
    super.key,
    required this.subscriptions,
    required this.onChanged,
  });

  int get _activeCount =>
      subscriptions.where((s) => s.status == SubscriptionStatus.active).length;

  int get _paymentsDueCount => subscriptions
      .where((s) => s.status == SubscriptionStatus.paymentDue)
      .length;

  int get _expiredCount =>
      subscriptions.where((s) => s.status == SubscriptionStatus.expired).length;

  double get _monthlyRevenue =>
      AdminMockData.monthlySubscriptionRevenue(subscriptions);

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _onAction(
    BuildContext context,
    String action,
    Subscription subscription,
  ) async {
    switch (action) {
      case 'view':
        await showSubscriptionDetailSheet(
          context: context,
          subscription: subscription,
          onChanged: onChanged,
        );
        break;
      case 'activate':
        subscription.status = SubscriptionStatus.active;
        subscription.paymentStatus = PaymentStatus.paid;
        onChanged();
        _showSnack(context, '${subscription.businessName} activated.');
        break;
      case 'renew':
        subscription.status = SubscriptionStatus.active;
        subscription.paymentStatus = PaymentStatus.paid;
        subscription.nextBillingDate = DateTime(
          subscription.nextBillingDate.year,
          subscription.nextBillingDate.month + 1,
          subscription.nextBillingDate.day,
        );
        onChanged();
        _showSnack(context, '${subscription.businessName} renewed.');
        break;
      case 'cancel':
        subscription.status = SubscriptionStatus.cancelled;
        onChanged();
        _showSnack(context, '${subscription.businessName} cancelled.');
        break;
      case 'change_plan':
        await showSubscriptionDetailSheet(
          context: context,
          subscription: subscription,
          onChanged: onChanged,
          initiallyEditingPlan: true,
        );
        break;
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 900
                ? 4
                : constraints.maxWidth >= 600
                    ? 2
                    : 1;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _SummaryCard(
                  label: 'Total Active Subscriptions',
                  value: '$_activeCount',
                  icon: Icons.check_circle_outline,
                ),
                _SummaryCard(
                  label: 'Payments Due',
                  value: '$_paymentsDueCount',
                  icon: Icons.error_outline,
                ),
                _SummaryCard(
                  label: 'Expired Subscriptions',
                  value: '$_expiredCount',
                  icon: Icons.history_toggle_off,
                ),
                _SummaryCard(
                  label: 'Monthly Revenue',
                  value: '₹${_monthlyRevenue.toStringAsFixed(0)}',
                  icon: Icons.payments_outlined,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Text('Subscriptions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ...subscriptions.map(
          (subscription) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subscription.businessName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              subscription.communityName,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (action) =>
                            _onAction(context, action, subscription),
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                              value: 'view', child: Text('View subscription')),
                          PopupMenuItem(
                              value: 'activate',
                              child: Text('Activate subscription')),
                          PopupMenuItem(
                              value: 'renew',
                              child: Text('Renew subscription')),
                          PopupMenuItem(
                              value: 'change_plan',
                              child: Text('Change plan')),
                          PopupMenuItem(
                              value: 'cancel',
                              child: Text('Cancel subscription')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusChip(
                        label: subscription.status.label,
                        icon: subscription.status.icon,
                        color: subscription.status.color,
                      ),
                      _StatusChip(
                        label: 'Payment: ${subscription.paymentStatus.label}',
                        icon: subscription.paymentStatus.icon,
                        color: subscription.paymentStatus.color,
                      ),
                      _StatusChip(
                        label: subscription.plan.name,
                        icon: Icons.card_membership_outlined,
                        color: AppColors.primaryMaroon,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${subscription.plan.monthlyPrice.toStringAsFixed(0)} / month',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Next billing: ${_formatDate(subscription.nextBillingDate)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softMaroon,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.primaryMaroon, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  label,
                  maxLines: 2,
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

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

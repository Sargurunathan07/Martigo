import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class SellerSubscriptionScreen extends StatefulWidget {
  const SellerSubscriptionScreen({super.key});

  @override
  State<SellerSubscriptionScreen> createState() =>
      _SellerSubscriptionScreenState();
}

class _SellerSubscriptionScreenState extends State<SellerSubscriptionScreen> {
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _onCancelPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Are you sure you want to cancel your Martigo Seller Membership?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Subscription'),
          ),
          TextButton(
            onPressed: () {
              setState(
                () => SellerDataStore.instance.membership.status =
                    MembershipStatus.inactive,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final membership = SellerDataStore.instance.membership;
    final textTheme = Theme.of(context).textTheme;
    final isActive = membership.status == MembershipStatus.active;

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: ResponsiveMobileContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(membership.planName, style: textTheme.titleMedium),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: (isActive ? Colors.green : Colors.grey)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isActive ? 'ACTIVE' : 'INACTIVE',
                          style: textTheme.bodySmall?.copyWith(
                            color: isActive ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${membership.monthlyPrice.toStringAsFixed(0)} / month',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 28),
                  _Row(
                    label: 'Next billing date',
                    value: _formatDate(membership.nextBillingDate),
                  ),
                  const SizedBox(height: 10),
                  _Row(
                    label: 'Payment Method',
                    value: membership.paymentMethod,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _MenuTile(
              icon: Icons.receipt_long_outlined,
              label: 'Payment History',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.settings_outlined,
              label: 'Manage Subscription',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.description_outlined,
              label: 'Billing Details',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.cancel_outlined,
              label: 'Cancel Subscription',
              iconColor: Colors.redAccent,
              labelColor: Colors.redAccent,
              onTap: _onCancelPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? AppColors.primaryMaroon),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: labelColor),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}

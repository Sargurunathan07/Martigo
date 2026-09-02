import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../seller_mock_data.dart';
import 'seller_subscription_screen.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final seller = SellerDataStore.instance.seller;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ResponsiveMobileContainer(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.softMaroon,
                    child: Text(
                      seller.businessName.isNotEmpty
                          ? seller.businessName[0].toUpperCase()
                          : '?',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryMaroon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(seller.businessName, style: textTheme.titleLarge),
                        Text(seller.ownerName, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _InfoTile(
                icon: Icons.phone_outlined,
                label: 'Mobile',
                value: seller.mobile,
              ),
              _InfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: seller.email,
              ),
              _InfoTile(
                icon: Icons.location_on_outlined,
                label: 'Store Address',
                value: seller.storeAddress,
              ),
              const Divider(height: 32),
              _MenuTile(
                icon: Icons.store_outlined,
                label: 'Business Details',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.card_membership_outlined,
                label: 'Subscription',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SellerSubscriptionScreen(),
                  ),
                ),
              ),
              _MenuTile(
                icon: Icons.receipt_long_outlined,
                label: 'Payment History',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.notifications_none_outlined,
                label: 'Notifications',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.help_outline,
                label: 'Help & Support',
                onTap: () {},
              ),
              const Divider(height: 32),
              _MenuTile(
                icon: Icons.logout,
                label: 'Logout',
                iconColor: Colors.redAccent,
                labelColor: Colors.redAccent,
                onTap: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryMaroon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
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

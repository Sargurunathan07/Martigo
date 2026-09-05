import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import 'customer_mock_data.dart';

/// Customer Profile tab.
/// Logout is available only for the Customer section.
/// Admin and Seller logout are handled separately.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _onLogoutPressed(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout?', textAlign: TextAlign.center),
          content: const Text(
            'Are you sure you want to logout\n'
            'from your Martigo account?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryMaroon,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) {
      return;
    }

    // Mock/local authentication for now.
    // Real customer session/token clearing can be added here later.

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.roleSelection, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = CustomerMockData.currentUser;
    final community = CustomerMockData.currentCommunity;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.softMaroon,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
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
                      Text(user.name, style: textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(community.name, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _ProfileMenuTile(
              icon: Icons.receipt_long_outlined,
              label: 'My Orders',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.myOrders);
              },
            ),

            _ProfileMenuTile(
              icon: Icons.groups_outlined,
              label: 'My Community',
              onTap: () {},
            ),

            _ProfileMenuTile(
              icon: Icons.bookmark_border,
              label: 'Saved Details',
              onTap: () {},
            ),

            _ProfileMenuTile(
              icon: Icons.notifications_none_outlined,
              label: 'Notifications',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.notifications);
              },
            ),

            _ProfileMenuTile(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () {},
            ),

            const Divider(height: 32),

            _ProfileMenuTile(
              icon: Icons.logout_rounded,
              label: 'Logout',
              iconColor: AppColors.primaryMaroon,
              labelColor: AppColors.primaryMaroon,
              onTap: () => _onLogoutPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _ProfileMenuTile({
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

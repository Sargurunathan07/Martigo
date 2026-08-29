import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import 'customer_mock_data.dart';

/// Profile tab. Shows the current mock user, their community, and a
/// menu of account-related actions.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _onLogoutPressed(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
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
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.myOrders),
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
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.notifications),
            ),
            _ProfileMenuTile(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () {},
            ),
            const Divider(height: 32),
            _ProfileMenuTile(
              icon: Icons.logout,
              label: 'Logout',
              iconColor: Colors.redAccent,
              labelColor: Colors.redAccent,
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
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: labelColor,
            ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
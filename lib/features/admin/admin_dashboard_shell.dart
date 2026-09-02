import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'admin_mock_data.dart';
import 'admin_models.dart';
import 'admin_dashboard_home_screen.dart';
import 'admin_communities_screen.dart';
import 'admin_sellers_screen.dart';
import 'admin_users_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_analytics_screen.dart';
import 'admin_complaints_screen.dart';
import 'monthly_subscriptions_screen.dart';
import 'admin_settings_screen.dart';

enum _AdminSection {
  dashboard,
  communities,
  sellers,
  users,
  orders,
  analytics,
  complaints,
  subscriptions,
  settings,
}

extension _AdminSectionX on _AdminSection {
  String get label {
    switch (this) {
      case _AdminSection.dashboard:
        return 'Dashboard';
      case _AdminSection.communities:
        return 'Communities';
      case _AdminSection.sellers:
        return 'Sellers';
      case _AdminSection.users:
        return 'Users';
      case _AdminSection.orders:
        return 'Orders';
      case _AdminSection.analytics:
        return 'Analytics';
      case _AdminSection.complaints:
        return 'Complaints';
      case _AdminSection.subscriptions:
        return 'Monthly Subscriptions';
      case _AdminSection.settings:
        return 'Settings';
    }
  }

  IconData get icon {
    switch (this) {
      case _AdminSection.dashboard:
        return Icons.dashboard_outlined;
      case _AdminSection.communities:
        return Icons.groups_outlined;
      case _AdminSection.sellers:
        return Icons.storefront_outlined;
      case _AdminSection.users:
        return Icons.people_outline;
      case _AdminSection.orders:
        return Icons.receipt_long_outlined;
      case _AdminSection.analytics:
        return Icons.insights_outlined;
      case _AdminSection.complaints:
        return Icons.report_gmailerrorred_outlined;
      case _AdminSection.subscriptions:
        return Icons.card_membership_outlined;
      case _AdminSection.settings:
        return Icons.settings_outlined;
    }
  }
}

/// Root shell for the Martigo Admin experience. Hosts all admin
/// sections behind a responsive navigation surface: a [NavigationRail]
/// on wide (tablet/web) layouts and a [Drawer] on narrow (mobile)
/// layouts.
class AdminDashboardShell extends StatefulWidget {
  const AdminDashboardShell({super.key});

  @override
  State<AdminDashboardShell> createState() => _AdminDashboardShellState();
}

class _AdminDashboardShellState extends State<AdminDashboardShell> {
  _AdminSection _selected = _AdminSection.dashboard;
  late final List<Subscription> _subscriptions =
      AdminMockData.buildSubscriptions();

  static const double _wideBreakpoint = 800;

  void _onSubscriptionsChanged() => setState(() {});

  Widget _buildSection(_AdminSection section) {
    switch (section) {
      case _AdminSection.dashboard:
        return AdminDashboardHomeScreen(subscriptions: _subscriptions);
      case _AdminSection.communities:
        return const AdminCommunitiesScreen();
      case _AdminSection.sellers:
        return const AdminSellersScreen();
      case _AdminSection.users:
        return const AdminUsersScreen();
      case _AdminSection.orders:
        return const AdminOrdersScreen();
      case _AdminSection.analytics:
        return const AdminAnalyticsScreen();
      case _AdminSection.complaints:
        return const AdminComplaintsScreen();
      case _AdminSection.subscriptions:
        return MonthlySubscriptionsScreen(
          subscriptions: _subscriptions,
          onChanged: _onSubscriptionsChanged,
        );
      case _AdminSection.settings:
        return const AdminSettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideBreakpoint;

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _AdminSection.values.indexOf(_selected),
                  onDestinationSelected: (index) {
                    setState(() => _selected = _AdminSection.values[index]);
                  },
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: AppColors.cream,
                  selectedIconTheme: const IconThemeData(
                    color: AppColors.primaryMaroon,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.primaryMaroon,
                    fontWeight: FontWeight.w600,
                  ),
                  destinations: _AdminSection.values
                      .map(
                        (section) => NavigationRailDestination(
                          icon: Icon(section.icon),
                          label: Text(section.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(title: Text(_selected.label)),
                    body: _buildSection(_selected),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(_selected.label)),
          drawer: Drawer(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: AppColors.primaryMaroon),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Martigo Admin',
                        style: TextStyle(
                          color: AppColors.cream,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  ..._AdminSection.values.map(
                    (section) => ListTile(
                      leading: Icon(section.icon),
                      title: Text(section.label),
                      selected: section == _selected,
                      selectedColor: AppColors.primaryMaroon,
                      onTap: () {
                        setState(() => _selected = section);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: _buildSection(_selected),
        );
      },
    );
  }
}

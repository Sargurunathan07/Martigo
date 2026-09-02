import 'package:flutter/material.dart';

import '../../widgets/app_card.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.notifications_none_outlined),
            title: const Text('Platform Notifications'),
            subtitle: const Text('Manage system-wide notification settings'),
          ),
        ),
        const SizedBox(height: 10),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.security_outlined),
            title: const Text('Admin Access'),
            subtitle: const Text('Manage admin roles and permissions'),
          ),
        ),
        const SizedBox(height: 10),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('About Martigo'),
            subtitle: const Text('App version and platform information'),
          ),
        ),
      ],
    );
  }
}

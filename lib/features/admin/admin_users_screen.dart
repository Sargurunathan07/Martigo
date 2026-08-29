import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  static const List<Map<String, String>> _users = [
    {'name': 'Aarav Sharma', 'role': 'Customer', 'community': 'Sunrise Apartments'},
    {'name': 'Priya Nair', 'role': 'Seller', 'community': 'Sunrise Apartments'},
    {'name': 'Ravi Kumar', 'role': 'Admin', 'community': '-'},
    {'name': 'Divya Menon', 'role': 'Customer', 'community': 'ABC Engineering College'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final user = _users[index];
        return AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_outline),
            title: Text(user['name']!),
            subtitle: Text('${user['role']} · ${user['community']}'),
          ),
        );
      },
    );
  }
}

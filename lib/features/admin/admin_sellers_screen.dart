import 'package:flutter/material.dart';

import '../../widgets/app_card.dart';

class AdminSellersScreen extends StatelessWidget {
  const AdminSellersScreen({super.key});

  static const List<Map<String, String>> _sellers = [
    {
      'name': 'Sunrise Supermarket',
      'community': 'Sunrise Apartments',
      'type': 'Supermarket',
    },
    {
      'name': 'ABC Campus Canteen',
      'community': 'ABC Engineering College',
      'type': 'Canteen',
    },
    {
      'name': 'Lakeview Grocers',
      'community': 'Lakeview Society',
      'type': 'Supermarket',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _sellers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final seller = _sellers[index];
        return AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.storefront_outlined),
            title: Text(seller['name']!),
            subtitle: Text('${seller['community']} · ${seller['type']}'),
          ),
        );
      },
    );
  }
}

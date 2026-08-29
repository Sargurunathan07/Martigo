import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  static const List<Map<String, String>> _orders = [
    {'id': 'o001', 'business': 'Sunrise Supermarket', 'status': 'Confirmed', 'total': '₹165'},
    {'id': 'o002', 'business': 'ABC Campus Canteen', 'status': 'Pending', 'total': '₹250'},
    {'id': 'o003', 'business': 'Lakeview Grocers', 'status': 'Completed', 'total': '₹120'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = _orders[index];
        return AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text('Order #${order['id']} · ${order['business']}'),
            subtitle: Text('Status: ${order['status']}'),
            trailing: Text(order['total']!),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';

class AdminComplaintsScreen extends StatelessWidget {
  const AdminComplaintsScreen({super.key});

  static const List<Map<String, String>> _complaints = [
    {'title': 'Delayed pickup', 'community': 'Sunrise Apartments', 'status': 'Open'},
    {'title': 'Wrong item delivered', 'community': 'ABC Engineering College', 'status': 'Resolved'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _complaints.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final complaint = _complaints[index];
        return AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.report_gmailerrorred_outlined),
            title: Text(complaint['title']!),
            subtitle: Text(complaint['community']!),
            trailing: Text(complaint['status']!),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'admin_create_community_screen.dart';
import '../../widgets/app_card.dart';

class AdminCommunitiesScreen extends StatelessWidget {
  const AdminCommunitiesScreen({super.key});

  static const List<Map<String, String>> _communities = [
    {
      'name': 'Sunrise Apartments',
      'type': 'Apartment',
      'business': 'Sunrise Supermarket',
    },
    {
      'name': 'ABC Engineering College',
      'type': 'College',
      'business': 'ABC Campus Canteen',
    },
    {
      'name': 'Lakeview Society',
      'type': 'Apartment',
      'business': 'Lakeview Grocers',
    },
    {
      'name': 'Maple Heights',
      'type': 'Apartment',
      'business': 'Maple Heights Canteen',
    },
  ];

  void _openCreateCommunity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminCreateCommunityScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Communities',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF292323),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manage apartments, colleges and their connected businesses.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _openCreateCommunity(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Community'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800020),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        ..._communities.map(
          (community) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E1E5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    community['type'] == 'College'
                        ? Icons.school_outlined
                        : Icons.apartment_outlined,
                    color: const Color(0xFF800020),
                  ),
                ),
                title: Text(
                  community['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${community['type']} • ${community['business']}',
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF800020),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

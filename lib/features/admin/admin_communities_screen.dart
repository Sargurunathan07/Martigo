import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/community.dart';
import '../../widgets/app_card.dart';
import '../community/community_registry.dart';

class AdminCommunitiesScreen extends StatefulWidget {
  const AdminCommunitiesScreen({super.key});

  @override
  State<AdminCommunitiesScreen> createState() => _AdminCommunitiesScreenState();
}

class _AdminCommunitiesScreenState extends State<AdminCommunitiesScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await CommunityRegistry.instance.load();

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final communities = CommunityRegistry.instance.communities;

    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryMaroon),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Communities',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        const Text(
          'Communities are created and managed by sellers.',
          style: TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 22),

        ...communities.map(
          (community) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.softMaroon,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    community.type == CommunityType.college
                        ? Icons.school_outlined
                        : Icons.apartment_outlined,
                    color: AppColors.primaryMaroon,
                  ),
                ),
                title: Text(
                  community.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${community.businessName ?? ''}\nCode: ${community.code}',
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

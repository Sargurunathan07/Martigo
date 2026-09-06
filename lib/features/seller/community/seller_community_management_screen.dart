import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/community.dart';
import '../../../widgets/app_card.dart';
import '../../community/community_registry.dart';
import '../seller_mock_data.dart';

class SellerCommunityManagementScreen extends StatefulWidget {
  const SellerCommunityManagementScreen({super.key});

  @override
  State<SellerCommunityManagementScreen> createState() =>
      _SellerCommunityManagementScreenState();
}

class _SellerCommunityManagementScreenState
    extends State<SellerCommunityManagementScreen> {
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

  Future<void> _create() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SellerCreateCommunityScreen()),
    );

    if (created == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final communities = CommunityRegistry.instance.communities;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Communities'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        backgroundColor: AppColors.primaryMaroon,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Community'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryMaroon),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Create a community and share its code with customers.',
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 20),

                if (communities.isEmpty)
                  const AppCard(
                    child: Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        'No communities yet.\nCreate one to start your demo.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...communities.map(
                    (community) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              community.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(community.businessName ?? ''),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    community.code,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryMaroon,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: community.code),
                                    );
                                  },
                                  icon: const Icon(Icons.copy_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 80),
              ],
            ),
    );
  }
}

class SellerCreateCommunityScreen extends StatefulWidget {
  const SellerCreateCommunityScreen({super.key});

  @override
  State<SellerCreateCommunityScreen> createState() =>
      _SellerCreateCommunityScreenState();
}

class _SellerCreateCommunityScreenState
    extends State<SellerCreateCommunityScreen> {
  final formKey = GlobalKey<FormState>();

  final communityController = TextEditingController();

  late final TextEditingController businessController;

  CommunityType type = CommunityType.apartment;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    businessController = TextEditingController(
      text: SellerDataStore.instance.seller.businessName,
    );
  }

  @override
  void dispose() {
    communityController.dispose();
    businessController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      saving = true;
    });

    final community = await CommunityRegistry.instance.createCommunity(
      communityName: communityController.text,
      businessName: businessController.text,
      type: type,
    );

    if (!mounted) return;

    setState(() {
      saving = false;
    });

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Community Created'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(community.name),
              const SizedBox(height: 14),
              const Text('Share this code with customers:'),
              const SizedBox(height: 8),
              SelectableText(
                community.code,
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.primaryMaroon,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Create Community'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  DropdownButtonFormField<CommunityType>(
                    initialValue: type,
                    decoration: const InputDecoration(
                      labelText: 'Community Type',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: CommunityType.apartment,
                        child: Text('Apartment / Supermarket'),
                      ),
                      DropdownMenuItem(
                        value: CommunityType.college,
                        child: Text('College / Canteen'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        type = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: communityController,
                    decoration: const InputDecoration(
                      labelText: 'Community Name',
                      hintText: 'Sunrise Apartments',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter community name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: businessController,
                    decoration: const InputDecoration(
                      labelText: 'Business / Store Name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter business name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  FilledButton(
                    onPressed: saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryMaroon,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    child: const Text('Create Community'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

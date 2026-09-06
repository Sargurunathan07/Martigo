import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/community.dart';
import '../../../widgets/app_card.dart';
import '../../community/community_registry.dart';
import '../seller_mock_data.dart';
import 'seller_community_session.dart';

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

    await SellerCommunitySession.instance.load();

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> _selectCommunity(Community community) async {
    await SellerCommunitySession.instance.setActiveCommunity(community);

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${community.name} is now active')));
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

    final active = SellerCommunitySession.instance.current;

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
        icon: const Icon(Icons.add),
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
                  'Create communities and choose which one you are currently managing.',
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 20),

                if (communities.isEmpty)
                  const AppCard(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No communities yet.\nCreate one to start.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...communities.map((community) {
                    final isActive = active?.code == community.code;

                    final isCanteen =
                        community.businessType == BusinessType.canteen;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCanteen
                                      ? Icons.restaurant
                                      : Icons.storefront,
                                  color: AppColors.primaryMaroon,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    community.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isActive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.softMaroon,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'ACTIVE',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primaryMaroon,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(community.businessName ?? ''),

                            Text(
                              isCanteen
                                  ? 'College / Canteen'
                                  : 'Apartment / Supermarket',
                              style: const TextStyle(color: Colors.black54),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Code: ${community.code}',
                                    style: const TextStyle(
                                      color: AppColors.primaryMaroon,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Copy code',
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: community.code),
                                    );
                                  },
                                  icon: const Icon(Icons.copy_rounded),
                                ),
                              ],
                            ),

                            if (!isActive) ...[
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    _selectCommunity(community);
                                  },
                                  child: const Text('Manage This Community'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),

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

    await SellerCommunitySession.instance.setActiveCommunity(community);

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
              Icon(
                type == CommunityType.college
                    ? Icons.restaurant
                    : Icons.storefront,
                size: 46,
                color: AppColors.primaryMaroon,
              ),
              const SizedBox(height: 12),
              Text(
                community.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
              const SizedBox(height: 12),
              Text(
                type == CommunityType.college
                    ? 'Canteen mode is now active.'
                    : 'Supermarket mode is now active.',
                style: const TextStyle(color: Colors.black54),
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
    final isCollege = type == CommunityType.college;

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
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        type = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: communityController,
                    decoration: InputDecoration(
                      labelText: 'Community Name',
                      hintText: isCollege
                          ? 'ABC Engineering College'
                          : 'Sunrise Apartments',
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
                    decoration: InputDecoration(
                      labelText: isCollege
                          ? 'Canteen Name'
                          : 'Supermarket Name',
                      hintText: isCollege
                          ? 'ABC College Canteen'
                          : 'Sunrise Supermarket',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return isCollege
                            ? 'Enter canteen name'
                            : 'Enter supermarket name';
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
                    child: saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create Community'),
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

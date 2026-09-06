import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../customer/customer_cart_store.dart';
import '../customer/customer_session.dart';
import 'community_registry.dart';

class JoinCommunityScreen extends StatefulWidget {
  const JoinCommunityScreen({super.key});

  @override
  State<JoinCommunityScreen> createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    await CommunityRegistry.instance.load();

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> _logout() async {
    CustomerCartStore.instance.clear();

    await CustomerSession.instance.clearCommunity();

    if (!mounted) return;

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.roleSelection, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryMaroon),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Navigator.of(context).canPop() ? const BackButton() : null,
        title: const Text('Choose Community'),
        centerTitle: true,
        actions: [TextButton(onPressed: _logout, child: const Text('Logout'))],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 10),

                Text(
                  'Where would you like to order?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Use the same Martigo account for your apartment and college.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 32),

                _ChoiceCard(
                  icon: Icons.apartment_rounded,
                  title: 'Apartment / Supermarket',
                  description: 'Order groceries and daily essentials.',
                  button: 'Choose Apartment',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.joinSupermarket);
                  },
                ),

                const SizedBox(height: 20),

                _ChoiceCard(
                  icon: Icons.school_rounded,
                  title: 'College / Canteen',
                  description: 'Pre-order meals, snacks and drinks.',
                  button: 'Choose College',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.joinCollege);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String button;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.button,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.softMaroon),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.softMaroon,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 38, color: AppColors.primaryMaroon),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryMaroon,
                foregroundColor: Colors.white,
              ),
              child: Text(button),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/community.dart';
import '../../../widgets/app_card.dart';
import '../seller_mock_data.dart';
import 'seller_trial_banner.dart';
import 'seller_products_home_section.dart';

class SellerDynamicHomeScreen extends StatefulWidget {
  final Community? community;
  final bool isCanteen;

  const SellerDynamicHomeScreen({
    super.key,
    required this.community,
    required this.isCanteen,
  });

  @override
  State<SellerDynamicHomeScreen> createState() =>
      _SellerDynamicHomeScreenState();
}

class _SellerDynamicHomeScreenState extends State<SellerDynamicHomeScreen> {
  void _refreshHome() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = SellerDataStore.instance;

    final items = store.productsForMode(widget.isCanteen);

    final low = store.lowAvailabilityForMode(widget.isCanteen);

    final businessName =
        widget.community?.businessName ?? store.seller.businessName;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Martigo',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.deepMaroon,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(businessName, style: const TextStyle(color: Colors.black54)),

            const SizedBox(height: 16),

            const SellerTrialBanner(),

            if (store.membership.isTrialActive) const SizedBox(height: 16),

            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.softMaroon,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.isCanteen ? Icons.restaurant : Icons.storefront,
                      color: AppColors.primaryMaroon,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isCanteen
                              ? 'Canteen Mode'
                              : 'Supermarket Mode',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          widget.community == null
                              ? 'Create or select a community from Profile → Communities.'
                              : widget.community!.name,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: widget.isCanteen
                        ? Icons.restaurant_menu
                        : Icons.inventory_2_outlined,
                    value: '${items.length}',
                    label: widget.isCanteen ? 'Menu Items' : 'Products',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _MetricCard(
                    icon: Icons.event_note_outlined,
                    value: '${store.todaysOrdersCount}',
                    label: 'Today',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _MetricCard(
                    icon: Icons.warning_amber_rounded,
                    value: '${low.length}',
                    label: widget.isCanteen ? 'Low Qty' : 'Low Stock',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            SellerProductsHomeSection(
              key: ValueKey(widget.isCanteen),
              isCanteen: widget.isCanteen,
              onChanged: _refreshHome,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryMaroon),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

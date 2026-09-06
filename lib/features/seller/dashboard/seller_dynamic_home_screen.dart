import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/community.dart';
import '../../../widgets/app_card.dart';
import '../seller_mock_data.dart';

class SellerDynamicHomeScreen extends StatelessWidget {
  final Community? community;
  final bool isCanteen;

  const SellerDynamicHomeScreen({
    super.key,
    required this.community,
    required this.isCanteen,
  });

  @override
  Widget build(BuildContext context) {
    final store = SellerDataStore.instance;

    final items = store.productsForMode(isCanteen);

    final low = store.lowAvailabilityForMode(isCanteen);

    final businessName = community?.businessName ?? store.seller.businessName;

    return Scaffold(
      backgroundColor: AppColors.background,
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

            const SizedBox(height: 20),

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
                      isCanteen ? Icons.restaurant : Icons.storefront,
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
                          isCanteen ? 'Canteen Mode' : 'Supermarket Mode',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          community == null
                              ? 'Create or select a community from Profile → Communities.'
                              : community!.name,
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
                    icon: isCanteen
                        ? Icons.restaurant_menu
                        : Icons.inventory_2_outlined,
                    value: '${items.length}',
                    label: isCanteen ? 'Menu Items' : 'Products',
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
                    label: isCanteen ? 'Low Qty' : 'Low Stock',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            Text(
              isCanteen ? 'Today\'s Menu' : 'Product Overview',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...items
                .take(5)
                .map(
                  (product) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                          Icon(
                            isCanteen
                                ? Icons.restaurant_outlined
                                : Icons.inventory_2_outlined,
                            color: AppColors.primaryMaroon,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  product.category,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            isCanteen
                                ? '${product.stock} available'
                                : '${product.stock} in stock',
                            style: const TextStyle(
                              color: AppColors.primaryMaroon,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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

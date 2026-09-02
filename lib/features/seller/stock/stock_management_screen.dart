import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../seller_mock_data.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  static const int _lowStockThreshold = 20;

  void _adjustStock(int index, int delta) {
    setState(() {
      final product = SellerDataStore.instance.products[index];
      final newStock = product.stock + delta;
      product.stock = newStock < 0 ? 0 : newStock;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = SellerDataStore.instance.products;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Management')),
      body: ResponsiveMobileContainer(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: products.length,
          separatorBuilder: (context, i) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final product = products[i];
            final isLow = product.stock <= _lowStockThreshold;

            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name, style: textTheme.titleMedium),
                      if (isLow)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'LOW STOCK',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLow
                        ? 'Only ${product.stock} remaining'
                        : '${product.stock} available',
                    style: textTheme.bodySmall?.copyWith(
                      color: isLow ? Colors.orange : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _adjustStock(i, -1),
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primaryMaroon,
                      ),
                      Text('${product.stock}', style: textTheme.titleMedium),
                      IconButton(
                        onPressed: () => _adjustStock(i, 1),
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primaryMaroon,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} stock updated.'),
                            ),
                          );
                        },
                        child: const Text('Update Stock'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

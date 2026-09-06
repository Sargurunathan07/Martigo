import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class ConnectedSellerStockPage extends StatefulWidget {
  final bool isCanteen;

  const ConnectedSellerStockPage({super.key, this.isCanteen = false});

  @override
  State<ConnectedSellerStockPage> createState() =>
      _ConnectedSellerStockPageState();
}

class _ConnectedSellerStockPageState extends State<ConnectedSellerStockPage> {
  final store = SellerDataStore.instance;

  void _increase(SellerProduct product) {
    setState(() {
      product.stock++;
    });
  }

  void _decrease(SellerProduct product) {
    if (product.stock <= 0) {
      return;
    }

    setState(() {
      product.stock--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = store.productsForMode(widget.isCanteen);

    final low = store.lowAvailabilityForMode(widget.isCanteen);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.isCanteen ? 'Menu Availability' : 'Stock Management',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              widget.isCanteen
                  ? 'Update how many portions are available for each menu item.'
                  : 'Update stock levels for all your products.',
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            AppCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.primaryMaroon,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.isCanteen
                          ? '${low.length} menu item(s) have low availability.'
                          : '${low.length} product(s) currently have low stock.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            ...products.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: product.stock <= 20
                              ? AppColors.softMaroon
                              : AppColors.cream,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          widget.isCanteen
                              ? Icons.restaurant_menu
                              : Icons.inventory_2_outlined,
                          color: AppColors.primaryMaroon,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 3),
                            Text('${product.category} • ${product.unit}'),
                            const SizedBox(height: 4),
                            Text(
                              widget.isCanteen
                                  ? product.stock <= 20
                                        ? 'LOW AVAILABILITY'
                                        : 'Available'
                                  : product.stock <= 20
                                  ? 'LOW STOCK'
                                  : 'In Stock',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryMaroon,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          _decrease(product);
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),

                      SizedBox(
                        width: 38,
                        child: Text(
                          '${product.stock}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          _increase(product);
                        },
                        icon: const Icon(Icons.add_circle_outline),
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

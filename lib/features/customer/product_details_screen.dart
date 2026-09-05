import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/product.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import 'customer_cart_store.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(child: Text('Product information is unavailable.')),
      );
    }

    final available = product.availability == ProductAvailability.available;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.softMaroon,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppColors.primaryMaroon,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Text(
                  '₹${product.price.toStringAsFixed(2)} / ${product.unit}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryMaroon,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primaryMaroon,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          available
                              ? '${product.stock} available for pre-order'
                              : 'Currently unavailable',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Add to Cart',
                  icon: Icons.add_shopping_cart,
                  onPressed: available
                      ? () {
                          CustomerCartStore.instance.addProduct(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                            ),
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

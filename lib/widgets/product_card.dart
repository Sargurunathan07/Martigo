import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/product.dart';
import 'app_button.dart';

/// Reusable product card for browsing/pre-ordering screens.
///
/// Martigo is a demand-planning app, not an instant-delivery app, so
/// this card intentionally uses "Add to Pre-order" wording rather than
/// "Add to cart" / "Buy now" / "Order now".
class ProductCard extends StatelessWidget {
  final Product product;

  /// Called when the customer taps the pre-order action. Null (or
  /// unavailable product) disables the button.
  final VoidCallback? onAddToPreOrder;

  /// Called when the card itself is tapped (e.g. to view product details).
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddToPreOrder,
    this.onTap,
  });

  bool get _isAvailable => product.availability == ProductAvailability.available;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(2)}',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryMaroon,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/ ${product.unit}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildAvailabilityBadge(context),
                  const SizedBox(height: 10),
                  AppButton(
                    label: _isAvailable ? 'Add to Pre-order' : 'Unavailable',
                    onPressed: _isAvailable ? onAddToPreOrder : null,
                    minHeight: 42,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: product.image != null && product.image!.isNotEmpty
          ? Image.network(
              product.image!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
            )
          : _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.softMaroon,
      alignment: Alignment.center,
      child: const Icon(
        Icons.shopping_bag_outlined,
        size: 36,
        color: AppColors.primaryMaroon,
      ),
    );
  }

  Widget _buildAvailabilityBadge(BuildContext context) {
    late final String label;
    late final Color color;

    switch (product.availability) {
      case ProductAvailability.available:
        label = 'Available';
        color = Colors.green;
        break;
      case ProductAvailability.outOfStock:
        label = 'Out of stock';
        color = Colors.redAccent;
        break;
      case ProductAvailability.comingSoon:
        label = 'Coming soon';
        color = Colors.orange;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../models/order.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import 'customer_cart_store.dart';
import 'customer_mock_data.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  bool _submitting = false;

  Future<void> _confirmOrder() async {
    final store = CustomerCartStore.instance;

    if (store.isEmpty || store.pickupDate == null || store.pickupSlot == null) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final community = CustomerMockData.currentCommunity;

    final order = Order(
      id: 'M${DateTime.now().millisecondsSinceEpoch}',
      customerId: CustomerMockData.currentUser.id,
      items: store.items
          .map(
            (item) => OrderItem(
              productId: item.product.id,
              productName: item.product.name,
              quantity: item.quantity,
              unitPrice: item.product.price,
            ),
          )
          .toList(),
      total: store.total,
      communityId: community.id,
      preOrderDate: store.pickupDate!,
      pickupLocation:
          '${community.businessName ?? community.name} • ${store.pickupSlot}',
      status: OrderStatus.confirmed,
    );

    CustomerMockData.orders.insert(0, order);

    store.clear();

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            size: 52,
            color: AppColors.primaryMaroon,
          ),
          title: const Text(
            'Pre-order Confirmed!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Your pre-order has been added successfully.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('View Pre-orders'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.customerHome,
      (route) => false,
      arguments: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = CustomerCartStore.instance;
    final community = CustomerMockData.currentCommunity;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Pre-order')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  community.businessName ?? community.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 18),
                ...store.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.product.name} × ${item.quantity}',
                            ),
                          ),
                          Text('₹${item.subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup Date',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store.pickupDate == null
                            ? '-'
                            : '${store.pickupDate!.day}/${store.pickupDate!.month}/${store.pickupDate!.year}',
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Pickup Time',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(store.pickupSlot ?? '-'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '₹${store.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Confirm Order',
                  isLoading: _submitting,
                  onPressed: store.isEmpty ? null : _confirmOrder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

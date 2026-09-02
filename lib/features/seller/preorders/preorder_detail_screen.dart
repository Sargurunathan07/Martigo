import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../seller_models.dart';

class PreOrderDetailScreen extends StatefulWidget {
  final SellerPreOrder order;

  const PreOrderDetailScreen({super.key, required this.order});

  @override
  State<PreOrderDetailScreen> createState() => _PreOrderDetailScreenState();
}

class _PreOrderDetailScreenState extends State<PreOrderDetailScreen> {
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _onMarkAsReady() {
    setState(() => widget.order.status = PreOrderStatus.ready);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Order marked as ready.')));
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.id}')),
      body: SafeArea(
        child: ResponsiveMobileContainer(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Row(label: 'Customer', value: order.customerLabel),
                      const SizedBox(height: 10),
                      _Row(
                        label: 'Pickup',
                        value:
                            '${_formatDate(order.pickupDate)} • ${order.pickupTime}',
                      ),
                      const Divider(height: 28),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.productName,
                                style: textTheme.bodyMedium,
                              ),
                              Text(
                                '×${item.quantity}',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 28),
                      _Row(
                        label: 'Total',
                        value: '₹${order.total.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Status', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: PreOrderStatus.values
                      .map(
                        (status) => Chip(
                          label: Text(status.label),
                          backgroundColor: status == order.status
                              ? AppColors.primaryMaroon
                              : null,
                          labelStyle: TextStyle(
                            color: status == order.status
                                ? AppColors.cream
                                : null,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                if (order.status != PreOrderStatus.ready &&
                    order.status != PreOrderStatus.completed)
                  AppButton(label: 'Mark as Ready', onPressed: _onMarkAsReady),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

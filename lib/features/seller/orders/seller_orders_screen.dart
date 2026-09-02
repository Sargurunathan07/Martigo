import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../preorders/preorder_detail_screen.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SellerPreOrder> _ordersForTab(int index) {
    final all = SellerDataStore.instance.preOrders;
    final today = DateTime.now();
    switch (index) {
      case 0:
        return all.where((o) => o.status == PreOrderStatus.received).toList();
      case 1:
        return all
            .where(
              (o) =>
                  o.pickupDate.year == today.year &&
                  o.pickupDate.month == today.month &&
                  o.pickupDate.day == today.day,
            )
            .toList();
      case 2:
        return all.where((o) => o.status == PreOrderStatus.completed).toList();
      default:
        return const [];
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pre-orders'),
            Tab(text: 'Today'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: ResponsiveMobileContainer(
        child: TabBarView(
          controller: _tabController,
          children: List.generate(3, (index) {
            final orders = _ordersForTab(index);
            if (orders.isEmpty) {
              return Center(
                child: Text(
                  'No orders here yet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              separatorBuilder: (context, i) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final order = orders[i];
                return AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PreOrderDetailScreen(order: order),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.id}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            order.status.label,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.primaryMaroon),
                          ),
                        ],
                      ),
                      Text(
                        '${order.customerLabel} · Pickup ${_formatDate(order.pickupDate)} ${order.pickupTime}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${order.items.length} item(s) · ₹${order.total.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

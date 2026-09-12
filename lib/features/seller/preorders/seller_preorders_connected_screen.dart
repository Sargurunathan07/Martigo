import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../demand/seller_demand_connected_screen.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class ConnectedSellerPreOrdersPage extends StatefulWidget {
  const ConnectedSellerPreOrdersPage({super.key});

  @override
  State<ConnectedSellerPreOrdersPage> createState() =>
      _ConnectedSellerPreOrdersPageState();
}

class _ConnectedSellerPreOrdersPageState
    extends State<ConnectedSellerPreOrdersPage> {
  final store = SellerDataStore.instance;

  String period = 'today';

  List<SellerPreOrder> get orders => store.ordersForPeriod(period);

  int get totalItems {
    return orders.fold(
      0,
      (total, order) =>
          total + order.items.fold(0, (sum, item) => sum + item.quantity),
    );
  }

  Future<void> _openOrder(SellerPreOrder order) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SellerOrderDetailsScreen(order: order)),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentOrders = orders;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Pre-orders',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              'View customer orders and plan demand.',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Today'),
                  selected: period == 'today',
                  onSelected: (_) {
                    setState(() {
                      period = 'today';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Tomorrow'),
                  selected: period == 'tomorrow',
                  onSelected: (_) {
                    setState(() {
                      period = 'tomorrow';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('This Week'),
                  selected: period == 'week',
                  onSelected: (_) {
                    setState(() {
                      period = 'week';
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: _Summary(
                      value: '${currentOrders.length}',
                      label: 'Pre-orders',
                    ),
                  ),
                  const SizedBox(height: 45, child: VerticalDivider()),
                  Expanded(
                    child: _Summary(value: '$totalItems', label: 'Total Items'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ConnectedSellerDemandScreen(period: period),
                  ),
                );
              },
              icon: const Icon(Icons.insights_outlined),
              label: const Text('View Demand Summary'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryMaroon,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Individual Orders',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (currentOrders.isEmpty)
              const AppCard(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No pre-orders for this period.')),
                ),
              )
            else
              ...currentOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () {
                      _openOrder(order);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Order #${order.id}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _StatusBadge(status: order.status),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(order.customerLabel),

                        const SizedBox(height: 5),

                        Text(
                          'Pickup: ${_formatDate(order.pickupDate)} • ${order.pickupTime}',
                          style: const TextStyle(color: Colors.black54),
                        ),

                        const Divider(height: 22),

                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Expanded(child: Text(item.productName)),
                                Text('×${item.quantity}'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '₹${order.total.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.primaryMaroon,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const Text(
                              'View Order',
                              style: TextStyle(
                                color: AppColors.primaryMaroon,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.primaryMaroon,
                            ),
                          ],
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class SellerOrderDetailsScreen extends StatefulWidget {
  final SellerPreOrder order;

  const SellerOrderDetailsScreen({super.key, required this.order});

  @override
  State<SellerOrderDetailsScreen> createState() =>
      _SellerOrderDetailsScreenState();
}

class _SellerOrderDetailsScreenState extends State<SellerOrderDetailsScreen> {
  final store = SellerDataStore.instance;

  void _changeStatus(PreOrderStatus status) {
    setState(() {
      store.updateOrderStatus(widget.order, status);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Order updated to ${status.label}')));
  }

  PreOrderStatus? get nextStatus {
    switch (widget.order.status) {
      case PreOrderStatus.received:
        return PreOrderStatus.preparing;

      case PreOrderStatus.preparing:
        return PreOrderStatus.ready;

      case PreOrderStatus.ready:
        return PreOrderStatus.completed;

      case PreOrderStatus.completed:
        return null;
    }
  }

  String get nextButtonLabel {
    switch (widget.order.status) {
      case PreOrderStatus.received:
        return 'Start Preparing';

      case PreOrderStatus.preparing:
        return 'Mark Ready for Pickup';

      case PreOrderStatus.ready:
        return 'Mark Completed';

      case PreOrderStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text('Order #${order.id}')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Order Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          _StatusBadge(status: order.status),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _StatusTimeline(current: order.status),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerLabel,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pickup Date: ${order.pickupDate.day}/${order.pickupDate.month}/${order.pickupDate.year}',
                      ),
                      Text('Pickup Time: ${order.pickupTime}'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Items',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                          Expanded(child: Text(item.productName)),
                          Text(
                            '×${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Total',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '₹${order.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                FilledButton(
                  onPressed: nextStatus == null
                      ? null
                      : () {
                          _changeStatus(nextStatus!);
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryMaroon,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: Text(nextButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final String value;
  final String label;

  const _Summary({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primaryMaroon,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PreOrderStatus status;

  const _StatusBadge({required this.status});

  Color get color {
    switch (status) {
      case PreOrderStatus.received:
        return Colors.blueGrey;

      case PreOrderStatus.preparing:
        return Colors.orange;

      case PreOrderStatus.ready:
        return AppColors.primaryMaroon;

      case PreOrderStatus.completed:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final PreOrderStatus current;

  const _StatusTimeline({required this.current});

  int get currentIndex {
    switch (current) {
      case PreOrderStatus.received:
        return 0;
      case PreOrderStatus.preparing:
        return 1;
      case PreOrderStatus.ready:
        return 2;
      case PreOrderStatus.completed:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    const steps = ['Received', 'Preparing', 'Ready', 'Completed'];

    return Column(
      children: List.generate(
        steps.length,
        (index) => Row(
          children: [
            Icon(
              index <= currentIndex
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: index <= currentIndex
                  ? AppColors.primaryMaroon
                  : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  steps[index],
                  style: TextStyle(
                    fontWeight: index == currentIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
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

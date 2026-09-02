import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../demand/demand_planning_screen.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';
import 'preorder_detail_screen.dart';

enum _PreOrderFilter { today, tomorrow, week }

/// Pre-orders screen. Prioritizes aggregated product demand over a
/// raw list of individual customer orders, per Martigo's core
/// question: "How much stock do I need?"
class SellerPreOrdersScreen extends StatefulWidget {
  const SellerPreOrdersScreen({super.key});

  @override
  State<SellerPreOrdersScreen> createState() => _SellerPreOrdersScreenState();
}

class _SellerPreOrdersScreenState extends State<SellerPreOrdersScreen> {
  _PreOrderFilter _filter = _PreOrderFilter.tomorrow;

  DemandSummary get _demand {
    final store = SellerDataStore.instance;
    if (_filter == _PreOrderFilter.week) return store.demandByPeriod['week']!;
    return store.demandByPeriod['tomorrow']!;
  }

  List<SellerPreOrder> get _orders {
    final store = SellerDataStore.instance;
    if (_filter == _PreOrderFilter.week) return store.preOrders;
    return store.preOrders
        .where((o) => o.status != PreOrderStatus.completed)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final demand = _demand;
    final orders = _orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Pre-orders')),
      body: ResponsiveMobileContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                _FilterChip(
                  label: 'Today',
                  selected: _filter == _PreOrderFilter.today,
                  onTap: () => setState(() => _filter = _PreOrderFilter.today),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Tomorrow',
                  selected: _filter == _PreOrderFilter.tomorrow,
                  onTap: () =>
                      setState(() => _filter = _PreOrderFilter.tomorrow),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'This Week',
                  selected: _filter == _PreOrderFilter.week,
                  onTap: () => setState(() => _filter = _PreOrderFilter.week),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primaryMaroon,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    demand.dateLabel,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.cream,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${orders.length} Pre-orders',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.cream.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...demand.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.productName,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.cream,
                            ),
                          ),
                          Text(
                            '×${entry.quantity}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.cream,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total items required',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.cream,
                        ),
                      ),
                      Text(
                        '${demand.totalItems}',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.cream,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cream,
                        foregroundColor: AppColors.primaryMaroon,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DemandPlanningScreen(),
                        ),
                      ),
                      child: const Text("Prepare Tomorrow's Stock"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Orders', style: textTheme.titleMedium),
            const SizedBox(height: 10),
            ...orders.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PreOrderDetailScreen(order: order),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${order.customerLabel} · ${order.items.length} item(s)',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        order.status.label,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryMaroon,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

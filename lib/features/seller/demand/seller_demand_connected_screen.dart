import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../seller_mock_data.dart';

class ConnectedSellerDemandScreen extends StatelessWidget {
  final String period;

  const ConnectedSellerDemandScreen({super.key, this.period = 'week'});

  String _periodTitle() {
    switch (period) {
      case 'today':
        return "Today's Demand";
      case 'tomorrow':
        return "Tomorrow's Demand";
      default:
        return 'This Week Demand';
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = SellerDataStore.instance;

    final orders = store.ordersForPeriod(period);

    final demand = store.aggregateDemand(orders);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(_periodTitle())),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.insights_outlined,
                        color: AppColors.primaryMaroon,
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${orders.length} pre-order(s)',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Combined quantity customers have requested.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Required Products',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                if (demand.isEmpty)
                  const AppCard(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('No active demand for this period.'),
                      ),
                    ),
                  )
                else
                  ...demand.entries.map((entry) {
                    final matchingProducts = store.products.where(
                      (product) =>
                          product.name.toLowerCase() == entry.key.toLowerCase(),
                    );

                    final currentStock = matchingProducts.isEmpty
                        ? 0
                        : matchingProducts.first.stock;

                    final shortage = entry.value - currentStock;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.softMaroon,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.inventory_2_outlined,
                                    color: AppColors.primaryMaroon,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  '×${entry.value}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: AppColors.primaryMaroon,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: _DemandInfo(
                                    label: 'Demand',
                                    value: '${entry.value}',
                                  ),
                                ),
                                Expanded(
                                  child: _DemandInfo(
                                    label: 'Current Stock',
                                    value: '$currentStock',
                                  ),
                                ),
                                Expanded(
                                  child: _DemandInfo(
                                    label: shortage > 0
                                        ? 'Need More'
                                        : 'Enough',
                                    value: shortage > 0 ? '$shortage' : '0',
                                    warning: shortage > 0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemandInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool warning;

  const _DemandInfo({
    required this.label,
    required this.value,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: warning ? AppColors.primaryMaroon : null,
          ),
        ),
      ],
    );
  }
}

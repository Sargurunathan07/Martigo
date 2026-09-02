import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../seller_mock_data.dart';

enum _DemandPeriod { tomorrow, week }

/// Demand Planning screen. Uses confirmed pre-orders as the current
/// demand source — no forecasting or AI is applied.
class DemandPlanningScreen extends StatefulWidget {
  const DemandPlanningScreen({super.key});

  @override
  State<DemandPlanningScreen> createState() => _DemandPlanningScreenState();
}

class _DemandPlanningScreenState extends State<DemandPlanningScreen> {
  _DemandPeriod _period = _DemandPeriod.tomorrow;

  @override
  Widget build(BuildContext context) {
    final store = SellerDataStore.instance;
    final demand = _period == _DemandPeriod.tomorrow
        ? store.demandByPeriod['tomorrow']!
        : store.demandByPeriod['week']!;
    final textTheme = Theme.of(context).textTheme;
    final topEntry = demand.entries.reduce(
      (a, b) => a.quantity > b.quantity ? a : b,
    );
    final maxQty = topEntry.quantity;

    return Scaffold(
      appBar: AppBar(title: const Text('Demand Planning')),
      body: ResponsiveMobileContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: _PeriodTile(
                    title: 'Tomorrow',
                    subtitle: '03 Sep',
                    selected: _period == _DemandPeriod.tomorrow,
                    onTap: () =>
                        setState(() => _period = _DemandPeriod.tomorrow),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PeriodTile(
                    title: 'This Week',
                    subtitle: '03–09 Sep',
                    selected: _period == _DemandPeriod.week,
                    onTap: () => setState(() => _period = _DemandPeriod.week),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Expected Demand', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            ...demand.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.productName, style: textTheme.bodyMedium),
                          Text(
                            '${entry.quantity} units',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: entry.quantity / maxQty,
                          minHeight: 8,
                          backgroundColor: AppColors.softMaroon,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primaryMaroon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softMaroon,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.primaryMaroon,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Based on current pre-orders, prepare ${topEntry.quantity} units of ${topEntry.productName} for ${_period == _DemandPeriod.tomorrow ? 'tomorrow' : 'this week'}.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryMaroon : AppColors.cream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryMaroon.withValues(
              alpha: selected ? 0 : 0.3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: selected ? AppColors.cream : AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: selected
                    ? AppColors.cream.withValues(alpha: 0.85)
                    : AppColors.text.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

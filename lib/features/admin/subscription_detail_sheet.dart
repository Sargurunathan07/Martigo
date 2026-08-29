import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import 'admin_mock_data.dart';
import 'admin_models.dart';

/// Shows subscription details in a modal bottom sheet, with an
/// optional inline plan-change selector. Mutates the [Subscription]
/// object directly (mock/local data only) and calls [onChanged] so
/// the parent list can refresh.
Future<void> showSubscriptionDetailSheet({
  required BuildContext context,
  required Subscription subscription,
  required VoidCallback onChanged,
  bool initiallyEditingPlan = false,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _SubscriptionDetailSheet(
      subscription: subscription,
      onChanged: onChanged,
      initiallyEditingPlan: initiallyEditingPlan,
    ),
  );
}

class _SubscriptionDetailSheet extends StatefulWidget {
  final Subscription subscription;
  final VoidCallback onChanged;
  final bool initiallyEditingPlan;

  const _SubscriptionDetailSheet({
    required this.subscription,
    required this.onChanged,
    required this.initiallyEditingPlan,
  });

  @override
  State<_SubscriptionDetailSheet> createState() =>
      _SubscriptionDetailSheetState();
}

class _SubscriptionDetailSheetState extends State<_SubscriptionDetailSheet> {
  late bool _editingPlan = widget.initiallyEditingPlan;
  late SubscriptionPlan _selectedPlan = widget.subscription.plan;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _applyPlanChange() {
    widget.subscription.plan = _selectedPlan;
    widget.onChanged();
    setState(() => _editingPlan = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Plan changed to ${_selectedPlan.name}.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscription = widget.subscription;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.text.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(subscription.businessName, style: textTheme.headlineMedium),
            Text(subscription.communityName, style: textTheme.bodyMedium),
            const SizedBox(height: 20),
            _DetailRow(label: 'Plan', value: subscription.plan.name),
            _DetailRow(
              label: 'Monthly Price',
              value: '₹${subscription.plan.monthlyPrice.toStringAsFixed(0)}',
            ),
            _DetailRow(
              label: 'Start Date',
              value: _formatDate(subscription.startDate),
            ),
            _DetailRow(
              label: 'Next Billing Date',
              value: _formatDate(subscription.nextBillingDate),
            ),
            _DetailRow(label: 'Status', value: subscription.status.label),
            _DetailRow(
              label: 'Payment Status',
              value: subscription.paymentStatus.label,
            ),
            const SizedBox(height: 16),
            if (!_editingPlan)
              AppButton(
                label: 'Change Plan',
                type: AppButtonType.secondary,
                onPressed: () => setState(() => _editingPlan = true),
              )
            else ...[
              Text('Select a plan', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              RadioGroup<SubscriptionPlan>(
                groupValue: _selectedPlan,
                onChanged: (value) {
                  if (value != null) setState(() => _selectedPlan = value);
                },
                child: Column(
                  children: AdminMockData.plans
                      .map(
                        (plan) => RadioListTile<SubscriptionPlan>(
                          contentPadding: EdgeInsets.zero,
                          value: plan,
                          title: Text(
                            '${plan.name} · ₹${plan.monthlyPrice.toStringAsFixed(0)}/mo',
                          ),
                          subtitle: Text(plan.features.join(' · ')),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              AppButton(label: 'Save Plan', onPressed: _applyPlanChange),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

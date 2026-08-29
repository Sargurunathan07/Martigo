import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../models/community.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

/// Shows the resolved community's details and lets the user confirm
/// joining it. Uses mock data only — no backend call is made.
class CommunityConfirmationScreen extends StatelessWidget {
  final Community community;

  const CommunityConfirmationScreen({super.key, required this.community});

  String get _typeLabel {
    switch (community.type) {
      case CommunityType.apartment:
        return 'Apartment';
      case CommunityType.college:
        return 'College';
    }
  }

  String get _businessTypeLabel {
    switch (community.businessType) {
      case BusinessType.supermarket:
        return 'Supermarket';
      case BusinessType.canteen:
        return 'Canteen';
      case null:
        return 'Not specified';
    }
  }

  IconData get _businessIcon {
    switch (community.businessType) {
      case BusinessType.supermarket:
        return Icons.storefront_outlined;
      case BusinessType.canteen:
        return Icons.restaurant_outlined;
      case null:
        return Icons.business_outlined;
    }
  }

  void _onConfirmPressed(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.customerHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Community')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Is this your community?', style: textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Please confirm the details below before joining.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.softMaroon,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            _businessIcon,
                            color: AppColors.primaryMaroon,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                community.name,
                                style: textTheme.titleMedium,
                              ),
                              Text(
                                _typeLabel,
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _DetailRow(label: 'Community Code', value: community.code),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Business',
                      value: community.businessName ?? 'Not specified',
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(label: 'Business Type', value: _businessTypeLabel),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Confirm & Join',
                onPressed: () => _onConfirmPressed(context),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Go Back',
                type: AppButtonType.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
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
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

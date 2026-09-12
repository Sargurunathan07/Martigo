import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../seller_mock_data.dart';

class SellerTrialBanner extends StatelessWidget {
  const SellerTrialBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final store = SellerDataStore.instance;

    final membership = store.membership;

    if (!membership.isTrialActive) {
      return const SizedBox.shrink();
    }

    final days = store.trialDaysRemaining;

    final end = membership.trialEndDate;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.softMaroon,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.primaryMaroon,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '14-Day Free Trial',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepMaroon,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$days ${days == 1 ? 'day' : 'days'} remaining',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                if (end != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Trial ends on '
                    '${_formatDate(end)}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],

                const SizedBox(height: 5),

                const Text(
                  '₹1,000/month after the free trial.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
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

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}

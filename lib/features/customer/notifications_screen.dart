import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'customer_mock_data.dart';

/// Notifications tab. Shows mock pre-order/deadline/pickup/availability
/// notifications.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(String message) {
    if (message.contains('confirmed')) return Icons.check_circle_outline;
    if (message.contains('deadline')) return Icons.timer_outlined;
    if (message.contains('ready')) return Icons.shopping_bag_outlined;
    if (message.contains('unavailable')) return Icons.error_outline;
    return Icons.notifications_none_outlined;
  }

  String _formatTimestamp(DateTime timestamp) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '${timestamp.day} ${months[timestamp.month - 1]}, $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final notifications = CustomerMockData.notifications;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'No notifications yet.',
                style: textTheme.bodyMedium,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? AppColors.cream
                        : AppColors.softMaroon,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _iconFor(notification.message),
                        color: AppColors.primaryMaroon,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.message,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(notification.timestamp),
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

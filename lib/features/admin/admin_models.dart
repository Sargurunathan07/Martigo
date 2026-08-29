import 'package:flutter/material.dart';

enum SubscriptionStatus { active, expired, paymentDue, cancelled }

enum PaymentStatus { paid, pending, overdue }

extension SubscriptionStatusX on SubscriptionStatus {
  String get label {
    switch (this) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.paymentDue:
        return 'Payment Due';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData get icon {
    switch (this) {
      case SubscriptionStatus.active:
        return Icons.check_circle_outline;
      case SubscriptionStatus.expired:
        return Icons.history_toggle_off;
      case SubscriptionStatus.paymentDue:
        return Icons.error_outline;
      case SubscriptionStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Color get color {
    switch (this) {
      case SubscriptionStatus.active:
        return Colors.green;
      case SubscriptionStatus.expired:
        return Colors.grey;
      case SubscriptionStatus.paymentDue:
        return Colors.orange;
      case SubscriptionStatus.cancelled:
        return Colors.redAccent;
    }
  }
}

extension PaymentStatusX on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.overdue:
        return 'Overdue';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentStatus.paid:
        return Icons.task_alt;
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.overdue:
        return Icons.warning_amber_outlined;
    }
  }

  Color get color {
    switch (this) {
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.overdue:
        return Colors.redAccent;
    }
  }
}

/// A mock/configurable subscription plan offered to sellers.
class SubscriptionPlan {
  final String id;
  final String name;
  final double monthlyPrice;
  final List<String> features;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.features,
  });
}

/// A seller/business's subscription to Martigo. Mutable so admin
/// actions (activate, renew, cancel, change plan) can update it
/// in-place against mock/local data.
class Subscription {
  final String id;
  final String businessName;
  final String communityName;
  SubscriptionPlan plan;
  final DateTime startDate;
  DateTime nextBillingDate;
  SubscriptionStatus status;
  PaymentStatus paymentStatus;

  Subscription({
    required this.id,
    required this.businessName,
    required this.communityName,
    required this.plan,
    required this.startDate,
    required this.nextBillingDate,
    required this.status,
    required this.paymentStatus,
  });
}

class RecentActivityItem {
  final String title;
  final String subtitle;
  final DateTime timestamp;

  const RecentActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });
}

class DemandTrendPoint {
  final String label;
  final int value;

  const DemandTrendPoint({required this.label, required this.value});
}

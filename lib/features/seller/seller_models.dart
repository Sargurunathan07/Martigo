enum PreOrderStatus { received, preparing, ready, completed }

extension PreOrderStatusX on PreOrderStatus {
  String get label {
    switch (this) {
      case PreOrderStatus.received:
        return 'Pre-order Received';
      case PreOrderStatus.preparing:
        return 'Preparing';
      case PreOrderStatus.ready:
        return 'Ready';
      case PreOrderStatus.completed:
        return 'Completed';
    }
  }
}

enum MembershipStatus { inactive, trial, active }

class Seller {
  String businessName;
  String ownerName;
  String mobile;
  String email;
  String storeAddress;

  Seller({
    required this.businessName,
    required this.ownerName,
    required this.mobile,
    required this.email,
    required this.storeAddress,
  });
}

class SellerMembership {
  MembershipStatus status;
  final String planName;
  final double monthlyPrice;

  DateTime? trialStartDate;
  DateTime? trialEndDate;
  DateTime? nextBillingDate;

  final String paymentMethod;

  SellerMembership({
    required this.status,
    required this.planName,
    required this.monthlyPrice,
    this.trialStartDate,
    this.trialEndDate,
    this.nextBillingDate,
    required this.paymentMethod,
  });

  bool isTrialActiveAt(DateTime now) {
    final end = trialEndDate;

    if (status != MembershipStatus.trial || end == null) {
      return false;
    }

    return now.isBefore(end);
  }

  bool isTrialExpiredAt(DateTime now) {
    final end = trialEndDate;

    if (status != MembershipStatus.trial || end == null) {
      return false;
    }

    return !now.isBefore(end);
  }

  int trialDaysRemainingAt(DateTime now) {
    if (!isTrialActiveAt(now)) {
      return 0;
    }

    final remaining = trialEndDate!.difference(now);

    return (remaining.inMilliseconds / Duration.millisecondsPerDay).ceil();
  }

  bool get isTrialActive {
    return isTrialActiveAt(DateTime.now());
  }

  bool get isTrialExpired {
    return isTrialExpiredAt(DateTime.now());
  }

  int get trialDaysRemaining {
    return trialDaysRemainingAt(DateTime.now());
  }
}

class SellerProduct {
  final String id;
  String name;
  String category;
  double price;
  String unit;
  int stock;
  bool preOrderEnabled;

  SellerProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.stock,
    this.preOrderEnabled = true,
  });
}

class SellerPreOrderItem {
  final String productName;
  final int quantity;

  const SellerPreOrderItem({required this.productName, required this.quantity});
}

class SellerPreOrder {
  final String id;
  final String customerLabel;
  final DateTime pickupDate;
  final String pickupTime;
  final List<SellerPreOrderItem> items;
  final double total;

  PreOrderStatus status;

  SellerPreOrder({
    required this.id,
    required this.customerLabel,
    required this.pickupDate,
    required this.pickupTime,
    required this.items,
    required this.total,
    this.status = PreOrderStatus.received,
  });
}

class DemandEntry {
  final String productName;
  final int quantity;

  const DemandEntry({required this.productName, required this.quantity});
}

class DemandSummary {
  final String dateLabel;
  final List<DemandEntry> entries;

  const DemandSummary({required this.dateLabel, required this.entries});

  int get totalItems {
    return entries.fold(0, (sum, entry) => sum + entry.quantity);
  }
}

class SellerNotification {
  final String id;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  const SellerNotification({
    required this.id,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

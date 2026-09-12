import 'package:flutter_test/flutter_test.dart';
import 'package:martigo/features/seller/seller_models.dart';

void main() {
  group('Martigo Seller 14-day free trial', () {
    final start = DateTime(2026, 9, 12, 10);

    final end = start.add(const Duration(days: 14));

    SellerMembership createTrial() {
      return SellerMembership(
        status: MembershipStatus.trial,
        planName: 'Martigo Seller Membership',
        monthlyPrice: 1000,
        trialStartDate: start,
        trialEndDate: end,
        paymentMethod: 'Razorpay',
      );
    }

    test('trial is active immediately after starting', () {
      final membership = createTrial();

      expect(membership.isTrialActiveAt(start), isTrue);

      expect(membership.trialDaysRemainingAt(start), 14);
    });

    test('trial remains active before exact expiry', () {
      final membership = createTrial();

      final oneSecondBefore = end.subtract(const Duration(seconds: 1));

      expect(membership.isTrialActiveAt(oneSecondBefore), isTrue);
    });

    test('trial expires at exact 14-day boundary', () {
      final membership = createTrial();

      expect(membership.isTrialActiveAt(end), isFalse);

      expect(membership.isTrialExpiredAt(end), isTrue);
    });

    test('trial is expired after 14 days', () {
      final membership = createTrial();

      expect(
        membership.isTrialExpiredAt(end.add(const Duration(minutes: 1))),
        isTrue,
      );
    });

    test('one remaining partial day displays as one day', () {
      final membership = createTrial();

      final almostFinished = end.subtract(const Duration(hours: 10));

      expect(membership.trialDaysRemainingAt(almostFinished), 1);
    });

    test('paid membership is not treated as trial', () {
      final membership = SellerMembership(
        status: MembershipStatus.active,
        planName: 'Martigo Seller Membership',
        monthlyPrice: 1000,
        paymentMethod: 'Razorpay',
      );

      expect(membership.isTrialActiveAt(start), isFalse);

      expect(membership.trialDaysRemainingAt(start), 0);
    });
  });
}

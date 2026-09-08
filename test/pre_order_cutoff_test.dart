import 'package:flutter_test/flutter_test.dart';
import 'package:martigo/core/utils/pre_order_cutoff.dart';

DateTime _istTimeAsUtc(
  int year,
  int month,
  int day,
  int hour,
  int minute, [
  int second = 0,
]) {
  return DateTime.utc(
    year,
    month,
    day,
    hour,
    minute,
    second,
  ).subtract(PreOrderCutoff.indiaUtcOffset);
}

void main() {
  group('Martigo pre-order cutoff', () {
    test('before 6:30 PM tomorrow is selectable', () {
      final now = _istTimeAsUtc(2026, 9, 8, 18, 29, 59);

      expect(PreOrderCutoff.isTomorrowCutoffClosed(nowUtc: now), isFalse);

      expect(
        PreOrderCutoff.isDateAvailable(DateTime(2026, 9, 9), nowUtc: now),
        isTrue,
      );
    });

    test('at exactly 6:30 PM tomorrow is disabled', () {
      final now = _istTimeAsUtc(2026, 9, 8, 18, 30);

      expect(PreOrderCutoff.isTomorrowCutoffClosed(nowUtc: now), isTrue);

      expect(
        PreOrderCutoff.isDateAvailable(DateTime(2026, 9, 9), nowUtc: now),
        isFalse,
      );
    });

    test('after 6:30 PM tomorrow is disabled', () {
      final now = _istTimeAsUtc(2026, 9, 8, 19, 15);

      expect(
        PreOrderCutoff.isDateAvailable(DateTime(2026, 9, 9), nowUtc: now),
        isFalse,
      );
    });

    test('today is always disabled', () {
      final now = _istTimeAsUtc(2026, 9, 8, 10, 0);

      expect(
        PreOrderCutoff.isDateAvailable(DateTime(2026, 9, 8), nowUtc: now),
        isFalse,
      );
    });

    test('past dates are always disabled', () {
      final now = _istTimeAsUtc(2026, 9, 8, 10, 0);

      expect(
        PreOrderCutoff.isDateAvailable(DateTime(2026, 9, 7), nowUtc: now),
        isFalse,
      );
    });

    test('day after tomorrow remains selectable after cutoff', () {
      final now = _istTimeAsUtc(2026, 9, 8, 20, 0);

      expect(
        PreOrderCutoff.isDateAvailable(DateTime(2026, 9, 10), nowUtc: now),
        isTrue,
      );
    });

    test('tomorrow selected before cutoff becomes invalid after cutoff', () {
      final before = _istTimeAsUtc(2026, 9, 8, 18, 20);

      final after = _istTimeAsUtc(2026, 9, 8, 18, 35);

      final selected = DateTime(2026, 9, 9);

      expect(PreOrderCutoff.isDateAvailable(selected, nowUtc: before), isTrue);

      expect(PreOrderCutoff.isDateAvailable(selected, nowUtc: after), isFalse);
    });

    test('cutoff automatically moves forward next day', () {
      final september9BeforeCutoff = _istTimeAsUtc(2026, 9, 9, 17, 0);

      expect(
        PreOrderCutoff.earliestAvailableDate(nowUtc: september9BeforeCutoff),
        DateTime(2026, 9, 10),
      );

      final september9AfterCutoff = _istTimeAsUtc(2026, 9, 9, 18, 30);

      expect(
        PreOrderCutoff.earliestAvailableDate(nowUtc: september9AfterCutoff),
        DateTime(2026, 9, 11),
      );
    });

    test('India date is calculated independently of device timezone', () {
      final utc = DateTime.utc(2026, 9, 8, 20, 0);

      final india = PreOrderCutoff.indiaNow(nowUtc: utc);

      expect(india.year, 2026);
      expect(india.month, 9);
      expect(india.day, 9);
      expect(india.hour, 1);
      expect(india.minute, 30);
    });

    test('calculation has no persisted cutoff state', () {
      final before = _istTimeAsUtc(2026, 9, 8, 12, 0);

      final nextDay = _istTimeAsUtc(2026, 9, 9, 12, 0);

      expect(
        PreOrderCutoff.earliestAvailableDate(nowUtc: before),
        DateTime(2026, 9, 9),
      );

      expect(
        PreOrderCutoff.earliestAvailableDate(nowUtc: nextDay),
        DateTime(2026, 9, 10),
      );
    });
  });
}

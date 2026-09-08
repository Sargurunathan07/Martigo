class PreOrderCutoff {
  PreOrderCutoff._();

  /// Asia/Kolkata / India Standard Time.
  ///
  /// India uses UTC+05:30 throughout the year and does not use DST.
  static const Duration indiaUtcOffset = Duration(hours: 5, minutes: 30);

  static const int cutoffHour = 18;
  static const int cutoffMinute = 30;

  /// Returns the current India wall-clock time.
  ///
  /// [nowUtc] exists mainly so the business rule can be unit-tested
  /// without depending on the actual clock.
  static DateTime indiaNow({DateTime? nowUtc}) {
    final utc = (nowUtc ?? DateTime.now().toUtc()).toUtc();
    final shifted = utc.add(indiaUtcOffset);

    return DateTime(
      shifted.year,
      shifted.month,
      shifted.day,
      shifted.hour,
      shifted.minute,
      shifted.second,
      shifted.millisecond,
      shifted.microsecond,
    );
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime indiaToday({DateTime? nowUtc}) {
    return dateOnly(indiaNow(nowUtc: nowUtc));
  }

  static DateTime tomorrow({DateTime? nowUtc}) {
    return indiaToday(nowUtc: nowUtc).add(const Duration(days: 1));
  }

  static DateTime dayAfterTomorrow({DateTime? nowUtc}) {
    return indiaToday(nowUtc: nowUtc).add(const Duration(days: 2));
  }

  /// At exactly 18:30:00 IST or later,
  /// tomorrow's pre-orders are closed.
  static bool isTomorrowCutoffClosed({DateTime? nowUtc}) {
    final now = indiaNow(nowUtc: nowUtc);

    if (now.hour > cutoffHour) {
      return true;
    }

    if (now.hour < cutoffHour) {
      return false;
    }

    return now.minute >= cutoffMinute;
  }

  /// Before 6:30 PM:
  /// earliest = tomorrow.
  ///
  /// At/after 6:30 PM:
  /// earliest = day after tomorrow.
  static DateTime earliestAvailableDate({DateTime? nowUtc}) {
    if (isTomorrowCutoffClosed(nowUtc: nowUtc)) {
      return dayAfterTomorrow(nowUtc: nowUtc);
    }

    return tomorrow(nowUtc: nowUtc);
  }

  static bool isDateAvailable(DateTime date, {DateTime? nowUtc}) {
    final selected = dateOnly(date);

    final earliest = earliestAvailableDate(nowUtc: nowUtc);

    return !selected.isBefore(earliest);
  }

  static bool isTomorrow(DateTime date, {DateTime? nowUtc}) {
    final selected = dateOnly(date);
    final tomorrowDate = tomorrow(nowUtc: nowUtc);

    return selected == tomorrowDate;
  }

  static String formatLongDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }
}
